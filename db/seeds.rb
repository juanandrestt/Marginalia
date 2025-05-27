# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


require "json"
require "open-uri"

url = "https://openlibrary.org/search.json?q=*&limit=100&page=1"
books_serialized = URI.parse(url).read
books = JSON.parse(book_serialized)

books.each do |books|
  Book.create!(
    title: ["title"],
    overview: movie["overview"],
    poster_url: "https://image.tmdb.org/t/p/w500/#{movie["poster_path"]}",
    rating: movie["vote_average"]
  )
end
