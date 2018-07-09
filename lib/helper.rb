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

def find_artist(id)
  query = <<-SQL
    SELECT artists.name
    FROM artists
    WHERE artists.id = ?
  SQL
  DB.execute(query, id)
end

def find_artist_by_name(artist_name)
  query = <<-SQL
    SELECT artists.id
    FROM artists
    WHERE artists.name like ?
  SQL
  DB.execute(query, "%#{artist_name}%")[0]
end

def find_track_by_name(track_name)
  query = <<-SQL
    SELECT tracks.id
    FROM tracks
    WHERE tracks.name like ?
  SQL
  DB.execute(query, "%#{track_name}%")[0]
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

def all_from_genre(genre_id)
  query = <<-SQL
    SELECT genres.name, artists.name, genres.id, artists.id
    FROM artists
    JOIN albums ON albums.artist_id = artists.id
    JOIN tracks ON tracks.album_id = albums.id
    JOIN genres ON tracks.genre_id = genres.id
    WHERE genres.id = "#{genre_id}"
    GROUP BY artists.name
  SQL
  DB.execute(query)
end

def get_genre_id(genre_name)
  query = <<-SQL
    SELECT genres.id
    FROM genres
    WHERE genres.name = "#{genre_name}"
  SQL
  DB.execute(query).join
end

def random_track_id(genre = nil)
  if genre
    query = <<-SQL
      SELECT tracks.id
      FROM tracks
      JOIN genres ON tracks.genre_id = genres.id
      WHERE genres.name = "#{genre}"
    SQL
  else
    query = <<-SQL
      SELECT tracks.id
      FROM tracks
    SQL
  end
  data = DB.execute(query)
  random_id = data.sample[0]
end
