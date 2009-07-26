module RVideo
  module Tools
    class Normalize
      include AbstractTool::InstanceMethods
      
      attr_reader :raw_metadata
      
      def tool_command
        'normalize'
      end
      
      private
      
      def parse_result(result)
        if m = /already normalized, not adjusting/.match(result)
          @raw_metadata = result
          return true
        end
        
        if m = /Applying adjustment of/.match(result)
          @raw_metadata = result
          return true
        end
        
        if m = /No such file or directory/.match(result)
          raise TranscoderError::InputFileNotFound
        end

        if m = /unrecognized audio file format/.match(result)
          raise TranscoderError::InvalidFile, "input file must be a valid wav file"
        end
          
        if m = /usage: normalize /i.match(result)
          raise TranscoderError::InvalidCommand, "command printed normalize help text (and presumably didn't execute)"
        end
        
        raise TranscoderError::UnexpectedResult, result
      end
      
    end
  end
end

