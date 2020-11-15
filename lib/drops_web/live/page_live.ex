defmodule DropsWeb.PageLive do
  use DropsWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:uploaded_files, [])
     |> allow_upload(:exhibit,
       accept: ~w(video/* image/*),
       max_entries: 1,
       auto_upload: true,
       # progress: &handle_progress/3,
       external: &presign_upload/2
     )}
  end

  @impl true
  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :exhibit, ref)}
  end

  @impl true
  def handle_event("save", _params, socket) do
    IO.puts("HELP - I AM STUCK")
    {:noreply, socket}
  end

  defp handle_progress(:exhibit, entry, socket) do
    if entry.done? do
      uploaded_file =
        consume_uploaded_entry(socket, entry, fn %{} = meta ->
          meta
        end)

      s3_conf = Application.get_env(:ex_aws, :s3)
      bucket = Application.get_env(:drops, :bucket)

      img_url =
        "#{Keyword.get(s3_conf, :scheme)}#{bucket}.#{Keyword.get(s3_conf, :host)}/#{
          uploaded_file.key
        }"

      socket =
        assign(socket,
          uploaded_files: [img_url]
        )

      {:noreply, socket}
    else
      {:noreply, socket}
    end
  end

  defp presign_upload(entry, socket) do
    bucket = Application.fetch_env!(:drops, :bucket)
    key = Application.fetch_env!(:drops, :path) <> entry.client_name
    query_params = [{"ContentType", "image/jpeg"}, {"x-amz-acl", "public-read"}]
    presign_options = [virtual_host: true, query_params: query_params]

    {:ok, url} =
      ExAws.Config.new(:s3)
      |> ExAws.S3.presigned_url(:put, bucket, key, presign_options)

    meta = %{
      uploader: "S3",
      key: key,
      url: url,
      fields: %{"x-amz-acl" => "public-read", "Content-Type": "image/jpeg"}
    }

    {:ok, meta, socket}
  end
end
