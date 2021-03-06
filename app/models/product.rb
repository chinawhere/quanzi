class Product < ActiveRecord::Base
  belongs_to :admin
  has_many :product_images
  scope :active, -> { where(active: true).order(:position) }

  def up_serial(target_id)
    self.class.transaction do
      pre_item = self.class.find(target_id)
      index = pre_item.position
      self.class.where(admin_id: self.admin_id).where.not(id: self.id).where('`position` <= ? AND `position` >= ?', self.position, pre_item.position).update_all('`position` = `position` + 1')
      self.update(:position => index)
    end
  end

  def down_serial(target_id)
    self.class.transaction do
      next_item = self.class.find(target_id)
      index = next_item.position
      self.class.where(admin_id: self.admin_id).where.not(id: self.id).where('`position` >= ? AND `position` <= ?', self.position, next_item.position).update_all('`position` = `position` - 1')
      self.update(:position => index)
    end
  end

  def enable
    self.update(active: true)
  end

  def disable
    self.update(active: false)
  end

  def to_applet_show
    attrs = {
      id: self.id,
      title: self.title,
      min_count: self.min_count,
      desc: self.description,
      price: self.price,
      city_name: self.city_name,
      start_date: self.start_date,
      end_date: self.end_date,
      img_url: self.detailed_image
    }
    if self.type == 'Course'
      info_extend = CourseExtend.find_by_course_id(self.id)
      attrs[:address] = info_extend.try(:address)
      attrs[:teachers] = self.teachers.map{|item| item.to_course_list}
    end

    attrs[:exprie_product] = true unless self.active
    attrs[:product_images] = self.product_images.active.pluck(:mobile_image)
    attrs
  end

  def to_applet_cart_show
    attrs = {
      id: self.id,
      title: self.title,
      price: self.price,
      min_count: self.min_count,
      img_url: self.detailed_image
    }
    attrs
  end

  def to_applet_list
    {
      id: self.id,
      title: self.title,
      price: self.price,
      min_count: self.min_count,
      img_url: self.front_image
    }
  end

  def self.get_product_list_hash(product_ids)
    products =  Product.where(id: product_ids)
    item_hash = {}
    products.each do |product|
      item_hash[product.id] = product.to_applet_list
    end
    return item_hash
  end
end