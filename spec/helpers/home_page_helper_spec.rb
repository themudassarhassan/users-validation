require 'rails_helper'

RSpec.describe HomePageHelper, type: :helper do
  describe "#status_badge" do
    let(:base_classes) { "px-2 inline-flex text-xs leading-5 font-semibold rounded-full" }

    context "when the status is :success" do
      it "returns a span with success classes" do
        result = helper.status_badge(:success)
        expect(result).to eq(
          content_tag(:span, :success, class: "#{base_classes} bg-green-100 text-green-800")
        )
      end
    end

    context "when the status is :failure" do
      it "returns a span with failure classes" do
        result = helper.status_badge(:failure)
        expect(result).to eq(
          content_tag(:span, :failure, class: "#{base_classes} bg-red-100 text-red-800")
        )
      end
    end

    context "when the status is :error" do
      it "returns a span with error classes" do
        result = helper.status_badge(:error)
        expect(result).to eq(
          content_tag(:span, :error, class: "#{base_classes} bg-yellow-100 text-yellow-800")
        )
      end
    end
  end
end
