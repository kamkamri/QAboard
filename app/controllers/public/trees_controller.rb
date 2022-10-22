class Public::TreesController < ApplicationController

  # 掲示版ツリー一覧
  def index
    @jobs = Job.where(is_deleted: false)
    @end_user = current_end_user
    @myarea = @end_user.area
    @trees = Tree.where(area_id: @myarea).or( Tree.where(post_id: @myarea)).distinct.page(params[:page])

    # 検索
    case params[:genre]
    # admin受信した質問
    when "自拠点" then
      # ツリーの送信者が自分の担当拠点
      @trees = Tree.where(area_id: @myarea).or( Tree.where(post_id: @myarea)).distinct.page(params[:page])
      @bord_name = "自拠点の質問"

    # 自分が送信した質問
    when "送信" then
      @trees = Tree.where(end_user_id: @end_user).page(params[:page])
      @bord_name = "自分の投稿"
    else
      if params[:job]
        @trees = Tree.where(area_id: @myarea, job_id: params[:job]).or( Tree.where(post_id: @myarea, job_id: params[:job])).distinct.page(params[:page])
        @bord_name = Job.find(params[:job]).name + "の質問"
      end
    end
  end



  # 質問確認画面
  def new
    @admin_area = Area.where(admin_area_flag: true).where(is_deleted: false).limit(1)
    @tree = Tree.new
    @jobs = Job.where(is_deleted: false)
    @url = confirm_trees_path
  end



  # 質問確認画面
  def confirm
    @tree = current_end_user.trees.new(tree_params)
    @url = trees_path

    # saveでバリデーション使えないので、エラーを表示するために記載
    if tree_params[:title] == ""
      @tree.errors.add(:title, "を入力してください" )
    end
    if tree_params[:body] == ""
      @tree.errors.add(:body, "を入力してください" )
    end
    if tree_params[:job_id] == ""
      @tree.errors.add(:job_id, "を選択してください" )
    end

    # if tree_params[:post_id] == "" || tree_params[:job_id] == "" || tree_params[:title] == "" || tree_params[:body] == ""
    # 上でエラーを判定し、errorsに追加しているので、ここからエラーがあった場合は、new画面に戻すという処理を書いている
    if @tree.errors.any?
      @jobs = Job.where(is_deleted: false)
      @admin_area = Area.where(admin_area_flag: true).where(is_deleted: false).limit(1)
      @url = confirm_trees_path
      render :new
    end

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
    # @tree.post_id = Area.where(admin_area_flag: true).where(is_deleted: false).limit(1)
    # @tree.attachments = params[:tree][:attachments]
  end



  # 更新機能
  def create
    # paramで送られてきたデータを2個単位での保存に戻す。最初の状態[finename, base64でエンコードされたdata]
    # if tree_params[:attachments].present?
      files = params[:tree][:attachments].split(',').each_slice(2).to_a
    # end

    @tree = current_end_user.trees.new(tree_params)
    @tree.area_id = current_end_user.area_id
    @tree.post_id = Area.find_by(admin_area_flag: true, is_deleted: false).id
    # @tree.attachments = params[:tree][:attachments]


    # 修正するをクリック、または@treeがsaveされなかったときはnewに戻る
    # !@tree.save !が前にあるので、saveできなかったらになる
    if params[:back] || !@tree.save
      @jobs = Job.where(is_deleted: false)
      @url = confirm_trees_path
      render :new and return
    end

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
      @tree.create_admin_ad_notification_tree!(current_end_user, @tree.id, @tree.post_id, @tree.job_id)
      @tree.create_admin_end_notification_tree!(current_end_user, @tree.id, @tree.post_id)
    # end_userが投稿したツリー場合
    else
      @tree.create_end_ad_notification_tree!(current_end_user, @tree.id, @tree.area_id, @tree.job_id)
      @tree.create_end_end_notification_tree!(current_end_user, @tree.id, @tree.area_id)
    end
    redirect_to tree_path(@tree.id)
  end



  # 質問詳細画面(レスポンス新規画面)
  def show
    @tree = Tree.find(params[:id])
    @responses = @tree.responses.page(params[:page])
    @newres = Response.new
    # 部分テンプレートをしようのため、新規レス投稿のURLを入れておく
    # form_with内でしようのため、通常ではできなかった
    @create_newres_url = tree_responses_path(@tree)

    @jobs = Job.where(is_deleted: false)
    @end_user = current_end_user
    @myarea = @end_user.area

    # 通知をチェック済にする
    @notifications = current_end_user.passive_notifications.where(tree_id: @tree.id)
    @notifications.each do |notification|
      notification.update(checked: true)
    end

    # 検索
    case params[:genre]
    # admin受信した質問
    when "自拠点" then
      # ツリーの送信者が自分の担当拠点
      @trees = Tree.where(area_id: @myarea).or( Tree.where(post_id: @myarea)).distinct.page(params[:page])

    # 自分が送信した質問
    when "送信" then
      @trees = Tree.where(end_user_id: @end_user).page(params[:page])
    else
      if params[:job]
        @trees = Tree.where(area_id: @myarea, job_id: params[:job]).or( Tree.where(post_id: @myarea, job_id: params[:job])).distinct.page(params[:page])
      end
    end
  end



  # 質問編集
  def edit
    @tree = current_end_user.trees.find(params[:id])
    @jobs = Job.where(is_deleted: false)
    @url = tree_path(@tree.id)
  end

  # 質問更新
  def update
     @tree = current_end_user.trees.find(params[:id])

    # 添付済のファイル削除
    if params[:tree][:obj_ids]
      params[:tree][:obj_ids].each do |obj_id|
        @attachment = @tree.attachments.find(obj_id)
        # binding.pry
        @attachment.purge
      end
    end

    if @tree.update(tree_params)
      redirect_to tree_path(@tree.id)
    else
      @jobs = Job.where(is_deleted: false)
      @url = tree_path(@tree.id)
      render :edit
    end
  end

  # 削除機能
  def destroy
    #@tree = current_admin_user.trees.find(params[:id])
    @tree = Tree.find(params[:id])
    #byebug
    @tree.destroy
    redirect_to trees_path
  end

  private
  def tree_params
    params.require(:tree).permit(:post_id, :job_id, :title, :body, attachments: [])
  end

end
