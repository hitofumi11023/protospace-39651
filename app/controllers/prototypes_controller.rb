class PrototypesController < ApplicationController
  before_action :set_prototype, only: [:edit, :show]
  before_action :move_to_index, except: [:index, :show, :new, :create]
  
  def index
    @prototypes = Prototype.includes(:user)
  end

  def new
    if user_signed_in?
      @prototype = Prototype.new
    else
      redirect_to new_user_session_path
    end
  end

  def create
    @prototype = Prototype.new(prototype_params)
    if @prototype.save
      redirect_to '/'
    else
      render "prototypes/new"
    end
  end

  def show
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
  end

  def edit
  end

  def update
    prototype = Prototype.find(params[:id])
    if prototype.update(prototype_params)
      redirect_to prototype_path(prototype.id)
    else 
      render "prototypes/edit"
    end
  end

  def destroy
    prototype = Prototype.find(params[:id])
    prototype.destroy
    redirect_to root_path
  end

  private
  def prototype_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end
  
  def set_prototype
    @prototype = Prototype.find(params[:id])
  end
  
  def move_to_index
    @prototype = Prototype.find(params[:id])
    unless current_user == @prototype.user
      redirect_to new_user_session_path
    end
  end

end