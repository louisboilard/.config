app: kitty
-
tag(): terminal
tag(): user.readline
tag(): user.generic_unix_shell
tag(): user.git
tag(): user.tmux

window rename <user.text>:
    user.kitty_set_window_title(text)
window {user.kitty_window_title} [focus]:
    user.kitty_focus_window(kitty_window_title)
window [{user.kitty_window_title}] [narrower|skinnier] [<user.number>]:
    num = number or 2
    user.kitty_resize_window(kitty_window_title or "", "horizontal", -1 * num)
window [{user.kitty_window_title}] wider [<user.number>]:
    user.kitty_resize_window(kitty_window_title or "", "horizontal", number or 2)
window [{user.kitty_window_title}] shorter [<user.number>]:
    num = number or 2
    user.kitty_resize_window(kitty_window_title or "", "vertical", -1 * num)
window [{user.kitty_window_title}] taller [<user.number>]:
    user.kitty_resize_window(kitty_window_title or "", "vertical", number or 2)
window [{user.kitty_window_title}] reset:
    user.kitty_resize_window(kitty_window_title or "", "reset", 0)

^signal {user.kitty_signal} [in {user.kitty_window_title}]$:
    user.kitty_send_signal(kitty_signal, kitty_window_title or "")

session {user.kitty_session}:
    user.kitty_run_session(kitty_session)

go run {user.kitty_go_file}:
    insert("go run "+kitty_go_file)

# TODO: the kitty extent "all" conflicts with the community command "copy all"
# I have added scrollback, but that is rather wordy.
copy {user.kitty_extent} [in {user.kitty_window_title}]:
    user.kitty_copy(kitty_extent, kitty_window_title or "")

preferences reload: key(cmd-ctrl-,)

code that:
    # TODO: extent? window title/other matcher?
    user.kitty_scrollback_to_editor()

suspend: key(ctrl-z)
resume:
    insert("fg")
    key(enter)

save:
    insert(";w")
    key(enter)

quit:
    insert(";q")
    key(enter)

force quit all:
    insert(";qall!")
    key(enter)

lisa durr:
    insert("ls ")
