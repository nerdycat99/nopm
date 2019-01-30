json.array! @notifications do |notification|
  #json.id notification.id
  #json.unread !notification.read_at?
  #json.template render partial: "notifications/#{notification.notifiable_type.underscore.pluralize}/#{notification.action}", locals: {notification: notification}, formats: [:html]

  # json.recipient notification.recipient

  json.id notification.id
  json.type notification.notifiable_type
  json.actorfirstname notification.actor.first_name
  json.actorlastname notification.actor.last_name
  json.action notification.action
  json.notifiable notification.notifiable

  # if the notification is for TP to look at task assigned to them they need standard TP view
  if notification.notifiable_type == "Task"
    json.url performer_org_project_task_path(current_user.org_id, notification.notifiable.project_id, notification.notifiable_id)
  else
    # if the notification id for manager they should be sent to project page
    json.url org_project_path(current_user.org_id, notification.notifiable.id)
  end
  # if the notification is to confirm TP accepted a task you created - view only page

end

