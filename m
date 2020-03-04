Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A3DD179260
	for <lists+io-uring@lfdr.de>; Wed,  4 Mar 2020 15:35:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbgCDOfy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 4 Mar 2020 09:35:54 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:38973 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726263AbgCDOfy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 4 Mar 2020 09:35:54 -0500
X-Originating-IP: 50.39.173.182
Received: from localhost (50-39-173-182.bvtn.or.frontiernet.net [50.39.173.182])
        (Authenticated sender: josh@joshtriplett.org)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 5B8FA6000A;
        Wed,  4 Mar 2020 14:35:50 +0000 (UTC)
Date:   Wed, 4 Mar 2020 06:35:48 -0800
From:   Josh Triplett <josh@joshtriplett.org>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH WIP 0/3] Support userspace-selected fds
Message-ID: <20200304143548.GA407676@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Prototype of the proposal I made at
https://lore.kernel.org/io-uring/20200211223235.GA25104@localhost/ . See
also the discussion at
https://twitter.com/josh_triplett/status/1235004009502494721 .

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
O_SPECIFIC_FD support for a new fd-allocating system call, and partly in
the hopes that this may make it more useful to wire up io_uring support
for pipe2 in the future.

Josh Triplett (3):
  fs: Support setting a minimum fd for "lowest available fd" allocation
  fs: openat2: Extend open_how to allow userspace-selected fds
  fs: pipe2: Support O_SPECIFIC_FD

 fs/fcntl.c                       |  2 +-
 fs/file.c                        | 62 ++++++++++++++++++++++++++++----
 fs/io_uring.c                    |  2 +-
 fs/open.c                        |  6 ++--
 fs/pipe.c                        | 15 +++++---
 include/linux/fcntl.h            |  5 +--
 include/linux/fdtable.h          |  1 +
 include/linux/file.h             |  3 ++
 include/uapi/asm-generic/fcntl.h |  4 +++
 include/uapi/linux/openat2.h     |  2 ++
 include/uapi/linux/prctl.h       |  4 +++
 kernel/sys.c                     | 10 ++++++
 12 files changed, 100 insertions(+), 16 deletions(-)

-- 
2.25.1

