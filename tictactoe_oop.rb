  class Board
    WINNING_LINES = [[1,2,3], [4,5,6], [7,8,9], [1,4,7], [2,5,8], [3,6,9], [1,5,9], [3,5,7]]

    def initialize
      @data = {}
      (1..9).each { |position| @data[position] = Squares.new(' ') }
    end

    def draw
      system 'clear'
      puts
      puts "     |     |"
      puts "  #{@data[1]}  |  #{@data[2]}  |  #{@data[3]}"
      puts "     |     |"
      puts "-----+-----+-----"
      puts "     |     |"
      puts "  #{@data[4]}  |  #{@data[5]}  |  #{@data[6]}"
      puts "     |     |"
      puts "-----+-----+-----"
      puts "     |     |"
      puts "  #{@data[7]}  |  #{@data[8]}  |  #{@data[9]}"
      puts "     |     |"
      puts
    end

    def nine_positions_are_filled?
      empty_positions == 0
    end

    def empty_squares
      @data.select { | _, square | square.value == ' '}.values
    end

    def empty_positions
      @data.select{|_, square| square.empty? }.keys
    end

    def all_squares_marked?
      empty_squares.size == 0
    end

    def mark_square(position, marker)
      @data[position].mark(marker)
    end

    def winning_condition?(marker)
      WINNING_LINES.each do |line|
        return true if @data[line[0]].value == marker && @data[line[1]].value  == marker && @data[line[2]].value == marker
      end
      false
    end

  end

  class Squares

    attr_accessor :value

    def initialize(value)
      @value = value
    end

    def mark(marker)
      @value = marker
    end

    def occupied?
      @value != " "
    end

    def empty?
      @value == " "
    end

    def to_s
      @value
    end
  end

  class Player
    attr_reader :marker, :name
    def initialize(name, marker)
      @name = name
      @marker = marker
    end

    def self.get_name
      puts "What is your name?"
      @name = gets.chomp.capitalize
    end
  end

  class TicTacToe
    attr_accessor :name
    def initialize
      @board = Board.new
      @human = Player.new("#{Player.get_name}", "X")
      @computer = Player.new("Computer", "O")
      @current_player = @human
    end

    def play_game?
      puts "Would you like to play a round of Tic Tac Toe? (yes, no)"
      @play_round =  gets.chomp.downcase
      puts ""
    end

    def current_player_marks_square
      if @current_player == @human
        begin
          puts "Choose a position (1-9):"
          position = gets.chomp.to_i
        end until @board.empty_positions.include?(position)
      else
        position = @board.empty_positions.sample
      end
      @board.mark_square(position, @current_player.marker)
    end

    def current_player_wins?
      @board.winning_condition?(@current_player.marker)
    end

    def alternate_player
      if @current_player == @human
        @current_player = @computer
      else
        @current_player = @human
      end
    end

    def play
      begin
        play_game?
        if @play_round == "yes"
          system 'clear'
          @board = Board.new
          @board.draw
          loop do
            current_player_marks_square
            @board.draw
            if current_player_wins?
              puts "The winner is #{@current_player.name}."
              puts ""
              break
            elsif @board.all_squares_marked?
              puts "Its a tie!"
              puts ""
            else
              alternate_player
            end
          end
        else
          puts "Bye"
        end
     end until @play_round == "no"
   end
 end

 TicTacToe.new.play