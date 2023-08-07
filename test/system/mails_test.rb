require "application_system_test_case"

class MailsTest < ApplicationSystemTestCase
  test "visit mails page" do
    visit "signalman/mails"

    assert_text "Mails"
  end
end
