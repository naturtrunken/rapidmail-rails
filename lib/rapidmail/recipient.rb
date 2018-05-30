module Rapidmail
  class Recipient
    attr_accessor :id, :email, :firstname, :lastname, :zip, :gender

    # Available string fields
    FIELDS = %w[
      id
      email
      firstname
      lastname
      gender
      zip
    ].freeze

    # Instantiates a new recipient object.
    # @param [Hash] values Attributes
    def initialize(values = {})
      FIELDS.each { |field| instance_variable_set("@#{field}", values[field]) }
    end

  end
end
