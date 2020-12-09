class Auth < ApplicationRecord
  self.table_name = "authentications"

  def self.generate_token
    build_payload
    @token = JWT.encode(@payload, "qwertyuiopasdfghjklzxcvbnm123456")
    @expired_at = Time.now + 2.hours

    create(token: @token, expired_at: @expired_at)
    @response = {
                "token_type": "Bearer",
                "access_token": @token,
                "expired_at": @expired_at
               }

    return @response
  end


  def self.decoded_token(headers)
    auth_header = headers["Authorization"]
    if auth_header
      token = auth_header.split(' ')[1]
      begin
        @auth = Auth.where(token: token).last

        if @auth
          if Time.now <= @auth.expired_at
            @decode_token = JWT.decode(token, "qwertyuiopasdfghjklzxcvbnm123456", true, algorithm: 'HS256')
            @response = @decode_token
          else
            @response = "expired"
          end
        else
          @response = "not found"
        end

        return @response
      rescue JWT::DecodeError
        nil
      end
    end
  end

  def self.build_payload
    @payload = {
      "iss": "Jojonomic",
      "iat": 1606696296,
      "exp": 1638232296,
      "aud": "jojonomic.com",
      "sub": "jojoarief",
      "company_id": "130",
      "user_id": "120"
    }
  end
end
