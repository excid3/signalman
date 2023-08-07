require "application_system_test_case"

class ViewsTest < ApplicationSystemTestCase
  test "visit views page" do
    visit "signalman/views"

    assert_text "Views"
  end
end
