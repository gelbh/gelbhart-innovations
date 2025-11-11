# frozen_string_literal: true

require "test_helper"

class TeamMemberTest < ActiveSupport::TestCase
  test "all returns array of team members" do
    members = TeamMember.all
    
    assert_instance_of Array, members
    assert_operator members.size, :>, 0
    assert_instance_of TeamMember, members.first
  end

  test "team members have required attributes" do
    member = TeamMember.all.first
    
    assert_not_nil member.name
    assert_not_nil member.bio
    assert_not_nil member.linkedin_url
  end

  test "first_name returns first part of name" do
    member = TeamMember.new(
      name: "John Doe",
      bio: "Test bio",
      linkedin_url: "https://linkedin.com/in/johndoe"
    )
    
    assert_equal "John", member.first_name
  end

  test "image_filename returns path with lowercase first name and extension" do
    member = TeamMember.new(
      name: "John Doe",
      bio: "Test bio",
      linkedin_url: "https://linkedin.com/in/johndoe"
    )
    
    assert_equal "team/john.png", member.image_filename
  end

  test "github? returns true when github_url is present" do
    member = TeamMember.new(
      name: "John Doe",
      bio: "Test bio",
      linkedin_url: "https://linkedin.com/in/johndoe",
      github_url: "https://github.com/johndoe"
    )
    
    assert member.github?
  end

  test "github? returns false when github_url is nil" do
    member = TeamMember.new(
      name: "John Doe",
      bio: "Test bio",
      linkedin_url: "https://linkedin.com/in/johndoe"
    )
    
    assert_not member.github?
  end

  test "initializes with all attributes" do
    member = TeamMember.new(
      name: "John Doe",
      bio: "Test bio",
      linkedin_url: "https://linkedin.com/in/johndoe",
      github_url: "https://github.com/johndoe"
    )
    
    assert_equal "John Doe", member.name
    assert_equal "Test bio", member.bio
    assert_equal "https://linkedin.com/in/johndoe", member.linkedin_url
    assert_equal "https://github.com/johndoe", member.github_url
  end
end

