class Recipe < ApplicationRecord
  enum :difficulty, { easy: 0, medium: 1, hard: 2 }

  validates :title, presence: true
  validates :cooking_time, numericality: { greater_than: 0 }, allow_nil: true
  validates :servings, numericality: { greater_than: 0 }, allow_nil: true

  scope :published,  -> { where(published: true) }
  scope :drafts,     -> { where(published: false) }
  scope :easy,       -> { where(difficulty: :easy) }
  scope :quick,      -> { where("cooking_time <= ?", 30) }
end
