# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.votes =
  link_url: (xhr) ->
    return '/'


$ ->
  $('.votes_actions a').bind 'ajax:success', (e, data, status, xhr) ->
    console


