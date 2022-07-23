const std = @import("std");

pub fn main() anyerror!void {
  // Note that info level log messages are by default printed only in Debug
  // and ReleaseSafe build modes.
  var p:[std.crypto.hash.sha2.Sha256.digest_length]u8 = undefined;
  var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
  defer arena.deinit();
  const allocator = arena.allocator();

  std.crypto.hash.sha2.Sha256.hash(
    try input(allocator,2048),
    &p,
    .{}
  );
  
  try std.io.getStdOut().writeAll(
    try std.fmt.allocPrint(
      allocator,
      "{x}",
      .{std.fmt.fmtSliceHexLower(@as([]u8,p[0..]))}
    )
  );
}

fn input(allocator: std.mem.Allocator, max_size: usize) ![]u8 {
  const stdin = std.io.getStdIn().reader();
  var res = try stdin.readUntilDelimiterOrEofAlloc(allocator,'\n',max_size);
  return res orelse return "";
}