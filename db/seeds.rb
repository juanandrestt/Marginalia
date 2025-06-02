require "json"
require "open-uri"
require "faker"

puts "Deleting all messages..."
Message.destroy_all

puts "Deleting all chats..."
Chat.destroy_all

puts "Deleting all reviews..."
Review.destroy_all

puts "Deleting all bookmarks..."
Bookmark.destroy_all

puts "Deleting all lists..."
List.destroy_all

puts "Deleting all follows..."
Follow.destroy_all

puts "Deleting all books..."
Book.destroy_all

puts "Deleting all users..."
User.destroy_all

puts "Deleting all reviews..."
Review.destroy_all

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

users = [
  User.create!(
    email: "anthony@mail.com",
    password: "password",
    password_confirmation: "password",
    username: "Anthony",
    avatar: "https://avatars.githubusercontent.com/u/207194539?v=4"
  ),
  User.create!(
    email: "juan@mail.com",
    password: "password",
    password_confirmation: "password",
    username: "Juan",
    avatar: "https://d26jy9fbi4q9wx.cloudfront.net/rails/active_storage/representations/proxy/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaHBBd2dkQkE9PSIsImV4cCI6bnVsbCwicHVyIjoiYmxvYl9pZCJ9fQ==--cd42f3a800cd318e2f31388a280d25de9b1f83d7/eyJfcmFpbHMiOnsibWVzc2FnZSI6IkJBaDdCem9MWm05eWJXRjBTU0lKYW5CbFp3WTZCa1ZVT2hOeVpYTnBlbVZmZEc5ZlptbHNiRnNJYVFISWFRSElld1k2Q1dOeWIzQTZEbUYwZEdWdWRHbHZiZz09IiwiZXhwIjpudWxsLCJwdXIiOiJ2YXJpYXRpb24ifX0=--23cdbdf9871e44adeb4d843a03b0793a5f08394b/CHA_0646-01.jpeg"
  ),
  User.create!(
    email: "samuel@mail.com",
    password: "password",
    password_confirmation: "password",
    username: "Samuel",
    avatar: "https://avatars.githubusercontent.com/u/207380223?v=4"
  )
]

puts "Users created. Now creating reviews..."

emotions = %w[Happy Sad Excited Grateful Angry Bored]
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
