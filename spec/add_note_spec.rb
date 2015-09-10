require 'spec_helper'

describe "Add Note Scenarios: Android: #{ENV["UDID"]}" do
  
  before :each do
    find_element(:id, 'com.example.android.notepad:id/menu_add').click
    wait_true { find_element(:id, "android:id/action_bar_title").text.eql? "New note" }
    @note = Lorem.sentence
  end
  
  it 'Create A Note' do
    find_element(:id, 'com.example.android.notepad:id/note').send_keys @note
    find_element(:id, 'com.example.android.notepad:id/menu_save').click
    wait_true { find_element(:id, "android:id/action_bar_title").text.eql? "Notes" }
    expect(find_element(:id, 'android:id/text1').text).to eq "fail_on_purpose" #@note
  end
end