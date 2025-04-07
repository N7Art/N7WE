const std = @import("std");

const lib = @import("N7WRenderer_lib");

const c = @cImport({
    @cInclude("fcntl.h");
    @cInclude("unistd.h");
    @cInclude("sys/ioctl.h");
    @cInclude("drm/drm.h");
    @cInclude("drm/drm_mode.h");
});
pub fn main() !void {
    const stdout = std.io.getStdOut().writer();
    const path = "/dev/dri/card0";
    const fd = try std.os.linux.open(path, c.O_RDWR, 0);
    defer std.os.linux.close(fd);

    var resources = c.struct_drm_mode_card_res{
        .fb_id_ptr = 0,
        .crtc_id_ptr = 0,
        .connector_id_ptr = 0,
        .encoder_id_ptr = 0,
        .count_fbs = 0,
        .count_crtcs = 0,
        .count_connectors = 0,
        .count_encoders = 0,
        .min_width = 0,
        .max_width = 0,
        .min_height = 0,
        .max_height = 0,
    };

    if (c.ioctl(fd, c.DRM_IOCTL_MODE_GETRESOURCES, &resources) < 0) { return error.GetResourcesFailed;}
    stdout.print("connectors count: {}\n", .{resources.count_connectors}); 

    if (resources.count_connectors == 0) {return;}

    const allocator = std.heap.page_allocator;
    const size = @as(usize, @intCast( resources.count_connectors)) * @sizeOf(c.uint32_t);

}
