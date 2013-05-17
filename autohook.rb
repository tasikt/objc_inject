#!/usr/bin/env ruby
# usage ./autohook.rb  target file
# 借鉴了 THEOS/LOGOS 的语法
# 快速生成注入代码

=begin 
TODO:
  [] insert function support
  [] log support
  [] better origin IMP storage , or need append a unique name to static variable
=end


=begin Documents here 
= a template to fast launch your task

#define HOOK_SCRIPTING 0
#if HOOK_SCRIPTING
%hook DemoObj
- (id)nothing:(id)arg{
    arg = %origin(arg);
    return arg;
}
%end
#else 
//-BEGIN-HOOK-GEN-CODES
//-END-HOOK-GEN-CODES
#endif

=end 


#  正则里通过 .*? 问号来防止贪婪算法
#  =begin =end 注释多行

DIR = File.expand_path(File.dirname(__FILE__))

require 'erb'

def usage
  puts "usage : autohook.rb targetfile"
  true
end

def imp_from_sel sel
  "_imp_#{sel.gsub(':','__')}"
end

# check arguments
file = ARGV.last || "main.m"
usage and exit 0 unless file


content = File.read(file)

# search for hooks %hooks ... %end
hooks = content.scan(/%hook\s.*?%end/m)

# instance method search and map to selector
# - (void)another:(id)arg1 and:(id)arg2
# another:and:
rawcodes = ""
hooks.each do |hook|
  
  # get hook class
  klass = hook.scan(/%hook\s+\w+/).first.gsub(/%hook\s+/,'')
  puts "Hook class : #{klass}"
  
  # remove comments for scan
  hook_without_comments = hook.gsub(/\/\/.*/,'').gsub(/\/\*.*?\*\//m,'')
  
  # scan to -(void)method{...}
  methods = hook.scan(/-\s*\(.*?\).*?\{.*?\}/m)  
  selectors = []
  
  methods.each do |method|
    # get method name : -(void)method
    method = method.gsub!(/\{.*\}/m,'')

    # get selector
    selector = method.scan(/\w*\s*:/m).join('').gsub(/\s*/,'')
    if selector.empty?
      # so it might a method - (BOOL)mVip without :
      selector = method.gsub(/-\s*\(.+?\)/,'').strip
    end
    
    if selector.empty?
      puts "ERROR: can't parse method #{method}"
    end
    # only hook method that not commented
    # the reason why not using hook_without_comments instead hook to scan methods
    # because replace %origin need current method-name, required one-2-one matched
    if hook_without_comments.include? method
      selectors << selector
      puts "\t#{selector}"
    end
    
    # and modify $origin -> to rawcodes
    hook.sub!("%origin(","#{imp_from_sel selector}(self,_cmd,")
  end
  
  # after scan, time to modify other contents
  # remove hook class and tail
  hook.gsub!(/%hook\s+\w+/,'').gsub!(/%end/,'').strip!
  
  # binding -> passing env to another , interesting
  hook_class = klass
  body = hook  
  rawcode = ERB.new(File.read("#{DIR}/autohook.erb.m"),nil,'-').result(binding)
  rawcodes += rawcode
end

# insert rawcode to gen-codes-field
content.gsub!(/\/\/-BEGIN-HOOK-GEN-CODES.*\/\/-END-HOOK-GEN-CODES/m , "//-BEGIN-HOOK-GEN-CODES\n#{rawcodes}//-END-HOOK-GEN-CODES")

File.write(file,content)



