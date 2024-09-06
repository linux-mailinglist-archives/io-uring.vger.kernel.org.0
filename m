Return-Path: <io-uring+bounces-3081-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D69D896FE3B
	for <lists+io-uring@lfdr.de>; Sat,  7 Sep 2024 00:57:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3CECE28780F
	for <lists+io-uring@lfdr.de>; Fri,  6 Sep 2024 22:57:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02E8715ADB1;
	Fri,  6 Sep 2024 22:57:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iPLODqSO"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 49D6715B54E;
	Fri,  6 Sep 2024 22:57:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725663430; cv=none; b=uw1UmvuuvtMQ2uxC/zDAmEgNTMjc6EN9bPO7z/PlNfI5j+ny6xOuxwUM5FrJAejVTyQoX1Sh5yQB11bluEvH+gqvnqf3xFxZXxbtjhPYx8cmUZoZin9CN7aGkF/ehHXitI7BgPnJM8B9aEBWMWY7pMIHEP1M4f/ciq0sIN6w/I8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725663430; c=relaxed/simple;
	bh=78UR0qruQh9KW0yalCw2O7xPrgksBC9fYQyOrc8Aubg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DKJ6lVg/12mdT0tWwRobTL2G39PEkOqqY4TISP+zq8ZYGjdfMMAguSgQCTL+sdjCS6JgMnq233D/v7ZPwZI8zRuJ6WeL2gfC+FXhKGQ8Jq70BgFqtuWpXSbGb+9ARdse/BbEvDjyrmRhNZII/kRzK2/NwiUSndaRPk9TKwXyrWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iPLODqSO; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a8ce5db8668so112530966b.1;
        Fri, 06 Sep 2024 15:57:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1725663427; x=1726268227; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jYezJHCo7v489eblMcj1bTcVFXeBrX/vk5R7qG2A1Yk=;
        b=iPLODqSO95xJ8LezNfwQmV0CBQjTWMC86BPKjs76QLXZIIhUlOr7UH4WWiF6Q53Cr/
         PwOznYDnmR5AIWkmxQiKn2PUcuipWdN91jI7l1+MeQrw5hxD7b6lfNTKjdOwUOG3AALo
         +7rO15Kpb5WXztBDykinIl8O2asGikK13uuqsewntJR0C7u+h2SjuEgD5piQsdfqmajQ
         coq1RjK/t3KaVS/V/4xpV45qur14rFcVadJxVkoA8hjuhwG/I4+YRrColMMWkvl2+TJT
         jwIf6PUU2CuYyQXQfGl7ic9Yq0835Kz0GbYi8VocRmteC6UtHD3ou4szjHrpAYsQd9Uo
         Zm0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725663427; x=1726268227;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jYezJHCo7v489eblMcj1bTcVFXeBrX/vk5R7qG2A1Yk=;
        b=bjUZWjbV4U8vWPfG0ALFKqm1hM4BWZDM+81zSPND2t5NpR5KFowTlezjZj3cteTaNU
         INX3peqC8LuE/848Tx+3CGod7CiS5htBMHktX/m2WFgf9HPn38pwK8urJb2GYT4mxycq
         5+C2unDkCwdkSlPhfTwYBvjJidehPSy7QUoJmrPjTutHgFiOCkNnrYtxu+p0wu5oSPxH
         5EyCmhM1mPAhRGVBsOKTfkBB/M45ZwsOHdx+DZENbJmoAvL06Skggsp0ApYsf6fzu6nM
         ucS0qUxx9D4UR3hF477DiGqfWN9M4Ri6YBqEJxs+XenSaoNDOmMc0/F2/SwXe6LOvIBT
         0xYg==
X-Forwarded-Encrypted: i=1; AJvYcCXSpxRuTMjW551MfX4H6VPwIZR1v+6MdL9Y1PJKMbrF5yqdwoVS9ibu+g5Bz014F6egQogr+todyhS7cw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyuMF069s1Thhzd8xUASER/wKld77CJ0vfbCdB6/rYuMR4jgXCA
	OQ/i9hvKW7dXzFx31uys8LATt22h/w64+L8kAHgdTHJYBGI7/I0j++LEmfWh
X-Google-Smtp-Source: AGHT+IE/3M7b/K3pyseCsX+NiZT9J56A5VyhoP1o7o5GWtiHew5dHLC0T6ZxFj2yq0dOHss7K5NZbA==
X-Received: by 2002:a17:907:3f20:b0:a8d:caa:7fee with SMTP id a640c23a62f3a-a8d1bf75ec5mr67443566b.7.1725663427142;
        Fri, 06 Sep 2024 15:57:07 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.146.236])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a8d25d54978sm2679566b.199.2024.09.06.15.57.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Sep 2024 15:57:06 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	asml.silence@gmail.com,
	Conrad Meyer <conradmeyer@meta.com>,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	Christoph Hellwig <hch@infradead.org>
Subject: [PATCH v4 7/8] block: add nowait flag for __blkdev_issue_zero_pages
Date: Fri,  6 Sep 2024 23:57:24 +0100
Message-ID: <387caa9b7a23061f19034a8afd1dfcf017d8fe35.1725621577.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1725621577.git.asml.silence@gmail.com>
References: <cover.1725621577.git.asml.silence@gmail.com>
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
 block/blk-lib.c        | 24 +++++++++++++++++++-----
 include/linux/bio.h    |  4 ++++
 include/linux/blkdev.h |  1 +
 3 files changed, 24 insertions(+), 5 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index c94c67a75f7e..0d8f1b93b4c3 100644
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
 
-		bio = bio_alloc(bdev, nr_vecs, REQ_OP_WRITE, gfp_mask);
+		bio = bio_alloc(bdev, nr_vecs, opf, gfp_mask);
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


