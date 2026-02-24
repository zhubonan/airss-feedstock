#!/usr/bin/env bash

set -ex

LIBS="-llapack -lblas $PWD/lib/libsymspg.a"

make \
  FC="$FC" \
  FFLAGS="$FFLAGS" \
  CC="$CC" \
  CFLAGS="$CFLAGS" \
  LDFLAGS="$LDFLAGS $LIBS" \
  all

airss_bin="${PREFIX}/libexec/airss"
mkdir -p "${airss_bin}"

cp -v \
  src/pp3/src/pp3 \
  src/cabal/src/cabal \
  src/buildcell/src/buildcell \
  src/cryan/src/cryan \
  bin/* \
  "${airss_bin}"

mkdir -p "${PREFIX}/bin"
sed "s;@PREFIX@;${PREFIX};g" "${RECIPE_DIR}/scripts/airss.sh" > "${PREFIX}/bin/airss"
chmod +x "${PREFIX}/bin/airss"

# Exposed limited set of the executables
for bin in $(cat ${RECIPE_DIR}/airss-tools.txt)
do
  cat > ${PREFIX}/bin/${bin} <<EOF
#!/usr/bin/env bash
exec "${PREFIX}/libexec/airss/${bin}" "\$@"
EOF
  chmod +x ${PREFIX}/bin/${bin}
done
