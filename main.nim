import dimscord, asyncdispatch, times, options, strutils, modules/commandHandler

const token = readFile("token.txt")
let discord = newDiscordClient(token)
let prefix = "nim "

# Event for on_ready
proc onReady(s: Shard, r: Ready) {.event(discord).} =
    echo "Bot logged in as " & $r.user


proc ping(m:Message, args:seq[string]): Future[Message] {.async.} =
    ## Ping command to see the ping of the bot to
    ## the Discord servers
    let t0 = getTime()
    var msg = await discord.api.sendMessage(m.channel_id, "ayy lmao")
    let delta = getTime() - t0
    discard await discord.api.editMessage(msg.channel_id, msg.id, "Ping: " & $delta.inMilliseconds & " ms.")

# Event for message_create
proc messageCreate(s: Shard, m:Message) {.event(discord).} =
    if m.author.bot:
        return

    var args = splitArguments(m.content, prefix)
    # returns if the args are empty
    if args.len() == 0:
        return

    let command = args[0]
    args = args[1..^1]

    case command.toLowerAscii():
    of "ping":
        discard ping(m, args)


# Connect to Discord and run the bot
waitFor discord.startSession()