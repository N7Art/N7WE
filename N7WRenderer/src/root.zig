const std = @import("std");
const rl = @import("raylib");

pub const Window = struct {
    width: i32,
    height: i32,
    title: [:0]const u8,
};

pub const Text = struct {
    text: [:0]const u8,
    fontSize: i32 = 14,
    color: rl.Color = rl.Color.black,
    posX: i32 = 0,
    posY: i32 = 0,
};

pub fn drawText(window: Window, text: Text) void {
    rl.initWindow(window.width, window.height, window.title);
    defer rl.closeWindow();

    rl.setTargetFPS(10);
    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();
        std.time.sleep(100_000_000);
        rl.clearBackground(rl.Color.blue);
        rl.drawText(text.text, text.posX, text.posY, text.fontSize, text.color);
    }
}
pub fn getFileContent(path: []const u8) ![:0]u8 {
    const file: std.fs.File = try std.fs.cwd().openFile(path, .{});
    defer file.close();

    var vbuf: [1024 * 1024 * 4]u8 = undefined;
    const s = try file.readAll(&vbuf);
    vbuf[s] = 0;

    const buf = vbuf[0..s :0];
    return buf;
}
