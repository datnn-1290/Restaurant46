class Category < ApplicationRecord
  has_many :dishes
  after_save :index_dishes_in_elasticsearch

  scope :ordered_by_name, ->(keyword = :asc){order name: keyword}

  validates :name, presence: true, length: {maximum: 50}

  private

  def index_dishes_in_elasticsearch
    dishes.find_each { |dish| dish.__elasticsearch__.index_document }
  end
end
