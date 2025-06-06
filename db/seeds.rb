require "json"
require "open-uri"
require "faker"

puts "Deleting all messages..."
Message.destroy_all

puts "Deleting all lists..."
List.destroy_all

puts "Deleting all chats..."
Chat.destroy_all

puts "Deleting all books..."
Book.destroy_all

puts "Deleting all users..."
User.destroy_all

puts "Creating books..."

subjects = ["fiction", "poetry", "manga"]

subjects.each do |subject|
  url = "https://openlibrary.org/search.json?q=subject:#{subject}+AND+first_publish_year:[2020+TO+*]+AND+(publisher:Knopf+OR+publisher:Viz+Media+OR+publisher:Penguin+Random+House)&limit=50"
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

      book.save! if book.cover.attached?
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
books = Book.all
quotes = [
  "J'ai mis quatre mois à le lire, et on ne sort pas indemne de la fréquentation aussi longue d'une littérature aussi rude.",
  "Un livre labyrinthique et total, superbement écrit.",
  "Peut-on se libérer de ses origines sans les trahir ? Ce récit subtil et incarné montre qu'on ne se défait jamais tout à fait de ce qui nous a formés, mais qu'on peut apprendre à le regarder autrement. Une réussite.",
  "I don't know if this is the best book I've ever read, or the worst.",
  "This also happened when I dyed my hair",
  "When your circle small but y'all crazy",
  "No spoilers but I didn't breathe for the last few pages of this book.",
  "Écrit par une IA",
  "Je suis en train de chialer comme une merde j'arrive pas à m'arrêter",
  "Bravo les lesbiennes",
  "Ok...",
  "In a narrative that unfolds with the deliberate pace of a slow-burning fuse, the author crafts a tapestry of lives intertwined by fate and circumstance. The prose, both lyrical and precise, invites readers to linger over each sentence, savoring the nuances of character and setting. Themes of loss, redemption, and the inexorable passage of time permeate the work, offering a meditation on the human condition that is as profound as it is poignant.",
  "The author's exploration of identity and belonging is both timely and timeless. Through a series of interconnected stories, the narrative delves into the complexities of cultural assimilation and the subtle fractures that occur when personal history collides with societal expectations. The writing is at once sharp and empathetic, capturing the dissonance between internal desires and external realities. This is a work that challenges the reader to reconsider preconceived notions and to engage with the text on a deeply personal level."
]

books.each do |book|
  Review.create!(
      content: quotes.sample,
      rating: rand(1.0..5.0).round(1),
      emotion: emotions.sample,
      user: users.sample,
      book: book
    )
end

puts "Everything is created!"
