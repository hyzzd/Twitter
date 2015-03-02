## Twitter (03/01/15)

This Twitter app improves on the functionality from before with an additional hamburger menu, mentions page, and profile page.

Time spent: `10 hours`

### Features

#### Required

- [x] Dragging anywhere in the view should reveal the menu.
- [x] The menu should include links to your profile, the home timeline, and the mentions view.
- [x] Profile page contains the user header view.
- [x] Profile page contains a section with the users basic stats: # tweets, # following, # followers.
- [x] Tapping on a user image should bring up that user's profile page.

### Walkthrough

![Video Walkthrough](twitter-round-2.gif)


## Twitter (02/22/15)

This is a basic Twitter app to read and compose tweets via the [Twitter API](https://apps.twitter.com/).

Time spent: `10 hours`

### Features

#### Required

- [x] User can sign in using OAuth login flow.
- [x] User can view last 20 tweets from their home timeline.
- [x] The current signed in user will be persisted across restarts.
- [x] In the home timeline, user can view tweet with the user profile picture, username, tweet text, and timestamp.  In other words, design the custom cell with the proper Auto Layout settings.  You will also need to augment the model classes.
- [x] User can pull to refresh.
- [x] User can compose a new tweet by tapping on a compose button.
- [x] User can tap on a tweet to view it, with controls to retweet, favorite, and reply.
- [x] User can retweet, favorite, and reply to the tweet directly from the timeline feed.

#### Optional

- [x] When composing, you should have a countdown in the upper right for the tweet limit.
- [ ] After creating a new tweet, a user should be able to view it in the timeline immediately without refetching the timeline from the network.
- [x] Retweeting and favoriting should increment the retweet and favorite count.
- [x] User should be able to unretweet and unfavorite and should decrement the retweet and favorite count. (_NOTE_: unretweeting doesn't work yet, but everything else does.)
- [x] Replies should be prefixed with the username and the reply_id should be set when posting the tweet.
- [ ] User can load more tweets once they reach the bottom of the feed using infinite loading similar to the actual Twitter client.

#### Extra

- [x] Refresh control is rate limited by the app to only query the API up to once per minute. The remainder of the time it fetches tweets from (and stores them in) NSUserDefaults.

### Walkthrough

![Video Walkthrough](twitter.gif)
