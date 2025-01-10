module RentalsHelper
  STATUS_COLORS = {
    pending: "badge-secondary",
    approved: "badge-success",
    rejected: "badge-danger",
    canceled: "badge-warning",
    renting: "badge-primary",
    returned: "badge-info"
  }.freeze

  def rental_status_color(status)
    STATUS_COLORS[status.to_sym] || "badge-secondary"
  end
end
