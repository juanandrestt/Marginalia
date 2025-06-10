require "json"
require "open-uri"
require "faker"

puts "Creating books..."

query = ["fiction"]

url = "https://www.googleapis.com/books/v1/volumes?q=subject:#{query}&maxResults=40"
excluded_patterns = [
  /university\s+press/i,
  /bod\s*[-–—]?\s*books\s+on\s+demand/i
]

begin
  serialized = URI.open(url).read
  data = JSON.parse(serialized)

  data["items"].each_with_index do |item, index|
    next if Book.exists?(open_library_id: item[:id])

    volume = item["volumeInfo"]
    publisher = volume['publisher'] || ""
    next if excluded_patterns.any? { |regex| publisher.match?(regex)}
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
    )

    book.save! if book.cover.attached?
    puts "Book #{index + 1}: #{title} created"
  end
rescue => e
  puts "Failed to fetch from Google Books API: #{e.message}"
end

puts "Books created. Now creating users..."

usernames = ["Anthony", "Juan", "Samuel", "Isabela", "Julie", "Maria", "Edouard", "Clarice", "Gabriel"]
users = usernames.map do |username|
  email = "#{username.downcase}@mail.com"

  User.find_or_create_by!(email: email) do |user|
    user.username = username
    user.password = "password"
    user.password_confirmation = "password"
    user.username = "#{username}"
    user.avatar = ""
  end
end

puts "Users created. Now creating lists..."

users.each do |user|
  unless user.lists.exists?(name: "My favorite books")
    list = List.create!(
      name: "My favorite books",
      user: user
    )
    list.books << Book.all.sample(5)
  end
end

puts "Lists created. Now creating bookmarks..."

bookmark = Bookmark.new(
  list: List.all.sample,
  book: Book.all.sample
)
bookmark.save if bookmark.valid?


puts "Bookmarks created. Now creating reviews..."

emotions = ["Happy", "Sad", "Excited", "Grateful", "Angry", "Bored",]
quotes = [
  "Written by an AI.",
  "Too long, too dense, but something kept me going until the end.",
  "I didn't understand everything, but I felt every word.",
  "This book is a mirror — and I wasn't ready to look.",
  "I hated every character and yet couldn't stop reading. That says something.",
  "I started it with no expectations, and finished it in tears.",
  "An emotional journey that left me with a lump in my throat.",
  "Impossible to categorize. Even harder to forget.",
  "It took me four months to read it, and you don't come out unscathed from such a prolonged exposure to such brutal literature.",
  "A labyrinthine and total book, superbly written.",
  "Can we free ourselves from our origins without betraying them? This subtle and vivid story shows that we never quite escape what shaped us — but we can learn to see it differently. A triumph.",
  "I'm crying like a wreck and I can't stop.",
  "This book doesn't just tell a story; it builds a whole universe, both intimate and vast. The prose is careful, the pacing deliberate, and each character breathes with a rare authenticity. It's not an easy read, but it's profoundly rewarding.",
  "This book doesn't just tell a story; it builds a whole universe, both intimate and vast. The prose is careful, the pacing deliberate, and each character breathes with a rare authenticity. It's not an easy read, but it's profoundly rewarding.",
  "As I turned the pages, I felt like I was rereading fragments of my own life, put into words with a haunting precision. This book doesn't just tell a story — it tells *your* story. And that's rare.",
  "In a narrative that unfolds with the deliberate pace of a slow-burning fuse, the author crafts a tapestry of lives intertwined by fate and circumstance. The prose, both lyrical and precise, invites readers to linger over each sentence, savoring the nuances of character and setting. Themes of loss, redemption, and the inexorable passage of time permeate the work, offering a meditation on the human condition that is as profound as it is poignant.",
  "The author's exploration of identity and belonging is both timely and timeless. Through a series of interconnected stories, the narrative delves into the complexities of cultural assimilation and the subtle fractures that occur when personal history collides with societal expectations. The writing is at once sharp and empathetic, capturing the dissonance between internal desires and external realities. This is a work that challenges the reader to reconsider preconceived notions and to engage with the text on a deeply personal level."
]

Book.order(created_at: :desc).limit(40).each do |book|
  Review.create!(
      content: quotes.sample,
      rating: rand(1..5),
      emotion: emotions.sample,
      user: users.sample,
      book: book
    )
end

puts "Reviews created. Now creating bookclubs..."

users.each do |user|
  next if user.bookclubs.present?
  Bookclub.create!(
    name: "#{user.username}'s Book Club",
    user: user,
    book: Book.all.sample
  )
end

puts "Bookclubs created!"
puts "Everything is created!"
