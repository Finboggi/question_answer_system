require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  describe 'GET #new' do
    create_user_and_sign_in
    before { get :new, question_id: question.id }

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders :new answer view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    create_user_and_sign_in
    context 'with valid answer' do
      it 'adds answer to database and assigns it to question' do
        expect { create_answer_request question, :answer }
          .to change(question.answers, :count).by(1)
      end

      it 'render js with new answer' do
        create_answer_request question, :answer
        expect(response).to render_template :create
      end

      it 'user authors new answer' do
        create_answer_request question, :answer
        expect(assigns(:answer).user_id).to eq @user.id
      end
    end

    context 'with invalid answer' do
      create_user_and_sign_in
      it 'does not add answer to database' do
        expect { create_answer_request question, :invalid_answer }.to_not change(Answer, :count)
      end

      it 're-renders :create answer view' do
        create_answer_request question, :invalid_answer
        expect(response).to render_template :create
      end
    end
  end

  describe 'answers manipulation' do
    create_user_and_sign_in
    let!(:answer) { create(:answer, user: @user) }
    let!(:answer_not_owned) { create(:answer) }

    describe 'DELETE #destroy' do
      context 'answer is deleted by owner' do
        it 'deletes answer' do
          expect { delete_answer_request answer }.to change(Answer, :count).by(-1)
        end

        it 'renders #destroy view' do
          delete_answer_request answer
          expect(response).to render_template :destroy
        end
      end
      context 'question is deleted by not owner' do
        it 'not deletes answer' do
          expect { delete_answer_request answer_not_owned }
            .to_not change(Answer, :count)
        end

        it 'renders 403 response code' do
          delete_answer_request answer_not_owned
          expect(response.status).to eq(403)
        end
      end
    end

    describe 'GET #edit' do
      context 'answer is edited by owner' do
        before { xhr :get, :edit, format: :js, question_id: question.id, id: answer }

        it 'assigns the requested Answer to @answer' do
          expect(assigns(:answer)).to eq answer
        end

        it 'renders :show question view' do
          expect(response).to render_template :edit
        end

        it { should_not set_flash.now[:alert] }
      end

      context 'answer is edited by not owner' do
        before { xhr :get, :edit, format: :js, question_id: question.id, id: answer_not_owned }

        it_has_403_answer
      end
    end

    describe 'PUT #update' do
      context 'answer is updated by owner' do
        before do
          answer.body = 'Alter question body'
          xhr :put, :update,
              format: :js, question_id: answer.question.id, id: answer, answer: answer.attributes
        end

        it 'assigns the sended Answer to @answer' do
          expect(assigns(:answer)).to eq answer
          expect(assigns(:answer).reload.body).to eq answer.body
        end

        it 'renders :update answer view' do
          expect(response).to render_template :update
        end

        it { should_not set_flash.now[:alert] }
      end

      context 'answer is updated by not owner' do
        before do
          answer_not_owned.body = 'Alter question body'
          xhr :put, :update,
              format: :js,
              question_id: answer_not_owned.question.id,
              id: answer_not_owned,
              answer: answer_not_owned.attributes
        end

        it 'assigns the old Answer to @answer' do
          expect(assigns(:answer)).to eq answer_not_owned
          expect(assigns(:answer).reload.body).to_not eq answer_not_owned.body
        end

        it_has_403_answer
      end
    end
  end

  describe 'PUT #accept' do
    context 'answer accepted by question owner' do
      create_question_answers

      before do
        sign_in question.user
        xhr :put, :accept, format: :js, question_id: answer.question.id, id: answer.id
        answer.reload
      end

      it 'marks answer accepted' do
        expect(assigns(:answer)).to eq answer
        expect(assigns(:answer).reload.accepted).to eq true
      end

      it 'renders #accept view' do
        expect(response).to render_template :accept
      end

      it { should_not set_flash.now[:alert] }
    end

    context 'accepted answer rejected by question owner' do
      create_question_answers accepted_answer: true

      before do
        sign_in question.user
        xhr :put,
            :accept,
            format: :js, question_id: accepted_answer.question.id, id: accepted_answer.id
      end

      it 'remove acceptance marks answer accepted' do
        expect(assigns(:answer)).to eq accepted_answer
        expect(assigns(:answer).accepted).to eq false
      end

      it 'renders #accept view' do
        expect(response).to render_template :accept
      end

      it 'flashes no alerts' do
        expect(flash[:alert]).to be_nil
      end
    end

    context 'answer accepted by question not owner' do
      create_question_answers

      create_user_and_sign_in
      before do
        xhr :put,
            :accept,
            format: :js, question_id: answer.question.id, id: answer.id
      end

      it 'doesnt mark answer accepted' do
        expect(assigns(:answer)).to eq answer
        expect(assigns(:answer).accepted).not_to eq true
      end

      it_has_403_answer
    end
  end
end
