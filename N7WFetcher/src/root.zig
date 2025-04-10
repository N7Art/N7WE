const std = @import("std");
const http = std.http;

/// needs to be freed
pub fn GET(allocator: std.mem.Allocator ,url: []const u8) ![]const u8 {

    var client = http.Client{ .allocator = allocator };
    defer client.deinit();

    const uri = try std.Uri.parse(url);
    const buf = try allocator.alloc(u8, 1024 * 1024 * 4);
    defer allocator.free(buf);

    var req = try client.open(.GET, uri, .{
        .server_header_buffer = buf,
    });

    defer req.deinit();
    try req.send();
    try req.finish();
    try req.wait();

    try std.testing.expectEqual(req.response.status, .ok);

    var rdr = req.reader();
    const body = try rdr.readAllAlloc(allocator, 1024 * 1024 * 4);
    return body;
}

pub fn get_url_from_cmd(allocator: std.mem.Allocator) []const u8 {
    var argsIterator = try std.process.ArgIterator.initWithAllocator(allocator);
    defer argsIterator.deinit();

    //skip first
    _ = argsIterator.next();

    if (argsIterator.next()) |text| {
        return text;
    } else {
        return "http://example.com";
    }
}
