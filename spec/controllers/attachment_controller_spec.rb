require 'rails_helper'

RSpec.describe AttachmentsController, type: :controller do
  let(:question) { create(:question, :with_attachments) }
  let(:attachment) { question.attachments.first }

  describe 'DELETE #destroy' do
    context 'answer is deleted by owner' do
      before { sign_in question.user }

      it 'deletes attachment' do
        expect { delete :destroy, format: 'js', id: attachment }.to change(Attachment, :count).by(-1)
      end

      it 'renders #destroy view' do
        delete :destroy, format: 'js', id: attachment
        expect(response).to render_template :destroy
      end
    end

    context 'question is deleted by not owner' do
      let(:user) { create(:user) }
      before { sign_in user }

      it 'not deletes attachment' do
        expect { delete :destroy, format: 'js', id: attachment }
            .to_not change(Answer, :count)
      end

      it 'renders 403 status' do
        delete :destroy, format: 'js', id: attachment
        expect(response.status).to eq(403)
      end
    end
  end
end
