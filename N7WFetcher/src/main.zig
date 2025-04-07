const lib = @import("N7WFetcher_lib");

const std = @import("std");

pub fn main() !void {
    const url = lib.get_url_from_cmd();
    try lib.GET(url) ;
}
