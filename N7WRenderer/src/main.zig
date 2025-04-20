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

    const text: lib.Text = .{
        .text = buf,
        .font = font,
        .color = .white,
        .font_size = font.baseSize,
        .glyph_spacing = 1,
        .line_spacing = 0,
    };
        const dims = text.calculateDimentions();

        const container: lib.Container = .{
            .posX = 8,
            .posY = 8,
            .color = .{.r = 50, .b = 50, .g = 50, .a=255 },
            .height = dims.height,
            .width = dims.width,
            .children =   text,

            .border = .{ .width = 1, .color = .white },
        };
    while (!rl.windowShouldClose()) {
        rl.beginDrawing();
        defer rl.endDrawing();
        std.time.sleep(100_000_000);
        rl.clearBackground(rl.Color.black);
        try lib.drawContainer(container);
    }
}

test "test" {}
