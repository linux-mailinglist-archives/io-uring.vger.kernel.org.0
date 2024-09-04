Return-Path: <io-uring+bounces-3025-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CF39196C00D
	for <lists+io-uring@lfdr.de>; Wed,  4 Sep 2024 16:21:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 790CF28BD38
	for <lists+io-uring@lfdr.de>; Wed,  4 Sep 2024 14:21:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 57BBD1E0B9D;
	Wed,  4 Sep 2024 14:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="et1Hv0Om"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7581E1301;
	Wed,  4 Sep 2024 14:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725459476; cv=none; b=aWAeUljmX2gBJPsZAK2Xe2qiE2dgYN46FfSxFgr60hjYJW/MlAKlfEGv8NTc/WCA1/EZgyE/KWaRCaC1tKGEwaEfiKYDCUKwX6JUVzkSiDIOQOpsyKaARUwvOOwgYXerHJcV5wCOGRRypnwNwM2vqQXgrShJnF9Xfd9Srv8JES8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725459476; c=relaxed/simple;
	bh=qT92kXhOb3ng0463r8HD9asnYhrFkLRqieKmlMdj6v0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kXroC8vDFTzJx7cAVUn7PuzU+8jDNoikXq7tRcGhk3q38ZeT227I9JOQ+MqcmhSYePFVyhVlUxHJ0geMREXt3S1eBsJzwfpaygEyQ8Yu6Vof44nCJnz+cljWBawMols1omfmzUr+bi4IoeKlxPV8Eid4z6xTyZqSuIn/7RbUFtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=et1Hv0Om; arc=none smtp.client-ip=209.85.167.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5334a8a1af7so7096188e87.2;
        Wed, 04 Sep 2024 07:17:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725459472; x=1726064272; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/3weTv0JDO1olCzxF1klLqGqviZ0xpQPSzNHS+GA/qM=;
        b=et1Hv0OmkszoSyVGQsE0+ggVtHkGET0uFWXqCcboj7WSFJFg3D6ah5/FbWEV5uRJr+
         B33hXqmVGgrYBegDxNFkSOK8T9dZ9qBc+G+kApdQCFMW6dOeps7JaaiDeZRJLHRe/tuv
         h7YzrnncgaTevmAVBQfrv8JQrdnQLu/+6Tr9aRe0kBFXNFiaOac8oTQTbFG4qK0DrH33
         RcluuhyVkiGwSTM8imbwJRW1EpeDNlO2460UHvGcwVMkq44bqPBkGa16fQBo1HIH0FCc
         p9d73u4DcomYzx5fb+XGQk+rl7MFvWkKBclVYzMYwWfefYWvxzFcq6Gjn3ItYOkbXuc2
         CDhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725459472; x=1726064272;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/3weTv0JDO1olCzxF1klLqGqviZ0xpQPSzNHS+GA/qM=;
        b=VorrE3y/fZzwB5vsDYT4su0ccatU6BfyaDaUkNHE6RLEM7htHDKDsBA64AlHjJYjBE
         LO+3tm7RbSDuRJeFhoy0zsl3RSNnOxVLWivABGYszX+7q601h/GOoU2FFiBLPhNgW8ck
         6D6SIXzkhIEiAj/dWcMA5JnhnDbSBzo9w8Hn7sUPaNShyrtBw5qcSZQ0Pu2edL77X7bB
         Fsurl+amFoMhRuWE6l9W8//lkY3XQ5xHoliCMWtgl806aOh9M5oH0ziNd7Cuvh20BSaJ
         k7rkkboSWJY9wt7uEBFRUjS1aM398Vm6w2/wScxmpw36to1hUqx468JtglHQqzDVBdry
         Fr5A==
X-Forwarded-Encrypted: i=1; AJvYcCUYC6+lD+wQsg6eb+LanqXJywr/mrVO7hbuOkxxxxKeJ6l5OZWfC2QwcOyLC0lqHMwPCR2ayBG4MTIgQw==@vger.kernel.org
X-Gm-Message-State: AOJu0YzCifgLpVorAxCqg5lIwVLoxuhy8Ks+5gc3QtBfXHApljkEO5Jo
	/4vJq2gYhV4EIssKFDGs6cop82oL9hb4burLjb9G3U//PI+q/nZnOEL7OQ==
X-Google-Smtp-Source: AGHT+IHXEXHSZq9e6Nc/W/109+8Kx4Ik97uxMWG+wzLcTtKwZnA/1xjIlHHukneB6BfUKC9IqvzHsA==
X-Received: by 2002:ac2:4c4f:0:b0:533:42ae:c985 with SMTP id 2adb3069b0e04-53546b2df7emr12335403e87.25.1725459472360;
        Wed, 04 Sep 2024 07:17:52 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8989196c88sm811160766b.102.2024.09.04.07.17.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2024 07:17:51 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Conrad Meyer <conradmeyer@meta.com>,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v3 7/8] block: add nowait flag for __blkdev_issue_zero_pages
