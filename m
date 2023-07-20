Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBD1D75B63F
	for <lists+io-uring@lfdr.de>; Thu, 20 Jul 2023 20:13:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231211AbjGTSNV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 20 Jul 2023 14:13:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbjGTSNU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 20 Jul 2023 14:13:20 -0400
Received: from mail-il1-x12c.google.com (mail-il1-x12c.google.com [IPv6:2607:f8b0:4864:20::12c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C051992
        for <io-uring@vger.kernel.org>; Thu, 20 Jul 2023 11:13:19 -0700 (PDT)
Received: by mail-il1-x12c.google.com with SMTP id e9e14a558f8ab-34637e55d9dso1179095ab.1
        for <io-uring@vger.kernel.org>; Thu, 20 Jul 2023 11:13:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689876798; x=1690481598;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lO/y0JczduNfKF+qr7m+WoYz7I0WlwYaSUZRVfc+zV4=;
        b=Pu/zmaJZ90qixup8NFEiStAk1UF0+44ZzF3j0OatYBtmtF3Gy4E0O+Dj2c2tEZkiem
         oNjk/U4ulEDcKKOVfsRpe7QvqLeQp2s/gMbZCUBK2yR2DFYnrtOTFxH4rZipRCRyPoii
         uY8TVDqC7Oix7O441rOzuJUU+WfZ+j/l4oI3msU2Dq2PMU5uqJfX2tKtdQ6FUPOADp6I
         QQESLDkScyP48b+XwLJgO1fz04/S6J/fzGXaygiN17dnm4zsYbdtjvTee9nosFmcV0QV
         WJB6iyJC2QRnSUvFl9ZjzceIVXB+oO4ysU/LGDKKOs8E8K1lePgmvNrMLzmIWGgkcqnh
         c0rw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689876798; x=1690481598;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lO/y0JczduNfKF+qr7m+WoYz7I0WlwYaSUZRVfc+zV4=;
        b=Jt8ZYpliwh8rYYqGyXWkAbLTN+1CASDTI2snPGw36fpUTPvNj84ZkGHHH6jG5NAnIo
         QdMlH97oZtbXwsxMYELbAHSjeNZBZLl6E8KaYQwPU0oKUXpcNj88u+oyTsonZnS7dhe1
         oQ73fRhajHKpCml4ZRFaY0oGXZnBhwBgfSlllD3Rc1n2kqUgIRpTXu2KBzyTkbMok8Ky
         /2rsNb8Yoo079mjJw/I+O1fX3GFNwSFuWNsi4AJBP/LZeXmeYpb6WT3rcml+QjeORJlE
         TLAtwvESvIzmFDRo4jydB44x9+4HkJk1DM5+i+TuWvetppaWCl+m/cNdtFWCCH3HzpQH
         vcWQ==
X-Gm-Message-State: ABy/qLbcKtGeFspFTy41+cYjE5pKCeuksZCn27l7X6wU3XGO/1ZeGR/3
        +PgV7rA6k9WH1gBNgFTOQHQcU3hCXw+f+mlKgAc=
X-Google-Smtp-Source: APBJJlE7fUZUWzIAkTh5EVdAECs4Ej9tOOcP9r7khn+zVkqb+CMEgaCM9pBkodR5d/h/5QA0K7QCcg==
X-Received: by 2002:a05:6e02:17c8:b0:346:4eb9:9081 with SMTP id z8-20020a056e0217c800b003464eb99081mr12451755ilu.3.1689876798649;
        Thu, 20 Jul 2023 11:13:18 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id v6-20020a92c6c6000000b003457e1daba8sm419171ilm.8.2023.07.20.11.13.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Jul 2023 11:13:17 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org
Cc:     hch@lst.de, andres@anarazel.de, david@fromorbit.com,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/8] iomap: treat a write through cache the same as FUA
Date:   Thu, 20 Jul 2023 12:13:05 -0600
Message-Id: <20230720181310.71589-4-axboe@kernel.dk>
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

Whether we have a write back cache and are using FUA or don't have
a write back cache at all is the same situation. Treat them the same.

This makes the IOMAP_DIO_WRITE_FUA name a bit misleading, as we have
two cases that provide stable writes:

1) Volatile write cache with FUA writes
2) Normal write without a volatile write cache

Rename that flag to IOMAP_DIO_STABLE_WRITE to make that clearer, and
update some of the FUA comments as well.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/iomap/direct-io.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index c654612b24e5..9f97d0d03724 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -21,7 +21,7 @@
  * iomap.h:
  */
 #define IOMAP_DIO_INLINE_COMP	(1 << 27)
-#define IOMAP_DIO_WRITE_FUA	(1 << 28)
+#define IOMAP_DIO_STABLE_WRITE	(1 << 28)
 #define IOMAP_DIO_NEED_SYNC	(1 << 29)
 #define IOMAP_DIO_WRITE		(1 << 30)
 #define IOMAP_DIO_DIRTY		(1 << 31)
@@ -222,7 +222,7 @@ static void iomap_dio_zero(const struct iomap_iter *iter, struct iomap_dio *dio,
 /*
  * Figure out the bio's operation flags from the dio request, the
  * mapping, and whether or not we want FUA.  Note that we can end up
- * clearing the WRITE_FUA flag in the dio request.
+ * clearing the STABLE_WRITE flag in the dio request.
  */
 static inline blk_opf_t iomap_dio_bio_opflags(struct iomap_dio *dio,
 		const struct iomap *iomap, bool use_fua)
@@ -236,7 +236,7 @@ static inline blk_opf_t iomap_dio_bio_opflags(struct iomap_dio *dio,
 	if (use_fua)
 		opflags |= REQ_FUA;
 	else
-		dio->flags &= ~IOMAP_DIO_WRITE_FUA;
+		dio->flags &= ~IOMAP_DIO_STABLE_WRITE;
 
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
+		    (dio->flags & IOMAP_DIO_STABLE_WRITE) &&
+		    (bdev_fua(iomap->bdev) || !bdev_write_cache(iomap->bdev)))
 			use_fua = true;
 	}
 
@@ -560,12 +562,15 @@ __iomap_dio_rw(struct kiocb *iocb, struct iov_iter *iter,
 
 		       /*
 			* For datasync only writes, we optimistically try
-			* using FUA for this IO.  Any non-FUA write that
-			* occurs will clear this flag, hence we know before
-			* completion whether a cache flush is necessary.
+			* using STABLE_WRITE for this IO. Stable writes are
+			* either FUA with a write cache, or a normal write to
+			* a device without a volatile write cache. For the
+			* former, Any non-FUA write that occurs will clear this
+			* flag, hence we know before completion whether a cache
+			* flush is necessary.
 			*/
 			if (!(iocb->ki_flags & IOCB_SYNC))
-				dio->flags |= IOMAP_DIO_WRITE_FUA;
+				dio->flags |= IOMAP_DIO_STABLE_WRITE;
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
+	if (dio->flags & IOMAP_DIO_STABLE_WRITE)
 		dio->flags &= ~IOMAP_DIO_NEED_SYNC;
 
 	WRITE_ONCE(iocb->private, dio->submit.poll_bio);
-- 
2.40.1

