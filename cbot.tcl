#!/usr/bin/tclsh

package require http
source config.tcl

set sockChan [socket $::BotServer $::BotPort]

fconfigure $sockChan -translation crlf -buffering line

puts $sockChan "NICK $::BotNick"
puts $sockChan "USER $::BotIdent * * :$::BotRealname"

while {![eof $sockChan]} {
	set line [gets $sockChan]
	if {$line != ""} {
	 set lline [split $line]
	 if {[lindex $lline 0] == "PING"} {
	   puts $sockChan "PONG [lindex $lline 1]"
	 }
	 if {[lindex $lline 0] == "433"} {
	   puts $sockChan "NICK $::BotAlt"
   }
   if {[lindex $lline 0] == "001"} {
     puts $sockChan "JOIN $::Home"
   }
  }
}