Date: Wed,  4 Sep 2024 15:18:06 +0100
Message-ID: <292fa1c611adb064efe16ab741aad65c2128ada8.1725459175.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1725459175.git.asml.silence@gmail.com>
References: <cover.1725459175.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

To reuse __blkdev_issue_zero_pages() in the following patch, we need to
make it work with non-blocking requests. Add a new nowait flag we can
pass inside. Return errors if something went wrong, and check
bio_alloc() for failures, which wasn't supposed to happen before because
of what gfp flags the callers are passing. Note that there might be a
bio passed back even when the function returned an error. To limit the
scope of the patch, don't add return code handling to callers, that can
be deferred to a follow up.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 block/blk-lib.c        | 22 ++++++++++++++++++----
 include/linux/bio.h    |  4 ++++
 include/linux/blkdev.h |  1 +
 3 files changed, 23 insertions(+), 4 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index c94c67a75f7e..a16b7c7965e8 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -193,20 +193,32 @@ static unsigned int __blkdev_sectors_to_bio_pages(sector_t nr_sects)
 	return min(pages, (sector_t)BIO_MAX_VECS);
 }
 
-static void __blkdev_issue_zero_pages(struct block_device *bdev,
+int blkdev_issue_zero_pages_bio(struct block_device *bdev,
 		sector_t sector, sector_t nr_sects, gfp_t gfp_mask,
 		struct bio **biop, unsigned int flags)
 {
+	blk_opf_t opf = REQ_OP_WRITE;
+
+	if (flags & BLKDEV_ZERO_PAGES_NOWAIT) {
+		sector_t max_bio_sectors = BIO_MAX_VECS << PAGE_SECTORS_SHIFT;
+
+		if (nr_sects > max_bio_sectors)
+			return -EAGAIN;
+		opf |= REQ_NOWAIT;
+	}
+
 	while (nr_sects) {
 		unsigned int nr_vecs = __blkdev_sectors_to_bio_pages(nr_sects);
 		struct bio *bio;
 
 		bio = bio_alloc(bdev, nr_vecs, REQ_OP_WRITE, gfp_mask);
+		if (!bio)
+			return -ENOMEM;
 		bio->bi_iter.bi_sector = sector;
 
 		if ((flags & BLKDEV_ZERO_KILLABLE) &&
 		    fatal_signal_pending(current))
-			break;
+			return -EINTR;
 
 		do {
 			unsigned int len, added;
@@ -223,6 +235,8 @@ static void __blkdev_issue_zero_pages(struct block_device *bdev,
 		*biop = bio_chain_and_submit(*biop, bio);
 		cond_resched();
 	}
+
+	return 0;
 }
 
 static int blkdev_issue_zero_pages(struct block_device *bdev, sector_t sector,
@@ -236,7 +250,7 @@ static int blkdev_issue_zero_pages(struct block_device *bdev, sector_t sector,
 		return -EOPNOTSUPP;
 
 	blk_start_plug(&plug);
-	__blkdev_issue_zero_pages(bdev, sector, nr_sects, gfp, &bio, flags);
+	blkdev_issue_zero_pages_bio(bdev, sector, nr_sects, gfp, &bio, flags);
 	if (bio) {
 		if ((flags & BLKDEV_ZERO_KILLABLE) &&
 		    fatal_signal_pending(current)) {
@@ -286,7 +300,7 @@ int __blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 	} else {
 		if (flags & BLKDEV_ZERO_NOFALLBACK)
 			return -EOPNOTSUPP;
-		__blkdev_issue_zero_pages(bdev, sector, nr_sects, gfp_mask,
+		blkdev_issue_zero_pages_bio(bdev, sector, nr_sects, gfp_mask,
 				biop, flags);
 	}
 	return 0;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 78ead424484c..87d85b326e1e 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -686,4 +686,8 @@ struct bio *blk_alloc_discard_bio(struct block_device *bdev,
 
 sector_t bio_discard_limit(struct block_device *bdev, sector_t sector);
 
+int blkdev_issue_zero_pages_bio(struct block_device *bdev,
+		sector_t sector, sector_t nr_sects, gfp_t gfp_mask,
+		struct bio **biop, unsigned int flags);
+
 #endif /* __LINUX_BIO_H */
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 643c9020a35a..bf1aa951fda2 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1098,6 +1098,7 @@ int blkdev_issue_secure_erase(struct block_device *bdev, sector_t sector,
 #define BLKDEV_ZERO_NOUNMAP	(1 << 0)  /* do not free blocks */
 #define BLKDEV_ZERO_NOFALLBACK	(1 << 1)  /* don't write explicit zeroes */
 #define BLKDEV_ZERO_KILLABLE	(1 << 2)  /* interruptible by fatal signals */
+#define BLKDEV_ZERO_PAGES_NOWAIT (1 << 3) /* non-blocking submission  */
 
 extern int __blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask, struct bio **biop,
-- 
2.45.2


