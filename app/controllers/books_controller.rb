class BooksController < ApplicationController

  def show
    @book = Book.find(params[:id])
  end

  def new
    @book = Book.new

  def search
    query = params[:query]
    if query.present?
      url = "https://openlibrary.org/search.json?q=#{URI.encode(query)}"
      books_serialized = URI.open(url).read
      @books_data = JSON.parse(books_serialized)


      @books_data.each do |book_data|
        book = Book.find_or_initialize_by(title: book_data["title"])
        book.author = book_data["author_name"]&.join(", ") || "Unknown"
        book.description = book_data["first_sentence"]&.first || "No description available"
        book.image_url = book_data["cover_i"] ? "https://covers.openlibrary.org/b/id/#{book_data['cover_i']}-M.jpg" : "https://via.placeholder.com/150"
        book.save
      end
    else
      flash[:alert] = "No books found matching your search."
      redirect_to books_path
    end
  end

  # private

  # def book_params
  #   params.require(:book).permit(:title, :author, :description, :image_url)
  # end
end

require "json"
require "open-uri"
