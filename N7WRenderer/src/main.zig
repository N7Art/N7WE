const std = @import("std");

const lib = @import("N7WRenderer_lib");
const rl = @import("raylib");
pub fn main() !void {
    rl.initWindow(500, 500, "halo");
    defer rl.closeWindow();

    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();
        std.time.sleep(100_000_000);
        rl.clearBackground(rl.Color.blue);
    }
}
