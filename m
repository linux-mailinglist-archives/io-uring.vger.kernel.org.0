Return-Path: <io-uring+bounces-3146-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B00CE97588E
	for <lists+io-uring@lfdr.de>; Wed, 11 Sep 2024 18:34:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D43FD1C22EFD
	for <lists+io-uring@lfdr.de>; Wed, 11 Sep 2024 16:34:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E34A1B29BA;
	Wed, 11 Sep 2024 16:34:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TJyR4zEj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CCBB1A3AB8;
	Wed, 11 Sep 2024 16:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726072474; cv=none; b=sxdgVoYN5mZ4dqv9k+DADIlNrhdkAxjm0m3WB2CXksTMrUXQ+6jDgxbjMghUH+Qg1+VAuA6XjO/bkA5AMayk0tLbSCDbNxbmmcelQUk1uNsQQAgdbazHHxINxJL5hj0gHLI7x97r7/cVVm2cpGbB/IBvRMOU+vLugn61LJRNb4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726072474; c=relaxed/simple;
	bh=sSEr2oV7JZ8OWOfM36VBUS5CdQbzuCCnTxq3sxwf8Kw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O3IIr8WEqfuvRs5Wr8EdB4Td2Pa+HbBLIT5NQYSf/zWfIr22vJfygTQ9gv4/NmZqarqdu2HlVvdoWSiua4ChdYPXdyNT8viBqQwzuR0dM0XiEnpCk9YSb3pd3b2pMKRcpAyyjqaQA8kx1xBeZv43HjrHwMsUbIRu7LeqeRseyz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TJyR4zEj; arc=none smtp.client-ip=209.85.208.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-5c26815e174so7509492a12.0;
        Wed, 11 Sep 2024 09:34:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1726072469; x=1726677269; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jv/xRgK93eDswhXa+H3bNlv587Pzbd+1FrWwfpAcjww=;
        b=TJyR4zEjQWywhOCIuO/HN7pRet4zeDHUI8BfrFcd/84vJ/84EGkeOtF5pZIk9QsbsR
         rftggtp3rsrba4fm7q45HqjA6F+rdaYwbA13BVTMxXWiBJmkvpLUim+qcA9jJFf8s3b/
         8JFGE9iIJweKIoN4DSA/B0tqyVxQEo/5cEy456cKYPP7krCRUT+XhVXeoPyCv084A23Y
         NDvE04c0SdvVkHNAjfBJ2rzMIq2A3YezheiFIy1q6+NaW6zjSFONHA+LtqDqGVATte/o
         sVaJgJ2sXt42WocF+zsLM1HomFmApVhA7z1OFQr+5BItv9WGl8FnbYsFa9d9NLlNirY2
         tFog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726072469; x=1726677269;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Jv/xRgK93eDswhXa+H3bNlv587Pzbd+1FrWwfpAcjww=;
        b=owNOCgPNUOsoiiyVvezI2LG7fOGlDt9mxLeiZyx2ljg0KUe9trUEI/wy3L0G7ja7bh
         hiFZgqytugjsIPmAGg+9chxVxWdkBtg310XnrOEPGOcjinqQBmHzTzL9HQkecANCuT1U
         qyT82sa6o0K39XaI/sltJkrwcRKPoSoLKoNEOkFpWAjSFBO7RLrFdayptXJg+r5BI58S
         tnFawOArR8QeZ7LpnnEJ+RwuU94+1iXwY1r3xBsAeI4HY1SqUCyt1r+dpFsIStqYlWdD
         PUVaW4WqcR1q41Oav34nwvUrB5sx51QFPzLhyxUcSBrf5ucbJa2wLmBWdOyOAFrxu6JV
         ntKg==
X-Forwarded-Encrypted: i=1; AJvYcCXni89A6+lhFg1pxMcm6rZ74id2ET/aafyOJ2xduzocq1wZVGjPUjlC0KIOC1+pHh119a5aWVyDXdlzIQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzyKVu37reQiaxNM+BNGnHENgEpRT24kFXPtf41zEx8g0jfGugv
	8LkXUQsK/7M1UnVnGt0UprdqHrSNHrWmU9B2aPbDCj7/HMlaczKYATjerO0K
X-Google-Smtp-Source: AGHT+IGuiTLA2mNX0YCzkTRNyEFx9mbWso8US7cNHDcH1lN98BWCM89d0c663QhibBxvnr/nZH5TzQ==
X-Received: by 2002:a17:907:f186:b0:a86:f960:411d with SMTP id a640c23a62f3a-a9029409aedmr9838766b.2.1726072469422;
        Wed, 11 Sep 2024 09:34:29 -0700 (PDT)
Received: from 127.0.0.1localhost ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8d25c72ed3sm631820866b.135.2024.09.11.09.34.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Sep 2024 09:34:28 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v5 7/8] block: add nowait flag for __blkdev_issue_zero_pages
Date: Wed, 11 Sep 2024 17:34:43 +0100
Message-ID: <0a4e17bf70d5fa035329664b25a780bf4f53e38f.1726072086.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1726072086.git.asml.silence@gmail.com>
References: <cover.1726072086.git.asml.silence@gmail.com>
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
index 83eb7761c2bf..40bb59f583ee 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -192,20 +192,32 @@ static unsigned int __blkdev_sectors_to_bio_pages(sector_t nr_sects)
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
@@ -222,6 +234,8 @@ static void __blkdev_issue_zero_pages(struct block_device *bdev,
 		*biop = bio_chain_and_submit(*biop, bio);
 		cond_resched();
 	}
+
+	return 0;
 }
 
 static int blkdev_issue_zero_pages(struct block_device *bdev, sector_t sector,
@@ -235,7 +249,7 @@ static int blkdev_issue_zero_pages(struct block_device *bdev, sector_t sector,
 		return -EOPNOTSUPP;
 
 	blk_start_plug(&plug);
-	__blkdev_issue_zero_pages(bdev, sector, nr_sects, gfp, &bio, flags);
+	blkdev_issue_zero_pages_bio(bdev, sector, nr_sects, gfp, &bio, flags);
 	if (bio) {
 		if ((flags & BLKDEV_ZERO_KILLABLE) &&
 		    fatal_signal_pending(current)) {
@@ -285,7 +299,7 @@ int __blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 	} else {
 		if (flags & BLKDEV_ZERO_NOFALLBACK)
 			return -EOPNOTSUPP;
-		__blkdev_issue_zero_pages(bdev, sector, nr_sects, gfp_mask,
+		blkdev_issue_zero_pages_bio(bdev, sector, nr_sects, gfp_mask,
 				biop, flags);
 	}
 	return 0;
diff --git a/include/linux/bio.h b/include/linux/bio.h
index faceadb040f9..e4e495a4a95b 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -684,4 +684,8 @@ struct bio *bio_chain_and_submit(struct bio *prev, struct bio *new);
 struct bio *blk_alloc_discard_bio(struct block_device *bdev,
 		sector_t *sector, sector_t *nr_sects, gfp_t gfp_mask);
 
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


