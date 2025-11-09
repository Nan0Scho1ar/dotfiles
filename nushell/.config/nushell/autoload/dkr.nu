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

    export def stop [--all, name: string@running] {
        if $all {
            docker stop ...(main | get ID)
        } else if $name {
            docker stop $name
        } else {
            print "Please provide a container name or use --all to stop all containers."
        }
    }

    export def logs [name: string@c] {
        docker logs $name -f
    }

    export def aws-login [] {
        aws ecr get-login-password --region ap-southeast-2 | docker login --username AWS --password-stdin $"((aws sts get-caller-identity | from json).Account).dkr.ecr.ap-southeast-2.amazonaws.com"
    }

    export def pull-push [source: string, target: string] {
        docker pull $source
        docker tag $source $target
        docker push $target
    }

}

use dkr
