#encoding: UTF-8

require 'nokogiri'
require_relative 'model.rb'

# ====================== Input Parameters Starts =====================
config_path = 'Templates.sample.xml'
# XML contains my sizes, this example filters to include only aspect ratio of 11x8.5 and 1x1
std_page_ratios = [11/8.5, 1/1]
# in SDK database, give each aspect ratio above an theme_id
std_ratio_types = [1, 4]
# Theme_id start index
theme_start_id = 200
# Each template page is a layout, here is its start index
layout_start_id = 2000
# Each page contains multiple slots
slot_star_id = 20000
# A large base number to convert the float number to integer, doing this to avoid saving integer to DB
dimension_scale_ratio = 7500
# ====================== Input Parameters Ends =====================

tb_themes = []
tb_layouts = []
tb_slots = []

def trim num
  i, f = num.to_i, num.to_f
  i == f ? i : f
end

=begin
Here is the sample Cascade template data in XML format, 
notice the following concept level mapping to the SDK's Template DB
- AlbumWidthInches/AlbumHeightInches  < = > Themes (Aspect Ratio)
- Templates                           < = > Page_layouts (Pages)
- DropZone                            < = > Slots
- template_type (pano vs split)       < = > Spread page (Spread vs Std page)
The unit of its cordinates were inch.

<TemplateList>
  <TemplateListSet>
    <ID>1</ID>
    <Name><![CDATA[Cascade]]></Name>
    <Locked>Yes</Locked>
    <System>Yes</System>
    <TemplateCount>0</TemplateCount>
    <Templates>
      <TemplateInfo>
        <ID>CD594FE2-29F5-8E37-E097-10B6DC9595AC</ID>
        <SetName>Cascade</SetName>
        <Name>14x11_01_000</Name>
        <Type>template_type_split</Type>
        <WidthInches>14</WidthInches>
        <HeightInches>11</HeightInches>
        <AlbumWidthInches>14</AlbumWidthInches>
        <AlbumHeightInches>11</AlbumHeightInches>
        <DropZones>
          <DropZone>
            <X>3.8</X>
            <Y>2.3036</Y>
            <Z>0</Z>
            <Width>6.4</Width>
            <Height>6.3996</Height>
            <BGColor>-1</BGColor>
            <StrokeWidth>0</StrokeWidth>
            <StrokeColor>0</StrokeColor>
            <Opacity>1</Opacity>
            <Rotation>0</Rotation>
          </DropZone>
        </DropZones>
        <Texts>
        </Texts>
      </TemplateInfo>

=end


doc = Nokogiri::XML(open(config_path))

templates_doc = doc.xpath('//TemplateListSet/Templates/TemplateInfo')

previous_std_width = 0
previous_std_height = 0
previous_theme = nil

templates_doc.each do |template_node|
  std_page_width = template_node.xpath('./AlbumWidthInches')[0].content.to_f
  std_page_height = template_node.xpath('./AlbumHeightInches')[0].content.to_f
  
  # puts "#{std_page_width}, #{std_page_height}, #{(std_page_width / std_page_height)}"
  # gets
  
  next unless std_page_ratios.include? (std_page_width / std_page_height)
  
  # theme
  if std_page_width != previous_std_width || std_page_height != previous_std_height || previous_theme == nil
    # puts 'new theme'
    # puts layouts.count
    # gets
    
    previous_std_width = std_page_width
    previous_std_height = std_page_height
    
    previous_theme = TBTheme.new
    previous_theme.id = theme_start_id
    theme_start_id = theme_start_id + 1
    
    previous_theme.std_page_width = (std_page_width * dimension_scale_ratio).to_i
    previous_theme.std_page_height = (std_page_height * dimension_scale_ratio).to_i
    previous_theme.need_inside_cover_pages = 1
    
    ratio_index = std_page_ratios.index(std_page_width / std_page_height)
    previous_theme.std_ratio_type = std_ratio_types[ratio_index]
    
    tb_themes << previous_theme
  end
  
  # puts previous_theme
  # gets
  
  # layout
  layout_width = template_node.xpath('./WidthInches')[0].content.to_f
  layout_height = template_node.xpath('./HeightInches')[0].content.to_f
  
  tb_layout = TBLayout.new
  tb_layout.id = layout_start_id
  layout_start_id = layout_start_id + 1
  
  tb_layout.theme_id = previous_theme.id
  tb_layout.std_ratio_type = previous_theme.std_ratio_type

  tb_layout.width = (layout_width * dimension_scale_ratio).to_i
  tb_layout.height = (layout_height * dimension_scale_ratio).to_i
  
  tb_layout.thumb_path = "Tapsbook/Layouts/#{trim(std_page_width)}x#{trim(std_page_height)}/layout_#{tb_layout.id}.png"
  
  if tb_layout.width / previous_theme.std_page_width == 2
    tb_layout.is_spread = 1
  else
    tb_layout.is_spread = 0
  end
  
  # TODO: thumb_path
  
  tb_layouts << tb_layout
  
  # puts tb_layout
  # gets
  
  # slots
  dropzones_doc = template_node.xpath('./DropZones/DropZone')
  
  dropzones_doc.each_with_index do |dropzone_node, index|
    tb_slot = TBSlot.new
    tb_slot.id = slot_star_id
    slot_star_id = slot_star_id + 1
    tb_slot.layout_id = tb_layout.id
    
    slot_top = dropzone_node.xpath('./Y')[0].content.to_f
    slot_left = dropzone_node.xpath('./X')[0].content.to_f
    slot_width = dropzone_node.xpath('./Width')[0].content.to_f
    slot_height = dropzone_node.xpath('./Height')[0].content.to_f
    slot_rotation = dropzone_node.xpath('./Rotation')[0].content.to_f
    
    tb_slot.center_x = ((slot_left + slot_width / 2) * dimension_scale_ratio).to_i
    tb_slot.center_y = ((slot_top + slot_height / 2) * dimension_scale_ratio).to_i
    tb_slot.width = (slot_width * dimension_scale_ratio).to_i
    tb_slot.height = (slot_height * dimension_scale_ratio).to_i
    tb_slot.rotation = (slot_rotation * dimension_scale_ratio).to_i
    tb_slot.z_position = index
    
    tb_slot.content_width = tb_slot.width
    tb_slot.content_height = tb_slot.height
    tb_slot.content_offset_x = 0
    tb_slot.content_offset_y = 0
    tb_slot.content_rotation = 0
    tb_slot.content_type = 1
    
    tb_slots << tb_slot
    
    # puts slot_top
    # puts slot_left
    # puts slot_width
    # puts slot_height
    #
    # puts tb_slot
    # gets
  end
end

puts "/* Processed #{tb_themes.count} themes, including #{tb_layouts.count} layouts and #{tb_slots.count} slots */"

puts '/* === Theme inserts === */'
tb_themes.each do |obj|
  puts obj.to_sql
end

puts '/* === Layout inserts  === */'
tb_layouts.each do |obj|
  puts obj.to_sql
end

puts '/* === Slot inserts  === */'
tb_slots.each do |obj|
  puts obj.to_sql
end
  
