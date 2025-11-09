module awsp {
    def aws_options [] {
        {
            options: {
                case_sensitive: false,
                completion_algorithm: substring,
                sort: false,
            },
            completions: (open ~/.aws/config | parse '[profile {name}]' | get name)
        }
    }

    export def --env main [profile?: string@aws_options] {
        $env.AWS_PROFILE = $profile
    }
}

use awsp