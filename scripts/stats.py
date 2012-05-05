#! /usr/bin/env python
# Smart Cache stat.log analyzer
# GPL v2 Radim Kolar 2003, part of Smart Cache distribution
# Changelog:
#  0.3   increased max. difference between 2 log lines to +10
#        added -o online mode switch
import sys
import re
import rfc822
import time


if len(sys.argv)==1:
 print "Smart Cache stat.log analyzer 0.3, GPL Open Source by Radim Kolar."
 print  "Run:",sys.argv[0],"[-o] <stat.log> ..."
 print  "  -o   do not include data from offline browsing"
 exit

onlineonly=0

for file in sys.argv[1:]:
  if file=="-o": onlineonly=1;continue
  f=open(file,'rt')
  sys.stdout.write("Analyzing file "+file)
  sys.stdout.flush()
  firstdate=None
  prevdate=(0,0,0,0,0,0,0,0,0)
  prevtime=0
  prevday=0
  records=0
  starts=0
  lines=0
  days=0
  bytesin=0L
  bytesout=0L
  dirsaved=0L
  dirsfreed=0L
  dirspurged=0L
  hourstatsin=24*[0L]
  hourstatsout=24*[0L]
  daystatsin=7*[0L]
  daystatsout=7*[0L]
  FILERX=re.compile("^(.+) - (.+)$")
  BYTESRX=re.compile("^.+ - \\d+% BYTES: (\\d+) B in, (\\d+) B out")
  DIRSRX=re.compile("^.+ - DIRS: (\\d+) saved, (\\d+) freed, (\\d+) purged")
  for line in f.readlines():
     lines+=1
     match=FILERX.match(line)
     if match is None: continue
     date=match.group(1)
     text=match.group(2)
     date=rfc822.parsedate(date)
     if date is None: continue
     date=time.localtime(time.mktime(date))
     if firstdate is None: firstdate=date
     if time.mktime(date)>time.mktime(prevdate)+10: 
         records+=1
	 prevdate=date
	 ntime=time.mktime(date)
	 if ntime-prevtime > 3*60+10:
	    starts+=1
	 prevtime=ntime
     if date[2]!=prevday:
     	days+=1
	prevday=date[2]
     match=BYTESRX.match(line)
     if match!=None:
        if onlineonly==1 and int(match.group(1))==0: continue
        bytesin+=int(match.group(1))
	bytesout+=int(match.group(2))
	hourstatsin[date[3]]+=int(match.group(1))
	hourstatsout[date[3]]+=int(match.group(2))
	daystatsin[date[6]]+=int(match.group(1))
	daystatsout[date[6]]+=int(match.group(2))

     match=DIRSRX.match(line)
     if match!=None:
	  dirsaved  += int(match.group(1))
	  dirsfreed += int(match.group(2))
	  dirspurged+= int(match.group(3))
        
  f.close()
  if days>0:
      print
      print days,"days,",lines,"lines,",records,"records,",starts,"starts."
      print "Total traffic:",round(bytesin/1024.0/1024.0,3),"MB in,",round(bytesout/1024.0/1024.0,3),"MB out."
      print "Average daily traffic:",round(bytesin/days/1024.0/1024.0,3),"MB in,",round(bytesout/days/1024.0/1024.0,3),"MB out; total B hit ratio",round(100.0*(bytesout-bytesin)/bytesout,1),"%"
      print "Average dir stat:",dirsaved/records,"saved,",dirsfreed/records,"freed,",dirspurged/records,"purged."

      unit=max(daystatsout)/65
      print
      print "Cache Daily stats, #=",unit/1024,'kB.'
      for i in range(0,7):
          if daystatsout[i]==0: 
	     daystatsout[i]=1
	     daystatsin[i]=1
          print ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"][i],"SUMMARY:",round(daystatsin[i]/1024.0/1024.0,3),"MB in,",round(daystatsout[i]/1024.0/1024.0,3),"MB out; hit ratio",round(100.0*(daystatsout[i]-daystatsin[i])/daystatsout[i],1),"%"
          print ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"][i],daystatsin[i]/unit*"#"
          print ["Mon","Tue","Wed","Thu","Fri","Sat","Sun"][i],daystatsout[i]/unit*"#"
	  
      unit=max(hourstatsout)/65
      print
      print "Cache Hour stats, #=",unit/1024,'kB.'
      for i in range(0,24):
          if hourstatsout[i]==0: 
	     hourstatsout[i]=1
	     hourstatsin[i]=1
          print i,"SUMMARY:",round(hourstatsin[i]/1024.0/1024.0,3),"MB in,",round(hourstatsout[i]/1024.0/1024.0,3),"MB out; hit ratio",round(100.0*(hourstatsout[i]-hourstatsin[i])/hourstatsout[i],1),"%"
          print i,hourstatsin[i]/unit*"#"
          print i,hourstatsout[i]/unit*"#"
