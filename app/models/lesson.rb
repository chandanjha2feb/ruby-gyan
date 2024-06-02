class Lesson < ApplicationRecord
    belongs_to :course, counter_cache: true
    has_many :user_lessons, dependent: :destroy

    validates :title, :content, :course, presence: true

    include RankedModel
    ranks :row_order, :with_same => :course_id

    include PublicActivity::Model
    tracked owner: Proc.new{ |controller, model| controller.current_user }

    has_rich_text :content

    extend FriendlyId
    friendly_id :title, use: :slugged

    def prev
        course.lessons.where("row_order < ?", row_order).order(:row_order).last
    end
    
    def next
        course.lessons.where("row_order > ?", row_order).order(:row_order).first
    end

    def viewed(user)
        self.user_lessons.where(user: user).present?
        #self.user_lessons.where(user_id: [user.id], lesson_id: [self.id]).present?
    end
end
