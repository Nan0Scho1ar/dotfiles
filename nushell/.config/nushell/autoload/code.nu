module code {
    export def main [...files] { 
        if ($files | is-empty) {
            codium (pwd)
        } else {
            codium -r ...$files
        }
    }
}

use code