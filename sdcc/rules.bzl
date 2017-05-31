def label_scoped_path(ctx, path):
  """Return the path scoped to target's label."""
  return ctx.label.name + "/" + path.lstrip("/")

def _get_deps_attr(ctx, attr):
  """Returns the merged set of the given attribute from deps."""
  deps = set()
  for x in ctx.attr.deps:
    deps += getattr(x.stm8, attr)
  return deps

def _sdcc_compile_impl(ctx):
    output_objs = []
    output_objs_link = []
    objs_outputs_path = label_scoped_path(ctx, "_objs/")

    for source in ctx.files.srcs:
	basename = source.basename.rpartition('.')[0]
        obj = ctx.new_file(objs_outputs_path + basename + ".rel")
	obj_link = ctx.new_file(objs_outputs_path + basename + ".lst")
	action_inputs = [source]
	action_inputs.extend(ctx.files.hdrs)
	action_inputs.extend(ctx.files._compiler_support)
	action_inputs.extend(ctx.files._compiler_include)
	action_inputs.extend(list(_get_deps_attr(ctx, "hdrs")))
	ctx.action(outputs = [obj, obj_link],
            inputs = action_inputs,
	    mnemonic = "CompileSTM8Source",
            executable = ctx.executable._compiler,
            arguments = ["-V", "-mstm8", "-c", "--std-c99", "-DSTM8S207", source.path, "-o", obj.path],
            )
	output_objs.append(obj)
	output_objs_link.append(obj_link)

    return struct(
        stm8 = struct(
	    hdrs = set(ctx.files.hdrs),
	    obj = set(output_objs),
	    link = set(output_objs_link)
	),
        files=depset(output_objs))



_sdcc_compile_attrs = {
    "srcs": attr.label_list(allow_files = [".c", ".cpp", ".cc"]),
    "hdrs": attr.label_list(allow_files = [".h", ".hpp", ".hh"]),
    "deps": attr.label_list(),
    "defines": attr.string_list(mandatory=False, allow_empty=True),
    "copts": attr.string_list(mandatory=False, allow_empty=True),
    "_compiler": attr.label(
        default = Label("@net_sourceforge_sdcc//:sdcc_compiler"),
	executable = True,
	allow_single_file = True,
	cfg = 'host',
    ),
    "_compiler_support": attr.label(
        allow_files = True,
        cfg = 'host',
	default = Label("@net_sourceforge_sdcc//:sdcc_compiler_support"),
    ),
    "_compiler_include": attr.label(
        allow_files = True,
        cfg = 'host',
        default = Label("@net_sourceforge_sdcc//:sdcc_compiler_include"),
    ),
}

def _stm8_binary_impl(ctx):
   obj_files = _get_deps_attr(ctx, "obj")
   link_files = _get_deps_attr(ctx, "link")
   print(obj_files)
   link_output = ctx.new_file(ctx.label.name + ".ihx")
   link_arguments = ["-V", "-mstm8", "--std-c99"]
   link_arguments.extend([x.path for x in obj_files])
   link_arguments.extend(["-o", link_output.path])

   print(link_arguments)
   action_inputs = list(obj_files)
   action_inputs.extend(list(link_files))
   action_inputs.extend(ctx.files._compiler_support)
   action_inputs.extend(ctx.files._compiler_include)

   ctx.action(
       inputs = action_inputs,
       outputs = [link_output],
       mnemonic = "LinkSTM8Binary",
       executable = ctx.executable._compiler,
       arguments = link_arguments
   )

   hex_output = ctx.new_file(ctx.label.name + ".hex")
   other_action_inputs = list([link_output])
   other_action_inputs.extend(ctx.files._compiler_support)
   ctx.action(
       inputs = other_action_inputs,
       outputs = [hex_output],
       mnemonic = "PackSTM8Hex",
       command = "{} {} > {}".format(ctx.executable._pack_ihx.path, link_output.path, hex_output.path)
   )

   return struct(files=set([hex_output]))

stm8_library = rule(
    implementation = _sdcc_compile_impl,
    attrs = _sdcc_compile_attrs,
)

stm8_binary = rule(
    implementation = _stm8_binary_impl,
    attrs = {
    "_compiler": attr.label(
        default = Label("@net_sourceforge_sdcc//:sdcc_compiler"),
	executable = True,
	allow_single_file = True,
	cfg = 'host',
    ),
    "_pack_ihx": attr.label(
        allow_single_file = True,
	cfg = 'host',
	executable = True,
	default = Label("@net_sourceforge_sdcc//:sdcc_packihx"),
    ),
    "_compiler_support": attr.label(
        allow_files = True,
        cfg = 'host',
	default = Label("@net_sourceforge_sdcc//:sdcc_compiler_support"),
    ),
    "_compiler_include": attr.label(
        allow_files = True,
        cfg = 'host',
        default = Label("@net_sourceforge_sdcc//:sdcc_compiler_include"),
    ),
    "deps": attr.label_list(providers = [["stm8"]])
    }
)

SDCC_BUILD = """
package(default_visibility = ["//visibility:public"])

filegroup(
    name = "sdcc_compiler",
    srcs = ["bin/sdcc"],
)

filegroup(
    name = "sdcc_packihx",
    srcs = ["bin/packihx"],
)

filegroup(
    name = "sdcc_compiler_support",
    srcs = glob([
        "bin/**/*",
	"share/**/*",
    ]),
)

filegroup(
    name = "sdcc_compiler_include",
    srcs = glob([
        "share/sdcc/include/**/*",
	"share/sdcc/non-free/include/**/*",
    ]),
)
"""

def sdcc_repositories():
    native.new_http_archive(
        name = "net_sourceforge_sdcc",
        url = "https://ufpr.dl.sourceforge.net/project/sdcc/sdcc-linux-x86/3.6.0/sdcc-3.6.0-i386-unknown-linux2.5.tar.bz2",
        sha256 = "af62404eff85c6d3c86a49b4eae50e8dc0677ab9fd52ee15dcf0281cd9e581ee",
        build_file_content = SDCC_BUILD,
        strip_prefix = "sdcc-3.6.0",
    )

