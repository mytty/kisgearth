#!/usr/bin/perl -w
################################################################################
# KisGearth - a Kismet xml log to GoogleEarth kml converter
################################################################################
# 0.01f - 2008.08.28 - by Richard Sammet (e-axe) richard.sammet@gmail.com
################################################################################
# Information and latest version available at:
# http://mytty.org/kisgearth/
################################################################################
# This file is part of KisGearth.
#
# KisGearth is free software; you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 2 of the License, or
# (at your option) any later version.
#
# KisGearth is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with KisGearth; if not, write to the Free Software Foundation,
# Inc., 51 Franklin St, Fifth Floor, Boston, MA  02110-1301  USA
#
# http://www.gnu.org/licenses/gpl.txt
################################################################################

use XML::Simple;
use Class::Struct;

# activating autoflush on stdout, stderr gets flushed automatic
$| = 1;

# constants
my $CODENAME    = 'KisGearth';
my $VERSION     = '0.01f';
my $AUTHOR      = 'Richard Sammet (e-axe)';
my $CONTACT     = 'richard.sammet@gmail.com';
my $WEBSITE     = 'http://mytty.org/kisgearth/';

# color constants
# used for network drawing
my $AliceBlue                 = 'F0F8FF';
my $AntiqueWhite              = 'FAEBD7';
my $Aquamarine1               = '7FFFD4';
my $Azure1                    = 'F0FFFF';
my $Beige                     = 'F5F5DC';
my $Bisque1                   = 'FFE4C4';
my $Black                     = '000000';
my $BlanchedAlmond            = 'FFEBCD';
my $Blue1                     = 'FF0000';
my $BlueViolet                = '8A2BE2';
my $Brown1                    = 'A52A2A';
my $Burlywood1                = 'DEB887';
my $Cadetblue1                = '5F9EA0';
my $Chartreuse1               = '7FFF00';
my $Chocolate1                = 'D2691E';
my $Coral1                    = 'FF7F50';
my $CornFlowerBlue            = '6495ED';
my $Cornsilk1                 = 'FFF8DC';
my $Cyan1                     = '00FFFF';
my $DarkGoldenrod1            = 'B8860B';
my $DarkGreen                 = '006400';
my $DarkKhaki                 = 'BDB768';
my $DarkOliveGreen1           = '556B2F';
my $DarkOrange1               = 'FF8C00';
my $DarkOrchid1               = '9932CC';
my $DarkSalmon                = 'E9967A';
my $DarkSeaGreen1             = '8FBC8F';
my $DarkSlateBlue             = '483D8B';
my $DarkSlateGray1            = '2F4F4F';
my $DarkTurquoise             = '00CED1';
my $DarkViolet                = '9400D3';
my $DeepPink1                 = 'FF1493';
my $DeepSkyBlue1              = '00BFFF';
my $DimGray                   = '696969';
my $DodgerBlue1               = '1E90FF';
my $Firebrick1                = 'B22222';
my $FloralWhite               = 'FFFAF0';
my $ForestGreen               = '228B22';
my $Gainsboro                 = 'DCDCDC';
my $GhostWhite                = 'F8F8FF';
my $Gold1                     = 'FFD700';
my $Goldenrod1                = 'DAA520';
my $Gray00                    = '7E7E7E';
my $Gray47                    = '787878';
my $Gray96                    = 'F5F5F5';
my $Green1                    = '00FF00';
my $GreenYellow               = 'ADFF2F';
my $Honeydew1                 = 'F0FFF0';
my $HotPink1                  = 'FF69B4';
my $IndianRed1                = 'CD5C5C';
my $Ivory1                    = 'FFFFF0';
my $Khaki1                    = 'F0E68C';
my $LavenderBlush1            = 'FFF0F5';
my $LawnGreen                 = '7CFC00';
my $LemonChiffon1             = 'FFFACD';
my $LightBlue1                = 'ADD8E6';
my $LightCoral                = 'F08080';
my $LightCyan1                = 'E0FFFF';
my $Lightgoldenrod1           = 'EEDD82';
my $LightGoldenrodYellow      = 'FAFAD2';
my $LightGray                 = 'D3D3D3';
my $LightPink1                = 'FFB6C1';
my $LightSalmon1              = 'FFA07A';
my $LightSeaGreen             = '20B2AA';
my $LightLightSkyBlue1        = '87CEFA';
my $LightSkyBlue2             = 'B0E2FF';
my $LightSlateBlue            = '8470FF';
my $LightSlateGray            = '778899';
my $LightSteelBlue1           = 'B0C4DE';
my $LightYellow1              = 'FFFFE0';
my $LimeGreen                 = '32CD32';
my $Linen                     = 'FAF0E6';
my $Magenta1                  = 'FF00FF';
my $Maroon1                   = 'B03060';
my $MediumAquamarine          = '66CDAA';
my $MediumBlue                = '0000CD';
my $MediumOrchid1             = 'BA55D3';
my $MediumPurple1             = '9370DB';
my $MediumSeaGreen            = '3CB371';
my $MediumSlateBlue           = '7B68EE';
my $MediumSpringGreen         = '00FA9A';
my $MediumTurquoise           = '48D1CC';
my $MediumvioletRed           = 'C71585';
my $MidnightBlue              = '191970';
my $MintCreme                 = 'F5FFFA';
my $Mistyrose1                = 'FFE4E1';
my $Moccasin                  = 'FFE4B5';
my $NavajoWhite1              = 'FFDEAD';
my $NavyBlue000080            = '000080';
my $Oldlace                   = 'FDF5E6';
my $OliveDrab1                = '6B8E23';
my $Orange1                   = '0090FF';
my $OrangeRed1                = 'FF4500';
my $Orchid1                   = 'DA70D6';
my $PaleGoldenrod             = 'EEE8AA';
my $PaleGreen1                = '98FB98';
my $PaleTurquoise1            = 'AFEEEE';
my $PaleVioletred1            = 'DB7093';
my $PapayaWhip                = 'FFEFD5';
my $Peachpuff1                = 'FFDAB9';
my $Peru                      = 'CD853F';
my $Pink1                     = 'FFC0CB';
my $Plum1                     = 'DDA0DD';
my $PowderBlue                = 'B0E0E6';
my $Purple1                   = 'A020F0';
my $Red1                      = '0000FF';
my $RoseGray                  = '706666';
my $Roseybrown1               = 'FFC1C1';
my $Royalblue1                = '4169E1';
my $SaddleBrown               = '8B4513';
my $Salmon1                   = 'FA8072';
my $SandyBrown                = 'F4A460';
my $Seagreen1                 = '2E8B57';
my $Seashell1                 = 'FFF5EE';
my $SergeBlue                 = '0000B4';
my $Sienna1                   = 'A0522D';
my $SkyBlue1                  = '87CEEB';
my $SlateBlue1                = '836FFF';
my $SlateGray1                = '708090';
my $Snow1                     = 'FFFAFA';
my $SpringGreen1              = '00FF7F';
my $SteelBlue1                = '4682B4';
my $Tan1                      = 'D2B48C';
my $Thsitle1                  = 'D8BFD8';
my $Thitle5                   = '8B7B8B';
my $TimGray                   = '615C5C';
my $Tomato1                   = 'FF6347';
my $Turquoise1                = '40E0D0';
my $Violet                    = 'EE82EE';
my $VioletRed1                = 'D02090';
my $Wheat1                    = 'F5DEB3';
my $Yellow1                   = '00FFFF';

my $RED         = $Red1;
my $ORANGE      = $Orange1;
my $YELLOW      = $Yellow1;
my $GREEN       = $Green1;
my $GREY        = $Gray00;

