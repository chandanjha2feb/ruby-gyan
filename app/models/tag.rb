class Tag < ApplicationRecord
    has_many :course_tags
    has_many :courses, through: :course_tags

    validates :name, length: {minimum: 1, maximum: 25}, uniqueness: true

    def self.ransackable_attributes(auth_object = nil)
        ["course_tags_count", "created_at", "id", "name", "updated_at"]
    end
end