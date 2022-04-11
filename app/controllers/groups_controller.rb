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
    @group = current_user.owned_groups.new(group_params)
    # group_userにも値が必要なため残す
    @group.owner_id = current_user.id
    # グループのメンバーに自分を含める記述
    @group.users << current_user
    if @group.save
      redirect_to group_path(@group)
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
  
  def join
    @group = Group.find(params[:group_id])
    @group.users << current_user
    redirect_to @group
  end
  
  def group_destroy
    @group = Group.find(params[:group_id])
    if @group.destroy
      redirect_to groups_path
    end
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
