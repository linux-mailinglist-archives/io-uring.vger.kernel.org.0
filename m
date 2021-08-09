Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1839A3E4E5F
	for <lists+io-uring@lfdr.de>; Mon,  9 Aug 2021 23:24:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236420AbhHIVYf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Aug 2021 17:24:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236421AbhHIVYf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Aug 2021 17:24:35 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 742EBC061799
        for <io-uring@vger.kernel.org>; Mon,  9 Aug 2021 14:24:12 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id j1so30027250pjv.3
        for <io-uring@vger.kernel.org>; Mon, 09 Aug 2021 14:24:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=dyOLwIAyn5igot9fdJEMYSDMYL7Dq8yEvViQYaBuv5Q=;
        b=IgN38Ju83GTulvCvZYlk1tCmOLuq05ZnrXLyiM9cJpOx72VXo8vLggCiEjPzdjwgyD
         mMK7Lct7hKsJ/9DeBUZkREk9FHfFpCUr77ggNxRruqvvZ4qbGG6Bt5NbSI/8AvjN+lsD
         7DlNNRZMiSIZboSKJdB46Lk6VuIvJ8D/yY1x6ajWlTDv1lyKY0e52sAZDh9GjmZn5d9X
         S2zhHWdkcPKHSIdk8OT/QtCUFD4xvU3VyyZhgnonWJv2jzZEX6KXZYTft+GnfFxn4mCi
         2hIadd1fFXCXYRljE3GILzNYvjMtdV6g6PhSoJG9kDpUkJFogd08mLnucB5oubB0dmNE
         nG+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=dyOLwIAyn5igot9fdJEMYSDMYL7Dq8yEvViQYaBuv5Q=;
        b=PQFjywCfJUjWAZJbhII4mlV8r9hbYmdHNc8wh89BcaUbxP9j8btTbIgEQOL0CQP9jZ
         4dhOc4aPzPPm2LWacm5jaR8ZC1os8Qc0O5rnuXu6ZoTBshNa62seP72giXm5dK3N+CBV
         9BtcjIG7K5wxb0ruz0TyE/PFwLRv2Kc4hwqeJg4sDjaAe10rsKdTn9HasguSHFC0M4eC
         YkKXI2++4xG7+Z0HQ4XEthJEuMSj6+YQhEYhfcggELVs3D3m5TBmPoBZyG+9+2ZKwxZ3
         gbUgoAORdNSNj4QfLbu3NT9uLJZXZ5eIzVRkFTzIlmu2ugQdPHdsHCCw7YMkfhENd14V
         zxoQ==
X-Gm-Message-State: AOAM530kt2WGUZLsLVbsFX7W1/0gUPrSEh9zmE7yXjGEFv065/r5DHGp
        xYJEP8+hUgXogpsdCzuBVpsuoL4XEf5GcMBo
X-Google-Smtp-Source: ABdhPJwsQKrvh7BBLMHgl6EZA+imD4LOvABq2HSlJV/q66inXi4kN9VHm6P7KHtJsfNePIQmLfyH3A==
X-Received: by 2002:a17:90a:6541:: with SMTP id f1mr1114982pjs.184.1628544251710;
        Mon, 09 Aug 2021 14:24:11 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id m16sm439885pjz.30.2021.08.09.14.24.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 14:24:11 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/4] block: enable use of bio allocation cache
Date:   Mon,  9 Aug 2021 15:24:01 -0600
Message-Id: <20210809212401.19807-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210809212401.19807-1-axboe@kernel.dk>
References: <20210809212401.19807-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If a kiocb is marked as being valid for bio caching, then use that to
allocate a (and free) new bio if possible.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/block_dev.c | 30 ++++++++++++++++++++++++++----
 1 file changed, 26 insertions(+), 4 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 9ef4f1fc2cb0..36a3d53326c0 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -327,6 +327,14 @@ static int blkdev_iopoll(struct kiocb *kiocb, bool wait)
 	return blk_poll(q, READ_ONCE(kiocb->ki_cookie), wait);
 }
 
+static void dio_bio_put(struct blkdev_dio *dio)
+{
+	if (!dio->is_sync && (dio->iocb->ki_flags & IOCB_ALLOC_CACHE))
+		bio_cache_put(&dio->bio);
+	else
+		bio_put(&dio->bio);
+}
+
 static void blkdev_bio_end_io(struct bio *bio)
 {
 	struct blkdev_dio *dio = bio->bi_private;
@@ -362,7 +370,7 @@ static void blkdev_bio_end_io(struct bio *bio)
 		bio_check_pages_dirty(bio);
 	} else {
 		bio_release_pages(bio, false);
-		bio_put(bio);
+		dio_bio_put(dio);
 	}
 }
 
@@ -385,7 +393,14 @@ static ssize_t __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 	    (bdev_logical_block_size(bdev) - 1))
 		return -EINVAL;
 
-	bio = bio_alloc_bioset(GFP_KERNEL, nr_pages, &blkdev_dio_pool);
+	bio = NULL;
+	if (iocb->ki_flags & IOCB_ALLOC_CACHE) {
+		bio = bio_cache_get(GFP_KERNEL, nr_pages, &blkdev_dio_pool);
+		if (!bio)
+			iocb->ki_flags &= ~IOCB_ALLOC_CACHE;
+	}
+	if (!bio)
+		bio = bio_alloc_bioset(GFP_KERNEL, nr_pages, &blkdev_dio_pool);
 
 	dio = container_of(bio, struct blkdev_dio, bio);
 	dio->is_sync = is_sync = is_sync_kiocb(iocb);
@@ -467,7 +482,14 @@ static ssize_t __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 		}
 
 		submit_bio(bio);
-		bio = bio_alloc(GFP_KERNEL, nr_pages);
+		bio = NULL;
+		if (iocb->ki_flags & IOCB_ALLOC_CACHE) {
+			bio = bio_cache_get(GFP_KERNEL, nr_pages, &fs_bio_set);
+			if (!bio)
+				iocb->ki_flags &= ~IOCB_ALLOC_CACHE;
+		}
+		if (!bio)
+			bio = bio_alloc(GFP_KERNEL, nr_pages);
 	}
 
 	if (!is_poll)
@@ -492,7 +514,7 @@ static ssize_t __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter,
 	if (likely(!ret))
 		ret = dio->size;
 
-	bio_put(&dio->bio);
+	dio_bio_put(dio);
 	return ret;
 }
 
-- 
2.32.0

