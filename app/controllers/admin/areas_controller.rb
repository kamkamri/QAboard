class Admin::AreasController < ApplicationController

  #一覧（新規登録画面）
  def index
    @area = Area.new
    @areas = Area.where(admin_area_flag: false).page(params[:page])
  end

  # 新規登録画面
  def create
    @area = Area.new(area_params)
    if @area.save
      redirect_to admin_areas_path
    else
      @areas = Area.where(admin_area_flag: false).page(params[:page])
      render :index
    end
  end

  # 編集画面
  def edit
    @area = Area.find(params[:id])
  end

  # 管理者更新
  def update
    @area = Area.find(params[:id])
    if @area.update(area_params)
      redirect_to admin_areas_path
    else
      render :edit
    end
  end

  # ストロングステータス
  private

  def area_params
    params.require(:area).permit(:name, :admin_area_flag, :is_deleted)
  end

end
