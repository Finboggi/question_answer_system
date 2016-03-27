module AcceptanceMacros
  def sign_in(user)
    visit new_user_session_path
    fill_in_login(user)
    click_on 'Log in'
  end

  def register(user)
    visit new_user_registration_path
    fill_in_register(user)
    click_button 'Sign up'
  end

  def fill_in_login(user)
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
  end

  def fill_in_register(user)
    fill_in_login(user)
    fill_in 'Password confirmation', with: user.password
  end
end