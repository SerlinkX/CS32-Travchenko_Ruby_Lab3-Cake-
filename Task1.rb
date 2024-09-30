# Функція для знаходження позицій родзинок у торті
def find_raisins(cake)
  raisins = []
  cake.each_with_index do |row, y|
    row.chars.each_with_index do |cell, x|
      raisins << [y, x] if cell == 'o'
    end
  end
  raisins
end

# Функція для поділу пирога на горизонтальні частини
def horizontal_cut(cake, raisins)
  # Масив для збереження результату
  result = []

  # Підготовка списку для зрізаних шматків
  previous_y = -1
  raisins.each do |y, x|
    # Якщо ми перейшли на новий рядок
    if y > previous_y
      result << []
    end
    # Додаємо шматок торта до результату
    result.last << cake[y]
    previous_y = y
  end

  result
end

# Функція для поділу пирога на вертикальні частини
def vertical_cut(cake, raisins)
  # Масив для збереження результату
  result = []

  # Для кожної родзинки вирізаємо шматок
  raisins.each_with_index do |(y, x), index|
    # Визначаємо розмір шматка для кожної родзинки
    result << []
    cake.each_with_index do |row, i|
      if i == y || row[x] == 'o'
        result[index] << row[x]
      else
        result[index] << ''
      end
    end
  end

  result
end

# Основна функція для пошуку оптимального розрізу
def divide_cake(cake)
  raisins = find_raisins(cake)
  n = raisins.size # Кількість родзинок

  # Пробуємо розрізати по горизонталі
  horizontal_result = horizontal_cut(cake, raisins)

  # Пробуємо розрізати по вертикалі
  vertical_result = vertical_cut(cake, raisins)

  # Повертаємо той результат, де ширина першого шматка найбільша
  if horizontal_result.first.first.size >= vertical_result.first.first.size
    horizontal_result
  else
    vertical_result
  end
end

# Вхідні дані (пиріг з родзинками)
cake = [
  '........',
  '..o.....',
  '...o....',
  '........'
]

# Виклик функції
result = divide_cake(cake)

# Виводимо результат
result.each do |piece|
  puts piece.join("\n")
  puts "------" # Візуально розділяємо шматки
end
