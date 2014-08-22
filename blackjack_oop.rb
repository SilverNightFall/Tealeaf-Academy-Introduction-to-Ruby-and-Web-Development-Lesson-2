require 'pry'

class Card

  attr_accessor :suit, :rank

  def initialize(suit, rank)
    @suit = suit
    @rank = rank
  end
end

class Deck
  attr_accessor :cards

  def initialize
    @cards = []
    %w{Spades Hearts Diamonds Clubs}.each do |suit|
      %w{Ace 2 3 4 5 6 7 8 9 10 Jack Queen King}.each do |rank|
        @cards << Card.new(suit, rank)
      end
    end
    shuffle_deck
  end

  def shuffle_deck
    cards.shuffle!
  end

  def deal_card
    cards.pop
  end

end

class Player

  attr_accessor :name, :hand

  def initialize(name)
    @name = name
    @hand = []
  end
end

  class Blackjack
    attr_accessor :player, :dealer, :cards, :hand

    BLACKJACK_AMOUNT = 21
    DEALER_MIN = 17
    ACE_VALUE = 11
    FACE_CARD_VALUE = 10

    def initialize
      @player = Player.new("Player")
      @dealer = Player.new("Computer")
      @cards = Deck.new
    end

    def play
     game = Blackjack.new
     game.start
    end

    def deal_card(deal_to)
      deal_to.hand << cards.deal_card
    end

    def get_player_name
      puts "What is your name?"
      player.name = gets.chomp.capitalize
    end

    def play_round?
      puts "Hi, would you like to play a round of Blackjack? (yes/no)"
      gets.chomp.downcase
    end

    def total_points(player_or_dealer)
      cards_value = 0
      player_value = player_or_dealer.hand.map { |r| r.rank }
      player_value.each do |r|
        if r == "Ace"
          cards_value += ACE_VALUE
        elsif r.to_i == 0
          cards_value += FACE_CARD_VALUE
        else r.to_i
          cards_value += r.to_i
        end
      end
      player_value.select { |r| r == "Ace" }.count.times do
        if cards_value > BLACKJACK_AMOUNT
          cards_value -= FACE_CARD_VALUE
        end
      end
      cards_value
    end

    def show_hand(player_or_dealer)
      puts "#{player_or_dealer.name}'s hand:"
      puts ""
      hand_output = player_or_dealer.hand.each do |card|
        puts "#{card.rank} of #{card.suit}"
      end
      hand_output
      puts "Total: #{ total_points(player_or_dealer)}"
      puts ""
    end

    def dealer_turn
      begin
        if  total_points(dealer) < DEALER_MIN
         deal_card(dealer)
       end
     end until  total_points(dealer) >= DEALER_MIN
   end

   def player_turn
      begin
      puts "What would you like to do next?"
      puts ""
      puts "[  HIT ] or [  STAY  ]"
      puts ""
      hit_or_stay = gets.chomp.downcase
        if !['hit', 'stay'].include?(hit_or_stay)
          puts "Error: you must enter hit or stay"
          next
        end
        if hit_or_stay == "hit"
          system 'clear'
          deal_card(player)
          show_hand(player)
        else
          next
        end
      end until hit_or_stay == "stay" ||  total_points(player) == BLACKJACK_AMOUNT ||  total_points(player) > BLACKJACK_AMOUNT
    end

    def winner?
      system 'clear'
      if  total_points(player) ==  total_points(dealer)
        puts "Its a tie"
        puts "No winner."
      elsif  total_points(player) == BLACKJACK_AMOUNT
        puts "#{player.name}, congratulations you got Blackjack!"
        puts ""
        puts "#{player.name} won!"
      elsif  total_points(dealer) == BLACKJACK_AMOUNT
        puts "#{player.name}, you lose!  Dealer got Blackjack!"
        puts ""
        puts "#{dealer.name} won!"
      elsif ( total_points(player) >  total_points(dealer) &&  total_points(player) <= BLACKJACK_AMOUNT) || ( total_points(player) <  total_points(dealer) &&  total_points(dealer) > BLACKJACK_AMOUNT)
        puts "#{player.name}, congratulations you won!"
        puts ""
      elsif  total_points(dealer) >  total_points(player) &&  total_points(dealer) < BLACKJACK_AMOUNT
        puts "#{dealer.name} won!"
      elsif  total_points(player) > BLACKJACK_AMOUNT
        puts "#{player.name}, you busted!"
        puts ""
      elsif  total_points(dealer) > BLACKJACK_AMOUNT
          puts "#{dealer.name} busted!"
          puts ""
      elsif  total_points(dealer) > BLACKJACK_AMOUNT &&  total_points(player) > BLACKJACK_AMOUNT
        puts "You both busted!"
        puts "No winner!"
      else
        "#{dealer.name} missed something."
      end
      show_hand(player)
      show_hand(dealer)
    end

    def start
      if play_round? == "yes"
        system 'clear'
        get_player_name
        2.times do
          deal_card(player)
          deal_card(dealer)
        end
      else
        puts "See you another time!"
        exit
      end
      system 'clear'

      if  total_points(player) == BLACKJACK_AMOUNT ||  total_points(player) > BLACKJACK_AMOUNT
        winner?
      end
      system 'clear'
      show_hand(player)
      player_turn
      if  total_points(player) == BLACKJACK_AMOUNT ||  total_points(player) > BLACKJACK_AMOUNT
        winner?
      else
        dealer_turn
        winner?
      end
      play
    end
  end

  game = Blackjack.new
  game.start
