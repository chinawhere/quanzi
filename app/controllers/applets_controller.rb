class AppletsController < ApplicationController
  protect_from_forgery

  def index
    request_info = {}
    render json: request_info
  end

  def shops_list
    p params
    if params[:admin_id]
      item = Admin.find(params[:admin_id])
    elsif params[:user_id]
      item = User.find(params[:user_id])
    end
    render json: {shops: item.shops.active.map{|item| item.to_applet_list}}
  end

  def cart_show
    product = Product.find(params[:id])
    request_info = {}
    request_info[:info] = product.to_applet_cart_show
    request_info[:cart_info] = product.to_applet_list
    render json: request_info
  end

  def product_show
    product = Product.find(params[:id])
    request_info = {}
    request_info[:info] = product.to_applet_show
    request_info[:cart_info] = product.to_applet_list
    p request_info
    render json: request_info
  end

  def login
    request = Wx::MiniApplet.get_open_id_by(params[:code])
    #request['session_key']用于 wx.checkSession， 检查登陆是否已过期
    Rails.logger.info "----#{Time.now.strftime("%F %T")}-----update_product_logger_params: #{request.inspect}"
    user_info = {}
    if request['openid'].present?
      user = User.find_or_create_wx_user(request['openid'])
      user_info.merge!(customerPhoneNumber: user.phone_number) if user.present? and user.phone_number.present?
      user_info.merge!(wx_open_id: request['openid'])
    end
    render json: user_info
  end

  def user_info
    p params
    user = User.find_or_create_wx_user(params[:wx_open_id])
    
    render json: {userInfo: user.to_applet_list}
  end

  def crm_info
    p params
    user = User.find_or_create_wx_user(params[:wx_open_id])
    
    render json: {userInfo: user.to_applet_crm_list}

  end

  def save_user_info
    user = User.find_or_create_wx_user(params[:wx_open_id])
    user.update(user_params)
    render json: {userInfo: user.to_applet_list}
  end

  def cart
    products = Product.get_product_list_hash(params[:product_ids].split(','))
    render json: {productInfos: products}
  end

  def save_address
    user = User.find_or_create_wx_user(params[:wx_open_id])
    params[:user_id] = user.try(:id)
    address_attr = address_params
  
    Address.for_user(params[:user_id]).update_all(is_default: false) if address_attr[:is_default] == '1' and params[:user_id].present?

    if params[:address_id].present?
      address = Address.find(params[:address_id]) rescue nil
      if address.present?
        address.update_attributes(address_attr)
      else
        address = Address.create(address_attr)
      end
    else
      address = Address.create(address_attr)
    end
    render json: {current_address: address.to_cart_info}
  end


  def load_address_list(current_address = nil)
    user = User.find_or_create_wx_user(params[:wx_open_id])
    user_addresses = Address.for_user(user.id).order('id desc')
    address_hash = user_addresses.select{|item| item.gaode_lng.present?}.map{|item| item.to_cart_info}
    render json: {addresses: address_hash, current_address: current_address || address_hash[0]}
  end

  def load_address_info
    address = Address.find(params[:id]) rescue nil
    render json: {address: address.to_cart_info}
  end

  def delete_user_address
    address = Address.find(params[:id]).destroy rescue nil
    load_address_list
  end

  def orders
    p params
    user = User.find_or_create_wx_user(params[:wx_open_id])
    if user.present?
      order_product_ids = []
      order_infos = []
      products = Product.get_product_list_hash(order_product_ids.uniq)
      attr_info = {orders: order_infos, products: products}
      attr_info[:emptyPageNotice] = '暂无订单' if order_infos.blank?
      render json: attr_info
    else
      render json: {orders: [], products: {}, emptyPageNotice: '暂无订单'}
    end
  end

  def cancel_order
    order = Order.find(params[:order_id]) rescue nil
    if order
      order, success, errors = Order.create_or_update_order({order: order, params: params, methods: %w(cancel_order), redis_expire_name: "order-#{order.id}"})
      render json: {success: success, errors: errors.values[0]}
    else
      render json: {success: false, errors: '订单信息错误'}
    end
  end

  def address_params
    params.permit(
      :recipient_name,
      :recipient_phone_number,
      :location_title,
      :location_address,
      :location_details,
      :address_province,
      :address_city,
      :address_district,
      :gaode_lng,
      :gaode_lat,
      :user_id,
      :sex,
      :is_default
    )
  end

  def user_params
    params.permit(
      :name,
      :avatar,
      :phone_number,
      :address_province,
      :address_city,
      :address_district,
      :sex
    )
  end

  def create_order
    p params
    order_info = params[:orderInfo]
    user = User.find_or_create_wx_user(params[:wx_open_id])


    order_info[:wx_open_id] = user.wx_open_id
    order_attr = base_order_params

    p order_attr
    order_attr.merge!(applet_order_base_info(order_info))

    if order_info[:address_id].present?
      order_attr.merge!(Address.find(order_info[:address_id]).to_applet_order_info)
    end

    order_attr[:user_id] = user.id
    order_attr, purchased_items = get_purchased_items(order_attr, params[:cartProducts])

    option = {order_attr: order_attr.permit!, params: order_info}
    option[:purchased_items] = purchased_items
    option[:user] = user if user.present?

    option[:methods] = %w(check_user create_order  save_with_new_external_id create_tenpay_order_payment_record)
    option[:redis_expire_name] = "applet-#{order_info[:wx_open_id]}"

    p option
    @order, success, errors = Order.create_or_update_order(option)
    if success
      render json: {success: true, order_id: @order.id}
    else
      render json: {success: false, errors: errors.values[0]}
    end
  end

  def applet_order_base_info(order_info)
    attrs = {
      status: "unpaid",
      wx_open_id: order_info[:wx_open_id],
      purchase_source: "小家订购"
    }
    attrs
  end

  def get_purchased_items(order_attr, cart_products)
    return [order_attr, []] if cart_products.blank?
    items = []
    products_ids = []


    cart_products.each{|item| products_ids.push(item[:id])} 
    product_hash = Product.where(id: products_ids).pluck(:id, :price).to_h

    cart_products.each do |info|
      next if info.blank?
      product_id = info[:id].to_i
      items << {product_id: product_id, quantity: info[:quantity].to_i, price: product_hash[product_id] || 0}
    end
    [order_attr, items]
  end

  def base_order_params
    params.require(:orderInfo).permit(
      :customer_name,
      :customer_phone_number,
      :recipient_name,
      :recipient_phone_number,      
      :user_id
    )
  end
end
