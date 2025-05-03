class ApplicationController < ActionController::API
  allow_browser versions: :modern

  include ActionController::Cookies

  before_action :autenticate_user

  private

  def autenticate_user
    header = request.headers["Authorization"]
    if header
      token = header.split(" ").last
      begin
        @decoded_token = JWT.decode(token, Rails.application.credentials.secret_key_base, true, { algorithm: "HS256" })
        @current_user = User.find(@decoded_token[:user_id])
      rescue Activate::RecordNotFound => e
        render json: { error: "User not found" }, status: :unauthorized
      rescue JWT::DecodeError => e
        render json: { error: "Invalid token" }, status: :unauthorized
      rescue JWT::ExpiredSignature => e
        render json: { error: "Token has expired" }, status: :unauthorized
      rescue JWT::VerificationError => e
        render json: { error: "Token verification failed" }, status: :unauthorized
      end
    else
      render json: { error: "Authorization header not found" }, status: :unauthorized
    end
  end
end

def jwt_encode(payload, exp = 24.hours.from_now)
  payload[:exp] = exp.to_i
  JWT.encode(payload, Rails.application.credentials.secret_key_base, "HS256")
end


def jwt_decode(token)
  decoded_token = JWT.decode(token, Rails.application.credentials.secret_key_base, true, { algorithm: "HS256" })
  HashWithIndifferentAccess.new(decoded_token[0])
rescue JWT::DecodeError
  nil
end

def current_user
  @current_user
end

def authorize_professor
  unless current_user.professor? || current_user.admin?
    render json: { errors: "Not authorized" }, status: :forbidden
  end
end

def authorize_student
  unless current_user.student?
    render json: { errors: "Not authorized" }, status: :forbidden
  end
end
