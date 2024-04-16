class Course < ApplicationRecord
    include PublicActivity::Model
    #tracked owner: Proc.new { |controller, model| controller.current_user }

    extend FriendlyId
    friendly_id :title, use: :slugged

    belongs_to :user
    has_many :lessons, dependent: :destroy

    validates :title, :short_description, :level, :price, :language,  presence: true
    validates :description, presence: true, length: { :minimum => 5 }

    has_rich_text :description

    LANGUAGES = [:"English", :"Russian", :"Polish", :"Spanish"]
    LEVELS = [:"Beginner", :"Intermediate", :"Advanced"]

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
      ["title", "short_description", "level", "price", "language"]
    end

    def self.ransackable_associations(auth_object = nil)
      ["rich_text_description", "user"]
    end

    def username
      user.username
    end
end
