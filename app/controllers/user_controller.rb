class UserController < ApplicationController
  skip_before_action :authorize_request, only: %i[create]

  def create
  end

  def index
  end

  def show
  end

  def edit
  end

  def reset_pasword
  end
end
