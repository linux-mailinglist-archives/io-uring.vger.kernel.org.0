Return-Path: <io-uring+bounces-8503-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E82BAEBB39
	for <lists+io-uring@lfdr.de>; Fri, 27 Jun 2025 17:12:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 972DF189A51D
	for <lists+io-uring@lfdr.de>; Fri, 27 Jun 2025 15:10:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EE4F02E9EB8;
	Fri, 27 Jun 2025 15:09:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UzrBqIG2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7A4B2E8E0D;
	Fri, 27 Jun 2025 15:09:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751036968; cv=none; b=HPdpUMiiPftF+I8jKOO2ErmePvOtVRTikg7NJoqbMNypmfCs62aiZS1+wzWeM2bLwPeyKJvzw3kKXF+Y9PygTh1uG23jpjlE5pFnbVr/Kq0Aijs9bcFUM7XS1CfdzlZ0jgNM5iVKgQCi/U52vvtEndoGZZwnsQWUwSUvPdALaA0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751036968; c=relaxed/simple;
	bh=KWDxPLsGnbk8fG+WmvbBXC/yc19sBb4Gy8Sd+JE5e1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=riXeRmUxV66IIsO1+vxEY93JBB3zSXIQo6IWD7m9CaRKOS4BoNBXCSs1VYdEyQVG+sgkt1WtFiobv6JC+hgiGgtvhS9/zDERhGrloM6zRhOnEc903gvcZiMcP8YFOUfiX7dFFE0k89Ya6VE402aZG5Vbr/sL0eLiX3jEbYasyrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UzrBqIG2; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-ae0a420431bso438489666b.2;
        Fri, 27 Jun 2025 08:09:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751036965; x=1751641765; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RpWD4+kMQgcu38VQMZMvjMOGf7VzHXvFZWMDq5klZzA=;
        b=UzrBqIG2Hsx3LhQtLr0tsgQ03KqGywJ4p1q5dZeEOpJ7OrQkOvciZdsMyKAFZRxkAm
         okUNGqZXdFUqnWInDTgpLMgdRNHHbAXRw3KcaPc3F5n7422Rsen54IBA0PK7bQRC5LK8
         lQgMnbTGAwE1v7rvcSaup2hTjlKtnuPWFQAyDSxs8Ghvo08+/xxOECfxXUd+Q4/0rxn1
         QG9JnlPSLzhs71o3zUnAYx1ZA5tHRmuf/M5ASxnXHPfyp1252vqLGcaOiS/i2hX5LKYV
         TEgs81/v6iuPCd7Ql6lsWXsV3v53mgCBz19tfnTw8OY9ugqzeuP2OqhcrYYsIvazXFiu
         Gqyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751036965; x=1751641765;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RpWD4+kMQgcu38VQMZMvjMOGf7VzHXvFZWMDq5klZzA=;
        b=fUL+3U2w68SVDVVMQvJm9IqOe8piBpA/e1gZHRweLL3js3cM0atNNieU2zhYqVZ8Yw
         4LCCWZCwCIIu3pkM7m6XLCX/VE5U4q0P+TMgZQI21WnCfNgGmW/UOYaIOS6QvzIATZJp
         SRiIUWh7ofA+5Ld6KCqxD6VPeO+2kamXt1Cxh2C7WCqq8FCYZTyEmH+LRZckKqJlJjZv
         carirJUxQa3XatPLtn2DiP4Ach4BqRz0ZluUh01GPy1VeMsCmngXal7N+NCho0ShPATH
         ktEX8lt5TrUe4XRvidFr+HgbO1flndGZ1SnpRdalnP1IuzcsLzWLBSlFqrx4nLcIpCe2
         Fe9A==
X-Forwarded-Encrypted: i=1; AJvYcCUSijXhXUnsKIO1wVK+bJyxcVaFD2WrXj6IU7Nhw2qaX1aqCvjlb80ulKpCeKeThpvh79khB9v+oyB+ng==@vger.kernel.org
X-Gm-Message-State: AOJu0YyHU2I2/FAXGH+WTmq3GMsWKH66dvKIF56f81yQWNLOHXNmS9R2
	IgKPs4r0l35basAST6LV8nbV7Sr4+Bdn7sfXsSf8gXBqznBCE4+aSsENkrlKVA==
