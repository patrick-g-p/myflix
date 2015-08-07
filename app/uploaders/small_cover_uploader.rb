class SmallCoverUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  def extension_white_list
    %w(jpg jpeg png)
  end

  process resize_to_fill: [166, 236]
end
