module API
  module V1
    class Base < Grape::API
      mount API::V1::Authentication
      mount API::V1::DocumentService
      # mount API::V1::AnotherResource
    end
  end
end
