Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F6DB75CE34
	for <lists+io-uring@lfdr.de>; Fri, 21 Jul 2023 18:18:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232625AbjGUQSr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Jul 2023 12:18:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231351AbjGUQS0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Jul 2023 12:18:26 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53D193583
        for <io-uring@vger.kernel.org>; Fri, 21 Jul 2023 09:17:11 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id ca18e2360f4ac-785ccd731a7so26078639f.0
        for <io-uring@vger.kernel.org>; Fri, 21 Jul 2023 09:17:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689956226; x=1690561026;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wU0I1Crk0A9YQHr2dSuYw08fghtgkYJZMMemssUA97A=;
        b=Wt5B/jrczgGplo7izRUX1x6J0TXmv3X4LjWC0vhre8KoqZSeJ0R+n4O5/8E5Yn5RzU
         U8GcrQgZvg2nAnpoHBIhrA7J463hFjfY0zSft1/0m63AT+ULNz/2ipmMVeZYWRFWDIZT
         PR7sqWdxomduhToaloAmi41xmfvbS1b3OKK+CEkX5o+NqmzI82LS6FVfipirWK2GnN6V
         vkzuLZ4qkZQgtkCgsgbdmYbCUbgFi0xcZvVRoqADIjKeQlJHU1krPh18DhxVeOMXoSlE
         2trh8lLHbuGH+lmA2ikTAiWdqguI0D9WGE4IHMbeZ47FQiuf/kjQfgKAN/sTifObJblc
         q4hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689956226; x=1690561026;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wU0I1Crk0A9YQHr2dSuYw08fghtgkYJZMMemssUA97A=;
        b=dY8OZ8UoIUp20h4njspUzmT07F6bKw3e9TK+2DRvF0MbilIkdpNiLQhZad8E5k/YJ5
         p9QgSIrSDr/E3PyeHNBhZoaVhwz1btLKqTFrY8i6Wauu4Lguh+afy5M/tm+Zyf/bFHdG
         X/9Vowb071rQoP2HRtrEIoBF7CWWcTbNNuAz+XLWn5qhTNqFHRVdIpGr4oHk8OUaUE/O
         TqCoaeD0nE0mtdOqM01hPo88JQHroj9vbVBQBmUi14QIKc6ph6yqHBsjUypVmyW+1/1S
         2yO09IHS9EdOqDhKiKwE18FwRb20Nykqt9oKe3PSYDjrfomYtH2GHsscaiyLsd45gO8g
         jFpw==
X-Gm-Message-State: ABy/qLaXWk3p2mA+iOGgyUxEj93u9i64b+0twocCUKZKZcLXk0oyYg2B
        H0uCbTp22TGNm+4V2bKkSi5snLGv6CHUK3WhKzs=
X-Google-Smtp-Source: APBJJlFVkVxscNIXOSMsYXKUWkRhB6n4mYkuHnJWS77o7eUQJyD/zAvZuu23HuKW4mNHvm0bDEzxVg==
X-Received: by 2002:a05:6602:14d2:b0:783:6ec1:65f6 with SMTP id b18-20020a05660214d200b007836ec165f6mr3087186iow.1.1689956225757;
        Fri, 21 Jul 2023 09:17:05 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id l7-20020a02a887000000b0042b599b224bsm1150450jam.121.2023.07.21.09.17.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jul 2023 09:17:05 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     hch@lst.de, andres@anarazel.de, david@fromorbit.com,
        djwong@kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 8/9] iomap: support IOCB_DIO_CALLER_COMP
Date:   Fri, 21 Jul 2023 10:16:49 -0600
Message-Id: <20230721161650.319414-9-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230721161650.319414-1-axboe@kernel.dk>
References: <20230721161650.319414-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If IOCB_DIO_CALLER_COMP is set, utilize that to set kiocb->dio_complete
handler and data for that callback. Rather than punt the completion to a
workqueue, we pass back the handler and data to the issuer and will get
a callback from a safe task context.

Using the following fio job to randomly dio write 4k blocks at
queue depths of 1..16:

fio --name=dio-write --filename=/data1/file --time_based=1 \
--runtime=10 --bs=4096 --rw=randwrite --norandommap --buffered=0 \
--cpus_allowed=4 --ioengine=io_uring --iodepth=$depth

shows the following results before and after this patch:

	Stock	Patched		Diff
=======================================
QD1	155K	162K		+ 4.5%
QD2	290K	313K		+ 7.9%
QD4	533K	597K		+12.0%
QD8	604K	827K		+36.9%
QD16	615K	845K		+37.4%

