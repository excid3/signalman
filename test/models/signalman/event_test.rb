require "test_helper"

class Signalman::EventTest < ActiveSupport::TestCase
  test "is valid" do
    assert Signalman::Event.new(name: "sql.active_record").valid?
  end

  test "is not valid" do
    assert_not Signalman::Event.new.valid?
  end
end
