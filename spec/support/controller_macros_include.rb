module ControllerMacrosInclude
  def sign_in(user)
      @user = user || create(:user)
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in @user
  end
end
