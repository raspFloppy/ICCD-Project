Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check
  namespace :api do
    namespace :v1 do
      post "/login", to: "auth#login"
      delete "/logout", to: "auth#logout"

      resources :classrooms do
        member do
          post :add_student
          delete "remove_student/:student_id", to: "classrooms#remove_student", as: :remove_student
        end
      end

      resources :levels, only: [ :index, :show ]

      resources :student_progresses, only: [ :index, :create ]
    end
  end

  get "*path", to: "application#frontend_index_html", constraints: lambda { |req|
    !req.xhr? && req.format.html?
  }
end
