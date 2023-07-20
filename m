Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB76375B649
	for <lists+io-uring@lfdr.de>; Thu, 20 Jul 2023 20:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231314AbjGTSN2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Jul 2023 14:13:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231301AbjGTSN1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Jul 2023 14:13:27 -0400
Received: from mail-io1-xd2f.google.com (mail-io1-xd2f.google.com [IPv6:2607:f8b0:4864:20::d2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6364A270B
        for <io-uring@vger.kernel.org>; Thu, 20 Jul 2023 11:13:26 -0700 (PDT)
Received: by mail-io1-xd2f.google.com with SMTP id ca18e2360f4ac-760dff4b701so13424939f.0
        for <io-uring@vger.kernel.org>; Thu, 20 Jul 2023 11:13:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689876805; x=1690481605;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uXqZdaZ6Mquv4fIr1Ve7JSk8CcFji/eSZ6SaOz1unh0=;
        b=gkBbhoaJhW9QE7tFd5BKEysDmJS6oIW0zakPz2TmWExyM5h0e0/zYspxWItXES0B2c
         AmUMz1xk4bpSXgZVRJDz2L59lYjvt+2CPyXqTha5Tn7xc3FAUTHNRP/9Uu3ELEcHGUek
         mbbJ7WZ2ryoaRSW1t37jYZfYAYw98N8W2M8lS05npoJjj3QTOnCHIdx5tTwqHlfaVWoG
         4bsgA5MEtBPU75KQdCvK1lFVtqrIkRIu6bSeVgnEUAN7Dj8kp4scq7G8nxRL27W67QBL
         ZXPin3bk6sqG7COAkitQ+WWXoUIZyHPvJal/OYtfGyLm2JLIZ1sYkkrE5mjoQJxLK1FY
         Lj7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689876805; x=1690481605;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uXqZdaZ6Mquv4fIr1Ve7JSk8CcFji/eSZ6SaOz1unh0=;
        b=Ozmg9cu18MKdFJqIr4syBYxmCoVEK2+ebMprJFUFxXzguHb6MJHd56ph7xj3yt820z
         rbyEDS6pKo27On/SG5acHtsAEdW4Ey+y3V6vC5o/8NtWrjNuInnltLAHdX1OMerjKT6z
         ca3ctACCZ1Te5vcCJkXGJhtGRD36yAI2jlGymOch/qvGsZ7LqT+Wgym2yq0a3qcBxN/0
         AqkAITFU1n8F3H3LKTmNZqUlEGckjtCVI5DhSXdtHRxrrCysz6aDWat/PptKo1qPQH3C
         hZPODGzOXwfJOI355oFxXTaOESxv8Slai22kRP3ujBm1j5x6GALi9UeMkCYoFmuPD/Dj
         7REQ==
X-Gm-Message-State: ABy/qLZK21wYX46SlW74xwRJPkInBGQo7A3yIGmf63Khk+WB5XqtLEen
        r+lGJatiVrAeZ2YJo+v6l7kpwYVLs2z+Ny5efW4=
X-Google-Smtp-Source: APBJJlH7ibxVZcFGYESD3kYWTxfRRHxo2GQ6mcaCElNBn5D+3k2OZwRxH4WCvaIa00ZBvqqERnpfcw==
X-Received: by 2002:a92:dacf:0:b0:345:db9a:be2c with SMTP id o15-20020a92dacf000000b00345db9abe2cmr3262388ilq.1.1689876805117;
        Thu, 20 Jul 2023 11:13:25 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id v6-20020a92c6c6000000b003457e1daba8sm419171ilm.8.2023.07.20.11.13.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jul 2023 11:13:24 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     hch@lst.de, andres@anarazel.de, david@fromorbit.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 8/8] iomap: support IOCB_DIO_DEFER
Date:   Thu, 20 Jul 2023 12:13:10 -0600
Message-Id: <20230720181310.71589-9-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230720181310.71589-1-axboe@kernel.dk>
References: <20230720181310.71589-1-axboe@kernel.dk>
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

If IOCB_DIO_DEFER is set, utilize that to set kiocb->dio_complete handler
and data for that callback. Rather than punt the completion to a
workqueue, we pass back the handler and data to the issuer and will get a
callback from a safe task context.

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

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/iomap/direct-io.c | 54 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 53 insertions(+), 1 deletion(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index cce9af019705..de86680968a4 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -20,6 +20,7 @@
  * Private flags for iomap_dio, must not overlap with the public ones in
  * iomap.h:
  */
+#define IOMAP_DIO_DEFER_COMP	(1 << 26)
 #define IOMAP_DIO_INLINE_COMP	(1 << 27)
 #define IOMAP_DIO_STABLE_WRITE	(1 << 28)
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
+	 * If this dio is flagged with IOMAP_DIO_DEFER_COMP, then schedule
+	 * our completion that way to avoid an async punt to a workqueue.
+	 */
+	if (dio->flags & IOMAP_DIO_DEFER_COMP) {
+		/* only polled IO cares about private cleared */
+		iocb->private = dio;
+		iocb->dio_complete = iomap_dio_deferred_complete;
+
+		/*
+		 * Invoke ->ki_complete() directly. We've assigned out
+		 * dio_complete callback handler, and since the issuer set
+		 * IOCB_DIO_DEFER, we know their ki_complete handler will
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
+		 * on IO completion. If we can't use stable writes and need to
+		 * sync, disable in-task completions as dio completion will
+		 * need to call generic_write_sync() which will do a blocking
+		 * fsync / cache flush call.
 		 */
 		if (!(iomap->flags & (IOMAP_F_SHARED|IOMAP_F_DIRTY)) &&
 		    (dio->flags & IOMAP_DIO_STABLE_WRITE) &&
 		    (bdev_fua(iomap->bdev) || !bdev_write_cache(iomap->bdev)))
 			use_fua = true;
+		else if (dio->flags & IOMAP_DIO_NEED_SYNC)
+			dio->flags &= ~IOMAP_DIO_DEFER_COMP;
 	}
 
 	/*
@@ -319,6 +355,13 @@ static loff_t iomap_dio_bio_iter(const struct iomap_iter *iter,
 		pad = pos & (fs_block_size - 1);
 		if (pad)
 			iomap_dio_zero(iter, dio, pos - pad, pad);
+
+		/*
+		 * If need_zeroout is set, then this is a new or unwritten
+		 * extent. These need extra handling at completion time, so
+		 * disable in-task deferred completion for those.
+		 */
+		dio->flags &= ~IOMAP_DIO_DEFER_COMP;
 	}
 
 	/*
@@ -557,6 +600,15 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 		iomi.flags |= IOMAP_WRITE;
 		dio->flags |= IOMAP_DIO_WRITE;
 
+		/*
+		 * Flag as supporting deferred completions, if the issuer
+		 * groks it. This can avoid a workqueue punt for writes.
+		 * We may later clear this flag if we need to do other IO
+		 * as part of this IO completion.
+		 */
+		if (iocb->ki_flags & IOCB_DIO_DEFER)
+			dio->flags |= IOMAP_DIO_DEFER_COMP;
+
 		if (dio_flags & IOMAP_DIO_OVERWRITE_ONLY) {
 			ret = -EAGAIN;
 			if (iomi.pos >= dio->i_size ||
-- 
2.40.1

