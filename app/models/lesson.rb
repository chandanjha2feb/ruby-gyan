class Lesson < ApplicationRecord
    belongs_to :course
    validates :title, :content, :course, presence: true

    include PublicActivity::Model
    tracked owner: Proc.new{ |controller, model| controller.current_user }

    extend FriendlyId
    friendly_id :title, use: :slugged
end
