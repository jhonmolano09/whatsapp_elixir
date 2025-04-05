defmodule WhatsappElixir.StaticTest do
  use ExUnit.Case
  alias WhatsappElixir.Static

  describe "message detection" do
    test "is_message/1 returns true for text message" do
      data = %{
        "entry" => [
          %{
            "changes" => [
              %{
                "value" => %{
                  "messaging_product" => "whatsapp",
                  "metadata" => %{
                    "display_phone_number" => "PHONE_NUMBER",
                    "phone_number_id" => "PHONE_NUMBER_ID"
                  },
                  "contacts" => [
                    %{
                      "profile" => %{"name" => "NAME"},
                      "wa_id" => "WHATSAPP_ID"
                    }
                  ],
                  "messages" => [
                    %{
                      "from" => "PHONE_NUMBER",
                      "id" => "wamid.ID",
                      "timestamp" => "TIMESTAMP",
                      "text" => %{"body" => "MESSAGE_BODY"},
                      "type" => "text"
                    }
                  ]
                },
                "field" => "messages"
              }
            ],
            "id" => "WHATSAPP_BUSINESS_ACCOUNT_ID"
          }
        ],
        "object" => "whatsapp_business_account"
      }

      assert Static.is_message(data) == true
    end

    test "is_message/1 returns false for status update" do
      status_data = %{
        "entry" => [
          %{
            "id" => "WHATSAPP_BUSINESS_ACCOUNT_ID",
            "changes" => [
              %{
                "value" => %{
                  "messaging_product" => "whatsapp",
                  "metadata" => %{
                    "display_phone_number" => "BUSINESS_DISPLAY_PHONE_NUMBER",
                    "phone_number_id" => "BUSINESS_PHONE_NUMBER_ID"
                  },
                  "statuses" => [
                    %{
                      "id" => "WHATSAPP_MESSAGE_ID",
                      "status" => "sent",
                      "timestamp" => "WEBHOOK_SENT_TIMESTAMP",
                      "recipient_id" => "WHATSAPP_USER_ID"
                    }
                  ]
                },
                "field" => "messages"
              }
            ]
          }
        ],
        "object" => "whatsapp_business_account"
      }

      assert Static.is_message(status_data) == false
    end
  end

  describe "get_mobile/1" do
    test "extracts mobile number from contact data" do
      data = %{
        "entry" => [
          %{
            "changes" => [
              %{
                "value" => %{
                  "contacts" => [
                    %{
                      "wa_id" => "91987654321"
                    }
                  ]
                }
              }
            ]
          }
        ]
      }

      assert Static.get_mobile(data) == "91987654321"
    end

    test "returns nil when no contact data present" do
      data = %{
        "entry" => [
          %{
            "changes" => [
              %{
                "value" => %{}
              }
            ]
          }
        ]
      }

      assert Static.get_mobile(data) == nil
    end
  end

  describe "get_name/1" do
    test "extracts name from profile data" do
      data = %{
        "entry" => [
          %{
            "changes" => [
              %{
                "value" => %{
                  "contacts" => [
                    %{
                      "profile" => %{
                        "name" => "John Doe"
                      }
                    }
                  ]
                }
              }
            ]
          }
        ]
      }

      assert Static.get_name(data) == "John Doe"
    end

    test "returns nil when no profile data present" do
      data = %{
        "entry" => [
          %{
            "changes" => [
              %{
                "value" => nil
              }
            ]
          }
        ]
      }

      assert Static.get_name(data) == nil
    end
  end

  describe "get_message/1" do
    test "extracts text message body" do
      data = %{
        "entry" => [
          %{
            "changes" => [
              %{
                "value" => %{
                  "messages" => [
                    %{
                      "text" => %{
                        "body" => "Hello, world!"
                      }
                    }
                  ]
                }
              }
            ]
          }
        ]
      }

      assert Static.get_message(data) == "Hello, world!"
    end

    test "returns nil when no message data present" do
      data = %{
        "entry" => [
          %{
            "changes" => [
              %{
                "value" => %{}
              }
            ]
          }
        ]
      }

      assert Static.get_message(data) == nil
    end
  end

  describe "get_message_id/1" do
    test "extracts message ID" do
      data = %{
        "entry" => [
          %{
            "changes" => [
              %{
                "value" => %{
                  "messages" => [
                    %{
                      "id" => "wamid.1234567890"
                    }
                  ]
                }
              }
            ]
          }
        ]
      }

      assert Static.get_message_id(data) == "wamid.1234567890"
    end

    test "returns nil when no message data present" do
      data = %{
        "entry" => [
          %{
            "changes" => [
              %{
                "value" => %{}
              }
            ]
          }
        ]
      }

      assert Static.get_message_id(data) == nil
    end
  end

  describe "get_message_timestamp/1" do
    test "extracts message timestamp" do
      data = %{
        "entry" => [
          %{
            "changes" => [
              %{
                "value" => %{
                  "messages" => [
                    %{
                      "timestamp" => "1637236710"
                    }
                  ]
                }
              }
            ]
          }
        ]
      }

      assert Static.get_message_timestamp(data) == "1637236710"
    end

    test "returns nil when no message data present" do
      data = %{
        "entry" => [
          %{
            "changes" => [
              %{
                "value" => %{}
              }
            ]
          }
        ]
      }

      assert Static.get_message_timestamp(data) == nil
    end
  end

  describe "get_interactive_response/1" do
    test "extracts interactive button response" do
      # Based on Quick Reply Button callback example
      data = %{
        "entry" => [
          %{
            "changes" => [
              %{
                "value" => %{
                  "messages" => [
                    %{
                      "interactive" => %{
                        "type" => "button_reply",
                        "button_reply" => %{
                          "id" => "unique-button-id",
                          "title" => "Yes"
                        }
                      }
                    }
                  ]
                }
              }
            ]
          }
        ]
      }

      expected_response = %{
        "type" => "button_reply",
        "button_reply" => %{
          "id" => "unique-button-id",
          "title" => "Yes"
        }
      }

      assert Static.get_interactive_response(data) == expected_response
    end

    test "returns nil when no interactive data present" do
      data = %{
        "entry" => [
          %{
            "changes" => [
              %{
                "value" => %{
                  "messages" => [
                    %{
                      "text" => %{
                        "body" => "Just text"
                      }
                    }
                  ]
                }
              }
            ]
          }
        ]
      }

      assert Static.get_interactive_response(data) == nil
    end
  end

  describe "get_location/1" do
    test "extracts location data" do
      data = %{
        "entry" => [
          %{
            "changes" => [
              %{
                "value" => %{
                  "messages" => [
                    %{
                      "location" => %{
                        "latitude" => 37.483872,
                        "longitude" => -122.148293,
                        "name" => "Facebook HQ",
                        "address" => "1 Hacker Way, Menlo Park, CA"
                      }
                    }
                  ]
                }
              }
            ]
          }
        ]
      }

      expected_location = %{
        "latitude" => 37.483872,
        "longitude" => -122.148293,
        "name" => "Facebook HQ",
        "address" => "1 Hacker Way, Menlo Park, CA"
      }

      assert Static.get_location(data) == expected_location
    end

    test "returns nil when no location data present" do
      data = %{
        "entry" => [
          %{
            "changes" => [
              %{
                "value" => %{
                  "messages" => [
                    %{
                      "text" => %{
                        "body" => "Just text"
                      }
                    }
                  ]
                }
              }
            ]
          }
        ]
      }

      assert Static.get_location(data) == nil
    end
  end

  describe "get_image/1" do
    test "extracts image data" do
      data = %{
        "entry" => [
          %{
            "changes" => [
              %{
                "value" => %{
                  "messages" => [
                    %{
                      "image" => %{
                        "mime_type" => "image/jpeg",
                        "sha256" => "image-hash",
                        "id" => "image-id"
                      }
                    }
                  ]
                }
              }
            ]
          }
        ]
      }

      expected_image = %{
        "mime_type" => "image/jpeg",
        "sha256" => "image-hash",
        "id" => "image-id"
      }

      assert Static.get_image(data) == expected_image
    end

    test "returns nil when no image data present" do
      data = %{
        "entry" => [
          %{
            "changes" => [
              %{
                "value" => %{
                  "messages" => [
                    %{
                      "text" => %{
                        "body" => "Just text"
                      }
                    }
                  ]
                }
              }
            ]
          }
        ]
      }

      assert Static.get_image(data) == nil
    end
  end

  describe "get_document/1" do
    test "extracts document data" do
      data = %{
        "entry" => [
          %{
            "changes" => [
              %{
                "value" => %{
                  "messages" => [
                    %{
                      "document" => %{
                        "filename" => "report.pdf",
                        "mime_type" => "application/pdf",
                        "sha256" => "doc-hash",
                        "id" => "doc-id"
                      }
                    }
                  ]
                }
              }
            ]
          }
        ]
      }

      expected_document = %{
        "filename" => "report.pdf",
        "mime_type" => "application/pdf",
        "sha256" => "doc-hash",
        "id" => "doc-id"
      }

      assert Static.get_document(data) == expected_document
    end

    test "returns nil when no document data present" do
      data = %{
        "entry" => [
          %{
            "changes" => [
              %{
                "value" => %{
                  "messages" => [
                    %{
                      "text" => %{
                        "body" => "Just text"
                      }
                    }
                  ]
                }
              }
            ]
          }
        ]
      }

      assert Static.get_document(data) == nil
    end
  end

  describe "get_audio/1" do
    test "extracts audio data" do
      data = %{
        "entry" => [
          %{
            "changes" => [
              %{
                "value" => %{
                  "messages" => [
                    %{
                      "audio" => %{
                        "mime_type" => "audio/mp4",
                        "sha256" => "audio-hash",
                        "id" => "audio-id",
                        "voice" => true
                      }
                    }
                  ]
                }
              }
            ]
          }
        ]
      }

      expected_audio = %{
        "mime_type" => "audio/mp4",
        "sha256" => "audio-hash",
        "id" => "audio-id",
        "voice" => true
      }

      assert Static.get_audio(data) == expected_audio
    end

    test "returns nil when no audio data present" do
      data = %{
        "entry" => [
          %{
            "changes" => [
              %{
                "value" => %{
                  "messages" => [
                    %{
                      "text" => %{
                        "body" => "Just text"
                      }
                    }
                  ]
                }
              }
            ]
          }
        ]
      }

      assert Static.get_audio(data) == nil
    end
  end

  describe "get_video/1" do
    test "extracts video data" do
      data = %{
        "entry" => [
          %{
            "changes" => [
              %{
                "value" => %{
                  "messages" => [
                    %{
                      "video" => %{
                        "mime_type" => "video/mp4",
                        "sha256" => "video-hash",
                        "id" => "video-id"
                      }
                    }
                  ]
                }
              }
            ]
          }
        ]
      }

      expected_video = %{
        "mime_type" => "video/mp4",
        "sha256" => "video-hash",
        "id" => "video-id"
      }

      assert Static.get_video(data) == expected_video
    end

    test "returns nil when no video data present" do
      data = %{
        "entry" => [
          %{
            "changes" => [
              %{
                "value" => %{
                  "messages" => [
                    %{
                      "text" => %{
                        "body" => "Just text"
                      }
                    }
                  ]
                }
              }
            ]
          }
        ]
      }

      assert Static.get_video(data) == nil
    end
  end

  describe "get_message_type/1" do
    test "returns 'text' for text messages" do
      data = %{
        "entry" => [
          %{
            "changes" => [
              %{
                "value" => %{
                  "messages" => [
                    %{
                      "type" => "text",
                      "text" => %{
                        "body" => "Hello, world!"
                      }
                    }
                  ]
                }
              }
            ]
          }
        ]
      }

      assert Static.get_message_type(data) == "text"
    end

    test "returns 'interactive' for interactive messages" do
      data = %{
        "entry" => [
          %{
            "changes" => [
              %{
                "value" => %{
                  "messages" => [
                    %{
                      "type" => "interactive",
                      "interactive" => %{
                        "type" => "button_reply",
                        "button_reply" => %{
                          "id" => "unique-id",
                          "title" => "Yes"
                        }
                      }
                    }
                  ]
                }
              }
            ]
          }
        ]
      }

      assert Static.get_message_type(data) == "interactive"
    end

    test "returns 'unknown' for unknown message types" do
      data = %{
        "entry" => [
          %{
            "changes" => [
              %{
                "value" => %{
                  "messages" => [
                    %{
                      "type" => "unknown"
                    }
                  ]
                }
              }
            ]
          }
        ]
      }

      assert Static.get_message_type(data) == "unknown"
    end

    test "returns nil when no message data present" do
      data = %{
        "entry" => [
          %{
            "changes" => [
              %{
                "value" => %{}
              }
            ]
          }
        ]
      }

      assert Static.get_message_type(data) == nil
    end
  end

  describe "get_delivery/1" do
    test "extracts delivery status" do
      data = %{
        "entry" => [
          %{
            "changes" => [
              %{
                "value" => %{
                  "statuses" => [
                    %{
                      "status" => "delivered"
                    }
                  ]
                }
              }
            ]
          }
        ]
      }

      assert Static.get_delivery(data) == "delivered"
    end

    test "returns nil when no status data present" do
      data = %{
        "entry" => [
          %{
            "changes" => [
              %{
                "value" => %{}
              }
            ]
          }
        ]
      }

      assert Static.get_delivery(data) == nil
    end
  end

  describe "changed_field/1" do
    test "extracts the field name that changed" do
      data = %{
        "entry" => [
          %{
            "changes" => [
              %{
                "field" => "messages"
              }
            ]
          }
        ]
      }

      assert Static.changed_field(data) == "messages"
    end
  end

  describe "get_author/1" do
    test "extracts the author phone number" do
      data = %{
        "entry" => [
          %{
            "changes" => [
              %{
                "value" => %{
                  "messages" => [
                    %{
                      "from" => "91987654321"
                    }
                  ]
                }
              }
            ]
          }
        ]
      }

      assert Static.get_author(data) == "91987654321"
    end

    test "returns nil when no author data present" do
      data = %{
        "entry" => [
          %{
            "changes" => [
              %{
                "value" => %{}
              }
            ]
          }
        ]
      }

      assert Static.get_author(data) == nil
    end

    test "handles exception and returns nil when data structure is invalid" do
      data = %{
        "entry" => [
          %{
            "changes" => [
              %{
                "value" => nil
              }
            ]
          }
        ]
      }

      assert Static.get_author(data) == nil
    end
  end

  describe "get_content/1" do
    test "extracts text content from text message" do
      data = %{
        "entry" => [
          %{
            "changes" => [
              %{
                "value" => %{
                  "messages" => [
                    %{
                      "type" => "text",
                      "text" => %{
                        "body" => "Hello, this is a text message"
                      }
                    }
                  ]
                }
              }
            ]
          }
        ]
      }

      assert Static.get_content(data) == "Hello, this is a text message"
    end

    test "extracts caption from image message" do
      data = %{
        "entry" => [
          %{
            "changes" => [
              %{
                "value" => %{
                  "messages" => [
                    %{
                      "type" => "image",
                      "image" => %{
                        "mime_type" => "image/jpeg",
                        "sha256" => "image-hash",
                        "id" => "image-id",
                        "caption" => "Image caption here"
                      }
                    }
                  ]
                }
              }
            ]
          }
        ]
      }

      assert Static.get_content(data) == "Image caption here"
    end

    test "extracts caption from video message" do
      data = %{
        "entry" => [
          %{
            "changes" => [
              %{
                "value" => %{
                  "messages" => [
                    %{
                      "type" => "video",
                      "video" => %{
                        "mime_type" => "video/mp4",
                        "sha256" => "video-hash",
                        "id" => "video-id",
                        "caption" => "Video caption here"
                      }
                    }
                  ]
                }
              }
            ]
          }
        ]
      }

      assert Static.get_content(data) == "Video caption here"
    end

    test "extracts caption from document message" do
      data = %{
        "entry" => [
          %{
            "changes" => [
              %{
                "value" => %{
                  "messages" => [
                    %{
                      "type" => "document",
                      "document" => %{
                        "filename" => "report.pdf",
                        "mime_type" => "application/pdf",
                        "sha256" => "doc-hash",
                        "id" => "doc-id",
                        "caption" => "Document caption here"
                      }
                    }
                  ]
                }
              }
            ]
          }
        ]
      }

      assert Static.get_content(data) == "Document caption here"
    end

    test "returns nil for unsupported message types" do
      data = %{
        "entry" => [
          %{
            "changes" => [
              %{
                "value" => %{
                  "messages" => [
                    %{
                      "type" => "unsupported_type"
                    }
                  ]
                }
              }
            ]
          }
        ]
      }

      assert Static.get_content(data) == nil
    end

    test "returns nil when no content available" do
      data = %{
        "entry" => [
          %{
            "changes" => [
              %{
                "value" => %{}
              }
            ]
          }
        ]
      }

      assert Static.get_content(data) == nil
    end
  end
end
