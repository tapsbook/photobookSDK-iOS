#encoding: UTF-8

class TBObject
  attr_accessor :id
  
  def table_name
    nil
  end
  
  def to_s
    str = "#{self.class}:\n"
    instance_variables.each do |var|
      str += " %s: %s\n" % [var, instance_variable_get(var)]
    end
    str
  end
  
  def to_sql
    sql = 
    column_names = []
    column_values = []
    # values
    
    instance_variables.each do |var|
      column_names << "'" + var.to_s[1..-1] + "'"
      
      value = instance_variable_get(var)
      column_values << (value.kind_of?(String) ? ("'" + value + "'") : value)
    end
    
    sql ="INSERT INTO '#{self.table_name}' (" + column_names.join(',') + ") VALUES (" + column_values.join(',') + ");"
  end
  
end

class TBBg < TBObject
  attr_accessor :theme_id
  attr_accessor :print_info_id
  attr_accessor :thumb_path, :print_path, :display_path
  attr_accessor :color
  attr_accessor :is_spread
  
  def table_name
    'bgs'
  end
end

class TBFrame < TBObject
  attr_accessor :theme_id
  attr_accessor :type
  attr_accessor :default_width
  attr_accessor :max_width
  attr_accessor :page_height
  attr_accessor :default_color
  attr_accessor :name
  attr_accessor :advanced_config_path
  
  def table_name
    'frames'
  end
  
end

class TBLayout < TBObject
  attr_accessor :theme_id
  attr_accessor :std_ratio_type
  attr_accessor :print_info_id
  attr_accessor :bg_id
  attr_accessor :is_spread
  attr_accessor :thumb_path
  attr_accessor :width
  attr_accessor :height
  attr_accessor :idx
  attr_accessor :is_front_page_layout
  attr_accessor :is_gutter_safe
  
  def table_name
    'page_layouts'
  end
  
end

class TBPrintInfoTheme < TBObject
  attr_accessor :print_info_id
  attr_accessor :theme_id
  
  def table_name
    'print_info_theme'
  end
end

class TBPrintInfo < TBObject
  attr_accessor :server_id
  attr_accessor :provider_name
  attr_accessor :name
  attr_accessor :description
  attr_accessor :preview_path
  attr_accessor :std_ratio_type
  attr_accessor :std_width
  attr_accessor :std_height
  attr_accessor :min_pages_count
  attr_accessor :max_pages_count
  attr_accessor :type
  attr_accessor :product_type
  attr_accessor :page_output_type
  attr_accessor :cover_output_type
  attr_accessor :std_page_print_width
  attr_accessor :std_page_print_height
  attr_accessor :cover_print_width
  attr_accessor :cover_print_height
  attr_accessor :min_ppi
  attr_accessor :max_ppi
  attr_accessor :spine_width

  def table_name
    'print_infos'
  end
  
end

class TBSlot < TBObject
  attr_accessor :layout_id
  attr_accessor :z_position
  attr_accessor :center_x
  attr_accessor :center_y
  attr_accessor :width
  attr_accessor :height
  attr_accessor :rotation
  attr_accessor :content_width
  attr_accessor :content_height
  attr_accessor :content_offset_x
  attr_accessor :content_offset_y
  attr_accessor :content_rotation
  attr_accessor :content_type
  attr_accessor :text_content
  attr_accessor :text_font_size
  attr_accessor :text_font_name
  attr_accessor :text_foreground_color
  attr_accessor :text_stroke_color
  attr_accessor :text_background_color
  attr_accessor :text_stroke_width
  attr_accessor :text_alignment
  attr_accessor :frame_id
  attr_accessor :frame_width_or_scale
  attr_accessor :frame_color
  attr_accessor :server_id
  
  def table_name
    'slots'
  end
  
end

class TBTheme < TBObject
  attr_accessor :name
  attr_accessor :std_page_width
  attr_accessor :std_page_height
  attr_accessor :need_inside_cover_pages
  attr_accessor :preview_path
  attr_accessor :std_ratio_type
  attr_accessor :allow_generic_layout
  
  def table_name
    'themes'
  end
  
end
