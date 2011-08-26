require 'spec_helper'

describe "Pages" do
  
  describe "/ (home page)" do
    it "should render the home page" do
      visit "/"
      page.should have_content("WarGame")
    end
  end
  
end