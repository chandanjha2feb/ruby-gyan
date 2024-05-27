class Course < ApplicationRecord
  include PublicActivity::Model
  #tracked owner: Proc.new { |controller, model| controller.current_user }

  extend FriendlyId
  friendly_id :title, use: :slugged

  belongs_to :user, counter_cache: true
  has_many :lessons, dependent: :destroy
  has_many :enrollments
  has_many :user_lessons, through: :lessons

  validates :title, :short_description, :level, :price, :language,  presence: true
  validates :title, uniqueness: true
  validates :description, presence: true, length: { :minimum => 5 }

  has_rich_text :description

  LANGUAGES = [:"English", :"Russian", :"Polish", :"Spanish"]
  LEVELS = [:"Beginner", :"Intermediate", :"Advanced"]

  scope :latest, -> { limit(3).order(created_at: :desc) }
  scope :top_rated, -> { limit(3).order(average_rating: :desc, created_at: :desc) }
  scope :popular, -> { limit(3).order(enrollments_count: :desc, created_at: :desc) }


  def self.languages
    LANGUAGES.map { |language| [language, language] }
  end

  def self.levels
    LEVELS.map { |level| [level, level] }
  end


  def to_s
    title
  end

  def self.ransackable_attributes(auth_object = nil)
    ["title", "short_description", "level", "price", "language", "enrollments_count", "average_rating", "created_at"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["rich_text_description", "user"]
  end

  def username
    user.username
  end

  def bought(user)
    self.enrollments.where(user_id: [user.id], course_id: [self.id]).empty?
  end

  def update_rating
    if enrollments.any? && enrollments.where.not(rating: nil).any?
      update_column :average_rating, (enrollments.average(:rating).round(2).to_f)
    else
      update_column :average_rating, (0)
    end
  end

  def progress(user)
    unless self.lessons_count == 0
      (user_lessons.where(user: user).count/self.lessons_count).to_f*100
    end
  end
end
