require "elasticsearch/model"

class Dish < ApplicationRecord
  extend Ransack::Adapters::ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  belongs_to :category
  has_many :images
  has_many :booking_details
  has_many :ratings
  has_many :reviews

  after_save :index_reviews_in_elasticsearch

  settings do
    mappings dynamic: false do
      indexes :name, type: :text
      indexes :desciption, type: :text
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

  def self.search(query)
    self.search({
    query: {
      multi_match: {
        query: query,
        fields: ['name', 'desciption', 'review.content']
      }
    }
  })
  end

  private

  def index_reviews_in_elasticsearch
    dishes.find_each { |dish| dish.__elasticsearch__.index_document }
  end
end
