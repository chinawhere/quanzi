class Admin::ShopsController < Admin::BaseController
  layout 'admin'

  def index
    @params = params[:q] || {}
    p @admin
    @q = @admin.shops.order('active desc').ransack(@params)
    @items = @q.result(distinct: true).page(params[:page])
  end

  def new
    @item = @admin.shops.build
  end
  def create
    @item = @admin.shops.build(current_record_params)
    if @item.save
      redirect_to admin_shops_path
    else
      render :new
    end
  end

  def update
    @item = Shop.find(params[:id])
    if @item.update_attributes(current_record_params)
      redirect_to admin_shops_path
    else
      render :edit
    end
  end

  def edit
    @item = Shop.find(params[:id])
  end

  def file_upload
    file_upload_to_qiniu('shop')
  end

  private

  def current_record_params
    params.require(:shop).permit!
  end 
end