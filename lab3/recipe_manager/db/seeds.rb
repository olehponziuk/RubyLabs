%w[Супи Основні\ страви Салати Десерти Сніданки Закуски Напої Випічка].each do |name|
  Category.find_or_create_by!(name: name)
end

%w[Борошно Яйця Молоко Цукор Сіль Олія Часник Цибуля Морква Картопля].each do |name|
  Ingredient.find_or_create_by!(name: name)
end

puts "Засіяно #{Category.count} категорій та #{Ingredient.count} інгредієнтів."
