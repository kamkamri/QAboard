class Admin::JobsController < ApplicationController

  # 業務マスタ一覧（新規登録）
  def index
    @job = Job.new
    @jobs = Job.all.page(params[:page])
  end

  # 業務新規登録
  def create
    @job = Job.new(job_params)
    if @job.save
      redirect_to admin_jobs_path
    else
      @jobs = Job.all.page(params[:page])
      render :index
    end
  end

  # 業務編集画面
  def edit
    @job = Job.find(params[:id])
  end

  # 業務更新機能
  def update
    @job = Job.find(params[:id])
    if @job.update(job_params)
      redirect_to admin_jobs_path
    else
      render :edit
    end
  end

  # ストロングパラメータ
  private

  def job_params
    params.require(:job).permit(:name, :color, :is_deleted)
  end
end
