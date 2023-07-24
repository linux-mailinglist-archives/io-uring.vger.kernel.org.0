Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05E917602C0
	for <lists+io-uring@lfdr.de>; Tue, 25 Jul 2023 00:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbjGXWzV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 24 Jul 2023 18:55:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230062AbjGXWzU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 24 Jul 2023 18:55:20 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 780F3100
        for <io-uring@vger.kernel.org>; Mon, 24 Jul 2023 15:55:19 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id d9443c01a7336-1bbadf9ed37so1478745ad.0
        for <io-uring@vger.kernel.org>; Mon, 24 Jul 2023 15:55:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1690239318; x=1690844118;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Wx3gDejnv+MYuO8cUn67Qw106/rsCHumB4kwemSJRZY=;
        b=bm+YKX6D1BwkR4vrs42vdWoeqGRLlquEzDtbB0b00LKREL0LWQEHHMtZV+Lve3k79k
         nJlObut1EZppwPrHtzilkZnngV2wP5bNloU+coVqsuEOL/nmSD5mM5mVyfZeCs0KdGrc
         eUjDg+Mswj6k7ivu7z7L/9wxEMuwiEJoztbGAfmnGDVcsfkIIXcDMR+CB0aT5Fb3WpO0
         qaS049XZo1myuKfEwG+guOIHssrbJ1NhrfOxOG3Kyrt8JeE64/L+kHziZl6wDN70GdmX
         P92zM73IY4gVZwhJJBo4VQCBKTWrSEt9KqfghLeUxNDlFBApp8YNLhVNxJA/StUHYMAp
         px6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690239318; x=1690844118;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Wx3gDejnv+MYuO8cUn67Qw106/rsCHumB4kwemSJRZY=;
        b=dLSd29ZngFCwRFE6UfTPakXciQqcZ2RW6eP+ZwOUENCTzyDjhF8tPxOpxmKd94D4ot
         5AwVbSXucsP+69/6r4i4orWino12sfx9vfhT0qtCwHmeB62ZveWSEvJ/3wVEhzAI/DIs
         jWMpLLftRXr18ZSaOkju8v8Ra1/sEIOEHeO4dziGbmtMZlSi4vakNPA1oHFQ8RKpzN2x
         SqN1zn5MikTbqeUw+SqbiuO0db6LNkF6HFP6xhISE1E3VODb9XJAHiHfRFYMW5+y5PCx
         LnBKC/c4nf9TzcIQK7P3A1Ow6pqI7nWgGFwlB3fwtexNKvHibgfdFJLYhJw3HUvRzNqc
         Bq0A==
X-Gm-Message-State: ABy/qLaap2ZFIdkqGPos1nCMKSztCv32UydyerCwXg7ZSjAMmYpi0L3z
        vm3M3krk/gik/vbGCT336X8MmG6UoTdIqGyUg1c=
X-Google-Smtp-Source: APBJJlHvNGqZ/QpFqqw+CFa53OAtegzHdOldV4x76K1a9aUXPkJY8NVWbAeVvyGXes1jwAY4Frt8tw==
X-Received: by 2002:a17:902:e74d:b0:1bb:ac37:384b with SMTP id p13-20020a170902e74d00b001bbac37384bmr3491050plf.6.1690239318701;
        Mon, 24 Jul 2023 15:55:18 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id p7-20020a1709026b8700b001acae9734c0sm9424733plk.266.2023.07.24.15.55.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Jul 2023 15:55:18 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     hch@lst.de, andres@anarazel.de, david@fromorbit.com,
        djwong@kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/8] iomap: treat a write through cache the same as FUA
Date:   Mon, 24 Jul 2023 16:55:06 -0600
Message-Id: <20230724225511.599870-4-axboe@kernel.dk>
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

Whether we have a write back cache and are using FUA or don't have
a write back cache at all is the same situation. Treat them the same.

This makes the IOMAP_DIO_WRITE_FUA name a bit misleading, as we have
two cases that provide stable writes:

1) Volatile write cache with FUA writes
2) Normal write without a volatile write cache

Rename that flag to IOMAP_DIO_STABLE_WRITE to make that clearer, and
update some of the FUA comments as well.

Reviewed-by: Darrick J. Wong <djwong@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/iomap/direct-io.c | 34 ++++++++++++++++++++--------------
 1 file changed, 20 insertions(+), 14 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index 7d627d43d10b..6b690fc22365 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -20,7 +20,7 @@
  * Private flags for iomap_dio, must not overlap with the public ones in
  * iomap.h:
  */
-#define IOMAP_DIO_WRITE_FUA	(1U << 28)
+#define IOMAP_DIO_WRITE_THROUGH	(1U << 28)
 #define IOMAP_DIO_NEED_SYNC	(1U << 29)
 #define IOMAP_DIO_WRITE		(1U << 30)
 #define IOMAP_DIO_DIRTY		(1U << 31)
@@ -219,7 +219,7 @@ static void iomap_dio_zero(const struct iomap_iter *iter, struct iomap_dio *dio,
 /*
  * Figure out the bio's operation flags from the dio request, the
  * mapping, and whether or not we want FUA.  Note that we can end up
- * clearing the WRITE_FUA flag in the dio request.
+ * clearing the WRITE_THROUGH flag in the dio request.
  */
 static inline blk_opf_t iomap_dio_bio_opflags(struct iomap_dio *dio,
 		const struct iomap *iomap, bool use_fua)
@@ -233,7 +233,7 @@ static inline blk_opf_t iomap_dio_bio_opflags(struct iomap_dio *dio,
 	if (use_fua)
 		opflags |= REQ_FUA;
 	else
-		dio->flags &= ~IOMAP_DIO_WRITE_FUA;
+		dio->flags &= ~IOMAP_DIO_WRITE_THROUGH;
 
 	return opflags;
 }
@@ -273,11 +273,13 @@ static loff_t iomap_dio_bio_iter(const struct iomap_iter *iter,
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
 
@@ -553,13 +555,16 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 			dio->flags |= IOMAP_DIO_NEED_SYNC;
 
 		       /*
-			* For datasync only writes, we optimistically try
-			* using FUA for this IO.  Any non-FUA write that
-			* occurs will clear this flag, hence we know before
-			* completion whether a cache flush is necessary.
+			* For datasync only writes, we optimistically try using
+			* WRITE_THROUGH for this IO. This flag requires either
+			* FUA writes through the device's write cache, or a
+			* normal write to a device without a volatile write
+			* cache. For the former, Any non-FUA write that occurs
+			* will clear this flag, hence we know before completion
+			* whether a cache flush is necessary.
 			*/
 			if (!(iocb->ki_flags & IOCB_SYNC))
-				dio->flags |= IOMAP_DIO_WRITE_FUA;
+				dio->flags |= IOMAP_DIO_WRITE_THROUGH;
 		}
 
 		/*
@@ -621,10 +626,11 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 		iomap_dio_set_error(dio, ret);
 
 	/*
-	 * If all the writes we issued were FUA, we don't need to flush the
-	 * cache on IO completion. Clear the sync flag for this case.
+	 * If all the writes we issued were already written through to the
+	 * media, we don't need to flush the cache on IO completion. Clear the
+	 * sync flag for this case.
 	 */
-	if (dio->flags & IOMAP_DIO_WRITE_FUA)
+	if (dio->flags & IOMAP_DIO_WRITE_THROUGH)
 		dio->flags &= ~IOMAP_DIO_NEED_SYNC;
 
 	WRITE_ONCE(iocb->private, dio->submit.poll_bio);
-- 
2.40.1

