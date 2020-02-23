
class Admin::ProductsController < Admin::BaseController
  layout 'admin'

  def index
    @params = params[:q] || {}
    @q = @admin.products.order('active desc, position asc').ransack(@params)
    @items = @q.result(distinct: true).page(params[:page])
  end

  def new
    @item = @admin.products.build
  end
  def create
    @item = @admin.products.build(current_record_params)
    if @item.save
      redirect_to admin_products_path
    else
      render :new
    end
  end

  def update
    @item = Product.find(params[:id])
    if @item.update_attributes(current_record_params)
      redirect_to admin_products_path
    else
      render :edit
    end
  end

  def edit
    @item = Product.find(params[:id])
  end


  def file_upload
    file_upload_to_qiniu('product')
  end

  def up_serial
    item = Product.where(id: params[:id]).first
    if item.up_serial params[:target_id]
      render js: "alert('操作成功');"
    else
      render js: "alert('操作失败');"
    end
  end

  def down_serial
    item = Product.where(id: params[:id]).first
    if item.down_serial params[:target_id]
      render js: "alert('操作成功');"
    else
      render js: "alert('操作失败');"
    end
  end

  def enable
    item = Product.find(params[:id])
    if item.enable
      redirect_to admin_products_path, alert: '成功'
    else
      redirect_to admin_products_path, alert: '失败'
    end
  end

  def disable
    item = Product.find(params[:id])
    if item.disable
      redirect_to admin_products_path, alert: '成功'
    else
      redirect_to admin_products_path, alert: '失败'
    end
  end

  private

  def current_record_params
    params.require(:product).permit!
  end 
end