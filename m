Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A0141FF50A
	for <lists+io-uring@lfdr.de>; Thu, 18 Jun 2020 16:44:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730933AbgFROoD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 18 Jun 2020 10:44:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730920AbgFROoB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 18 Jun 2020 10:44:01 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC5D4C0613EE
        for <io-uring@vger.kernel.org>; Thu, 18 Jun 2020 07:44:00 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id b5so2997156pgm.8
        for <io-uring@vger.kernel.org>; Thu, 18 Jun 2020 07:44:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:reply-to:mime-version
         :content-transfer-encoding;
        bh=QtQZj6qHx4NyNp4faebxEBGjQhFGouVk8vIR/YM0OZ0=;
        b=LaeOybvgVFUedJ618PM1GTEUXkMXPY3qF3zemK0oPI0t/5c3IyDHmKKjFSXMlllNpg
         u4+VdHvZcEwrYY6QLxMvN9QNbcQkL40jfHhhwKnfjkRjaCBH/fdF2CXYNuGlJe/1qagv
         GOuftdx/mhTGZ0CDkYYM/BzpHCtO3WgFPHV5MzKmJusZp3RHe6UsIOj2jqBaJqopy9w1
         8dyb1/ZNKWuCGje3eaRAvZHyHC8hhvG7uaNyzR+WZLwsMfnWHwLZir4H4MXYeJ5kkTgv
         S21Bzwg3kx7/cgMp23f6Z1a2ySJ2w9JTPWvpySOoRC3V8WNU7ZClsM3eXev1LkALavYt
         hZcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :mime-version:content-transfer-encoding;
        bh=QtQZj6qHx4NyNp4faebxEBGjQhFGouVk8vIR/YM0OZ0=;
        b=W8l8nrYXKa35MIYbRs08GmtH20cTR5Y5dd6JU/oOvi51kC6IrSLswXEEt+eiochJrQ
         6pugBpY68pzE9IUiutamf2rV1FzCeVO73NzynlDMI9XPnj+XrpICBGO0jMp39dK4z9KY
         ClflD319POOctytNjFk8h9HZy8gbcT2Xxfq2q8iVyQ5PwBDnn5ZLa/AcrXXlnIRuquIC
         wRS/T/njge0W+3UxqihHK164ZYWpPATBNKGLsaof+rRXlgIEyW0FhwCuWsjZwQEa1Zy2
         a3XyyL/7S05AnvG6n1aOb3FCH9FQuQaedfpM3AbeiHg77j8v/JsGZSqznL9vz9hfl73t
         VqKw==
X-Gm-Message-State: AOAM530FOar24+YHvgYhZme6Jqby5c82xZCdmVWRIghBUAZrIxLiufuS
        CpeovybWHzv35+WpGmCIrvFms2NPGov7Dw==
X-Google-Smtp-Source: ABdhPJwVlCUbORgsthBtt/igrlr5i7l6tNK0VhZZRDtHj5c1nyTVCxDwaDg3pXHR9uxp5F9dJc2YrQ==
X-Received: by 2002:a62:191:: with SMTP id 139mr3946645pfb.94.1592491439786;
        Thu, 18 Jun 2020 07:43:59 -0700 (PDT)
Received: from x1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id g9sm3127197pfm.151.2020.06.18.07.43.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2020 07:43:59 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, akpm@linux-foundation.org
Subject: 
Date:   Thu, 18 Jun 2020 08:43:40 -0600
Message-Id: <20200618144355.17324-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.27.0
Reply-To: "[PATCHSET v7 0/15]"@vger.kernel.org, Add@vger.kernel.org,
          support@vger.kernel.org, for@vger.kernel.org,
          async@vger.kernel.org, buffered@vger.kernel.org,
          reads@vger.kernel.org
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

https://git.kernel.dk/cgit/linux-block/log/?h=async-buffered.7

or pull from:

git://git.kernel.dk/linux-block async-buffered.7

 block/blk-core.c        |   6 +
 fs/block_dev.c          |   2 +-
 fs/btrfs/file.c         |   2 +-
 fs/ext4/file.c          |   2 +-
 fs/io_uring.c           | 336 ++++++++++++++++++++++++++++++++++------
 fs/xfs/xfs_file.c       |   2 +-
 include/linux/blkdev.h  |   1 +
 include/linux/fs.h      |  10 +-
 include/linux/pagemap.h |  75 +++++++++
 mm/filemap.c            | 110 ++++++++-----
 10 files changed, 454 insertions(+), 92 deletions(-)

Changes since v6:
- Properly catch and resubmit requests that would have blocked in
  submission.
- Fix sqthread mm usage for async buffered retry
- Fix a retry condition iter setup
- Rebase on master + for-5.9/io_uring
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



