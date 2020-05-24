Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D80FB1E020F
	for <lists+io-uring@lfdr.de>; Sun, 24 May 2020 21:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387755AbgEXTWO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 24 May 2020 15:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36928 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387744AbgEXTWN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 24 May 2020 15:22:13 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A80BC08C5C0
        for <io-uring@vger.kernel.org>; Sun, 24 May 2020 12:22:13 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id x13so7923233pfn.11
        for <io-uring@vger.kernel.org>; Sun, 24 May 2020 12:22:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PRgTWBIUIof3K+e/CBH42LWEIO1ioATTUwPeCqp2UHQ=;
        b=QoOW0b+9anaSH1PynN6EMvziqcD6SYQPSEyhxExvJ4fIbobZWkV+qjOWZY58TVG7/j
         XFzrw/TO8ZNuU9Wy1Kf0MtJNqmALcX1/fJ/5NQp7C3CXyHN9qTAhMDHMuZ1P5N0QLICT
         SPtZkbXpx1yp8TjNzUYVx5kDRq5UU+8wJ4/KNP5CVFR4UX6FTCLFGCgQ1D3Lsqx7QjuV
         tYMuVOBoMg+OEnWFCvHKiMZQ4b/JUMaF2BwDINXvScHsgfWF3j0okK8Xtc5dWYKAP6mD
         Gfl8OHlvFdVv3AnJaeKNPTRCWKLc+m5FLCtY12XqW+yTOwdElb93BOVQczWu3zRG1Tfj
         7hbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=PRgTWBIUIof3K+e/CBH42LWEIO1ioATTUwPeCqp2UHQ=;
        b=UDcEbS54H+RNiO5YD6Vn541HFdErBOFBd/JGXm62Mlz4jtEMLPp1go95ZxUsAiZhhe
         WPWNqB2ZyUlWzVEmyludu+RJMiVGE+D8vo1yuoq9RNnRmTedNRyl2L/ekkEeUE4q1mDi
         knvL3UOL/rh0nhaSbrPFANI1GX8gnVB1bQzWJChCNoFvvhCNyZREl3Ec3nbeZXr3mWRE
         MhoEvU/+JZKOo9r12gVc5WNk+p0MLgXlOmaESWpkrgTc5X+AKF09m3R7e04thmQJ50Sx
         fcCy7ZSUlr7SxvUR+9tpeh9x8Ifz1K3lix7s3Zu2wou973RgRzNQbbPAfabtTmvsuvm/
         ND4Q==
X-Gm-Message-State: AOAM531B9XyAsUdNyyNKg/LJsb9wwdSIAaMSWNG3yg6mVxNlKw9liQ9L
        z1vXB4N2OdKMgD/0SoWRSPPE34Aj8jej2g==
X-Google-Smtp-Source: ABdhPJxpWNMA85eA4BcwCQuyHmnnwKmYr9/iXxe1Qr6NlCvQdWZu5puz/A2BlfDne/CKV/J4XCu1QA==
X-Received: by 2002:a63:1207:: with SMTP id h7mr17624890pgl.241.1590348132344;
        Sun, 24 May 2020 12:22:12 -0700 (PDT)
Received: from x1.lan ([2605:e000:100e:8c61:c871:e701:52fa:2107])
        by smtp.gmail.com with ESMTPSA id t21sm10312426pgu.39.2020.05.24.12.22.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 24 May 2020 12:22:11 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: [PATCHSET v4 0/12] Add support for async buffered reads
Date:   Sun, 24 May 2020 13:21:54 -0600
Message-Id: <20200524192206.4093-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We technically support this already through io_uring, but it's
implemented with a thread backend to support cases where we would
block. This isn't ideal.

After a few prep patches, the core of this patchset is adding support
for async callbacks on page unlock. With this primitive, we can simply
retry the IO operation. With io_uring, this works a lot like poll based
retry for files that support it. If a page is currently locked and
needed, -EIOCBQUEUED is returned with a callback armed. The callers
callback is responsible for restarting the operation.

