# encoding: utf-8
require_relative 'recipe_manager'

Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8
$stdin.set_encoding('UTF-8')

class App
  YAML_FILE = 'recipes.yaml'
  JSON_FILE  = 'recipes.json'

  def initialize
    @manager = RecipeManager.new
  end

  def run
    load_data
    loop do
      print_menu
      case read_input
      when '1' then cmd_list
      when '2' then cmd_add
      when '3' then cmd_edit
      when '4' then cmd_delete
      when '5' then cmd_find
      when '6' then cmd_filter_category
      when '7' then cmd_filter_difficulty
      when '0' then break
      else puts "Невідома команда."
      end
    end
  ensure
    @manager.save_to_yaml(YAML_FILE)
    puts "Збережено у #{YAML_FILE}. До побачення!"
  end

  private

  def read_input
    gets.to_s.encode('UTF-8', invalid: :replace, undef: :replace, replace: '').chomp.strip
  end

  def load_data
    if File.exist?(YAML_FILE)
      @manager.load_from_yaml(YAML_FILE)
      puts "Завантажено з #{YAML_FILE} (#{@manager.size} записів)"
    elsif File.exist?(JSON_FILE)
      @manager.load_from_json(JSON_FILE)
      puts "Завантажено з #{JSON_FILE} (#{@manager.size} записів)"
    else
      puts "Порожня колекція."
    end
  end

  def print_menu
    puts "\n========= МЕНЮ ========="
    puts "1. Список рецептів"
    puts "2. Додати рецепт"
    puts "3. Редагувати рецепт"
    puts "4. Видалити рецепт"
    puts "5. Пошук за назвою"
    puts "6. Фільтр за категорією"
    puts "7. Фільтр за складністю"
    puts "0. Вийти"
    puts "========================"
    print "Вибір: "
  end

  def print_recipe(id, r)
    puts "  [#{id}] #{r.title}"
    puts "      Категорія : #{r.category}"
    puts "      Складність: #{r.difficulty}"
    puts "      Час        : #{r.cooking_time} хв  |  Порції: #{r.servings}"
    puts "      Інгредієнти: #{r.ingredients.join(', ')}"
    puts "      Кроки      : #{r.steps.join(' -> ')}"
    puts "      Дата       : #{r.created_at}  |  Опубліковано: #{r.published}"
    puts "      " + "-" * 55
  end

  def cmd_list
    col = @manager.list_recipes
    col.empty? ? puts("Колекція порожня.") : col.each { |id, r| print_recipe(id, r) }
  end

  def cmd_add
    print "Назва: ";                         title        = read_input
    print "Інгредієнти (через кому): ";      ingredients  = read_input.split(',').map(&:strip)
    print "Кроки (через кому): ";            steps        = read_input.split(',').map(&:strip)
    print "Категорія: ";                     category     = read_input
    print "Час (хв): ";                      cooking_time = read_input.to_i
    print "Порції: ";                        servings     = read_input.to_i
    print "Складність (easy/medium/hard): "; difficulty   = read_input
    id = @manager.add_recipe(title, ingredients, steps, category, cooking_time, servings, difficulty)
    puts "Додано рецепт з id=#{id}."
  end

  def cmd_edit
    print "ID рецепту: "; id = read_input.to_i
    puts "Поля: title, category, cooking_time, servings, difficulty, published"
    print "Поле: "; field = read_input.to_sym
    print "Значення: "; value = read_input
    value = value.to_i      if %i[cooking_time servings].include?(field)
    value = value == 'true' if field == :published
    @manager.edit_recipe(id, { field => value })
    puts "Оновлено."
  rescue RuntimeError => e
    puts "Помилка: #{e.message}"
  end

  def cmd_delete
    print "ID рецепту: "; id = read_input.to_i
    @manager.delete_recipe(id)
    puts "Видалено."
  rescue RuntimeError => e
    puts "Помилка: #{e.message}"
  end

  def cmd_find
    print "Запит: "; query = read_input
    res = @manager.find_by_title(query)
    res.empty? ? puts("Не знайдено.") : res.each { |id, r| print_recipe(id, r) }
  end

  def cmd_filter_category
    print "Категорія: "; cat = read_input
    res = @manager.filter_by_category(cat)
    res.empty? ? puts("Не знайдено.") : res.each { |id, r| print_recipe(id, r) }
  end

  def cmd_filter_difficulty
    print "Складність (easy/medium/hard): "; diff = read_input
    res = @manager.filter_by_difficulty(diff)
    res.empty? ? puts("Не знайдено.") : res.each { |id, r| print_recipe(id, r) }
  end
end

App.new.run
