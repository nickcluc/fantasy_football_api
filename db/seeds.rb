# Make the damn web requests!
Rake.application['get_data:request'].invoke
# Invoke owners Rake task
Rake.application['parse_data:seasons'].invoke

Rake.application['parse_data:owners'].invoke

Rake.application['parse_data:teams'].invoke

Rake.application['parse_data:team_matchups'].invoke
