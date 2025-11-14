Return-Path: <io-uring+bounces-10631-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D6447C5C403
	for <lists+io-uring@lfdr.de>; Fri, 14 Nov 2025 10:26:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 53F2D3BD277
	for <lists+io-uring@lfdr.de>; Fri, 14 Nov 2025 09:23:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E664306B2D;
	Fri, 14 Nov 2025 09:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="BeoIgOlr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D17DE306B12
	for <io-uring@vger.kernel.org>; Fri, 14 Nov 2025 09:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763112143; cv=none; b=fPCK4UmRjklT2VMyYOqxSQKsXt0wXAPC22SFVy4IPdwPvvIQtGNUT18mFmtDFwsXbN+Ui1CpKyWGBJu1i992HFu59SLhWw4pvJRPe0CEq2LwCf0vMUydu6HhCRNvZd37/BLZ1/sd2wqe+QG3mCdgQodHWOb6+3YLmUEo3DMByCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763112143; c=relaxed/simple;
	bh=zey9QOsJwIZZBHiOsf2KAEaEBrib8095W2F0E7BXEVc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hk6rItJ2IiD9hHuqOooOwp+98KsM9AjH8QRirgNtZAA3alXTQLD+MjGHYUjFysu61URhhO8siu1VkpygGFEKOSX9dyPXbSW/rw6O0Ig9IqiG9rLOFv5AG+eRzTUzBxC1uiqM4/KUchEtUNfkA8tuxrdVI+YCVqW7Xj361rTauuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=BeoIgOlr; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2980d9b7df5so16577255ad.3
        for <io-uring@vger.kernel.org>; Fri, 14 Nov 2025 01:22:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1763112141; x=1763716941; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pVqJ5zZ0HtfmnlapRSluaL8hZ3jxVD5iRJrMHsVwK6A=;
        b=BeoIgOlrXgYeTNe/LIA4b6Sq/NH8PjOxtykOPjubumEf8QBVXFePbwm896YPx2XNpO
         6sy1kgtfdWGUadEa/mpP+QhsBPrnCSY240b/OTbTxoAMLaiJ3VUBILVwxmJYN/93kLEE
         buM/NglbCIEFjtzwVXLs5aWWVaHEhCPcYwwzOyXZTxfS1RQWYMDDCilqC1U9x63FRCgX
         XbEA6oMBBgTSwGPpCvfS7aepMATFERmjfsBFlKTMidUBhUKCOBIH/eJq4R+/UQiZ+/p5
         wOXXodikYyoA4NjJL61i64uBlnYJLgyy/IQ5pgW+pO+x3TlrU8iQlEZXo0iR2ED/Jjtg
         kSNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763112141; x=1763716941;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pVqJ5zZ0HtfmnlapRSluaL8hZ3jxVD5iRJrMHsVwK6A=;
        b=tOJ+hdsvSgTdnRDsRc+Pzs+oIR8qY2jcuY/QoOhFHdTI+4KIbtVkbLMlhyWG1I6ekI
         AI43HVO5NOA7JwdWp4TVxjzK30qreZIx3w07TzsA+jVgYhDoh9w+5kWaDa/gMTFxTORg
         L/Yor4B2Pq4aqXzQp1CtcRHdubqJpJ0G5+1HyzuS1fPL1898g5M+vyAhQCnFsLN9M0cn
         2wDQQdpASVQ4nQtdVFx/eS1cGUCyyVDRuByU7xEV88a5SWREY0WvKdmfXMotwxwr7BTE
         Oc4OuaO7vssEiW5F7E+2VJvqBEN3pn4MLhYpHUUKvw9jhMyFOy18bNtudHPo+Dprz0I5
         UhlA==
