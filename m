Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A10B27585C6
	for <lists+io-uring@lfdr.de>; Tue, 18 Jul 2023 21:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbjGRTt3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Jul 2023 15:49:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230332AbjGRTt2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Jul 2023 15:49:28 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FD1D1992
        for <io-uring@vger.kernel.org>; Tue, 18 Jul 2023 12:49:27 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id ca18e2360f4ac-785ccd731a7so68474639f.0
        for <io-uring@vger.kernel.org>; Tue, 18 Jul 2023 12:49:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689709766; x=1690314566;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w5RGf/AztcSIhP5DFZEGlQk10jAnPRlynSLtijCMzZ4=;
        b=uVjqrRfgxlo7M0RXR2cj9GYEPSnJK1B0Cakesm9KzrHqbTPDquGVMOH2v+pW5Zoet7
         YiXgI4yD5/+0BjFGkJfHmYo41V3EprTN5u6k+PaCUi/Hh4MGtP9/60v7lH5cfbXIQgQF
         b1eA0rz5lC4NJxDyJvbeVVERhm0KhTgl8viOCZEbLDLnaBN4y3fFGV1pnd8I7hnQVMvV
         fgwzvB0QCRYwvKtToaWISYnvszMayn8bOZqRKFiqLyVRi6nc5Aa+UPWKmQy/HJNSWp06
         vxiA7Hj+0RVAZB+ps4xlvGOnked0yRgrUMBnjdzY6SvJ8DCllEBv0rm71QJuzEkRGfCL
         RHNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689709766; x=1690314566;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=w5RGf/AztcSIhP5DFZEGlQk10jAnPRlynSLtijCMzZ4=;
        b=MvLJGcutw+zNRtt8XP1UAvqgv9O/eb3+9usgXPjQ5eBH4B8evQ8qdbjtz75Rr+XXBU
         S4JD13SUHDsCSaQwKJCEr79ud1rLW6MNsL4tZvpOAmFB/uAGhbmc2/K+InNnI4whG0P5
         LBM++PjnCbtf6SZrULmPTuEWfAUhIGPOBkYi1DIJsaNCaVSbBTKR29qbFnVdpBT0aYaM
         K0eklmS9Bg0ge6+X+iC/NTxo06hMdErt81KFSz7E0/pMbFvNxSVv8q09+MfjJkPPRnuD
         WR5/t5q4ceuD8kY0IMIRzELnCeuX4IfLP9M7i7ATAR68AudMOg+3WbT1Rj5UZYl4c8vI
         dqag==
X-Gm-Message-State: ABy/qLZGJZaWanzlT2Tu/Wl6rVDyXFou9YUm5vLP/Faw0q8XE6BBiKSG
        2tsKAqJJiLYwYuxWOIYoCiWj+WOUTxx10k0uuPU=
X-Google-Smtp-Source: APBJJlHNrBPrb6/NTxNFIMVviy6/Vrwwn2y5BNkB9XpeWA57DlLQVQwu8YRln6Tnq7dnCAYSYHaALg==
X-Received: by 2002:a05:6e02:219b:b0:345:a3d0:f0d4 with SMTP id j27-20020a056e02219b00b00345a3d0f0d4mr3704541ila.3.1689709766509;
        Tue, 18 Jul 2023 12:49:26 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id v18-20020a92d252000000b00345e3a04f2dsm897463ilg.62.2023.07.18.12.49.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jul 2023 12:49:25 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     hch@lst.de, andres@anarazel.de, david@fromorbit.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/5] iomap: simplify logic for when a dio can get completed inline
Date:   Tue, 18 Jul 2023 13:49:16 -0600
Message-Id: <20230718194920.1472184-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230718194920.1472184-1-axboe@kernel.dk>
References: <20230718194920.1472184-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Currently iomap gates this on !IOMAP_DIO_WRITE, but this isn't entirely
accurate. Some writes can complete just fine inline. One such example is
polled IO, where the completion always happens in task context.

