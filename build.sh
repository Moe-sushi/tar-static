rm /etc/resolv.conf
echo nameserver 1.1.1.1 > /etc/resolv.conf
echo https://dl-cdn.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories
apk add wget make clang git xz-dev libintl libbsd-static libsemanage-dev libselinux-utils libselinux-static xz-libs zlib zlib-static libselinux-dev linux-headers libssl3 libbsd libbsd-dev gettext-libs gettext-static gettext-dev gettext python3 build-base openssl-misc openssl-libs-static openssl zlib-dev xz-dev openssl-dev automake libtool bison flex gettext autoconf gettext sqlite sqlite-dev pcre-dev wget texinfo docbook-xsl libxslt docbook2x musl-dev gettext gettext-asprintf gettext-dbg gettext-dev gettext-doc gettext-envsubst gettext-lang gettext-libs gettext-static
apk add upx
mkdir output

git clone https://git.savannah.gnu.org/git/gzip
cd gzip
./bootstrap
./configure LDFLAGS="-static -Wl,--gc-sections -ffunction-sections -fdata-sections" --enable-static --disable-shared
make -j8 LDFLAGS="--static -Wl,--gc-sections -ffunction-sections -fdata-sections"
strip gzip
upx gzip
cp gzip ../output/
cp COPYING ../output/LICENSE-gzip

# OK
cd ..
git clone https://github.com/xz-mirror/xz
cd xz
autoreconf -fi
./autogen.sh
./configure LDFLAGS="-static -Wl,--gc-sections -ffunction-sections -fdata-sections" --enable-static --disable-shared
make -j8 LDFLAGS="--static -Wl,--gc-sections -ffunction-sections -fdata-sections"
strip src/xz/xz
upx src/xz/xz
cp src/xz/xz ../output/
cp COPYING ../output/LICENSE-xz

# OK
cd ..
git clone https://git.savannah.gnu.org/git/tar
cd tar
./bootstrap
FORCE_UNSAFE_CONFIGURE=1 ./configure LDFLAGS="-static -Wl,--gc-sections -ffunction-sections -fdata-sections" --enable-static --disable-shared --with-gzip=gzip --with-xz=xz
make -j8 LDFLAGS="--static -Wl,--gc-sections -ffunction-sections -fdata-sections"
strip src/tar
upx src/tar
cp src/tar ../output/
cp COPYING ../output/LICENSE-tar
cd ..
cd output
tar -cvf ../$(uname -m).tar .
exit 0
