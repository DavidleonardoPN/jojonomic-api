module API
  module V1
    class Authentication < Grape::API
      format :json
      
      resource :auth do
        get do
          Auth.generate_token
        end
      end
    end
  end
end
