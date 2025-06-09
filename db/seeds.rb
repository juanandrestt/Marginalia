require "json"
require "open-uri"
require "faker"

puts "Creating books..."

query = "poetry"

url = "https://www.googleapis.com/books/v1/volumes?q=subject:#{query}&maxResults=40"

begin
  serialized = URI.open(url).read
  data = JSON.parse(serialized)

  data["items"].each_with_index do |item, index|
    next if Book.exists?(open_library_id: item[:id])

    volume = item["volumeInfo"]
    title = volume["title"]
    author = volume["authors"]&.first || "Unknown Author"
    publishing_year = volume["publishedDate"]&.slice(0, 4)
    description = volume["description"] || "No description available"
    cover_url = volume.dig("imageLinks", "thumbnail")&.gsub("http:", "https:")

    next unless cover_url

    book = Book.new(
      title: title,
      author: author,
      publishing_year: publishing_year,
      open_library_id: item["id"],
      description: description,
      cover_url: cover_url,
      subjects: query,
      characters: nil
    )

    book.cover.attach(
      io: URI.open(cover_url),
      filename: "cover_#{title.parameterize}.jpg",
      content_type: "image/jpeg"
    ) if cover_url

    book.save! if book.cover.attached?
    puts "Book #{index + 1}: #{title} created"
  end
rescue => e
  puts "Failed to fetch from Google Books API: #{e.message}"
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

bookmark = Bookmark.new(
  list: List.all.sample,
  book: Book.all.sample
)
bookmark.save if bookmark.valid?


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

puts "Reviews created. Now creating bookclubs..."

users.each do |user|
  book = Book.all.sample
  Bookclub.create!(
    name: "#{user.username}'s Book Club",
    user: user,
    book: book
  )
end

puts "Bookclubs created!"
puts "Everything is created!"
