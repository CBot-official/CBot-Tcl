proc ircsplit str {

	set res {}	if {[string index $str 0] eq ":"} {

		lappend res [string range $str 1 [set first [string first " " $str]]-1]

		set str [string range $str 1+$first end]

	} else {

		lappend res {}

	}

	if {[set pos [string first " :" $str]] != -1} {

		lappend res {*}[split [string range $str 0 ${pos}-1]]

		lappend res [string range $str 2+$pos end]

	} else {

		lappend res {*}[split $str]

	}

	return $res

}

package require http

package require

if {[string index $::BPORT 0] == "+"} {

 set sockChan [tls::socket $::BSERVER $::BPORT]

} else {

 set sockChan [socket $::BSERVER $::BPORT]

}

fconfigure $sockChan -translation crlf -buffering line

puts $sockChan "NICK $::BNICK"

puts $sockChan "USER $::BIDENT * * :$::BNAME"

while {![eof $sockChan]} {

	set line [gets $sockChan]

	puts ">> $line"

	set lline [ircsplit $line]

	set text [lindex $lline end]

	set nick [lindex [split $lline !] 0]

	set host [lindex [split $lline !] 1]

	set type [lindex $lline 1]

	set chan [lindex $lline 2]

	set text [lindex $lline 2]

	switch -nocase -- [lindex $lline 1] {

		PING {puts $sockChan "PONG :[lindex $lline 2]"}

		001 {puts $sockChan "JOIN $::home"}

		433 {puts $sockChan "NICK $::alternick"}

			}

		}
