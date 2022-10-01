class Admin::TreesController < ApplicationController

  # 掲示版ツリー一覧
  def index
    @trees = Tree.all
    @areas = Area.where(admin_area_flag: false).where(is_deleted: false)
    @jobs = Job.where(is_deleted: false)
    @admin_user = current_admin_user


    # 検索
    case params[:genre]
    # admin受信した質問
    when "担当" then
      # ツリーの送信者が自分の担当拠点
      @myarea = @admin_user.areas.where(your_areas:{admin_user_id: @admin_user.id})
      # ツリーの業務がじぶんの担当業務
      @myjob = @admin_user.jobs.where(your_jobs:{admin_user_id: @admin_user.id})
      @trees = Tree.where(area_id: @myarea, job_id: @myjob).or( Tree.where(post_id: @myarea, job_id: @myjob)).distinct
      @bord_name = "担当拠点の質問"

    #全ての質問
    when "全て" then
      @trees = Tree.all
      @bord_name = "全ての質問"

    # 自分が送信した質問
    when "送信" then
      @trees = Tree.where(admin_user_id: @admin_user)
      @bord_name = "自分の投稿"
    else
      if params[:area]
        @trees = Tree.where(area_id: params[:area]).or( Tree.where(post_id: params[:area])).distinct
        @bord_name = Area.find(params[:area]).name + "の質問"
      elsif params[:job]
        @trees = Tree.where(job_id: params[:job])
        @bord_name = Job.find(params[:job]).name + "の質問"
      else
      end
    end
  end

  # 質問入力画面
  def new
    @tree = Tree.new
    @jobs = Job.all
    @user_areas =  Area.where(admin_area_flag: false).where(is_deleted: false)
  end

  # 質問確認画面
  def confirm
    # 複数添付ファイル保存のために
    # ファイルを入れるための箱を準備
    if tree_params[:attachments].present?
      @files = []
      # ファイルに、ファイル名と、base64でエンコードされたデータを配列で保存
      # エンコード：データを他の形式へ変換
      # Base64とは：すべてのデータをアルファベット(a~z, A~z)と数字(0~9)、一部の記号(+,/)の64文字で表すエンコード方式です
      # https://wa3.i-3-i.info/word11338.html
      # [[] [] ]で保存

      tree_params[:attachments].each do |file|
        @files << [file.original_filename, Base64.encode64(File.open(file.tempfile.path).read).gsub(/\n/,'')]
      end

      #hidden_fieldは配列を送れないので、カンマ区切りのstringの羅列に変更
      @files = @files.join(',')
    end

    @tree = Tree.new(tree_params)
    # @tree.attachments = params[:tree][:attachments]
  end

  # 更新機能
  def create
    # paramで送られてきたデータを2個単位での保存に戻す。最初の状態[finename, base64でエンコードされたdata]
    files = params[:tree][:attachments].split(',').each_slice(2).to_a

    @tree = current_admin_user.trees.new(tree_params)
    @tree.area_id = current_admin_user.area_id
    # @tree.attachments = params[:tree][:attachments]

    # 修正するをクリック、または@treeがsaveされなかったときはnewに戻る
    # !@tree.save !が前にあるので、saveできなかったらになる
    if params[:back] || !@tree.save
      @jobs = Job.all
      @user_areas =  Area.where(admin_area_flag: false).where(is_deleted: false)
      render :new and return
    end

    # [
    #   [filename, data],
    #   [filename, data],
    #   [filename, data],
    # ]

    # 添付ファイル用
    files.each do |file|
      # fine_name を現在の時刻（数字の羅列VER）で仮作成
      file_name = Time.now.to_i
      # Rails.root}/tmp/#{file_nameファイルを　’wbモード追加書き込み読み込み’で開く
      File.open("#{Rails.root}/tmp/#{file_name}", 'wb') do |f|
        # 一つずつ開いて、dataを、書き込む
        f.write(Base64.decode64(file[1]))
      end

      # original_filename を開いて、保存
      @tree.attachments.attach(io: File.open("#{Rails.root}/tmp/#{file_name}"), filename: file[0])
      # 仮で作成したファイルを削除
      FileUtils.rm("#{Rails.root}/tmp/#{file_name}")
    end

    # コメント通知　モデルに定義
    # admin_userが投稿したツリー場合
    if @tree.end_user_id.nil?
      @tree.create_admin_ad_notification_tree!(current_admin_user, @tree.id, @tree.post_id, @tree.job_id)
      @tree.create_admin_end_notification_tree!(current_admin_user, @tree.id, @tree.post_id)
    # end_userが投稿したツリー場合
    else
      @tree.create_end_ad_notification_tree!(current_admin_user, @tree.id, @tree.area_id, @tree.job_id)
      @tree.create_end_end_notification_tree!(current_admin_user, @tree.id, @tree.area_id)
    end

    redirect_to admin_tree_path(@tree.id)
  end

  # 質問詳細画面(レスポンス新規画面)
  def show
    @tree = Tree.find(params[:id])
    @responses = @tree.responses
    @res = Response.new

    @areas = Area.where(admin_area_flag: false).where(is_deleted: false)
    @jobs = Job.where(is_deleted: false)
    @admin_user = current_admin_user

    # 通知をチェック済にする
    @notifications = current_admin_user.passive_notifications.where(tree_id: @tree.id)
    @notifications.each do |notification|
      notification.update(checked: true)
    end

    # 検索
    case params[:genre]
    # admin受信した質問
    when "担当" then
      # ツリーの送信者が自分の担当拠点
      @myarea = @admin_user.areas.where(your_areas:{admin_user_id: @admin_user.id})
      # ツリーの業務がじぶんの担当業務
      @myjob = @admin_user.jobs.where(your_jobs:{admin_user_id: @admin_user.id})
      @trees = Tree.where(area_id: @myarea, job_id: @myjob).or( Tree.where(post_id: @myarea, job_id: @myjob)).distinct
      @bord_name = "担当拠点の質問"

    #全ての質問
    when "全て" then
      @trees = Tree.all
      @bord_name = "全ての質問"

    # 自分が送信した質問
    when "送信" then
      @trees = Tree.where(admin_user_id: @admin_user)
      @bord_name = "自分の投稿"
    else
      if params[:area]
        @trees = Tree.where(area_id: params[:area]).or( Tree.where(post_id: params[:area])).distinct
        @bord_name = Area.find(params[:area]).name + "の質問"
      elsif params[:job]
        @trees = Tree.where(job_id: params[:job])
        @bord_name = Job.find(params[:job]).name + "の質問"
      else
      end
    end
  end


  # 質問編集
  def edit
    @tree = current_admin_user.trees.find(params[:id])
    @jobs = Job.all
    @user_areas =  Area.where(admin_area_flag: false).where(is_deleted: false)
  end

  # 質問更新
  def update
     @tree = current_admin_user.trees.find(params[:id])

    # 添付済のファイル削除
    if params[:tree][:obj_ids]
      params[:tree][:obj_ids].each do |obj_id|
        @attachment = @tree.attachments.find(obj_id)
        # binding.pry
        @attachment.purge
      end
    end

    if @tree.update(tree_params)
      redirect_to admin_tree_path(@tree.id)
    else
      @jobs = Job.all
      @user_areas =  Area.where(admin_area_flag: false).where(is_deleted: false)
      render :edit
    end
  end

  # 削除機能
  def destroy
    #@tree = current_admin_user.trees.find(params[:id])
    @tree = Tree.find(params[:id])
    #byebug
    @tree.destroy
    redirect_to admin_trees_path
  end


  private
  def tree_params
    params.require(:tree).permit(:post_id, :job_id, :title, :body, attachments: [])
  end

end
