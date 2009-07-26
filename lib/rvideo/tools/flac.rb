module RVideo
  module Tools
    class Flac
      include AbstractTool::InstanceMethods
      
      attr_reader :raw_metadata
      
      def tool_command
        'flac'
      end
      
      private
      
      def parse_result(result)
        if m = /wrote \d+ bytes, ratio=/.match(result)
          @raw_metadata = result
          return true
        end
        
        if m = /No such file or directory/.match(result)
          raise TranscoderError::InputFileNotFound
        end

        if m = /for encoding a raw file you must specify/.match(result)
          raise TranscoderError::InvalidFile, "input file must be a valid audio file"
        end
          
        if m = /this is the short help/i.match(result)
          raise TranscoderError::InvalidCommand, "command printed flac help text (and presumably didn't execute)"
        end
        
        raise TranscoderError::UnexpectedResult, result
      end
      
    end
  end
end

