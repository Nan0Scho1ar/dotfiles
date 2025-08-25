module cb {
    def conf [] { $env.HOME | path join .config/bookmarks/dirs.toml }
    def options [] { open (conf) | columns }

    export def --env main [name?: string@options] { 
        if $name in (options) {
            cd (open (conf) | get $name)
        } else {
            open (conf)
        }
    }

    export def "--add" [name: string] {
        if $name in (options) {
            print $"Bookmark '($name)' already exists."
        } else {
            open (conf) | insert $name (pwd) | save -f (conf)
            print $"Bookmark '($name)' added with path '(pwd)'."
        }
    }

    export def "--rm" [name: string@options] {
        if $name in (options) {
            open (conf) | reject $name | save -f (conf)
            print $"Bookmark '($name)' removed."
        } else {
            print $"Bookmark '($name)' does not exist."
        }
    }

}

use cb