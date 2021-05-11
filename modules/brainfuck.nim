## This module interprets and runs brainfuck code

import sequtils

type
    WrongBrackets = ref object of ValueError
        position: int

proc checkBrackets(line: string): seq[int]
    ## Takes in a brainfuck string and
    ## checks if the brackets are set correctly.
    ## Returns an array of relative bracket positions.
    ## i-th Bracket has its counterpart at index i

proc runBrainfuck(line: string, input=""): string =
    ## Interprets brainfuck code from a string
    ## and returns the output of the code.
    var
        p: int  # pointer
        paraStack: seq[int]
        relPos: seq[int]
    
    try:
        relPos = checkBrackets(line)
    except WrongBrackets as e:
        return "Missing opening bracket for closing bracket at index " & $e.position & "."


proc checkBrackets(line: string): seq[int] =
    var
        paraStack: seq[char]
        relStack: seq[int]
        relPos: seq[int]
    
    # This part makes sure all the brackets are set correctly
    # If a bracket mistake is found, an error is raised
    for i, c in line:
        # We add -1 to each index. Used as a filler
        relPos.add(-1)

        if c == '[':
            paraStack.add('[')
            relStack.add(i)
        elif c == ']':
            if paraStack.len() == 0:
                var e: WrongBrackets
                new(e)
                e.msg = "Missing opening bracket."
                e.position = i
                raise e
            else:
                discard paraStack.pop()
                var opIdx = relStack.pop()
                relPos[opIdx] = i
                relPos[i] = opIdx

    # Turns all elements in the array to relative positions
    for i, n in relPos:
        if n == -1:
            # makes -1 into an unachievable relative
            # number which can then easily be removed
            relPos[i] = relPos.len
        else:
            relPos[i] = n - i
    
    # Removes all indexes with -1 in the relPos sequence
    relPos.keepIf(proc(x:int): bool = x != relPos.len)

    return relPos

echo runBrainfuck("[]")