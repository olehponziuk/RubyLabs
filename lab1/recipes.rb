require 'json'
require 'yaml'

# --- CRUD ---

# Додати новий рецепт до колекції; id генерується автоматично
def add_recipe(collection, title:, ingredients:, steps:, category:,
               cooking_time:, servings:, difficulty:, created_at:, published:)
  id = (collection.keys.max || 0) + 1
  collection[id] = {
    title:        title,
    ingredients:  ingredients,
    steps:        steps,
    category:     category,
    cooking_time: cooking_time,
    servings:     servings,
    difficulty:   difficulty,
    created_at:   created_at,
    published:    published
  }
  id
end

# Редагувати поля рецепту за id; передані ключі замінюються
def edit_recipe(collection, id, new_data)
  raise "Запис #{id} не знайдено" unless collection.key?(id)
  collection[id].merge!(new_data)
end

# Видалити рецепт за id
def delete_recipe(collection, id)
  raise "Запис #{id} не знайдено" unless collection.key?(id)
  collection.delete(id)
end

# Вивести всі рецепти у зручному форматі
def list_recipes(collection)
  if collection.empty?
    puts "  (колекція порожня)"
    return
  end
  collection.each do |id, r|
    puts "  [#{id}] #{r[:title]}"
    puts "      Категорія : #{r[:category]}"
    puts "      Складність: #{r[:difficulty]}"
    puts "      Час        : #{r[:cooking_time]} хв  |  Порції: #{r[:servings]}"
    puts "      Інгредієнти: #{r[:ingredients].join(', ')}"
    puts "      Кроки      : #{r[:steps].join(' -> ')}"
    puts "      Дата       : #{r[:created_at]}  |  Опубліковано: #{r[:published]}"
    puts "      " + "-" * 60
  end
end

# --- Пошук та фільтрація ---

# Пошук за частиною назви (регістр не враховується)
def find_by_title(collection, query)
  collection.select { |_, r| r[:title].downcase.include?(query.downcase) }
end

# Фільтрація за категорією
def filter_by_category(collection, category)
  collection.select { |_, r| r[:category].downcase == category.downcase }
end

# Фільтрація за рівнем складності (easy / medium / hard)
def filter_by_difficulty(collection, difficulty)
  collection.select { |_, r| r[:difficulty].downcase == difficulty.downcase }
end

# --- Файли ---

# Перетворити хеш до вигляду, зручного для серіалізації (рядкові ключі)
def stringify_keys(collection)
  collection.transform_keys(&:to_s).transform_values { |v| v.transform_keys(&:to_s) }
end

# Відновити символьні ключі після десеріалізації
def symbolize_keys(raw)
  raw.transform_keys(&:to_i).transform_values { |v| v.transform_keys(&:to_sym) }
end

# Зберегти колекцію у JSON-файл
def save_to_json(collection, filename)
  File.write(filename, JSON.pretty_generate(stringify_keys(collection)))
  puts "  Збережено у #{filename}"
end

# Завантажити колекцію з JSON-файлу
def load_from_json(filename)
  symbolize_keys(JSON.parse(File.read(filename)))
rescue Errno::ENOENT
  puts "  Файл #{filename} не знайдено"
  {}
end

# Зберегти колекцію у YAML-файл
def save_to_yaml(collection, filename)
  File.write(filename, stringify_keys(collection).to_yaml)
  puts "  Збережено у #{filename}"
end

# Завантажити колекцію з YAML-файлу
def load_from_yaml(filename)
  symbolize_keys(YAML.safe_load(File.read(filename)))
rescue Errno::ENOENT
  puts "  Файл #{filename} не знайдено"
  {}
end

# =============================================================================
# Демонстрація
# =============================================================================

puts "=" * 65
puts "  МЕНЕДЖЕР РЕЦЕПТІВ — демонстрація"
puts "=" * 65

# Початкова колекція згідно з варіантом
recipes = {
  1 => {
    title:        "Борщ",
    ingredients:  ["буряк", "капуста", "морква"],
    steps:        ["нарізати овочі", "зварити бульйон", "додати овочі"],
    category:     "Супи",
    cooking_time: 60,
    servings:     4,
    difficulty:   "easy",
    created_at:   "2024-02-15",
    published:    false
  },
  2 => {
    title:        "Вареники",
    ingredients:  ["борошно", "картопля", "цибуля"],
    steps:        ["замісити тісто", "приготувати начинку", "зліпити"],
    category:     "Основні страви",
    cooking_time: 90,
    servings:     6,
    difficulty:   "medium",
    created_at:   "2024-02-20",
    published:    true
  }
}

# --- list ---
puts "\n>> list_recipes (початкова колекція)"
list_recipes(recipes)

# --- add ---
puts "\n>> add_recipe — додаємо «Омлет»"
new_id = add_recipe(
  recipes,
  title:        "Омлет",
  ingredients:  ["яйця", "молоко", "сіль"],
  steps:        ["збити яйця з молоком", "вилити на пательню", "смажити 5 хв"],
  category:     "Сніданки",
  cooking_time: 10,
  servings:     2,
  difficulty:   "easy",
  created_at:   "2024-03-01",
  published:    true
)
puts "  Додано з id=#{new_id}"
list_recipes(recipes)

# --- edit ---
puts "\n>> edit_recipe — змінюємо servings Борщу на 6"
edit_recipe(recipes, 1, { servings: 6 })
puts "  recipes[1][:servings] = #{recipes[1][:servings]}"

# --- find_by_title ---
puts "\n>> find_by_title('ник')"
found = find_by_title(recipes, "ник")
found.each { |id, r| puts "  [#{id}] #{r[:title]}" }

# --- filter_by_category ---
puts "\n>> filter_by_category('Сніданки')"
filter_by_category(recipes, "Сніданки").each { |id, r| puts "  [#{id}] #{r[:title]}" }

# --- filter_by_difficulty ---
puts "\n>> filter_by_difficulty('easy')"
filter_by_difficulty(recipes, "easy").each { |id, r| puts "  [#{id}] #{r[:title]}" }

# --- save/load JSON ---
puts "\n>> save_to_json / load_from_json"
save_to_json(recipes, "recipes.json")
loaded_json = load_from_json("recipes.json")
puts "  Завантажено #{loaded_json.size} записів з JSON"
puts "  recipes[1][:title] = #{loaded_json[1][:title]}"

# --- save/load YAML ---
puts "\n>> save_to_yaml / load_from_yaml"
save_to_yaml(recipes, "recipes.yaml")
loaded_yaml = load_from_yaml("recipes.yaml")
puts "  Завантажено #{loaded_yaml.size} записів з YAML"
puts "  recipes[2][:title] = #{loaded_yaml[2][:title]}"

# --- обробка помилок ---
puts "\n>> Обробка помилок"

begin
  delete_recipe(recipes, 999)
rescue RuntimeError => e
  puts "  RuntimeError: #{e.message}"
end

begin
  edit_recipe(recipes, 999, { title: "X" })
rescue RuntimeError => e
  puts "  RuntimeError: #{e.message}"
end

missing = load_from_json("no_such_file.json")
puts "  load_from_json повернув: #{missing}"

missing = load_from_yaml("no_such_file.yaml")
puts "  load_from_yaml повернув: #{missing}"

# --- delete ---
puts "\n>> delete_recipe — видаляємо id=3"
delete_recipe(recipes, 3)
puts "  Після видалення:"
list_recipes(recipes)

puts "\n" + "=" * 65
puts "  Готово."
puts "=" * 65
