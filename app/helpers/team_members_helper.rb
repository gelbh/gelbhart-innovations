module TeamMembersHelper
  def team_member_bio(member)
    simple_format(member.bio.to_s, {}, sanitize: true)
  end
end

