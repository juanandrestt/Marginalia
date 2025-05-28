require "json"
require "open-uri"
require "faker"

subjects = %w[fantasy science-fiction romance children poetry computers sociology manga]

puts "Creating books..."

subjects.each do |subject|
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

    # fetch full work details
    work_url = "https://openlibrary.org/works/#{open_library_id}.json"
    begin
      full_data = JSON.parse(URI.open(work_url).read)
      desc = full_data["description"]
      description = desc.is_a?(Hash) ? desc["value"] : desc
    rescue
      description = nil
    end

    cover_id = work["cover_id"]
    cover_url = cover_id ? "https://covers.openlibrary.org/b/id/#{cover_id}-L.jpg" : nil
    characters = nil # not available here

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
end

puts "Books created. Now creating users..."

users = 5.times.map do |i|
  User.create!(
    email: "user#{i + 1}@mail.com",
    password: "password",
    password_confirmation: "password"
  )
end

puts "Users created. Now creating reviews..."

emotions = %w[happy sad excited grateful angry bored]
characters = ["Alice", "Frodo", "Jon Snow", "Matilda", "Naruto", "Hermione"]
books = Book.all

books.each do |book|
  Review.create!(
      content: Faker::Quotes::Shakespeare.hamlet_quote,
      rating: rand(1.0..5.0).round(1),
      emotion: emotions.sample,
      favorite_characters: characters.sample,
      user: users.sample,
      book: book
    )
end

puts "Everything is created!"
