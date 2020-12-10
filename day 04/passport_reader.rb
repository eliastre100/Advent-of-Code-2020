class PassportReader
  def read(str)
    tags = extract_tags(str)
    tags.each do |tag|
      passport.public_send("#{tag[:tag]}=", tag[:value])
    end
  end

  def extract_passport
    passport.tap do
      @passport = nil
    end
  end

  private

  def extract_tags(str)
    str.split(' ').map do |tag_str|
      tag_slitted = tag_str.split(':')
      {
        tag: tag_slitted.first,
        value: tag_slitted.last
      }
    end
  end

  def passport
    @passport ||= Passport.new
  end
end
