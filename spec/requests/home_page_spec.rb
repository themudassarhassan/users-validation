require 'rails_helper'

RSpec.describe "HomePages", type: :request do
  describe "GET /index" do
    specify do
      get '/'

      expect(response).to render_template(:index)
    end

    specify do
      get '/'

      expect(response.body).to include('Upload users CSV file for validation.')
    end
  end
end