X-Forwarded-Encrypted: i=1; AJvYcCVMyZQwoK2H5zIjwR0HjVHfGjcF9V/ZG7nRM8SGR2O5eI/zlrd5Yr+c0f4yGg/qpw15MEdM0DdSew==@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3pBredijbmIwK1Xut9OZhyurty4PQTfHv9ngQ9LjuRtCA1LCw
	01/2qMpyu4DxJKt9YPNr2E99Dit3JjumsU0Hq2gkc/fDMYzW+pHxjDfAVToZY0xeF3s=
X-Gm-Gg: ASbGncuDQAZU+/82m31lkZB+MjdGJQNzZLEeQpTME1DGJBcgM0on0vCtL3LJ9lvb8ED
	qYEyZepM1NUOM5Ntdu57Iq5/buV2QIpRKU5leMGfUhx+XvSjdgjVvMceJklSfYjrha9S9QIw1UO
	Au++rDpg8E1wlXZgnJNeNugjFONzV1yJgdxFd3Tg7cDjP1CUuU+SgE5Bhv8aPLayR+JqpZs1tRN
	vNOpA/7ZB1hr5fp2OhG2q8hgZJm9gkFj9+jCJIwMU+sHSP1fGJc00UpXqGwzal5E8qHTllzAMT4
	wP7jKYhvYolaJmqGN0//viM1+wuhuj+6OP7OkTb/AnEPJvi50ALlFU834UZ/Si7UJ0Zq9v5ZL0I
	dL+EcotQpY7plycQdt6ofTnj8LI6XIA6stAzRkULeZLo7oxLy/6x7W/2YonsR9Zy+hE2O3PzqSS
	GKgiBP/7k57ghJfGkBQans5Z6a87qSTuJbIU5pR8cldxAQ
X-Google-Smtp-Source: AGHT+IG8akVzn6mgTzVS8eSbF8fdiM3Aj0sp4LOsT1smP8qpTtrhqG7ZlkpNWC+Kazn0Hs5a6+hQ3A==
X-Received: by 2002:a17:903:2c07:b0:293:e12:1bec with SMTP id d9443c01a7336-2986a6d57ebmr28935835ad.20.1763112141041;
        Fri, 14 Nov 2025 01:22:21 -0800 (PST)
Received: from localhost.localdomain ([203.208.167.151])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2985c2b0fe9sm48725735ad.65.2025.11.14.01.22.15
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 14 Nov 2025 01:22:20 -0800 (PST)
From: Fengnan Chang <changfengnan@bytedance.com>
To: axboe@kernel.dk,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	asml.silence@gmail.com,
	willy@infradead.org,
	djwong@kernel.org,
	hch@infradead.org,
	ritesh.list@gmail.com,
	linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-xfs@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-block@vger.kernel.org,
	ming.lei@redhat.com,
	linux-nvme@lists.infradead.org
Cc: Fengnan Chang <changfengnan@bytedance.com>
Subject: [PATCH v3 1/2] block: use bio_alloc_bioset for passthru IO by default
Date: Fri, 14 Nov 2025 17:21:48 +0800
Message-Id: <20251114092149.40116-2-changfengnan@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20251114092149.40116-1-changfengnan@bytedance.com>
References: <20251114092149.40116-1-changfengnan@bytedance.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use bio_alloc_bioset for passthru IO by default, so that we can enable
bio cache for irq and polled passthru IO in later.

