require "json"
require "open-uri"
require "faker"

puts "Deleting all messages..."
Message.destroy_all

puts "Deleting all lists..."
List.destroy_all

puts "Deleting all chats..."
Chat.destroy_all

puts "Deleting all follows..."
Follow.destroy_all

puts "Deleting all books..."
Book.destroy_all

puts "Deleting all users..."
User.destroy_all

puts "Creating books..."

def upload_cover(image_path)
  Cloudinary::Uploader.upload(image_path)['secure_url']
end

subjects = ["fiction", "poetry", "manga"]

subjects.each do |subject|
  url = "https://openlibrary.org/search.json?q=subject:#{subject}+AND+first_publish_year:[2020+TO+*]+AND+(publisher:Knopf+OR+publisher:Viz+Media+OR+publisher:Penguin+Random+House)&limit=20"
  begin
    serialized = URI.open(url).read
    data = JSON.parse(serialized)

    data["docs"].each do |doc|
      title = doc["title"]
      author = doc["author_name"]&.first || "Unknown Author"
      publishing_year = doc["first_publish_year"]
      open_library_id = doc["key"]&.split("/")&.last
      subjects = doc["subject"]&.join(", ") || ""

      work_url = "https://openlibrary.org/works/#{open_library_id}.json"
      begin
        full_data = JSON.parse(URI.open(work_url).read)
        desc = full_data["description"]
        description = desc.is_a?(Hash) ? desc["value"] : desc
      rescue
        description = nil
      end

      cover_id = doc["cover_i"]
      cover_url = cover_id ? "https://covers.openlibrary.org/b/id/#{cover_id}-L.jpg" : nil

      # Ensure cover_url is not nil before proceeding
      next unless cover_url

      characters = nil # not available here

      book = Book.new(
        title: title,
        author: author,
        publishing_year: publishing_year,
        open_library_id: open_library_id,
        description: description,
        cover_url: cover_url,
        subjects: subjects,
        characters: characters
      )

      # Ensure cover_url is valid before attaching
      if book.cover_url
        book.cover.attach(
          io: URI.open(book.cover_url),
          filename: "cover_#{book.title}",
          content_type: "image/jpg"
        )
      end

      book.save!
    end
  rescue => e
    puts "An error occurred: #{e.message}"
    next
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
