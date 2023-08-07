require "application_system_test_case"

class JobsTest < ApplicationSystemTestCase
  test "visit jobs page" do
    visit "signalman/jobs"

    assert_text "Jobs"
  end
end
