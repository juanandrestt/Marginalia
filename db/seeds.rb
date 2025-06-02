require "json"
require "open-uri"
require "faker"

puts "Deleting all messages..."
Message.destroy_all

puts "Deleting all chats..."
Chat.destroy_all

puts "Deleting all follows..."
Follow.destroy_all

puts "Deleting all books..."
Book.destroy_all

puts "Deleting all users..."
User.destroy_all

puts "Creating books..."

subjects = %w[fantasy science-fiction romance children poetry computers sociology manga]

subjects.each do |subject|
  url = "https://openlibrary.org/subjects/#{subject}.json?limit=30"
  serialized = URI.open(url).read
  data = JSON.parse(serialized)

  data["works"].each do |work|
    title = work["title"]
    authors = work["authors"] || []
    author = authors.first ? authors.first["name"] : "Unknown Author"
    publishing_year = work["first_publish_year"]
    open_library_id = work["key"]&.split("/")&.last
    subjects = work["subject"]&.join(", ") || ""

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

users = [
  User.create!(
    email: "isabela@mail.com",
    password: "password",
    password_confirmation: "password",
    username: "Isabela",
    avatar: ""
  ),
  User.create!(
    email: "anthony@mail.com",
    password: "password",
    password_confirmation: "password",
    username: "Anthony",
    avatar: ""
  ),
  User.create!(
    email: "juan@mail.com",
    password: "password",
    password_confirmation: "password",
    username: "Juan",
    avatar: ""
  ),
  User.create!(
    email: "samuel@mail.com",
    password: "password",
    password_confirmation: "password",
    username: "Samuel",
    avatar: ""
  )
]

puts "Users created. Now creating lists..."

users.each do |user|
  list = List.create!(
    name: "My favorite books",
    user: user
  )
  list.books << Book.all.sample(5)
end

puts "Lists created. Now creating bookmarks..."

Bookmark.create!(
  list: List.all.sample,
  book: Book.all.sample
)


puts "Bookmarks created. Now creating reviews..."

emotions = %w[Happy Sad Excited Grateful Angry Bored]
characters = ["Alice", "Frodo", "Jon Snow", "Matilda", "Naruto", "Hermione"]
books = Book.all

books.each do |book|
  Review.create!(
      content: Faker::GreekPhilosophers.quote,
      rating: rand(1.0..5.0).round(1),
      emotion: emotions.sample,
      favorite_characters: characters.sample,
      user: users.sample,
      book: book
    )
end

puts "Everything is created!"
