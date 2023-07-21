Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 537F275CE26
	for <lists+io-uring@lfdr.de>; Fri, 21 Jul 2023 18:18:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232566AbjGUQSi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Jul 2023 12:18:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232694AbjGUQSF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Jul 2023 12:18:05 -0400
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D882D421C
        for <io-uring@vger.kernel.org>; Fri, 21 Jul 2023 09:17:02 -0700 (PDT)
Received: by mail-io1-xd33.google.com with SMTP id ca18e2360f4ac-7835bbeb6a0so28197439f.0
        for <io-uring@vger.kernel.org>; Fri, 21 Jul 2023 09:17:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689956219; x=1690561019;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z7yoihIdu5UPPNOooKn2vi0vzZ8WciIEgPTPhkQQaos=;
        b=x8Lt3uasN44rcnJmIUZvfnrKhQLZC36ZOXD3rCJZ6chD4Xkj6qYJjWRuYnex7ZraWp
         s7gKjMrw0rzE7502lXlPwomvek+ykNBFkBzcWkfcrjAiK/EKMI1nx0LotnxFsmlbAegI
         8l4NmDuosjGN5VnB+pgPWQ4PHX34au0MFG25qAgMkaSoM0Azdy8mxoEuaoue66L1mhai
         ma8PDpwJSawKMohbp2YQEW0hf9kXBlbv6pxvuao/xAAIxJ0OBn40pUmxevKU5485HXDg
         ESZyV6R5cclSYgFMyl16KYVT643Kh6s4HkfAQQMAJhJtuAe25ea9BZTlfD/YNhQafTYr
         MBWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689956219; x=1690561019;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z7yoihIdu5UPPNOooKn2vi0vzZ8WciIEgPTPhkQQaos=;
        b=b0jFUFyZULACyp5zAN8r6d3M6Zz0fNpwEsUz9wwzAf5kJiet/zjnS3AiVbibeSGHfS
         fb45oFL/BwTIUw3reJzutKzKkYKcrtPut2OgRNRwC8RTJCYRloleIJXFe1E+20M7xEFN
         t1BJhzcyzikWksFt9fMr9D6yDlPH1/DNoifAD7mDALpGzVz0KMzf9TiU+peO0tEevOvG
         LmpifR7DIsne+QTYLFBhpGeg7iHT0cKCGivLWI3C/wVwaN0l/mwR+ziCHd+1Af7h0wm2
         ULFmRG5F4wc0iLjEOLMVd6mE3N6eIrHqZacwdZdPQtjr7KsGDMNc7Hdc2e9Z+IriV3Ir
         1dnw==
X-Gm-Message-State: ABy/qLbE0FNgJDv4R4pr7gGrGDnAbAe55Y/tZAsXWLz/fksAhcFo07Bv
        P3z7DnJD5m19L3wfE3DlI1bHEADraXtP7/j0ji0=
X-Google-Smtp-Source: APBJJlEcEMTariaTZWPEkwzOzKZajcPLUhmagDsKQgxPwC2xgu7zprXfCI6DVPyp3uqZ0W+mgc1V8Q==
X-Received: by 2002:a05:6602:1a05:b0:780:c6bb:ad8d with SMTP id bo5-20020a0566021a0500b00780c6bbad8dmr2382978iob.0.1689956219453;
        Fri, 21 Jul 2023 09:16:59 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id l7-20020a02a887000000b0042b599b224bsm1150450jam.121.2023.07.21.09.16.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jul 2023 09:16:58 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     hch@lst.de, andres@anarazel.de, david@fromorbit.com,
        djwong@kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/9] iomap: treat a write through cache the same as FUA
Date:   Fri, 21 Jul 2023 10:16:44 -0600
Message-Id: <20230721161650.319414-4-axboe@kernel.dk>
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

Whether we have a write back cache and are using FUA or don't have
a write back cache at all is the same situation. Treat them the same.

This makes the IOMAP_DIO_WRITE_FUA name a bit misleading, as we have
two cases that provide stable writes:

1) Volatile write cache with FUA writes
2) Normal write without a volatile write cache

