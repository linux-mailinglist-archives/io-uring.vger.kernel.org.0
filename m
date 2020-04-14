Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B7C31A70DC
	for <lists+io-uring@lfdr.de>; Tue, 14 Apr 2020 04:14:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404008AbgDNCO4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 13 Apr 2020 22:14:56 -0400
Received: from relay7-d.mail.gandi.net ([217.70.183.200]:55575 "EHLO
        relay7-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403967AbgDNCO4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 13 Apr 2020 22:14:56 -0400
X-Originating-IP: 50.39.163.217
Received: from localhost (50-39-163-217.bvtn.or.frontiernet.net [50.39.163.217])
        (Authenticated sender: josh@joshtriplett.org)
        by relay7-d.mail.gandi.net (Postfix) with ESMTPSA id 495A020008;
        Tue, 14 Apr 2020 02:14:48 +0000 (UTC)
Date:   Mon, 13 Apr 2020 19:14:46 -0700
From:   Josh Triplett <josh@joshtriplett.org>
To:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org, linux-arch@vger.kernel.org
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Jens Axboe <axboe@kernel.dk>,
        Aleksa Sarai <cyphar@cyphar.com>
Subject: [PATCH v4 0/3] Support userspace-selected fds
Message-ID: <cover.1586830316.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

5.8 material, not intended for 5.7.

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

If this gets accepted, I'm happy to also write corresponding manpage
patches.

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
 .../testing/selftests/openat2/openat2_test.c  | 29 ++++++++-
 15 files changed, 144 insertions(+), 24 deletions(-)

-- 
2.26.0

