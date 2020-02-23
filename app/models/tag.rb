class Tag < ApplicationRecord
  belongs_to :admin
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
end