mkdir -p ~/.local/bin
export PATH=~/.cargo/bin:~/.local/bin:$PATH

# install Rust
curl https://sh.rustup.rs -sSf | sh -s -- -y --no-modify-path --default-toolchain nightly
rustc --version

# install verion of Meson that is compatible with UxAS build
curl -L -s https://github.com/GaloisInc/meson/archive/0.47-rust-depfile.zip -o meson.zip
unzip -q meson.zip
pushd meson-0.47-rust-depfile; python3.6 setup.py install --user; popd
meson --version

# download newer Ninja than is packaged in repos
curl -L -s https://github.com/ninja-build/ninja/releases/download/v1.7.2/ninja-linux.zip -o ninja.zip
unzip -q ninja.zip
mv ninja ~/.local/bin
ninja --version

# clone, build, and run LmcpGen
git clone https://github.com/afrl-rq/LmcpGen.git ../LmcpGen
pushd ../LmcpGen; ant jar; popd
sh RunLmcpGen.sh

# process the wraps and their patches
./prepare

RUST_BACKTRACE=1 cargo build -vv -j 2

# # build with -j2; Travis has 2 "cores"
# meson build
# ninja -C build -j2
# # run test suite with *2 timeout multiplier, because Travis can be slow
# meson test -C build -t 2
