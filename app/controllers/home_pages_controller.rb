class HomePagesController < ApplicationController
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
end
