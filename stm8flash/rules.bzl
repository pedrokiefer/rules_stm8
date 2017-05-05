
def stm8flash_repositories():
    native.new_git_repository(
        name = "info_libusb_libusb",
        remote = "https://github.com/libusb/libusb.git",
	tag = "v1.0.21",
	build_file = str(Label("//stm8flash:libusb.BUILD"))
    )
    native.new_git_repository(
        name = "com_github_vdudouyt_stm8flash",
        remote = "https://github.com/vdudouyt/stm8flash.git",
	commit = "3478232632147e59497b4292a4e373338a687152",
	build_file = str(Label("//stm8flash:stm8flash.BUILD"))
    )
