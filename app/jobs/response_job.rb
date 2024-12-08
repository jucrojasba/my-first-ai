class ResponseJob < ApplicationJob
  queue_as :default

  def perform(form_id)
    form = Form.find(form_id)
    response = OpenAI::Client.new(api_key: ENV["OPENAI_API_KEY"]).completions(
      parameters: {
        model: "text-davinci-003",
        prompt: "Contexto: #{form.name} - #{form.description}",
        max_tokens: 100
      }
    )
    form.create_response(ai_response: response["choices"].first["text"], status: "completed")
    UserMailer.response_ready(form).deliver_now
  end
end
