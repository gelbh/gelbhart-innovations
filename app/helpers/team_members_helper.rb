module TeamMembersHelper
  TEAM_MEMBER_LEAD_SERVICES = {
    bareket: :pharmaceutical,
    yaron: :real_estate,
    tomer: :full_stack,
    effie: :sustainability
  }.freeze

  def team_member_lead_service_key(member)
    TEAM_MEMBER_LEAD_SERVICES[member.key]
  end

  def team_member_lead_service_path(member)
    case team_member_lead_service_key(member)
    when :pharmaceutical then pharmaceutical_path
    when :real_estate then real_estate_path
    when :full_stack then full_stack_path
    when :sustainability then sustainability_path
    end
  end

  def team_member_lead_service_icon(member)
    key = team_member_lead_service_key(member)
    key && AppConstants::SERVICE_ICONS[key]
  end

  def team_member_lead_service_gradient(member)
    key = team_member_lead_service_key(member)
    key && AppConstants::SERVICE_GRADIENTS[key]
  end

  def team_member_bio(member)
    simple_format(member.bio.to_s, {}, { sanitize: true })
  end
end
