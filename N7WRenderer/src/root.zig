const std = @import("std");
const rl = @import("raylib");

pub const Window = struct {
    width: i32,
    height: i32,
    title: [:0]const u8,
};

pub fn drawText(window: Window, text: [:0]const u8) void {
    rl.initWindow(window.width, window.height, window.title);
    defer rl.closeWindow();

    rl.setTargetFPS(10);
    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();
        std.time.sleep(100_000_000);
        rl.clearBackground(rl.Color.blue);
        rl.drawText(text, 200, 220, 66, .black);
    }
}
