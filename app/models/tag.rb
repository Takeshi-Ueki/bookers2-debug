class Tag < ApplicationRecord
  has_many :book_tags, dependent: :destroy, foreign_key: 'tag_id'
  # タグは複数のbookを持つ、それはbook_tagsを通じて参照する
  has_many :books, through: :book_tags

  validates :name, uniqueness: true, presence: true
end
