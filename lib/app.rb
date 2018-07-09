require "sinatra"
require "sinatra/reloader" if development?
require "sqlite3"
require_relative "helper.rb"
require_relative "scrapper.rb"

DB = SQLite3::Database.new(File.join(File.dirname(__FILE__), 'db/jukebox.sqlite'))
set :port, 1111
get "/" do
  @artists = display_all
  # TODO: Gather all artists to be displayed on home page
  erb :home
end

get "/artists/:id" do
  @albums = display_albums(params[:id].to_i)
  @artist = find_artist(params[:id].to_i)
  # TODO: Gather all artists to be displayed on home page
  erb :artist_page
end

get "/albums/:id" do
  # @test = params
  @tracks = display_tracks(params[:id].to_i)
  # erb :test
  erb :album_page
end

get "/tracks/:id" do
  # @test = params
  @track = track_from_id(params[:id].to_i)
  @embed_url = generate_embed_url(scrape_youtube(@track[0][0].to_s))
  # @test = @track[0][0].to_s
  # erb :test
  erb :track_page
end

get "/genres/:id" do
  @artists_f_genre = all_from_genre(params[:id].to_i)

  erb :genre_page
end

get "/random" do
  @random_all = random_track_id
  @random_rock = random_track_id("Rock")
  @random_classical = random_track_id("Classical")
  erb :random
end

post '/search' do
  search = params["search"].to_s
  artist_id = find_artist_by_name(search)
  track_id = find_track_by_name(search) unless artist_id
  if artist_id
    string = "/artists/#{artist_id[0]}"
  elsif track_id
    string = "/tracks/#{track_id[0]}"
  else
    string = "/" # Add NOT FOUND page
  end
  redirect string
end