# channel colors
my @CHANCOL = (
      $AliceBlue,
      $RED,
      $ORANGE,
      $YELLOW,
      $GREEN,
      $Aquamarine1,
      $Azure1,
      $Brown1,
      $Burlywood1,
      $Cadetblue1,
      $Chartreuse1,
      $Chocolate1,
      $Coral1,
      $CornFlowerBlue,
      $Cornsilk1,
      $Cyan1,
      $DarkGoldenrod1,
      $DarkGreen,
      $DarkKhaki,
      $DarkOliveGreen1,
      $DarkOrange1,
      $DarkOrchid1,
      $DarkSalmon,
      $DarkSeaGreen1,
      $DarkSlateBlue,
      $DarkSlateGray1,
      $DarkTurquoise,
      $DarkViolet,
      $DeepPink1,
      $DeepSkyBlue1,
      $DimGray,
      $DodgerBlue1,
      $Firebrick1,
      $FloralWhite,
      $ForestGreen,
      $Gainsboro,
      $GhostWhite,
      $Gold1,
      $Goldenrod1,
      $Gray00,
      $Gray47,
      $Gray96,
      $Green1,
      $GreenYellow,
      $Honeydew1,
      $HotPink1,
      $IndianRed1,
      $Ivory1,
      $Khaki1,
      $LavenderBlush1,
      $LawnGreen,
      $LemonChiffon1,
      $LightBlue1,
      $LightCoral,
      $LightCyan1,
      $Lightgoldenrod1,
      $LightGoldenrodYellow,
      $LightGray,
      $LightPink1,
      $LightSalmon1,
      $LightSeaGreen,
      $LightLightSkyBlue1,
      $LightSkyBlue2,
      $LightSlateBlue,
      $LightSlateGray,
      $LightSteelBlue1,
      $LightYellow1,
      $LimeGreen,
      $Linen,
      $Magenta1,
      $Maroon1,
      $MediumAquamarine,
      $MediumBlue,
      $MediumOrchid1,
      $MediumPurple1,
      $MediumSeaGreen,
      $MediumSlateBlue,
      $MediumSpringGreen,
      $MediumTurquoise,
      $MediumvioletRed,
      $MidnightBlue,
      $MintCreme,
      $Mistyrose1,
      $Moccasin,
      $NavajoWhite1,
      $NavyBlue000080,
      $Oldlace,
      $OliveDrab1,
      $Orange1,
      $OrangeRed1,
      $Orchid1,
      $PaleGoldenrod,
      $PaleGreen1,
      $PaleTurquoise1,
      $PaleVioletred1,
      $PapayaWhip,
      $Peachpuff1,
      $Peru,
      $Pink1,
      $Plum1,
      $PowderBlue,
      $Purple1,
      $Red1,
      $RoseGray,
      $Roseybrown1,
      $Royalblue1,
      $SaddleBrown,
      $Salmon1,
      $SandyBrown,
      $Seagreen1,
      $Seashell1,
      $SergeBlue,
      $Sienna1,
      $SkyBlue1,
      $SlateBlue1,
      $SlateGray1,
      $Snow1,
      $SpringGreen1,
      $SteelBlue1,
      $Tan1,
      $Thsitle1,
      $Thitle5,
      $TimGray,
      $Tomato1,
      $Turquoise1,
      $Violet,
      $VioletRed1,
      $Wheat1,
      $Yellow1,
      $AliceBlue,
      $AntiqueWhite,
      $Aquamarine1,
      $Azure1,
      $Beige,
      $Bisque1,
      $Black,
      $BlanchedAlmond,
      $Blue1,
      $BlueViolet,
      $Brown1,
      $Burlywood1,
      $Cadetblue1,
      $Chartreuse1,
      $Chocolate1,
      $Coral1,
      $CornFlowerBlue,
      $Cornsilk1,
      $Cyan1,
      $DarkGoldenrod1,
      $DarkGreen,
      $DarkKhaki,
      $DarkOliveGreen1,
      $DarkOrange1,
      $DarkOrchid1,
      $DarkSalmon,
      $DarkSeaGreen1,
      $DarkSlateBlue,
      $DarkSlateGray1,
      $DarkTurquoise,
      $DarkViolet,
      $DeepPink1,
      $DeepSkyBlue1,
      $DimGray,
      $DodgerBlue1,
      $Firebrick1,
      $FloralWhite,
      $ForestGreen,
      $Gainsboro,
      $GhostWhite,
      $Gold1,
      $Goldenrod1,
      $Gray00,
      $Gray47,
      $Gray96,
      $Green1,
      $GreenYellow,
      $Honeydew1,
      $HotPink1,
      $IndianRed1,
      $Ivory1,
      $Khaki1,
      $LavenderBlush1,
      $LawnGreen,
      $LemonChiffon1,
      $LightBlue1,
      $LightCoral,
      $LightCyan1,
      $Lightgoldenrod1,
      $LightGoldenrodYellow,
      $LightGray,
      $LightPink1,
      $LightSalmon1,
      $LightSeaGreen,
      $LightLightSkyBlue1,
      $LightSkyBlue2,
      $LightSlateBlue,
      $LightSlateGray,
      $LightSteelBlue1,
      $LightYellow1,
      $LimeGreen,
      $Linen,
      $Magenta1,
      $Maroon1,
      $MediumAquamarine,
      $MediumBlue,
      $MediumOrchid1,
      $MediumPurple1,
      $MediumSeaGreen,
      $MediumSlateBlue,
      $MediumSpringGreen,
      $MediumTurquoise,
      $MediumAquamarine,
      $MediumvioletRed,
      $MidnightBlue,
      $MintCreme,
      $RED,
      $ORANGE,
      $YELLOW,
      $GREEN,
      $Aquamarine1
);

# crypt state colors
my @CRYPTCOL = (
  $GREEN,       # wpa2 -> AES-CCM
  $YELLOW,      # wpa  -> TKIP
  $ORANGE,      # wep  -> WEP
  $RED          # none -> None
);

# vaiable constants
my $MSGLVL        = 1;      # global msg level
my $ERROR         = 0;      # level for error msgs
my $DEBUG         = 3;      # level for debug msgs
my $VERBOSE       = 2;      # level for verbose msgs
my $STANDARD      = 1;      # level for standard msgs

# commandline opts variable constants
my $QUIET         = 0;      # 0/1 quiet mode
my $OPACITY       = 127;    # transparency
my $ORDER         = 0;      # network order type
my $NCOLORS       = 0;      # network coloring type
my $INFOS         = "all";  # export infos
my $IPSEEN        = 0;      # ip-seen filter
my $IIPSEEN       = 0;      # inverted ip-seen filter
my $HAVECLIENTS   = 0;      # have-clients filter
my $IHAVECLIENTS  = 0;      # inverted have-clients filter
my $OUTFTYPE      = "";     # output filetype
my $OUTFNAME      = "";     # outpur filename
my $SSIDFILTER    = "";     # ssid filter list
my $ISSIDFILTER   = "";     # inverted ssid filter list
my $BSSIDFILTER   = "";     # bssid filter list
my $IBSSIDFILTER  = "";     # inverted bssid filter list
my $CHANFILTER    = "";     # channel filter list
my $ICHANFILTER   = "";     # inverted channel filter list
my $CARRFILTER    = "";     # carrier filter list
my $ICARRFILTER   = "";     # inverted carrier filter list
my $TYPEFILTER    = "";     # type filter list
my $ITYPEFILTER   = "";     # inverted type filter list
#my $PCKTFILTER    = "";     # packet filter list
#my $IPCKTFILTER   = "";     # inverted packet filter list
my $CALCRANGE     = 0;      # calculate network range
my $USESIGNAL     = 0;      # use the signal strength for position calculation
my $DRAWCENTER    = 1;      # draw center of network
my $CENTERSIZE    = 1;      # size for network center
my $FROM          = "";     # started
my $TO            = "";     # ended

# global variables
my @networks        = ();
my $net_count       = 0;
my $gps_cnt         = 0;
my $kismet_xml_file = '';
my $kismet_gps_file = '';

# these are our structures ;)
struct IPaddress => {
  iprange =>  '$',
  iptype  =>  '$',
};

struct Packets => {
  pcrypt  =>  '$',
  pLLC    =>  '$',
  pdupeiv =>  '$',
  pweak   =>  '$',
  pdata   =>  '$',
  ptotal  =>  '$',
  pivdupe =>  '$',
};

struct Gpsinfo => {
  gminlon =>  '$',
  gmaxspd =>  '$',
  gminlat =>  '$',
  gminspd =>  '$',
  gminalt =>  '$',
  gunit   =>  '$',
  gmaxlat =>  '$',
  gmaxlon =>  '$',
  gmaxalt =>  '$',
};

struct Network => {
  nnumber      =>  '$',
  nssid        =>  '$',
  nbssid       =>  '$',
  ninfo        =>  '$',
  nchannel     =>  '$',
  nwep         =>  '$',
  ncarrier     =>  '$',
  nencoding    =>  '$',
  ncloaked     =>  '$',
  ndatasize    =>  '$',
  nmaxseenrate =>  '$',
  nlasttime    =>  '$',
  nfirsttime   =>  '$',
  ntype        =>  '$',
  nmaxrate     =>  '$',
  nencryption  =>  '@',
  nwclient     =>  '$',
  nipaddress   =>  'IPaddress',
  npackets     =>  'Packets',
  ngpsinfo     =>  'Gpsinfo',
};

