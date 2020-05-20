# frozen_string_literal: true

# Validators for the incoming requests
module InputValidators
  def self.check_description(raw_author, raw_name, raw_date, raw_mark, raw_read_format, raw_sizeb, raw_comment)
    author = raw_author || ''
    name = raw_name || ''
    date = raw_date || ''
    mark = raw_mark || ''
    read_format = raw_read_format || ''
    sizeb = raw_sizeb || ''
    comment = raw_comment || ''
    errors = [].concat(check_date(date))
               .concat(check_date_format(date))
               .concat(check_author(author))
               .concat(check_name(name))
               .concat(check_read_format(read_format))
               .concat(check_empty_read_format(read_format))
               .concat(check_mark(mark))
               .concat(check_sizeb(sizeb))
               .concat(check_comment(comment))
               .concat(smarks(mark))
               .concat(isanint(mark))
    {
      author: author,
      name: name,
      date: date,
      mark: mark,
      read_format: read_format,
      sizeb: sizeb,
      comment: comment,
      errors: errors
    }
  end

  def self.check_comment(_comment)
    []
  end

  def self.check_mark(mark)
    if mark.empty?
      ['Оценка не может быть пустой']
    else
      isanint(mark)
  end
end

  def self.isanint(mark)
    if mark.to_i != 0
      smarks(mark)
    else
      ['Оценка должна быть целым числом']
    end
  end

  def self.smarks(mark)
    if mark.to_i.negative? || mark.to_i > 10
      ['Оценка должна быть от 0 до 10']
    else
      []
    end
  end

  def self.check_sizeb(sizeb)
    if sizeb.empty?
      ['Размер произвдениея не может быть пустым']
    else
      []
      end
    end

  def self.check_book(raw_read_format)
    read_format = raw_read_format || ''
    errors = [].concat(check_read_format(read_format))
               .concat(check_empty_read_format(read_format))
    {
      read_format: read_format,
      errors: errors
    }
  end

  def self.check_read_format(read_format)
    if (read_format != 'бумажная книга') && (read_format != 'электронная книга') && (read_format != 'аудиокнига')
      ['Надо ввести либо бумажную книгу, либо электронную, либо аудиокнигу']
    else
      []
    end
  end

  def self.check_empty_read_format(read_format)
    if read_format.empty?
      ['Формат чтения не может быть пустым']
    else
      []
    end
  end

  def self.check_date_format(date)
    if /\d{4}-\d{2}-\d{2}/ =~ date
      []
    else
      ['Дата должна быть передана в формате ГГГГ-ММ-ДД']
    end
  end

  def self.check_n_d(date)
    array = date.split('-').map(&:to_i)
    check_year(array)
  end

  def self.check_year(array)
    if array[0].nil?
      ['Вы ввели пустой год']
    elsif (array[0] < 1) || (array[0] > 2020)
      ['Год не может быть меньше 1 больше 2020']
    else
      check_month(array)
    end
  end

  def self.check_month(array)
    if array[1].nil?
      ['Вы ввели пустой месяц']
    elsif (array[1] < 1) || (array[1] > 12)
      ['Месяц не может быть меньше 1 и больше 12']
    else
      check_day(array)
    end
  end

  def self.check_day(array)
    if array[2].nil?
      ['Вы ввели пустой день в дате']
    elsif (array[2] < 1) || (array[2] > 31)
      ['День не может быть меньше 1 больше 31']
    else
      []
    end
  end

  def self.check_author(author)
    if author.empty?
      ['Имя автора не может быть пустым']
    else
      []
    end
  end

  def self.check_name(name)
    if name.empty?
      ['Название книги  не может быть пустым']
    else
      []
    end
  end

  def self.check_date(date)
    if date.empty?
      ['Дата не может быть пустой']
    else
      check_n_d(date)
    end
  end
end
