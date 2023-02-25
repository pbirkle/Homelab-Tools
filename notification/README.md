# Notification

## ntfy
### Server
for more information see [ntfy website](https://docs.ntfy.sh/install/)

### Client
use [ntfy.sh](./ntfy.sh) to send notifications:

```sh
# ARGUMENTS          | MANDATORY | DECRIPTION
# ------------------------------------------------------------------------------
# -h   --help        |           | show help
# -l   --login-token |           | login token for authorization
# -m   --message     |     x     | message to display
# -p   --priority    |           | priority of the notification
# -t   --title       |           | title of the notification
# -T   --tags        |           | tags of the notification
# -u   --url         |     x     | url of the ntfy instance including the topic

# e.g.
./ntfy.sh -l "[SECRET_TOKEN]" -m "message" -p "3" -t "title" -T "beer,dog,cat" -u "https://ntfy.sh/MY_TOPIC"
```