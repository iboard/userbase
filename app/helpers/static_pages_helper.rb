module StaticPagesHelper
  
  def encode_filename(file_name)
    CGI::escape(Base64::encode64(file_name))
  end
  
  def decode_filename(enc_name)
    Base64::decode64(enc_name)
  end
  
end