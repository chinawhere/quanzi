class ProductTagAssignment < ActiveRecord::Base
  belongs_to :tag
  belongs_to :product
  # validates_uniqueness_of :tag_id, scope: :product_id
  # validates_presence_of :tag_id, :product_id


  def set_top
    self.class.transaction do
      self.class.where(tag_id: self.tag_id).where.not(id: self.id).update_all('`position` = `position` + 1')
      self.update(:position => 0)
    end
  end

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

end