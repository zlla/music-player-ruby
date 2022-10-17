require './input_functions.rb'
require 'colorize'

module Genre
	POP, CLASSIC, JAZZ, ROCK = *1..4
end

$genre_names = ['Null', 'Pop', 'Classic', 'Jazz', 'Rock']

class String
def black;          "\e[30m#{self}\e[0m" end
def red;            "\e[31m#{self}\e[0m" end
def green;          "\e[32m#{self}\e[0m" end
def brown;          "\e[33m#{self}\e[0m" end
def blue;           "\e[34m#{self}\e[0m" end
def magenta;        "\e[35m#{self}\e[0m" end
def cyan;           "\e[36m#{self}\e[0m" end
def gray;           "\e[37m#{self}\e[0m" end

def bg_black;       "\e[40m#{self}\e[0m" end
def bg_red;         "\e[41m#{self}\e[0m" end
def bg_green;       "\e[42m#{self}\e[0m" end
def bg_brown;       "\e[43m#{self}\e[0m" end
def bg_blue;        "\e[44m#{self}\e[0m" end
def bg_magenta;     "\e[45m#{self}\e[0m" end
def bg_cyan;        "\e[46m#{self}\e[0m" end
def bg_gray;        "\e[47m#{self}\e[0m" end
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

	def play_music
		link = "'#{(@location).delete!("\n")}'"
		pid = fork{ exec 'afplay', @location}
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

def print_track(track, id)
	puts("#{id+1} - #{track.name}")
end

def print_tracks(tracks)
	count = tracks.length
	puts("Track List:")
  	i = 0
  	while (i < count)
		print_track(tracks[i], i)
  	  	i+=1
  	end
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

def print_album(album, album_id)
	puts("Album ID: #{album_id + 1}                                       ".bg_blue.black)
	puts("-=#{$genre_names[album.genre]}=-")
	puts("> #{album.name.delete("\n")} by  #{album.artist.delete("\n")}")
	puts("--------------------------------------------------")
end

def print_albums(albums)
	count = albums.length
	finished = false
	begin
		puts("Display Album")
		puts("1 - Display All")
		puts("2 - Display Genre")
		number_of_select_print = read_integer_in_range("Option: ", 1, 2)
		system("clear")
		if (number_of_select_print == 1)
			puts("Albums                                            ".bg_green.black)
			i = 0
			begin
				print_album(albums[i], i)
				i+=1
			end while (i<count)
			print("Press Enter to continue.")
			gets()
		elsif (number_of_select_print == 2)
			puts("Select Genre")
			loop_in_genre_names = 0
			begin
				if (loop_in_genre_names == 0)
					loop_in_genre_names+=1
					next
				end
				puts("#{loop_in_genre_names} - #{$genre_names[loop_in_genre_names]}")
				loop_in_genre_names+=1
			end while (loop_in_genre_names < $genre_names.length)
			select_genre = read_integer_in_range("Option: ", 1, ($genre_names.length-1))
			system("clear")
			loop_in_albumn = 0
			check_print = false
			case select_genre
			when 0
				while(loop_in_albumn < albums.length)
					if(albums[loop_in_albumn].genre == select_genre)
						print_album(albums[loop_in_albumn], loop_in_albumn)
						check_print = true
					end
					loop_in_albumn+=1
				end
				if (check_print == false)
					puts("There are no albums available for this genre at the moment.")
				end
				print("Press Enter to continue.")
				gets()
			when 1
				while(loop_in_albumn < albums.length)
					if(albums[loop_in_albumn].genre == select_genre)
						print_album(albums[loop_in_albumn], loop_in_albumn)
						check_print = true
					end
					loop_in_albumn+=1
				end
				if (check_print == false)
					puts("There are no albums available for this genre at the moment.")
				end
				print("Press Enter to continue.")
				gets()
			when 2
				while(loop_in_albumn < albums.length)
					if(albums[loop_in_albumn].genre == select_genre)
						print_album(albums[loop_in_albumn], loop_in_albumn)
						check_print = true
					end
					loop_in_albumn+=1
				end
				if (check_print == false)
					puts("There are no albums available for this genre at the moment.")
				end
				print("Press Enter to continue.")
				gets()
			when 3
				while(loop_in_albumn < albums.length)
					if(albums[loop_in_albumn].genre == select_genre)
						print_album(albums[loop_in_albumn], loop_in_albumn)
						check_print = true
					end
					loop_in_albumn+=1
				end
				if (check_print == false)
					puts("There are no albums available for this genre at the moment.")
				end
				print("Press Enter to continue.")
				gets()
			end
		end
	end
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

def play(albums, album_index, track_index)
	system("clear")
	animation()
	albums[album_index].tracks[track_index].play_music()
	puts("Playing")
	puts("Album: #{albums[album_index].name}")
	puts(albums[album_index].tracks[track_index].name)
	puts("Press enter to continue")
	gets()
end
	
def play_by_id(albums)
	system("clear")
	get_album_id = read_integer_in_range("Album ID: ", 1, (albums.length))
	get_album_id-=1
	puts("Track list:")
	i = 0
	begin
		puts("#{i+1} - #{albums[get_album_id].tracks[i].name}")
		i+=1
	end while (i < albums[get_album_id].tracks.length)
	get_track = read_integer_in_range("Play Track: ", 1, (albums[get_album_id].tracks.length))
	get_track-=1
	play(albums, get_album_id, get_track)
end

