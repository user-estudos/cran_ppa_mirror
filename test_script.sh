#!/bin/bash
cd /home/mrutter/CRAN

. ~/CRAN/packages.txt

ArchiveDir=/home/cran/ubuntu

packages=${CRANPackages}
releases=${CRANReleases}
relnum=(${CRANRelNum})
releases35=${CRAN35Releases}
relnum35=(${CRAN35RelNum})
rcomp=${RComponents}

echo ${releases}
echo ${releases35}

#sudo apt-mirror

INDEX=0
for r in ${releases}; do
 for p in ${packages}; do
#   rm /home/mrutter/CRAN/ubuntu/${r}/*${p}*
#   paths=`find /home/mrutter/CRAN/mirror/ppa.launchpad.net/marutter/rrutter -name *${p}* | grep ${r}`
#   rsync -av --exclude-from '/home/mrutter/CRAN/exclude.txt' ${paths} ${ArchiveDir}/${r}
   paths=`find /home/mrutter/CRAN/mirror/ppa.launchpad.net/marutter/rrutter -name *${p}* | grep ${relnum[$INDEX]}`
   echo ${p}
   echo ${paths}
#   rsync -av --exclude-from '/home/mrutter/CRAN/exclude.txt' ${paths} ${ArchiveDir}/${r}
#  cp ${paths} /home/mrutter/CRAN/ubuntu/${r}
#   paths=`find /home/mrutter/CRAN/mirror/ppa.launchpad.net/marutter/rrutter -name *${p}* | grep orig`
#  cp ${paths} /home/mrutter/CRAN/ubuntu/${r}
#   rsync -av --exclude-from '/home/mrutter/CRAN/exclude.txt' ${paths} ${ArchiveDir}/${r}
 done
# for p in ${rcomp}; do
#   paths=`find /home/mrutter/CRAN/mirror/ppa.launchpad.net/marutter/rrutter -name *${p}* | grep ${r}`
#   rsync -av --exclude-from '/home/mrutter/CRAN/exclude.txt' ${paths} ${ArchiveDir}/${r}
# done
 ((INDEX++))
done

