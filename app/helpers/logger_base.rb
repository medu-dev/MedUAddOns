class LoggerBase

  BASE_PATH = LOGFILE = "log/"

  def initialize(log_file_name)
    @logfile = BASE_PATH+log_file_name
  end

  def open
    file_rollover
    return File.open(@logfile, "a")
  end

  def get_name
    return @logfile
  end

  # keep logfiles by date. rollover if logfile is not from today. similar to "daily" option on Logger
  def file_rollover
    # can't do anything if we don't have a file
    if !File.exists?(@logfile)
      return
    end

    if self.change_date?
      begin
        extension = File.stat(@logfile).ctime.strftime("%Y%m%d")
        File.rename(@logfile, LOGFILE+"."+extension)
      rescue
        # do nothing
      end
    end

  end

  # determines if the date of the file is different from todays date
  def change_date?
    stat = File.stat(@logfile)

    now = Time.now.strftime("%Y%m%d")

=begin
    what we really want is file creation date, but ruby doesn't return it. Best we can do is ctime, which according
    to doc is: Returns the change time for the named file (the time at which directory information about the file was changed,
    not the file itself).
=end
    access_time = stat.ctime.strftime("%Y%m%d")

    #return access_time.eql?(now) # for debugging
    return !access_time.eql?(now)
  end

  def create_log_entry(msg)
    file_rollover
    log_file = File.open(@logfile, "a")
    log_file.write(msg)
    log_file.flush
    log_file.close
  end



end