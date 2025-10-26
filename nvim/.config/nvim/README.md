CTRL-] : Press  CTRL-]  to jump to a subject under the cursor.
CTRL-O : Press  CTRL-O  to jump back (repeat to go further back).
gg : start of file
G : end of file
{num}G : go to line [num] of file
{num}% : go to [num] % of file
Ctrl+G : show "usr_03.txt" line 233 of 650 --35%-- col 45-52 
H : top of visible page
M : middle of visible page
L : bottom of visible page
Ctrl+U : scrolls down half a screen of text
Ctrl+D : scrolls up half a screen of text
Ctrl+E : scrolls up one line
Ctrl+Y : scrolls down one line
Ctrl+F : scrolls forward whole screen
Ctrl+B : scrolls backward whole screen
zz : center the cursor
zt : move cursor top
zb : move cursor bottom
/{word} : to search
Note:
	The characters .*[]^%/\?~$ have special meanings.  If you want to use them in a search you must put a \ in front of them.
? : works like "/" but searches backwards
N : repeats the last search the opposite direction
Note:
    using "N" after a "/" command search backwards, using "N" after "?" searches
forward.
* : search current word under cursor
# : search current word under cursor bacwards
`` : jump back to past position
Ctrl+O : jumps to older positions
Ctrl+I : jumps to newer positions
:jumps : gives a list of positions you jumped to
named marks
m{char} : marks the current cursor location to {char}
`{mark} : backtick + a mark takes the cursor to that position
Note:
    'mark (single quotation mark, or apostrophe) moves you to the beginning of the line containing the mark. This differs from the `mark command, which moves you to marked column.
:marks : get a list of marks

You will notice a few special marks.  These include:
    ''	The cursor position before doing a jump
	"	The cursor position when last editing the file
	[	Start of the last change
	]	End of the last change
