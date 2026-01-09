module Kern
  class ApplicationMailer < (defined?(ActionMailer::Base) ? ActionMailer::Base : Object)
    default from: "from@example.com" if defined?(ActionMailer::Base)
    layout "mailer" if defined?(ActionMailer::Base)
  end
end