Signed-off-by: Fengnan Chang <changfengnan@bytedance.com>
---
 block/blk-map.c           | 90 ++++++++++++++++-----------------------
 drivers/nvme/host/ioctl.c |  2 +-
 2 files changed, 37 insertions(+), 55 deletions(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index 60faf036fb6e..9e45cb142d85 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -37,6 +37,25 @@ static struct bio_map_data *bio_alloc_map_data(struct iov_iter *data,
 	return bmd;
 }
 
+static inline void blk_mq_map_bio_put(struct bio *bio)
+{
+	bio_put(bio);
+}
+
+static struct bio *blk_rq_map_bio_alloc(struct request *rq,
+		unsigned int nr_vecs, gfp_t gfp_mask)
+{
+	struct block_device *bdev = rq->q->disk ? rq->q->disk->part0 : NULL;
+	struct bio *bio;
+
+	bio = bio_alloc_bioset(bdev, nr_vecs, rq->cmd_flags, gfp_mask,
+				&fs_bio_set);
+	if (!bio)
+		return NULL;
+
+	return bio;
+}
+
 /**
  * bio_copy_from_iter - copy all pages from iov_iter to bio
  * @bio: The &struct bio which describes the I/O as destination
@@ -154,10 +173,9 @@ static int bio_copy_user_iov(struct request *rq, struct rq_map_data *map_data,
 	nr_pages = bio_max_segs(DIV_ROUND_UP(offset + len, PAGE_SIZE));
 
 	ret = -ENOMEM;
-	bio = bio_kmalloc(nr_pages, gfp_mask);
+	bio = blk_rq_map_bio_alloc(rq, nr_pages, gfp_mask);
 	if (!bio)
 		goto out_bmd;
-	bio_init_inline(bio, NULL, nr_pages, req_op(rq));
 
 	if (map_data) {
 		nr_pages = 1U << map_data->page_order;
@@ -233,43 +251,12 @@ static int bio_copy_user_iov(struct request *rq, struct rq_map_data *map_data,
 cleanup:
 	if (!map_data)
 		bio_free_pages(bio);
-	bio_uninit(bio);
-	kfree(bio);
+	blk_mq_map_bio_put(bio);
 out_bmd:
 	kfree(bmd);
 	return ret;
 }
 
-static void blk_mq_map_bio_put(struct bio *bio)
-{
-	if (bio->bi_opf & REQ_ALLOC_CACHE) {
-		bio_put(bio);
-	} else {
-		bio_uninit(bio);
-		kfree(bio);
-	}
-}
-
-static struct bio *blk_rq_map_bio_alloc(struct request *rq,
-		unsigned int nr_vecs, gfp_t gfp_mask)
-{
-	struct block_device *bdev = rq->q->disk ? rq->q->disk->part0 : NULL;
-	struct bio *bio;
-
-	if (rq->cmd_flags & REQ_ALLOC_CACHE && (nr_vecs <= BIO_INLINE_VECS)) {
-		bio = bio_alloc_bioset(bdev, nr_vecs, rq->cmd_flags, gfp_mask,
-					&fs_bio_set);
-		if (!bio)
-			return NULL;
-	} else {
-		bio = bio_kmalloc(nr_vecs, gfp_mask);
-		if (!bio)
-			return NULL;
-		bio_init_inline(bio, bdev, nr_vecs, req_op(rq));
-	}
-	return bio;
-}
-
 static int bio_map_user_iov(struct request *rq, struct iov_iter *iter,
 		gfp_t gfp_mask)
 {
@@ -318,25 +305,23 @@ static void bio_invalidate_vmalloc_pages(struct bio *bio)
 static void bio_map_kern_endio(struct bio *bio)
 {
 	bio_invalidate_vmalloc_pages(bio);
-	bio_uninit(bio);
-	kfree(bio);
+	blk_mq_map_bio_put(bio);
 }
 
-static struct bio *bio_map_kern(void *data, unsigned int len, enum req_op op,
+static struct bio *bio_map_kern(struct request *rq, void *data, unsigned int len,
 		gfp_t gfp_mask)
 {
 	unsigned int nr_vecs = bio_add_max_vecs(data, len);
 	struct bio *bio;
 
-	bio = bio_kmalloc(nr_vecs, gfp_mask);
+	bio = blk_rq_map_bio_alloc(rq, nr_vecs, gfp_mask);
 	if (!bio)
 		return ERR_PTR(-ENOMEM);
-	bio_init_inline(bio, NULL, nr_vecs, op);
+
 	if (is_vmalloc_addr(data)) {
 		bio->bi_private = data;
 		if (!bio_add_vmalloc(bio, data, len)) {
-			bio_uninit(bio);
-			kfree(bio);
+			blk_mq_map_bio_put(bio);
 			return ERR_PTR(-EINVAL);
 		}
 	} else {
@@ -349,8 +334,7 @@ static struct bio *bio_map_kern(void *data, unsigned int len, enum req_op op,
 static void bio_copy_kern_endio(struct bio *bio)
 {
 	bio_free_pages(bio);
-	bio_uninit(bio);
-	kfree(bio);
+	blk_mq_map_bio_put(bio);
 }
 
 static void bio_copy_kern_endio_read(struct bio *bio)
@@ -369,6 +353,7 @@ static void bio_copy_kern_endio_read(struct bio *bio)
 
 /**
  *	bio_copy_kern	-	copy kernel address into bio
+ *	@rq: request to fill
  *	@data: pointer to buffer to copy
  *	@len: length in bytes
  *	@op: bio/request operation
@@ -377,9 +362,10 @@ static void bio_copy_kern_endio_read(struct bio *bio)
  *	copy the kernel address into a bio suitable for io to a block
  *	device. Returns an error pointer in case of error.
  */
-static struct bio *bio_copy_kern(void *data, unsigned int len, enum req_op op,
+static struct bio *bio_copy_kern(struct request *rq, void *data, unsigned int len,
 		gfp_t gfp_mask)
 {
+	enum req_op op = req_op(rq);
 	unsigned long kaddr = (unsigned long)data;
 	unsigned long end = (kaddr + len + PAGE_SIZE - 1) >> PAGE_SHIFT;
 	unsigned long start = kaddr >> PAGE_SHIFT;
@@ -394,10 +380,9 @@ static struct bio *bio_copy_kern(void *data, unsigned int len, enum req_op op,
 		return ERR_PTR(-EINVAL);
 
 	nr_pages = end - start;
-	bio = bio_kmalloc(nr_pages, gfp_mask);
+	bio = blk_rq_map_bio_alloc(rq, nr_pages, gfp_mask);
 	if (!bio)
 		return ERR_PTR(-ENOMEM);
-	bio_init_inline(bio, NULL, nr_pages, op);
 
 	while (len) {
 		struct page *page;
@@ -431,8 +416,7 @@ static struct bio *bio_copy_kern(void *data, unsigned int len, enum req_op op,
 
 cleanup:
 	bio_free_pages(bio);
-	bio_uninit(bio);
-	kfree(bio);
+	blk_mq_map_bio_put(bio);
 	return ERR_PTR(-ENOMEM);
 }
 
@@ -676,18 +660,16 @@ int blk_rq_map_kern(struct request *rq, void *kbuf, unsigned int len,
 		return -EINVAL;
 
 	if (!blk_rq_aligned(rq->q, addr, len) || object_is_on_stack(kbuf))
-		bio = bio_copy_kern(kbuf, len, req_op(rq), gfp_mask);
+		bio = bio_copy_kern(rq, kbuf, len, gfp_mask);
 	else
-		bio = bio_map_kern(kbuf, len, req_op(rq), gfp_mask);
+		bio = bio_map_kern(rq, kbuf, len, gfp_mask);
 
 	if (IS_ERR(bio))
 		return PTR_ERR(bio);
 
 	ret = blk_rq_append_bio(rq, bio);
-	if (unlikely(ret)) {
-		bio_uninit(bio);
-		kfree(bio);
-	}
+	if (unlikely(ret))
+		blk_mq_map_bio_put(bio);
 	return ret;
 }
 EXPORT_SYMBOL(blk_rq_map_kern);
diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
index c212fa952c0f..9c0d7b1618ce 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -446,7 +446,7 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 	struct iov_iter iter;
 	struct iov_iter *map_iter = NULL;
 	struct request *req;
-	blk_opf_t rq_flags = REQ_ALLOC_CACHE;
+	blk_opf_t rq_flags = 0;
 	blk_mq_req_flags_t blk_flags = 0;
 	int ret;
 
-- 
2.39.5 (Apple Git-154)


