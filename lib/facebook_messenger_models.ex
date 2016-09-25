defmodule FacebookMessenger.Attachment do
  @moduledoc """
  Messenger attachment structure
  """
  @derive [Poison.Encoder]
  defstruct [:type, :title, :payload, :url]

  @type t :: %FacebookMessenger.Attachment{
    type: atom,
    title: String.t,
    payload: FacebookMessenger.Payload.t,
    url: String.t
  }
end

defmodule FacebookMessenger.Payload do
  @moduledoc """
  Facebook message structures
  """

  @derive [Poison.Encoder]
  defstruct [:template_type, :text, :url, :buttons, :elements]

  @type t :: %FacebookMessenger.Payload{
    template_type: String.t,
    url: String.t,
    text: String.t,
    buttons: [ FacebookMessenger.Button ],
    elements: [ FacebookMessenger.Element.t ]
  }
end

defmodule FacebookMessenger.Element do
  @moduledoc """
  Facebook message structures
  """

  @derive [Poison.Encoder]
  defstruct [:title, :item_url, :image_url, :subtitle, :buttons]

  @type t :: %FacebookMessenger.Element{
    title: String.t,
    item_url: String.t,
    image_url: String.t,
    subtitle: String.t,
    buttons: [ FacebookMessenger.Button.t ]
  }
end

defmodule FacebookMessenger.Button do
  @moduledoc """
  Facebook message structures
  """

  @derive [Poison.Encoder]
  defstruct [:type, :title, :url, :payload]

  @type t :: %FacebookMessenger.Button{
    type: String.t,
    title: String.t,
    url: String.t,
    payload: String.t
  }
end

defmodule FacebookMessenger.QuickReply do
  @moduledoc """
  Messenger quick reply structure
  """
  @derive [Poison.Encoder]
  defstruct [:content_type, :title, :payload]

  @type t :: %FacebookMessenger.QuickReply{
    content_type: String.t,
    title: String.t,
    payload: FacebookMessenger.Payload.t
  }
end

defmodule FacebookMessenger.Message do
  @moduledoc """
  Facebook message structure
  """

  @derive [Poison.Encoder]
  defstruct [:mid, :seq, :text, :attachments, :quick_replies, :quick_reply]

  @type t :: %FacebookMessenger.Message{
    mid: String.t,
    seq: integer,
    text: String.t,
    attachments: [FacebookMessenger.Attachment.t],
    quick_replies: [FacebookMessenger.QuickReply.t],
    quick_reply: FacebookMessenger.QuickReply.t
  }
end

defmodule FacebookMessenger.User do
  @moduledoc """
  Facebook user structure
  """

  @derive [Poison.Encoder]
  defstruct [:id]

  @type t :: %FacebookMessenger.User{
    id: String.t
  }
end

defmodule FacebookMessenger.Optin do
  @moduledoc """
  Facebook user structure
  """

  @derive [Poison.Encoder]
  defstruct [:ref]

  @type t :: %FacebookMessenger.Optin{
    ref: String.t
  }
end

defmodule FacebookMessenger.Postback do
    @moduledoc """
    Facebook postback structure
    """

    @derive [Poison.Encoder]
    defstruct [:payload]

    @type t :: %FacebookMessenger.Postback{
        payload: String.t
    }
end

defmodule FacebookMessenger.AccountLinking do
  @moduledoc """
  Account linking structure
  """

  @derive [Poison.Encoder]
  defstruct [:authorization_code, :status]

  @type t :: %FacebookMessenger.AccountLinking{
    authorization_code: String.t,
    status: String.t
  }
end

defmodule FacebookMessenger.Delivery do
  @moduledoc """
  Delivery structure
  """

  @derive [Poison.Encoder]
  defstruct [:mids, :watermark, :seq]

  @type t :: %FacebookMessenger.Delivery{
    mids: [ String.t ],
    watermark: integer,
    seq: integer
  }
end

defmodule FacebookMessenger.Messaging do
  @moduledoc """
  Facebook messaging structure, contains the sender, recepient and message info
  """
  @derive [Poison.Encoder]
  defstruct [:sender, :recipient, :timestamp, :message, :optin, :postback, :account_linking, :delivery]

  @type t :: %FacebookMessenger.Messaging{
    sender: FacebookMessenger.User.t,
    recipient: FacebookMessenger.User.t,
    timestamp: integer,
    message: FacebookMessenger.Message.t,
    optin: FacebookMessenger.Optin.t,
    postback: FacebookMessenger.Postback.t,
    account_linking: FacebookMessenger.AccountLinking.t,
    delivery: FacebookMessenger.Delivery.t,
  }
end

defmodule FacebookMessenger.Entry do
  @moduledoc """
  Facebook entry structure
  """
  @derive [Poison.Encoder]
  defstruct [:id, :time, :messaging]

  @type t :: %FacebookMessenger.Entry{
    id: String.t,
    messaging: FacebookMessenger.Messaging.t,
    time: integer
  }
end

