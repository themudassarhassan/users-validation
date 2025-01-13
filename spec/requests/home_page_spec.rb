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

  describe "POST /home_pages" do
    let(:csv_content) { "name,password\nJohn Doe,password123\nJane Doe,password456" }
    let(:csv_file) { Rack::Test::UploadedFile.new(StringIO.new(csv_content), 'text/csv', original_filename: 'users.csv') }

    context 'with valid csv' do
      it "returns turbo stream response" do
        post home_page_path, params: { users_csv: csv_file }, headers: { accept: "text/vnd.turbo-stream.html" }

        expect(response.media_type).to eq "text/vnd.turbo-stream.html"
        expect(response).to have_http_status(:success)
      end
    end

    context 'with malformed csv file' do
      let(:csv_content) { "name,password\n\"John\" Doe, pass,word" }

      it "flashes an alert" do
        post home_page_path, params: { users_csv: csv_file }, headers: { accept: "text/vnd.turbo-stream.html" }

        expect(flash[:alert]).to match(/Invalid CSV format:/)
      end
    end
  end
end
