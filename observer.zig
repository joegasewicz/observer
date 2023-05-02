// const Message = struct {
//     text: std.ArrayList(u8),

//     pub fn init(allocator: std.mem.Allocator) Message {
//         return .{ .text = std.ArrayList(u8).init(allocator) };
//     }
// };

// pub fn main() !void {
//     var ally = std.heap.page_allocator;
//     var message = Message.init(ally);
//     try message.text.appendSlice("Hello people");
//     // We can use the write interface in u8
//     var writer = message.text.writer();
//     try writer.print("Hello world, I have {d}", .{message.text.items.len});
//     // We can print this normaly
//     std.debug.print("{s}", .{message.text.items});
// }

// =====================================================================================

// const std = @import("std");

// const State = enum {
//     started,
//     completed,
//     failed,
// };

// const Message = struct {
//     text: []const u8,
// };

// const Observers = struct {
//     pub fn notify(subject: Observable) !void {
//         const stdout = std.io.getStdOut().writer();
//         try stdout.print("{}", .{subject});
//     }
// };

// const Observable = struct {
//     observers: std.BoundedArray(Observers, 100),
//     subject: ?*Observable,
//     msg: Message,

//     pub fn register(self: *Observable, observer: Observers) !void {
//         try self.observers.append(observer);
//     }

//     pub fn notify(self: Observable) !void {
//         if (self.observers) |obs| {
//             for (obs) |o| {
//                 try o.notify(self);
//             }
//         }
//     }

//     pub fn update(self: *Observable, message: Message) !void {
//         self.msg = message;
//         try self.notify();
//     }
// };

// pub fn main() !void {
//     const msg = Message{
//         .text = "hello!",
//     };
//     var subject: Observable = undefined;
//     subject.msg = msg;
//     try subject.register(Observers{});
//     try subject.update(.{.text="bye"});
// }

// =====================================================================================

const std = @import("std");
const stdout = std.io.getStdOut().writer();

const State = enum {
    started,
    completed,
    failed,
};

const Message = struct {
    text: ?[]const u8,
};

const Observers = struct {
    pub fn notify(subject: Observable) !void {
        try stdout.print("", .{subject});
    }
};

const Observable = struct {
    observers: ?[100]Observers,
    subject: ?*Observable,
    msg: Message,

    pub fn register(observer: Observable) !void {
        .observers ++ observer;
    }

    pub fn notify(self: Observable) !void {
        for (.observers) |o| {
            o.notify(self);
        }
    }

    pub fn update(self: *Observable, message: Message) !void {
        self.msg = message;
    }
};

pub fn main() !void {
    const msg = Message{
        .text = "hello!",
    };
    const subject = Observable{
        .msg = msg,
    };
    _ = subject;
}
