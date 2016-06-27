module ApplicationHelper
  def bootstrap_class_for(flash_type)
    {
      success: 'alert-success',
      error: 'alert-danger',
      alert: 'alert-warning',
      notice: 'alert-info'
    }[flash_type.to_sym] || flash_type
  end

  def voted?(votable)
    Vote.where( { user_id: current_user.id, votable: votable } ).present? ? true : false
  end

  def not_voted?(votable)
    !voted? votable
  end
end
