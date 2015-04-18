class ItemsController < ApplicationController
  before_action :set_item, only: [:show, :edit, :update, :destroy]
  before_action :set_aws_option, only: [:data_save, :index, :update_us_price]

  def set_aws_option
    Amazon::Ecs.options = {
      :associate_tag => Rails.application.secrets.associate_tag,
      :AWS_access_key_id => Rails.application.secrets.AWS_access_key_id,
      :AWS_secret_key => Rails.application.secrets.AWS_secret_key
    }
  end

  def insert_jp_data 
    Item.insert_jp_data
  end

  def update_us_price
    @xml = Item.update_us_price
  end

  # GET /items
  # GET /items.json
  def index
    @items = Item.all
    item = Item.new
    @xml = item.get_item_xml
  end

  # GET /items/1
  # GET /items/1.json
  def show
  end

  # GET /items/new
  def new
    @item = Item.new
  end

  # GET /items/1/edit
  def edit
  end

  # POST /items
  # POST /items.json
  def create
    @item = Item.new(item_params)

    respond_to do |format|
      if @item.save
        format.html { redirect_to @item, notice: 'Item was successfully created.' }
        format.json { render :show, status: :created, location: @item }
      else
        format.html { render :new }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /items/1
  # PATCH/PUT /items/1.json
  def update
    respond_to do |format|
      if @item.update(item_params)
        format.html { redirect_to @item, notice: 'Item was successfully updated.' }
        format.json { render :show, status: :ok, location: @item }
      else
        format.html { render :edit }
        format.json { render json: @item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /items/1
  # DELETE /items/1.json
  def destroy
    @item.destroy
    respond_to do |format|
      format.html { redirect_to items_url, notice: 'Item was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_item
      @item = Item.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def item_params
      params.require(:item).permit(:name, :asin, :search_index, :price_jp, :price_us, :rank_amazon, :check_date)
    end
end
