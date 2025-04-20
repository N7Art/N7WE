const std = @import("std");

const lib = @import("N7WRenderer_lib");
const rl = @import("raylib");

pub fn main() !void {
    const window: lib.Window = .{ .width = 1000, .height = 1000, .title = "halo" };

    const buf = try lib.getFileContent("../tmp/index.html");

    rl.initWindow(window.width, window.height, window.title);
    defer rl.closeWindow();
    rl.setTargetFPS(10);

    const font: rl.Font = try rl.loadFontEx("../tmp/font/font.ttf", 16, null);
    defer rl.unloadFont(font);

    const text = lib.Text.init(buf, font, .white);

    const dims = text.dims;
    const mini_container: lib.Container = .{
        .children = .{ .text = @constCast(&text) },
        
        .color = .{ .r = 50, .b = 50, .g = 50, .a = 255 },
        .posX = 8,
        .posY = 8,
        .height = dims.height,
        .width = dims.width,
        .border = .{ .color = .red, .width = 2 },
    };
    const container: lib.Container = .{
        .posX = 8,
        .posY = 8,
        .color = .{ .r = 0, .b = 0, .g = 0, .a = 255 },
        .height = mini_container.height + mini_container.posY + mini_container.border.width*2,
        .width = mini_container.width + mini_container.posX + mini_container.border.width*2,
        .children = .{ .container = &mini_container },
        .border = .{ .width = 3, .color = .white },
    };
    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();
        std.time.sleep(100_000_000);
        rl.clearBackground(rl.Color.black);
        try lib.drawContainer(&container);
    }
}

test "test" {}
