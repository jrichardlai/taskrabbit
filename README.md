For the case when we have to set the client_secret

To get an user:

@api = Taskrabbit::API.new(client_secret)
@api.user(some_user_id)

To have a authenticated user:

class User
  :token
end

@api  = Taskrabbit::API.new(client_secret)     | Taskrabbit::API.client_secret = 'client_secret'
@api.login(email, password)                    | TaskRabbit::API.login()
or
@api.signup()                                  | TaskRabbit::API.signup()
or
@api.oauth()                                   | TaskRabbit::API.oauth()


login/oauth => /api/v1/oauth

TaskRabbit::API.tasks.all
TaskRabbit::API.users.all

TaskRabbit::API.logout

@user = TaskRabbit::API.current_user
@user.account # will do GET account and return a User
@user.tasks.all
@user.tasks.find(321)
@user.tasks.create()

@task = @user.tasks.create /api/v1/tak

If stored card missing

if @task.need_card?
   @task.set_card(card_informations)
end


@client.tasks.create(some_params)

OR if we put in some initializer:

Taskrabbit::API.client_secret = 'client_secret'

To get an user:

Taskrabbit.user(some_user_id)

For Oauth:

@user = Taskrabbit.oauth(some_user_oauth_token)
@user.account # will do GET account and return a User

Should I use api/users since oauth/users display a view
Which endpoint use to create the user ?

one need the stored card