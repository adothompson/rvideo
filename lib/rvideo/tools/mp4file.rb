module RVideo
  module Tools
    class Mp4file
      include AbstractTool::InstanceMethods

      attr_reader :raw_metadata

      def tool_command
        'mp4file'
      end

      def format_fps(params={})
          " -rate=#{params[:fps]}" 
      end

      def parse_result(result)
        if m = /MP4ERROR: MP4Open: failed: No such file or directory\n/.match(result)
          raise TranscoderError::InputFileNotFound
        end
        
        if m = /ReadAtom: invalid atom size/.match(result)
          raise TranscoderError::InvalidFile, "input must be a valid MP4 file"
        end
          
        if m = /usage: mp4file /i.match(result)
          raise TranscoderError::InvalidCommand, "command printed mp4file help text (and presumably didn't execute)"
        end
        
        if @options['output_file'] && !File.exist?(@options['output_file'])
          raise TranscoderError::UnexpectedResult, "An unknown error has occured with mp4file:#{result}"
        end

        @raw_metadata = result.empty? ? "No Results" : result
        return true
      end

    end
  end
end
