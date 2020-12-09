Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99D652D38C8
	for <lists+io-uring@lfdr.de>; Wed,  9 Dec 2020 03:26:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbgLICYG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 8 Dec 2020 21:24:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725789AbgLICYF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 8 Dec 2020 21:24:05 -0500
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49FA2C061793;
        Tue,  8 Dec 2020 18:23:25 -0800 (PST)
Received: by mail-wm1-x342.google.com with SMTP id x22so124017wmc.5;
        Tue, 08 Dec 2020 18:23:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=8nqDKih6zs0hYQyZVTLYe1C7LXeqUorCx1dYSoWDPdA=;
        b=dY0KUTZ5GpJFPtyv4XUE1XidgJi6UAxHsPmqZ2S1fkEB1MZEGrUE4mlvN6U1PBusmU
         QWpC/nsZe+pAABtgAxjYFa7p+L1y3ok1VqvO/ywORlAwm/JR9lqAPYxeEWeFv+Mq2FQ2
         MrlAB2LtJStGBI+EmFmHRWGqA6ccp7im6GGm6qq2Ceu6bH5F8LWEUqKRwaljuot5e5M6
         BBET6k+7gVu2Ijts63gVDyGMfjmX7zOwIWXc3hlCRvYwNijp5JUBxMlpixoLTc06YnKD
         wNeWz/rgfAOC3/dU2Zftza3BclNRpC3rjuVctWX8brDvkPhFUloHCYS3QmK8bhchgmT0
         5kpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=8nqDKih6zs0hYQyZVTLYe1C7LXeqUorCx1dYSoWDPdA=;
        b=hxAIUbfs07VZlTwXz30wIkdx/T5RVRdQ6JgHuj7rXNDTyPc8kK0zy3RmN+RTXbAq22
         nrdXfnfb5fiLk+XUSuSrQnT7n8fTYvxlUWibCFe5GLv4ZddvcSqo0QFmnGBV8M6CYi1D
         J1scN4BH/i8BXVp2c4Msf3T9CiSwyaar66IKAHxp1DsutZTmpv5cfO0SQgJ9B76eUsw9
         iImOq4CRRfPzkEEnMkP0N08elZ2xBnX/PBd/CkNTu16dfk277YGuHULNOnljjKghYkQv
         5hk0FoHWDuSaX4hs7n4itrCeBaaVqHKnjvYBK/4vhtJpUV7VkJrBq8C7cSkN5IXpbkaz
         4/MA==
X-Gm-Message-State: AOAM532sLWCAWFKilSD4V1KpL9ra3KRZM/5KUTNqAeoJ3+nTs7oAeoXN
        Ncz2M1PRNENOAQyePsFTk1+hTHoY8nRFzw==
X-Google-Smtp-Source: ABdhPJx4PlE+nQwap93mrg1QUhABGQKdyeuq32vY5vLrCdwCgzlONCP/1uYvKPYpVqOQj6fOXSosYw==
X-Received: by 2002:a05:600c:210e:: with SMTP id u14mr319194wml.48.1607480604048;
        Tue, 08 Dec 2020 18:23:24 -0800 (PST)
Received: from localhost.localdomain ([85.255.233.156])
        by smtp.gmail.com with ESMTPSA id k64sm330606wmb.11.2020.12.08.18.23.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 18:23:23 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Wilcox <willy@infradead.org>
Subject: [PATCH 2/2] block: no-copy bvec for direct IO
Date:   Wed,  9 Dec 2020 02:19:52 +0000
Message-Id: <51905c4fcb222e14a1d5cb676364c1b4f177f582.1607477897.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1607477897.git.asml.silence@gmail.com>
References: <cover.1607477897.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The block layer spends quite a while in blkdev_direct_IO() to copy and
initialise bio's bvec. However, if we've already got a bvec in the input
iterator it might be reused in some cases, i.e. when new
ITER_BVEC_FLAG_FIXED flag is set. Simple tests show considerable
performance boost, and it also reduces memory footprint.

Suggested-by: Matthew Wilcox <willy@infradead.org>
[BIO_WORKINGSET] Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/block_dev.c | 30 +++++++++++++++++++++++++++++-
 1 file changed, 29 insertions(+), 1 deletion(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index d699f3af1a09..aee5d2e4f324 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -349,6 +349,28 @@ static void blkdev_bio_end_io(struct bio *bio)
 	}
 }
 
+static int bio_iov_fixed_bvec_get_pages(struct bio *bio, struct iov_iter *iter)
+{
+	bio->bi_vcnt = iter->nr_segs;
+	bio->bi_max_vecs = iter->nr_segs;
+	bio->bi_io_vec = (struct bio_vec *)iter->bvec;
+	bio->bi_iter.bi_bvec_done = iter->iov_offset;
+	bio->bi_iter.bi_size = iter->count;
+
+	/*
+	 * In practice groups of pages tend to be accessed/reclaimed/refaulted
+	 * together. To not go over bvec for those who didn't set BIO_WORKINGSET
+	 * approximate it by looking at the first page and inducing it to the
+	 * whole bio
+	 */
+	if (unlikely(PageWorkingset(iter->bvec->bv_page)))
+		bio_set_flag(bio, BIO_WORKINGSET);
+	bio_set_flag(bio, BIO_NO_PAGE_REF);
+
+	iter->count = 0;
+	return 0;
+}
+
 static ssize_t
 __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter, int nr_vecs)
 {
@@ -368,6 +390,8 @@ __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter, int nr_vecs)
 	    (bdev_logical_block_size(bdev) - 1))
 		return -EINVAL;
 
+	if (iov_iter_bvec_fixed(iter))
+		nr_vecs = 0;
 	bio = bio_alloc_bioset(GFP_KERNEL, nr_vecs, &blkdev_dio_pool);
 
 	dio = container_of(bio, struct blkdev_dio, bio);
@@ -398,7 +422,11 @@ __blkdev_direct_IO(struct kiocb *iocb, struct iov_iter *iter, int nr_vecs)
 		bio->bi_end_io = blkdev_bio_end_io;
 		bio->bi_ioprio = iocb->ki_ioprio;
 
-		ret = bio_iov_iter_get_pages(bio, iter);
+		if (iov_iter_is_bvec(iter) && iov_iter_bvec_fixed(iter))
+			ret = bio_iov_fixed_bvec_get_pages(bio, iter);
+		else
+			ret = bio_iov_iter_get_pages(bio, iter);
+
 		if (unlikely(ret)) {
 			bio->bi_status = BLK_STS_IOERR;
 			bio_endio(bio);
-- 
2.24.0

