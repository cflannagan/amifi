require 'rails_helper'

RSpec.describe TheFiPicture, type: :model do
  context "assets" do
    it "equals to 0" do
      expect(TheFiPicture.assets).to eq 0
    end
  end

  context "passive_income" do
    it "equals to 0" do
      expect(TheFiPicture.passive_income).to eq 0
    end
  end

  context "spending" do
    it "equals to 0" do
      expect(TheFiPicture.spending).to eq 0
    end
  end
end
