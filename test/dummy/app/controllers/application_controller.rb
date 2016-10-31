class ApplicationController < ActionController::Base
  helper Giman::ApplicationHelper
  protect_from_forgery with: :exception
end
