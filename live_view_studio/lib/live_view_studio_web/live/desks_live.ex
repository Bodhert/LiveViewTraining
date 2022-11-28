defmodule LiveViewStudioWeb.DesksLive do
  use LiveViewStudioWeb, :live_view

  alias LiveViewStudio.Desks
  alias LiveViewStudio.Desks.Desk

  def mount(_params, _session, socket) do
    if connected?(socket), do: Desks.subscribe()

    desks = Desks.list_desks()
    changeset = Desks.change_desk(%Desk{})

    socket =
      assign(socket,
        desks: desks,
        changeset: changeset
      )

    socket =
      allow_upload(
        socket,
        :photo,
        accept: ~w(.png .jpeg .jpg),
        max_entries: 3,
        max_file_size: 10_000_000
      )

    {:ok, socket, temporary_assigns: [desks: []]}
  end

  def handle_event("save", %{"desk" => params}, socket) do
    {completed, []} = uploaded_entries(socket, :photo)

    urls =
      for entry <- completed do
        Routes.static_path(socket, "/uploads/#{filename(entry)}")
      end

    desk = %Desk{photo_urls: urls}

    case Desks.create_desk(desk, params, &consume_photos(socket, &1)) do
      {:ok, _desk} ->
        changeset = Desks.change_desk(%Desk{})
        {:noreply, assign(socket, changeset: changeset)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end

  def handle_event("validate", %{"desk" => params}, socket) do
    changeset =
      %Desk{}
      |> Desks.change_desk(params)
      |> Map.put(:action, :insert)

    {:noreply, assign(socket, changeset: changeset)}
  end

  def handle_event("cancel", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :photo, ref)}
  end

  def handle_info({:desk_created, desk}, socket) do
    {:noreply, update(socket, :desks, fn desks -> [desk | desks] end)}
  end

  def consume_photos(socket, desk) do
    consume_uploaded_entries(socket, :photo, fn meta, entry ->
      dest = Path.join("priv/static/uploads", filename(entry))
      File.cp!(meta.path, dest)
      {:ok, Routes.static_path(socket, "/uploads/#{filename(entry)}")}
    end)

    {:ok, desk}
  end

  def error_to_string(:too_large),
    do: "File too large (max 10 MB)."

  def error_to_string(:too_many_files),
    do: "You've selected too many files."

  def error_to_string(:not_accepted),
    do: "You've selected an unacceptable file type."

  defp filename(entry) do
    [ext | _] = MIME.extensions(entry.client_type)
    "#{entry.uuid}.#{ext}"
  end
end