defmodule FacebookMessenger.Response do
  @moduledoc """
  Facebook messenger response structure
  """

  @derive [Poison.Encoder]
  defstruct [:object, :entry]

  @doc """
  Decodes a map into a `FacebookMessenger.Response`
  """
  @spec parse(map) :: FacebookMessenger.Response.t
  def parse(param) when is_map(param) do
    Poison.Decode.decode(param, as: decoding_map)
  end

  @doc """
  Decodes a string into a `FacebookMessenger.Response`
  """
  @spec parse(String.t) :: FacebookMessenger.Response.t

  def parse(param) when is_binary(param) do
    Poison.decode!(param, as: decoding_map)
  end

  @doc """
  Returns a list of message texts from a `FacebookMessenger.Response`
  """
  @spec message_texts(FacebookMessenger.Response) :: [String.t]
  def message_texts(%{entry: entries}) do
    messaging =
    Enum.flat_map(entries, &Map.get(&1, :messaging))
    |> Enum.map(&( &1 |> Map.get(:message) |> Map.get(:text)))
  end

  @doc """
  Return a list of attachments from a `FacebookMessenger.Response`
  """
  @spec message_attachments(FacebookMessenger.Response) :: [FacebookMessenger.Attachment.t]
  def message_attachments(%{entry: entries}) do
    messaging =
    Enum.flat_map(entries, &Map.get(&1, :messaging))
    |> Enum.map(&(&1 |> Map.get(:message)))
    |> Enum.flat_map(&Map.get(&1, :attachments))
  end

  @doc """
  Return a list of attachment_payloads from a `FacebookMessenger.Response`
  """
  @spec message_attachment_payloads(FacebookMessenger.Response) :: [FacebookMessenger.Payload.t]
  def message_attachment_payloads(%{entry: entries}) do
    messaging =
    Enum.flat_map(entries, &Map.get(&1, :messaging))
    |> Enum.map(&(&1 |> Map.get(:message)))
    |> Enum.flat_map(&Map.get(&1, :attachments) |> Map.get(:payload))
  end


  @doc """
  Returns a list of message recipients from a `FacebookMessenger.Response`
  """
  @spec message_senders(FacebookMessenger.Response) :: [FacebookMessenger.User.t]
  def message_senders(%{entry: entries}) do
    messaging =
    Enum.flat_map(entries, &Map.get(&1, :messaging))
    |> Enum.map(&( &1 |> Map.get(:sender)))
  end

  @doc """
  Returns a list of message optins from a `FacebookMessenger.Response`
  """
  @spec message_optins(FacebookMessenger.Response) :: [FacebookMessenger.Optin.t]
  def message_optins(%{entry: entries}) do
    messaging =
    Enum.flat_map(entries, &Map.get(&1, :messaging))
    |> Enum.map(&( &1 |> Map.get(:optin)))
  end

  @doc """
  Returns a list of message deliveries from a `FacebookMessenger.Response`
  """
  @spec message_deliveries(FacebookMessenger.Response) :: [FacebookMessenger.Delivery.t]
  def message_deliveries(%{entry: entries}) do
    messaging =
    Enum.flat_map(entries, &Map.get(&1, :messaging))
    |> Enum.map(&( &1 |> Map.get(:delivery)))
  end

  @doc """
  Returns a list of message postbacks from a `FacebookMessenger.Response`
  """
  @spec message_postbacks(FacebookMessenger.Response) :: [FacebookMessenger.Postback.t]
  def message_postbacks(%{entry: entries}) do
    messaging =
    Enum.flat_map(entries, &Map.get(&1, :messaging))
    |> Enum.map(&( &1 |> Map.get(:postback)))
  end

  @doc """
  Returns a list of message postbacks from a `FacebookMessenger.Response`
  """
  @spec message_postbacks_text(FacebookMessenger.Response) :: [String.t]
  def message_postbacks_text(%{entry: entries}) do
    messaging =
    Enum.flat_map(entries, &Map.get(&1, :messaging))
    |> Enum.map(&( &1 |> Map.get(:postback) |> Map.get(:payload)))
  end


  defp decoding_map do
     messaging_parser =
    %FacebookMessenger.Messaging{
      "sender": %FacebookMessenger.User{},
      "recipient": %FacebookMessenger.User{},
      "message": %FacebookMessenger.Message{
        "attachments": [%FacebookMessenger.Attachment{}],
        "quick_replies": [%FacebookMessenger.QuickReply{}],
        "quick_reply": %FacebookMessenger.QuickReply{}
      },
      "optin": %FacebookMessenger.Optin{},
      "postback": %FacebookMessenger.Postback{},
      "account_linking": %FacebookMessenger.AccountLinking{},
      "delivery": %FacebookMessenger.Delivery{},
    }
    %FacebookMessenger.Response{
      "entry": [%FacebookMessenger.Entry{
        "messaging": [messaging_parser]
      }]}
  end

   @type t :: %FacebookMessenger.Response{
    object: String.t,
    entry: FacebookMessenger.Entry.t
  }

end

defmodule FacebookMessenger.Request do
  @moduledoc """
  Facebook messaging structure to be sent on Send-API requests
  """
  @derive [Poison.Encoder]
  defstruct [:recipient, :message]

  @type t :: %FacebookMessenger.Request{
    recipient: FacebookMessenger.User.t,
    message: FacebookMessenger.Message.t
  }
end
