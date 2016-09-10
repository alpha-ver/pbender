#!/bin/bash
export PATH=$PATH:/usr/local/lib/ruby/2.3.0/rubygems

case $1 in
   start)
      cd /app/bender/current;
      #echo $$ > /app/bender/current/tmp/pids/metrics_gen_master.pid
      unbuffer /app/bender/current/bin/rake bender RAILS_ENV=production >> /app/bender/current/log/rake_bender.log &
      ;;
    stop)
      
      kill -0 `cat /app/bender/current/tmp/pids/metrics_gen.ppid`
      wait `cat /app/bender/current/tmp/pids/metrics_gen.ppid`
      rm -rf /app/bender/current/tmp/pids/metrics_gen.ppid
      echo 'ppid !'

      kill -0 `cat /app/bender/current/tmp/pids/metrics_gen.pid`
      wait cat /app/bender/current/tmp/pids/metrics_gen.pid
      rm -rf /app/bender/current/tmp/pids/metrics_gen.pid
      echo 'pid!'

      ;;
    *)
      echo "usage: bender_worker {start|stop}" ;;
esac
exit 0