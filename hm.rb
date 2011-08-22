def exec(cmd)
  puts cmd
  `#{cmd}`
end


puts "setting svn ignores:"

exec "rm -f log/*.log"
exec "svn propset svn:ignore \".bundle\" ."
exec "cd log; svn propset svn:ignore \"*.log\" . ; cd .."
exec "cd tmp/cache; svn propset svn:ignore \"*\" . ; cd ../.."
exec "mkdir -p tmp/sass-cache"
exec "svn add tmp/sass-cache"
exec "cd tmp/sass-cache; svn propset svn:ignore \"*\" . ; cd ../.."
exec "cd tmp/pids; svn propset svn:ignore \"*\" . ; cd ../.."
exec "cd tmp/sessions; svn propset svn:ignore \"*\" . ; cd ../.."
exec "cd tmp/sockets; svn propset svn:ignore \"*\" . ; cd ../.."