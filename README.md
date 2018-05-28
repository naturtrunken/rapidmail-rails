# Rapidmail::Rails
Short description and motivation.

## Usage


```ruby
# Create the API object and log in.
rapidmail = Rapidmail.new(username, password)

# Get the list to work with.
list = rapidmail.recipientlist(1234)

# Get Peter from the list by retrieving a list of all users,
# filtered by his email. This returns an array with one recipient
# or nil.
# (We could check this also with list.recipient?('peter@example.com')
# and then retrieving the record with the all function.)
all_recipients = list.all(email: 'peter@example.com')
if all_recipients.any?
  @peter = all_recipients[0]
else
  # He is not. To add him, we need a recipient object first which
  # can store also additional data.
  @peter = Rapidmail::Recipient.new(
    email: 'peter@example.com',
    firstname: 'Peter',
    lastname: 'Example'
  )
  
  # Let's create it.
  unless list.add(@peter)
    # Error handling
  end
end

# Of course we can add more details. See the rapidmail api description
# for all available fields.
@peter.extra1 = "Works in Freiburg."  

# Update the record.
unless list.update(@peter)
  # Error handling
end

# And finally remove Peter from the list.
unless list.delete(@peter)
  # Error handling
end

```


## Installation
Add this line to your application's Gemfile:

```ruby
gem 'rapidmail-rails'
```

And then execute:
```bash
$ bundle
```

Or install it yourself as:
```bash
$ gem install rapidmail-rails
```

## Contributing
Contribution directions go here.

## License
The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
