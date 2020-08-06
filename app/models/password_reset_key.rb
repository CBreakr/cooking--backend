class PasswordResetKey < ApplicationRecord

    @@chars = ["0","1","2","3","4","5","6","7","8","9","A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z"]

    def self.createForUser(username)
        prk = PasswordResetKey.new

        prk.username = username
        prk.expiration = DateTime.now + 30.minutes

        prk.reset_key = ""

        8.times do
            prk.reset_key += @@chars.sample
        end
        
        puts "NEW KEY NEW KEY NEW KEY NEW KEY"
        puts prk.username
        puts prk.reset_key
        puts prk.expiration

        prk.save

        return prk
    end

    def send_email(user)
        url = URI("https://api.pepipost.com/v5/mail/send")

        http = Net::HTTP.new(url.host, url.port)

        puts url.host
        puts url.port

        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        request = Net::HTTP::Post.new(url)

        request["content-type"] = 'application/json'
        request["api_key"] = ENV['MAIL_KEY']

        puts "MAILKEY MAILKEY MAILKEY MAILKEY MAILKEY"
        puts ENV['MAIL_KEY']

        # request.body = "{\"from\":{\"email\":\"robnotwicz@pepisandbox.com\",\"name\":\"Flight confirmation\"},\"subject\":\"Your Barcelona flight e-ticket : BCN2118050657714\",\"content\":[{\"type\":\"html\",\"value\":\"Hello Lionel, Your flight for Barcelona is confirmed.\"}],\"personalizations\":[{\"to\":[{\"email\":\"rob.notwicz@gmail.com\",\"name\":\"Lionel Messi\"}]}]}"

        # request.body = "{\"from\":{\"email\":\"robnotwicz@pepisandbox.com\",\"name\":\"robnotwicz\"},\"subject\":\"Your Barcelona flight e-ticket : BCN2118050657714\",\"content\":[{\"type\":\"html\",\"value\":\"Hello Lionel, Your flight for Barcelona is confirmed.\"}],\"personalizations\":[{\"to\":[{\"email\":\"rob.notwicz@gmail.com\",\"name\":\"Lionel Messi\"}]}]}"

        base_url = "http://localhost:3001/reset"

        body = "Please click the following link to reset password: <a href='#{base_url}/#{self.reset_key}'>CLICK</a>, this key will expire at " + self.expiration.strftime("%d/%m/%Y %I:%M %p")

        puts body
        puts user.email

        request.body = "{
            \"from\": {
                \"email\": \"robnotwicz@pepisandbox.com\",
                \"name\": \"pepi post\"
            },
            \"subject\": \"password reset: Pepi test email\",
            \"content\": [
                {
                    \"type\": \"html\",
                    \"value\": \"#{body}\"
                }
            ],
            \"personalizations\": [
                {
                    \"attributes\": {
                    \"LEAD\": \"Andy Dwyer\",
                    \"BAND\": \"Mouse Rat\"
                    },
                    \"to\": [
                    {
                        \"email\": \"#{user.email}\",
                        \"name\": \"Pepi\"
                    }
                    ]
                }
            ],
            \"settings\": {
                \"open_track\": true,
                \"click_track\": true,
                \"unsubscribe_track\": true
            }
        }"

        response = http.request(request)

        puts response.read_body
    end
end
