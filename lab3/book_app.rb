# frozen_string_literal: true

require 'forme'
require 'roda'
require_relative 'models'
# BookApp class of application
class BookApp < Roda
  opts[:root] = __dir__
  plugin :environments
  plugin :forme
  plugin :render
  configure :development do
    plugin :public
    opts[:serve_static] = true
  end

  opts[:books] = BookList.new([
                                Book.new('Булгаков', 'Мастер и Маргарита', '2018-02-12', '9', 'бумажная книга', 708, 'советую'),
                                Book.new('Рудазов', 'Серая чума', '2019-06-04', '3', 'бумажная книга', 540, ''),
                                Book.new('Бунин', 'Жизнь Арсеньева', '2019-03-23', '5', 'электронная книга', 1092, 'отлично'),
                                Book.new('Достоевский', 'Преступление и наказание', '2020-02-20', '7', 'аудиокнига', 301, ''),
                                Book.new('Круз', 'Выживатель', '2010-12-07', '9', 'бумажная книга', 504, 'советую'),
                                Book.new('Толстой', 'Война и мир', '2020-02-24', '10', 'электронная книга', 542, ''),
                                Book.new('Мележ', 'Дыхание грозы', '2020-01-13', '2', 'аудиокнига', 12, ''),
                                Book.new('Ахматова', 'Вечер', '2020-06-08', '5', 'бумажная книга', 104, '')
                              ])

  route do |r|
    r.public if opts[:serve_static]
    r.root do
      @books = opts[:books].sort_by_date
      @params = InputValidators.check_book(r.params['read_format'])
      @filtered_books = if @params[:errors].empty?
                          opts[:books].filter(@params[:read_format])
                        else
                          opts[:books].all_books
                          end
      view('books')
    end

    r.on 'new' do
      r.get do
        view('new_book')
      end
      r.post do
        @params = InputValidators.check_description(r.params['author'], r.params['name'], r.params['date'], r.params['mark'], r.params['read_format'], r.params['sizeb'], r.params['comment'])
        if @params[:errors].empty?
          opts[:books].add_book(Book.new(@params[:author], @params[:name], @params[:date], @params[:mark], @params[:read_format], @params[:sizeb], @params[:comment]))
          r.redirect '/'
        else
          view('new_book')
        end
      end
    end

    r.on 'statistics' do
      r.get do
        @books = opts[:books].sort_by_date
        @years = opts[:books].years
        view('statistics')
      end
    end

    r.get Integer do |year|
      @books = opts[:books].sort_by_date
      @year = year
      view('read_books')
    end
  end
end
