module cf {
    export def main [] {
        open cftool-config.yaml | get Configurations
        | items { |config_name, config|
            let config_params = $config | get -o Parameters | default {}
            
            $config.Instances
            | items { |instance_name, instance|
                let instance_params = $instance | get -o Parameters | default {}
                {
                    name: $"($config_name):($instance_name)",
                    parameters: ($config_params | merge $instance_params)

                }
            }
        }
        | flatten
        | reduce -f {} { |item, acc| 
            $acc | insert $item.name $item.parameters
        }
    }
}

use cf