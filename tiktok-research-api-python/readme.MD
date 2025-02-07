# TikTok Research API Python Package
This Python package provides a client library for interacting with the TikTok Research API.

> [!NOTE]
> Changes to the original repo from TikTok to the python implementation.  Search requests are only repeated, when the response is 500 (internal error) and the client can poll again in a second. When the server responses, that the query or parameters are invalid, there is no point in staying in the loop and keeping to poll...  

## Getting Started

Below we provide the examples of the queries using the Wrapper, illustrate its functionality, as well as provide some examples of the types of analysis possible with TikTok Research API

The information on TikTok Research API can be found here: https://developers.tiktok.com/doc/research-api-codebookhttps://developers.tiktok.com/doc/research-api-codebook

### Let's install the package


### Loading the Wrapper


```python
from tiktok_research_api import *
```

 First thing first, you need to initialize the API client. For that you will need you client_key and client_secret that you will see in your TikTok for Developers portal  https://developers.tiktok.com/research after your application has been approved


```python
# Initialize the API client
qps = 5 #rate limiter
client_key = 'your_client_key'
client_secret = 'your_client_secret'
research_api = TikTokResearchAPI(client_key, client_secret, qps)
```

## Querying 

Currently, the Research API Wrapper supports following endpoints:

- Videos endpoint

- Users endpoint

- Comments endpoint

- User Pinned Videos endpoint

- User Liked Videos endpoint

- User Reposted Videos endpoint

- User Following endpoint

- User Followers endpoint



### Pagination

If you want to retrieve more than 100 videos (max_count of videos per response), you need search_id and cursor. 

Search_id - unique identifier assigned to a cached search result. This identifier enables the resumption of a prior search and retrieval of additional results based on the same search criteria. The unique identifier assigned to a cached search result. 

Cursor - index assigned to a video, allowing you to continue your query where you left off.


The wrapper faciltates the pagination, through following arguments:

'fetch_all_pages" (default is False) argument. When set to True, handles pagination automatically. If False, it returns only the initial API response.

'max_total' (default is 100000) argument. If you want to return more than max_count, but limit for how much is returned.

For Video Endpoint, the Wrapper allows to query for a period for more than 30 days, but continuing the search would require start_date and end_date (returned in response)

For the endpoints listed below, enabling the "fetch_all_pages" argument allows automatic pagination. When enabled, the function handles pagination automatically. If disabled (set to false) or left unset, it returns only the initial API response.

| R Wrapper Function      | API Endpoint |
| ----------- | ----------- |
| query_videos      | /v2/research/video/query/|
| query_user_followers   | /v2/research/user/followers/|
| query_user_following   | /v2/research/user/following/|
| query_user_liked_videos   | /v2/research/user/liked_videos/|
| query_video_comments   | /v2/research/video/comment/list/|
| query_user_reposted_videos   | /v2/research/user/reposted_videos/|

### To query Videos endpoint

If you decide to query the video endpoint, the possible options are below.
Can search using one of:

"create_date": when the video was created

"username": the handle/username of the creator

"region_code": the region where the video was uploaded

"video_id": the unique ID of the video

"hashtag_name": indexed hashtag

"keyword": a string in the video description (can be a hashtag or something else)

"music_id": the unique ID of the audio

"effect_id": the unique ID of the effects used

"video_length": the length of the video in seconds

OPERATIONS:

"EQ" = equal to

"IN" = in a list

"GT" = greater than

"GTE" = greater than or equal to

"LT" = less than

"LTE" = less than or equal to

All search values should be input as a list of strings. E.g., region_code: ['US','CA']

