require "sqlite3"
DB = SQLite3::Database.new(File.join(File.dirname(__FILE__), 'db/jukebox.sqlite'))

def display_all
  query = <<-SQL
    SELECT artists.name as art, artists.id
    FROM artists
    ORDER BY art ASC
  SQL
  DB.execute(query)
end

def display_albums(id)
  query = <<-SQL
    SELECT albums.title as alb, albums.id
    FROM albums
    WHERE albums.artist_id = "#{id}"
    ORDER BY alb ASC
  SQL
  DB.execute(query)
end

def display_tracks(album_id)
  query = <<-SQL
    SELECT tracks.name as track, tracks.id
    FROM tracks
    WHERE tracks.album_id = "#{album_id}"
    ORDER BY track ASC
  SQL
  DB.execute(query)
end

def track_from_id(track_id)
  query = <<-SQL
    SELECT tracks.name as track
    FROM tracks
    WHERE tracks.id = "#{track_id}"
    ORDER BY track ASC
  SQL
  DB.execute(query)
end
