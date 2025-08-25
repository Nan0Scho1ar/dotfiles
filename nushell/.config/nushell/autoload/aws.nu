module awsp {
    def aws_options [] {
        open ~/.aws/config 
        | from ini 
        | columns 
        | find -n profile 
        | str replace "profile " "" 
    }

    export def --env main [profile?: string@aws_options] {
        $env.AWS_PROFILE = $profile
    }
}

use awsp