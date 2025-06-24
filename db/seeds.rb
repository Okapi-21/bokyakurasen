# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

require 'faker'

# まず全データをクリア
Choice.delete_all
Question.delete_all
User.delete_all

# ユーザーもダミーで作成
users = 5.times.map do
  User.create!(
    name: Faker::Name.name,
    email: Faker::Internet.unique.email,
    password: "password",
    password_confirmation: "password"
  )
end

# 親（チャレンジ）を10個作成
10.times do
  parent = Question.create!(
    title: Faker::Educator.course_name,
    description: Faker::Lorem.paragraph,
    user: users.sample
  )

  # 各親チャレンジに子（問題）を5~8個ランダムで作成
  rand(5..8).times do
    child = Question.create!(
      title: Faker::Educator.subject,
      description: Faker::Lorem.sentence,
      parent: parent,
      user: users.sample,
      explanation: Faker::Lorem.sentence
    )

    # 各問題に4択の選択肢（正解は1つだけ）
    correct_index = rand(0..3)
    4.times do |i|
      child.choices.create!(
        content: Faker::Lorem.word,
        is_correct: (i == correct_index)
      )
    end
  end
end
