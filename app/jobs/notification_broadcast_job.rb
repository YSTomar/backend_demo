class NotificationBroadcastJob < ApplicationJob
  queue_as :default

  def perform(message)
    message = render_message(message)

    ActionCable.server.broadcast "notifications_#{message.user.id}_channel",
                                 message: message,
                                 conversation_id: message.conversation.id

    if message.receiver.online?
      ActionCable.server.broadcast "notifications_#{message.receiver.id}_channel",
                                   notification: render_notification(message),
                                   message: message,
                                   conversation_id: message.conversation.id
    end
  end

  private

  def render_notification(message)
    NotificationsController.render partial: 'notifications/notification', locals: {message: message}
  end

  def render_message(message)
    MessagesController.render partial: 'messages/message',
                                      locals: {message: message}
  end
end
