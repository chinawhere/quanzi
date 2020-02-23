class Store < ApplicationRecord
  belongs_to :admin
  scope :active, -> { where(active: true).order(:position) }
end