which shows nice wins all around. If we factored in per-IOP efficiency,
the wins look even nicer. This becomes apparent as queue depth rises,
as the offloaded workqueue completions runs out of steam.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/iomap/direct-io.c | 55 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 54 insertions(+), 1 deletion(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 6ffa1b1ebe90..ae9046d16d71 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -20,6 +20,7 @@
  * Private flags for iomap_dio, must not overlap with the public ones in
  * iomap.h:
  */
+#define IOMAP_DIO_CALLER_COMP	(1 << 26)
 #define IOMAP_DIO_INLINE_COMP	(1 << 27)
 #define IOMAP_DIO_WRITE_THROUGH	(1 << 28)
 #define IOMAP_DIO_NEED_SYNC	(1 << 29)
@@ -132,6 +133,11 @@ ssize_t iomap_dio_complete(struct iomap_dio *dio)
 }
 EXPORT_SYMBOL_GPL(iomap_dio_complete);
 
+static ssize_t iomap_dio_deferred_complete(void *data)
+{
+	return iomap_dio_complete(data);
+}
+
 static void iomap_dio_complete_work(struct work_struct *work)
 {
 	struct iomap_dio *dio = container_of(work, struct iomap_dio, aio.work);
@@ -192,6 +198,31 @@ void iomap_dio_bio_end_io(struct bio *bio)
 		goto release_bio;
 	}
 
+	/*
+	 * If this dio is flagged with IOMAP_DIO_CALLER_COMP, then schedule
+	 * our completion that way to avoid an async punt to a workqueue.
+	 */
+	if (dio->flags & IOMAP_DIO_CALLER_COMP) {
+		/* only polled IO cares about private cleared */
+		iocb->private = dio;
+		iocb->dio_complete = iomap_dio_deferred_complete;
+
+		/*
+		 * Invoke ->ki_complete() directly. We've assigned our
+		 * dio_complete callback handler, and since the issuer set
+		 * IOCB_DIO_CALLER_COMP, we know their ki_complete handler will
+		 * notice ->dio_complete being set and will defer calling that
+		 * handler until it can be done from a safe task context.
+		 *
+		 * Note that the 'res' being passed in here is not important
+		 * for this case. The actual completion value of the request
+		 * will be gotten from dio_complete when that is run by the
+		 * issuer.
+		 */
+		iocb->ki_complete(iocb, 0);
+		goto release_bio;
+	}
+
 	/*
 	 * Async DIO completion that requires filesystem level completion work
 	 * gets punted to a work queue to complete as the operation may require
@@ -288,12 +319,17 @@ static loff_t iomap_dio_bio_iter(const struct iomap_iter *iter,
 		 * after IO completion such as unwritten extent conversion) and
 		 * the underlying device either supports FUA or doesn't have
 		 * a volatile write cache. This allows us to avoid cache flushes
-		 * on IO completion.
+		 * on IO completion. If we can't use writethrough and need to
+		 * sync, disable in-task completions as dio completion will
+		 * need to call generic_write_sync() which will do a blocking
+		 * fsync / cache flush call.
 		 */
 		if (!(iomap->flags & (IOMAP_F_SHARED|IOMAP_F_DIRTY)) &&
 		    (dio->flags & IOMAP_DIO_WRITE_THROUGH) &&
 		    (bdev_fua(iomap->bdev) || !bdev_write_cache(iomap->bdev)))
 			use_fua = true;
+		else if (dio->flags & IOMAP_DIO_NEED_SYNC)
+			dio->flags &= ~IOMAP_DIO_CALLER_COMP;
 	}
 
 	/*
@@ -319,6 +355,14 @@ static loff_t iomap_dio_bio_iter(const struct iomap_iter *iter,
 		pad = pos & (fs_block_size - 1);
 		if (pad)
 			iomap_dio_zero(iter, dio, pos - pad, pad);
+
+		/*
+		 * If need_zeroout is set, then this is a new or unwritten
+		 * extent, or dirty file metadata have not been persisted to
+		 * disk. These need extra handling at completion time, so
+		 * disable in-task deferred completion for those.
+		 */
+		dio->flags &= ~IOMAP_DIO_CALLER_COMP;
 	}
 
 	/*
@@ -557,6 +601,15 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 		iomi.flags |= IOMAP_WRITE;
 		dio->flags |= IOMAP_DIO_WRITE;
 
+		/*
+		 * Flag as supporting deferred completions, if the issuer
+		 * groks it. This can avoid a workqueue punt for writes.
+		 * We may later clear this flag if we need to do other IO
+		 * as part of this IO completion.
+		 */
+		if (iocb->ki_flags & IOCB_DIO_CALLER_COMP)
+			dio->flags |= IOMAP_DIO_CALLER_COMP;
+
 		if (dio_flags & IOMAP_DIO_OVERWRITE_ONLY) {
 			ret = -EAGAIN;
 			if (iomi.pos >= dio->i_size ||
-- 
2.40.1

