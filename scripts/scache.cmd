/* OS/2 REXX */
/* Hartmut Krafft <hartmut@mail.ru> 2001 */
/* ansi_init patch for eCS by Dag Bjerkeli" <dagbj@online.no> */

call MyInit
/*----------------------*/

configfile='scache.cnf' /* Change this if necessary ! */

/*----------------------*/

if arg() <> 1 then call err 'Please enter 1 argument.', 1, 'UX'

todo=translate(arg(1))

call read_conf configfile

select
   when todo='START' then
   do
      call scache_start
   end
   when todo='STOP' then
   do
      call scache_stop shutdown_flag
   end
   when todo='KILL' then
   do
      call scache_stop Immediate_shutdown_flag
   end
   when todo='GC' then
   do
      call scache_gc
   end
   otherwise
   do
      call err 'Wrong argument.', 1, 'UX'
   end
end

exit

jscache: procedure
   /* Parameters: 1st string: Args to 'START' */
   /*             2nd string: Args to scache  */
   'start "SmartCache" '||arg(1)||' java -ms1m scache '||arg(2)
return(rc)

scache_start:
   call SysFileTree alive_flag, 'file', 'FO'
   if file.0=0 then
   do
     ret=jscache('/c /min',)
     if ret > 0 then call err 'Scache rc= '||ret, -1, 'XU'
     else
     do
        say bright||yellowfg||'Starting Scache:'||reset
        call charout ,bright||magentafg||'Waiting'
        do until file.0=1
           call SysFileTree alive_flag, 'file', 'FO'
           call SysSleep 2
           call charout , '.'
        end
        say reset
        say bright||yellowfg||'Scache started.'||reset
     end
   end
   else
   do
      call err 'Scache is already running, or a stale '||alive_flag||' has been left.', 2, 'X'
   end
return

scache_stop:
   stopfile=arg(1)
   call SysFileTree alive_flag, 'file', 'FO'
   if file.0=1 then
   do
      call lineout stopfile, 'Stop!'
      call stream stopfile, 'C', 'CLOSE'
      if stopfile=shutdown_flag then waitstr='(up to 3 minutes)'||crlf
      else waitstr=''
      say bright||yellowfg||'Scache Stop Flag set, wait '||waitstr||, 
      'until Scache has shut down.'||reset
      call charout ,bright||magentafg||'Waiting'
      do while file.0 <> 0
         call SysFileTree alive_flag, 'file', 'FO'
         call SysSleep 2
         call charout , '.'
      end
      say reset
      say bright||yellowfg||'Scache stopped.'||reset
   end
   else
   do
      call err 'Scache is not running.', 3, 'X'
   end
return

scache_gc:
   call SysFileTree alive_flag, 'file', 'FO'
   if file.0=1 then
   do
     ret=jscache('/C',' -gc')
     if ret > 0 then call err 'Scache rc= '||ret, -1, 'XU'
     else say bright||yellowfg||'Garbage collection started.'||reset
   end
   else
   do
      call err 'Scache is not running.', 4, 'X'
   end
return

read_conf:
   infile=arg(1)
   k=0
   do until k>=3
      if lines(infile) then theline=linein(infile)
      else call err 'config data couldn''t be read.', 5, 'X'
      parse value theline with token flag
      token=translate(token)
      if token='ALIVE_FLAG' then
      do
         alive_flag=flag
         k=k+1
      end
      if token='SHUTDOWN_FLAG' then 
      do
          shutdown_flag=flag
          k=k+1
      end
      if token='IMMEDIATE_SHUTDOWN_FLAG' then 
      do
         Immediate_shutdown_flag=flag
         k=k+1
      end
   end
   call stream infile, 'C', 'CLOSE'
return

/*----------------------*/
MyInit:
   beep='07'x;
   crlf='0d0a'x;
   call no_ansi
   call ansi_init /* ANSI must be ON */
   '@ECHO OFF'
   loaded=rxfuncquery('sysloadfuncs')
   if loaded=1 then do
     call RxFuncAdd 'SysLoadFuncs', 'RexxUtil', 'SysLoadFuncs'
     signal on syntax name NoREXX
     call SysLoadFuncs
   end
   signal on syntax name Syntax
  /*  say(ert),12 /*syntax error test*/ */
