module ApplicationHelper
  include Pagy::Frontend
  def full_title(page_title)
    base_title = t "title.page_title"
    page_title.blank? ? base_title : "#{page_title} | #{base_title}"
  end

  def home_link
    Settings.default.href.home_href
  end

  def time_options
    start_time = Time.current.beginning_of_day
    end_time = Time.current.end_of_day

    times = []
    while start_time <= end_time
      times << [start_time.strftime("%H:%M, %d/%m/%Y"), start_time.strftime("%Y-%m-%dT%H:%M")]
      start_time += 30.minutes
    end
    times
  end
end
