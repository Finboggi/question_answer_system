$ ->
  bootstrap_class_for = (flash_type) ->
    bootstrap_classes =
      success: "alert-success"
      error: "alert-danger"
      alert: "alert-warning"
      notice: "alert-info"
    bootstrap_classes[flash_type]

  get_flash_messages = (jqXHR) ->
    return if (!jqXHR || !jqXHR.getResponseHeader)
    JSON.parse jqXHR.getResponseHeader 'X-Flash'

  generate_bootstrap_message = (type, message) ->
    close_button = $('<BUTTON>')
      .addClass('close')
      .attr('data-dismiss', 'alert')
      .text('x')
    $('<DIV>')
      .addClass('alert fade in ' + bootstrap_class_for(type))
      .html message
      .prepend close_button
      .appendTo $('#flash_messages')

  show_flash_messages = (jqXHR) ->
    flash_messages = get_flash_messages jqXHR
    $('#flash_messages').empty() if $.map(flash_messages, ( (n, i) -> i ) ).length
    $.each flash_messages, (type, message) ->
      generate_bootstrap_message type, message

  $(document).ajaxComplete (event, xhr, settings) ->
    show_flash_messages xhr

  $('.votes_actions').bind 'ajax:success', (e, data, status, xhr) ->
    vote_json = xhr.responseJSON
    votable_node_id = '#' + vote_json['vote']['votable_type'].toLowerCase() + '_' + vote_json['vote']['votable_id']

    $(votable_node_id + ' .votes_actions>div').each ->
      $(@).toggleClass('display_none')
    $(votable_node_id + ' .votes_sum .numeric').text vote_json['votes_sum']
  .bind 'ajax:error', (e, data, status, xhr) ->
    $('#flash_messages').empty()
    errors = data.responseJSON['errors']
    $.each errors, (error_no, error_message) ->
      generate_bootstrap_message 'alert', error_message