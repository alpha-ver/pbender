#!/bin/bash
export PATH=$PATH:/usr/local/lib/ruby/2.3.0/rubygems

case $1 in
   start)
      cd /app/bender/current;
      #echo $$ > /app/bender/current/tmp/pids/metrics_gen_master.pid
      /app/bender/current/bin/rake bender RAILS_ENV=production >> /app/bender/current/log/rake_bender.log &
      ;;
    stop)
      kill `cat /app/bender/current/tmp/pids/metrics_gen.ppid`
      kill `cat /app/bender/current/tmp/pids/metrics_gen.pid`
      #kill `cat /app/bender/current/tmp/pids/metrics_gen_master.pid`

      rm -rf /app/bender/current/tmp/pids/metrics_gen.ppid
      rm -rf /app/bender/current/tmp/pids/metrics_gen.pid
      #rm -rf /app/bender/current/tmp/pids/metrics_gen_master.pid

      ;;
    *)
      echo "usage: bender_worker {start|stop}" ;;
esac
exit 0