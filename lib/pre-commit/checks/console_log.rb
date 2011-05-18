class ConsoleLog

  attr_accessor :staged_files, :error_message

  def self.call(quiet=false)
    check = new
    check.staged_files = Utils.staged_files('public/javascripts')

    result = check.run
    if !quiet && !result
      puts check.error_message
    end
    result
  end

  def run
    return true if staged_files.empty?
    if detected_bad_code?
      @error_message = "pre-commit: console.log found:\n"
      @error_message += instances_of_console_log_violations
      false
    else
      true
    end
  end

  def detected_bad_code?
    system('git diff --cached --pickaxe-regex -S"^[^/][^/].*console.log')
  end

  def instances_of_console_log_violations
    `git grep -nH "console.log" #{staged_files}`
  end

end
