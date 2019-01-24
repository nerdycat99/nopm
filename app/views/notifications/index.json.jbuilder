json.array! @notifications do |notification|
  #json.id notification.id
  #json.unread !notification.read_at?
  #json.template render partial: "notifications/#{notification.notifiable_type.underscore.pluralize}/#{notification.action}", locals: {notification: notification}, formats: [:html]

  # json.recipient notification.recipient
  json.id notification.id
  json.actorfirstname notification.actor.first_name
  json.actorlastname notification.actor.last_name
  json.action notification.action
  json.notifiable notification.notifiable
  json.url performer_org_project_task_path(current_user.org_id, notification.notifiable.project_id, notification.notifiable_id)
end

