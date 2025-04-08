defmodule WhatsappElixir.Media do
   @moduledoc """
  Send different Media  to WhatsApp users.
  """

require Logger
alias WhatsappElixir.HTTP


@endpoint "messages"


@doc """
Sends a location message to a WhatsApp user.

## Args
  - recipient_id: Phone number of the user with country code without +
  - opts: Keyword list with the following options:
    - lat: Latitude of the location
    - long: Longitude of the location
    - name: Name of the location
    - address: Address of the location
    - custom_config: Custom configuration for HTTP client (default: [])

## Example

    iex> WhatsappElixir.send_location("5511999999999", lat: "-23.564", long: "-46.654", name: "My Location", address: "Rua dois, 123")
    {:ok, %{"success" => true}}
"""
def send_location(recipient_id, [lat: lat, long: long, name: name, address: address] = opts) do
  custom_config = Keyword.get(opts, :custom_config, [])

  data = %{
    messaging_product: "whatsapp",
    to: recipient_id,
    type: "location",
    location: %{
      latitude: lat,
      longitude: long,
      name: name,
      address: address
    }
  }

  Logger.info("Sending location to #{recipient_id}")
  case HTTP.post(@endpoint, data, custom_config ) do
    {:ok, response} ->
      Logger.info("Location sent to #{recipient_id}")
      response
    {:error, reason} ->
      Logger.error("Failed to send location to #{recipient_id}: #{inspect(reason)}")
      {:error, reason}
  end
end

@doc """
Sends an image message to a WhatsApp user.

## Args
  - recipient_id: Phone number of the user with country code without +
  - opts: Keyword list with the following options:
    - image: Image id or link of the image
    - recipient_type: Type of the recipient, either individual or group (default: "individual")
    - caption: Caption of the image (default: "")
    - link: Whether to send an image id or an image link, true means that the image is a link, false means that the image is an id (default: true)
    - custom_config: Custom configuration for HTTP client (default: [])

## Example

    iex> WhatsappElixir.send_image("5511999999999", image: "https://i.imgur.com/Fh7XVYY.jpeg")
    {:ok, %{"success" => true}}
"""
def send_image(recipient_id, [image: image] = opts) do
  recipient_type = Keyword.get(opts, :recipient_type, "individual")
  caption = Keyword.get(opts, :caption, "")
  link = Keyword.get(opts, :link, true)
  custom_config = Keyword.get(opts, :custom_config, [])

  data = %{
    messaging_product: "whatsapp",
    recipient_type: recipient_type,
    to: recipient_id,
    type: "image",
    image: (if link, do: %{link: image, caption: caption}, else: %{id: image, caption: caption})
  }

  Logger.info("Sending image to #{recipient_id}")
  case HTTP.post(@endpoint, data, custom_config) do
    {:ok, response} ->
      Logger.info("Image sent to #{recipient_id}")
      response
    {:error, reason} ->
      Logger.error("Failed to send image to #{recipient_id}: #{inspect(reason)}")
      {:error, reason}
  end
end

@doc """
Sends a sticker message to a WhatsApp user.

## Args
  - recipient_id: Phone number of the user with country code without +
  - opts: Keyword list with the following options:
    - sticker: Sticker id or link of the sticker
    - recipient_type: Type of the recipient, either individual or group (default: "individual")
    - link: Whether to send a sticker id or a sticker link, true means that the sticker is a link, false means that the sticker is an id (default: true)
    - custom_config: Custom configuration for HTTP client (default: [])

## Example

    iex> WhatsappElixir.send_sticker("5511999999999", sticker: "170511049062862", link: false)
    {:ok, %{"success" => true}}
"""
def send_sticker(recipient_id, [sticker: sticker] = opts) do
  recipient_type = Keyword.get(opts, :recipient_type, "individual")
  link = Keyword.get(opts, :link, true)
  custom_config = Keyword.get(opts, :custom_config, [])

  data = %{
    messaging_product: "whatsapp",
    recipient_type: recipient_type,
    to: recipient_id,
    type: "sticker",
    sticker: (if link, do: %{link: sticker}, else: %{id: sticker})
  }

  Logger.info("Sending sticker to #{recipient_id}")
  case HTTP.post(@endpoint, data, custom_config) do
    {:ok, response} ->
      Logger.info("Sticker sent to #{recipient_id}")
      response
    {:error, reason} ->
      Logger.error("Failed to send sticker to #{recipient_id}: #{inspect(reason)}")
      {:error, reason}
  end
