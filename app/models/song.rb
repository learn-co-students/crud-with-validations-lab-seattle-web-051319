class Song < ApplicationRecord
  validate :cannot_be_released_without_release_year, :release_year_cannot_be_greater_that_current_year, :cannot_release_same_song_more_than_per_year
  validates :title, presence: true
  validates :released, inclusion: { in: [true, false] }
  validates :artist_name, presence: true

  def cannot_be_released_without_release_year
    if self.released == true && self.release_year == nil
      errors.add(:release_year, "has to have a release year if the song has been released")
    end
  end

  def release_year_cannot_be_greater_that_current_year
    year = Time.now.year
    if self.release_year.to_i > year
      errors.add(:release_year, "can't be released in the future")
    end
  end

  def cannot_release_same_song_more_than_per_year
    matching_year_songs = Song.all.select {|song|song.release_year == self.release_year}
    matching_artist_songs = matching_year_songs.select {|song|song.artist_name == self.artist_name}

    matching_artist_songs.each do |song|
      if self.title == song.title
        errors.add(:title, "can't release the same song in the same year")
      end
    end
  end

end
