class Shop < ApplicationRecord
  belongs_to :admin
  scope :active, -> { where(active: true).order(:active) }

  def to_applet_list
    {
      id: self.id,
      title: self.shop_name,
      desc: self.description,
      img_url: self.mobile_image
    }
  end

  def to_applet_show
    {
      id: self.id,
      title: self.shop_name,
      phone_number: self.phone_number,
      desc: self.description,
      min_amount: self.min_amount,
      img_url: self.mobile_image
    }
  end
end
