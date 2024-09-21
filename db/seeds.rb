# user = User.new(
#   email: 'admin@example.com', 
#   password: 'admin@example.com', 
#   password_confirmation: 'admin@example.com'
# )
# user.skip_confirmation!
# user.save!
PublicActivity.enabled = false
10.times do
    course = Course.new(
        title: Faker::Educator.course_name,
        description: Faker::TvShows::GameOfThrones.quote,
        user_id: User.first.id,
        short_description: Faker::Quote.famous_last_words,
        language: Faker::ProgrammingLanguage.name,
        level: "Beginner",
        price: Faker::Number.between(from: 1000, to: 20000)
    )
    course.save(validate: false)
end
PublicActivity.enabled = true