With this callback primitive, we can add support for
generic_file_buffered_read(), which is what most file systems end up
using for buffered reads. XFS/ext4/btrfs/bdev is wired up, but probably
trivial to add more.

The file flags support for this by setting FMODE_BUF_RASYNC, similar
to what we do for FMODE_NOWAIT. Open to suggestions here if this is
the preferred method or not.

In terms of results, I wrote a small test app that randomly reads 4G
of data in 4K chunks from a file hosted by ext4. The app uses a queue
depth of 32. If you want to test yourself, you can just use buffered=1
with ioengine=io_uring with fio. No application changes are needed to
use the more optimized buffered async read.

preadv for comparison:
	real    1m13.821s
	user    0m0.558s
	sys     0m11.125s
	CPU	~13%

Mainline:
	real    0m12.054s
	user    0m0.111s
	sys     0m5.659s
	CPU	~32% + ~50% == ~82%

This patchset:
	real    0m9.283s
	user    0m0.147s
	sys     0m4.619s
	CPU	~52%

The CPU numbers are just a rough estimate. For the mainline io_uring
run, this includes the app itself and all the threads doing IO on its
behalf (32% for the app, ~1.6% per worker and 32 of them). Context
switch rate is much smaller with the patchset, since we only have the
one task performing IO.

Also ran a simple fio based test case, varying the queue depth from 1
to 16, doubling every time:

[buf-test]
filename=/data/file
direct=0
ioengine=io_uring
norandommap
rw=randread
bs=4k
iodepth=${QD}
randseed=89
runtime=10s

QD/Test		Patchset IOPS		Mainline IOPS
1		9046			8294
2		19.8k			18.9k
4		39.2k			28.5k
8		64.4k			31.4k
16		65.7k			37.8k

Outside of my usual environment, so this is just running on a virtualized
NVMe device in qemu, using ext4 as the file system. NVMe isn't very
efficient virtualized, so we run out of steam at ~65K which is why we
flatline on the patched side (nvme_submit_cmd() eats ~75% of the test app
CPU). Before that happens, it's a linear increase. Not shown is context
switch rate, which is massively lower with the new code. The old thread
offload adds a blocking thread per pending IO, so context rate quickly
goes through the roof.

The goal here is efficiency. Async thread offload adds latency, and
it also adds noticable overhead on items such as adding pages to the
page cache. By allowing proper async buffered read support, we don't
have X threads hammering on the same inode page cache, we have just
the single app actually doing IO.

Been beating on this and it's solid for me, and I'm now pretty happy
with how it all turned out. Not aware of any missing bits/pieces or
code cleanups that need doing.

Series can also be found here:

https://git.kernel.dk/cgit/linux-block/log/?h=async-buffered.4

or pull from:

git://git.kernel.dk/linux-block async-buffered.4

 fs/block_dev.c            |   2 +-
 fs/btrfs/file.c           |   2 +-
 fs/ext4/file.c            |   2 +-
 fs/io_uring.c             | 114 ++++++++++++++++++++++++++++++++++++++
 fs/xfs/xfs_file.c         |   2 +-
 include/linux/blk_types.h |   3 +-
 include/linux/fs.h        |  10 +++-
 include/linux/pagemap.h   |  67 ++++++++++++++++++++++
 mm/filemap.c              | 111 ++++++++++++++++++++++++-------------
 9 files changed, 267 insertions(+), 46 deletions(-)

Changes since v3:
- io_uring: don't retry if REQ_F_NOWAIT is set
- io_uring: alloc req->io if the request type didn't already
- Add iocb->ki_waitq instead of (ab)using iocb->private
Changes since v2:
- Get rid of unnecessary wait_page_async struct, just use wait_page_async
- Add another prep handler, adding wake_page_match()
- Use wake_page_match() in both callers
Changes since v1:
- Fix an issue with inline page locking
- Fix a potential race with __wait_on_page_locked_async()
- Fix a hang related to not setting page_match, thus missing a wakeup

-- 
Jens Axboe


