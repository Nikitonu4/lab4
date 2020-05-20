# frozen_string_literal: true

require 'forwardable'
# The list of books
class BookList
  extend Forwardable
  def_delegator :@books, :each, :each_book

  def initialize(books = [])
    @books = books
  end

  def all_books
    @books.dup
  end

  def add_book(book)
    @books.append(book)
  end

  def sort_by_date
    @books.sort { |book2, book1| (book1.date <=> book2.date) }
  end

  def years
    array_of_years = []
    @books.each do |book|
      year = book.date.split('-').map(&:to_i)
      array_of_years.append(year[0])
    end
    array_of_years.uniq.sort
  end

  def filter(read_format)
    @books.select do |book|
      next if !read_format.empty? && !book.read_format.include?(read_format)

      true
    end
  end
end
