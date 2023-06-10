set input 0x5FABFF01

# ������ �������������� �������� - ������ ���� ��������� ��������
set param1 [expr {($input >> 8) & 0xFF}]

# ������ �������������� �������� - �������� 7-�� ���� ��������� ��������
set param2 [expr {!($input & 0x80)}]

# ������� �������������� �������� - ���������� ����������� ����� 17-20
set bit17 [expr {($input >> 17) & 0x1}]
set bit18 [expr {($input >> 18) & 0x1}]
set bit19 [expr {($input >> 19) & 0x1}]
set bit20 [expr {($input >> 20) & 0x1}]
set param3 [expr {($bit17 << 3) | ($bit18 << 2) | ($bit19 << 1) | $bit20}]

# �����
puts "������ �������������� ��������: $param1 ([format "%b" $param1])"
puts "������ �������������� ��������: $param2 ([format "%b" $param2])"
puts "������ �������������� ��������: $param3 ([format "%b" $param3])"
