require 'spec_helper'


describe "Definitions" do
  
  it "should fetch the definitions" do
    data = get_json "/definitions"
    # puts data.inspect
    defs = [:structs, :units, :techs]
    data.keys.each do |key|
      defs.should include(key.to_sym)
      data[key].should be_a(Array)
    end
  end
  
  it "should fetch the definitions based on type" do
    defs = [:structs, :units, :techs]
    defs.each do |key|
      data = get_json "/definitions/#{key}"
      # puts "DATA: #{data}"
      data.should be_a(Array)
      data.first["definition"].should be_a(Hash)
    end
  end
  
end
