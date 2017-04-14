class ChoresController < ApplicationController
  before_filter :authenticate_parent!
  before_action :set_chore, only: [:show, :edit, :update, :destroy]

  # GET /chores
  # GET /chores.json
  def index
    @chores = Chore.all
  end

  # GET /chores/1
  # GET /chores/1.json
  def show
    @chore = Chore.find(params[:id])
  end

  # GET /chores/new
  def new
    @chore = Chore.new
  end

  # GET /chores/1/edit
  def edit
  end
  
    
  ####    STARTING TO FUCK SOME SHIT UP HERE  #####
  
  
  def complete
    completeChore = Chore.find(params[:id])
    completeChore.completed = true
    # flop pending_approval to false because it technically isn't pending approval. This also eases some searching done elsewhere.
    completeChore.pending_approval = false
    completeChore.save
 
    
    
    incrementChild = Child.find(params[:child])
    incrementChild.balance = incrementChild.balance + completeChore.coins
    incrementChild.save
    
       
    redirect_to :back, notice: 'Chore was successfully completed.'
    
  end
  
  def pending 
    pendingChore = Chore.find(params[:id])
    pendingChore.pending_approval = true
    pendingChore.save
    
    redirect_to :back, notice: 'Chore is now waiting for parent approval.'
  end
  
  # Conner having a moment of partial genius 
  def deny
    denyChore = Chore.find(params[:id])
    denyChore.pending_approval = false
    denyChore.save
    
    redirect_to :back, notice: 'Chore was successfully denied. Your child may try again.'
  end
  
  # associateChild adds child.id to chore.child_id and marks chore as pending because Conner is lazy...
  def associateChild
    choreFind = Chore.find(params[:id])
    childFind = Child.find(params[:child])
    choreFind.child_id = childFind.id
    
    choreFind.pending_approval=true
    choreFind.save
    
    redirect_to :back
    
  end
  
  # Conner is done having his moment of partial genius
  
  ####   resume normality ####

   # POST /chores
  # POST /chores.json
  def create
    @chore = Chore.new(chore_params)

    respond_to do |format|
      if @chore.save
        format.html { redirect_to @chore, notice: 'Chore was successfully created.' }
        format.json { render :show, status: :created, location: @chore }
      else
        format.html { render :new }
        format.json { render json: @chore.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /chores/1
  # PATCH/PUT /chores/1.json
  def update
    respond_to do |format|
      if @chore.update(chore_params)
        format.html { redirect_to @chore, notice: 'Chore was successfully updated.' }
        format.json { render :show, status: :ok, location: @chore }
      else
        format.html { render :edit }
        format.json { render json: @chore.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /chores/1
  # DELETE /chores/1.json
  def destroy
    @chore.destroy
    respond_to do |format|
      format.html { redirect_to chores_url, notice: 'Chore was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_chore
      @chore = Chore.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def chore_params
      params.fetch(:chore, {}).permit(:name, :description, :coins, :child_id, :due_date, :repeat_type, :repeat_data, :parent_id, :needs_approval)
    end
end
