class HomePagesController < ApplicationController
  rescue_from Users::CSVImportService::CSVParsingError, with: :redirect_and_show_message

  def index
  end

  def create
    @result = Users::CSVImportService.call(users_csv)

    respond_to do |format|
      format.turbo_stream
    end
  end


  private

  def users_csv
     params[:users_csv]
  end

  def redirect_and_show_message(exception)
    redirect_to root_url, alert: exception.message
  end
end
