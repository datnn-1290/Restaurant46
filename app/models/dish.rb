require "elasticsearch/model"

class Dish < ApplicationRecord
  extend Ransack::Adapters::ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  belongs_to :category
  has_many :images
  accepts_nested_attributes_for :images,
    reject_if: ->(attrs) {attrs["url"].blank?}
  has_many :booking_details
  has_many :ratings
  has_many :reviews

  settings index: {number_of_shards: 1} do
    mappings dynamic: "false" do
      indexes :name, analyzer: "english"
      indexes :description, analyzer: "english"
      indexes :price
      indexes "category.name", analyzer: "english"
    end
  end

  scope :lastest, ->(number){order(created_at: :desc).limit(number).select(:id, :name, :price)}

  def self.most_popular_dishes
    dish_ids = "SELECT `booking_details`.`dish_id`
                FROM booking_details
                GROUP BY `booking_details`.`dish_id`
                ORDER BY sum(booking_details.quantity) DESC"
    Dish.where(id: dish_ids).select(:id, :name, :price).limit(Settings.home.dish_popular_number)
  end

  def as_indexed_json(options = {})
    self.as_json(
      only: [:id, :name, :price, :description],
      include: {
        category: {
          only: [:name]
        }
      }
    )
  end

  def self.search_elastic(query)
    __elasticsearch__.search({
    query: {
      multi_match: {
        query: query,
        type: "phrase_prefix",
        fields: ['name^10', 'price', 'description', 'reviews.content', 'category.name']
      }
    }
  })
  end
end
Dish.import
