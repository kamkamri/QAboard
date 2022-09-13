class Admin::TreesController < ApplicationController
  
  # 掲示版ツリー一覧
  def index
    @trees = Tree.all
  end

  def new
  end

  def confirm
  end

  def show
  end

  def edit
  end
end
