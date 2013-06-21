class UpdateAudioFiles < ActiveRecord::Migration
  def up
    execute "update articles set audio_file_name=document_file_name, audio_content_type=document_content_type, audio_file_size=document_file_size, audio_updated_at=document_updated_at where category='son' and audio_file_name is null and document_file_name is not null"
  end

  def down
  end
end