Rename that flag to IOMAP_DIO_STABLE_WRITE to make that clearer, and
update some of the FUA comments as well.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/iomap/direct-io.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index c654612b24e5..17b695b0e9d6 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -21,7 +21,7 @@
  * iomap.h:
  */
 #define IOMAP_DIO_INLINE_COMP	(1 << 27)
-#define IOMAP_DIO_WRITE_FUA	(1 << 28)
+#define IOMAP_DIO_WRITE_THROUGH	(1 << 28)
 #define IOMAP_DIO_NEED_SYNC	(1 << 29)
 #define IOMAP_DIO_WRITE		(1 << 30)
 #define IOMAP_DIO_DIRTY		(1 << 31)
@@ -222,7 +222,7 @@ static void iomap_dio_zero(const struct iomap_iter *iter, struct iomap_dio *dio,
 /*
  * Figure out the bio's operation flags from the dio request, the
  * mapping, and whether or not we want FUA.  Note that we can end up
- * clearing the WRITE_FUA flag in the dio request.
+ * clearing the WRITE_THROUGH flag in the dio request.
  */
 static inline blk_opf_t iomap_dio_bio_opflags(struct iomap_dio *dio,
 		const struct iomap *iomap, bool use_fua)
@@ -236,7 +236,7 @@ static inline blk_opf_t iomap_dio_bio_opflags(struct iomap_dio *dio,
 	if (use_fua)
 		opflags |= REQ_FUA;
 	else
-		dio->flags &= ~IOMAP_DIO_WRITE_FUA;
+		dio->flags &= ~IOMAP_DIO_WRITE_THROUGH;
 
 	return opflags;
 }
@@ -276,11 +276,13 @@ static loff_t iomap_dio_bio_iter(const struct iomap_iter *iter,
 		 * Use a FUA write if we need datasync semantics, this is a pure
 		 * data IO that doesn't require any metadata updates (including
 		 * after IO completion such as unwritten extent conversion) and
-		 * the underlying device supports FUA. This allows us to avoid
-		 * cache flushes on IO completion.
+		 * the underlying device either supports FUA or doesn't have
+		 * a volatile write cache. This allows us to avoid cache flushes
+		 * on IO completion.
 		 */
 		if (!(iomap->flags & (IOMAP_F_SHARED|IOMAP_F_DIRTY)) &&
-		    (dio->flags & IOMAP_DIO_WRITE_FUA) && bdev_fua(iomap->bdev))
+		    (dio->flags & IOMAP_DIO_WRITE_THROUGH) &&
+		    (bdev_fua(iomap->bdev) || !bdev_write_cache(iomap->bdev)))
 			use_fua = true;
 	}
 
@@ -560,12 +562,15 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 
 		       /*
 			* For datasync only writes, we optimistically try
-			* using FUA for this IO.  Any non-FUA write that
-			* occurs will clear this flag, hence we know before
-			* completion whether a cache flush is necessary.
+			* using WRITE_THROUGH for this IO. Stable writes are
+			* either FUA with a write cache, or a normal write to
+			* a device without a volatile write cache. For the
+			* former, Any non-FUA write that occurs will clear this
+			* flag, hence we know before completion whether a cache
+			* flush is necessary.
 			*/
 			if (!(iocb->ki_flags & IOCB_SYNC))
-				dio->flags |= IOMAP_DIO_WRITE_FUA;
+				dio->flags |= IOMAP_DIO_WRITE_THROUGH;
 		}
 
 		/*
@@ -627,10 +632,10 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 		iomap_dio_set_error(dio, ret);
 
 	/*
-	 * If all the writes we issued were FUA, we don't need to flush the
+	 * If all the writes we issued were stable, we don't need to flush the
 	 * cache on IO completion. Clear the sync flag for this case.
 	 */
-	if (dio->flags & IOMAP_DIO_WRITE_FUA)
+	if (dio->flags & IOMAP_DIO_WRITE_THROUGH)
 		dio->flags &= ~IOMAP_DIO_NEED_SYNC;
 
 	WRITE_ONCE(iocb->private, dio->submit.poll_bio);
-- 
2.40.1

