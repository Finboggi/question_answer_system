module ControllerMacrosExtend
  def create_user_and_sign_in
    before do
      @user = create(:user)
      @request.env['devise.mapping'] = Devise.mappings[:user]
      sign_in @user
    end
  end

  def it_has_403_answer
    it 'has 403 status code' do
      expect(response.status).to eq(403)
    end

    it { should set_flash.now[:alert] }
  end

  def create_question_answers(options = {})
    let(:question) { create(:question, :with_answers, options) }
    let(:answer) { question.answers.first }

    let(:accepted_answer) { question.answers.find(&:accepted) } if options[:accepted_answer]
  end
end
