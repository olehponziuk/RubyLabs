class Photo < ApplicationRecord
  belongs_to :recipe, optional: true
  validates :url, presence: true
end
