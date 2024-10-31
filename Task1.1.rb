require 'minitest/autorun'

# Функція для поділу торта на прямокутники
def divide_cake_by_raisins(cake)
  # Перетворюємо торт на числову матрицю (0 - родзинка, 1 - порожнє місце)
  numeric_cake = cake.map do |row|
    row.chars.map { |cell| cell == 'о' ? 0 : 1 }
  end

  rows = numeric_cake.length
  columns = numeric_cake[0].length

  # Знаходимо кількість родзинок
  raisins = []
  numeric_cake.each_with_index do |row, i|
    row.each_with_index do |cell, j|
      raisins << [i, j] if cell == 0
    end
  end
  raisin_count = raisins.length

  # Перевіряємо, чи можна поділити торт на частини
  total_elements = rows * columns
  if total_elements % raisin_count != 0
    return "Неможливо рівномірно поділити торт."
  end

  # Обчислюємо розмір кожного прямокутника
  part_size = total_elements / raisin_count

  # Перевіряємо можливі розміри прямокутників, де висота і ширина >= 2
  divisors = (2..Math.sqrt(part_size)).select { |n| part_size % n == 0 }
  possible_sizes = divisors.map { |d| [d, part_size / d] }.select { |height, width| height >= 2 && width >= 2 }

  return "Неможливо поділити торт: не можна створити прямокутники з висотою і шириною >= 2." unless possible_sizes.any?

  # Обираємо перший підходящий розмір
  part_height, part_width = possible_sizes.first

  # Ділимо торт на прямокутники і перевіряємо, чи є в кожному тільки одна родзинка
  horizontal_parts = rows / part_height
  vertical_parts = columns / part_width
  result = []

  (0...horizontal_parts).each do |h_index|
    (0...vertical_parts).each do |v_index|
      row_start = h_index * part_height
      row_end = row_start + part_height - 1
      col_start = v_index * part_width
      col_end = col_start + part_width - 1

      # Перевіряємо кількість родзинок у цьому прямокутнику
      raisin_count_in_rect = 0
      (row_start..row_end).each do |i|
        (col_start..col_end).each do |j|
          raisin_count_in_rect += 1 if numeric_cake[i][j] == 0
        end
      end

      if raisin_count_in_rect != 1
        return "Помилка: у прямокутнику більше або менше ніж одна родзинка. Поділ неможливий."
      end

      # Зберігаємо результат для тестування
      part = (row_start..row_end).map do |i|
        numeric_cake[i][col_start..col_end].map { |x| x == 0 ? 'о' : '.' }.join
      end
      result << part
    end
  end

  result
end

# Тести для функції divide_cake_by_raisins
class TestDivideCakeByRaisins < Minitest::Test
  def test_divisible_cake_with_raisins
    cake = [
      '.о......',
      '.....o..',
      '........',
      '...о....'
    ]
    result = divide_cake_by_raisins(cake)
    expected_result = [
      ['.о', '..'],
      ['..', 'o.'],
      ['..', '..'],
      ['..', 'о.']
    ]
    assert_equal expected_result, result
  end

  def test_undivisible_cake_due_to_extra_raisins
    cake = [
      '.о......',
      '.....о..',
      '.....о..'
    ]
    result = divide_cake_by_raisins(cake)
    assert_equal "Помилка: у прямокутнику більше або менше ніж одна родзинка. Поділ неможливий.", result
  end

  def test_impossible_division_due_to_part_size
    cake = [
      '.о...',
      '.....',
      '.....',
      '.....'
    ]
    result = divide_cake_by_raisins(cake)
    assert_equal "Неможливо поділити торт: не можна створити прямокутники з висотою і шириною >= 2.", result
  end

  def test_divisible_cake_with_single_raisin
    cake = [
      '.о.',
      '...'
    ]
    result = divide_cake_by_raisins(cake)
    expected_result = [['.о', '..']]
    assert_equal expected_result, result
  end

  def test_no_raisins
    cake = [
      '......',
      '......'
    ]
    result = divide_cake_by_raisins(cake)
    assert_equal "Неможливо рівномірно поділити торт.", result
  end
end
