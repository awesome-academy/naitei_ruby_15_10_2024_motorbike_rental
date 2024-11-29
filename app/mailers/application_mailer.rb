# frozen_string_literal: true

# The ApplicationMailer class is the base class for all mailers in the application.
# It is used to set default configurations for all outgoing emails, such as the "from"
# address and the layout to be used for email views. Specific mailers can inherit
# from ApplicationMailer to apply these settings and define email content.
class ApplicationMailer < ActionMailer::Base
  # Set the default "from" email address for all emails sent by the app
  default from: 'from@example.com'

  # Specify the default layout to be used for email views
  layout 'mailer'
end
