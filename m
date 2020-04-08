Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 505901A1C0B
	for <lists+io-uring@lfdr.de>; Wed,  8 Apr 2020 08:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726586AbgDHG4j (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Apr 2020 02:56:39 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:60995 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726477AbgDHG4j (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Apr 2020 02:56:39 -0400
X-Originating-IP: 50.39.163.217
Received: from localhost (50-39-163-217.bvtn.or.frontiernet.net [50.39.163.217])
        (Authenticated sender: josh@joshtriplett.org)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id 2E360C0007;
        Wed,  8 Apr 2020 06:56:32 +0000 (UTC)
Date:   Tue, 7 Apr 2020 23:56:29 -0700
From:   Josh Triplett <josh@joshtriplett.org>
To:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org, linux-arch@vger.kernel.org
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH v3 0/3] Support userspace-selected fds
Message-ID: <cover.1586321767.git.josh@joshtriplett.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

(Note: numbering this updated version v3, to avoid confusion with Jens'
v2 that built on my v1. Jens, if you like this approach, please feel
free to stack your additional patches from the io_uring-fd-select branch
atop this series. 5.8 material, not intended for the current merge window.)

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

Josh Triplett (3):
  fs: Support setting a minimum fd for "lowest available fd" allocation
  fs: openat2: Extend open_how to allow userspace-selected fds
  fs: pipe2: Support O_SPECIFIC_FD

 fs/fcntl.c                       |  2 +-
 fs/file.c                        | 62 ++++++++++++++++++++++++++++----
 fs/io_uring.c                    |  3 +-
 fs/open.c                        |  6 ++--
 fs/pipe.c                        | 16 ++++++---
 include/linux/fcntl.h            |  5 +--
 include/linux/fdtable.h          |  1 +
 include/linux/file.h             |  4 +++
 include/uapi/asm-generic/fcntl.h |  4 +++
 include/uapi/linux/openat2.h     |  2 ++
 include/uapi/linux/prctl.h       |  3 ++
 kernel/sys.c                     |  5 +++
 12 files changed, 97 insertions(+), 16 deletions(-)

-- 
2.26.0
