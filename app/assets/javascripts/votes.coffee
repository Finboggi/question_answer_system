# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.votes =
  vote: (link) ->
    self = this
    $.post({
      url: $(link).attr('href')
      data: self.vote_data(link)
    }).success( self.successfully_voted(link) );

  vote_data: (link) ->
    data =
      vote:
        votable_type: $(link).attr('data_votable_type')
        votable_id: $(link).attr('data_votable_id')
        value: $(link).attr('data_value')

  successfully_voted: (link) ->
    alert('success!')

