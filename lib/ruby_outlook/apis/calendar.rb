module RubyOutlook
  class Client

    def get_calendars(**args)
      request_url  = "/#{user_or_me(args[:user])}#{"/calendargroups/#{args[:calendar_group_id]}" if args[:calendar_group_id].present?}/calendars"
      request_params = build_request_params(args)

      response = make_api_call(:get, request_url, request_params)
      JSON.parse(response)
    end

    def sync_events(start_date_time, end_date_time, **args)
      request_url  = "/#{user_or_me(args[:user])}#{"/calendars('#{args[:calendar_id]}')" if args[:calendar_id].present?}/calendarview"
      request_params = build_request_params(args)

      request_params['startDateTime'] = start_date_time.respond_to?(:iso8601) ? start_date_time.iso8601 : start_date_time
      request_params['endDateTime']   = end_date_time.respond_to?(:iso8601)   ? end_date_time.iso8601   : end_date_time

      headers = {
        'Prefer' => ['odata.track-changes', "odata.maxpagesize=#{args[:max_page_size].presence || 50}"]
      }

      response = make_api_call(:get, request_url, request_params, headers)
      JSON.parse(response)
    end

    # TODO - fix
    # token (string): access token
    # view_size (int): maximum number of results
    # page (int): What page to fetch (multiple of view size)
    # fields (array): An array of field names to include in results
    # sort (hash): { sort_on => field_to_sort_on, sort_order => 'ASC' | 'DESC' }
    # user (string): The user to make the call for. If nil, use the 'Me' constant.
    def get_events(token, view_size, page, fields = nil, sort = nil, user = nil)
      request_url = "/api/v2.0/" << (user.nil? ? "Me" : ("users/" << user)) << "/Events"
      request_params = {
        '$top' => view_size,
        '$skip' => (page - 1) * view_size
      }

      unless fields.nil?
        request_params['$select'] = fields.join(',')
      end

      unless sort.nil?
        request_params['$orderby'] = sort[:sort_field] + " " + sort[:sort_order]
      end

      get_events_response = make_api_call "GET", request_url, token, request_params

      JSON.parse(get_events_response)
    end

    # TODO - fix
    # token (string): access token
    # id (string): The Id of the event to retrieve
    # fields (array): An array of field names to include in results
    # user (string): The user to make the call for. If nil, use the 'Me' constant.
    def get_event_by_id(token, id, fields = nil, user = nil)
      request_url = "/api/v2.0/" << (user.nil? ? "Me" : ("users/" << user)) << "/Events/" << id
      request_params = nil

      unless fields.nil?
        request_params = { '$select' => fields.join(',') }
      end

      get_event_response = make_api_call "GET", request_url, token, request_params

      JSON.parse(get_event_response)
    end

    # TODO - fix
    # token (string): access token
    # window_start (DateTime): The earliest time (UTC) to include in the view
    # window_end (DateTime): The latest time (UTC) to include in the view
    # id (string): The Id of the calendar to view
    #              If nil, the default calendar is used
    # fields (array): An array of field names to include in results
    # user (string): The user to make the call for. If nil, use the 'Me' constant.
    def get_calendar_view(token, window_start, window_end, id = nil, fields = nil, user = nil)
      request_url = "/api/v2.0/" << (user.nil? ? "Me" : ("users/" << user))

      unless id.nil?
        request_url << "/Calendars/" << id
      end

      request_url << "/CalendarView"

      request_params = {
        'startDateTime' => window_start.strftime('%Y-%m-%dT00:00:00Z'),
        'endDateTime' => window_end.strftime('%Y-%m-%dT00:00:00Z')
      }

      unless fields.nil?
        request_params['$select'] = fields.join(',')
      end

      get_view_response =make_api_call "GET", request_url, token, request_params

      JSON.parse(get_view_response)
    end

    # TODO - fix
    # token (string): access token
    # payload (hash): a JSON hash representing the event entity
    # folder_id (string): The Id of the calendar folder to create the event in.
    #                     If nil, event is created in the default calendar folder.
    # user (string): The user to make the call for. If nil, use the 'Me' constant.
    def create_event(token, payload, folder_id = nil, user = nil)
      request_url = "/api/v2.0/" << (user.nil? ? "Me" : ("users/" << user))

      unless folder_id.nil?
        request_url << "/Calendars/" << folder_id
      end

      request_url << "/Events"

      create_event_response = make_api_call "POST", request_url, token, nil, nil, payload

      JSON.parse(create_event_response)
    end

    # TODO - fix
    # token (string): access token
    # payload (hash): a JSON hash representing the updated event fields
    # id (string): The Id of the event to update.
    # user (string): The user to make the call for. If nil, use the 'Me' constant.
    def update_event(token, payload, id, user = nil)
      request_url = "/api/v2.0/" << (user.nil? ? "Me" : ("users/" << user)) << "/Events/" << id

      update_event_response = make_api_call "PATCH", request_url, token, nil, nil, payload

      JSON.parse(update_event_response)
    end

    # TODO - fix
    # token (string): access token
    # id (string): The Id of the event to delete.
    # user (string): The user to make the call for. If nil, use the 'Me' constant.
    def delete_event(token, id, user = nil)
      request_url = "/api/v2.0/" << (user.nil? ? "Me" : ("users/" << user)) << "/Events/" << id

      delete_response = make_api_call "DELETE", request_url, token

      return nil if delete_response.nil? || delete_response.empty?

      JSON.parse(delete_response)
    end

  end
end
