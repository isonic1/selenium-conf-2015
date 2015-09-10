require 'spec_helper'

describe "Modify Note Scenarios: Android: #{ENV["UDID"]}" do
  
  before :each do
    find_element(:id, 'com.example.android.notepad:id/menu_add').click
    wait_true { find_element(:id, "android:id/action_bar_title").text.eql? "New note" }
    @note = Lorem.sentence
    find_element(:id, 'com.example.android.notepad:id/note').send_keys @note
    find_element(:id, 'com.example.android.notepad:id/menu_save').click
    wait_true { find_element(:id, "android:id/action_bar_title").text.eql? "Notes" }
  end
    
  it 'Delete A Note' do
    find_elements(:id, 'android:id/text1').find { |note| note.text.eql? @note }.click
    find_element(:id, 'More options').click
    find_element(:name, 'Delete').click
    wait_true { find_element(:id, "android:id/action_bar_title").text.eql? "Notes" }
    if exists { find_element(:id, 'android:id/text1') }
      notes = find_elements(:id, 'android:id/text1').map { |note| note.text }
    else
      notes = []
    end
    expect(notes).to_not include @note
  end
end