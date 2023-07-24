Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E812D7602CA
	for <lists+io-uring@lfdr.de>; Tue, 25 Jul 2023 00:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230288AbjGXWz0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Jul 2023 18:55:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230344AbjGXWzZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Jul 2023 18:55:25 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3695DE5A
        for <io-uring@vger.kernel.org>; Mon, 24 Jul 2023 15:55:24 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id d9443c01a7336-1bb91c20602so3392835ad.0
        for <io-uring@vger.kernel.org>; Mon, 24 Jul 2023 15:55:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1690239323; x=1690844123;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+DqlprFT3rIJ93hb4ytZ/U+5DLbYbXZZtopIzdBjbSs=;
        b=qZyXJ5GOrSNROW0VLYT+HLv0T1KL6Mh1WHD9ZALp0ngmW4xvke7aJv0gGltZeOBrt7
         bYoLfr0qjEzJN0R3KP25nnJ08in3S5axLYskHHTWQa8/hIZk22fjqiljQemLyYOewTUp
         vM3o42lLuoR0DnSDGIF9IyswN6hE/xUDaE7CqjnM3Cpjv/PnCLuQplD8m28cfjs+DjJL
         86VtF80yyUGCWXrYz3lDs1YP135U8OlFUr8wntQYEUacAU8U5UdksHX+IxUYL7C77Wqn
         Egf3Snu+mupFd09XqzSbFVwpjOB5GTaRwQ1+lHrY5pxcqXhGEa7adagVSIppXj3681SW
         PZLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690239323; x=1690844123;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+DqlprFT3rIJ93hb4ytZ/U+5DLbYbXZZtopIzdBjbSs=;
        b=cuepMrBebHNuxoaFMNdbqc1V0vCnfBp7DRS06mG/D3e6acAWaKuJl1a/PmrZoZMdHM
         NsMt7GIsCYnqyU6LgZsFzMvLsQjcgfmKGN0Cjd+tB4eArZ42heyBfm5/Yd5c0hBcqUta
         G5XHmVsvpPuUpRPevr0gto1cWPH3dvfwYcihKm/1TjMX4bq4QeqpP0hSTsvUkMB3f01Z
         Uuh13QUykl9GXpcYGATUiOEIg/ELZykcFNq1LodLMak0XzbsqfFhoxTd/cJLpYPx6htz
         bqaYuTnKY3mJQfMjm/qeC3ZfsCpS03QpInXPPlkccwBrD6whudL7R4R2PbbFp04ReoZv
         S/9Q==
X-Gm-Message-State: ABy/qLYBmtG5S0/Pa7/+DPLZaXChg5M4Yh5mE3zkQy26vzyS2A9EwFKV
        +H24wB/4Iyy/XfWNh22eBPgwYTzYTtD76XwNAhE=
X-Google-Smtp-Source: APBJJlF7N9AmmkBTysR/mafF4wuzyAwYLu/QLUnYzQrf7ApEXKA6OZJFE1/IL+aC4TOHfQMOGzedBg==
X-Received: by 2002:a17:902:ea01:b0:1bb:83ec:832 with SMTP id s1-20020a170902ea0100b001bb83ec0832mr10583875plg.2.1690239323510;
        Mon, 24 Jul 2023 15:55:23 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id p7-20020a1709026b8700b001acae9734c0sm9424733plk.266.2023.07.24.15.55.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jul 2023 15:55:23 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     hch@lst.de, andres@anarazel.de, david@fromorbit.com,
        djwong@kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 8/8] iomap: support IOCB_DIO_CALLER_COMP
Date:   Mon, 24 Jul 2023 16:55:11 -0600
Message-Id: <20230724225511.599870-9-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230724225511.599870-1-axboe@kernel.dk>
References: <20230724225511.599870-1-axboe@kernel.dk>
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
 fs/iomap/direct-io.c | 62 ++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 60 insertions(+), 2 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index b943bc5c7b18..bcd3f8cf5ea4 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -20,6 +20,7 @@
  * Private flags for iomap_dio, must not overlap with the public ones in
  * iomap.h:
  */
+#define IOMAP_DIO_CALLER_COMP	(1U << 26)
 #define IOMAP_DIO_INLINE_COMP	(1U << 27)
 #define IOMAP_DIO_WRITE_THROUGH	(1U << 28)
 #define IOMAP_DIO_NEED_SYNC	(1U << 29)
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
@@ -182,6 +188,31 @@ void iomap_dio_bio_end_io(struct bio *bio)
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
@@ -278,12 +309,17 @@ static loff_t iomap_dio_bio_iter(const struct iomap_iter *iter,
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
@@ -298,10 +334,23 @@ static loff_t iomap_dio_bio_iter(const struct iomap_iter *iter,
 		goto out;
 
 	/*
-	 * We can only poll for single bio I/Os.
+	 * We can only do deferred completion for pure overwrites that
+	 * don't require additional IO at completion. This rules out
+	 * writes that need zeroing or extent conversion, extend
+	 * the file size, or issue journal IO or cache flushes
+	 * during completion processing.
 	 */
 	if (need_zeroout ||
+	    ((dio->flags & IOMAP_DIO_NEED_SYNC) && !use_fua) ||
 	    ((dio->flags & IOMAP_DIO_WRITE) && pos >= i_size_read(inode)))
+		dio->flags &= ~IOMAP_DIO_CALLER_COMP;
+
+	/*
+	 * The rules for polled IO completions follow the guidelines as the
+	 * ones we set for inline and deferred completions. If none of those
+	 * are available for this IO, clear the polled flag.
+	 */
+	if (!(dio->flags & (IOMAP_DIO_INLINE_COMP|IOMAP_DIO_CALLER_COMP)))
 		dio->iocb->ki_flags &= ~IOCB_HIPRI;
 
 	if (need_zeroout) {
@@ -547,6 +596,15 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
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

