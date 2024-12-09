class FormsController < ApplicationController
  before_action :set_form, only: %i[show edit update destroy]

  # GET /forms or /forms.json
  def index
    @forms = Form.all
  end

  # GET /forms/1 or /forms/1.json
  def show
  end

  # GET /forms/new
  def new
    @form = Form.new
  end

  # GET /forms/1/edit
  def edit
  end

  # POST /forms or /forms.json
  def create
    @form = Form.new(form_params)

    if @form.save
      # Verifica si el formulario debe ser procesado por un job
      if params[:form].present? && params[:form][:processed_in_job] == "true"
        ResponseJob.perform_later(@form.id)
        redirect_to forms_path, notice: "Formulario en proceso. Se te notificará por correo."
      else
        process_response(@form)
        redirect_to @form, notice: "Formulario procesado exitosamente."
      end
    else
      render :new
    end
  end

  # PATCH/PUT /forms/1 or /forms/1.json
  def update
    respond_to do |format|
      if @form.update(form_params)
        format.html { redirect_to @form, notice: "Formulario actualizado exitosamente." }
        format.json { render :show, status: :ok, location: @form }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @form.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /forms/1 or /forms/1.json
  def destroy
    @form.destroy!

    respond_to do |format|
      format.html { redirect_to forms_path, status: :see_other, notice: "Formulario destruido exitosamente." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_form
      @form = Form.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def form_params
      params.require(:form).permit(:name, :description, :processed_in_job)
    end

    def process_response(form)
      response = OpenAI::Client.new(api_key: ENV["OPENAI_API_KEY"]).completions(
        parameters: {
          model: "text-davinci-003",
          prompt: "Contexto: #{form.name} - #{form.description}",
          max_tokens: 100
        }
      )
      form.create_response(ai_response: response["choices"].first["text"], status: "completed")
    end
end