All possible regions: 'FR', 'TH', 'MM', 'BD', 'IT', 'NP', 'IQ', 'BR', 'US', 'KW', 'VN', 'AR', 'KZ', 'GB', 'UA', 'TR', 'ID', 'PK', 'NG', 'KH', 'PH', 'EG', 'QA', 'MY', 'ES', 'JO', 'MA', 'SA', 'TW', 'AF', 'EC', 'MX', 'BW', 'JP', 'LT', 'TN', 'RO', 'LY', 'IL', 'DZ', 'CG', 'GH', 'DE', 'BJ', 'SN', 'SK', 'BY', 'NL', 'LA', 'BE', 'DO', 'TZ', 'LK', 'NI', 'LB', 'IE', 'RS', 'HU', 'PT', 'GP', 'CM', 'HN', 'FI', 'GA', 'BN', 'SG', 'BO', 'GM', 'BG', 'SD', 'TT', 'OM', 'FO', 'MZ', 'ML', 'UG', 'RE', 'PY', 'GT', 'CI', 'SR', 'AO', 'AZ', 'LR', 'CD', 'HR', 'SV', 'MV', 'GY', 'BH', 'TG', 'SL', 'MK', 'KE', 'MT', 'MG', 'MR', 'PA', 'IS', 'LU', 'HT', 'TM', 'ZM', 'CR', 'NO', 'AL', 'ET', 'GW', 'AU', 'KR', 'UY', 'JM', 'DK', 'AE', 'MD', 'SE', 'MU', 'SO', 'CO', 'AT', 'GR', 'UZ', 'CL', 'GE', 'PL', 'CA', 'CZ', 'ZA', 'AI', 'VE', 'KG', 'PE', 'CH', 'LV', 'PR', 'NZ', 'TL', 'BT', 'MN', 'FJ', 'SZ', 'VU', 'BF', 'TJ', 'BA', 'AM', 'TD', 'SI', 'CY', 'MW', 'EE', 'XK', 'ME', 'KY', 'YE', 'LS', 'ZW', 'MC', 'GN', 'BS', 'PF', 'NA', 'VI', 'BB', 'BZ', 'CW', 'PS', 'FM', 'PG', 'BI', 'AD', 'TV', 'GL', 'KM', 'AW', 'TC', 'CV', 'MO', 'VC', 'NE', 'WS', 'MP', 'DJ', 'RW', 'AG', 'GI', 'GQ', 'AS', 'AX', 'TO', 'KN', 'LC', 'NC', 'LI', 'SS', 'IR', 'SY', 'IM', 'SC', 'VG', 'SB', 'DM', 'KI', 'UM', 'SX', 'GD', 'MH', 'BQ', 'YT', 'ST', 'CF', 'BM', 'SM', 'PW', 'GU', 'HK', 'IN', 'CK', 'AQ', 'WF', 'JE', 'MQ', 'CN', 'GF', 'MS', 'GG', 'TK', 'FK', 'PM', 'NU', 'MF', 'ER', 'NF', 'VA', 'IO', 'SH', 'BL', 'CU', 'NR', 'TP', 'BV', 'EH', 'PN', 'TF', 'RU'

API Documention: https://developers.tiktok.com/doc/research-api-specs-query-videos/



```python
# Define query object
query_criteria_1 = Criteria(
    operation="EQ", field_name="hashtag_name", field_values=["hashtag"]
)
query_criteria_2 = Criteria(
    operation="IN", field_name="region_code", field_values=["region"]
)

# You can define criteria using:
#'and_criteria' specify that all the conditions in the list must be met
#'or_criteria' specify that at least one of the conditions in the list must be met
#'not_criteria' specify that none of the conditions in the list must be met
query = Query(and_criteria=[query_criteria_1, query_criteria_2])
```


```python
video_fields = "id,create_time,username,region_code,video_description,video_duration,hashtag_names,view_count,like_count,comment_count,share_count"
video_columns = video_fields.split(',')
video_request = QueryVideoRequest(
    fields=video_fields,    
    query = query,
    start_date="20240101",
    end_date="20240201",
    max_count=100,
    max_total = 1000
)

videos, search_id, cursor, has_more, start_date, end_date = research_api.query_videos(video_request, fetch_all_pages=True)

```

If you want to continue your search, you can specify your search_id, cursor, and start_date, and end_date in your next query. Please make sure to use search_id provided at the end of the query.


```python
video_request = QueryVideoRequest(
    fields=video_fields,    
    query = query,
    start_date=start_date,
    end_date=end_date,
    max_count=100,
    max_total = 1000,
    search_id = search_id,
    cursor = cursor

)

videos, search_id, cursor, has_more, start_date, end_date = research_api.query_videos(video_request, fetch_all_pages=True)
```

### Query Users endpoint


```python
username = "username"
user_info_request = QueryUserInfoRequest(
    username= username
)
userinfo = research_api.query_user_info(user_info_request)
```

### Query Comments 


```python
video_id="video_id"
video_comment_request = QueryVideoCommentsRequest(
    video_id=video_id,        
    max_count=100,
)
comments, cursor, has_more = research_api.query_video_comments(video_comment_request, fetch_all_pages=False)
```

### Query User Pinned Videos


```python
username = "username"
user_pinned_videos_request = QueryUserPinnedVideosRequest(
    username= username
)
pinned_videos = research_api.query_user_pinned_videos(user_pinned_videos_request)
```

### Query User Liked Videos


```python
username = "username"
user_liked_videos = QueryUserLikedVideosRequest(
    username= username
)
liked_videos, cursor, has_more = research_api.query_user_liked_videos(user_liked_videos)
```

### Query Reposted Videos


```python
username="username"
reposted_videos_request = QueryUserRepostedVideosRequest(
    username=username                                                
)
reposted_videos, cursor, has_more  = research_api.query_user_reposted_videos(reposted_videos_request)
```

### Query User Following


```python
username = "username"
user_following_request = QueryUserFollowingRequest(
    username= username
)
user_following, cursor, has_more = research_api.query_user_following(user_following_request, fetch_all_pages=False)
```

### Query User Followers


```python
username = "username"
user_followers_request = QueryUserFollowersRequest(
    username= username
)
user_followers = research_api.query_user_followers(user_followers_request, fetch_all_pages=False)
```

For additional functionality demonstration: please refer to [Tutorial Notebook](https://github.com/tiktok/tiktok-research-api-wrapper/blob/main/tiktok-research-api-python/examples/python_tutorial_notebook.ipynb)
