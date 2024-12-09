Rails.application.routes.draw do
  # Rutas para la gestión de formularios
  resources :forms, only: [:index, :show, :edit, :update, :destroy] do
    # La ruta para crear un nuevo formulario y procesar la creación
    post "", to: "forms#create", as: :create
  end

  # Verificar el estado de la aplicación
  get "up", to: "rails/health#show", as: :rails_health_check

  # Rutas dinámicas para archivos de PWA
  get "service-worker", to: "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest", to: "rails/pwa#manifest", as: :pwa_manifest

  # Define la raíz de la aplicación
  root "forms#index"
end
