class Admin::StoresController < Admin::BaseController
  layout 'admin'

  def index
    @params = params[:q] || {}
    p @admin
    @q = @admin.stores.order('active desc').ransack(@params)
    @items = @q.result(distinct: true).page(params[:page])
  end

  def new
    @item = @admin.stores.build
  end
  def create
    @item = @admin.stores.build(current_record_params)
    if @item.save
      redirect_to admin_stores_path
    else
      render :new
    end
  end

  def update
    @item = Store.find(params[:id])
    if @item.update_attributes(current_record_params)
      redirect_to admin_stores_path
    else
      render :edit
    end
  end

  def edit
    @item = Store.find(params[:id])
  end

  private

  def current_record_params
    params.require(:store).permit!
  end 
end