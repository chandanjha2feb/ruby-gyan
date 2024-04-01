class Course < ApplicationRecord
    extend FriendlyId
    friendly_id :title, use: :slugged

    belongs_to :user

    validates :title, :short_description, :level, :price, :language,  presence: true
    validates :description, presence: true, length: { :minimum => 5 }

    has_rich_text :description


    def to_s
      title
    end

end
