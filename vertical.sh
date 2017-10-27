# Apache Software License 2 (ASL2)
# (sdake) Not my finest work ;)
# This script more or less keeps history intact by using git format-patch and git am
# to import multiple repositories into one repository.  Before the git am step, common
# paths are sed-ified to the correct monorepo location.

mkdir -p monorepo
pushd monorepo
git clone https://github.com/istio/istio
git clone https://github.com/istio/auth
git clone https://github.com/istio/api
git clone https://github.com/istio/proxy
git clone https://github.com/istio/mixer
git clone https://github.com/istio/pilot
git clone https://github.com/istio/broker
pushd auth
git format-patch -2000 -o ../auth-patches
popd
pushd api
git format-patch -2000 -o ../api-patches
popd
pushd proxy
git format-patch -2000 -o ../proxy-patches
popd
pushd mixer
git format-patch -2000 -o ../mixer-patches
popd
pushd pilot
git format-patch -2000 -o ../pilot-patches
popd
pushd broker
git format-patch -2000 -o ../broker-patches
popd
pushd auth-patches
sed -i -e 's/ a\// a\/auth\//g' *patch
sed -i -e 's/ b\// b\/auth\//g' *patch
popd
pushd api-patches
sed -i -e 's/ a\// a\/api\//g' *patch
sed -i -e 's/ b\// b\/api\//g' *patch
popd
pushd proxy-patches
rm -f 0330-Update_Dependencies-605.patch # empty file; confuses git am
sed -i -e 's/ a\// a\/proxy\//g' *patch
sed -i -e 's/ b\// b\/proxy\//g' *patch
popd
pushd mixer-patches
rm -f 0651-Update_Dependencies-1294.patch # empty file; confuses git am
sed -i -e 's/From: `W0131/From `W0131/g' 0168-Fix-config-manager-error-message.-215.patch # From: in comment confuses git am
sed -i -e 's/ a\// a\/mixer\//g' *patch
sed -i -e 's/ b\// b\/mixer\//g' *patch
popd
pushd pilot-patches
sed -i -e 's/ a\// a\/pilot\//g' *patch
sed -i -e 's/ b\// b\/pilot\//g' *patch
popd
pushd broker-patches
sed -i -e 's/ a\// a\/broker\//g' *patch
sed -i -e 's/ b\// b\/broker\//g' *patch
popd

pushd istio
git am ../auth-patches/*
git am ../api-patches/*
git am ../proxy-patches/*
git am ../pilot-patches/*
git am ../broker-patches/*
git am ../mixer-patches/*

popd # monorepo created
