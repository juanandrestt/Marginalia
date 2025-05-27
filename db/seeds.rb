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



