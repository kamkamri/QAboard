class Admin::TreesController < ApplicationController

  # 掲示版ツリー一覧
  def index
    @trees = Tree.all
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

    @tree = Tree.new(tree_params)
    @tree.attachments = params[:tree][:attachments]
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
    redirect_to admin_tree_path(@tree.id)
  end

  # 質問詳細画面(レスポンス新規画面)
  def show
    @tree = Tree.find(params[:id])
    @responses = @tree.responses
    @res = Response.new
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
