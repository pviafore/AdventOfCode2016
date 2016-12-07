sub get-room-info (Str $room){
    if $room ~~ m/([<:Ll>|\-]*)(\d+)\[(<:Ll>*)\]/ {
        return (~$0, ~$1, ~$2)
    }
    die "INVALID ROOM ", $room;
}

sub get-checksum (Str $room) {
    my %mapping = ();
    my @chars = split "", $room;
    for @chars -> $char {
        if $char === "-" || $char === "" {

        }
        elsif %mapping{$char}:exists {
            %mapping{$char} =  %mapping{$char} + 1;
        }
        else {
            %mapping{$char} = 1
        }
    }
    my @sorted =  %mapping.keys.sort.sort: {%mapping{$^b} <=> %mapping{$^a} };
    return join "", @sorted[0..4];
}

sub is-valid-room((Str $room, Str $id, Str $chksum)) {
    return get-checksum($room) === $chksum;
}

sub shift($char, $id) {
    if ($char === "-" || $char === "") 
    {
        return $char;
    }
    my $int-value = ord($char);
    my $mod26 = ($int-value - 97 + $id) %26;

    return chr($mod26 + 97);
}

sub decrypt((Str $room, Str $id, Str $chksum)) {
    my @chars = split "", $room;
    my @decoded-room = @chars.map({ shift $_, $id});
    my $final-room = join "", @decoded-room;
    return ($final-room, $id, $chksum)
}


my $data = slurp "/data/day4.txt";
my @rooms = split("\n", $data);
my @room-infos = @rooms.map({get-room-info $_ })
                       .grep({is-valid-room $_})
                       .map({decrypt $_})
                       .grep({$_ ~~ m/"north"/});
say @room-infos;
