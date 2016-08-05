 #
 # Copyright © 2016, Kartik12 a.k.a The-Demon12
 #
 # Custom build script
 #
 # This software is licensed under the terms of the GNU General Public
 # License version 2, as published by the Free Software Foundation, and
 # may be copied, distributed, and modified under those terms.
 #
 # This program is distributed in the hope that it will be useful,
 # but WITHOUT ANY WARRANTY; without even the implied warranty of
 # MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 # GNU General Public License for more details.
 #
 # Please maintain this if you use this script or any part of it
 #
KERNEL_DIR=~/msm8916
KERNEL_OUT=~/phenex_out
KERN_IMG=$KERNEL_DIR/arch/arm64/boot/Image
DTBTOOL=$KERNEL_DIR/dtbToolCM
TOOLCHAIN_DIR=~/toolchain/bin
BUILD_START=$(date +"%s")
blue='\033[0;34m'
cyan='\033[0;36m'
yellow='\033[0;33m'
red='\033[0;31m'
nocol='\033[0m'
# Modify the following variable if you want to build
export ARCH=arm64
export CCOMPILE=$CROSS_COMPILE
export CROSS_COMPILE=aarch64-linux-android-
export PATH=$PATH:~/toolchain/bin
export KBUILD_BUILD_USER="TheDemon"
export KBUILD_BUILD_HOST="Gates-Of-Hell"
STRIP="~/toolchain/bin/aarch64-linux-android-strip"
MODULES_DIR=$KERNEL_DIR/drivers/staging/prima


compile_kernel ()
{
echo -e "$blue               ~ WRITING INTO CONFIGS         $nocol"
rm -f $KERN_IMG
make cyanogenmod_lettuce-64_defconfig
echo -e "$blue                 ~ BUILDING KERNEL          $nocol"
make -j8
if ! [ -a $KERN_IMG ];
then
echo -e "$red Kernel Compilation failed! Fix the errors! $nocol"
exit 1
fi
echo -e "$blue                  ~MAKING MASTER DTB        $nocol  "
$DTBTOOL -2 -o $KERNEL_DIR/arch/arm64/boot/dt.img -s 2048 -p $KERNEL_DIR/scripts/dtc/ $KERNEL_DIR/arch/arm/boot/dts/
}

phenex ()
{
echo -e "$red**********************************************************"
echo "                      COMPILING PHENEX KERNEL             "
echo -e "**********************************************************$nocol"
echo -e " "
echo -e " SELECT ONE OF THE FOLLOWING TYPES TO BUILD : "
echo -e " 1.DIRTY"
echo -e " 2.CLEAN"
echo -n " YOUR CHOICE : ? "
read ch
echo -n " VERSION : ? "
read ver
case $ch in
1) echo -e "$cyan                            DIRTY $nocol"
   echo -e "$cyan                          BUILDING NOW ..$nocol"
   compile_kernel ;;
2) echo -e "$cyan                            CLEAN $nocol"
   echo -e "$cyan                          BUILDING NOW ..$nocol"
   make clean
   make mrproper
   compile_kernel ;;
*) device ;;
esac
echo -e "$blue                      ~COPYING FILES       $nocol  "
cp arch/arm64/boot/dt.img ~/phenex/tools
cp arch/arm64/boot/Image ~/phenex/tools
echo -e "$blue                        ~MAKING ZIP        $nocol  "
echo -e " Version : ?"
today=$(date +"-%Y%m%d-%H:%M")
zip -r Phenex_v$ver$today.zip *
mv *.zip ~/phenex_out
cd ~/phenex/tools/
rm -f dt.img
rm -f Image
}

phenex
BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
echo -e "$yellow BUILD SUCEEDED IN $(($DIFF / 60)) MINUTE(S) and $(($DIFF % 60)) SECONDS.$nocol"
cd ../.. && cd $KERNEL_OUT && ls
