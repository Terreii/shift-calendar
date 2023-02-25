class ChangeHolidayToAPublicEventChild < ActiveRecord::Migration[7.0]
  def up
    execute %(
      INSERT INTO public_events(type, name, duration, created_at, updated_at)
      SELECT 'Holiday', name, daterange(date, date, '[]'), created_at, updated_at
      FROM holidays;
    )
    drop_table :holidays
  end

  def down
    create_table :holidays do |t|
      t.string :name
      t.date :date

      t.timestamps
    end
    add_index :holidays, :date
    execute %(
      INSERT INTO holidays(name, date, created_at, updated_at)
      SELECT name, lower(duration), created_at, updated_at FROM public_events
      WHERE type = 'Holiday';
    )
    execute %(
      DELETE FROM public_events
      WHERE type = 'Holiday';
    )
  end
end