return

Syntax:
  errstr=rc 'in line' sigl':' errortext(rc)||crlf||,
  cyanfg||'Line '||sigl':'||sourceline(sigl)||crlf||,
  greenfg||'Sorry, exiting...'
  call err errstr, 1, 'X'
return

NoRexx:
   errstr='Unable to load the REXXUtil functions.  Maybe the REXXUTIL.DLL file'||crlf||,
   'is not on the LIBPATH or REXX support is not installed at all'||crlf||,
   'on this system. If you''re running Warp4 aka Merlin, there''s something'||crlf||,
   'wrong; on Warp3 you may have unselected REXX during install...'
   call err errstr, 2, 'X'
return

/* Error Messages                                */
/* Arguments: 1. Error Message String.           */
/*            2. Return Code (may be nil)        */
/*            3. Arguments:                      */
/*               a string containing X, U, or nil*/
/*               X: exit after error message     */
/*               U: display usage                */
/*               (may be compined)               */
err:
   msg=arg(1); errno=arg(2); theargs=translate(arg(3));
   say beep||bright||redfg||'Error: '||msg||reset
   if pos('U',theargs)>0 then call usage
   if pos('X',theargs)>0 then exit(errno)
return


/* Ansi codes initialization */
ansi_init:
    '@ANSI|RXQUEUE'
    ansiret1=linein('QUEUE:')
    if ansiret1 = '' then
    do
       errstr='ANSI support error.'
       call err errstr, 3, 'X'
    end
    state=word(ansiret1,words(ansiret1))
    if state <> ' on.' then
    do
       errstr='ANSI support error - ANSI returns:'||crlf||ansiret1
       call err errstr, 3, 'X'
    end
    esc='1b'x
     normal=esc||'[0m'
     bright=esc||'[1m'
    inverse=esc||'[7m'
  invisible=esc||'[8m'
  
    blackfg=esc||'[30m'
      redfg=esc||'[31m'
    greenfg=esc||'[32m'
   yellowfg=esc||'[33m'
     bluefg=esc||'[34m'
  magentafg=esc||'[35m'
     cyanfg=esc||'[36m'
    whitefg=esc||'[37m'
    
    blackbg=esc||'[40m'
      redbg=esc||'[41m'
    greenbg=esc||'[42m'
   yellowbg=esc||'[43m'
     bluebg=esc||'[44m'
  magentabg=esc||'[45m'
     cyanbg=esc||'[46m'
    whitebg=esc||'[47m'

   reset=normal||whitefg||blackbg
 
   /* use with charout */    
      curup=esc||'[1A'
    curdown=esc||'[1B'
   curright=esc||'[1C'
    curleft=esc||'[1D'
    cursave=esc||'[s'
 currestore=esc||'[u'
    nobreak=esc||'[=07I' /* ?? */
return

no_ansi:
     normal=''
     bright=''
    inverse=''
  invisible=''
  
    blackfg=''
      redfg=''
    greenfg=''
   yellowfg=''
     bluefg=''
  magentafg=''
     cyanfg=''
    whitefg=''
    
    blackbg=''
      redbg=''
    greenbg=''
   yellowbg=''
     bluebg=''
  magentabg=''
     cyanbg=''
    whitebg=''

   reset='' 
   /* use with charout */    
      curup=''
    curdown=''
   curright=''
    curleft=''
    cursave=''
 currestore=''
    nobreak=''

return

/*-------------------*/

usage:
   parse source src
   parse value src with os int cm
   say bright||cyanfg||'Usage: '||cm||' [start|gc|stop|kill]'||reset
   say bright||yellowfg||'start: Start Scache.'||reset
   say bright||yellowfg||'   gc: Run Garbage Collection.'||reset
   say bright||yellowfg||' stop: Stop Scache.'||reset
   say bright||yellowfg||' kill: Stop Scache Now.'||reset
return

/*----FINISH-------*/
