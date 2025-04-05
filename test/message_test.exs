defmodule WhatsappElixir.MessageTest do
  use ExUnit.Case
  alias WhatsappElixir.Message

  describe "new/1" do
    test "creates a new message from text message data" do
      # Mock data for a text message
      text_message_data = %{
        "entry" => [
          %{
            "changes" => [
              %{
                "value" => %{
                  "messaging_product" => "whatsapp",
                  "metadata" => %{
                    "display_phone_number" => "1234567890",
                    "phone_number_id" => "phone_id_123"
                  },
                  "contacts" => [
                    %{
                      "profile" => %{"name" => "John Doe"},
                      "wa_id" => "9876543210"
                    }
                  ],
                  "messages" => [
                    %{
                      "from" => "9876543210",
                      "id" => "wamid.123456789",
                      "timestamp" => "1637236710",
                      "text" => %{"body" => "Hello, world!"},
                      "type" => "text"
                    }
                  ]
                },
                "field" => "messages"
              }
            ],
            "id" => "business_account_id_123"
          }
        ],
        "object" => "whatsapp_business_account"
      }

      message = Message.new(text_message_data)

      assert message.id == "wamid.123456789"
      assert message.content == "Hello, world!"
      assert message.to == ""
      assert message.rec_type == "individual"
      assert message.type == "text"
      assert message.sender == "9876543210"
      assert message.name == "John Doe"
      assert message.image == nil
      assert message.video == nil
      assert message.audio == nil
      assert message.document == nil
      assert message.location == nil
      assert message.interactive == nil
      assert message.data == text_message_data
      assert message.timestamp == "1637236710"
      assert message.metadata == %{
        "display_phone_number" => "1234567890",
        "phone_number_id" => "phone_id_123"
      }
    end

    test "creates a new message from image message data" do
      # Mock data for an image message
      image_message_data = %{
        "entry" => [
          %{
            "changes" => [
              %{
                "value" => %{
                  "messaging_product" => "whatsapp",
                  "metadata" => %{
                    "display_phone_number" => "1234567890",
                    "phone_number_id" => "phone_id_123"
                  },
                  "contacts" => [
                    %{
                      "profile" => %{"name" => "John Doe"},
                      "wa_id" => "9876543210"
                    }
                  ],
                  "messages" => [
                    %{
                      "from" => "9876543210",
                      "id" => "wamid.image123",
                      "timestamp" => "1637236710",
                      "image" => %{
                        "caption" => "Check this out!",
                        "mime_type" => "image/jpeg",
                        "sha256" => "image-hash-value",
                        "id" => "image-id-123"
                      },
                      "type" => "image"
                    }
                  ]
                },
                "field" => "messages"
              }
            ],
            "id" => "business_account_id_123"
          }
        ],
        "object" => "whatsapp_business_account"
      }

      message = Message.new(image_message_data)

      assert message.id == "wamid.image123"
      assert message.content == "Check this out!"
      assert message.type == "image"
      assert message.sender == "9876543210"
      assert message.name == "John Doe"

      assert message.image == %{
               "caption" => "Check this out!",
               "mime_type" => "image/jpeg",
               "sha256" => "image-hash-value",
               "id" => "image-id-123"
             }

      assert message.video == nil
      assert message.audio == nil
      assert message.document == nil
      assert message.timestamp == "1637236710"
      assert message.metadata == %{
        "display_phone_number" => "1234567890",
        "phone_number_id" => "phone_id_123"
      }
    end

    test "creates a new message from document message data" do
      # Mock data for a document message
      document_message_data = %{
        "entry" => [
          %{
            "changes" => [
              %{
                "value" => %{
                  "messaging_product" => "whatsapp",
                  "metadata" => %{
                    "display_phone_number" => "1234567890",
                    "phone_number_id" => "phone_id_123"
                  },
                  "contacts" => [
                    %{
                      "profile" => %{"name" => "John Doe"},
                      "wa_id" => "9876543210"
                    }
                  ],
                  "messages" => [
                    %{
                      "from" => "9876543210",
                      "id" => "wamid.doc123",
                      "timestamp" => "1637236710",
                      "document" => %{
                        "filename" => "report.pdf",
                        "mime_type" => "application/pdf",
                        "sha256" => "doc-hash-value",
                        "id" => "doc-id-123"
                      },
                      "type" => "document"
                    }
                  ]
                },
                "field" => "messages"
              }
            ],
            "id" => "business_account_id_123"
          }
        ],
        "object" => "whatsapp_business_account"
      }

      message = Message.new(document_message_data)

      assert message.id == "wamid.doc123"
      assert message.content == ""
      assert message.type == "document"
      assert message.sender == "9876543210"
      assert message.name == "John Doe"

      assert message.document == %{
               "filename" => "report.pdf",
               "mime_type" => "application/pdf",
               "sha256" => "doc-hash-value",
               "id" => "doc-id-123"
             }

      assert message.image == nil
      assert message.video == nil
      assert message.audio == nil
      assert message.timestamp == "1637236710"
      assert message.metadata == %{
        "display_phone_number" => "1234567890",
        "phone_number_id" => "phone_id_123"
      }
    end

    test "creates a new message from interactive message data" do
      # Mock data for an interactive button response
      interactive_message_data = %{
        "entry" => [
          %{
            "changes" => [
              %{
                "value" => %{
                  "messaging_product" => "whatsapp",
                  "metadata" => %{
                    "display_phone_number" => "1234567890",
                    "phone_number_id" => "phone_id_123"
                  },
                  "contacts" => [
                    %{
                      "profile" => %{"name" => "John Doe"},
                      "wa_id" => "9876543210"
                    }
                  ],
                  "messages" => [
                    %{
                      "from" => "9876543210",
                      "id" => "wamid.interactive123",
                      "timestamp" => "1637236710",
                      "interactive" => %{
                        "type" => "button_reply",
                        "button_reply" => %{
                          "id" => "button-id-123",
                          "title" => "Yes"
                        }
                      },
                      "type" => "interactive"
                    }
                  ]
                },
                "field" => "messages"
              }
            ],
            "id" => "business_account_id_123"
          }
        ],
        "object" => "whatsapp_business_account"
      }

      message = Message.new(interactive_message_data)

      assert message.id == "wamid.interactive123"
      assert message.content == ""
      assert message.type == "interactive"
      assert message.sender == "9876543210"
      assert message.name == "John Doe"

      assert message.interactive == %{
               "type" => "button_reply",
               "button_reply" => %{
                 "id" => "button-id-123",
                 "title" => "Yes"
               }
             }

      assert message.image == nil
      assert message.document == nil
      assert message.timestamp == "1637236710"
      assert message.metadata == %{
        "display_phone_number" => "1234567890",
        "phone_number_id" => "phone_id_123"
      }
    end

    test "creates a new message from location message data" do
      # Mock data for a location message
      location_message_data = %{
        "entry" => [
          %{
            "changes" => [
              %{
                "value" => %{
                  "messaging_product" => "whatsapp",
                  "metadata" => %{
                    "display_phone_number" => "1234567890",
                    "phone_number_id" => "phone_id_123"
                  },
                  "contacts" => [
                    %{
                      "profile" => %{"name" => "John Doe"},
                      "wa_id" => "9876543210"
                    }
                  ],
                  "messages" => [
                    %{
                      "from" => "9876543210",
                      "id" => "wamid.location123",
                      "timestamp" => "1637236710",
                      "location" => %{
                        "latitude" => 37.483872,
                        "longitude" => -122.148293,
                        "name" => "Palo Alto",
                        "address" => "1 Hacker Way, CA"
                      },
                      "type" => "location"
                    }
                  ]
                },
                "field" => "messages"
              }
            ],
            "id" => "business_account_id_123"
          }
        ],
        "object" => "whatsapp_business_account"
      }

      message = Message.new(location_message_data)

      assert message.id == "wamid.location123"
      assert message.content == ""
      assert message.type == "location"
      assert message.sender == "9876543210"
      assert message.name == "John Doe"

      assert message.location == %{
               "latitude" => 37.483872,
               "longitude" => -122.148293,
               "name" => "Palo Alto",
               "address" => "1 Hacker Way, CA"
             }

      assert message.image == nil
      assert message.document == nil
      assert message.timestamp == "1637236710"
      assert message.metadata == %{
        "display_phone_number" => "1234567890",
        "phone_number_id" => "phone_id_123"
      }
    end

    test "handles audio message data" do
      audio_message_data = %{
        "entry" => [
          %{
            "changes" => [
              %{
                "value" => %{
                  "messaging_product" => "whatsapp",
                  "metadata" => %{
                    "display_phone_number" => "1234567890",
                    "phone_number_id" => "phone_id_123"
                  },
                  "contacts" => [
                    %{
                      "profile" => %{"name" => "John Doe"},
                      "wa_id" => "9876543210"
                    }
                  ],
                  "messages" => [
                    %{
                      "from" => "9876543210",
                      "id" => "wamid.audio123",
                      "timestamp" => "1637236710",
                      "audio" => %{
                        "mime_type" => "audio/ogg",
                        "sha256" => "audio-hash-value",
                        "id" => "audio-id-123",
                        "voice" => true
                      },
                      "type" => "audio"
                    }
                  ]
                },
                "field" => "messages"
              }
            ],
            "id" => "business_account_id_123"
          }
        ],
        "object" => "whatsapp_business_account"
      }

      message = Message.new(audio_message_data)

      assert message.id == "wamid.audio123"
      assert message.content == ""
      assert message.type == "audio"
      assert message.sender == "9876543210"
      assert message.name == "John Doe"

      assert message.audio == %{
               "mime_type" => "audio/ogg",
               "sha256" => "audio-hash-value",
               "id" => "audio-id-123",
               "voice" => true
             }

      assert message.image == nil
      assert message.document == nil
      assert message.timestamp == "1637236710"
      assert message.metadata == %{
        "display_phone_number" => "1234567890",
        "phone_number_id" => "phone_id_123"
      }
    end

    test "handles video message data" do
      video_message_data = %{
        "entry" => [
          %{
            "changes" => [
              %{
                "value" => %{
                  "messaging_product" => "whatsapp",
                  "metadata" => %{
                    "display_phone_number" => "1234567890",
                    "phone_number_id" => "phone_id_123"
                  },
                  "contacts" => [
                    %{
                      "profile" => %{"name" => "John Doe"},
                      "wa_id" => "9876543210"
                    }
                  ],
                  "messages" => [
                    %{
                      "from" => "9876543210",
                      "id" => "wamid.video123",
                      "timestamp" => "1637236710",
                      "video" => %{
                        "mime_type" => "video/mp4",
                        "sha256" => "video-hash-value",
                        "id" => "video-id-123"
                      },
                      "type" => "video"
                    }
                  ]
                },
                "field" => "messages"
              }
            ],
            "id" => "business_account_id_123"
          }
        ],
        "object" => "whatsapp_business_account"
      }

      message = Message.new(video_message_data)

      assert message.id == "wamid.video123"
      assert message.content == ""
      assert message.type == "video"
      assert message.sender == "9876543210"
      assert message.name == "John Doe"

      assert message.video == %{
               "mime_type" => "video/mp4",
               "sha256" => "video-hash-value",
               "id" => "video-id-123"
             }

      assert message.image == nil
      assert message.document == nil
      assert message.timestamp == "1637236710"
      assert message.metadata == %{
        "display_phone_number" => "1234567890",
        "phone_number_id" => "phone_id_123"
      }
    end
  end
end
