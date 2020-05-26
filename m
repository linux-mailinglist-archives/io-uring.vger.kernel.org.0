Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC701E2F47
	for <lists+io-uring@lfdr.de>; Tue, 26 May 2020 21:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389679AbgEZTv3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 May 2020 15:51:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389569AbgEZTv1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 May 2020 15:51:27 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00D03C03E96F
        for <io-uring@vger.kernel.org>; Tue, 26 May 2020 12:51:27 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id x11so8123530plv.9
        for <io-uring@vger.kernel.org>; Tue, 26 May 2020 12:51:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3vgocQPX0Uu624PG2Fri8o8+lrHBaWtJW7f03lBEuxc=;
        b=gwggRYZamJOMYInIOlO/Q04SnoVGCJjFg/6Nj8AbQjUNnZAVI79HRFs1KsrsW8B037
         41oP5k8Rj1YW3C67iTh+6CF16JmtkpfM8q9oSY1dsdaXfNSFE9Ssnus5ww52WkER1Ny+
         vPaijD2dFGuGk6dDwcgcMU8RLs191JoUlYWjpEIO1MPOv2WJ6Uf0eypTxpyja4WN3sFj
         19XkX+HMt4c5jqAILmUwqMlJEyjrGTBEc+yUA1CLaBAO00de/mOAl2uj49T1QZQkK1Rz
         7at4zJtB1S2w7ZfT5YQI5haZWA4wRfav9yfraSTA7fVaI9gL0OhfY2j5MXe5F/IsSfGT
         NyvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=3vgocQPX0Uu624PG2Fri8o8+lrHBaWtJW7f03lBEuxc=;
        b=Q84YGpYzat/ccta3gikqv7ns+0AC1wzFSMATfZwB1+DotBgPfz4mvTXEgaoRNQwsbB
         JuAQ4BxPMtjdvgq4LPjjUEeU5VCpv/RPoGRN9gL71MifCTnAs4s40iWr4EGckLlKlJiV
         UZMr9l9GYzDV7fDJVQ3m8BrveQaU4PyK6AZpeaRpG5IPFJ5Dt6NOsPIUYwm9O7sx937u
         R8ssSusKiqXgM//1CE4gkWg9jK457i65RzDoAYkXiCaWf70pK8un0mUiTupQYADIGbZL
         JImMUvda57GGhH5gq4w+pqsRbHY2BnktaryZHbkBTrPx329g4v5SrIAuE098/mGMbnyn
         bU2w==
X-Gm-Message-State: AOAM532dMrM6FBWsQYeZDGG5dX5WdRjCeiMaiTvFhAu6AMQloXNVpK3f
        d+w+G3rBUq9TYUB53zFTPoTwMz77Yo/v8w==
X-Google-Smtp-Source: ABdhPJzJ3Tq3BzFtOFHbUR4w5NteDSN5zWurQj7+sWPv13oLtiMeWlePumfMLTLd1gZHRthRJuHHcA==
X-Received: by 2002:a17:90a:e28d:: with SMTP id d13mr918533pjz.128.1590522686069;
        Tue, 26 May 2020 12:51:26 -0700 (PDT)
Received: from x1.lan ([2605:e000:100e:8c61:94bb:59d2:caf6:70e1])
        by smtp.gmail.com with ESMTPSA id c184sm313943pfc.57.2020.05.26.12.51.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 12:51:25 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, akpm@linux-foundation.org
Subject: [PATCHSET v5 0/12] Add support for async buffered reads
Date:   Tue, 26 May 2020 13:51:11 -0600
Message-Id: <20200526195123.29053-1-axboe@kernel.dk>
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

https://git.kernel.dk/cgit/linux-block/log/?h=async-buffered.5

or pull from:

git://git.kernel.dk/linux-block async-buffered.5

 fs/block_dev.c            |   2 +-
 fs/btrfs/file.c           |   2 +-
 fs/ext4/file.c            |   2 +-
 fs/io_uring.c             | 130 ++++++++++++++++++++++++++++++++++++--
 fs/xfs/xfs_file.c         |   2 +-
 include/linux/blk_types.h |   3 +-
 include/linux/fs.h        |  10 ++-
 include/linux/pagemap.h   |  67 ++++++++++++++++++++
 mm/filemap.c              | 111 ++++++++++++++++++++------------
 9 files changed, 279 insertions(+), 50 deletions(-)

Changes since v5:
- Correct commit message, iocb->private -> iocb->ki_waitq
- Get rid of io_uring goto, use an iter read helper
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


