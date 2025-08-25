module dkr {
    def from-docker [] {
        $in | lines | each { from json }
    }

    def to-containers [] {
        $in | select ID Names Image State Status CreatedAt RunningFor Ports Size Command LocalVolumes Networks Mounts Labels
    }

    def to-images [] {
        $in | select ID Repository Tag Containers CreatedAt CreatedSince Size SharedSize UniqueSize VirtualSize Digest
    }

    def running [] {
        {
            options: {
                case_sensitive: false,
                completion_algorithm: substring,
                sort: false,
            },
            completions: (main | get Names)
        }
    }

    def get-id [name] {
        main | where $it.Names == $name | first | get ID
    }

    export def main [] {
        docker ps --format '{{json .}}' | from-docker | to-containers
    }

    export def c [] {
        docker container ls -a --format '{{json .}}' | from-docker | to-containers
    }

    export def i [] {
        docker image ls -a --format '{{json .}}' | from-docker | to-images
    }

    export def stop [name: string@running] {
        docker stop (get-id $name)
    }

    export def stop-all [] {
        docker stop ...(main | get ID)
    }

    export def logs [name: string@running] {
        docker logs $name -f
    }

}

use dkr
