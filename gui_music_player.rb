require 'rubygems'
require 'gosu'
require './music_player_text.rb'

TOP_COLOR = Gosu::Color.new(0xFF1EB1FA)
BOTTOM_COLOR = Gosu::Color.new(0xFF1D4DB5)
BACKGROUND_HEIGHT = 800

module ZOrder
	BACKGROUND, PLAYER, UI = *0..2
end

module Genre
	POP, CLASSIC, JAZZ, ROCK = *1..4
end

GENRE_NAMES = ['Null', 'Pop', 'Classic', 'Jazz', 'Rock']

class ArtWork
	attr_accessor :bmp

	def initialize (file)
		@bmp = Gosu::Image.new(file)
	end
end

class MusicPlayerMain < Gosu::Window

	def initialize
		super 600, 800
		self.caption = "Music Player"
		@background = TOP_COLOR
		@change_page = 0
		@album_text = Gosu::Font.new(self, "Space mono", 40)
		@track_text = Gosu::Font.new(self, "Space mono", 30)
		@file_has_loaded = 0
		@albums = Array.new
		while @file_has_loaded != 1 do
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
			@albums = read_albums(file_name)
			@file_has_loaded = 1
		end		  
		@song
		@y_possition_scroll = 0
		@y_possition_scroll_track = 0
		@check_scroll = 0
		@check_scroll_track = 0
		@select_album = -1
		@select_track = -1
		@list_imgs = Array.new(@albums.length)
		@hover_album_p1 = Gosu::Color.new(0x00FFFFFF)
		@hover_album_p2 = Gosu::Color.new(0x00FFFFFF)
		@hover_album_p3 = Gosu::Color.new(0x00FFFFFF)
		@hover_back_btn = Gosu::Color.new(0x00FFFFFF)
		@tracks_color = Array.new(@albums[@select_album].tracks.length)
		@navi_btn_color_1 = Gosu::Color::RED
		@navi_btn_color_2 = Gosu::Color::RED
		@check_play = true
	end

	def update
		if @change_page == 0
			get_number_to_hover = mouse_over_position_p1(mouse_x, mouse_y)
			case get_number_to_hover
			when 1
				@hover_album_p1 = Gosu::Color.new(0x1AFFFFFF)
				@hover_album_p2 = Gosu::Color.new(0x00FFFFFF)
				@hover_album_p3 = Gosu::Color.new(0x00FFFFFF)
			when 2
				@hover_album_p2 = Gosu::Color.new(0x1AFFFFFF)
				@hover_album_p1 = Gosu::Color.new(0x00FFFFFF)
				@hover_album_p3 = Gosu::Color.new(0x00FFFFFF)
			when 3
				@hover_album_p3 = Gosu::Color.new(0x1AFFFFFF)
				@hover_album_p1 = Gosu::Color.new(0x00FFFFFF)
				@hover_album_p2 = Gosu::Color.new(0x00FFFFFF)
			else
				@hover_album_p1 = Gosu::Color.new(0x00FFFFFF)
				@hover_album_p2 = Gosu::Color.new(0x00FFFFFF)
				@hover_album_p3 = Gosu::Color.new(0x00FFFFFF)
			end
		end

		if @change_page == 1
			if (mouse_over_position_p2(mouse_x, mouse_y) == true)
				@hover_back_btn = Gosu::Color.new(0x4DFFFFFF)
			else
				@hover_back_btn = Gosu::Color.new(0x00FFFFFF)
			end

			i = 0
			while (i < @albums[@select_album].tracks.length)
				if (mouse_over_position_p2(mouse_x, mouse_y) == i)
					@tracks_color[i] = Gosu::Color::YELLOW
				else
					@tracks_color[i] = Gosu::Color::WHITE
				end
				i+=1
			end
		end

		if @change_page == 0 or @change_page == 1 or @change_page == 3
			if (check_navi_btn(mouse_x, mouse_y) == 1)
				@navi_btn_color_1 = Gosu::Color::WHITE
				@navi_btn_color_2 = Gosu::Color::RED
			elsif (check_navi_btn(mouse_x, mouse_y) == 2)
				@navi_btn_color_2 = Gosu::Color::WHITE
				@navi_btn_color_1 = Gosu::Color::RED
			else
				@navi_btn_color_1 = Gosu::Color::RED
				@navi_btn_color_2 = Gosu::Color::RED
			end
		end


		def button_down(id)
			if @change_page == 0
				if id == Gosu::MsWheelDown
					if (@albums.length > 3)
						time_scroll = @albums.length - 3
						if (@check_scroll < time_scroll)
							@y_possition_scroll -= 250
							@check_scroll+=1
						end
					end
				end
				if id == Gosu::MsWheelUp
					if (@check_scroll > 0)
						@y_possition_scroll += 250
						@check_scroll-=1
					end
				end

				if id == Gosu::MsLeft
					if (mouse_over_position_p1(mouse_x, mouse_y) != -1)
						@select_album += (mouse_over_position_p1(mouse_x, mouse_y) + @check_scroll)
						@change_page = 1
						@background = Gosu::Color.new(0xFF283655)
						i = 0
						while (i < @albums[@select_album].tracks.length)
							@tracks_color[i] = Gosu::Color::WHITE
							i+=1
						end
					end

					if (check_navi_btn(mouse_x, mouse_y) == 1)
						@background = TOP_COLOR
						@change_page = 0
						@select_album = -1
						@select_track = -1
						@check_scroll_track = 0
						@check_scroll = 0
						@y_possition_scroll = 0
						@y_possition_scroll_track = 0
					elsif (check_navi_btn(mouse_x, mouse_y) == 2)
						@background = Gosu::Color.new(0xFF283655)
						@change_page = 3
					end
				end

			elsif @change_page == 1
				if id == Gosu::MsWheelDown
					if (@albums[@select_album].tracks.length > 6)
						time_scroll = @albums[@select_album].tracks.length - 6
						if (@check_scroll_track < time_scroll)
							@y_possition_scroll_track -= 50
							@check_scroll_track+=1
						end
					end
				end
				if id == Gosu::MsWheelUp
					if (@check_scroll_track > 0)
						@y_possition_scroll_track += 50
						@check_scroll_track-=1
					end
				end

				if id == Gosu::MsLeft
					if (mouse_y > 470 and mouse_y < 470 + 50*6)
						if (mouse_x < 550 and mouse_x > 0)
							@select_track = (mouse_over_position_p2(mouse_x, mouse_y))
							@change_page = 2
							@check_play = true
							@song = Gosu::Song.new(@albums[@select_album].tracks[@select_track].location.chomp) 
							@song.play
						end

						if (mouse_x > 550 and mouse_x < 600)
							track_current = check_favourite_track(mouse_x, mouse_y)
							puts(@albums[@select_album].tracks[track_current].name)
						end
					end

					if (mouse_over_position_p2(mouse_x, mouse_y) == true)
						@background = TOP_COLOR
						@change_page = 0
						@y_possition_scroll = 0
						@y_possition_scroll_track = 0
						@check_scroll = 0
						@check_scroll_track = 0
						@select_album = -1
						@select_track = -1
					end

					if (check_navi_btn(mouse_x, mouse_y) == 1)
						@background = TOP_COLOR
						@change_page = 0
						@y_possition_scroll = 0
						@y_possition_scroll_track = 0
						@check_scroll = 0
						@check_scroll_track = 0
						@select_album = -1
						@select_track = -1
					elsif (check_navi_btn(mouse_x, mouse_y) == 2)
						@change_page = 3
					end
				end

			elsif @change_page == 2
				if id == Gosu::MsLeft
					if (back_btn_in_p3(mouse_x, mouse_y) == true)
						@background = Gosu::Color.new(0xFF283655)
						@change_page = 1
					end

					if (mouse_over_position_p3(mouse_x, mouse_y) == false)
						@check_play = false
						@song.pause
					elsif (mouse_over_position_p3(mouse_x, mouse_y) == true)
						@check_play = true
						@song.play
					end

					if (mouse_over_position_p3(mouse_x, mouse_y) == 1)
						if (@select_track > 0)
							@select_track-=1
							@song = Gosu::Song.new(@albums[@select_album].tracks[@select_track].location.chomp) 
							@song.play
						end
					elsif (mouse_over_position_p3(mouse_x, mouse_y) == 2)
						if (@select_track < @albums[@select_album].tracks.length)
							@select_track+=1
							@song = Gosu::Song.new(@albums[@select_album].tracks[@select_track].location.chomp) 
							@song.play
						end
					end
				end

			elsif @change_page == 3
				if id == Gosu::MsLeft
					if (check_navi_btn(mouse_x, mouse_y) == 1)
						@background = TOP_COLOR
						@change_page = 0
						@y_possition_scroll = 0
						@y_possition_scroll_track = 0
						@check_scroll = 0
						@check_scroll_track = 0
						@select_album = -1
						@select_track = -1
					elsif (check_navi_btn(mouse_x, mouse_y) == 2)
						@background = Gosu::Color.new(0xFF283655)
						@change_page = 3
					end

				end
			end

		end
	end

	def mouse_over_position_p1(mouse_x, mouse_y)
		if ((mouse_x > 0 and mouse_x < 600) and (mouse_y > 0 and mouse_y < 250))
			return 1
		elsif ((mouse_x > 0 and mouse_x < 600) and (mouse_y > 250 and mouse_y < 500))
			return 2 
		elsif ((mouse_x > 0 and mouse_x < 600) and (mouse_y > 500 and mouse_y < 750))
			return 3 
		else
			return -1
		end
	end

	def mouse_over_position_p2(mouse_x, mouse_y)
		number_to_play = 0
		distance_top = 0
		distance_bot = 50
		back_btn = false
		if (mouse_x > 0 and mouse_x < 60) and (mouse_y > 0 and mouse_y < 60)
			return back_btn = true
		end
		if (mouse_x < 550)
			while (number_to_play < @albums[@select_album].tracks.length)
				if ((mouse_x > 0) and (mouse_y > 470 + distance_top and mouse_y < 470 + distance_bot))
					return number_to_play + @check_scroll_track
				end
				distance_top += 50
				distance_bot += 50
				number_to_play+=1
			end
		end
	end

	def back_btn_in_p3(mouse_x, mouse_y)
		back_btn = false
		if (mouse_x > 0 and mouse_x < 60) and (mouse_y > 0 and mouse_y < 60)
			return back_btn = true
		end
	end

	def mouse_over_position_p3(mouse_x, mouse_y)
		if (mouse_x > 50 and mouse_x < 150) and (mouse_y > 620 and mouse_y < 720)
			return 1
		end

		if (mouse_x > 450 and mouse_x < 550) and (mouse_y > 620 and mouse_y < 720)
			return 2
		end

		if (@check_play == true)
			if (mouse_x > 225 and mouse_x < 375) and (mouse_y > 600 and mouse_y < 750)
				return false
			end
		end
		if (@check_play == false)
			if (mouse_x > 225 and mouse_x < 375) and (mouse_y > 600 and mouse_y < 750)
				return true
			end
		end
	end

	def check_favourite_track(mouse_x, mouse_y)
		number_favourite = 0
		distance_top = 0
		distance_bot = 50
		if (mouse_x > 550)
			while (number_favourite < @albums[@select_album].tracks.length)
				if ((mouse_x < 600) and (mouse_y > 470 + distance_top and mouse_y < 470 + distance_bot))
					return number_favourite + @check_scroll_track
				end
				distance_top += 50
				distance_bot += 50
				number_favourite+=1
			end
		end
	end

	def check_navi_btn(mouse_x, mouse_y)
		if (mouse_x > 0 and mouse_x < 300) and (mouse_y > 750 and mouse_y < 800)
			return 1
		elsif (mouse_x > 300 and mouse_x < 600) and (mouse_y > 750 and mouse_y < 800)
			return 2
		else
			return -1
		end
	end

	def needs_cursor?; true; end

	def draw_background
		Gosu.draw_rect(0, 0, 600, BACKGROUND_HEIGHT, @background, ZOrder::BACKGROUND, mode=:default)
	end

	def draw_navi
		Gosu.draw_rect(0, 750, 600, 50, Gosu::Color::RED, ZOrder::UI, mode=:default)
		Gosu.draw_rect(0, 750, 300, 50, @navi_btn_color_1, ZOrder::UI, mode=:default)
		Gosu.draw_rect(300, 750, 300, 50, @navi_btn_color_2, ZOrder::UI, mode=:default)
		home_btn = ArtWork.new("./btn_function_imgs/home.png")
		home_btn.bmp.draw(120, 750, 2, 0.097, 0.097)
		heart_btn = ArtWork.new("./btn_function_imgs/heart.png")
		heart_btn.bmp.draw(430, 750, 2, 0.097, 0.097)
	end

	def draw_menu_albums()
		Gosu.draw_rect(0, 0, 600, 250, @hover_album_p1, ZOrder::UI, mode=:default)
		Gosu.draw_rect(0, 250, 600, 250, @hover_album_p2, ZOrder::UI, mode=:default)
		Gosu.draw_rect(0, 500, 600, 250, @hover_album_p3, ZOrder::UI, mode=:default)
		@y_possition_text = 50
		i = 0
		while (i < @albums.length)
			@album_text.draw(@albums[i].name, 270, @y_possition_text + @y_possition_scroll, ZOrder::PLAYER, 1.0, 1.0, Gosu::Color::WHITE)
			@album_text.draw(@albums[i].date, 270, @y_possition_text + @y_possition_scroll + 40, ZOrder::PLAYER, 1.0, 1.0, Gosu::Color::WHITE)
			@y_possition_text+=250
			i+=1
		end
		
		i = 0
		while (i < @albums.length)
			@album = ArtWork.new("./images/" + "#{i+1}".to_s + ".bmp")
			@list_imgs[i] = @album
			i+=1
		end

		@y_possition_img = 0
		i = 0
		while (i < @albums.length)
			@list_imgs[i].bmp.draw(0, @y_possition_img + @y_possition_scroll, 0)
			@y_possition_img+=250
			i+=1
		end
	end

	def draw_album()
		heart_btn = ArtWork.new("./btn_function_imgs/heart.png")
		Gosu.draw_rect(0, 0, 600, 470, Gosu::Color.new(0xFF283655), ZOrder::UI, mode=:default)
		Gosu.draw_rect(0, 0, 60, 60, @hover_back_btn, ZOrder::UI, mode=:default)
		back_btn = ArtWork.new("./btn_function_imgs/backbtn1.png")
		back_btn.bmp.draw(0, 0, 2, 0.115, 0.115)
		@list_imgs[@select_album].bmp.draw(175, 40, 2)
		title = Gosu::Font.new(self, "Space mono", 35)
		title.draw("#{@albums[@select_album].name.chomp} by #{@albums[@select_album].artist}" , 70, 320, ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
		genre = Gosu::Font.new(self, "Space mono", 30)
		genre.draw("Genre: #{GENRE_NAMES[@albums[@select_album].genre]}", 70, 350, ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
		possition_track = 470
		i = 0
		while (i < @albums[@select_album].tracks.length)
			@track_text.draw("#{i+1}: #{@albums[@select_album].tracks[i].name}", 100, possition_track + @y_possition_scroll_track, ZOrder::PLAYER, 1.0, 1.0, @tracks_color[i])
			Gosu.draw_rect(550, possition_track + @y_possition_scroll_track, 50, 26, Gosu::Color::WHITE, ZOrder::PLAYER, mode=:default)
			heart_btn.bmp.draw(562.5, possition_track + @y_possition_scroll_track, 1, 0.050, 0.050)
			possition_track+=50
			i+=1
		end
	end

	def draw_player_music
		back_btn = ArtWork.new("./btn_function_imgs/backbtn1.png")
		back_btn.bmp.draw(0, 0, 2, 0.115, 0.115)
		@list_imgs[@select_album].bmp.draw(100, 60, 2, 1.6, 1.6)
		title = Gosu::Font.new(self, "Space mono", 40)
		title.draw("#{@albums[@select_album].tracks[@select_track].name}" , 100, 500, ZOrder::UI, 1.0, 1.0, Gosu::Color::WHITE)
		artist = Gosu::Font.new(self, "Space mono", 30)
		artist.draw("#{@albums[@select_album].artist}" , 100, 540, ZOrder::UI, 1.0, 1.0, Gosu::Color.new(0x80FFFFFF))

		#function_btn
		back_function = ArtWork.new("./btn_function_imgs/back.png")
		back_function.bmp.draw(50, 620, 2, 0.2, 0.2)
		next_function = ArtWork.new("./btn_function_imgs/next.png")
		next_function.bmp.draw(450, 620, 2, 0.2, 0.2)
		if (@check_play == true)
			pause_btn = ArtWork.new("./btn_function_imgs/pause.png")
			pause_btn.bmp.draw(225, 600, 2, 0.3, 0.3)
		elsif (@check_play == false)
			play_btn = ArtWork.new("./btn_function_imgs/play.png")
			play_btn.bmp.draw(225, 600, 2, 0.3, 0.3)
		end

	end

	def draw
		if (@change_page == 0)
			draw_background
			draw_menu_albums
			draw_navi
		elsif (@change_page == 1)
			draw_background
			draw_album
			draw_navi
		elsif (@change_page == 2)
			draw_background
			draw_player_music
		elsif (@change_page == 3)
			draw_background
			draw_navi
		end
	end

end

MusicPlayerMain.new.show if __FILE__ == $0
