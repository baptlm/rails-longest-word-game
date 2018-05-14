require 'open-uri'

class GamesController < ApplicationController

  def new
    @letters = []
    10.times { @letters << ('a'...'z').to_a.shuffle.first }
  end

  def score
    @text = params[:word]
    @grid = params[:grid].delete(" ")
    if dictionnary?(@text) == false
      @result = "Sorry but #{@text} is not an English word"
    elsif !grid_check?(@text, @grid)
      @result = "Sorry but #{@text} canot be built from the grid"
    else
      @result = "Congratulations! #{@text} is valid !"
    end
  end

  def dictionnary?(attempt)
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    word_serialized = open(url).read
    word = JSON.parse(word_serialized)
    return word["found"]
  end

  def string_to_hash(string)
    my_hash = Hash.new(0)
    string.split("").each do |element|
      my_hash[element] += 1
    end
    return my_hash
  end

  def grid_check?(attempt, grid)
    attempt_hash = string_to_hash(attempt)
    grid_hash    = string_to_hash(grid)
    attempt_hash.each_key do |letter|
      if !grid_hash.key?(letter)
        return false
      else
        if attempt_hash[letter] > grid_hash[letter]
          return false
        end
      end
    end
    return true
  end

end
