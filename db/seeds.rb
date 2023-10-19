# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
# seedは初期データのことであり、今回で言うと管理者側で新規登録を行わないため、
# 新たにデータを追加することがないという理由でseedによって初期データを設定している。
Admin.create!(
  email: "test@test.com",
  password: "111111"
  )