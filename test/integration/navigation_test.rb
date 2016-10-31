require 'test_helper'

class NavigationTest < ActionDispatch::IntegrationTest
  test "the truth" do
    visit "/users"
    assert true
  end
end

