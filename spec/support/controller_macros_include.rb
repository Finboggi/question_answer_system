module ControllerMacrosInclude
  def delete_answer_request(answer)
    delete :destroy, format: 'js', id: answer, question_id: answer.question
  end

  def create_answer_request(question, answer)
    post :create, format: 'js', question_id: question.id, answer: attributes_for(answer)
  end
end
