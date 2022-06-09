defmodule LiveViewStudio.Repo.Migrations.CreateFlight do
  use Ecto.Migration

  def change do
    create table(:flight) do
      add :number, :string
      add :origin, :string
      add :destination, :string
      add :departure_time, :date
      add :arrival_time, :date

      timestamps()
    end

  end
end
