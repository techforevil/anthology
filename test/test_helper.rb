ENV["RAILS_ENV"] = "test"
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'webmock/test_unit'

require 'fixtures/factories'
require 'fixtures/mock_book_metadata_lookup'

require 'mocha/setup'

DatabaseCleaner.strategy = :transaction
DatabaseCleaner.clean

WebMock.disable_net_connect!

include Warden::Test::Helpers

class ActiveSupport::TestCase
  def setup
    DatabaseCleaner.start
    Book.metadata_lookup = MockBookMetadataLookup.new # stub the metadata lookup class in tests
  end

  def teardown
    DatabaseCleaner.clean
  end

  def login_as_stub_user
    @user = FactoryGirl.create(:user, :name => 'Ian Fleming')
    request.env['warden'] = stub(:authenticate! => true, :authenticated? => true, :user => @user)
  end
end
