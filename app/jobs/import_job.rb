class ImportJob < ApplicationJob
  queue_as :default

  def perform(contact_file_object)
    service = ContactFileService.new(contact_file_object)
    service.call
  end
end
