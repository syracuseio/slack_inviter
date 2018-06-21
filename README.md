# SlackInviter

[![Build Status](https://travis-ci.org/syracuseio/slack_inviter.svg?branch=master)](https://travis-ci.org/syracuseio/slack_inviter)

A small phoenix app that uses the Slack API to get display user counts, and invite users to join our slack group.

To run locally:
* `cp .env.example .env`
* update .env with your slack api token
* `mix deps.get`
* `cd assets && npm install && cd ..`
* `source .env`
* `mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

