require "rapidmail/rails/railtie"
require 'rapidmail/recipient'
require 'rapidmail/list'
require 'rapidmail/wrapper'

module Rapidmail
  # API endpoint
  API_URL = 'https://apiv3.emailsys.net'.freeze

  # A general exception
  class Error < StandardError; end

  # Raised when the API returns a 403 status code.
  class ForbiddenException < Error; end

  # Raised when the API returns a 404 status code or
  # an object was not found in the response.
  class NotFoundException < Error; end

  # an object was not found in the response.
  class MissingRecipientIdException < Error; end

  def self.new(*args)
    Wrapper.new *args
  end
end
