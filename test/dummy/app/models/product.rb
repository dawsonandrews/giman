class Product < ApplicationRecord
  has_giman_attachments :images

  validates :name, :description, presence: true
end
