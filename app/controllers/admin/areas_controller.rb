class Admin::AreasController < ApplicationController

  #一覧（新規登録画面）
  def index
    @area = Area.new
    @areas = Area.all
  end

  # 新規登録画面
  def create
    @area = Area.new(area_params)
    if @area.save
      redirect_to admin_areas_path
    else
      @areas = Area.all
      render :index
    end
  end

  def edit
  end

  # ストロングステータス
  private

  def area_params
    params.require(:area).permit(:name)
  end

end
