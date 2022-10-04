class Admin::SearchesController < ApplicationController

  # 文字で検索し、treeのindexに表示
  def search
    @areas = Area.where(admin_area_flag: false).where(is_deleted: false)
    @jobs = Job.where(is_deleted: false)
    @admin_user = current_admin_user
    @myarea = @admin_user.areas.where(your_areas:{admin_user_id: @admin_user.id})
    # ツリーの業務がじぶんの担当業務
    @myjob = @admin_user.jobs.where(your_jobs:{admin_user_id: @admin_user.id})


    # 検索
    # ツリー検索
    @search_tree_ids = Tree.where(["title like? OR body like?", "%#{params[:keyword]}%", "%#{params[:keyword]}%"]).pluck(:id)
    # レス検索
    @search_res_ids = Response.where(["body like?", "%#{params[:keyword]}%"]).pluck(:tree_id)
    # admin
    #ツリーに合体
    @search_tree_ids = @search_tree_ids.push(@search_res_ids)
    #連想配列を削除[1,2,3[5,6]]みたいなの
    @search_tree_ids.flatten!
    # 重複削除
    @search_tree_ids = @search_tree_ids.uniq
    # nilを削除
    @search_tree_ids = @search_tree_ids.compact
    # 対象のツリー
    @trees = Tree.where(id: @search_tree_ids)


    @bord_name = "検索結果　#{ params[:keyword]}"
    render "admin/trees/index"
  end

end
