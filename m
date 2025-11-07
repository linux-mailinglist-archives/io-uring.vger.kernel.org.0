Return-Path: <io-uring+bounces-10436-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A1AFC3E344
	for <lists+io-uring@lfdr.de>; Fri, 07 Nov 2025 03:07:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 41AA11889AC6
	for <lists+io-uring@lfdr.de>; Fri,  7 Nov 2025 02:07:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49E332D9ED9;
	Fri,  7 Nov 2025 02:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b="ZK+dqPBD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC6CB219A86
	for <io-uring@vger.kernel.org>; Fri,  7 Nov 2025 02:07:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762481237; cv=none; b=n0mY+EHisEjV3eK3Qy3L4vF20heRoC6BR9MDm/LdS0kW3iyZjcNVrS3NvC6LR3ccFN+EYTHNa1PapVh/Y4j+2RKiP27YcDgk3xJAdab4wAC027YWgBf69rnwkYXrNznBHsofKEDZO5yI0oCefT4o4hvGaAi/EpE9ob5UloCBWzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762481237; c=relaxed/simple;
	bh=lli0u4TsngLndxWtzp+3OjhbYuTLmWB5AKNTXIDei0c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=F+od/qdiNlaHBL9pmc2Bt4DfPeopeCJN022QMCprpkzlvG7LTTtfHQ4N0KrDoQetfT2qFUcrjauOzpXc+ewT32qICEhkxeoOWnyMQTCvLvjW2+u/cfbx80tprs0J6MWiHpqn4Z8XGzYCpR4iSqvMGKIBf7wSw9FVdZLDfmLABDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com; spf=pass smtp.mailfrom=bytedance.com; dkim=pass (2048-bit key) header.d=bytedance.com header.i=@bytedance.com header.b=ZK+dqPBD; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=bytedance.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bytedance.com
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-28a5b8b12a1so2122075ad.0
        for <io-uring@vger.kernel.org>; Thu, 06 Nov 2025 18:07:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1762481234; x=1763086034; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XOUCCDcR32WTLhwAJaOBtVC8wRTuafJBLOF7ysVPF/4=;
        b=ZK+dqPBDsOX76jp54dJVBVYt5whg6DQHhTju4LBQFrHFooAsi/5qpswY9NzUl3IIKg
         ORS23IsPYDfPoMC7wDtIBkJS2XCawXjd/rZDKBgTWRC8G/cII+mLw0p7ylEE4tmqFiUT
         KrwaN6/hJdr3CDMdjUhFm3ZOsK392ccAT8B/h7v3BNL1wtNd2gQQ9l5Q1aLisQBNBMHG
         qpikA3+ANgyNr287xBjO5oxPeWDat++Nu59Y6VrIqdoR1P6au2prEFiDxfP12Gqm0hyw
         2q/Y7nPm2u3DuuYWLtdiTOXdUykrMqaxzNm+nOBp5j51T+4HWwedUUu+bngkGJVm79YS
         4QNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762481234; x=1763086034;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XOUCCDcR32WTLhwAJaOBtVC8wRTuafJBLOF7ysVPF/4=;
        b=kKv7e9rUDWaFXelD9Vceu/jtJpNLuv2QkiMJUhta/1VcPcNx0mZ68u9MrrT1n9Tkew
         zor4FEVsQhMhS3eY+Glq11wBykN44YqON/AG8guTyyaFjCqx7b8XPqd/KwdIIvsb96jC
         HUS7tsQ/TvGUZ4GD3sJXj5qK8o7191vwTarUBsOTUhEu5EWGw3zQ5ts0zBRoltHC6OuY
         ez6oH7N1I3gERP4FuNjGboftyLM/r2JrB/KGPCsZe79Ij2YiANtkFt4WZl4BUydNQ93x
         +C7v2HQrBCq96FWzcwqeoSVBOBuQtWrl/pqgfH+tp7OSSQXQt2fx0dTFuGy/T6I21UD7
         lrkg==
X-Forwarded-Encrypted: i=1; AJvYcCXOyStGn202EPSCoUV8NweL1zTob0Py+SbyebvhsiInZFQPJUMZfbSUPtnC31tSM0lSHdv6DEawPg==@vger.kernel.org
X-Gm-Message-State: AOJu0YxrlXB05wc9ATC8xqEaFBPXwvvwKFvhHS76dLfWAasOYDlP0NsA
	14aWaW/J4xXHrBJK7kZ0iD1esDseSQ3AZIAO54llNQKh77oHMIm297GvJhSNp30FuBo=