struct GPSpoint => {
  bssid        =>  '$',
  timesec      =>  '$',
  timeusec     =>  '$',
  lat          =>  '$',
  lon          =>  '$',
  alt          =>  '$',
  spd          =>  '$',
  heading      =>  '$',
  fix          =>  '$',
  signal       =>  '$',
  quality      =>  '$',
  noise        =>  '$',
};

# this is currently not in use!
# is there an array or hash outta there ? ;)
sub IsArray {

  if($_[0] =~ m/(ARRAY|HASH)/) {
    return 1;
  }
  return 0;

} # sub IsArray

# the usage ;)
sub usage {

  print STDOUT "$CODENAME $VERSION ( $WEBSITE )\n";
  print STDOUT "USAGE: $0 [Options/Filter/Drawing Options] -- [Kismet.xml]\n";
  print STDOUT "--\n";
  print STDOUT "Options:\n";
  print STDOUT " -h, --help                This help\n";
  print STDOUT " -v, --verbose             Verbose output while running\n";
  print STDOUT " -d, --debug               Debug output while running\n";
  print STDOUT " -q, --quiet               Do not print anything on stdout (should be used as 1st opt)\n";
  print STDOUT " -V, --version             KisGearth Version\n";
  print STDOUT " -G, --gps <file>          Also use the Kismet *.gps log. (recommended)\n";
  print STDOUT "                           more accurate AP positioning.\n";
  print STDOUT " -oN <file>                Output converted data in GEarth kml format to\n";
  print STDOUT "                           the given filename\n";
  #print STDOUT " -oZ <file>                Output converted data in GEarth kmz format to\n";
  #print STDOUT "                           the given filename\n";
  print STDOUT " -O,  --order <order>      Ordering hierarchy [Default: 0]\n";
  print STDOUT "                            0 is ordered based on encryption status\n";
  print STDOUT "                            1 is ordered based on network channel\n";
  print STDOUT "\n";
  print STDOUT "Filters:\n";
  print STDOUT " -fS <SSID list>           Comma-separated list of SSIDs to filter\n";
  print STDOUT " -iS <SSID list>           Comma-separated list of SSIDs to filter (Inverted!)\n";
  print STDOUT " -fB <BSSID list>          Comma-separated list of BSSIDs to filter\n";
  print STDOUT " -iB <BSSID list>          Comma-separated list of BSSIDs to filter (Inverted!)\n";
  print STDOUT " -fC <Channel list>        Comma-separated list of Channels to filter\n";
  print STDOUT " -iC <Channel list>        Comma-separated list of Channels to filter (Inverted!)\n";
  print STDOUT " -fR <Carrier list>        Comma-separated list of Carriers to filter\n";
  print STDOUT " -iR <Carrier list>        Comma-separated list of Carriers to filter (Inverted!)\n";
  print STDOUT "                            Possible Carriers: a,b,g,h,n\n";
  print STDOUT "                            (normally it is the same you used for scanning!)\n";
  print STDOUT " -fT <Type list>           Comma-separated list of Types to filter\n";
  print STDOUT " -iT <Type list>           Comma-separated list of Types to filter (Inverted!)\n";
  print STDOUT "                            Possible Types: infrastructure,ad-hoc,probe,data,\n";
  print STDOUT "                                            turbocell,unknown\n";
  print STDOUT " -fH, --have-clients       Only shows networks with clients seen\n";
  print STDOUT " -iH, --i-have-clients     Only shows networks with clients seen (Inverted!)\n";
  print STDOUT " -fI, --ip-seen            Only shows networks with ip-addresses seen\n";
  print STDOUT " -iI, --i-ip-seen          Only shows networks with ip-addresses seen (Inverted!)\n";
  print STDOUT "\n";
  print STDOUT "Drawing Options:\n";
  print STDOUT " -n,  --network-colors <c> Network drawing colors [Default: 0]\n";
  print STDOUT "                            0 is random colors\n";
  print STDOUT "                            1 is color based on encryption status\n";
  print STDOUT "                            2 is color based on network channel\n";
  print STDOUT " -r,  --calculate-range    Rudimentary trys to calculate the range of the wireless\n";
  print STDOUT "                           network based on the min/max coords\n";
  print STDOUT " -s,  --use-signal         Enables the use of the signal strength for\n";
  print STDOUT "                           network position calculation.\n";
  print STDOUT " -c,  --draw-center        Draws each network as a single dot [Default]\n";
  print STDOUT " -cS, --center-size <s>    Size of network center dot [1 to 4 ; Default 1]\n";
  print STDOUT " -a,  --alpha <h>          Draw opacity [1 to 255 ; Default: 127 (~50%)]\n";
  #print STDOUT " -eI <Info list>           Exports given Inforamtion into kml/kmz network description\n";
  #print STDOUT "                           [Default: all]\n";
  #print STDOUT "                            Possible Infos: ssid,bssid,type,wep,cloaked,firsttime,lasttime,\n";
  #print STDOUT "                                            info,channel,maxrate,maxseenrate,carrier,\n";
  #print STDOUT "                                            encoding,packets,gpsinfo,iptype,iprange,datasize\n";

} # sub usage

# own print function...
sub my_print {

  my $which   = $_[0];
  my $msg     = $_[1];

  if($which == 0) {
    print STDERR "ERROR: $msg\n";
  }elsif(($which <= $MSGLVL) and ($QUIET == 0)) {
    print STDOUT "$msg\n";
  }

  return 0;

} # sub my_print

# prting the version
sub print_version {

  print STDOUT "$CODENAME $VERSION ( $WEBSITE )\n";
  print STDOUT "$AUTHOR - $CONTACT\n";
  print STDOUT "License: GNU General Public License ( http://www.gnu.org/licenses/gpl.txt )\n";

} # sub print_version

