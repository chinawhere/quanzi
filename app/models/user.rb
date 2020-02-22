class User < ApplicationRecord
  has_many  :orders

  def get_applet_sex
    self.sex ? "#{self.sex}" : '0'
  end

  def to_applet_list
    attrs = {}
    %w(name avatar address_province address_city address_district).each do |info|
      attrs[info.to_sym] =  self.send(info)
    end
    attrs[:sex] = self.get_applet_sex
    attrs
  end

  def to_applet_crm_list
    attrs = {}
    %w(name avatar).each do |info|
      attrs[info.to_sym] =  self.send(info)
    end
    attrs[:sex] = self.get_applet_sex
    attrs[:orders_count] = 0
    attrs
  end

  def self.find_or_create_source_user(mobile, source, user_info)
    user = User.where(phone_number: mobile).first
    return user if user.present?
    user_attr = {phone_number: mobile, source: source }
    [:wx_union_id, :wx_open_id].each {|v| user_attr[v] = user_info[v] if user_info[v].present?}
    User.create!(user_attr)
  end

  def self.find_or_create_wx_user(wx_open_id, source = 'weixin_applet')
    user = User.find_by_wx_open_id(wx_open_id)
    return user if user.present?
    user_attr = {wx_open_id: wx_open_id, source: source}
    User.create!(user_attr)
  end

end