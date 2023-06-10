set input1 "#SD#04012011;135515;5544.6025;N;03739.6834;E;35;215;110;7\r\n"
set input2 "#M#���� ���������\r\n"

proc parse {packet} {
    # ������� ������������� ����������� ������

    set packet [string trim $packet]
    set parts [split $packet "#"]
    set type [lindex $parts 1]
    set data [lindex $parts 2]

    switch -exact -- $type {
        "SD" {
            #SD#date;time;lat1;lat2;lon1;lon2;speed;course;height;sats\r\n
            set fields [split $data ";"]

            # �������� ������
            set i 0;
            foreach el $fields {
                # �������� ������� ����������
                if {[string length $el] > 0} {
                    # puts "������� ����� $i - $el"
                    # �������� ������������ ����������
                    if {($i != 3) && ($i != 5) && [string is double $el]} {
                        incr i
                    } elseif {($i == 3) && ($el == "N") || ($el == "S")} {
                        incr i
                    } elseif {($i == 5) && ($el == "E") || ($el == "W")} {
                        incr i
                    } else {
                        puts "����� $type ����� �������� ������"
                        return 0
                    }
                } else {
                    puts "����� $type ����� �������� ������"
                    return 0
                }
            }
            if {$i == 10} {
                set date [lindex $fields 0]
                set time [lindex $fields 1]
                set lat1 [lindex $fields 2]
                set lat2 [lindex $fields 3]
                set lon1 [lindex $fields 4]
                set lon2 [lindex $fields 5]
                set speed [lindex $fields 6]
                set course [lindex $fields 7]
                set height [lindex $fields 8]
                set sats [lindex $fields 9]
            } else {
                puts "����� $type ����� �������� ������"
                return 0
            }

            # �������������� ������ � ���� ������� �����
            set latitudeList [split $lat1 "."]
            set degrees [string range [lindex $latitudeList 0] 0 1]
            set minutes [expr [string range [lindex $latitudeList 0] 2 3] + [lindex $latitudeList 1]*0.0001]
            set latitude [expr {($degrees + ($minutes / 60)) * ($lat2 == "N" ? 1 : -1) }]

            # �������������� ������� � ���� ������� �����
            set longitudeList [split $lon1 "."]
            set degrees [string trimleft [string range [lindex $longitudeList 0] 0 2] 0]
            set minutes [expr [string range [lindex $longitudeList 0] 3 4] + [lindex $longitudeList 1]*0.0001]
            set longitude [expr {($degrees + ($minutes / 60)) * ($lon2 == "E" ? 1 : -1) }]

            # �����
            puts "��� ������: $type"
            puts "����: $date"
            puts "�����: $time"
            puts "������: $latitude �"
            puts "�������: $longitude �"
            puts "��������: $speed ��/�"
            puts "����: $course �"
            puts "������: $height �"
            puts "���������� ���������: $sats"
            puts ""
            return 1
        }
        "M" {
            set message $data
            # �����
            puts "��� ������: $type"
            puts "���������: $message"
            return 1
        }
        default {
            puts "����� ����� ����������� ������"
            return 0
        }
    }
}

parse $input1
parse $input2
