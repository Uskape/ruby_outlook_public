module RubyOutlook
  class Client

    def joined_teams(**args)
      request_url  =  "/#{user_or_me(args[:user])}/joinedTeams"
      request_params = build_request_params(args)
      response = make_api_call(:get, request_url, request_params)
      JSON.parse(response)
    end

    def get_team_members(id)
      request_url  =  "/teams/#{id}/members"
      response = make_api_call(:get, request_url)
      JSON.parse(response)
    end
    
    # https://docs.microsoft.com/en-us/graph/api/team-get-members?view=graph-rest-1.0&tabs=http
    def get_team_member(team_id, member_id)
      request_url  =  "/teams/#{team_id}/members/#{member_id}"
      response = make_api_call(:get, request_url)
      JSON.parse(response)
    end

    def get_channels(id)
      request_url  =  "/teams/#{id}/channels"
      response = make_api_call(:get, request_url)
      JSON.parse(response)
    end

    def get_channel_messages(team_id, id)
      request_url = "/teams/#{team_id}/channels/#{id}/messages"
      response = make_api_call(:get, request_url)
      JSON.parse(response)
    end

    def get_message(team_id, channel_id, id)
      request_url = "/teams/#{team_id}/channels/#{channel_id}/messages/#{id}"
      response = make_api_call(:get, request_url)
      JSON.parse(response)
    end

    def send_reply(team_id, channel_id, id, args)
      request_url = "/teams/#{team_id}/channels/#{channel_id}/messages/#{id}/replies"
      response = make_api_call(:post, request_url, nil, nil, args)
      JSON.parse(response)
    end

    def get_replies(team_id, channel_id, id, **args)
      request_url = "/teams/#{team_id}/channels/#{channel_id}/messages/#{id}/replies"
      request_params = build_request_params(args)
      response = make_api_call(:get, request_url, request_params)
      JSON.parse(response)
    end

    def get_user(id)
      request_url = "/users/#{id}"
      response = make_api_call(:get, request_url)
      JSON.parse(response)
    end

    def create_channel(team_id, args)
      request_url = "/teams/#{team_id}/channels"
      response = make_api_call(:post, request_url, nil, nil, args)
      JSON.parse(response)
    end

    def send_message(team_id, channel_id, args)
      request_url = "/teams/#{team_id}/channels/#{channel_id}/messages"
      response = make_api_call(:post, request_url, nil, nil, args)
      JSON.parse(response)
    end
  end
end
