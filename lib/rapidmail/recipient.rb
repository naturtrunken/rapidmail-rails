module Rapidmail
  class Recipient
    attr_accessor :id, :email, :firstname, :lastname, :zip, :gender, :title

    # Available string fields
    FIELDS = %w[
      id
      email
      firstname
      lastname
      gender
      zip
      title
    ].freeze

    # Instantiates a new recipient object.
    # @param [Hash] values Attributes
    def initialize(values = {})
      FIELDS.each { |field| instance_variable_set("@#{field}", values[field]) }
    end

  end
end
