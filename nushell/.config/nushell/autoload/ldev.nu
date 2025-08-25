module ldev {
    def containers [] {
        open ($env.LOCALDEV_DIR)/compose.yaml | get services | columns
    }

    def dockr [] {
        docker ps --format '{{json .}}' | lines | each { from json } | get Names
    }

    def running [] { dockr | where $it in (containers) }

    def fzf-run [cmd: string] {
        $"/usr/bin/env nu -c \"source ~/.config/nushell/autoload/ldev.nu; ($cmd)\""
    }

    export def seed [] { 
        cd $env.LOCALDEV_DIR; ahoy reseed-most 
    }

    export def up [] {
        cd $env.LOCALDEV_DIR
        docker compose up -d ...(containers)
        status
    }

    export def down [] {
        if (running | length) > 0 {
            docker stop ...(running)
        }
        status
    }

    export def status [] {
        let green = "\e[32m"
        let red = "\e[31m"
        let reset = "\e[0m"

        let state = dockr

        containers | each {|name| 
            if $name in ($state) {
                 $"($green)($name)($reset)" 
            } else {
                 $"($red)($name)($reset)" 
            }
        } | to text
    }

    export def toggle [name: string] {
        cd $env.LOCALDEV_DIR
        if $name in (dockr) {
            docker stop $name
        } else {
            docker compose up -d $name
        }

    }

    export def --env main [] {
        let prev_cmd = 'docker logs -f {}'
        let prev_win = 'follow,80%'

        let header = 'Ctrl-Space to toggle'
        let bind1 = $"start:reload\((fzf-run 'ldev status')\)"
        let bind2 = $"ctrl-space:execute-silent\((fzf-run 'ldev toggle {}')\)+reload\((fzf-run 'ldev status')\)"
    
        fzf --ansi --preview-window $prev_win --preview $prev_cmd --bind $bind1 --bind $bind2 --header $header
        | if $in != '' {docker logs -f $in} 
    }
}

use ldev