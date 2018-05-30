require 'faraday'

module Rapidmail
  class List
    attr_reader :id, :conn

    def initialize(list_id, username, password)
      @id = list_id.to_i
      @conn = create_connection(username, password)

      # Make sure that the list is available.
      raise NotFoundException unless list_available?(list_id)
    end

    # Returns an array of recipients of this list.
    # @param [Hash] filter Optional filter arguments.
    # @return [Array] Array of recipient objects.
    def recipients(filter = {})
      # TODO Add other filters

      additional_parameters = ''
      additional_parameters += "&email=#{filter['email']}" if filter['email']

      response = @conn.get("/recipients?recipientlist_id=#{@id}#{additional_parameters}")
      json_response = JSON.parse(response.body)

      # If the response contains the ID of the given list id, then the list exists.
      json_response['_embedded']['recipients'].map do |recipient_hash|
        ::Rapidmail::Recipient.new(recipient_hash)
      end
    rescue
      nil
    end

    # Is true if the given email exists as a recipient on this list.
    # @param [String] email Email of a recipient
    # @return [Boolean] See description
    def recipient?(email)
      response = @conn.get("/recipients?recipientlist_id=#{@id}&email=#{email}")
      json_response = JSON.parse(response.body)

      # If the response contains the ID of the given list id, then the list exists.
      (json_response['total_items'].to_i != 0)
    rescue
      false
    end

    # Retrieves all stored data about a recipient identified by its email.
    # @param [String] email Email of a recipient
    # @return [Recipient] Recipient with the given email or nil.
    def recipient(email)
      recipients({'email' => email})[0]
    rescue
      nil
    end

    # Adds the given recipient to this list.
    # @param [Recipient] recipient The recipient object
    # @param [Boolean] double_opt_in If true (default) then a double opt in process starts and the recipient is added to the "New" list. If set to false, the recipient is added directly to the "Active" list.
    # @params [Boolean] True if the recipient could be added.
    def add(recipient, double_opt_in = true)
      # Build the request's body.
      body = {
        recipientlist_id: @id,
        status: (double_opt_in ? 'new' : 'active')
      }
      Recipient::FIELDS.each {
        |field| body[field] = recipient.send(field)
      }

      response = @conn.post(
        "/recipients",
        body.except('id').to_json
      ) do |req|
        req.headers['Content-Type'] = 'application/json'
      end
      json_response = JSON.parse(response.body)

      # If the response contains the ID of the given list id, then the list exists.
      (json_response['email'] == recipient.email)
    rescue => e
      false
    end

    # Updates the given recipient to this list.
    # @param [Recipient] recipient The recipient object
    # @params [Boolean] True if the recipient could be updated.
    def update(recipient)
      throw MissingRecipientIdException unless recipient.id

      # Build the request's body.
      body = {}
      Recipient::FIELDS.each {
        |field| body[field] = recipient.send(field)
      }

      response = @conn.patch(
        "/recipients/#{recipient.id}",
        body.except('id').to_json
      ) do |req|
        req.headers['Content-Type'] = 'application/json'
      end
      json_response = JSON.parse(response.body)

      # If the response contains the ID of the given list id, then the list exists.
      (json_response['email'] == recipient.email)
    rescue => e
      false
    end

    # Deltes the given recipient from this list.
    # @param [Recipient] recipient The recipient object
    # @params [Boolean] True if the recipient could be deleted.
    def delete(recipient)
      throw MissingRecipientIdException unless recipient.id

      response = @conn.delete(
        "/recipients/#{recipient.id}"
      )
      response.body == ''
    rescue
      false
    end

    protected

    # Creates a Faraday connection with some configuration.
    # @param [String] username The API username
    # @param [String] password The API password
    # @return [Faraday::Connection] The connection object
    def create_connection(username, password)
      ::Faraday.new(url: API_URL) do |faraday|
        faraday.adapter(Faraday.default_adapter)
        faraday.basic_auth(username, password)
      end
    end

    # Is true if the given list exists for the given user.
    # @params [Integer] list_id The list id
    # @params [Boolean] True if the user has access to the given list.
    def list_available?(list_id)
      response = @conn.get("/recipientlists/#{list_id}")
      json_response = JSON.parse(response.body)

      # If the response contains the ID of the given list id, then the list exists.
      (json_response['id'].to_i == list_id)
    rescue
      false
    end

  end
end
