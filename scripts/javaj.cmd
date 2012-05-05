/* 
  JavaJ.cmd

    simple rexx script to run jar packaged java applications
    for Java 1.1.8  or Java 1.3 (a bit of a quick hack though),
    it requires 
       unzip, grep, Java and Rexx 
    ;) to be installed

  This program is freeware. The author accepts no liability for
  any damage this program might cause. Use at your own risk!

  (C) Copyright  Bastian Maerkisch (bmaerkisch@web.de)

  revision history:
    5. 6.2001  1.0 initial release
   28. 9.2001  1.1 added support for Class-Path in Manifest
   18.10.2001  1.2 support for java options, new command line syntax
*/
'@echo off'
version = '1.2'

/*  initialize some variables 
*/
jar  = ''
mode = ''
mainclass= ''
mainclass_opt = ''
java_opt = ''
pgm_opt  = ''
force13  = 0
force118 = 0

/*  parse command line, 
    (let's call it simplistic ;)
    everything before the -jar options is condsidered a java option,
*/
parse arg opt

/* hack to allow invocation via WPS (uuuh, ugly!)
*/
if words(opt) = 1 then do
  jar = strip( opt )
  if left(jar,1) = '-' then
    jar = ''
  signal done_parsing
end

have_jar = 0
do while opt \= ''
  parse var opt this_arg opt
  select
    when translate(this_arg) = '-PM' then do
      if \ have_jar then
        mode = 'PM'
    end
    when translate(this_arg) = '-W' then do
      if \ have_jar then
        mode = 'PM'
    end
    when translate(this_arg) = '-JAR' then do
      parse var opt jar opt
      have_jar = 1
    end
    when translate(this_arg) = '-MAINCLASS' then do
      parse var opt mainclass_opt opt
    end
    otherwise do
      if have_jar then
        pgm_opt  = pgm_opt this_arg
      else
        java_opt = java_opt this_arg
    end
  end
end
java_opt = strip( java_opt )
pgm_opt  = strip( pgm_opt )
done_parsing:

/* incomplete command line: give help 
*/
if jar = '' then do
  say "JavaJ" version "by Bastian Maerkisch"
  say ""
  say "This program is freeware. The author accepts no liability for"
  say "any damage this program might cause. Use at your own risk!"
  say ""
  say "Usage:"
  say "  javaj <jarfile>"
  say "  javaj [-pm] [java opts] -jar <jarfile> [-mainclass <main>] [program opts]"
  return -1
end


/* get java version
*/
call clear_queue
'java -version 2>&1 | rxqueue'
parse pull . '"' javaver '"'
if javaver \= '1.1.8' then do
  if javaver \= '1.3.0' then do
    say "Warning: This script was written for Java 1.1.8"
    say "         You have Java version" javaver
    return -1
  end
  else do
    say "Hint: This script is no longer needed for Java 1.3"
    say "      Simply use Java's '-jar' option."
  end
end
call clear_queue


/* a bit of a hack for pre 1.3.0 versions....
*/
if javaver = '1.1.8' then do

  /* retrieve main class from jar file
  */
  call clear_queue
  'unzip -p' jar 'META-INF/MANIFEST.MF | rxqueue'
  mainclass = ''
  add_classes = ''
  do while queued() > 0
    parse pull line
    if mainclass == '' then 
      parse var line "Main-Class:" mainclass
    if add_classes == '' then 
      parse var line "Class-Path:" add_classes
  end
  call clear_queue
  if mainclass = '' then do
    say 'Warning: Could not retrieve main class from jar' jar
    /*  return -1  */
  end

  if mainclass_opt \= '' then do
    if mainclass \= '' then
      say 'Warning: Using Main-Class' mainclass_opt 'instead of' mainclass
    mainclass = mainclass_opt
  end
  mainclass = strip( mainclass )

  /* start building classpath
  */
  classpath = ''

  /* locate extra jars
  */
  if add_classes \= '' then do
    say 'Attention: Found extra classpath in manifest:'
    say '          ' || add_classes

    do while add_classes \= ''
      parse var add_classes class ',' add_classes
      classpath = classpath || strip(class) || ';'
    end
  end

  /* get classpath from environment
  */
  classpath = classpath || getenv( "CLASSPATH" )

  /* automagically append standard classpath... 
     dont' know if this is done correctly
  */

  /* load rexxutil */
  call RxFuncAdd "SysLoadFuncs", "RexxUtil", "SysLoadFuncs"
  call SysLoadFuncs

  /* locate java lib */
  classes = SysSearchPath( "LIB", "classes.zip" )
  java = left( classes, lastpos( "\", classes ) )
  if java \= '' then do /* found it ! */
    /* list classes */
    ret = SysFileTree( java || "*.zip", "file.", "FO" )
    if ret = 0 then 
      do i = 1 to file.0
        classpath = classpath || ";" || file.i
      end

    /* list classes */
    ret = SysFileTree( java || "*.jar", "file.", "FO" )
    if ret = 0 then 
      do i = 1 to file.0
        classpath = classpath || ";" || file.i
      end
  end

/*
  /* hhm, probably there's jikes installed...
  */
  jikespath = getenv( "JIKESPATH" )
*/
  jikespath = ''

  /* create new classpath
  */
  classpath = strip( jar || ";" || classpath || ";" || jikespath,"T",";" )

  /* build command line 
  */
/*
  todo: better do some checking of command length here
  cmd = strip( java_opt "-classpath" classpath mainclass pgm_opt)
*/
  cmd = strip( java_opt mainclass pgm_opt )
  call setenv "CLASSPATH", classpath 

  /* finally call java
  */
  if mode = 'PM' then
    "javapm" cmd
  else
    "java" cmd
  return rc

end
else do /* javaver = 1.3.0 */

  if mode = 'PM' then 
    "javaw" java_opt "-jar" jar pgm_opt
  else
    "java" java_opt "-jar" jar pgm_opt
  return rc

end
exit

/* ------------------------------------------------------- */

setenv:
return value( arg(1), arg(2), "OS2ENVIRONMENT" )

getenv:
return value( arg(1), , "OS2ENVIRONMENT" )

exists: procedure
  ret = (stream( arg(1), "c", "query exists" ) \= "")
  call stream arg(1), "c", "close"
return ret

clear_queue:
  do while queued() > 0
    pull
  end
return