X-Gm-Gg: ASbGncuiuyuT4eoBAL277Jlw4hPoCCGzmCS/sFzfLim76pjRNWoU/0fR23uABi+2bNK
	YkC2tAWI+KcjNtYf7TlIxYBcobkvezdeWecQ2v2jiQMduR+6Dh0YkmTJiTnkQ/6dLx1GreE9R4G
	JAkRqBFpZWROhv1USmfhuNLLDqyXNFC2dA1yJ4BK02wJeF0vkdrFuEZHbukzKNoykaWXXPIPMbz
	qeQWHgDhgvC+0lcNNpU7aIFxMFX5FWX8LZrFss4R7aQ2S2p0CU2hwywdBJ6iGeRtJfLYxdecv9f
	ikRpXzsQpsP791DK/e70oV8O18KGszm/mZfb1EV1TD1bCiBDy1jYLhVHbLPgO9BpkkU1HUfoneb
	7
X-Google-Smtp-Source: AGHT+IEv5k45Pnz4J20shFCzhfjwj9GpAntAKXrKttoCW2d3WclD2HmKoC699BkmgmHcg4HQHoePEw==
X-Received: by 2002:a17:907:1b16:b0:ad8:914b:7d0b with SMTP id a640c23a62f3a-ae34fcf46ebmr326692766b.11.1751036964297;
        Fri, 27 Jun 2025 08:09:24 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.147.145])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ae353c014fbsm135802866b.86.2025.06.27.08.09.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Jun 2025 08:09:23 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org,
	linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org
Cc: linux-fsdevel@vger.kernel.org,
	Keith Busch <kbusch@kernel.org>,
	David Wei <dw@davidwei.uk>,
	Vishal Verma <vishal1.verma@intel.com>,
	asml.silence@gmail.com
Subject: [RFC 04/12] block: introduce dmavec bio type
Date: Fri, 27 Jun 2025 16:10:31 +0100
Message-ID: <6b83e74f1840aab6a91d8e050acbfc408dd62c31.1751035820.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1751035820.git.asml.silence@gmail.com>
References: <cover.1751035820.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Premapped buffers don't require a generic bio_vec since these have
already been dma mapped. Repurpose the bi_io_vec with the dma vector
as they are mutually exclusive, and provide the setup and to support
dma vectors.

In order to use this, a driver must implement the .get_dma_device()
blk-mq op. If the driver provides this callback, then it must be
aware that any given bio may be using a dma_tag instead of a
bio_vec.

Note, splitting is not implemented just yet.

Suggested-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 block/bio.c               | 21 +++++++++++++++++++++
 block/blk-merge.c         | 32 ++++++++++++++++++++++++++++++++
 block/blk.h               |  2 +-
 block/fops.c              |  2 ++
 include/linux/bio.h       | 29 ++++++++++++++++++++++++++---
 include/linux/blk_types.h |  6 +++++-
 6 files changed, 87 insertions(+), 5 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 3c0a558c90f5..440f89b9e7de 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -838,6 +838,9 @@ static int __bio_clone(struct bio *bio, struct bio *bio_src, gfp_t gfp)
 		bio_clone_blkg_association(bio, bio_src);
 	}
 
+	if (bio_flagged(bio_src, BIO_DMAVEC))
+		bio_set_flag(bio, BIO_DMAVEC);
+
 	if (bio_crypt_clone(bio, bio_src, gfp) < 0)
 		return -ENOMEM;
 	if (bio_integrity(bio_src) &&
@@ -1156,6 +1159,18 @@ void bio_iov_bvec_set(struct bio *bio, const struct iov_iter *iter)
 	bio_set_flag(bio, BIO_CLONED);
 }
 
