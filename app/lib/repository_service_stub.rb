# frozen_string_literal: true

class RepositoryServiceStub
  class << self
    Git = Struct.new(:log)
    Logger = Struct.new(:sha)

    def shallow_clone!(*)
      log = []
      logger = Logger.new('f09a50c39d92efd5ed65a87fb07f64675baa8774')
      log << logger
      Git.new(log)
    end
  end
end
