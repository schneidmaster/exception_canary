require_dependency 'exception_canary/application_controller'

module ExceptionCanary
  class StoredExceptionsController < ApplicationController
    def index
      @stored_exceptions = StoredException.order(:created_at).reverse_order.page(params[:page])
    end

    def show
      @stored_exception = StoredException.find(params[:id])
    end
  end
end
