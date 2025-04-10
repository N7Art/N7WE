const lib = @import("N7WFetcher_lib");

const std = @import("std");

pub fn main() !void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const url = lib.get_url_from_cmd(allocator);

    const resp: []const u8 = try lib.GET(allocator, url);
    defer allocator.free(resp);

    const file = try std.fs.cwd().createFile("../tmp/index.html", .{ .read = true });
    defer file.close();
    try write(&file, resp);
}
fn write(file: *const std.fs.File, text: []const u8) !void {
    try file.writeAll(text);
}


