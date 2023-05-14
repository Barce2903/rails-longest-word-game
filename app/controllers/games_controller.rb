require 'open-uri'
# Controlleur du jeu
class GamesController < ApplicationController
  def new
    array_of_letters = ('A'..'Z').to_a
    @letters = Array.new(10)
    @letters.map! { |_letter| array_of_letters[rand(26)] }
  end

  def score
    api_feedback = JSON.parse(URI.open("https://wagon-dictionary.herokuapp.com/#{params['answer']}").read)
    answer = params['answer'].upcase.split('')
    answer.map! { |letter| params['letters_given'].split(' ').include?(letter) ? nil : break }
    answer.compact!
    @result = result(api_feedback, answer)
  end

  private

  def result(api_feedback, answer)
    if api_feedback['found'] == true && answer.empty?
      "Congratulations! #{params['answer']} is a valid English word!"
    elsif api_feedback['found'] == false && answer.empty?
      "Sorry but #{params['answer']} does not seem to be a valid english word..."
    else
      "Sorry but #{params['answer']} can't be built out of #{params['letters_given']}"
    end
  end
end
