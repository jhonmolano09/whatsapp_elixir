defmodule WhatsappElixir.Message do
  alias WhatsappElixir.Static

  defstruct [
    :id,
    :data,
    :content,
    :to,
    :rec_type,
    :type,
    :sender,
    :sender_wa_id,
    :name,
    :image,
    :video,
    :audio,
    :document,
    :location,
    :interactive,
    :contact,
    :timestamp,
    :metadata
  ]

  def new(data) do
    %WhatsappElixir.Message{
      id: Static.get_message_id(data),
      data: data,
      content: Static.get_content(data) || "",
      to: "",
      rec_type: "individual",
      type: Static.get_message_type(data),
      sender: Static.get_mobile(data),
      sender_wa_id: Static.get_sender_wa_id(data),
      name: Static.get_name(data),
      image: Static.get_image(data),
      video: Static.get_video(data),
      audio: Static.get_audio(data),
      document: Static.get_document(data),
      location: Static.get_location(data),
      interactive: Static.get_interactive_response(data),
      contact: Static.get_contact_message(data),
      timestamp: Static.get_message_timestamp(data),
      metadata: Static.get_metadata(data)
    }
  end
end
