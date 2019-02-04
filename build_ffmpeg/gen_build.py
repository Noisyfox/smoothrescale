import platform
from shutil import copy2


class AndroidPlatform:
    def __init__(self, abi, cpu='', arch='', toolchain='', toolchain_exec='', addi_cflags=[], addi_ldflags=[], addi_confflags=[]):
        self.abi = abi
        self.cpu = cpu
        self.arch = arch
        self.toolchain = toolchain
        self.toolchain_exec = toolchain_exec
        self.addi_cflags = addi_cflags
        self.addi_ldflags = addi_ldflags
        self.addi_confflags = addi_confflags

        if not self.cpu:
            self.cpu = self.abi

        if not self.arch:
            self.arch = self.cpu

        if not self.toolchain:
            self.toolchain = self.arch + '-linux-android'

        if not self.toolchain_exec:
            self.toolchain_exec = self.toolchain

toolchain_version = '4.9'
android_platform = '24'

enablePIE = int(android_platform) >= 16
x86_disable_asm = int(android_platform) >= 23

all_platform = [
    AndroidPlatform('armeabi-v7a', cpu='arm', toolchain='arm-linux-androideabi', addi_cflags=['-marm'], addi_confflags=['--disable-neon']),
    AndroidPlatform('arm64-v8a', cpu='arm64', arch='aarch64'),
    AndroidPlatform('x86', toolchain='x86', toolchain_exec='i686-linux-android', addi_confflags=['--disable-asm'] if x86_disable_asm else []),
    AndroidPlatform('x86_64', toolchain='x86_64', toolchain_exec='x86_64-linux-android'),
]

common_cflags = ['-fPIE', '-fPIC'] if enablePIE else []
common_ldlags = ['-pie'] if enablePIE else []

if __name__ == '__main__':
    copy2('build.sh', 'build_gen.sh')
    with open('build_gen.sh', 'a') as f:
        f.write('TOOLCHAIN_VERSION={}\n'.format(toolchain_version))
        f.write('PLATFORM={}\n\n'.format(android_platform))

        for p in all_platform:
            f.write('OUT={}\n'.format(p.abi))
            f.write('CPU={}\n'.format(p.cpu))
            f.write('ARCH={}\n'.format(p.arch))
            f.write('TOOLCHAIN={}\n'.format(p.toolchain))
            f.write('TOOLCHAIN_EXEC={}\n'.format(p.toolchain_exec))

            # Write CFLAGS
            cflags = ' '.join(common_cflags + p.addi_cflags)
            f.write('ADDI_CFLAGS="{}"\n'.format(cflags))

            # Write LDFLAGS
            ldflags = ' '.join(common_ldlags + p.addi_ldflags)
            f.write('ADDI_LDLAGS="{}"\n'.format(ldflags))

            # Write ADDITIONAL_CONFIGURE_FLAG
            confflags = ' '.join(p.addi_confflags)
            f.write('ADDITIONAL_CONFIGURE_FLAG="{}"\n'.format(confflags))

            f.write('build_one\n\n')