X-Gm-Gg: ASbGnctcxhC0nAVTzBt4hfJHy/F+7nGksBrN9yswfyOYpY0frNrRlEA6Wa/Xs4kicAJ
	kyBpitMMaLeNZjSeulp5MQNU3GTcKPX1XYAdgv1QdqU2v6/mo3kSvLL8xL63GvorA0c+VMGFVGE
	vEEWa1nZwwbyDIaDMEm4wdoURZdWovl2GVW8BetcwzslKAThjOKj07ZwWzmUn42cIJaEGr66NqU
	J4S7Xsm1MVoEfmd+jhJLj0MyM4Q3Ii+JRy1ZPLEj8SdVy0zvZBcV7MFSGFsGWWfT6Z/rguVPhol
	qAvttV76SVilFDjvzTvn0s27sirEs/Dta6i5mEXwa2iPP53wRuf7f40XxqbmxfeiZIovMQd5IHM
	mm7mJe6TQl/CrnmoHyM1jjDJJGgnCaCHrEDn8J8och1ueKb+JqzuqlnnGoVOQd94T84A1PeCStK
	LVDf4H3OqZ2EclpCmd
X-Google-Smtp-Source: AGHT+IEJti4NiV6U2nPuxp72+m4/jnwAUg2/UAR4b5PLKU43+gH5PrMm/tm0Xa1G5TmaQR5rlzUdcA==
X-Received: by 2002:a17:903:2ac3:b0:290:94ed:184c with SMTP id d9443c01a7336-297c03d5580mr23239875ad.15.1762481234112;
        Thu, 06 Nov 2025 18:07:14 -0800 (PST)
Received: from localhost.localdomain ([2408:8740:c4ff:1::4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2965096825esm43129885ad.3.2025.11.06.18.07.03
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Thu, 06 Nov 2025 18:07:13 -0800 (PST)
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
Subject: [PATCH v2 1/2] block: use bio_alloc_bioset for passthru IO by default
Date: Fri,  7 Nov 2025 10:05:56 +0800
Message-Id: <20251107020557.10097-2-changfengnan@bytedance.com>
X-Mailer: git-send-email 2.39.5 (Apple Git-154)
In-Reply-To: <20251107020557.10097-1-changfengnan@bytedance.com>
References: <20251107020557.10097-1-changfengnan@bytedance.com>
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
 block/blk-map.c           | 89 +++++++++++++++------------------------
 drivers/nvme/host/ioctl.c |  2 +-
 2 files changed, 36 insertions(+), 55 deletions(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index 60faf036fb6e..272a23d8ef8e 100644
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
@@ -377,9 +361,10 @@ static void bio_copy_kern_endio_read(struct bio *bio)
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
@@ -394,10 +379,9 @@ static struct bio *bio_copy_kern(void *data, unsigned int len, enum req_op op,
 		return ERR_PTR(-EINVAL);
 
 	nr_pages = end - start;
-	bio = bio_kmalloc(nr_pages, gfp_mask);
+	bio = blk_rq_map_bio_alloc(rq, nr_pages, gfp_mask);
 	if (!bio)
 		return ERR_PTR(-ENOMEM);
-	bio_init_inline(bio, NULL, nr_pages, op);
 
 	while (len) {
 		struct page *page;
@@ -431,8 +415,7 @@ static struct bio *bio_copy_kern(void *data, unsigned int len, enum req_op op,
 
 cleanup:
 	bio_free_pages(bio);
-	bio_uninit(bio);
-	kfree(bio);
+	blk_mq_map_bio_put(bio);
 	return ERR_PTR(-ENOMEM);
 }
 
@@ -676,18 +659,16 @@ int blk_rq_map_kern(struct request *rq, void *kbuf, unsigned int len,
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
index c212fa952c0f..cd6bca8a5233 100644
--- a/drivers/nvme/host/ioctl.c
+++ b/drivers/nvme/host/ioctl.c
@@ -446,7 +446,7 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, struct nvme_ns *ns,
 	struct iov_iter iter;
 	struct iov_iter *map_iter = NULL;
 	struct request *req;
-	blk_opf_t rq_flags = REQ_ALLOC_CACHE;
+	blk_opf_t rq_flags;
 	blk_mq_req_flags_t blk_flags = 0;
 	int ret;
 
-- 
2.39.5 (Apple Git-154)


