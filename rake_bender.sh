#!/bin/bash
export PATH=$PATH:/usr/local/lib/ruby/2.3.0/rubygems

case $1 in
    start)
      cd /app/bender/current;
      unbuffer /app/bender/current/bin/rake bender RAILS_ENV=production >> /app/bender/current/log/rake_bender.log &
      ;;
    stop)
      kill `cat /app/bender/current/tmp/pids/metrics_gen.pid`
      while ps -p ` cat /app/bender/current/tmp/pids/metrics_gen.pid` > /dev/null; do sleep 1; done
      rm -rf /app/bender/current/tmp/pids/metrics_gen.pid
      echo 'End pid!'
      ;;
    *)
      echo "usage: bender_worker {start|stop}" ;;
esac
exit 0