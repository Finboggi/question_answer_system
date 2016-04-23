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
    $('#flash_messages').empty
    flash_messages = get_flash_messages jqXHR
    $.each flash_messages, (type, message) ->
      generate_bootstrap_message type, message



  $(document).ajaxComplete (event, xhr, settings) ->
    show_flash_messages xhr