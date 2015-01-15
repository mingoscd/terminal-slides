require 'pry'
require 'terminfo'

class ConsoleKeynote
	def initialize(auto = false)
		@auto = auto
	end

	def get_presentation(file)
		@presentation = Presentation.new(file)
	end

	def begin
		self.show_slide
	end

	def show_slide
		slide_content = @presentation.slides[@presentation.slide_number]

		show_content_in_screen(slide_content)

		option = gets.chomp
		while true
			if option[0] == "n" || option == ""
				self.next_slide
				break
			elsif option[0] == "p"
				self.prev_slide
				break
			else
			end
		end			
	end

	def next_slide
		@presentation.get_next_slide
		self.show_slide
	end

	def prev_slide
		@presentation.get_prev_slide
		self.show_slide
	end

	def show_content_in_screen(slide_content)
		terminal_size = TermInfo.screen_size
		slide_height = slide_content.split("\n").length
		
		spaces_height = (terminal_size[0] - slide_height) / 2.0

		print "\n"*spaces_height.floor
		print slide_content.center(terminal_size[1])
		print "\n"*spaces_height.ceil
		print " "*3 + "<< previus" + " "*(terminal_size[1] - 25) + "next >>" + " "*3
	end
end

class Presentation
	attr_accessor :slides, :slide_number
	def initialize(file)
		@slides = IO.read(file).split("\n----\n").map { |s| s.gsub("\n", "") }
		@slide_number = 0
	end

	def get_next_slide		
		if @slide_number < @slides.length - 1
			@slide_number += 1
		else
			exit
		end
	end

	def get_prev_slide
		if @slide_number > 0
			@slide_number -= 1
		end
	end
end

console = ConsoleKeynote.new
console.get_presentation("slides.txt")
console.begin