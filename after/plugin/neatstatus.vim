" NeatStatus (c) 2012 Lukasz Grzegorz Maciak
" Neat and simple status line - because Powerline is overrated
"    _   _            _   ____  _        _             
"   | \ | | ___  __ _| |_/ ___|| |_ __ _| |_ _   _ ___ 
"   |  \| |/ _ \/ _` | __\___ \| __/ _` | __| | | / __|
"   | |\  |  __/ (_| | |_ ___) | || (_| | |_| |_| \__ \
"   |_| \_|\___|\__,_|\__|____/ \__\__,_|\__|\__,_|___/
"   Vim plugin by Luke Maciak (c) 2012
"
" Loosely based on a script by Tomas Restrepo (winterdom.com)
" " Original available here:
" http://winterdom.com/2007/06/vimstatusline

set ls=2 " Always show status line
let g:last_mode=""

" Color Scheme Settings
" You can redefine these in your .vimrc

" Black on Green
if !exists('g:NeatStatusLine_color_normal')   | let g:NeatStatusLine_color_normal   = 'guifg=#000000 guibg=#7dcc7d gui=NONE' | endif
" White on Red
if !exists('g:NeatStatusLine_color_insert')   | let g:NeatStatusLine_color_insert   = 'guifg=#ffffff guibg=#ff0000 gui=bold' | endif
" Yellow on Blue
if !exists('g:NeatStatusLine_color_replace')  | let g:NeatStatusLine_color_replace  = 'guifg=#ffff00 guibg=#5b7fbb gui=bold' | endif
" White on Purple
if !exists('g:NeatStatusLine_color_visual')   | let g:NeatStatusLine_color_visual   = 'guifg=#ffffff guibg=#810085 gui=NONE' | endif
" White on Black
if !exists('g:NeatStatusLine_color_position') | let g:NeatStatusLine_color_position = 'guifg=#ffffff guibg=#000000'          | endif
" White on Black
if !exists('g:NeatStatusLine_color_modified') | let g:NeatStatusLine_color_modified = 'guifg=#ffffff guibg=#000000'          | endif
" White on Black
if !exists('g:NeatStatusLine_color_line')     | let g:NeatStatusLine_color_line     = 'guifg=#ffffff guibg=#000000 gui=bold' | endif
" White on Black
if !exists('g:NeatStatusLine_color_filetype') | let g:NeatStatusLine_color_filetype = 'guifg=#ffffff guibg=#000000 gui=bold' | endif

if !exists('g:NeatStatusLine_separator')      | let g:NeatStatusLine_separator = '|' | endif

"==============================================================================
"==============================================================================

" Set up the colors for the status bar
function! SetNeatstatusColorscheme()

    " Basic color presets
    exec 'hi User1 '.g:NeatStatusLine_color_normal
    exec 'hi User2 '.g:NeatStatusLine_color_replace
    exec 'hi User3 '.g:NeatStatusLine_color_insert
    exec 'hi User4 '.g:NeatStatusLine_color_visual
    exec 'hi User5 '.g:NeatStatusLine_color_position
    exec 'hi User6 '.g:NeatStatusLine_color_modified
    exec 'hi User7 '.g:NeatStatusLine_color_line
    exec 'hi User8 '.g:NeatStatusLine_color_filetype

endfunc

" pretty mode display - converts the one letter status notifiers to words
function! Mode()
    redraw
    let l:mode = mode()
    
    if     mode ==# "n"  | exec 'hi User1 '.g:NeatStatusLine_color_normal  | return "NO"
    elseif mode ==# "i"  | exec 'hi User1 '.g:NeatStatusLine_color_insert  | return "IN"
    elseif mode ==# "R"  | exec 'hi User1 '.g:NeatStatusLine_color_replace | return "RE"
    elseif mode ==# "v"  | exec 'hi User1 '.g:NeatStatusLine_color_visual  | return "VI"
    elseif mode ==# "V"  | exec 'hi User1 '.g:NeatStatusLine_color_visual  | return "VL"
    elseif mode ==# "" | exec 'hi User1 '.g:NeatStatusLine_color_visual  | return "VB"
    else                 | return l:mode
    endif
endfunc    

"==============================================================================
"==============================================================================

if has('statusline')

    " set up color scheme now
    call SetNeatstatusColorscheme()

    " Status line detail:
    " -------------------
    "
    " %f    file name
    " %F    file path
    " %y    file type between braces (if defined)
    "
    " %{v:servername}   server/session name (gvim only)
    "
    " %<    collapse to the left if window is to small
    "
    " %( %) display contents only if not empty
    "
    " %1*   use color preset User1 from this point on (use %0* to reset)
    "
    " %([%R%M]%)   read-only, modified and modifiable flags between braces
    "
    " %{'!'[&ff=='default_file_format']}
    "        shows a '!' if the file format is not the platform default
    "
    " %{'$'[!&list]}  shows a '*' if in list mode
    " %{'~'[&pm=='']} shows a '~' if in patchmode
    "
    " %=     right-align following items
    "
    " %{&fileencoding}  displays encoding (like utf8)
    " %{&fileformat}    displays file format (unix, dos, etc..)
    " %{&filetype}      displays file type (vim, python, etc..)
    "
    " #%n   buffer number
    " %l/%L line number, total number of lines
    " %p%   percentage of file
    " %c%V  column number, absolute column number
    " &modified         whether or not file was modified
    "
    " %-5.x - syntax to add 5 chars of padding to some element x
    "
    function! SetStatusLineStyle()

        let &stl=""
        " mode (changes color)
        let &stl.="%1*\ %{Mode()} %0*"
        " session name
        let &stl.="%5*%( %{fugitive#statusline()} %)%0*"
        " file path
        let &stl.=" %<%F "
        " read only, modified, modifiable flags in brackets
        let &stl.="%([%R%M]%) "

        " right-aligh everything past this point
        let &stl.="%= "

        " readonly flag
        let &stl.="%(%{(&ro!=0?'(readonly)':'')} ".g:NeatStatusLine_separator." %)"

        " file type (eg. python, ruby, etc..)
        let &stl.="%8*%( %{&filetype} %)%0* "
        " file format (eg. unix, dos, etc..)
        let &stl.="%{&fileformat} ".g:NeatStatusLine_separator." "
        " file encoding (eg. utf8, latin1, etc..)
        let &stl.="%(%{(&fenc!=''?&fenc:&enc)} ".g:NeatStatusLine_separator." %)"
        " buffer number
        let &stl.="BUF #%n "
        "line number (pink) / total lines
        let &stl.="%5*  LN %7*%-4.l%5*/%-4.L\ %0* "
        " percentage done
        let &stl.="(%-3.p%%) ".g:NeatStatusLine_separator." "
        " column number (minimum width is 4)
        let &stl.="COL %-3.c "
        let &stl.="\ %#ErrorMsg#%{neomake#statusline#LoclistStatus()}"

    endfunc

    "FIXME: hack to fix the repeated statusline issue in console version
    " whenever the color scheme changes re-apply the colors
    au ColorScheme * call SetNeatstatusColorscheme()

    " Make sure the statusbar is reloaded late to pick up servername
    au ColorScheme,VimEnter * call SetStatusLineStyle()

    " Switch between the normal and vim-debug modes in the status line
    nmap _ds :call SetStatusLineStyle()<CR>
    call SetStatusLineStyle()
    " Window title
    if has('title')
        set titlestring="%t%(\ [%R%M]%)".expand(v:servername)
    endif
endif
