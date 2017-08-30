import platform
from shutil import copy2


class AndroidPlatform:
    def __init__(self, abi, cpu='', arch='', toolchain='', toolchain_exec=''):
        self.abi = abi
        self.cpu = cpu
        self.arch = arch
        self.toolchain = toolchain
        self.toolchain_exec = toolchain_exec

        if not self.cpu:
            self.cpu = self.abi

        if not self.arch:
            self.arch = self.cpu

        if not self.toolchain:
            self.toolchain = self.arch + '-linux-android'

        if not self.toolchain_exec:
            self.toolchain_exec = self.toolchain


all_platform = [
    AndroidPlatform('armeabi-v7a', cpu='arm', toolchain='arm-linux-androideabi'),
    AndroidPlatform('arm64-v8a', cpu='arm64', arch='aarch64'),
    AndroidPlatform('x86', toolchain='x86', toolchain_exec='i686-linux-android'),
    AndroidPlatform('x86_64', toolchain='x86_64', toolchain_exec='x86_64-linux-android'),
]

toolchain_version = '4.9'
android_platform = '23'

if __name__ == '__main__':
    system, _, _, _, arch, _ = platform.uname()
    is64 = arch == 'x86_64'
    enablePIE = int(android_platform) >= 16
    x86_disable_asm = int(android_platform) >= 23

    if system == 'Darwin':
        host = 'darwin-' + arch
    else:
        raise Exception('Unsupported host!')

    copy2('build.sh', 'build_gen.sh')
    with open('build_gen.sh', 'a') as f:
        f.write('HOST={}\n'.format(host))
        f.write('TOOLCHAIN_VERSION={}\n'.format(toolchain_version))
        f.write('PLATFORM={}\n\n'.format(android_platform))

        # if enablePIE:
        #     f.write('ADDI_CFLAGS=-fPIE\n')
        #     f.write('ADDI_LDFLAGS="-fPIE -pie"\n\n')

        for p in all_platform:
            f.write('OUT={}\n'.format(p.abi))
            f.write('CPU={}\n'.format(p.cpu))
            f.write('ARCH={}\n'.format(p.arch))
            f.write('TOOLCHAIN={}\n'.format(p.toolchain))
            f.write('TOOLCHAIN_EXEC={}\n'.format(p.toolchain_exec))
            if p.cpu == 'arm':
                f.write('ADDI_CFLAGS=-marm\n')
            else:
                f.write('ADDI_CFLAGS=\n')

            if x86_disable_asm:
                if p.cpu == 'x86':
                    f.write('ADDITIONAL_CONFIGURE_FLAG=--disable-asm\n')
                else:
                    f.write('ADDITIONAL_CONFIGURE_FLAG=\n')
            f.write('build_one\n\n')
