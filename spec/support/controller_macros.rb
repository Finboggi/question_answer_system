module ControllerMacros
  def sign_in_user(test)
    before do
      p test
      @user = create(:user)
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in @user
    end
  end
end
