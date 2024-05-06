class Lesson < ApplicationRecord
    belongs_to :course, counter_cache: true
    validates :title, :content, :course, presence: true

    include PublicActivity::Model
    tracked owner: Proc.new{ |controller, model| controller.current_user }

    has_rich_text :content

    extend FriendlyId
    friendly_id :title, use: :slugged
end
