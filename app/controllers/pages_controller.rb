require 'open-uri'
require 'json'

class PagesController < ApplicationController
  def game
    alphabet = ("A".."Z").to_a
    grid = []
    1.upto(10) { grid << alphabet[rand(26)] }
    $grid = grid
    $start_time = Time.now
  end

  def score
    @word = params[:word]
    end_time = Time.now
    grid_hash = {}
    @results= {}
    attempt_hash = {}
    $grid.each do |i|
      x = i.downcase
      add_to_hash(grid_hash, x)
    end
    @word.downcase.each_char do |j|
      add_to_hash(attempt_hash, j)
    end
    attempt_hash.each_key do |key|
      if !grid_hash[key] || grid_hash[key] < attempt_hash[key]
        @results[:score] = 0
        @results[:message] = "not in the grid"
        return @results
      end
    end
    url = "https://wagon-dictionary.herokuapp.com/#{@word}"
    result = open(url).read
    result_file = JSON.parse(result)
    if result_file["found"]
      @results[:score] = (result_file["length"] + 1) / (end_time - $start_time)
      @results[:message] = "well done!"
    else
      results[:score] = 0
      results[:message] = "not an english word"
    end
    return @results
  end

  def add_to_hash(a_hash, letter)
    if a_hash[letter]
      a_hash[letter] += 1
    else
      a_hash[letter] = 1
    end
  end
end
