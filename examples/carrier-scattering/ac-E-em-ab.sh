#! /bin/sh
set -e

# Acoustic phonon scattering for an infinite QW
#
# This script is part of the QWWAD software suite. Any use of this code
# or its derivatives in published work must be accompanied by a citation
# of:
#   P. Harrison and A. Valavanis, Quantum Wells, Wires and Dots, 4th ed.
#    Chichester, U.K.: J. Wiley, 2015, ch.2
#
# (c) Copyright 1996-2014
#     Alex Valavanis <a.valavanis@leeds.ac.uk>
#
# QWWAD is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# QWWAD is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with QWWAD.  If not, see <http://www.gnu.org/licenses/>.

# Initialise files
outfile=ac-E-em-ab.dat
rm -f $outfile

# Electron temperature
T=300

nz=601

# Define required rate
cat > rrp.r << EOF
2 1
1 2
EOF

cat > N.r << EOF
1e14
1e14
EOF

# Loop over carrier density per subband
for LW in `seq 100 10 600`; do

# Solve infinite well
efiw --width $LW --nz $nz --nst 2

 # Save lowest two energies to file
 E1=`sed -n 1p < Ee.r | awk '{print $2}'`
 E2=`sed -n 2p < Ee.r | awk '{print $2}'`
 DE=`echo $E1 $E2 | awk '{print $2-$1}'`

 # Calculate distribution function
 sbp --Te $T

 sradp --Te $T --Tl $T
 rate_21_em=`awk '/^2/{print $3}' ACe-if.r`
 rate_12_em=`awk '/^1/{print $3}' ACe-if.r`
 rate_21_ab=`awk '/^2/{print $3}' ACa-if.r`
 rate_12_ab=`awk '/^1/{print $3}' ACa-if.r`

 printf "%e %e %e %e %e\n" $DE $rate_21_em $rate_21_ab $rate_12_em $rate_12_ab >> $outfile
done

cat << EOF
Results have been written to $outfile in the format:

  COLUMN 1 - 
  COLUMN 2 - <Something>
  <...>

  <Remove this chunk if only 1 data set is in the file>
  The file contains <x> data sets, each set being separated
  by a blank line, representing <whatever>:

  SET 1 - <Description of the 1st set>
  SET 2 - <Description of the 2nd set>
  <...>

This script is part of the QWWAD software suite.

(c) Copyright 1996-2014
    Alex Valavanis <a.valavanis@leeds.ac.uk>
    Paul Harrison  <p.harrison@leeds.ac.uk>

Report bugs to https://bugs.launchpad.net/qwwad
EOF

# Clean up workspace
# rm -f *.r
