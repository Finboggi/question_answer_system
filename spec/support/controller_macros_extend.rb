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
    let(:answer) { question.answers.find { |a| !a.accepted } }

    let(:accepted_answer) { question.answers.find(&:accepted) } if options[:accepted_answer]
  end

  def it_includes_voted_concern
    describe 'includes Voted concern' do
      it { expect(described_class.included_modules.include? Voted).to eq(true) }
    end
  end
end
