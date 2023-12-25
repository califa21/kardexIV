class Doc
    require 'zip'
    require 'tempfile'
    attr_reader :document_content

    def initialize(path, temp_dir=nil)
      @zip_file = Zip::File.new(path)
      @temp_dir = temp_dir
      read_docx_file
    end

    def replace(pattern, replacement, multiple_occurrences=false)
      replace = replacement.to_s.encode(xml: :text)
      
      #for each sur le tableau de doc à faire
      if multiple_occurrences
	        @fic_mod.each do |key,fic|
			fic.force_encoding("UTF-8").gsub!(pattern, replace)
		end
	        #@document_content.force_encoding("UTF-8").gsub!(pattern, replace)
		#@header_content.force_encoding("UTF-8").gsub!(pattern, replace)
      else
		@fic_mod.each do |key,fic|
			fic.force_encoding("UTF-8").sub!(pattern, replace)
		end
		#@document_content.force_encoding("UTF-8").sub!(pattern, replace)
		#@header_content.force_encoding("UTF-8").sub!(pattern, replace)
      end
    end

    def matches(pattern)
      @document_content.scan(pattern).map{|match| match.first}
    end

    def unique_matches(pattern)
      matches(pattern)
    end

    alias_method :uniq_matches, :unique_matches


    def commit(new_path=nil)
      write_back_to_file(new_path)
    end

    private
    DOCUMENT_FILE_PATH = 'word/document.xml'
    HEADER_File = 'word/header'

    def read_docx_file
	#creation d'un file content pour le document et pour les fichier header
	@fic_mod = Hash.new
	@zip_file.entries.each do |e|
		 if (e.name == DOCUMENT_FILE_PATH || e.name.include?(HEADER_File)) then
			 #si le nom du fichier m'interresse mise dans le Hash
			@fic_mod[e.name] = @zip_file.read(e.name)
		 end
	end
		
      #@document_content = @zip_file.read(DOCUMENT_FILE_PATH)
      #@header_content = @zip_file.read( HEADER_FILE_PATH)
      #en sortie un tableau de variable globale contenant les documents à mofifier
    end

    def write_back_to_file(new_path=nil)
      if @temp_dir.nil?
        temp_file = Tempfile.new('docxedit-')
      else
        temp_file = Tempfile.new('docxedit-', @temp_dir)
      end
      Zip::OutputStream.open(temp_file.path) do |zos|
        @zip_file.entries.each do |e|
          unless (@fic_mod.key?(e.name))
            zos.put_next_entry(e.name)
            zos.print e.get_input_stream.read
          end
	end
	@fic_mod.each do |key,fic|
		zos.put_next_entry(key)
		zos.print fic
	end
      end
       temp_file.close
      if new_path.nil?
        path = @zip_file.name
        FileUtils.rm(path)
      else
        path = new_path
      end
      FileUtils.mv(temp_file.path, path)
      @zip_file = Zip::File.new(path, true)
    end
  end
  
