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
    my @sorted =  %mapping.keys.reverse.sort.sort: {%mapping{$^b} <=> %mapping{$^a} };
    return join "", @sorted[0..4];
}

sub is-valid-room((Str $room, Str $id, Str $chksum)) {
    return get-checksum($room) === $chksum;
}


my $data = slurp "/data/day4.txt";
my @rooms = split("\n", $data);
my @room-infos = @rooms.map({get-room-info $_ }).grep({is-valid-room $_});
my @sum = @room-infos.map({$_[1]}).sum;
say @sum;
