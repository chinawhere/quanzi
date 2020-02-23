class Admin::TagsController < Admin::BaseController
  layout 'admin'

  def index
    @params = params[:q] || {}
    @q = @admin.tags.order('active desc, position asc').ransack(@params)
    @items = @q.result(distinct: true).page(params[:page])
  end

  def new
    @item = @admin.tags.build
    @current_products = @item.products
  end
  def create
    @item = @admin.tags.build(current_record_params)
    @current_products = @item.products
    if @item.save
      redirect_to admin_tags_path
    else
      render :new
    end
  end

  def update
    @item = Tag.find(params[:id])
    @current_products = @item.products
    p current_record_params
    if @item.update_attributes(current_record_params)
      redirect_to admin_tags_path
    else
      render :edit
    end
  end

  def edit
    @item = Tag.find(params[:id])
    @current_products = @item.products
  end

  def destroy
    @item = Tag.find(params[:id])
    redirect_to admin_tags_path if @item.destroy
  end

  def up_serial
    item = Tag.where(id: params[:id]).first
    if item.up_serial params[:target_id]
      render js: "alert('操作成功');"
    else
      render js: "alert('操作失败');"
    end
  end

  def down_serial
    item = Tag.where(id: params[:id]).first
    if item.down_serial params[:target_id]
      render js: "alert('操作成功');"
    else
      render js: "alert('操作失败');"
    end
  end

  def enable
    item = Tag.find(params[:id])
    if item.enable
      redirect_to admin_products_path, alert: '成功'
    else
      redirect_to admin_products_path, alert: '失败'
    end
  end

  def disable
    item = Tag.find(params[:id])
    if item.disable
      redirect_to admin_products_path, alert: '成功'
    else
      redirect_to admin_products_path, alert: '失败'
    end
  end

  private

  def current_record_params
    params.require(:tag).permit!
  end 
end