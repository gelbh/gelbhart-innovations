# frozen_string_literal: true

require "test_helper"

class TeamMembersHelperTest < ActionView::TestCase
  test "service_spotlight_bio uses scoped short bio when present" do
    member = TeamMember.find_by_key(:bareket)
    bio = service_spotlight_bio("pages.services.pharmaceutical.spotlight", member)

    assert_includes bio, I18n.t("pages.services.pharmaceutical.spotlight.bio")
    refute_includes bio, "Technion"
  end

  test "team_member_image_alt includes name and lead service" do
    member = TeamMember.find_by_key(:tomer)

    assert_includes team_member_image_alt(member), member.name
    assert_includes team_member_image_alt(member), I18n.t("nav.full_stack")
  end
end
