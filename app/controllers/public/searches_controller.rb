class Public::SearchesController < ApplicationController
   # 部分一致
  def search
    @jobs = Job.where(is_deleted: false)
    @end_user = current_end_user
    @myarea = @end_user.area
    # 自分の拠点ツリーを絞る
    @search = Tree.where(area_id: @myarea).or( Tree.where(post_id: @myarea)).distinct
    # ツリー検索
    @search_tree_ids = @search.where(["title like? OR body like?", "%#{params[:keyword]}%", "%#{params[:keyword]}%"]).pluck(:id)
    # レスポンス検索
    @search_res_ids = Response.where(["body like?", "%#{params[:keyword]}%"]).where(tree_id: @search.ids).pluck(:tree_id)
    # @search_res_ids = @search.includes(:responses).where(["body like?", "%#{params[:keyword]}%"]).pluck(:tree_id)
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
    render "public/trees/index"
  end
end
