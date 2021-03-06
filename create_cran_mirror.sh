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

sudo apt-mirror

INDEX=0
for r in ${releases}; do
 for p in ${packages}; do
#   rm /home/mrutter/CRAN/ubuntu/${r}/*${p}*
   paths=`find /home/mrutter/CRAN/mirror/ppa.launchpad.net/marutter/rrutter -name *${p}* | grep -i ${r}`
   rsync -av --exclude-from '/home/mrutter/CRAN/exclude.txt' ${paths} ${ArchiveDir}/${r}
   paths=`find /home/mrutter/CRAN/mirror/ppa.launchpad.net/marutter/rrutter -name *${p}* | grep ${relnum[$INDEX]}`
   rsync -av --exclude-from '/home/mrutter/CRAN/exclude.txt' ${paths} ${ArchiveDir}/${r}
#  cp ${paths} /home/mrutter/CRAN/ubuntu/${r}
   paths=`find /home/mrutter/CRAN/mirror/ppa.launchpad.net/marutter/rrutter -name *${p}* | grep orig`
#  cp ${paths} /home/mrutter/CRAN/ubuntu/${r}
   rsync -av --exclude-from '/home/mrutter/CRAN/exclude.txt' ${paths} ${ArchiveDir}/${r}
 done
 for p in ${rcomp}; do
   paths=`find /home/mrutter/CRAN/mirror/ppa.launchpad.net/marutter/rrutter -name *${p}* | grep -i ${r}`
   rsync -av --exclude-from '/home/mrutter/CRAN/exclude.txt' ${paths} ${ArchiveDir}/${r}
 done
 ((INDEX++))
done

INDEX=0
for r in ${releases35}; do
 for p in ${packages}; do
#   rm /home/mrutter/CRAN/ubuntu/${r}/*${p}*
   paths=`find /home/mrutter/CRAN/mirror/ppa.launchpad.net/marutter/rrutter3.5 -name *${p}* | grep -i ${r}`
   rsync -av --exclude-from '/home/mrutter/CRAN/exclude.txt' ${paths} ${ArchiveDir}/${r}-cran35
   paths=`find /home/mrutter/CRAN/mirror/ppa.launchpad.net/marutter/rrutter3.5 -name *${p}* | grep ${relnum35[$INDEX]}`
   rsync -av --exclude-from '/home/mrutter/CRAN/exclude.txt' ${paths} ${ArchiveDir}/${r}-cran35
#  cp ${paths} /home/mrutter/CRAN/ubuntu/${r}
   paths=`find /home/mrutter/CRAN/mirror/ppa.launchpad.net/marutter/rrutter3.5 -name *${p}* | grep orig`
#  cp ${paths} /home/mrutter/CRAN/ubuntu/${r}
   rsync -av --exclude-from '/home/mrutter/CRAN/exclude.txt' ${paths} ${ArchiveDir}/${r}-cran35
 done
 for p in ${rcomp}; do
   paths=`find /home/mrutter/CRAN/mirror/ppa.launchpad.net/marutter/rrutter3.5 -name *${p}* | grep -i ${r}`
   rsync -av --exclude-from '/home/mrutter/CRAN/exclude.txt' ${paths} ${ArchiveDir}/${r}-cran35
 done
 ((INDEX++))
done

./remove_old.sh
# #./remove_old35.sh

for r in ${releases}; do
  rm -f ${ArchiveDir}/${r}/Release
  rm -f ${ArchiveDir}/${r}/Release.gpg
  rm -f ${ArchiveDir}/${r}/InRelease
#  rm -f ${ArchiveDir}/${r}/*20110218*.*
  sudo apt-ftparchive generate apt-ftparchive_${r}.conf
  sudo apt-ftparchive -c apt-ftparchive_${r}.conf --sha1=no release ${ArchiveDir}/${r}> ${ArchiveDir}/${r}/Release
  cat ~/.pgp/.zeke | gpg --batch --no-tty --passphrase-fd 0 -abs -o ${ArchiveDir}/${r}/Release.gpg ${ArchiveDir}/${r}/Release
  if [[ ${r} > "wily" ]]
  then
    cat ~/.pgp/.zeke | gpg --batch --no-tty --passphrase-fd 0 --clearsign -o ${ArchiveDir}/${r}/InRelease ${ArchiveDir}/${r}/Release
  fi
  sudo chmod 644 ${ArchiveDir}/${r}/Packages
  sudo chmod 644 ${ArchiveDir}/${r}/Packages.gz
  sudo chmod 644 ${ArchiveDir}/${r}/Sources
  sudo chmod 644 ${ArchiveDir}/${r}/Sources.gz
done

for r in ${releases35}; do
  rm -f ${ArchiveDir}/${r}-cran35/Release
  rm -f ${ArchiveDir}/${r}-cran35/Release.gpg
  rm -f ${ArchiveDir}/${r}-cran35/InRelease
#  rm -f ${ArchiveDir}/${r}/*20110218*.*
  sudo apt-ftparchive generate apt-ftparchive_${r}-cran35.conf
  sudo apt-ftparchive -c apt-ftparchive_${r}-cran35.conf --sha1=no release ${ArchiveDir}/${r}-cran35> ${ArchiveDir}/${r}-cran35/Release
  cat ~/.pgp/.zeke | gpg --batch --no-tty --passphrase-fd 0 -abs -o ${ArchiveDir}/${r}-cran35/Release.gpg ${ArchiveDir}/${r}-cran35/Release
  cat ~/.pgp/.zeke | gpg --batch --no-tty --passphrase-fd 0 --clearsign -o ${ArchiveDir}/${r}-cran35/InRelease ${ArchiveDir}/${r}-cran35/Release
  sudo chmod 644 ${ArchiveDir}/${r}-cran35/Packages
  sudo chmod 644 ${ArchiveDir}/${r}-cran35/Packages.gz
  sudo chmod 644 ${ArchiveDir}/${r}-cran35/Sources
  sudo chmod 644 ${ArchiveDir}/${r}-cran35/Sources.gz
done

rsync -av /home/mrutter/Dropbox/R/README.rmd ${ArchiveDir}/
mv ${ArchiveDir}/README.rmd ${ArchiveDir}/README
rsync -av /home/mrutter/Dropbox/R/README.html ${ArchiveDir}/

#rsync -avz --progress --delete -e 'ssh -p 1022' /home/mrutter/CRAN/ubuntu mar36@boson.aset.psu.edu:~
