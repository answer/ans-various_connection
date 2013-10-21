require "ans-releaser"
class GemReleaseTask
  include Ans::Releaser::GemTask

  def gem_host
    "gem.ans-web.co.jp"
  end
  def gem_root
    "/var/www/gem/public"
  end

  def version_file
    "lib/ans/various_connection/version.rb"
  end
end

GemReleaseTask.new.build_release_tasks
