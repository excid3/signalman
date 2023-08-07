require "application_system_test_case"

class RequestsTest < ApplicationSystemTestCase
  test "visit requests page" do
    visit "signalman/requests"

    assert_text "Requests"
  end
end
