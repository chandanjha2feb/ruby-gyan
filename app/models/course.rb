class Course < ApplicationRecord
  include PublicActivity::Model
  #tracked owner: Proc.new { |controller, model| controller.current_user }

  extend FriendlyId
  friendly_id :title, use: :slugged

  belongs_to :user, counter_cache: true
  has_many :lessons, dependent: :destroy
  has_many :enrollments, dependent: :restrict_with_error, inverse_of: :course
  has_many :user_lessons, through: :lessons
  has_many :course_tags
  has_many :tags, through: :course_tags

  accepts_nested_attributes_for :lessons, reject_if: :all_blank, allow_destroy: true

  validates :title, :description, :short_description, :level, :price, :language,  presence: true
  validates :title, uniqueness: true, length: { maximum: 70 }
  validates :price, numericality: { greater_than_or_equal_to: 0 }
  validates :description, length: { minimum: 5 }
  validates :short_description, length: { maximum: 300 }
  validates :avatar, presence: true, on: :update
  validates :avatar,
    content_type: ['image/png', 'image/jpg', 'image/jpeg'], 
    size: { less_than: 500.kilobytes , message: 'size should be under 500 kilobytes' }

  has_rich_text :description
  has_one_attached :avatar

  LANGUAGES = [:"English", :"Russian", :"Polish", :"Spanish"]
  LEVELS = [:"All levels", :"Beginner", :"Intermediate", :"Advanced"]

  scope :latest, -> { limit(3).order(created_at: :desc) }
  scope :top_rated, -> { limit(3).order(average_rating: :desc, created_at: :desc) }
  scope :popular, -> { limit(3).order(enrollments_count: :desc, created_at: :desc) }
  scope :published, -> { where(published: true) }
  scope :unpublished, -> { where(published: false) }
  scope :approved, -> { where(approved: true) }
  scope :unapproved, -> { where(approved: false) }

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
    ["title", "short_description", "level", "price", "language", "enrollments_count", "average_rating", "created_at", "tags_name_cont_any"]
  end

  def self.ransackable_associations(auth_object = nil)
    ["rich_text_description", "user", "tags", "course_tags"]
  end

  def username
    user.username
  end

  def bought(user)
    self.enrollments.where(user_id: [user.id], course_id: [self.id]).exists?
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

  def similiar_courses
    self.class.joins(:tags)
    .where.not(id: id)
    .where(tags: { id: tags.ids })
    .select(
    'courses.*',
    'COUNT(tags.*) AS tags_in_common'
    )
    .group(:id)
    .order(tags_in_common: :desc)
  end
end
