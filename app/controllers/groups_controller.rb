class GroupsController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update]
  
  def index
    @groups = Group.all
    @book = Book.new
  end

  def show
    @group = Group.find(params[:id])
    @book = Book.new
  end

  def new
    @group = Group.new
  end
  
  def create
    @group = Group.new(group_params)
    @group.owner_id = current_user.id
    # グループのメンバーに自分を含める記述
    @group.users << current_user
    if @group.save
      redirect_to groups_path
    else
      render :new
    end
  end

  def edit
  end
  
  def update
    if @group.update(group_params)
      redirect_to groups_path
    else
      render :edit
    end
  end
  
  def destroy
    @group = Group.find(params[:id])
    # グループ内のメンバーを削除する（グループ自体ではない）
    @group.users.delete(current_user)
    redirect_to groups_path
  end
  
  private
    
    def group_params
      params.require(:group).permit(:name, :introduction, :group_image)
    end
    
    def ensure_correct_user
      @group = Group.find(params[:id])
      redirect_to groups_path unless @group.owner_id == current_user.id
    end
end
