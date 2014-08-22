  class Hand

    include Comparable

    attr_reader :pick
  
    def initialize(choice)
      @pick = choice
    end

    def <=>(another_hand)
      if @pick == another_hand.pick
        0
      elsif (@pick == 'p' && another_hand.pick == 'r') || (@pick == 's' && another_hand.pick == 'p') || (@pick == 'r' && another_hand.pick == 's')
        1
      else
        -1
      end 
    end
  
    def display_winning_message
      case @pick
      when 'p'
        puts "Paper covers Rock"
      when 'r'
        puts "Rock smashes Scissors"
      when 's'
        puts "Scissors cut Paper" 
      end
    end
  end

  class Player < Hand

    attr_accessor :hand
    attr_reader :name
    
    def initialize(n)
      @name = n
    end
  
    def to_s
      "#{name} has a choice of #{self.hand.pick}."
    end
  end

  class Human < Player

    def hand_pick
      begin
      puts "Choose one: (R/P/S)"
      pick = gets.chomp.downcase
      end until RockPaperScissors::CHOICES.keys.include?(pick)
  
      self.hand = Hand.new(pick)
    end
  end
  
  class Computer < Player

    def hand_pick
      self.hand = Hand.new(RockPaperScissors::CHOICES.keys.sample)
    end
  end

  # noinspection ALL
  class RockPaperScissors < Player
  
    CHOICES = { 'r' => 'Rock', 'p' => 'Paper', 's' => 'Scissors'}
    attr_reader :player, :computer
    
    def initialize
      @computer = Computer.new("Computer")
      @player = Human.new("Player")
    end

    def compare_hands
      if player.hand == computer.hand
        puts "It's a tie!"
      elsif player.hand > computer.hand
        player.hand.display_winning_message
        puts "#{player.name} won!"
      else
        computer.hand.display_winning_message
        puts "#{computer.name} won!"
      end
    end

    def play
      player.hand_pick
      computer.hand_pick
      compare_hands
      display_winning_message
      puts player
      puts computer
    end
  end

  RockPaperScissors.new.play