+void bio_iov_dmavec_set(struct bio *bio, struct iov_iter *iter)
+{
+	WARN_ON_ONCE(bio->bi_max_vecs);
+
+	bio->bi_vcnt = iter->nr_segs;
+	bio->bi_dmavec = (struct dmavec *)iter->dmavec;
+	bio->bi_iter.bi_bvec_done = iter->iov_offset;
+	bio->bi_iter.bi_size = iov_iter_count(iter);
+	bio->bi_opf |= REQ_NOMERGE;
+	bio_set_flag(bio, BIO_DMAVEC);
+}
+
 static unsigned int get_contig_folio_len(unsigned int *num_pages,
 					 struct page **pages, unsigned int i,
 					 struct folio *folio, size_t left,
@@ -1322,6 +1337,10 @@ int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter)
 		bio_iov_bvec_set(bio, iter);
 		iov_iter_advance(iter, bio->bi_iter.bi_size);
 		return 0;
+	} else if (iov_iter_is_dma(iter)) {
+		bio_iov_dmavec_set(bio, iter);
+		iov_iter_advance(iter, bio->bi_iter.bi_size);
+		return 0;
 	}
 
 	if (iov_iter_extract_will_pin(iter))
@@ -1673,6 +1692,8 @@ struct bio *bio_split(struct bio *bio, int sectors,
 	/* Zone append commands cannot be split */
 	if (WARN_ON_ONCE(bio_op(bio) == REQ_OP_ZONE_APPEND))
 		return ERR_PTR(-EINVAL);
+	if (WARN_ON_ONCE(bio_flagged(bio, BIO_DMAVEC)))
+		return ERR_PTR(-EINVAL);
 
 	/* atomic writes cannot be split */
 	if (bio->bi_opf & REQ_ATOMIC)
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 3af1d284add5..f932ed61dcb5 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -278,6 +278,35 @@ static unsigned int bio_split_alignment(struct bio *bio,
 	return lim->logical_block_size;
 }
 
+static int bio_split_rw_at_dmavec(struct bio *bio, const struct queue_limits *lim,
+				  unsigned *segs, unsigned max_bytes)
+{
+	struct dmavec *dmav;
+	int offset, length;
+
+	/* Aggressively refuse any splitting, should be improved */
+
+	if (!lim->virt_boundary_mask)
+		return -EINVAL;
+	if (bio->bi_vcnt > lim->max_segments)
+		return -EINVAL;
+	if (bio->bi_iter.bi_size > max_bytes)
+		return -EINVAL;
+
+	dmav = &bio->bi_dmavec[bio->bi_iter.bi_idx];
+	offset = bio->bi_iter.bi_bvec_done;
+	length = bio->bi_iter.bi_size;
+	while (length > 0) {
+		if (dmav->len - offset > lim->max_segment_size)
+			return -EINVAL;
+		length -= dmav->len;
+		dmav++;
+	}
+	*segs = bio->bi_vcnt;
+	return 0;
+}
+
+
 /**
  * bio_split_rw_at - check if and where to split a read/write bio
  * @bio:  [in] bio to be split
@@ -297,6 +326,9 @@ int bio_split_rw_at(struct bio *bio, const struct queue_limits *lim,
 	struct bvec_iter iter;
 	unsigned nsegs = 0, bytes = 0;
 
+	if (bio_flagged(bio, BIO_DMAVEC))
+		return bio_split_rw_at_dmavec(bio, lim, segs, max_bytes);
+
 	bio_for_each_bvec(bv, bio, iter) {
 		/*
 		 * If the queue doesn't support SG gaps and adding this
diff --git a/block/blk.h b/block/blk.h
index 37ec459fe656..85429f542bd2 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -386,7 +386,7 @@ static inline struct bio *__bio_split_to_limits(struct bio *bio,
 	switch (bio_op(bio)) {
 	case REQ_OP_READ:
 	case REQ_OP_WRITE:
-		if (bio_may_need_split(bio, lim))
+		if (bio_may_need_split(bio, lim) || bio_flagged(bio, BIO_DMAVEC))
 			return bio_split_rw(bio, lim, nr_segs);
 		*nr_segs = 1;
 		return bio;
diff --git a/block/fops.c b/block/fops.c
index 1309861d4c2c..388acfe82b6c 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -347,6 +347,8 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
 		 * bio_iov_iter_get_pages() and set the bvec directly.
 		 */
 		bio_iov_bvec_set(bio, iter);
+	} else if (iov_iter_is_dma(iter)) {
+		bio_iov_dmavec_set(bio, iter);
 	} else {
 		ret = bio_iov_iter_get_pages(bio, iter);
 		if (unlikely(ret))
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 8349569414ed..49f6b20d77f6 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -108,16 +108,36 @@ static inline bool bio_next_segment(const struct bio *bio,
 #define bio_for_each_segment_all(bvl, bio, iter) \
 	for (bvl = bvec_init_iter_all(&iter); bio_next_segment((bio), &iter); )
 
+static inline void bio_advance_iter_dma(const struct bio *bio,
+				    struct bvec_iter *iter, unsigned int bytes)
+{
+	unsigned int idx = iter->bi_idx;
+
+	iter->bi_size -= bytes;
+	bytes += iter->bi_bvec_done;
+
+	while (bytes && bytes >= bio->bi_dmavec[idx].len) {
+		bytes -= bio->bi_dmavec[idx].len;
+		idx++;
+	}
+
+	iter->bi_idx = idx;
+	iter->bi_bvec_done = bytes;
+}
+
 static inline void bio_advance_iter(const struct bio *bio,
 				    struct bvec_iter *iter, unsigned int bytes)
 {
 	iter->bi_sector += bytes >> 9;
 
-	if (bio_no_advance_iter(bio))
+	if (bio_no_advance_iter(bio)) {
 		iter->bi_size -= bytes;
-	else
+	} else if (bio_flagged(bio, BIO_DMAVEC)) {
+		bio_advance_iter_dma(bio, iter, bytes);
+	} else {
 		bvec_iter_advance(bio->bi_io_vec, iter, bytes);
 		/* TODO: It is reasonable to complete bio with error here. */
+	}
 }
 
 /* @bytes should be less or equal to bvec[i->bi_idx].bv_len */
@@ -129,6 +149,8 @@ static inline void bio_advance_iter_single(const struct bio *bio,
 
 	if (bio_no_advance_iter(bio))
 		iter->bi_size -= bytes;
+	else if (bio_flagged(bio, BIO_DMAVEC))
+		bio_advance_iter_dma(bio, iter, bytes);
 	else
 		bvec_iter_advance_single(bio->bi_io_vec, iter, bytes);
 }
@@ -396,7 +418,7 @@ static inline void bio_wouldblock_error(struct bio *bio)
  */
 static inline int bio_iov_vecs_to_alloc(struct iov_iter *iter, int max_segs)
 {
-	if (iov_iter_is_bvec(iter))
+	if (iov_iter_is_bvec(iter) || iov_iter_is_dma(iter))
 		return 0;
 	return iov_iter_npages(iter, max_segs);
 }
@@ -443,6 +465,7 @@ int bdev_rw_virt(struct block_device *bdev, sector_t sector, void *data,
 
 int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter);
 void bio_iov_bvec_set(struct bio *bio, const struct iov_iter *iter);
+void bio_iov_dmavec_set(struct bio *bio, struct iov_iter *iter);
 void __bio_release_pages(struct bio *bio, bool mark_dirty);
 extern void bio_set_pages_dirty(struct bio *bio);
 extern void bio_check_pages_dirty(struct bio *bio);
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 3d1577f07c1c..dc2a5945604a 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -266,7 +266,10 @@ struct bio {
 
 	atomic_t		__bi_cnt;	/* pin count */
 
-	struct bio_vec		*bi_io_vec;	/* the actual vec list */
+	union {
+		struct bio_vec		*bi_io_vec;	/* the actual vec list */
+		struct dmavec		*bi_dmavec;
+	};
 
 	struct bio_set		*bi_pool;
 
@@ -308,6 +311,7 @@ enum {
 	BIO_REMAPPED,
 	BIO_ZONE_WRITE_PLUGGING, /* bio handled through zone write plugging */
 	BIO_EMULATES_ZONE_APPEND, /* bio emulates a zone append operation */
+	BIO_DMAVEC, /* Using premmaped dma buffers */
 	BIO_FLAG_LAST
 };
 
-- 
2.49.0


