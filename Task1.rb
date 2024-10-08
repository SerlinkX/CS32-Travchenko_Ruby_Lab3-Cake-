def divide_cake_by_raisins(cake)
  # Перевірка на однакову кількість елементів у кожному рядку
  return puts 'У всіх рядках має бути однакова кількість елементів.' unless cake.all? { |row| row.length == cake[0].length }

  # Перетворюємо торт у масив чисел (0 - родзинка, 1 - інше)
  cake_matrix = cake.map do |row|
    row.chars.map { |cell| cell == 'о' || cell == 'o' ? 0 : 1 }
  end

  # Розмір торта
  rows = cake_matrix.length
  columns = cake_matrix[0].length

  # Знаходимо кількість родзинок
  raisin_count = cake_matrix.flatten.count(0)

  # Якщо немає родзинок
  return puts 'Неможливо поділити торт: немає родзинок.' if raisin_count.zero?

  # Визначаємо розміри прямокутників
  area = rows * columns
  if area % raisin_count != 0
    return puts 'Неможливо поділити торт: площа не ділиться на кількість родзинок.'
  end

  # Розмір кожного прямокутника
  rect_area = area / raisin_count

  # Знаходимо можливі розміри прямокутників (мінімум 2x2)
  possible_sizes = []
  (2..rect_area).each do |h|
    if rect_area % h == 0
      w = rect_area / h
      possible_sizes << [h, w] if w >= 2
    end
  end

  # Ділимо торт на прямокутники
  rectangles = []

  possible_sizes.each do |height, width|
    # Перевірка можливості поділу на прямокутники розміру height x width
    next unless rows % height == 0 && columns % width == 0

    valid = true
    (0...rows).step(height) do |r|
      (0...columns).step(width) do |c|
        rectangle = []
        raisin_count_in_rect = 0

        (0...height).each do |i|
          row = cake_matrix[r + i][c, width]
          rectangle << row
          raisin_count_in_rect += row.count(0)
        end

        # Якщо в прямокутнику більше ніж одна родзинка, розглядаємо наступний розмір
        if raisin_count_in_rect != 1
          valid = false
          break
        end
      end
      break unless valid
    end

    if valid
      # Якщо прямокутник коректний, зберігаємо його
      (0...rows).step(height) do |r|
        (0...columns).step(width) do |c|
          rectangle = []
          (0...height).each do |i|
            rectangle << cake[r + i][c, width]
          end
          rectangles << rectangle
        end
      end
      break
    end
  end

  # Виведення результатів
  if rectangles.empty?
    puts 'Неможливо поділити торт так, щоб у кожному прямокутнику була одна родзинка.'
  else
    puts "Торт поділено на прямокутники:"
    rectangles.each_with_index do |rectangle, index|
      puts "Прямокутник #{index + 1}:"
      rectangle.each { |row| puts row }
      puts "-" * 10  # Для розмежування частин
    end
  end
end

# Введення торта
cake = [
  '.о...o..',
  '........',
  '.o......',
  '.....o..',
]

# Ділимо торт на прямокутники
divide_cake_by_raisins(cake)
