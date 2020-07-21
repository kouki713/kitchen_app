class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :recipe

  # バリテーション
  validates :comment, presence: true, length: { maximum: 200 }
end
