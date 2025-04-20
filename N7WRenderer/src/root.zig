const std = @import("std");
const rl = @import("raylib");

pub const Window = struct {
    width: i32,
    height: i32,
    title: [:0]const u8,
};

pub const Container = struct {
    posX: i32,
    posY: i32,
    width: i32,
    height: i32,
    border: struct {
        width: i32,
        color: rl.Color,
    } = .{
        .width = 1,
        .color = .white,
    },
    color: rl.Color,
    children: ?Text,
};

pub const Text = struct {
    text: [:0]const u8,
    font_size: i32 = 14,
    color: rl.Color = rl.Color.black,
    posX: i32 = 0,
    posY: i32 = 0,
    glyph_spacing: i32 = 2,
    line_spacing: i32 = 0,
    dims: struct { width: i32, height: i32 } = undefined,
    font: rl.Font,

    pub fn init(self: Text, text:[:0]u8, font:rl.Font,  ) void {
        self.dims = self.calculateDimentions();
        self.text = text;
        self.font = font;
    }

    /// calculates text 2D
    pub fn calculateDimentions(self: Text) struct { width: i32, height: i32 } {
        var char_counter_max: i32 = 0;
        var char_counter: i32 = 0;
        var line_counter: i32 = 0;

        for (self.text) |ch| {
            char_counter += 1;
            if (ch == '\n') {
                line_counter += 1;

                if (char_counter > char_counter_max) {
                    char_counter_max = char_counter;
                }
                char_counter = 0;
            }
        }


        //measureTextEx is not working propperly
        const w: i32 = @intFromFloat(rl.measureTextEx(self.font, self.text, @floatFromInt(self.font_size), @floatFromInt(self.glyph_spacing)).x);
        const h: i32 = ((self.font.baseSize + self.line_spacing) * line_counter);

        return .{
            .width = w,
            .height = h,
        };
    }
};

pub fn drawText(text: Text) !void {
    rl.setTextLineSpacing(text.line_spacing);
    rl.drawTextEx(
        text.font,
        text.text,
        rl.Vector2{
            .x = @floatFromInt(text.posX),
            .y = @floatFromInt(text.posY),
        },
        @floatFromInt(text.font_size),
        @floatFromInt(text.glyph_spacing),
        text.color,
    );
}

pub fn drawContainer(container: Container) !void {
    rl.drawRectangle(
        container.posX,
        container.posY,
        container.width + container.border.width * 2,
        container.height + container.border.width * 2,
        container.border.color,
    );

    const border = container.border;
    const inner: struct {
        x: i32,
        y: i32,
        w: i32,
        h: i32,
    } = .{
        .x = container.posX + border.width,
        .y = container.posY + container.border.width,
        .w = container.width,
        .h = container.height,
    };

    rl.drawRectangle(
        inner.x,
        inner.y,
        inner.w,
        inner.h,
        container.color,
    );
    const child = container.children;
    var txt = child.?;

    txt.posX = inner.x;
    txt.posY = inner.y;
    try drawText(txt);
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