def search(albums)
	puts("Search for Album")
	puts("1 - Search by Genre")
	puts("2 - Search by Title")
	type_search = read_integer_in_range("Option: ", 1, 2)
	if (type_search == 1)
		puts("Select Genre")
		i = 0
		begin
			if (i == 0)
				i+=1
				next
			end
			puts("#{i} - #{$genre_names[i]}")
			i+=1
		end while(i < $genre_names.length)
		type_genre = read_integer_in_range("Option: ", 1, ($genre_names.length-1))
		system("clear")
		list_id_search = Array.new()
		run = false
		puts("Albums")
		i = 0
		while(i < albums.length)
			if(albums[i].genre == type_genre)
				print_album(albums[i], i)
				list_id_search << i
				run = true
			end
			i+=1
		end
		if (run)
			select_album = read_integer("Play Album ID: ")
			select_album-=1
			i = 0
			check = true
			while (check)
				while (i < list_id_search.length)
					if (select_album == list_id_search[i])
						check = false
					end
					i+=1
				end
				if (check == false)
					break
				end
				puts("The ID you just selected is another music genre, please choose again")
				select_album = read_integer("Play Album ID: ")
				select_album-=1
				i = 0
			end
			print_tracks(albums[select_album].tracks)
			select_play = read_integer_in_range("Play Track: ", 1, albums[select_album].tracks.length)
			select_play-=1
			play(albums, select_album, select_play)
		elsif (run == false)
			puts("There aren't any tracks in the album")
		end

	elsif (type_search == 2)
		print("Title: ")
		title_search = gets()
		found = false
		i = 0
		begin
			if (albums[i].name == title_search)
				found = true
				print_tracks(albums[i].tracks)
				play_track = read_integer_in_range("Play Track: ", 1, albums[i].tracks.length)
				play_track-=1
				play(albums, i, play_track)
				break
			end
			i+=1
		end while(i < albums.length)
		if (found == false)
			puts("Album not found!")
			print("Press enter to continue")
			gets()
		end
	end
end

def update_album(albums)
	puts("Update Album")
	puts("Update an album's info'")
	select_album = read_integer_in_range("Album ID: ", 1, albums.length)
	select_album-=1
	system("clear")
	puts("Update Album")
	puts("1 - Update Title")
	puts("2 - Update Genre")
	puts("3 - Update Track")
	select_update = read_integer_in_range("Option: ", 1, 3)
	case select_update
	when 1
		system("clear")
		puts("Current title album: #{albums[select_album].name}")
		puts("Update Title Album")
		new_title_album = read_string("Title: ")
		albums[select_album].name = new_title_album
		system("clear")
		puts("Changed !")
		print_album(albums[select_album], select_album)
	when 2
		system("clear")
		puts("Current genre: #{albums[select_album].genre}")
		puts("Update Genre")
		i = 1
		while (i < $genre_names.length)
			puts("#{i} - #{$genre_names[i]}")
			i+=1
		end
		select_genre = read_integer_in_range("Option: ", 1, 5)
		albums[select_album].genre = select_genre
		system("clear")
		puts("Changed !")
		print_album(albums[select_album], select_album)
	when 3
		system("clear")
		puts("Select Track")
		print_tracks(albums[select_album].tracks)
		select_track = read_integer_in_range("Option: ", 1, albums[select_album].tracks.length)
		select_track-=1
		system("clear")
		puts("Update Track")
		puts("1 - Title")
		puts("2 - Filename")
		option_track  = read_integer_in_range("Option: ", 1, 2)
		if (option_track == 1)
			albums[select_album].tracks[select_track].name = read_string("Title: ")
			system("clear")
			print_album(albums[select_album], select_album)
			print_tracks(albums[select_album].tracks)
		elsif (option_track == 2)
			albums[select_album].tracks[select_track].location = read_string("Filename: ")
			system("clear")
			puts("Changed !")
		end
	end

end

def main()
	finished = false
	check = false

	begin
		system("clear")
		puts("       TEXT MUSIC PLAYER       ".bg_green.black)
		puts("   Main Menu:                  ".bg_red.black)
		puts("1 - Read in Album              ".bg_magenta.black)
		puts("2 - Display Album info         ".bg_magenta.black)
		puts("3 - Play Album                 ".bg_magenta.black)
		puts("4 - Update Album               ".bg_magenta.black)
		puts("5 - Exit                       ".bg_magenta.black)
		choice = read_integer_in_range("Please enter your choice: ", 1, 5)
		case choice
		when 1
			begin
				system("clear")
				file_name = read_string("File Name: ")
				albums = read_albums(file_name)
			rescue
				print "Wrong input ! try again."
				gets()
				system("clear")
				retry
			end
			animation()
			print("Press Enter to continue...")
			gets()
			check = true
		when 2
			if (check)
				system("clear")
				print_albums(albums)
			else
				puts("Please select option 1 first")
				print("Press Enter to continue.")
				gets()
				system("clear")
			end
    	when 3
			if (check)
				system("clear")
				puts("1 - Play by ID")
				puts("2 - Search")
				select_type_play = read_integer_in_range("Option: ", 1, 2)
				if (select_type_play == 1)
					play_by_id(albums)
				elsif (select_type_play == 2)
					search(albums)
				end
			else
				puts("Please select option 1 first")
				print("Press Enter to continue.")
				gets()
				system("clear")
			end
		when 4
			if (check)
				update_album(albums)
			else
				puts("Please select option 1 first")
				print("Press Enter to continue.")
				gets()
				system("clear")
			end
		when 5
			finished = true
			puts("           Goodbye !           ".bg_blue.black)
			gets()
    	else
			puts('Please select again')
    	end
	end until finished
end

main()