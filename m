Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 26EED31EBA2
	for <lists+io-uring@lfdr.de>; Thu, 18 Feb 2021 16:41:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232322AbhBRPkN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Feb 2021 10:40:13 -0500
Received: from hmm.wantstofly.org ([213.239.204.108]:57128 "EHLO
        mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232388AbhBRM2a (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Feb 2021 07:28:30 -0500
Received: by mail.wantstofly.org (Postfix, from userid 1000)
        id E7AEC7F4AC; Thu, 18 Feb 2021 14:26:40 +0200 (EET)
Date:   Thu, 18 Feb 2021 14:26:40 +0200
From:   Lennert Buytenhek <buytenh@wantstofly.org>
To:     Jens Axboe <axboe@kernel.dk>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        io-uring@vger.kernel.org
Cc:     David Laight <David.Laight@aculab.com>,
        Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v3 0/2] io_uring: add support for IORING_OP_GETDENTS
Message-ID: <20210218122640.GA334506@wantstofly.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

These patches add support for IORING_OP_GETDENTS, which is a new io_uring
opcode that more or less does an lseek(sqe->fd, sqe->off, SEEK_SET)
followed by a getdents64(sqe->fd, (void *)sqe->addr, sqe->len).

A dumb test program for IORING_OP_GETDENTS is available here:

	https://krautbox.wantstofly.org/~buytenh/uringfind-v2.c

This test program does something along the lines of what find(1) does:
it scans recursively through a directory tree and prints the names of
all directories and files it encounters along the way -- but then using
io_uring.  (The io_uring version prints the names of encountered files and
directories in an order that's determined by SQE completion order, which
is somewhat nondeterministic and likely to differ between runs.)

On a directory tree with 14-odd million files in it that's on a
six-drive (spinning disk) btrfs raid, find(1) takes:

	# echo 3 > /proc/sys/vm/drop_caches
	# time find /mnt/repo > /dev/null

	real    24m7.815s
	user    0m15.015s
	sys     0m48.340s
	#

And the io_uring version takes:

	# echo 3 > /proc/sys/vm/drop_caches
	# time ./uringfind /mnt/repo > /dev/null

	real    10m29.064s
	user    0m4.347s
	sys     0m1.677s
	#


The fully cached case also shows some speedup.  find(1):

	# time find /mnt/repo > /dev/null

	real    0m5.223s
	user    0m1.926s
	sys     0m3.268s
	#

Versus the io_uring version:

	# time ./uringfind /mnt/repo > /dev/null

	real    0m3.604s
	user    0m2.417s
	sys     0m0.793s
	#


That said, the point of this patch isn't primarily to enable
lightning-fast find(1) or du(1), but more to complete the set of
filesystem I/O primitives available via io_uring, so that applications
can do all of their filesystem I/O using the same mechanism, without
having to manually punt some of their work out to worker threads -- and
indeed, an object storage backend server that I wrote a while ago can
run with a pure io_uring based event loop with this patch.

Changes since v2 RFC:

- Rebase onto io_uring-2021-02-17 plus a manually applied version of
  the mkdirat patch.  The latter is needed because userland (liburing)
  has already merged the opcode for IORING_OP_MKDIRAT (in commit
  "io_uring.h: 5.12 pending kernel sync") while this opcode isn't in
  the kernel yet (as of io_uring-2021-02-17), and this means that this
  can't be merged until IORING_OP_MKDIRAT is merged.

- Adapt to changes made in "io_uring: replace force_nonblock with flags"
  that are in io_uring-2021-02-17.

Changes since v1 RFC:

- Drop the trailing '64' from IORING_OP_GETDENTS64 (suggested by
  Matthew Wilcox).

- Instead of requiring that sqe->off be zero, use this field to pass
  in a directory offset to start reading from.  For the first
  IORING_OP_GETDENTS call on a directory, this can be set to zero,
  and for subsequent calls, it can be set to the ->d_off field of
  the last struct linux_dirent64 returned by the previous call.

Lennert Buytenhek (2):
  readdir: split the core of getdents64(2) out into vfs_getdents()
  io_uring: add support for IORING_OP_GETDENTS

 fs/io_uring.c                 |   73 ++++++++++++++++++++++++++++++++++++++++++
 fs/readdir.c                  |   25 +++++++++-----
 include/linux/fs.h            |    4 ++
 include/uapi/linux/io_uring.h |    1 
 4 files changed, 95 insertions(+), 8 deletions(-)
