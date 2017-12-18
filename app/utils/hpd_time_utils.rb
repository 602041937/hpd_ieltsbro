module HPDTimeUtils

  def self.hpd_dateTimeToYmdHM(date_time)
    return date_time.to_datetime.strftime("%Y-%m-%d %H:%M")
  end

  def self.hpd_dateTimeToYmd(date_time)
    return date_time.to_datetime.strftime("%Y-%m-%d")
  end

end