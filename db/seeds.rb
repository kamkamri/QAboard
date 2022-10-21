# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Area.create!(
  name: "管理者",
  admin_area_flag: true
  )

AdminUser.create!(
  employee_number: "000000",
  family_name: "admin",
  first_name: "管理者",
  area_id: 1,
  email: "admin@example.com",
  password: "000000",
  is_deleted: false
  )