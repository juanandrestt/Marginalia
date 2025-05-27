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

subject = "fantasy"  # Change this to your desired subject
url = "https://openlibrary.org/subjects/#{subject}.json?limit=50"
serialized = URI.open(url).read
data = JSON.parse(serialized)
data["works"].each do |work|
  title = work["title"]
  authors = work["authors"] || []
  author = authors.first ? authors.first["name"] : "Unknown Author"
  publishing_year = work["first_publish_year"]
  open_library_id = work["key"]&.split("/")&.last
  subjects = work["subject"]&.join(", ") || ""
  description = work["description"]
  # description can be string or hash with 'value'
  if description.is_a?(Hash)
    description = description["value"]
  elsif !description.is_a?(String)
    description = nil
  end
  cover_id = work["cover_id"]
  cover_url = cover_id ? "https://covers.openlibrary.org/b/id/#{cover_id}-L.jpg" : nil
  characters = nil # not available here, could add later
  Book.create!(
    title: title,
    author: author,
    publishing_year: publishing_year,
    open_library_id: open_library_id,
    description: description,
    cover_url: cover_url,
    subjects: subjects,
    characters: characters
  )
end


# require "json"
# require "open-uri"

# url = "https://openlibrary.org/search.json?q=*&limit=100&page=1"
# books_serialized = URI.parse(url).read
# books = JSON.parse(book_serialized)

# books.each do |books|
#   Book.create!(
#     title: ["title"],
#     overview: movie["overview"],
#     poster_url: "https://image.tmdb.org/t/p/w500/#{movie["poster_path"]}",
#     rating: movie["vote_average"]
#   )
# end