end

@doc """
Sends an audio message to a WhatsApp user.

## Args
  - recipient_id: Phone number of the user with country code without +
  - opts: Keyword list with the following options:
    - audio: Audio id or link of the audio
    - link: Whether to send an audio id or an audio link, true means that the audio is a link, false means that the audio is an id (default: true)
    - custom_config: Custom configuration for HTTP client (default: [])

## Example

    iex> WhatsappElixir.send_audio("5511999999999", audio: "https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3")
    {:ok, %{"success" => true}}
"""
def send_audio(recipient_id, [audio: audio] = opts) do
  link = Keyword.get(opts, :link, true)
  custom_config = Keyword.get(opts, :custom_config, [])

  data = %{
    messaging_product: "whatsapp",
    to: recipient_id,
    type: "audio",
    audio: (if link, do: %{link: audio}, else: %{id: audio})
  }

  Logger.info("Sending audio to #{recipient_id}")
  case HTTP.post(@endpoint, data, custom_config) do
    {:ok, response} ->
      Logger.info("Audio sent to #{recipient_id}")
      response
    {:error, reason} ->
      Logger.error("Failed to send audio to #{recipient_id}: #{inspect(reason)}")
      {:error, reason}
  end
end

@doc """
Sends a video message to a WhatsApp user.

## Args
  - recipient_id: Phone number of the user with country code without +
  - opts: Keyword list with the following options:
    - video: Video id or link of the video
    - caption: Caption of the video (default: "")
    - link: Whether to send a video id or a video link, true means that the video is a link, false means that the video is an id (default: true)
    - custom_config: Custom configuration for HTTP client (default: [])

## Example

    iex> WhatsappElixir.send_video("5511999999999", video: "https://www.youtube.com/watch?v=dQw4w9WgXcQ")
    {:ok, %{"success" => true}}
"""
def send_video(recipient_id, [video: video] = opts) do
  caption = Keyword.get(opts, :caption, "")
  link = Keyword.get(opts, :link, true)
  custom_config = Keyword.get(opts, :custom_config, [])

  data = %{
    messaging_product: "whatsapp",
    to: recipient_id,
    type: "video",
    video: (if link, do: %{link: video, caption: caption}, else: %{id: video, caption: caption})
  }

  Logger.info("Sending video to #{recipient_id}")
  case HTTP.post(@endpoint, data, custom_config) do
    {:ok, response} ->
      Logger.info("Video sent to #{recipient_id}")
      response
    {:error, reason} ->
      Logger.error("Failed to send video to #{recipient_id}: #{inspect(reason)}")
      {:error, reason}
  end
end

@doc """
Sends a document message to a WhatsApp user.

## Args
  - recipient_id: Phone number of the user with country code without +
  - opts: Keyword list with the following options:
    - document: Document id or link of the document
    - caption: Caption of the document (default: "")
    - link: Whether to send a document id or a document link, true means that the document is a link, false means that the document is an id (default: true)
    - custom_config: Custom configuration for HTTP client (default: [])

## Example

    iex> WhatsappElixir.Media.send_document("5511999999999", document: "https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf")
    {:ok, %{"success" => true}}
"""
def send_document(recipient_id, [document: document] = opts) do
  caption = Keyword.get(opts, :caption, "")
  link = Keyword.get(opts, :link, true)
  custom_config = Keyword.get(opts, :custom_config, [])

  data = %{
    messaging_product: "whatsapp",
    to: recipient_id,
    type: "document",
    document: (if link, do: %{link: document, caption: caption}, else: %{id: document, caption: caption})
  }

  Logger.info("Sending document to #{recipient_id}")
  case HTTP.post(@endpoint, data, custom_config) do
    {:ok, response} ->
      Logger.info("Document sent to #{recipient_id}")
      response
    {:error, reason} ->
      Logger.error("Failed to send document to #{recipient_id}: #{inspect(reason)}")
      {:error, reason}
  end
end
end
