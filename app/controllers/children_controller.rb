class ChildrenController < ApplicationController
  
  before_filter :authenticate_parent!
  before_action :set_child, only: [:show, :edit, :update, :destroy]
  

  # GET /children
  # GET /children.json
  def index
    @children = Child.all
  end

  # GET /children/1
  # GET /children/1.json
  def show

  end

  # GET /children/new
  def new
    @child = Child.new
  end

  # GET /children/1/edit
  def edit
  end
  

  
  
  # POST /children
  # POST /children.json
  def create
    @child = Child.new(child_params)

    respond_to do |format|
      if @child.save
         if @child.reload.avatar.file.nil?
          @child.set_default_avatar
         end
        format.html { redirect_to "/children", notice: 'Child was successfully created.' }
        format.json { render :show, status: :created, location: @child }
      else
        format.html { render :new }
        format.json { render json: @child.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /children/1
  # PATCH/PUT /children/1.json
  def update
    respond_to do |format|
      if @child.update(child_params)
        if @child.reload.avatar.file.nil?
          @child.set_default_avatar
        end
        format.html { redirect_to "/children", notice: 'Child was successfully updated.' }
        format.json { render :show, status: :ok, location: @child }
      else
        format.html { render :edit }
        format.json { render json: @child.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /children/1
  # DELETE /children/1.json
  def destroy
    @child.destroy
    @chores = Chore.where(child_id: @child.id)
    @chores.each do |chore|
      Chore.destroy(chore.id)
    end
    
    @rewards = Reward.where(child_id: @child.id)
    @rewards.each do |reward|
      Reward.destroy(reward.id)
    end
    
    @notifications = Notification.where(user_type: :child, user_id: @child.id)
    @notifications.each do |notif|
      Notification.destroy(notif.id)
    end
    respond_to do |format|
      format.html { redirect_to children_url, notice: 'Child was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_child
      @child = Child.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def child_params
      params.fetch(:child, {}).permit(:name, :balance, :parent_id, :avatar, :remove_avatar)
      
          # params.fetch(:user, {}).permit(:first_name, :last_name, :email, :phone, 
    end
end