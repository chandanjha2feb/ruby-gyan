class Lesson < ApplicationRecord
    belongs_to :course, counter_cache: true
    has_many :user_lessons

    validates :title, :content, :course, presence: true

    include PublicActivity::Model
    tracked owner: Proc.new{ |controller, model| controller.current_user }

    has_rich_text :content

    extend FriendlyId
    friendly_id :title, use: :slugged

    def viewed(user)
        self.user_lessons.where(user: user).present?
        #self.user_lessons.where(user_id: [user.id], lesson_id: [self.id]).empty?
    end
end
