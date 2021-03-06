#!/bin/bash

function usage {
    echo >&2 "usage: $0 [hostname (default:hiro014)]"
    echo >&2 "          [-h|--help] print this message"
    exit 0
}

# command line parse
OPT=`getopt -o h -l help -- $*`
if [ $? != 0 ]; then
    usage
fi

eval set -- $OPT

while [ -n "$1" ] ; do
    case $1 in
        -h|--help) usage ;;
        --) shift; break;;
        *) echo "Unknown option($1)"; usage;;
    esac
done

## Comment out; not used.
#address=`host hrpsys-base.googlecode.com | awk '/^[[:alnum:].-]+ has address/ { print $4 ; exit }'` # this does not work for  Server certificate verification 

PID=28169

wget https://raw.github.com/start-jsk/hrpsys/master/package.xml -O /tmp/hrpsys-package.xml
HRPSYS_VERSION=`sed -n 's@\s*<version>\(.*\)</version>@\1@p' /tmp/hrpsys-package.xml`
(cd ../; tar -cvzf /tmp/hironx-robot-script-$PID.tgz robot/Makefile robot/*.in robot/*.sav)


commands="
  . ~/.profile;
  env;
  echo \"* Download hrpsys *\";
  mkdir -p /tmp/hrpsys-source-$PID/src;
  cd /tmp/hrpsys-source-$PID/src;
  svn co http://hrpsys-base.googlecode.com/svn/tags/${HRPSYS_VERSION} hrpsys-base-source-${HRPSYS_VERSION};
  echo \"* Configure hrpsys *\";
  cd hrpsys-base-source-${HRPSYS_VERSION};
  PATH=/opt/jsk/bin:/usr/pkg/bin:/usr/qnx650/host/qnx6/x86/usr/bin:$PATH LD_LIBRARY_PATH=/opt/jsk/lib:/usr/pkg/lib PKG_CONFIG_PATH=/opt/jsk/lib/pkgconfig:/usr/pkg/lib/pkgconfig CXX=QCC CC=qcc TVMET_DIR=/opt/jsk OPENRTM_IDL_DIR=/opt/jsk/include/OpenRTM-1.1/rtm/idl LDFLAGS=\"-L/usr/pkg/lib -lboost_system -lboost_signals -lboost_thread -lboost_filesystem\" cmake . -DLAPACK_LIBRARY_DIRS=/opt/jsk/lib -DLAPACK_INCLUDE_DIRS=/opt/jsk/include -DOPENRTM_DIR=/opt/jsk -DOPT_COLLADASUPPORT=NO -DEIGEN_INCLUDE_DIR=/opt/jsk/include -DCOMPILE_JAVA_STUFF=OFF -DCMAKE_SHARED_LINKER_FLAGS=\"-L/usr/pkg/lib -lboost_system -lboost_signals -lboost_filesystem -lboost_thread -lboost_regex -lf2c -Wl,-u,MAIN__\" -DCMAKE_EXE_LINKER_FLAGS=\"-L/usr/pkg/lib -lboost_system -lboost_signals -lboost_thread -lboost_filesystem -lboost_regex -lf2c -Wl,-u,MAIN__\" -DCMAKE_MODULE_LINKER_FLAGS=\"-L/usr/pkg/lib -lboost_system -lboost_signals -lboost_filesystem -lboost_thread -lboost_regex -lf2c -Wl,-u,MAIN__\" -DCMAKE_INSTALL_PREFIX=../ -DBLAS_LIBRARY=/opt/jsk/lib/libblas.so -DLAPACK_LIBRARY=/opt/jsk/lib/liblapack.so -DG2C_LIBRARY=/opt/jsk/lib/libf2c.so -DCMAKE_CXX_FLAGS=\"-I/usr/pkg/include\" -DCMAKE_INSTALL_PREFIX=../../ -DENABLE_DOXYGEN=OFF ;
  echo \"* Compile hrpsys *\";
  PATH=/opt/jsk/bin:/usr/pkg/bin:/usr/qnx650/host/qnx6/x86/usr/bin:$PATH LD_LIBRARY_PATH=/opt/jsk/lib:/usr/pkg/lib:/usr/qnx650/host/qnx6/x86/usr/lib make VERBOSE=1;
  make install;
  echo \"* Modify codes *\";
  cd /tmp;
  rm hrpsys-source-$PID/lib/libhrpIo.so;
  (cd /tmp/hrpsys-source-$PID; sed -i s@/tmp/hrpsys-source-$PID@/opt/jsk@g bin/hrpsyspy lib/pkgconfig/hrpsys-base.pc share/hrpsys/samples/*/*.{conf,xml,sh};);
  echo \"* Configure robot script files  *\";
  tar -xkvzf /tmp/hironx-robot-script-$PID.tgz;
  cd robot;
  make configure;
  make install INSTALL_DIR=/tmp/hrpsys-source-$PID;
  cd ..;
  echo \"* make tarball *\";
  tar -C hrpsys-source-$PID  -czf hrpsys-qnx-${HRPSYS_VERSION}.tgz ./;
  "

hostname=$1
hostname=${hostname:="hiro014"} 
userid=$2
userid=${userid:="hiro"} 
echo "comands = $commands"
read -p "execute compile command @ $hostname (y/n)?"
if [ "$REPLY" == "y" ]; then
    scp /tmp/hironx-robot-script-$PID.tgz $userid@$hostname:/tmp/
    ssh $userid@$hostname -t $commands 2>&1 | tee /tmp/robot-compile-hrpsys-`date +"%Y%m%d-%H%M%S"`.log
    echo "====="
    echo "$ cd /opt/jsk"
    echo "$ tar -xvzf /tmp/hrpsys-qnx-${HRPSYS_VERSION}.tgz"
else
    echo "DO NOT RUN"
    echo "----"
    echo "$commands"
    echo "----"
    echo "EXITTING.."
fi

