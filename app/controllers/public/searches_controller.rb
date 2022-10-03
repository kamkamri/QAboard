class Public::SearchesController < ApplicationController
   # 部分一致
  def search
    @jobs = Job.where(is_deleted: false)
    @end_user = current_end_user
    @myarea = @end_user.area
    # 自分の拠点ツリーを絞る
    @search = Tree.where(area_id: @myarea).or( Tree.where(post_id: @myarea)).distinct
    @trees = @search.where(["title like? OR body like?", "%#{params[:keyword]}%", "%#{params[:keyword]}%"]).distinct
  end
end
