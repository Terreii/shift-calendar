# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

year = Date.current.year

# Add Baden-Wuerttemberg holidays
Holiday.create([
  { name: "Neujahr", date: Date.new(year, 1, 1) },
  { name: "Heilige Drei Könige", date: Date.new(year, 1, 6) },
  { name: "Karfreitag", date: Date.new(year, 4, 15) },
  { name: "Ostermontag", date: Date.new(year, 4, 18) },
  { name: "Tag der Arbeit", date: Date.new(year, 5, 1) },
  { name: "Christi Himmelfahrt", date: Date.new(year, 5, 26) },
  { name: "Pfingstmontag", date: Date.new(year, 6, 6) },
  { name: "Fronleichnam", date: Date.new(year, 6, 16) },
  { name: "Tag der Deutschen Einheit", date: Date.new(year, 10, 3) },
  { name: "Allerheiligen", date: Date.new(year, 11, 1) },
  { name: "1. Weihnachtsfeiertag", date: Date.new(year, 12, 25) },
  { name: "2. Weihnachtsfeiertag", date: Date.new(year, 12, 26) }
])

# Add Baden-Wuerttemberg school breaks
SchoolBreak.create([
  { name: "Herbstferien",     duration: Date.new(year, 10, 31)..Date.new(year, 11, 4) },
  { name: "Weihnachtsferien", duration: Date.new(year, 12, 21)..Date.new(year + 1, 1, 7) },
  { name: "Osterferien",      duration: Date.new(year + 1, 4, 6)..Date.new(year + 1, 4, 15) },
  { name: "Pfingstferien",    duration: Date.new(year + 1, 5, 30)..Date.new(year + 1, 6, 9) },
  { name: "Sommerferien",     duration: Date.new(year + 1, 7, 27)..Date.new(year + 1, 9, 9) }
])