Add IOMAP_DIO_INLINE_COMP which tells the completion side if we can
complete this dio inline, or if it needs punting to a workqueue. We set
this flag by default for any dio, and turn it off for unwritten extents
or blocks that require a sync at completion time.

Gate the inline completion on whether we're in a task or not as well.
This will always be true for polled IO, but for IRQ driven IO, the
completion context may not allow for inline completions.

Testing a basic QD 1..8 dio random write with polled IO with the
following fio job:

fio --name=polled-dio-write --filename=/data1/file --time_based=1 \
--runtime=10 --bs=4096 --rw=randwrite --norandommap --buffered=0 \
--cpus_allowed=4 --ioengine=io_uring --iodepth=$depth --hipri=1

yields:

        Stock   Patched         Diff
=======================================
QD1     180K    201K            +11%
QD2     356K    394K            +10%
QD4     608K    650K            +7%
QD8     827K    831K            +0.5%

which shows a nice win, particularly for lower queue depth writes.
This is expected, as higher queue depths will be busy polling
completions while the offloaded workqueue completions can happen in
parallel.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/iomap/direct-io.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index ea3b868c8355..6fa77094cf0a 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -20,6 +20,7 @@
  * Private flags for iomap_dio, must not overlap with the public ones in
  * iomap.h:
  */
+#define IOMAP_DIO_INLINE_COMP	(1 << 27)
 #define IOMAP_DIO_WRITE_FUA	(1 << 28)
 #define IOMAP_DIO_NEED_SYNC	(1 << 29)
 #define IOMAP_DIO_WRITE		(1 << 30)
@@ -161,15 +162,15 @@ void iomap_dio_bio_end_io(struct bio *bio)
 			struct task_struct *waiter = dio->submit.waiter;
 			WRITE_ONCE(dio->submit.waiter, NULL);
 			blk_wake_io_task(waiter);
-		} else if (dio->flags & IOMAP_DIO_WRITE) {
+		} else if ((dio->flags & IOMAP_DIO_INLINE_COMP) && in_task()) {
+			WRITE_ONCE(dio->iocb->private, NULL);
+			iomap_dio_complete_work(&dio->aio.work);
+		} else {
 			struct inode *inode = file_inode(dio->iocb->ki_filp);
 
 			WRITE_ONCE(dio->iocb->private, NULL);
 			INIT_WORK(&dio->aio.work, iomap_dio_complete_work);
 			queue_work(inode->i_sb->s_dio_done_wq, &dio->aio.work);
-		} else {
-			WRITE_ONCE(dio->iocb->private, NULL);
-			iomap_dio_complete_work(&dio->aio.work);
 		}
 	}
 
@@ -244,6 +245,7 @@ static loff_t iomap_dio_bio_iter(const struct iomap_iter *iter,
 
 	if (iomap->type == IOMAP_UNWRITTEN) {
 		dio->flags |= IOMAP_DIO_UNWRITTEN;
+		dio->flags &= ~IOMAP_DIO_INLINE_COMP;
 		need_zeroout = true;
 	}
 
@@ -500,7 +502,8 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 	dio->i_size = i_size_read(inode);
 	dio->dops = dops;
 	dio->error = 0;
-	dio->flags = 0;
+	/* default to inline completion, turned off when not supported */
+	dio->flags = IOMAP_DIO_INLINE_COMP;
 	dio->done_before = done_before;
 
 	dio->submit.iter = iter;
@@ -535,6 +538,7 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 		/* for data sync or sync, we need sync completion processing */
 		if (iocb_is_dsync(iocb)) {
 			dio->flags |= IOMAP_DIO_NEED_SYNC;
+			dio->flags &= ~IOMAP_DIO_INLINE_COMP;
 
 		       /*
 			* For datasync only writes, we optimistically try
-- 
2.40.1

