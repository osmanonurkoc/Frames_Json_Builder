#! /bin/bash
CONFIG=./file_lists/config.cfg
if [ -f "$CONFIG" ]; then
    echo "Configuration file loaded."
    source ./file_lists/config.cfg
else
    echo "Configuration file does not exist."
    echo "Creating configuration file..."
    read -p "Press enter to continue."
    touch ./file_lists/config.cfg
    echo "ROOT=">>./file_lists/config.cfg
    echo "USERNAME=">>./file_lists/config.cfg
    echo "REPO=">>./file_lists/config.cfg
    echo "WALLFOLDER=">>./file_lists/config.cfg
    nano ./file_lists/config.cfg
    source ./file_lists/config.cfg
fi
cwd=$(pwd)
cd $ROOT
echo Building file lists...
find ./ -type d > $cwd/file_lists/collections.txt
cd $cwd
sed -i '1d' ./file_lists/collections.txt
find ./file_lists/collections.txt -type f -exec sed -i 's|./||gI' {} \;

collections_number=$(cat ./file_lists/collections.txt | wc -l)
collections="$(head -1 ./file_lists/collections.txt)"
exa $ROOT/$collections > ./file_lists/$collections.txt
sed -i '1d' ./file_lists/collections.txt

x=$collections_number
x=$((x-1))
while [ $x -gt 0 ];
do
  collections="$(head -1 ./file_lists/collections.txt)"
  exa $ROOT/$collections > ./file_lists/$collections.txt
  sed -i '1d' ./file_lists/collections.txt
  x=$(($x-1))
done

cd $ROOT
find ./ -type d > $cwd/file_lists/collections.txt
cd $cwd
sed -i '1d' ./file_lists/collections.txt
find ./file_lists/collections.txt -type f -exec sed -i 's|./||gI' {} \;
echo file lists build successfully completed.
read -p "Press enter to continue."

echo BUILDING JSON FILE...
sleep 2
cp ./Scheme/start.json ./
mv start.json output.json


number_of_collections=$(cat ./file_lists/collections.txt | wc -l)

y=$number_of_collections
while [ $y -gt 0 ];
do
  collection_name="$(head -1 ./file_lists/collections.txt)"
  wallpaper_name="$(head -1 ./file_lists/$collection_name.txt)"
  number_of_wallpapers=$(cat ./file_lists/$collection_name.txt | wc -l)
  sed -i '1d' ./file_lists/$collection_name.txt
  cp ./Scheme/Scheme.json ./builder
  find ./builder/Scheme.json -type f -exec sed -i "s|Xwallpaper_name|$wallpaper_name|gI" {} \;
  find ./builder/Scheme.json -type f -exec sed -i "s|Xcollection_name|$collection_name|gI" {} \;
  IN=$wallpaper_name
  arrIN=(${IN//-/ })
  Title=${arrIN[1]}
  Author=${arrIN[0]}
  find ./builder/Scheme.json -type f -exec sed -i "s|Xname|$Title|gI" {} \;
  find ./builder/Scheme.json -type f -exec sed -i "s|Xauthor_name|$Author|gI" {} \;
  cat ./builder/Scheme.json >> ./output.json
  x=$number_of_wallpapers
  x=$((x-1))
  while [ $x -gt 0 ];
  do
    wallpaper_name="$(head -1 ./file_lists/$collection_name.txt)"
    sed -i '1d' ./file_lists/$collection_name.txt
    cp ./Scheme/Scheme.json ./builder
    find ./builder/Scheme.json -type f -exec sed -i "s|Xwallpaper_name|$wallpaper_name|gI" {} \;
    find ./builder/Scheme.json -type f -exec sed -i "s|Xcollection_name|$collection_name|gI" {} \;
    IN=$wallpaper_name
    arrIN=(${IN//-/ })
    Title=${arrIN[1]}
    Author=${arrIN[0]}
    find ./builder/Scheme.json -type f -exec sed -i "s|Xname|$Title|gI" {} \;
    find ./builder/Scheme.json -type f -exec sed -i "s|Xauthor_name|$Author|gI" {} \;
    cat ./builder/Scheme.json >> ./output.json
    x=$(($x-1))
  done
  sed -i '1d' ./file_lists/collections.txt
  echo $collection_name collection completed.
  y=$(($y-1))
done
cat ./Scheme/end.json >> ./output.json
penultimate=$(cat ./output.json | wc -l)
z=$penultimate
z=$((z-1))
find ./output.json -type f -exec sed -i "$z"' s|},|}|gI' {} \;
find ./output.json -type f -exec sed -i '/"name"/s/.png//gI' {} \;
find ./output.json -type f -exec sed -i '/"name"/s/.jpeg//gI' {} \;
find ./output.json -type f -exec sed -i '/"name"/s/.jpg//gI' {} \;
find ./output.json -type f -exec sed -i '/"name"/s/.bmp//gI' {} \;
find ./output.json -type f -exec sed -i '/"name"/s/.webp//gI' {} \;
find ./output.json -type f -exec sed -i '/"name"/s/_/ /gI' {} \;
find ./output.json -type f -exec sed -i '/"author"/s/_/ /gI' {} \;
find ./output.json -type f -exec sed -i '/"collections"/s/_/ /gI' {} \;
find ./output.json -type f -exec sed -i "s|#username#|$USERNAME|gI" {} \;
find ./output.json -type f -exec sed -i "s|#repository#|$REPO|gI" {} \;
find ./output.json -type f -exec sed -i "s|#mainfolder#|$WALLFOLDER|gI" {} \;
cp ./output.json ../wallpapers.json
echo JSON FILE SUCCESSFULLY BUILT.
sleep 2
echo FRAMES JSON BUILDER @osmanonurkoc
read -p "Press enter to start cleanup."
rm ./*.json
rm ./builder/*.json
rm ./file_lists/*.txt
> /dev/null
echo done
