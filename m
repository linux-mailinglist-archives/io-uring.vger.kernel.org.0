Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5550E1B36C4
	for <lists+io-uring@lfdr.de>; Wed, 22 Apr 2020 07:19:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725934AbgDVFT1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 22 Apr 2020 01:19:27 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:36125 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725787AbgDVFT1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 22 Apr 2020 01:19:27 -0400
X-Originating-IP: 50.39.163.217
Received: from localhost (50-39-163-217.bvtn.or.frontiernet.net [50.39.163.217])
        (Authenticated sender: josh@joshtriplett.org)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id C360EC0003;
        Wed, 22 Apr 2020 05:19:19 +0000 (UTC)
Date:   Tue, 21 Apr 2020 22:19:14 -0700
From:   Josh Triplett <josh@joshtriplett.org>
To:     io-uring@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, mtk.manpages@gmail.com
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Jens Axboe <axboe@kernel.dk>,
        Aleksa Sarai <cyphar@cyphar.com>, linux-man@vger.kernel.org
Subject: [PATCH v5 0/3] Support userspace-selected fds
Message-ID: <cover.1587531463.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="5vNYLRcllDrimb99"
Content-Disposition: inline
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org


--5vNYLRcllDrimb99
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

5.8 material, not intended for 5.7. Now includes a patch for man-pages,
attached to this cover letter.

Inspired by the X protocol's handling of XIDs, allow userspace to select
the file descriptor opened by a call like openat2, so that it can use
the resulting file descriptor in subsequent system calls without waiting
for the response to the initial openat2 syscall.

The first patch is independent of the other two; it allows reserving
file descriptors below a certain minimum for userspace-selected fd
allocation only.

The second patch implements userspace-selected fd allocation for
openat2, introducing a new O_SPECIFIC_FD flag and an fd field in struct
open_how. In io_uring, this allows sequences like openat2/read/close
without waiting for the openat2 to complete. Multiple such sequences can
overlap, as long as each uses a distinct file descriptor.

The third patch adds userspace-selected fd allocation to pipe2 as well.
I did this partly as a demonstration of how simple it is to wire up
O_SPECIFIC_FD support for any fd-allocating system call, and partly in
the hopes that this may make it more useful to wire up io_uring support
for pipe2 in the future.

v5:

Rename padding field to __padding.
Add tests for non-zero __padding.
Include patch for man-pages.

v4:

Changed fd field to __u32.
Expanded and consolidated checks that return -EINVAL for invalid arguments.
Simplified and commented build_open_how.
Add documentation comment for fd field.
Add kselftests.

Thanks to Aleksa Sarai for feedback.

v3:

This new version has an API to atomically increase the minimum fd and
return the previous minimum, rather than just getting and setting the
minimum; this makes it easier to allocate a range. (A library that might
initialize after the program has already opened other file descriptors
may need to check for existing open fds in the range after reserving it,
and reserve more fds if needed; this can be done entirely in userspace,
and we can't really do anything simpler in the kernel due to limitations
on file-descriptor semantics, so this patch series avoids introducing
any extra complexity in the kernel.)

This new version also supports a __get_specific_unused_fd_flags call
which accepts the limit for RLIMIT_NOFILE as an argument, analogous to
__get_unused_fd_flags, since io_uring needs that to correctly handle
RLIMIT_NOFILE.

Thanks to Jens Axboe for review and feedback.

v2:

Version 2 was a version incorporated into a larger patch series from Jens Axboe
on io_uring.

