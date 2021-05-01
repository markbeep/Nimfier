import strutils

proc splitArguments*(content: var string, prefix: string): seq[string] =
    # checks if the message starts with the given prefix
    if not content.startsWith(prefix):
        return @[]  # empty sequence if its unrelevant
    
    # removes the prefix from the content
    content = content.replace(prefix)
    
    # splits the given message content into a sequence of strings
    var args = content.split(" ")

    return args