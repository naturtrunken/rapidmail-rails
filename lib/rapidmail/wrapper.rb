module Rapidmail
  class Wrapper
    attr_reader :username, :password

    # Wraps the credentials for an API
    # @param [String] username The API username
    # @param [String] password The API password
    # @return [Rapidmail] The Rapidmail object
    def initialize(username, password)
      @username = username
      @password = password
    end

    # Create a List object for the given list.
    # @param [Integer] list_id The ID of the list.
    def list(list_id)
      List.new(list_id, @username, @password)
    end

  end
end
