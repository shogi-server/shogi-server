# Must live in test/ so File.dirname(__FILE__) resolves there;
# TC_config.rb#test_top_dir1 asserts $topdir equals test/'s expanded path.
$topdir ||= File.expand_path(File.dirname(__FILE__))
$options ||= {}
