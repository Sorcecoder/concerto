require 'test_helper'

class UserTest < ActiveSupport::TestCase

  def setup
    @katie = users(:katie)
    @kristen = users(:kristen)
  end

  test "admin users can do anything to users" do
    admin = @katie
    ability = Ability.new(admin)
    assert ability.can?(:create, User)
    assert ability.can?(:read, @kristen)
    assert ability.can?(:update, @kristen)
    assert ability.can?(:destroy, User.new)
  end

  test "regular users can only touch themselves" do
    user = @kristen
    ability = Ability.new(user)
    assert ability.can?(:read, @kristen)
    assert ability.can?(:update, @kristen)

    # Don't let users delete themselves ATM.
    # We need to think about the reprecussions of this
    assert ability.cannot?(:destroy, @kristen)

    assert ability.cannot?(:create, User)
    assert ability.cannot?(:read, @katie)
    assert ability.cannot?(:update, @katie)
    assert ability.cannot?(:destroy, @katie)
  end

  test "new users can only sign up" do
    ability = Ability.new(User.new)
    assert ability.can?(:create, User)
    assert ability.cannot?(:read, @katie)
    assert ability.cannot?(:update, @katie)
    assert ability.cannot?(:destroy, @katie)
  end
end
