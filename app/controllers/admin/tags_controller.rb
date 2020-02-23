class Admin::TagsController < Admin::BaseController
  layout 'admin'

  def index
    @params = params[:q] || {}
    p @admin
    @q = @admin.tags.ransack(@params)
    @items = @q.result(distinct: true).page(params[:page])
  end

  def new
    @item = @admin.tags.build
  end
  def create
    @item = @admin.tags.build(current_record_params)
    if @item.save
      redirect_to admin_tags_path
    else
      render :new
    end
  end

  def update
    @item = Tag.find(params[:id])
    if @item.update_attributes(current_record_params)
      redirect_to admin_tags_path
    else
      render :edit
    end
  end

  def edit
    @item = Tag.find(params[:id])
  end

  def destroy
    @item = Tag.find(params[:id])
    redirect_to admin_tags_path if @item.destroy
  end

  private

  def current_record_params
    params.require(:tag).permit!
  end 
end