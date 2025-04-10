const std = @import("std");

const lib = @import("N7WRenderer_lib");
const rl = @import("raylib");


pub fn main() !void {
    const gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();
    defer allocator.destroy

    const window: lib.Window = .{ .width = 500, .height = 500, .title = "halo" };
    
    const text = "halo";

    lib.drawText(window, text);
    
}
