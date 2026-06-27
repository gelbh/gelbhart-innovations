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

  def service_spotlight_bio(i18n_scope, member)
    scoped_bio = t("#{i18n_scope}.bio", default: "")
    return simple_format(scoped_bio, {}, sanitize: true) if scoped_bio.present?

    truncate(strip_tags(member.bio.to_s), length: 280)
  end

  def team_member_bio(member)
    simple_format(member.bio.to_s, {}, { sanitize: true })
  end

  def team_member_image_alt(member)
    service_key = team_member_lead_service_key(member)
    return member.name unless service_key

    t("pages.team.image_alt", name: member.name, service: t("nav.#{service_key}"))
  end
end
