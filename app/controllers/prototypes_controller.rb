class PrototypesController < ApplicationController
 
  before_action :set_prototype, except: [:index, :new, :create]
  before_action :authenticate_user!, except: [:index, :show]

  def index
    @prototypes = Prototype.includes(:user).order("created_at ASC")
  end
  
  def new
    @prototype = Prototype.new
  end
 
  def create
    @prototype = Prototype.new(prototypes_params)
    if @prototype.save
      redirect_to root_path      
    else
      render :new      
    end
  end

  def destroy
    if @prototype.destroy
       redirect_to root_path
    else
       render :edit
    end

  end

  
  def edit
    unless current_user == @prototype.user
      redirect_to root_path
    end
  end
  
  def update
    if @prototype.update(prototypes_params)
       redirect_to prototype_path(@prototype)
    else
      render :edit
    end
  end

  def show
    @comment = Comment.new
    @comments = @prototype.comments.includes(:user)
  end
  

  private

  def set_prototype
    @prototype = Prototype.find(params[:id])
  end

  def prototypes_params
    params.require(:prototype).permit(:title, :catch_copy, :concept, :image).merge(user_id: current_user.id)
  end


end
