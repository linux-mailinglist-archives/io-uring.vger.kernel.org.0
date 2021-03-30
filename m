Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE89434E63F
	for <lists+io-uring@lfdr.de>; Tue, 30 Mar 2021 13:18:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231829AbhC3LRj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 30 Mar 2021 07:17:39 -0400
Received: from hmm.wantstofly.org ([213.239.204.108]:40410 "EHLO
        mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231743AbhC3LRX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 30 Mar 2021 07:17:23 -0400
Received: by mail.wantstofly.org (Postfix, from userid 1000)
        id 8132A7F4C0; Tue, 30 Mar 2021 14:17:21 +0300 (EEST)
Date:   Tue, 30 Mar 2021 14:17:21 +0300
From:   Lennert Buytenhek <buytenh@wantstofly.org>
To:     io-uring@vger.kernel.org
Cc:     Tavian Barnes <tavianator@tavianator.com>,
        Dmitry Kadashev <dkadashev@gmail.com>
Subject: [PATCH v5 0/2] io_uring: add support for IORING_OP_GETDENTS
Message-ID: <YGMIwcxAIJPAWGLu@wantstofly.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

(These patches depend on IORING_OP_MKDIRAT going in first.)

These patches add support for IORING_OP_GETDENTS, which is a new io_uring
opcode that more or less does an lseek(sqe->fd, sqe->off, SEEK_SET)
followed by a getdents64(sqe->fd, (void *)sqe->addr, sqe->len).

A dumb test program which recursively scans through a directory tree
and prints the names of all directories and files it encounters along
the way is available here:

        https://krautbox.wantstofly.org/~buytenh/uringfind-v3.c

Changes since v4:

- Make IORING_OP_GETDENTS read from the directory's current position
  if the specified offset value is -1 (IORING_FEAT_RW_CUR_POS).
  (Requested / pointed out by Tavian Barnes.)

- Rebase onto for-5.13/io_uring as of 2021/03/30 plus v3 of Dmitry
  Kadashev's "io_uring: add mkdirat support".

Changes since v3:

- Made locking in io_getdents() unconditional, as the prior
  optimization was racy.  (Pointed out by Pavel Begunkov.)

- Rebase onto for-5.13/io_uring as of 2021/03/12 plus a manually
  applied version of the mkdirat patch.

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

 fs/io_uring.c                 |   66 ++++++++++++++++++++++++++++++++++++++++++
 fs/readdir.c                  |   25 ++++++++++-----
 include/linux/fs.h            |    4 ++
 include/uapi/linux/io_uring.h |    1
 4 files changed, 88 insertions(+), 8 deletions(-)
