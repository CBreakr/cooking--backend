class UsersController < ApplicationController
    ### very simple for now, we'll do this for real later
    # register
    # login

    skip_before_action :authorized, except: :ping

    def index
        render json: User.all 
    end

    def register 
        # user = User.create(user_params)
        # set_user(user)
        # render json: user, except: [:created_at, :updated_at]

        user = User.create(user_params)
        # spoonacular = User.find_by(name: '')
        user.follow_default
        if user.save
            token = encode_token(user_id: user.id)
            render json: { id: user.id, name: user.name, jwt: token }, status: :created
        else
            render json: { error: 'failed to create user' }, status: :not_acceptable
        end
    end
    
    def login
        # user = User.find_by(name: user_params[:name])
        # set_user(user)
        # render json: user, except: [:created_at, :updated_at]

        user = User.find_by(name: user_params[:name])
        #User#authenticate comes from BCrypt

        puts "FOUND USER?"
        puts user

        up = user_params
        puts up[:password_digest]

        if user && user.authenticate(up[:password])
            # encode token comes from ApplicationController
            puts "AUTHENTICATED"
            token = encode_token({ user_id: user.id })
            render json: { id: user.id, name: user.name, jwt: token }, status: :accepted
        else
            puts "NOT AUTHENTICATED"
            render json: { message: 'Invalid username or password' }, status: :unauthorized
        end
    end

    def logout
        # set_user(nil)
        #
        # hmm, is there a way to invalidate the token?
        #
    end

    def ping
        # do nothing, just trigger the authorized function
        puts "PING"
        puts "PING"
        puts "PING"
        puts "PING"
        puts "PING"
        puts "PING"
        puts "PING"
        puts "PING"
        puts "PING"
        puts "PING"
        render json: {success: true}
    end

    def following
        user = User.find(params[:id].to_i)
        users = user.followings 
        render json: users, except: [:created_at, :updated_at]
    end

    def trigger_reset 

        puts "trigger_reset"

        username = params[:username]

        puts username

        user = User.find_by(name: username)

        if user then

            prk = PasswordResetKey.createForUser(username)

            # send email to user with link
            prk.send_email(user)

            # create key, save record, send email
            puts "user match to trigger reset"
            render json: {success: true}
        else
            puts "no user match to trigger reset"
            render json: {success: false}
        end
    end

    def password_reset
        reset_key = params[:key]
        username = params[:username]
        password = params[:password]

        puts reset_key
        puts username
        puts password

        reset = PasswordResetKey.find_by(username: username, reset_key: reset_key)

        if reset then

            puts "we have a reset key"

            json = {reset: false}

            if reset.expiration > Date.today then
                reset.destroy
                user = User.find_by(name: username)
                user.password = password
                user.save

                reset.destroy

                token = encode_token(user_id: user.id)
                json = { id: user.id, name: user.name, jwt: token }
            end

            render json: json
        else
            puts "no reset key found"
            render json: {reset: false}
        end
    end

    private
    def user_params
        puts params
        params.require(:user).permit(:name, :password)
    end
end
