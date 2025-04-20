const std = @import("std");
const rl = @import("raylib");

pub const ChildTypes = enum { text, container };

pub const Window = struct {
    width: i32,
    height: i32,
    title: [:0]const u8,
};

pub const Container = struct {
    posX: i32 = 0,
    posY: i32 = 0,
    width: i32,
    height: i32,
    border: Border = .{
        .width = 1,
        .color = .white,
    },
    color: rl.Color,
    parent: ?*Container = null,
    children: ?union(ChildTypes) { text: *Text, container: *const Container } = null,

    const Border = struct {
        width: i32,
        color: rl.Color,
    };
};

pub const Text = struct {
    text: [:0]const u8,
    font_size: i32 = 14,
    color: rl.Color = rl.Color.black,
    posX: i32 = 0,
    posY: i32 = 0,
    glyph_spacing: i32 = 1,
    line_spacing: i32 = 0,
    dims: struct { width: i32, height: i32 } = undefined,
    font: rl.Font,

    pub fn init(text: [:0]u8, font: rl.Font, color: rl.Color) Text {
        var new: Text = .{
            .text = text,
            .font = font,
            .color = color,
            .font_size = font.baseSize,
        };
        const dims = calculateDimentions(new);
        new.dims = .{ .height = dims.height, .width = dims.width };
        return new;
    }

    /// calculates text 2D params
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
        const measure = rl.measureTextEx(
            self.font,
            self.text,
            @floatFromInt(self.font_size),
            @floatFromInt(self.glyph_spacing),
        );

        const w: i32 = @intFromFloat(
            measure.x,
        );
        //measureTextEx .y is not working propperly
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

pub fn drawBorders(dementions: struct { x: f32, y: f32, w: f32, h: f32 }, border: Container.Border) void {
    const x = dementions.x;
    const y = dementions.y;
    const w = dementions.w;
    const h = dementions.h;
    const bw: f32 = @floatFromInt(border.width);
    const bc = border.color;
    //left
    rl.drawLineEx(
        .{ .x = x + bw/2, .y = y },
        .{ .x = x + bw/2, .y = y + h + bw * 2 },
        bw,
        bc
    );
    //top
    rl.drawLineEx(
        .{ .x = x + bw , .y = y + bw/2 },
        .{ .x = x + w + bw * 2, .y = y + bw/2 },
        bw,
        bc
    );
    //right
    rl.drawLineEx(
        .{ .x = x + w + bw*1.5, .y = y + bw },
        .{ .x = x + w + bw*1.5, .y = y + h + bw * 2 },
        bw,
        bc
    );
    //bottom
    rl.drawLineEx(
        .{ .x = x + w + bw, .y = y + h + bw*1.5 },
        .{ .x = x + bw, .y = y + h + bw * 1.5 },
        bw,
        bc
    );
}

pub fn drawContainer(container: *const Container) !void {
    drawBorders(
        .{
            .x = @floatFromInt(container.posX),
            .y = @floatFromInt(container.posY),
            .w = @floatFromInt(container.width),
            .h = @floatFromInt(container.height),
        },
        .{
            .width = container.border.width,
            .color = container.border.color,
        },
    );

    const border = container.border;
    const inner: struct {
        x: i32,
        y: i32,
        w: i32,
        h: i32,
    } = .{
        .x = container.posX + border.width,
        .y = container.posY + border.width,
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

    const ch = container.children;
    if (ch == null) {
        std.debug.print("{s}", .{"\n\nno child\n\n"});
        return;
    }

    switch (ch.?) {
        .container => |child_container| {
            std.debug.print("{s}", .{"\n\ncontainer type child\n\n"});
            var tmp = child_container.*;
            tmp.posX += inner.x;
            tmp.posY += inner.y;

            try drawContainer(&tmp);
        },

        .text => |txt| {
            std.debug.print("{s}", .{"\n\ntext type child\n\n"});
            txt.posX = inner.x;
            txt.posY = inner.y;
            try drawText(txt.*);
        },
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
