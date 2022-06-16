defmodule LiveViewStudio.Repo.Migrations.CreateFlight do
  use Ecto.Migration

  def change do
    create table(:flight) do
      add(:number, :string)
      add(:origin, :string)
      add(:destination, :string)
      add(:departure_time, :naive_datetime_usec)
      add(:arrival_time, :naive_datetime_usec)

      timestamps()
    end
  end
end
