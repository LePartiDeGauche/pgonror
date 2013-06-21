class CleanAudioFiles < ActiveRecord::Migration
  def up
    execute "update articles set document_file_name=null, document_content_type=null, document_file_size=null, document_updated_at=null where category='son' and audio_file_name is not null and document_file_name is not null"
  end

  def down
  end
end