Josh Triplett (3):
  fs: Support setting a minimum fd for "lowest available fd" allocation
  fs: openat2: Extend open_how to allow userspace-selected fds
  fs: pipe2: Support O_SPECIFIC_FD

 fs/fcntl.c                                    |  2 +-
 fs/file.c                                     | 62 +++++++++++++++++--
 fs/io_uring.c                                 |  3 +-
 fs/open.c                                     |  8 ++-
 fs/pipe.c                                     | 16 +++--
 include/linux/fcntl.h                         |  5 +-
 include/linux/fdtable.h                       |  1 +
 include/linux/file.h                          |  4 ++
 include/uapi/asm-generic/fcntl.h              |  4 ++
 include/uapi/linux/openat2.h                  |  3 +
 include/uapi/linux/prctl.h                    |  3 +
 kernel/sys.c                                  |  5 ++
 tools/testing/selftests/openat2/helpers.c     |  2 +-
 tools/testing/selftests/openat2/helpers.h     | 21 +++++--
 .../testing/selftests/openat2/openat2_test.c  | 35 ++++++++++-
 15 files changed, 150 insertions(+), 24 deletions(-)

-- 
2.26.2


--5vNYLRcllDrimb99
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-openat2.2-pipe.2-prctl.2-Document-O_SPECIFIC_FD-and-.patch"

From e3f2c8b75008de46cc51802f5915833298216370 Mon Sep 17 00:00:00 2001
Message-Id: <e3f2c8b75008de46cc51802f5915833298216370.1587531331.git.josh@joshtriplett.org>
From: Josh Triplett <josh@joshtriplett.org>
Date: Tue, 21 Apr 2020 21:54:25 -0700
Subject: [PATCH] openat2.2, pipe.2, prctl.2: Document O_SPECIFIC_FD and
 PR_INCREASE_MIN_FD

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 man2/openat2.2 | 83 ++++++++++++++++++++++++++++++++++++++++++++++++--
 man2/pipe.2    | 42 +++++++++++++++++++++++++
 man2/prctl.2   | 12 ++++++++
 3 files changed, 134 insertions(+), 3 deletions(-)

diff --git a/man2/openat2.2 b/man2/openat2.2
index fb976f259..994210ad1 100644
--- a/man2/openat2.2
+++ b/man2/openat2.2
@@ -103,9 +103,11 @@ This argument is a pointer to a structure of the following form:
 .in +4n
 .EX
 struct open_how {
-    u64 flags;    /* O_* flags */
-    u64 mode;     /* Mode for O_{CREAT,TMPFILE} */
-    u64 resolve;  /* RESOLVE_* flags */
+    u64 flags;     /* O_* flags */
+    u64 mode;      /* Mode for O_{CREAT,TMPFILE} */
+    u64 resolve;   /* RESOLVE_* flags */
+    u32 fd;        /* File descriptor for O_SPECIFIC_FD */
+    u32 __padding; /* Must be zeroed */
     /* ... */
 };
 .EE
@@ -147,6 +149,12 @@ argument,
 .BR openat2 ()
 returns an error if unknown or conflicting flags are specified in
 .IR how.flags .
+.IP
+The flag
+.B O_SPECIFIC_FD
+is only valid for openat2, as it requires the
+.I fd
+field.
 .TP
 .I mode
 This field specifies the
@@ -390,6 +398,48 @@ so that a pathname component (now) contains a bind mount.
 If any bits other than those listed above are set in
 .IR how.resolve ,
 an error is returned.
+.TP
+.I fd
+If
+.I flags
+contains
+.BR O_SPECIFIC_FD ,
+.BR openat2 ()
+will allocate and return that specific file descriptor, rather than using the
+lowest available file descriptor.
+If
+.I fd
+contains \-1,
+.BR openat2 ()
+will return the lowest available file descriptor just as if
+.B O_SPECIFIC_FD
+had not been specified.
+.IP
+The caller may wish to use the
+.BR prctl (2)
+option
+.B PR_INCREASE_MIN_FD
+to reserve a range of file descriptors for such usage.
+.IP
+If the specified file descriptor is already in use,
+.BR openat2 ()
+will return \-1 and set
+.I errno
+to
+.BR EBUSY .
+.IP
+If
+.I flags
+does not contain
+.BR O_SPECIFIC_FD ,
+.I fd
+must be zero.
+.TP
+.I __padding
+This value must be zero, and must not be referenced by name.
+Future versions of the
+.I open_how
+structure may give a new name and semantic to this field.
 .SH RETURN VALUE
 On success, a new file descriptor is returned.
 On error, \-1 is returned, and
