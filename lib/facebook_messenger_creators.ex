defmodule FacebookMessenger.Creators do
  @doc """
  creates a button to send to facebook

    * :type - the type of the button
    * :title - the title button
    * :url - the url of the button if url type
    * :payload - the developer defined payload to be returned by the button
  """
  @spec create_button(String.t, String.t, String.t, String.t) :: FacebookMessenger.Button.t
  def create_button(type, title, url, payload) do
    labels = ["type", "title", "url", "payload"]
    values = [type, title, url, payload]
    create_map_not_null(labels, values)
  end

  @doc """
  creates an attachment to send to facebook

    * :type - the type of the attachment
    * :payload - the inner payload of the attachment
  """
  @spec create_attachment(String.t, FacebookMessenger.Payload.t) :: FacebookMessenger.Attachment.t
  def create_attachment(type, payload) do
    labels = ["type", "payload"]
    values = [type, payload]
    create_map_not_null(labels, values)
  end

  @doc """
  creates a payload to send to facebook

    * :template_type - the type of the payload
    * :text - the text of the payload
    * :buttons - a list of buttons
    * :elements - a list of elements
  """
  @spec create_payload(String.t, String.t, [ FacebookMessenger.Button.t ], [ FacebookMessenger.Element.t ]) :: FacebookMessenger.Payload.t
  def create_payload(template_type, text, buttons, elements) do
    labels = ["template_type", "text", "buttons", "elements"]
    values = [template_type, text, buttons, elements]
    create_map_not_null(labels, values)
  end

  @doc """
  creates an element to send to facebook
    * :title - the title of the element
    * :item_url - the url for when the element is clicked
    * :image_url - the image that appears on the element
    * :subtitle - the subtitle of the elemente
    * :buttons - the list of buttons on the element
  """
  @spec create_element(String.t, String.t, String.t, String.t, [ FacebookMessenger.Button.t ]) :: FacebookMessenger.Element.t
  def create_element(title, item_url, image_url, subtitle, buttons) do
    label = ["title", "item_url", "image_url", "subtitle", "buttons"]
    values = [title, item_url, image_url, subtitle, buttons]
    create_map_not_null(label, values)
  end

  @doc """
  creates a message to send to facebook
    * :text - the text of the payload
    * :attachment - the attachment of the message
  """
  @spec create_message(String.t, FacebookMessenger.Attachment.t) :: FacebookMessenger.Message2.t
  def create_message(text, attachment) do
    label = ["text", "attachment"]
    values = [text, attachment]
    create_map_not_null(label, values)
  end

  @doc """
  creates a request to send to facebook
    * :recipient - the user struct of the payload
    * :message - the message struct of the request
  """
  @spec create_request(FacebookMessenger.User.t, FacebookMessenger.Message.t) :: FacebookMessenger.Request.t
  def create_request(recipient, message) do
    label = ["recipient", "message"]
    values = [recipient, message]
    create_map_not_null(label, values)
  end

  @doc """
  creates a recipient to send to facebook
    * :id - the user struct of the payload
  """
  @spec create_recipient(integer) :: FacebookMessenger.User.t
  def create_recipient(id) do
    label = ["id"]
    values = [id]
    create_map_not_null(label, values)
  end

  @doc """
  creates a map with only with the labels whose corresponding values are not null
    * :labels - the names of the keys of the resulting map
    * :values - the values of each entry in the resulting map
  """
  def create_map_not_null(labels, values) when length(labels) == length(values) do
    map_aux = Enum.zip(labels, values) 
      |> Enum.into(%{}, fn {k,v} -> {String.to_atom(k),v} end)
      |> Enum.filter(fn {_, v} -> v != nil end)
      |> Enum.into(%{})
    map_aux
  end
end