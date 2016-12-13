# Make the damn web requests!
Rake.application['get_data:request'].invoke
# Invoke owners Rake task
Rake.application['get_data:owners'].invoke
