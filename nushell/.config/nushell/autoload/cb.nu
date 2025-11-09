module cb {
    def conf [] { $env.HOME | path join .config/bookmarks/dirs.toml }
    def options [] { open (conf) | columns }

    # Bookmark directories for quick navigation
    export def --env main [
        --add,                 # Add a new bookmark with the given name for the current directory
        --rm,                  # Remove the bookmark with the given name
        name?: string@options  # The name of the bookmark to add, remove, or go to
    ] {
        let found = $name in (options)

        if $add and $found {
            print $"Bookmark '($name)' already exists."
        } else if $add {
            open (conf) | insert $name (pwd) | save -f (conf)
            print $"Bookmark '($name)' added with path '(pwd)'."
        } else if $rm and $found {
            open (conf) | reject $name | save -f (conf)
            print $"Bookmark '($name)' removed."
        } else if $rm {
            print $"Bookmark '($name)' does not exist."
        } else if $found {
            cd (open (conf) | get $name)
        } else {
            open (conf)
        }
    }
}

use cb