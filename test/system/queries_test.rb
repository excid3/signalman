require "application_system_test_case"

class QueriesTest < ApplicationSystemTestCase
  test "visit queries page" do
    visit "signalman/queries"

    assert_text "Queries"
  end
end
