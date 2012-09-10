module PuppetAcceptance
  class Result
    attr_accessor :host, :cmd, :stdout, :stderr, :exit_code, :output,
                  :raw_output, :raw_stdout, :raw_stderr
    def initialize(host, cmd)
      @host       = host
      @cmd        = cmd
      @stdout     = ''
      @stderr     = ''
      @output     = ''
      @raw_output = ''
      @raw_stdout = ''
      @raw_stderr = ''
      @exit_code  = nil
    end

    def log(logger)
      logger.debug "Exited: #{exit_code}" unless exit_code == 0
    end

    def formatted_output(limit=10)
      @output.split("\n").last(limit).collect {|x| "\t" + x}.join("\n")
    end

    def exit_code_in?(range)
      range.include?(@exit_code)
    end
  end
end
