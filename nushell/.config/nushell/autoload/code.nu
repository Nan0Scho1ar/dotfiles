# module code {
#     export def main [...files] { 
#         if ($files | is-empty) {
#             ^code (pwd)
#         } else {
#             ^code -r ...$files
#         }
#     }
# }

# use code