# processing commandline arguments
# this is a very strange and rudimentary function ;)
sub process_opts {

  my $optcnt = 0;
  my $optend = 0;
  my $dummy  = "";

  if(($#ARGV == -1) or ($#ARGV > 256)) {
    &usage();
    return -1;
  }

  for( ; $optcnt <= $#ARGV ; $optcnt++) {
    if(($ARGV[$optcnt] eq '-h') or ($ARGV[$optcnt] eq '--help')) {
      &usage();
      exit 0;
    }elsif(($ARGV[$optcnt] eq '-V') or ($ARGV[$optcnt] eq '--version')) {
      &print_version();
      exit 0;
    }elsif(($ARGV[$optcnt] eq '-v') or ($ARGV[$optcnt] eq '--verbose')) {
      if($MSGLVL < 2) {
        $MSGLVL = 2;
      }elsif($MSGLVL == 3) {
        &my_print($DEBUG, "DEBUG > VERBOSE.");
      }
    }elsif(($ARGV[$optcnt] eq '-d') or ($ARGV[$optcnt] eq '--debug')) {
      if($MSGLVL < 3) {
        $MSGLVL = 3;
        &my_print($DEBUG, "DEBUG mode enabled.");
      }
    }elsif(($ARGV[$optcnt] eq '-q') or ($ARGV[$optcnt] eq '--quiet')) {
      $QUIET = 1;
    }elsif(($ARGV[$optcnt] eq '-fI') or ($ARGV[$optcnt] eq '--ip-seen')) {
      $IPSEEN = 1;
      &my_print($DEBUG, "IP Seen filter activated!");
    }elsif(($ARGV[$optcnt] eq '-fH') or ($ARGV[$optcnt] eq '--have-clients')) {
      $HAVECLIENTS = 1;
      &my_print($DEBUG, "Have Clients filter activated!");
    }elsif(($ARGV[$optcnt] eq '-iI') or ($ARGV[$optcnt] eq '--i-ip-seen')) {
      $IIPSEEN = 1;
      &my_print($DEBUG, "Inverted IP Seen filter activated!");
    }elsif(($ARGV[$optcnt] eq '-iH') or ($ARGV[$optcnt] eq '--i-have-clients')) {
      $IHAVECLIENTS = 1;
      &my_print($DEBUG, "Inverted Have Clients filter activated!");
    }elsif(($ARGV[$optcnt] eq '-r') or ($ARGV[$optcnt] eq '--calculate-range')) {
      $CALCRANGE = 1;
      &my_print($DEBUG, "Calculate Network Range activated!");
    }elsif(($ARGV[$optcnt] eq '-s') or ($ARGV[$optcnt] eq '--use-signal')) {
      $USESIGNAL = 1;
      &my_print($DEBUG, "Calculate network position with the help of the signal strength!");
    }elsif(($ARGV[$optcnt] eq '-c') or ($ARGV[$optcnt] eq '--draw-center')) {
      $DRAWCENTER = 1;
      &my_print($DEBUG, "Draw Network Center activated!");
    }elsif(($ARGV[$optcnt] eq '-cS') or ($ARGV[$optcnt] eq '--center-size')) {
      if($ARGV[$optcnt+1] =~ m/^[1-4]$/) {
        $CENTERSIZE = $ARGV[$optcnt+1];
        &my_print($DEBUG, "Using Center Size: $CENTERSIZE");
        $optcnt++;
      }else{
        &my_print($ERROR, "Format error in given -cS/--center-size value!");
        return -1;
      }
    }elsif(($ARGV[$optcnt] eq '-n') or ($ARGV[$optcnt] eq '--network-colors')) {
      if($ARGV[$optcnt+1] =~ m/^[0-2]$/) {
        $NCOLORS = $ARGV[$optcnt+1];
        &my_print($DEBUG, "Using Network Colors: $NCOLORS");
        $optcnt++;
      }else{
        &my_print($ERROR, "Format error in given -n/--network-colors value!");
        return -1;
      }
    }elsif(($ARGV[$optcnt] eq '-O') or ($ARGV[$optcnt] eq '--order')) {
      if($ARGV[$optcnt+1] =~ m/^[0-1]$/) {
        $ORDER = $ARGV[$optcnt+1];
        &my_print($DEBUG, "Using Order: $ORDER");
        $optcnt++;
      }else{
        &my_print($ERROR, "Format error in given -O/--order value!");
        return -1;
      }
    }elsif(($ARGV[$optcnt] eq '-a') or ($ARGV[$optcnt] eq '--alpha')) {
      if($ARGV[$optcnt+1] =~ m/^[0-9]{1,3}$/) {
        $OPACITY = $ARGV[$optcnt+1];
        &my_print($DEBUG, "Using Opacity/Alpha value: $OPACITY");
        $optcnt++;
      }else{
        &my_print($ERROR, "Format error in given -a/--alpha value!");
        return -1;
      }
    }elsif(($ARGV[$optcnt] eq '-G') or ($ARGV[$optcnt] eq '--gps')) {
      if(-f $ARGV[$optcnt+1]) {
        $kismet_gps_file = $ARGV[$optcnt+1];
        &my_print($VERBOSE, "Using $kismet_gps_file as gps file ...");
        $optcnt++;
      }else{
        &my_print($ERROR, "File not found (-G/--gps $kismet_gps_file)!");
        return -1;
      }
    }elsif($ARGV[$optcnt] eq '-oN') {
      if($ARGV[$optcnt+1] =~ m/^\-$/i) {
        $OUTFTYPE = "kml";
        &my_print($DEBUG, "Using $OUTFTYPE output format ...");
        $OUTFNAME = "$ARGV[$optcnt+1]";
        &my_print($VERBOSE, "Using $OUTFNAME (STDOUT) as output file ...");
      }elsif((!($ARGV[$optcnt+1] =~ m/^\-/i)) and (!(-f $ARGV[$optcnt+1]))) {
        $OUTFTYPE = "kml";
        &my_print($DEBUG, "Using $OUTFTYPE output format ...");
        $OUTFNAME = "$ARGV[$optcnt+1]";
        &my_print($VERBOSE, "Using $OUTFNAME as output file ...");
        $optcnt++;
      }else{
        &my_print($ERROR, "None/wrong filenamen given to -oN or file already exists!");
        return -1;
      }
    }elsif($ARGV[$optcnt] =~ m/^\-(f|i)S$/) {
      $dummy = $1;
      if($ARGV[$optcnt+1] =~ m/^[^\-](.)*$/i) {
        if($dummy eq 'f') {
          $SSIDFILTER = $ARGV[$optcnt+1];
          &my_print($DEBUG, "Using SSID Filter: $SSIDFILTER");
          $optcnt++;
        }elsif($dummy eq 'i') {
          $ISSIDFILTER = $ARGV[$optcnt+1];
          &my_print($DEBUG, "Using inverted SSID Filter: $ISSIDFILTER");
          $optcnt++;
        }
      }else{ 
        &my_print($ERROR, "Format error in given -${dummy}S filter list!");
        return -1;
      }
    }elsif($ARGV[$optcnt] =~ m/^\-(f|i)B$/) {
      $dummy = $1;
      if($ARGV[$optcnt+1] =~ m/^[^\-](.)*$/i) {
        if($dummy eq 'f') {
          $BSSIDFILTER = $ARGV[$optcnt+1];
          &my_print($DEBUG, "Using BSSID Filter: $BSSIDFILTER");
          $optcnt++;
        }elsif($dummy eq 'i') {
          $IBSSIDFILTER = $ARGV[$optcnt+1];
          &my_print($DEBUG, "Using inverted BSSID Filter: $IBSSIDFILTER");
          $optcnt++;
        }
      }else{ 
        &my_print($ERROR, "Format error in given -${dummy}B filter list!");
        return -1;
      }
    }elsif($ARGV[$optcnt] =~ m/^\-(f|i)C$/) {
      $dummy = $1;
      if($ARGV[$optcnt+1] =~ m/^[^\-](.)*$/i) {
        if($dummy eq 'f') {
          $CHANFILTER = $ARGV[$optcnt+1];
          &my_print($DEBUG, "Using Channel Filter: $CHANFILTER");
          $optcnt++;
        }elsif($dummy eq 'i') {
          $ICHANFILTER = $ARGV[$optcnt+1];
          &my_print($DEBUG, "Using inverted Channel Filter: $ICHANFILTER");
          $optcnt++;
        }
      }else{ 
        &my_print($ERROR, "Format error in given -${dummy}C filter list!");
        return -1;
      }
    }elsif($ARGV[$optcnt] =~ m/^\-(f|i)R$/) {
      $dummy = $1;
      if($ARGV[$optcnt+1] =~ m/^[^\-](.)*$/i) {
        if($dummy eq 'f') {
          $CARRFILTER = $ARGV[$optcnt+1];
          &my_print($DEBUG, "Using Carrier Filter: $CARRFILTER");
          $optcnt++;
        }elsif($dummy eq 'i') {
          $ICARRFILTER = $ARGV[$optcnt+1];
          &my_print($DEBUG, "Using inverted Carrier Filter: $ICARRFILTER");
          $optcnt++;
        }
      }else{ 
        &my_print($ERROR, "Format error in given -${dummy}R filter list!");
        return -1;
      }
    }elsif($ARGV[$optcnt] =~ m/^\-(f|i)T$/) {
      $dummy = $1;
      if($ARGV[$optcnt+1] =~ m/^[^\-](.)*$/i) {
        if($dummy eq 'f') {
          $TYPEFILTER = $ARGV[$optcnt+1];
          &my_print($DEBUG, "Using Type Filter: $TYPEFILTER");
          $optcnt++;
        }elsif($dummy eq 'i') {
          $ITYPEFILTER = $ARGV[$optcnt+1];
          &my_print($DEBUG, "Using inverted Type Filter: $ITYPEFILTER");
          $optcnt++;
        }
      }else{ 
        &my_print($ERROR, "Format error in given -${dummy}T filter list!");
        return -1;
      }
    #}elsif($ARGV[$optcnt] =~ m/^\-(f|i)P$/) {
    #  $dummy = $1;
    #  if($ARGV[$optcnt+1] =~ m/^[^\-](.)*$/i) {
    #    if($dummy eq 'f') {
    #      $PCKTFILTER = $ARGV[$optcnt+1];
    #      &my_print($DEBUG, "Using Packet Filter: $PCKTFILTER");
    #      $optcnt++;
    #    }elsif($dummy eq 'i') {
    #      $IPCKTFILTER = $ARGV[$optcnt+1];
    #      &my_print($DEBUG, "Using inverted Packet Filter: $IPCKTFILTER");
    #      $optcnt++;
    #    }
    #  }else{ 
    #    &my_print($ERROR, "Format error in given -${dummy}P filter list!");
    #    return -1;
    #  }
    }elsif($ARGV[$optcnt] eq '-eI') {
      if($ARGV[$optcnt+1] =~ m/^[^\-](.)*$/i) {
        $INFOS = $ARGV[$optcnt+1];
        &my_print($DEBUG, "Using Info list: $INFOS");
        $optcnt++;
      }else{ 
        &my_print($ERROR, "Format error in given -eI list!");
        return -1;
      }
    }elsif($ARGV[$optcnt] eq '--') {
      if((defined $ARGV[$optcnt+1]) and (!(-f $ARGV[$optcnt+1]))) {
        &my_print($ERROR, "File not found! ( $ARGV[$optcnt+1] )");
        return -1;
      }elsif((defined $ARGV[$optcnt+1]) and (-f $ARGV[$optcnt+1])) {
        $kismet_xml_file = $ARGV[$optcnt+1];
        &my_print($DEBUG, "Using $kismet_xml_file ...");
        $optend = 1;
        last;
      }else{  
        &my_print($ERROR, "Did you miss to specify an output file?!");
        return -1;
      }
    }
  }
 
  if(($OUTFTYPE eq "") or ($OUTFNAME eq "")) {
    &my_print($ERROR, "No ouput file specified (-oN/-oZ)! Abortion!");
    return -1;
  }
 
  if($optend == 0) {
    &my_print($ERROR, "Optend (--) not found! Abortion!");
    return -1;
  }

} # sub process_opts

# reading the xml file/s
sub read_k_xml {

  my $xml_file = $_[0];
  my $data     = "";
  my $procnt   = 0;
  my $N        = "";
  my $E        = "";
  my $xml      = undef;

  # create object
  $xml = new XML::Simple (KeyAttr=>[]);

  $data = $xml->XMLin("$xml_file");

  &my_print($VERBOSE, "Storing data into our structures ...");

  $FROM = $data->{'start-time'};
  $TO   = $data->{'end-time'};

  foreach $N (@{$data->{'wireless-network'}}) {

    $networks[$net_count] = Network->new();
    $networks[$net_count]->nipaddress(new IPaddress);
    $networks[$net_count]->npackets(new Packets);
    $networks[$net_count]->ngpsinfo(new Gpsinfo);

    $networks[$net_count]->nnumber($N->{'number'});
    $networks[$net_count]->nssid($N->{'SSID'});
    $networks[$net_count]->nbssid($N->{'BSSID'});
    $networks[$net_count]->ninfo($N->{'info'});
    $networks[$net_count]->nchannel($N->{'channel'});
    $networks[$net_count]->nwep($N->{'wep'});
    $networks[$net_count]->ncarrier($N->{'carrier'});
    $networks[$net_count]->nencoding($N->{'encoding'});
    $networks[$net_count]->ncloaked($N->{'cloaked'});
    $networks[$net_count]->ndatasize($N->{'datasize'});
    $networks[$net_count]->nmaxseenrate($N->{'maxseenrate'});
    $networks[$net_count]->nlasttime($N->{'last-time'});
    $networks[$net_count]->nfirsttime($N->{'first-time'});
    $networks[$net_count]->ntype($N->{'type'});
    $networks[$net_count]->nmaxrate($N->{'maxrate'});

    $networks[$net_count]->npackets->pcrypt($N->{'packets'}->{'crypt'});
    $networks[$net_count]->npackets->pLLC($N->{'packets'}->{'LLC'});
    $networks[$net_count]->npackets->pdupeiv($N->{'packets'}->{'dupeiv'});
    $networks[$net_count]->npackets->pweak($N->{'packets'}->{'weak'});
    $networks[$net_count]->npackets->pdata($N->{'packets'}->{'data'});
    $networks[$net_count]->npackets->ptotal($N->{'packets'}->{'total'});
    $networks[$net_count]->npackets->pivdupe($N->{'packets'}->{'ivdupe'});

    $networks[$net_count]->ngpsinfo->gminlon($N->{'gps-info'}->{'min-lon'});
    $networks[$net_count]->ngpsinfo->gmaxspd($N->{'gps-info'}->{'max-spd'});
    $networks[$net_count]->ngpsinfo->gminlat($N->{'gps-info'}->{'min-lat'});
    $networks[$net_count]->ngpsinfo->gminspd($N->{'gps-info'}->{'min-spd'});
    $networks[$net_count]->ngpsinfo->gminalt($N->{'gps-info'}->{'min-alt'});
    $networks[$net_count]->ngpsinfo->gunit($N->{'gps-info'}->{'unit'});
    $networks[$net_count]->ngpsinfo->gmaxlat($N->{'gps-info'}->{'max-lat'});
    $networks[$net_count]->ngpsinfo->gmaxlon($N->{'gps-info'}->{'max-lon'});
    $networks[$net_count]->ngpsinfo->gmaxalt($N->{'gps-info'}->{'max-alt'});

    $networks[$net_count]->nipaddress->iprange($N->{'ip-address'}->{'ip-range'});
    $networks[$net_count]->nipaddress->iptype($N->{'ip-address'}->{'type'});

    $networks[$net_count]->nwclient($N->{'wireless-client'});

    foreach $E (@{$N->{'encryption'}}) {  
      push(@{$networks[$net_count]->nencryption}, $E);
    }

    $net_count++;

    # if quiet is not set, we print some status
    if(($QUIET == 0) and ($MSGLVL == 2)) {
      if($procnt == 75) {
        $procnt = 0;
        print STDOUT "\b"x75;
      }
      print STDOUT "+";
      $procnt++;
    }
  }

  #&my_print($VERBOSE, "\n");
  &my_print($VERBOSE, $net_count." networks imported.");

  return 0;

} # sub read_k_xml

# reading the xml file/s
sub read_g_xml {

  my $xml_file = $_[0];
  my $data     = "";
  my $procnt   = 0;
  my $N        = "";
  my $E        = "";
  my $xml      = undef;

  # create object
  $xml = new XML::Simple (KeyAttr=>[]);

  $data = $xml->XMLin("$xml_file");

  &my_print($VERBOSE, "Storing data into our structures ...");

  #$FROM = $data->{'start-time'};

  foreach $N (@{$data->{'gps-point'}}) {

    $GPSpoints[$gps_cnt] = GPSpoint->new();

    $GPSpoints[$gps_cnt]->bssid($N->{'bssid'});
    $GPSpoints[$gps_cnt]->timesec($N->{'time-sec'});
    $GPSpoints[$gps_cnt]->timeusec($N->{'time-usec'});
    $GPSpoints[$gps_cnt]->lat($N->{'lat'});
    $GPSpoints[$gps_cnt]->lon($N->{'lon'});
    $GPSpoints[$gps_cnt]->alt($N->{'alt'});
    $GPSpoints[$gps_cnt]->spd($N->{'spd'});
    $GPSpoints[$gps_cnt]->heading($N->{'heading'});
    $GPSpoints[$gps_cnt]->fix($N->{'fix'});
    $GPSpoints[$gps_cnt]->signal($N->{'signal'});
    $GPSpoints[$gps_cnt]->quality($N->{'quality'});
    $GPSpoints[$gps_cnt]->noise($N->{'noise'});

    $gps_cnt++;

    # if quiet is not set, we print some status
    if(($QUIET == 0) and ($MSGLVL == 2)) {
      if($procnt == 75) {
        $procnt = 0;
        print STDOUT "\b"x75;
      }
      print STDOUT "+";
      $procnt++;
    }
  }

  #&my_print($VERBOSE, "\n");
  &my_print($VERBOSE, $gps_cnt." gps data units imported.");

  return 0;

} # sub read_k_xml

# our filter function
sub apply_filters {

  my $entrycnt    = 0;
  my $pattern     = "";
  my $dummy       = 0;
  my $overdummy   = 0;
  my $procnt      = 0;

  my @ssidlist    = ();
  my @issidlist   = ();
  my @bssidlist   = ();
  my @ibssidlist  = ();

  if($SSIDFILTER ne "") { @ssidlist = split(/,/, $SSIDFILTER); }
  if($ISSIDFILTER ne "") { @issidlist = split(/,/, $ISSIDFILTER); }
  if($BSSIDFILTER ne "") { @bssidlist = split(/,/, $BSSIDFILTER); }
  if($IBSSIDFILTER ne "") { @ibssidlist = split(/,/, $IBSSIDFILTER); }
  if($CHANFILTER ne "") { @chanlist = split(/,/, $CHANFILTER); }
  if($ICHANFILTER ne "") { @ichanlist = split(/,/, $ICHANFILTER); }
  if($CARRFILTER ne "") { @carrlist = split(/,/, $CARRFILTER); }
  if($ICARRFILTER ne "") { @icarrlist = split(/,/, $ICARRFILTER); }
  if($TYPEFILTER ne "") { @typelist = split(/,/, $TYPEFILTER); }
  if($ITYPEFILTER ne "") { @itypelist = split(/,/, $ITYPEFILTER); }

  &my_print($VERBOSE, "Proccessing filters ...");

  for( ; ; ) {
    if($entrycnt == $net_count) {
      last;
    }

    if($#ssidlist >= 0) {
      foreach $pattern (@ssidlist) {
        if((defined($networks[$entrycnt]->nssid)) and ($networks[$entrycnt]->nssid eq $pattern)) {
          $dummy = 1;
          last;
        }
      }
      if($dummy == 0) {
        &my_print($DEBUG, "Network ".$networks[$entrycnt]->nnumber." deletet through SSID filter!");
        splice(@networks, $entrycnt, 1);
        $net_count--;
        redo;
      }elsif($dummy == 1) {
        $overdummy = 1;
        $dummy = 0;
      }
    }

    if($#issidlist >= 0) {
      foreach $pattern (@issidlist) {
        if((defined($networks[$entrycnt]->nssid)) and ($networks[$entrycnt]->nssid eq $pattern)) {
          $dummy = 1;
          last;
        }
      }
      if($dummy == 1) {
        &my_print($DEBUG, "Network ".$networks[$entrycnt]->nnumber." deletet through inverted SSID filter!");
        splice(@networks, $entrycnt, 1);
        $net_count--;
        $dummy = 0;
        redo;
      }elsif($dummy == 0) {
        $overdummy = 1;
      }
    }

    if($#bssidlist >= 0) {
      foreach $pattern (@bssidlist) {
        if((defined($networks[$entrycnt]->nbssid)) and ($networks[$entrycnt]->nbssid =~ m/$pattern/i)) {
          $dummy = 1;
          last;
        }
      }
      if($dummy == 0) {
        &my_print($DEBUG, "Network ".$networks[$entrycnt]->nnumber." deletet through BSSID filter!");
        splice(@networks, $entrycnt, 1);
        $net_count--;
        redo;
      }elsif($dummy == 1) {
        $overdummy = 1;
        $dummy = 0;
      }
    }

    if($#ibssidlist >= 0) {
      foreach $pattern (@ibssidlist) {
        if((defined($networks[$entrycnt]->nbssid)) and ($networks[$entrycnt]->nbssid =~ m/$pattern/i)) {
          $dummy = 1;
          last;
        }
      }
      if($dummy == 1) {
        &my_print($DEBUG, "Network ".$networks[$entrycnt]->nnumber." deletet through inverted BSSID filter!");
        splice(@networks, $entrycnt, 1);
        $net_count--;
        $dummy = 0;
        redo;
      }elsif($dummy == 0) {
        $overdummy = 1;
      }
    }

    if($#chanlist >= 0) {
      foreach $pattern (@chanlist) {
        if((defined($networks[$entrycnt]->nchannel)) and ($networks[$entrycnt]->nchannel =~ m/$pattern/i)) {
          $dummy = 1;
          last;
        }
      }
      if($dummy == 0) {
        &my_print($DEBUG, "Network ".$networks[$entrycnt]->nnumber." deletet through Channel filter!");
        splice(@networks, $entrycnt, 1);
        $net_count--;
        redo;
      }elsif($dummy == 1) {
        $overdummy = 1;
        $dummy = 0;
      }
    }

    if($#ichanlist >= 0) {
      foreach $pattern (@ichanlist) {
        if((defined($networks[$entrycnt]->nchannel)) and ($networks[$entrycnt]->nchannel =~ m/$pattern/i)) {
          $dummy = 1;
          last;
        }
      }
      if($dummy == 1) {
        &my_print($DEBUG, "Network ".$networks[$entrycnt]->nnumber." deletet through inverted Channel filter!");
        splice(@networks, $entrycnt, 1);
        $net_count--;
        $dummy = 0;
        redo;
      }elsif($dummy == 0) {
        $overdummy = 1;
      }
    }

    if($#carrlist >= 0) {
      foreach $pattern (@carrlist) {
        if((defined($networks[$entrycnt]->ncarrier)) and ($networks[$entrycnt]->ncarrier =~ m/$pattern$/i)) {
          $dummy = 1;
          last;
        }
      }
      if($dummy == 0) {
        &my_print($DEBUG, "Network ".$networks[$entrycnt]->nnumber." deletet through Carrier filter!");
        splice(@networks, $entrycnt, 1);
        $net_count--;
        redo;
      }elsif($dummy == 1) {
        $overdummy = 1;
        $dummy = 0;
      }
    }

    if($#icarrlist >= 0) {
      foreach $pattern (@icarrlist) {
        if((defined($networks[$entrycnt]->ncarrier)) and ($networks[$entrycnt]->ncarrier =~ m/$pattern$/i)) {
          $dummy = 1;
          last;
        }
      }
      if($dummy == 1) {
        &my_print($DEBUG, "Network ".$networks[$entrycnt]->nnumber." deletet through inverted Carrier filter!");
        splice(@networks, $entrycnt, 1);
        $net_count--;
        $dummy = 0;
        redo;
      }elsif($dummy == 0) {
        $overdummy = 1;
      }
    }

    if($#typelist >= 0) {
      foreach $pattern (@typelist) {
        if((defined($networks[$entrycnt]->ntype)) and ($networks[$entrycnt]->ntype eq $pattern)) {
          $dummy = 1;
          last;
        }
      }
      if($dummy == 0) {
        &my_print($DEBUG, "Network ".$networks[$entrycnt]->nnumber." deletet through Type filter!");
        splice(@networks, $entrycnt, 1);
        $net_count--;
        redo;
      }elsif($dummy == 1) {
        $overdummy = 1;
        $dummy = 0;
      }
    }

    if($#itypelist >= 0) {
      foreach $pattern (@itypelist) {
        if((defined($networks[$entrycnt]->ntype)) and ($networks[$entrycnt]->ntype eq $pattern)) {
          $dummy = 1;
          last;
        }
      }
      if($dummy == 1) {
        &my_print($DEBUG, "Network ".$networks[$entrycnt]->nnumber." deletet through inverted Type filter!");
        splice(@networks, $entrycnt, 1);
        $net_count--;
        $dummy = 0;
        redo;
      }elsif($dummy == 0) {
        $overdummy = 1;
      }
    }

    if($HAVECLIENTS == 1) {
      if(not defined($networks[$entrycnt]->nwclient)) {
        &my_print($DEBUG, "Network ".$networks[$entrycnt]->nnumber." deletet through Have Clients filter!");
        splice(@networks, $entrycnt, 1);
        $net_count--;
        redo;
      }else{
        $overdummy = 1;
      }
    }

    if($IHAVECLIENTS == 1) {
      if(defined($networks[$entrycnt]->nwclient)) {
        &my_print($DEBUG, "Network ".$networks[$entrycnt]->nnumber." deletet through inverted Have Clients filter!");
        splice(@networks, $entrycnt, 1);
        $net_count--;
        redo;
      }else{
        $overdummy = 1;
      }
    }

    if($IPSEEN == 1) {
      if(not defined($networks[$entrycnt]->nipaddress->iprange)) {
        &my_print($DEBUG, "Network ".$networks[$entrycnt]->nnumber." deletet through IP Seen filter!");
        splice(@networks, $entrycnt, 1);
        $net_count--;
        redo;
      }else{
        $overdummy = 1;
      }
    }

    if($IIPSEEN == 1) {
      if(defined($networks[$entrycnt]->nipaddress->iprange)) {
        &my_print($DEBUG, "Network ".$networks[$entrycnt]->nnumber." deletet through inverted IP Seen filter!");
        splice(@networks, $entrycnt, 1);
        $net_count--;
        redo;
      }else{
        $overdummy = 1;
      }
    }

    #if($overdummy == 1) {
      $entrycnt++;
      $overdummy = 0;
    #}

    # if quiet is not set, we print some status
    if(($QUIET == 0) and ($MSGLVL == 2)) {
      if($procnt == 75) {
        $procnt = 0;
        print STDOUT "\b"x75;
      }
      print STDOUT "+";
      $procnt++;
    }

  }

  #&my_print($VERBOSE, "\n");
  &my_print($VERBOSE, $net_count." networks remained after filtering.");

  return 0;

} # sub apply_filters

# calculate network position (and range - rudimentary)
sub calc_pos {

  my $minlon_in    = $_[0];
  my $minlat_in    = $_[1];
  my $maxlon_in    = $_[2];
  my $maxlat_in    = $_[3];
  my $nbssid       = $_[4];
  my $altitude_out = 0;
  my $range_out    = 750;
  my $heading_out  = 0;
  my $tilt_out     = 0;
  my $coords_out   = "0.0,0.0";
  my $lon_out      = 0.0;
  my $lat_out      = 0.0;
  my $scale_out    = 0.0;
  my $dummy        = 0;
  my $tmp_netgps_cnt = 0;

  if($kismet_gps_file ne "") {
    for(my $tmp_gps_cnt = 0 ; $tmp_gps_cnt < $gps_cnt ; $tmp_gps_cnt++) {
      if($GPSpoints[$tmp_gps_cnt]->bssid eq $nbssid) {
        # here we go. a "little" improvement wich should help to make 
        # the positioning more accurate. (anybody ever seen some values
        # within the quality field of the *.gps files?)
        if(($USESIGNAL == 1) and ($GPSpoints[$tmp_gps_cnt]->signal > 0)) {
          $lon_out += ($GPSpoints[$tmp_gps_cnt]->lon * $GPSpoints[$tmp_gps_cnt]->signal);
          $lat_out += ($GPSpoints[$tmp_gps_cnt]->lat * $GPSpoints[$tmp_gps_cnt]->signal);
          $tmp_netgps_cnt+=$GPSpoints[$tmp_gps_cnt]->signal;
        }else{
          $lon_out += $GPSpoints[$tmp_gps_cnt]->lon;
          $lat_out += $GPSpoints[$tmp_gps_cnt]->lat;
          $tmp_netgps_cnt++;
        }
      }
    }
    if($tmp_netgps_cnt == 0) {
      &my_print($VERBOSE, "WARNING: No gps data found for bssid $nbssid, using alternate position calculation!");
      goto fallback_calc;
    }
    $lon_out /= $tmp_netgps_cnt;
    $lat_out /= $tmp_netgps_cnt;
  }else{
    fallback_calc:
    $dummy = ($maxlon_in - $minlon_in) / 2;
    $lon_out = $minlon_in + $dummy;

    $dummy = ($maxlat_in - $minlat_in) / 2;
    $lat_out = $minlat_in + $dummy;
  }

  $coords_out = "$lon_out,$lat_out,0";

  if($CALCRANGE == 1) {
    $scale_out = ((($maxlat_in - $minlat_in) + ($maxlon_in - $minlon_in)) / 2) * 1850;

    if($scale_out < 0.8) {
      $scale_out = 0.8;
    }elsif($scale_out > 4.0) {
      $scale_out = 4.0;
    }
  }else{
    $scale_out = $CENTERSIZE;
  }

  return "$lon_out|$lat_out|$coords_out|$altitude_out|$range_out|$heading_out|$tilt_out|$scale_out";

} # sub calc_pos

# TODO: error checks a.s.o.
# generates and outputs the data in kml format
sub generate {

  my $net_alpha       = sprintf("%x", $OPACITY);
  my $tmp_count       = 0;
  my $col_count       = 0;
  my $procnt          = 0;

  my $net_color       = 0;
  my $net_scale_range = 0;
  my $net_name        = 0;
  my $tmp_net_name    = "";
  my $net_desc        = 0;
  my $net_lon         = 0;
  my $net_lat         = 0;
  my $net_alt         = 0;
  my $net_range       = 0;
  my $net_tilt        = 0;
  my $net_head        = 0;
  my $net_coords      = 0;
  my $doc_name        = "";
  my $doc_state       = 0;
  my $folder_name     = "";
  my $folder_state    = 0;
  my $placemark       = "";
  my $styles          = "";

  my $net_lon_all     = 0;
  my $net_lat_all     = 0;
  my $net_false_cnt   = 0;

  my $tmp1            = "";
  my $tmp2            = "";

  my $tmp_crypt       = "";
  my $tmp_uncrypt     = "";

  my $tmp_cnt         = 0;

  my @tmp_channels    = ();

  my $kml_header      = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n<kml xmlns=\"http://earth.google.com/kml/2.1\">\n";
  my $kml_footer      = "</kml>\n";
  my $folder_close    = "  </Folder>\n";
  my $doc_close       = "    </Document>\n";

  &my_print($VERBOSE, "Generating and Ordering output ...");

  open(OUTHANDLE, ">$OUTFNAME");

  for( ; $tmp_count < $net_count ; $tmp_count++) {

    if($NCOLORS == 0) {
      #if($col_count == 15) {
      #  $col_count = 1;
      #}
      $net_color = $CHANCOL[$col_count++];
    }elsif($NCOLORS == 1) { 
      if(grep(/AES\-CCM/i, @{$networks[$tmp_count]->nencryption}) == 1) {
        $net_color = $GREEN;
      }elsif(grep(/TKIP/i, @{$networks[$tmp_count]->nencryption}) == 1) {
        $net_color = $YELLOW;
      }elsif(grep(/WEP/i, @{$networks[$tmp_count]->nencryption}) == 1) {
        $net_color = $ORANGE;
      }else{
        $net_color = $RED;
      }
    }elsif($NCOLORS == 2) {
      $net_color = $CHANCOL[$networks[$tmp_count]->nchannel];
    }else{
      $net_color = $GREY;
    }

    if(defined $networks[$tmp_count]->nssid) {
      $net_name = $networks[$tmp_count]->nssid;
    }elsif(defined $networks[$tmp_count]->nbssid) {
      $net_name = $networks[$tmp_count]->nbssid;
    }else{
      $net_name = "UNKNOWN";
    }

    ($net_lon, $net_lat, $net_coords, $net_alt, $net_range, $net_head, $net_tilt, $net_scale_range) = split(/\|/, &calc_pos($networks[$tmp_count]->ngpsinfo->gminlon, $networks[$tmp_count]->ngpsinfo->gminlat, $networks[$tmp_count]->ngpsinfo->gmaxlon, $networks[$tmp_count]->ngpsinfo->gmaxlat, $networks[$tmp_count]->nbssid));

    if(($net_lon != 0) and ($net_lat != 0)) {
      $net_lon_all += $net_lon;
      $net_lat_all += $net_lat;
    }else{
      $net_false_cnt++;
    }

    if($INFOS eq "all") {
      $net_desc = "<![CDATA[<hr>";
      if(defined $networks[$tmp_count]->nnumber) {
        $net_desc .= "<b>Number:</b> ".$networks[$tmp_count]->nnumber."<br>\n";
      }
      if(defined $networks[$tmp_count]->nssid) {
        $net_desc .= "<b>SSID:</b> ".$networks[$tmp_count]->nssid."<br>\n";
      }
      if(defined $networks[$tmp_count]->nbssid) {
        $net_desc .= "<b>BSSID:</b> ".$networks[$tmp_count]->nbssid."<br>\n";
      }
      if(defined $networks[$tmp_count]->ninfo) {
        $net_desc .= "<b>Info:</b> ".$networks[$tmp_count]->ninfo."<br>\n";
      }
      if(defined $networks[$tmp_count]->nchannel) {
        $net_desc .= "<b>Channel:</b> ".$networks[$tmp_count]->nchannel."<br>\n";
      }
      if(defined $networks[$tmp_count]->nwep) {
        $net_desc .= "<b>Encrypted:</b> ".$networks[$tmp_count]->nwep."<br>\n";
        foreach my $tmp_enc (@{$networks[$tmp_count]->nencryption}) {
          $net_desc .= "<b>Enc.-Details:</b> ".$tmp_enc."<br>\n";
        }
      }
      if(defined $networks[$tmp_count]->ncarrier) {
        $net_desc .= "<b>Carrier:</b> ".$networks[$tmp_count]->ncarrier."<br>\n";
      }
      if(defined $networks[$tmp_count]->nencoding) {
        $net_desc .= "<b>Encoding:</b> ".$networks[$tmp_count]->nencoding."<br>\n";
      }
      if(defined $networks[$tmp_count]->ncloaked) {
        $net_desc .= "<b>Cloaked:</b> ".$networks[$tmp_count]->ncloaked."<br>\n";
      }
      if(defined $networks[$tmp_count]->ndatasize) {
        $net_desc .= "<b>Datasize:</b> ".$networks[$tmp_count]->ndatasize."<br>\n";
      }
      if(defined $networks[$tmp_count]->nmaxseenrate) {
        $net_desc .= "<b>Maxseenrate:</b> ".$networks[$tmp_count]->nmaxseenrate."<br>\n";
      }
      if(defined $networks[$tmp_count]->nfirsttime) {
        $net_desc .= "<b>Firsttime:</b> ".$networks[$tmp_count]->nfirsttime."<br>\n";
      }
      if(defined $networks[$tmp_count]->nlasttime) {
        $net_desc .= "<b>Lasttime:</b> ".$networks[$tmp_count]->nlasttime."<br>\n";
      }
      if(defined $networks[$tmp_count]->ntype) {
        $net_desc .= "<b>Type:</b> ".$networks[$tmp_count]->ntype."<br>\n";
      }
      if(defined $networks[$tmp_count]->nmaxrate) {
        $net_desc .= "<b>Maxrate:</b> ".$networks[$tmp_count]->nmaxrate."<br>\n";
      }
      if(defined $networks[$tmp_count]->nwclient) {
        $net_desc .= "<b>Have Clients:</b> true<br>\n";
      }
      if(defined $networks[$tmp_count]->nipaddress->iprange) {
        $net_desc .= "<b>IP-Range:</b> ".$networks[$tmp_count]->nipaddress->iprange."<br>\n";
      }
      if(defined $networks[$tmp_count]->nipaddress->iptype) {
        $net_desc .= "<b>IP-Type:</b> ".$networks[$tmp_count]->nipaddress->iptype."<br>\n";
      }
      $net_desc .= "<hr>Generated with $CODENAME $VERSION<br>Website: $WEBSITE]]>";
    }

    $net_name     =~ s/(.)/"&#".ord($1).";"/eg;
    $tmp_net_name = $net_name;

    $styles          = "    <Style id=\"${tmp_net_name}_normal\">
          <IconStyle>
            <color>${net_alpha}${net_color}</color>
            <scale>$net_scale_range</scale>
            <Icon>
              <href>http://maps.google.com/mapfiles/kml/shapes/target.png</href>
            </Icon>
          </IconStyle>
        </Style>
        <Style id=\"${tmp_net_name}_highlight\">
          <IconStyle>
            <color>${net_alpha}${net_color}</color>
            <scale>$net_scale_range</scale>
            <Icon>
              <href>http://maps.google.com/mapfiles/kml/shapes/target.png</href>
            </Icon>
          </IconStyle>
        </Style>
      <StyleMap id=\"${tmp_net_name}_styleMap\">
        <Pair>
          <key>normal</key>
          <styleUrl>#${tmp_net_name}_normal</styleUrl>
        </Pair>
        <Pair>
          <key>highlight</key>
          <styleUrl>#${tmp_net_name}_highlight</styleUrl>
        </Pair>
      </StyleMap>
    ";

    if($ORDER == 0) {
      if((defined $networks[$tmp_count]->nwep) and ($networks[$tmp_count]->nwep eq "true")) {
        $tmp_crypt .= $styles;
      }elsif((defined $networks[$tmp_count]->nwep) and ($networks[$tmp_count]->nwep eq "false")) {
        $tmp_uncrypt .= $styles;
      }
    }elsif($ORDER == 1) {
      $tmp_channel[$networks[$tmp_count]->nchannel] .= $styles
    }

    $placemark       = "      <Placemark>
          <name>$net_name</name>
          <styleUrl>#${tmp_net_name}_styleMap</styleUrl>
          <description>$net_desc</description>
          <LookAt>
            <longitude>$net_lon</longitude>
            <latitude>$net_lat</latitude>
            <altitude>$net_alt</altitude>
            <range>$net_range</range>
            <tilt>$net_tilt</tilt>
            <heading>$net_head</heading>
          </LookAt>
          <Point>
            <coordinates>$net_coords</coordinates>
          </Point>
        </Placemark>
    ";

    if($ORDER == 0) {
      if((defined $networks[$tmp_count]->nwep) and ($networks[$tmp_count]->nwep eq "true")) {
        $tmp_crypt .= $placemark;
      }elsif((defined $networks[$tmp_count]->nwep) and ($networks[$tmp_count]->nwep eq "false")) {
        $tmp_uncrypt .= $placemark;
      }
    }elsif($ORDER == 1) {
      $tmp_channel[$networks[$tmp_count]->nchannel] .= $placemark;
    }

    # if quiet is not set, we print some status
    if(($QUIET == 0) and ($MSGLVL == 2)) {
      if($procnt == 75) {
        $procnt = 0;
        print STDOUT "\b"x75;
      }
      print STDOUT "+";
      $procnt++;
    }
  }

  #&my_print($VERBOSE, "\n");
  &my_print($VERBOSE, "Writing Generated data to file ...");

  print OUTHANDLE $kml_header;
  print OUTHANDLE "<Document>
  <name>Kismet Imported - $OUTFNAME</name>
  <open>1</open>
  <description><![CDATA[From: $FROM<br> To: $TO<hr>Generated with $CODENAME $VERSION<br>Website: $WEBSITE]]></description>
  ";
  if(($net_count-$net_false_cnt) > 0) {
    $net_lon_all = ($net_lon_all / ($net_count-$net_false_cnt));
    $net_lat_all = ($net_lat_all / ($net_count-$net_false_cnt));
  }else{
    &my_print($ERROR, "\$net_count - \$net_false_cnt is smaller or equal zero!");
    &my_print($ERROR, "it seems that there is a problem with your input data file!");
    &my_print($ERROR, "can not calculate the LookAt start position!");
  }

  print OUTHANDLE "      <LookAt>
        <longitude>$net_lon_all</longitude>
        <latitude>$net_lat_all</latitude>
        <altitude>0</altitude>
        <range>$net_range</range>
        <tilt>0</tilt>
        <heading>0</heading>
      </LookAt>
  ";

  if($ORDER == 0) {
    $tmp_crypt = "   <Document>
    <name>Encrypted</name>
    <description>These are encrypted networks.</description>
    $tmp_crypt
    </Document>
    ";
    $tmp_uncrypt = "   <Document>
    <name>Unencrypted</name>
    <description>These are unencrypted networks.</description>
    $tmp_uncrypt
    </Document>
    ";
  }elsif($ORDER == 1) {
    for($tmp_cnt = 0 ; $tmp_cnt <= 256 ; $tmp_cnt++) {
      if(defined $tmp_channel[$tmp_cnt]) {
        $tmp_channel[$tmp_cnt] = "   <Document>
        <name>Channel $tmp_cnt</name>
        <description>These are networks on Channel $tmp_cnt.</description>
        $tmp_channel[$tmp_cnt]
        </Document>
        ";
      }
    }
  }

  if($ORDER == 0) {
    print OUTHANDLE $tmp_crypt;
    print OUTHANDLE $tmp_uncrypt;
  }elsif($ORDER == 1) {
    for($tmp_cnt = 0 ; $tmp_cnt <= 256 ; $tmp_cnt++) {
      if(defined $tmp_channel[$tmp_cnt]) {
        print OUTHANDLE $tmp_channel[$tmp_cnt];
      }
    }
  }

  print OUTHANDLE $doc_close;
  print OUTHANDLE $kml_footer;

  close(OUTHANDLE);

  &my_print($VERBOSE, $net_count." networks ordered and written.");

} # sub generate




if(&process_opts() == -1) {
  &my_print($DEBUG, "An Error ocoured while parsing the commandline opts!");
  exit -1;
}

&my_print($VERBOSE, "Reading $kismet_xml_file ... this may take a while!");

if(&read_k_xml("$kismet_xml_file") != 0) {
  &my_print($DEBUG, "An Error occoured while parsing the xml file ($kismet_xml_file)!");
  exit -1;
}

if($kismet_gps_file ne "") {
  &my_print($VERBOSE, "Reading $kismet_gps_file ... this may take a while!");

  if(&read_g_xml("$kismet_gps_file") != 0) {
    &my_print($DEBUG, "An Error occoured while parsing the xml file ($kismet_gps_file)!");
    exit -1;
  }
}

if(&apply_filters() != 0) {
  &my_print($DEBUG, "An Error occoured while applying the filters!");
  exit -1;
}

&generate();

&my_print($VERBOSE, "Finished!");
