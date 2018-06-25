require "elasticsearch/model"

class Dish < ApplicationRecord
  extend Ransack::Adapters::ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  belongs_to :category
  has_many :images
  accepts_nested_attributes_for :images, allow_destroy: true,
  reject_if: ->(attrs) {attrs["url"].blank?}
  has_many :booking_details
  has_many :ratings
  has_many :reviews

  scope :lastest, ->(number){order(created_at: :desc).limit(number).select(:id, :name, :price)}
  scope :most_popular_dishes,
  ->{where(id: BookingDetail.most_popular_dishes).limit(Settings.home.dish_popular_number)}
  scope :with_images, ->{includes :images}
  scope :newest, ->{order created_at: :desc}
  scope :oldest, ->{order created_at: :asc}
  scope :name_asc, ->{order name: :asc}
  scope :name_desc, ->{order name: :desc}
  scope :price_asc, ->{order price: :asc}
  scope :price_desc, ->{order price: :desc}
  scope :min_price, ->(min){where("price >= ?", min)}
  scope :max_price, ->(max){where("price <= ?", max)}

  validates :price, presence: true, inclusion: Settings.dish.price_range.range,
  numericality: {only_integer: true}

  settings index: {number_of_shards: 1} do
    mappings dynamic: "false" do
      indexes :name, analyzer: "english"
      indexes :description, analyzer: "english"
      indexes :price
      indexes "category.name", analyzer: "english"
      indexes "reviews.content", analyzer: "english"
    end
  end

  scope :lastest, ->(number){order(created_at: :desc).limit(number).select(:id, :name, :price)}

  def as_indexed_json(options = {})
    self.as_json(
      only: [:id, :name, :price, :description],
      include: {
        reviews: {
          only: [:content]
          },
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

  def self.find_all
   __elasticsearch__.search({
    query: {
      "match_all": {}
    }
    })
 end
end