@@ -421,6 +471,26 @@ The caller may choose to retry the
 .BR openat2 ()
 call.
 .TP
+.B EBUSY
+.I how.flags
+contains
+.B O_SPECIFIC_FD
+and the file descriptor specified in
+.I fd
+was in use.
+.TP
+.B EMFILE
+.I how.flags
+contains
+.B O_SPECIFIC_FD
+and
+.I how.fd
+exceeds the maximum file descriptor allowed for the process
+(see the description of
+.BR RLIMIT_NOFILE
+in
+.BR getrlimit (2)).
+.TP
 .B EINVAL
 An unknown flag or invalid value was specified in
 .IR how .
@@ -435,6 +505,13 @@ or
 .BR O_TMPFILE .
 .TP
 .B EINVAL
+.I how.fd
+is non-zero, but
+.I how.flags
+does not contain
+.BR O_SPECIFIC_FD .
+.TP
+.B EINVAL
 .I size
 was smaller than any known version of
 .IR "struct open_how" .
diff --git a/man2/pipe.2 b/man2/pipe.2
index 4a5a10567..af07b9c59 100644
--- a/man2/pipe.2
+++ b/man2/pipe.2
@@ -146,6 +146,31 @@ referred to by the new file descriptors.
 Using this flag saves extra calls to
 .BR fcntl (2)
 to achieve the same result.
+.TP
+.B O_SPECIFIC_FD
+Rather than allocating the next available file descriptors, read the file
+descriptor values specified in
+.I pipefd
+and allocate those specific file descriptors.
+If one or both of the entries in
+.I pipefd
+contains \-1,
+.BR pipe2 ()
+will allocate the lowest available file descriptor for that end of the pipe as
+usual.
+.IP
+The caller may wish to use the
+.BR prctl (2)
+option
+.B PR_INCREASE_MIN_FD
+to reserve a range of file descriptors for such usage.
+.IP
+If the specified file descriptor is already in use,
+.BR pipe2 ()
+will return \-1 and set
+.I errno
+to
+.BR EBUSY .
 .SH RETURN VALUE
 On success, zero is returned.
 On error, \-1 is returned,
@@ -169,6 +194,12 @@ likewise does not modify
 on failure.
 .SH ERRORS
 .TP
+.B EBUSY
+.I flags
+contains
+.B O_SPECIFIC_FD
+and one of the specified file descriptors was in use.
+.TP
 .B EFAULT
 .I pipefd
 is not valid.
@@ -181,6 +212,17 @@ Invalid value in
 .B EMFILE
 The per-process limit on the number of open file descriptors has been reached.
 .TP
+.B EMFILE
+.I flags
+contains
+.B O_SPECIFIC_FD
+and one of the specified file descriptors exceeds the maximum file descriptor
+allowed for the process
+(see the description of
+.BR RLIMIT_NOFILE
+in
+.BR getrlimit (2)).
+.TP
 .B ENFILE
 The system-wide limit on the total number of open files has been reached.
 .TP
diff --git a/man2/prctl.2 b/man2/prctl.2
index 7a5af76f4..d54d9cb67 100644
--- a/man2/prctl.2
+++ b/man2/prctl.2
@@ -531,6 +531,18 @@ All unused
 .BR prctl ()
 arguments must be zero.
 .TP
+.BR PR_INCREASE_MIN_FD " (since Linux 5.8)"
+Increase the minimum file descriptor that the kernel will automatically
+allocate when the process opens a new file descriptor, by
+.IR arg2 .
+Return (as the function result) the current minimum.
+A process may pass 0 as
+.I arg2
+to return the current minimum without changing it.
+The remaining unused
+.BR prctl ()
+arguments must be zero for future compatibility.
+.TP
 .BR PR_SET_MM " (since Linux 3.3)"
 .\" commit 028ee4be34a09a6d48bdf30ab991ae933a7bc036
 Modify certain kernel memory map descriptor fields
-- 
2.26.2


--5vNYLRcllDrimb99--
