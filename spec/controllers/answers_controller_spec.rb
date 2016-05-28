require 'rails_helper'

RSpec.describe AnswersController, type: :controller do
  let(:question) { create(:question) }
  describe 'GET #new' do
    sign_in_user
    before { get :new, question_id: question.id }

    it 'assigns a new Answer to @answer' do
      expect(assigns(:answer)).to be_a_new(Answer)
    end

    it 'renders :new answer view' do
      expect(response).to render_template :new
    end
  end

  describe 'POST #create' do
    sign_in_user
    context 'with valid answer' do
      it 'adds answer to database and assigns it to question' do
        expect { post :create, format: 'js', question_id: question.id, answer: attributes_for(:answer) }
          .to change(question.answers, :count).by(1)
      end

      it 'render js with new answer' do
        post :create, format: 'js', question_id: question.id, answer: attributes_for(:answer)
        expect(response).to render_template :create
      end

      it 'user authors new answer' do
        post :create, format: 'js', question_id: question.id, answer: attributes_for(:answer)
        expect(assigns(:answer).user_id).to eq @user.id
      end
    end

    context 'with invalid answer' do
      sign_in_user
      it 'does not add answer to database' do
        expect { post :create, format: 'js', question_id: question.id, answer: attributes_for(:invalid_answer) }
          .to_not change(Answer, :count)
      end

      it 're-renders :create answer view' do
        post :create, format: 'js', question_id: question.id, answer: attributes_for(:invalid_question)
        expect(response).to render_template :create
      end
    end
  end

  describe 'answers manipulation' do
    sign_in_user
    let!(:answer) { create(:answer, user: @user) }
    let!(:answer_not_owned) { create(:answer) }

    describe 'DELETE #destroy' do
      context 'answer is deleted by owner' do
        it 'deletes answer' do
          expect { delete :destroy, format: 'js', id: answer, question_id: answer.question }
            .to change(Answer, :count).by(-1)
        end

        it 'renders #destroy view' do
          delete :destroy, format: 'js', id: answer, question_id: answer.question
          expect(response).to render_template :destroy
        end
      end
      context 'question is deleted by not owner' do
        it 'not deletes answer' do
          expect { delete :destroy, format: 'js', id: answer_not_owned, question_id: answer_not_owned.question }
            .to_not change(Answer, :count)
        end

        it 'renders :show view' do
          delete :destroy, format: 'js', id: answer_not_owned, question_id: answer_not_owned.question
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

        it 'not flashes alert' do
          expect(flash[:alert]).to be_nil
        end
      end

      context 'answer is edited by not owner' do
        before { xhr :get, :edit, format: :js, question_id: question.id, id: answer_not_owned }

        it 'flashes alert' do
          expect(flash[:alert]).to_not be_nil
        end

        it 'has 403 status code' do
          expect(response.status).to eq(403)
        end
      end
    end

    describe 'PUT #update' do
      context 'answer is updated by owner' do
        before { answer.body = 'Alter question body' }
        before { xhr :put, :update, format: :js, question_id: answer.question.id, id: answer, answer: answer.attributes }

        it 'assigns the sended Answer to @answer' do
          expect(assigns(:answer)).to eq answer
          expect(assigns(:answer).reload.body).to eq answer.body
        end

        it 'renders :update answer view' do
          expect(response).to render_template :update
        end

        it 'flashes no alerts' do
          expect(flash[:alert]).to be_nil
        end
      end

      context 'answer is updated by not owner' do
        before { answer_not_owned.body = 'Alter question body' }
        before { xhr :put, :update, format: :js, question_id: answer_not_owned.question.id, id: answer_not_owned, answer: answer_not_owned.attributes }

        it 'assigns the old Answer to @answer' do
          expect(assigns(:answer)).to eq answer_not_owned
          expect(assigns(:answer).reload.body).to_not eq answer_not_owned.body
        end

        it 'has 403 status code' do
          expect(response.status).to eq(403)
        end

        it 'not flashes alert' do
          expect(flash[:alert]).to_not be_nil
        end
      end
    end
  end

  describe 'PUT #accept' do
    context 'answer accepted by question owner' do
      let(:question) { create(:question, :with_answers) }
      let(:answer) { question.answers.first }

      #TODO: login must bi more simple
      before { @request.env['devise.mapping'] = Devise.mappings[:user]; sign_in question.user }
      before { answer[:accepted] = 1 }
      before { xhr :put, :accept, format: :js, question_id: answer.question.id, id: answer.id, answer: answer.attributes }

      it 'marks answer accepted' do
        expect(assigns(:answer)).to eq answer
        expect(assigns(:answer).reload.accepted).to eq true
      end

      it 'renders #accept view' do
        expect(response).to render_template :accept
      end

      it 'flashes no alerts' do
        expect(flash[:alert]).to be_nil
      end
    end

    #TODO: needs to be refactored (move 403 and no alerts into macross)
    context 'answer accepted by question not owner' do
      let(:question) { create(:question, :with_answers) }
      let(:answer) { question.answers.first }

      sign_in_user
      before { answer[:accepted] = 1 }
      before { xhr :put, :accept, format: :js, question_id: answer.question.id, id: answer.id, answer: answer.attributes }

      it 'doesnt mark answer accepted' do
        expect(assigns(:answer)).to eq answer
        expect(assigns(:answer).reload.accepted).not_to eq true
      end

      it 'has 403 status code' do
        expect(response.status).to eq(403)
      end

      it 'not flashes alert' do
        expect(flash[:alert]).to_not be_nil
      end
    end
  end
end
