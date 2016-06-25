require 'evernote_oauth'
require 'singleton'

module Evernote
  class Client
    include Singleton
    attr_reader :token, :note_store

    def initialize
      @token = ENV['EVERNOTE_DEVELOPER_TOKEN']
      @note_store = ::EvernoteOAuth::Client.new(token: @token, sandbox: false).note_store
    end
  end

  class Note
    OFFSET = 0
    MAX_RESULT_NUM = 1

    def initialize(title:, content:, notebook_name:, search_keyword:)
      @note_store = ::Evernote::Client.instance.note_store
      @title      = title
      @content    = formatted_xml(content)
      @search_keyword  = search_keyword
      @parent_notebook = parent_notebook(notebook_name)
    end

    def update
      begin
        new_note = Evernote::EDAM::Type::Note.new
        new_note.title   = @title
        new_note.content = @content

        filter = Evernote::EDAM::NoteStore::NoteFilter.new(words: @search_keyword)
        found_note = @note_store.findNotes(::Evernote::Client.instance.token, filter, OFFSET, MAX_RESULT_NUM).notes.first

        if found_note
          new_note.guid = found_note.guid
          @note_store.updateNote(::Evernote::Client.instance.token, new_note)
        else
          new_note.notebookGuid = @parent_notebook.guid
          @note_store.createNote(new_note)
        end

        new_note
      rescue Evernote::EDAM::Error::EDAMUserException => e
        # Something was wrong with the note data
        # See EDAMErrorCode enumeration for error code explanation
        # http://dev.evernote.com/documentation/reference/Errors.html#Enum_EDAMErrorCode
        puts "EDAMUserException: #{e}"
      rescue Evernote::EDAM::Error::EDAMNotFoundException
        puts "EDAMNotFoundException: Invalid parent notebook GUID"
      end
    end

    private

    def parent_notebook(name)
      @note_store.listNotebooks.find { |notebook| notebook.name == name }
    end

    def formatted_xml(content)
      <<-HEADER
<?xml version=\"1.0\" encoding=\"UTF-8\"?>
<!DOCTYPE en-note SYSTEM \"http://xml.evernote.com/pub/enml2.dtd\">
<en-note>#{content}</en-note>
      HEADER
    end
  end
end
