# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
window.answers =
  sort: ->
    answers_list = $('.answers .answer')
    answers_list.sort(answers.order)
    answers_list.detach().appendTo($('.answers'));

  order: (a, b) ->
    compare_accepted_result = answers.compare_accepted(a, b)
    return answers.compare_created_at(a, b) if compare_accepted_result == 0
    return compare_accepted_result

  compare_accepted: (a, b) ->
    return 1 if a.getAttribute('data-accepted') < b.getAttribute('data-accepted')
    return -1 if a.getAttribute('data-accepted') > b.getAttribute('data-accepted')
    return 0

  compare_created_at: (a, b) ->
    return 1 if Date.parse(a.getAttribute('data-created-at')) > Date.parse(b.getAttribute('data-created-at'))
    return -1 if Date.parse(a.getAttribute('data-created-at')) < Date.parse(b.getAttribute('data-created-at'))
    return 0