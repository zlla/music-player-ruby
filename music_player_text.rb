require './input_functions.rb'
require 'colorize'
require 'gosu'
require 'rubygems'

module Genre
	POP, CLASSIC, JAZZ, ROCK = *1..4
end

class Album
	attr_accessor :artist, :name, :date, :genre, :tracks

	def initialize(artist, name, date, genre, tracks)
		@artist = artist
		@name = name
		@date = date
		@genre = genre
		@tracks = tracks
	end
end

class Track
	attr_accessor :name, :location

	def initialize (name, location)
		@name = name
		@location = location
	end
end

def read_track(music_file)
	name = music_file.gets()
  	location = music_file.gets()
  	track = Track.new(name, location)
end

def read_tracks(music_file)
	count = music_file.gets().to_i()
	tracks = Array.new()
	i = 0
  	while (i < count)
		track = read_track(music_file)
  	  	tracks << track
  	  	i+=1
  	end

	return tracks
end

def read_album(music_file)
	artist = music_file.gets()
	name = music_file.gets()
	date = music_file.gets().to_i
	genre = music_file.gets().to_i
	tracks = read_tracks(music_file)
	album = Album.new(artist, name, date, genre, tracks)
end

def read_albums(file_name)
	music_file = File.new(file_name, "r") # open for reading
	albums = Array.new()
	count = music_file.gets().to_i
	i = 0
	begin
		album = read_album(music_file)
		albums << album
		i+=1
	end while(i<count)

  	music_file.close()
	return albums
end

def animation()
	@perc = 0
	t = Thread.new { loop do ; @perc += 1 ; sleep 0.050 ; end }  
	until @perc == 100   
		puts "Loading: (" + @perc.to_s + "%)"
	  	print "\r\e[A"
	  	sleep 0.050
	end
	t.kill
	system("clear")
	puts "Loading: (100%)"
	print "\r\e[A"  
	puts "\nComplete !"
end

