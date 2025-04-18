const std = @import("std");

const lib = @import("N7WRenderer_lib");
const rl = @import("raylib");

pub fn main() !void {

    const window: lib.Window = .{ .width = 1000, .height = 1000, .title = "halo" };

const buf = try lib.getFileContent("../tmp/index.html");
    const text: lib.Text = .{ .text = buf };
    lib.drawText(window, text);
}

test "test" {}
