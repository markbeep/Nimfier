import dimscord, asyncdispatch, times, options, strutils

const token = readFile("token.txt")
let discord = newDiscordClient(token)

# Event for on_ready
proc onReady(s: Shard, r: Ready) {.event(discord).} =
    echo "Bot logged in as " & $r.user


proc commandHandler(content: var string, prefix: string): seq[string] =
    # checks if the message starts with the given prefix
    if not content.startsWith(prefix):
        return @[]  # empty sequence if its unrelevant
    
    # removes the prefix from the content
    content = content.replace(prefix)
    
    # splits the given message content into a sequence of strings
    var args = content.split(" ")

    return args


# Ping command to see ping of the bot
proc ping(m:Message, args:seq[string]): Future[Message] {.async.} =
    let t0 = getTime()
    let msg = await discord.api.sendMessage(m.channel_id, "ayy lmao")
    let delta = getTime() - t0
    discard await discord.api.editMessage(channel_id=msg.channel_id, message_id=msg.id, content="Ping: " & $delta.inMilliseconds & " ms.")


# Event for message_create
proc messageCreate(s: Shard, m:Message) {.event(discord).} =
    if m.author.bot:
        return

    var args = commandHandler(m.content, "nim ")
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