Return-Path: <io-uring+bounces-13176-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mEpzHZok8mlmoQEAu9opvQ
	(envelope-from <io-uring+bounces-13176-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 29 Apr 2026 17:32:42 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DFD96496F95
	for <lists+io-uring@lfdr.de>; Wed, 29 Apr 2026 17:32:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D1B213128EE3
	for <lists+io-uring@lfdr.de>; Wed, 29 Apr 2026 15:26:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7E71637F00D;
	Wed, 29 Apr 2026 15:26:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TY6XL8+S"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36E7837EFFF
	for <io-uring@vger.kernel.org>; Wed, 29 Apr 2026 15:26:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777476407; cv=none; b=CMJKnI3BQkjKLzFEdXReCQENkcMdIncz1bou+8jfeC+g61qn1c1xBtFcll2I8vBorUk4B2l1JlUG2CASDXT3uwUEtLUBuxbivqaKUbU8CUbLgY9i52wMkKXh3iZhr2PPZoxpzvBEjqx7LRJLttiwGZszAScX5D5CuA763Q8CwJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777476407; c=relaxed/simple;
	bh=wPna77yg1sN41atnG+TaUrGkyr7sGycheND1pjkgNrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OyBBWJW0qSqhG8yW1vOG7Z/fP98EdoK/4PN0Vdk3Rmd6yyZaazi/18frLEcBm9QrLE1cpBn0Bi3tYBqTHpJA7+2v9bQm1NYvY2F/ymGV/wyGyArUD1ePuM7pr6uCVaDF8zSFVJqrBMk/EjHO4JxItMoI7fq8dJLYPw0V7tNmBKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TY6XL8+S; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-43cfde3c3f3so12742234f8f.3
        for <io-uring@vger.kernel.org>; Wed, 29 Apr 2026 08:26:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777476402; x=1778081202; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=swjDqvfsydtMCDgC1VH/dViD3xm2NdukCe3jlmQ9xuA=;
        b=TY6XL8+SopWnzYIn0SbdzNv5g86pO9n5+v3Cvu0qi5bOnGzBX7BxvB1PnP1RLoCH3P
         F8Ae4llxZwbHeUX/A6xvs0pPRBr8geA5jkkMMZ+u2oFGlYCIa/B5U/m8mkgiuDqZa2GT
         MRr3T7Tp38ZmmFAfACqOYpqY3vnQh1uFzHALigHNaRPEmChrY5tNXL0kMPWoWkaXtSB4
         NGWN1G68pJTZ0anmuqdmk83WmK3e1OzREoLUjPSQAotRh87+OX1uG1MakOwNJMZqHnb6
         98o+lgiWw98QvScr7M7vN4rUfbIwJHsQlwBCFT8SiKiNqiw0a/sxTBAEUAV4a7iwyCwP
         tqbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777476402; x=1778081202;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=swjDqvfsydtMCDgC1VH/dViD3xm2NdukCe3jlmQ9xuA=;
        b=nLpP4HmyzhPnxHUBkF3C+6RvmgftYxSsIUFEMhhEOuGYkx5lSe4g0ZyD5/4ZVwk80G
         16D8v9zxCnbd7o7l27u8BqyvLXDIiwsjgWjwOqHEM5O3zG/eC7As5Fw5SVx7NOft2ExZ
         j8IJF2vsAtfiQowUqctRTkng+P9K1t6EstdJRUo7jcCEWXZOB+TO0iYH5BULHQfvlcWq
         m6eHzDHMfLG1yRbi0gziGBkhZcTDr7wkhta4fYT6bo+5NI404JPNjshO3Wt3GLK3s8wT
         83jdbPRSGq1KhHcrbEXcxR5CcR9dhz/R7lS+MKoLjX326yZdqwdghQU9wI4Uq5D1C76Q
         YdOw==
X-Forwarded-Encrypted: i=1; AFNElJ9RCZn29BHk082PaMKoXJe7OZ69Do1LmHDSB7v39R/yIWnbIo1BX7il4ZAQqD0kdC3SOkki45IVAg==@vger.kernel.org
X-Gm-Message-State: AOJu0YwDRawkmQORWvizieHXoMfaLcaqNt1BzjjR4ELHOrqSRmMa7PYE
	6ZQOfoTGxWx5MNWkE7Gg09TrzQeQwiTtEkVlgo6rQpf5iU9QQgQue0gH
X-Gm-Gg: AeBDieu0K6KsqWu2VUyJYkwdah6s3XDUhCgoBa44bp6lLo2ch4AEyYK7nQj5Os52qxc
	z03Z8WT+QJ3de/3SGaOwZJlURKfxfmlCRtdLq1Aj7QussPegCo3dWDrmwyE1aeYBpG/Ofy78mk8
	lovn0sUy7sIL16JykC6qQQNDBQVMyIUP3Q3TH99cDwsr0SDpwPJglV3hKzKAlrQf4xa/ulj8Sif
	boEFqs5DuM4hCkL1BqDyi+PP5h0KVtYf6isI/jI0j6aFa6VEGqnGSY3NSx6e4EW+0BARZgPWXVb
	iGws+GL+pMHJ5P0U8jDsxvfcFXAS5wFhqHpmjHJtRLJtTtE3Zem9LWEyYoYs4kXqS3TLGx9Iyjr
	qjC1RyhpVDTcFzXIiUmV8Uw8cJtdvqGVaomY/xZCxo3FpyLxPZ43oiwbJ9nZJXsidSdzh6AZVsU
	ss1f77+xzyR+Ao4p/R2UkWsiHm8npAk+LG/9tHgDOZIsJbnTKj70lNmEblo7Fx92G1RvItxSY+D
	aTTQ1XNFS0H9H4jMfXlO/bgIvJUDcxmzea9dHgGAVCU
X-Received: by 2002:a05:6000:1888:b0:43f:debd:feb1 with SMTP id ffacd0b85a97d-44649ba18b5mr14136832f8f.39.1777476397928;
        Wed, 29 Apr 2026 08:26:37 -0700 (PDT)
Received: from 127.0.0.1localhost ([82.132.184.31])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-447b76e5c22sm6382951f8f.28.2026.04.29.08.26.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Apr 2026 08:26:37 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sumit Semwal <sumit.semwal@linaro.org>,
	=?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org,
	linux-media@vger.kernel.org,
	dri-devel@lists.freedesktop.org,
	linaro-mm-sig@lists.linaro.org
Cc: asml.silence@gmail.com,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Anuj Gupta <anuj20.g@samsung.com>,
	Tushar Gohad <tushar.gohad@intel.com>,
	William Power <william.power@intel.com>,
	Phil Cayton <phil.cayton@intel.com>,
	Jason Gunthorpe <jgg@nvidia.com>
Subject: [PATCH v3 04/10] block: introduce dma map backed bio type
Date: Wed, 29 Apr 2026 16:25:50 +0100
Message-ID: <646ecd6fde8d9e146cb051efb514deb27ce3883e.1777475843.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1777475843.git.asml.silence@gmail.com>
References: <cover.1777475843.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: DFD96496F95
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.16 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	RCPT_COUNT_TWELVE(0.00)[25];
	FREEMAIL_CC(0.00)[gmail.com,samsung.com,intel.com,nvidia.com];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13176-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-0.998];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]

Premapped buffers don't require a generic bio_vec since these have
already been dma mapped. Repurpose the bi_io_vec space to strore dmabuf
maps as they are mutually exclusive.

Suggested-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 block/bio.c               | 25 ++++++++++++++++++++++++-
 block/blk-merge.c         | 14 ++++++++++++++
 block/blk.h               |  3 ++-
 block/fops.c              |  2 ++
 include/linux/bio.h       | 19 ++++++++++++++++---
 include/linux/blk_types.h |  8 +++++++-
 6 files changed, 65 insertions(+), 6 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 0734b50d4992..bdc91777c288 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -851,7 +851,13 @@ static int __bio_clone(struct bio *bio, struct bio *bio_src, gfp_t gfp)
 	bio->bi_write_hint = bio_src->bi_write_hint;
 	bio->bi_write_stream = bio_src->bi_write_stream;
 	bio->bi_iter = bio_src->bi_iter;
-	bio->bi_io_vec = bio_src->bi_io_vec;
+
+	if (!bio_flagged(bio_src, BIO_DMABUF_MAP)) {
+		bio->bi_io_vec = bio_src->bi_io_vec;
+	} else {
+		bio->dmabuf_map = bio_src->dmabuf_map;
+		bio_set_flag(bio, BIO_DMABUF_MAP);
+	}
 
 	if (bio->bi_bdev) {
 		if (bio->bi_bdev == bio_src->bi_bdev &&
@@ -1183,6 +1189,18 @@ void bio_iov_bvec_set(struct bio *bio, const struct iov_iter *iter)
 	bio_set_flag(bio, BIO_CLONED);
 }
 
+void bio_dmabuf_map_set(struct bio *bio, struct iov_iter *iter)
+{
+	WARN_ON_ONCE(bio->bi_max_vecs);
+
+	bio->dmabuf_map = iter->dmabuf_map;
+	bio->bi_vcnt = 0;
+	bio->bi_iter.bi_bvec_done = iter->iov_offset;
+	bio->bi_iter.bi_size = iov_iter_count(iter);
+	bio->bi_opf |= REQ_NOMERGE;
+	bio_set_flag(bio, BIO_DMABUF_MAP);
+}
+
 /*
  * Aligns the bio size to the len_align_mask, releasing excessive bio vecs that
  * __bio_iov_iter_get_pages may have inserted, and reverts the trimmed length
@@ -1252,6 +1270,11 @@ int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter,
 		iov_iter_advance(iter, bio->bi_iter.bi_size);
 		return 0;
 	}
+	if (iov_iter_is_dmabuf_map(iter)) {
+		bio_dmabuf_map_set(bio, iter);
+		iov_iter_advance(iter, bio->bi_iter.bi_size);
+		return 0;
+	}
 
 	if (iov_iter_extract_will_pin(iter))
 		bio_set_flag(bio, BIO_PAGE_PINNED);
diff --git a/block/blk-merge.c b/block/blk-merge.c
index fcf09325b22e..fc2c0c428001 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -348,6 +348,19 @@ int bio_split_io_at(struct bio *bio, const struct queue_limits *lim,
 		len_align_mask |= (bc->bc_key->crypto_cfg.data_unit_size - 1);
 	}
 
+	if (bio_flagged(bio, BIO_DMABUF_MAP)) {
+		nsegs = 1;
+
+		if ((bio->bi_iter.bi_bvec_done & lim->dma_alignment) ||
+		    (bio->bi_iter.bi_size & len_align_mask))
+			return -EINVAL;
+		if (bio->bi_iter.bi_size > max_bytes) {
+			bytes = max_bytes;
+			goto split;
+		}
+		goto out;
+	}
+
 	bio_for_each_bvec(bv, bio, iter) {
 		if (bv.bv_offset & start_align_mask ||
 		    bv.bv_len & len_align_mask)
@@ -378,6 +391,7 @@ int bio_split_io_at(struct bio *bio, const struct queue_limits *lim,
 		bvprvp = &bvprv;
 	}
 
+out:
 	*segs = nsegs;
 	bio->bi_bvec_gap_bit = ffs(gaps);
 	return 0;
diff --git a/block/blk.h b/block/blk.h
index b998a7761faf..b4b09abebce8 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -424,7 +424,8 @@ static inline struct bio *__bio_split_to_limits(struct bio *bio,
 	switch (bio_op(bio)) {
 	case REQ_OP_READ:
 	case REQ_OP_WRITE:
-		if (bio_may_need_split(bio, lim))
+		if (bio_may_need_split(bio, lim) ||
+		    bio_flagged(bio, BIO_DMABUF_MAP))
 			return bio_split_rw(bio, lim, nr_segs);
 		*nr_segs = 1;
 		return bio;
diff --git a/block/fops.c b/block/fops.c
index bb6642b45937..713a3ba3f457 100644
--- a/block/fops.c
+++ b/block/fops.c
@@ -349,6 +349,8 @@ static ssize_t __blkdev_direct_IO_async(struct kiocb *iocb,
 		 * bio_iov_iter_get_pages() and set the bvec directly.
 		 */
 		bio_iov_bvec_set(bio, iter);
+	} else if (iov_iter_is_dmabuf_map(iter)) {
+		bio_dmabuf_map_set(bio, iter);
 	} else {
 		ret = blkdev_iov_iter_get_pages(bio, iter, bdev);
 		if (unlikely(ret))
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 97d747320b35..0c43fa6b0900 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -108,16 +108,26 @@ static inline bool bio_next_segment(const struct bio *bio,
 #define bio_for_each_segment_all(bvl, bio, iter) \
 	for (bvl = bvec_init_iter_all(&iter); bio_next_segment((bio), &iter); )
 
+static inline void bio_advance_iter_dmabuf_map(struct bvec_iter *iter,
+					       unsigned int bytes)
+{
+	iter->bi_bvec_done += bytes;
+	iter->bi_size -= bytes;
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
+	} else if (bio_flagged(bio, BIO_DMABUF_MAP)) {
+		bio_advance_iter_dmabuf_map(iter, bytes);
+	} else {
 		bvec_iter_advance(bio->bi_io_vec, iter, bytes);
 		/* TODO: It is reasonable to complete bio with error here. */
+	}
 }
 
 /* @bytes should be less or equal to bvec[i->bi_idx].bv_len */
@@ -129,6 +139,8 @@ static inline void bio_advance_iter_single(const struct bio *bio,
 
 	if (bio_no_advance_iter(bio))
 		iter->bi_size -= bytes;
+	else if (bio_flagged(bio, BIO_DMABUF_MAP))
+		bio_advance_iter_dmabuf_map(iter, bytes);
 	else
 		bvec_iter_advance_single(bio->bi_io_vec, iter, bytes);
 }
@@ -391,7 +403,7 @@ static inline void bio_wouldblock_error(struct bio *bio)
  */
 static inline int bio_iov_vecs_to_alloc(struct iov_iter *iter, int max_segs)
 {
-	if (iov_iter_is_bvec(iter))
+	if (iov_iter_is_bvec(iter) || iov_iter_is_dmabuf_map(iter))
 		return 0;
 	return iov_iter_npages(iter, max_segs);
 }
@@ -471,6 +483,7 @@ int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter,
 		unsigned len_align_mask);
 
 void bio_iov_bvec_set(struct bio *bio, const struct iov_iter *iter);
+void bio_dmabuf_map_set(struct bio *bio, struct iov_iter *iter);
 void __bio_release_pages(struct bio *bio, bool mark_dirty);
 extern void bio_set_pages_dirty(struct bio *bio);
 extern void bio_check_pages_dirty(struct bio *bio);
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 8808ee76e73c..d5ad085b701d 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -233,7 +233,12 @@ struct bio {
 	atomic_t		__bi_remaining;
 
 	/* The actual vec list, preserved by bio_reset() */
-	struct bio_vec		*bi_io_vec;
+	union {
+		struct bio_vec		*bi_io_vec;
+		/* Driver specific dma map, present only with BIO_DMABUF_MAP */
+		struct io_dmabuf_map	*dmabuf_map;
+	};
+
 	struct bvec_iter	bi_iter;
 
 	union {
@@ -322,6 +327,7 @@ enum {
 	BIO_REMAPPED,
 	BIO_ZONE_WRITE_PLUGGING, /* bio handled through zone write plugging */
 	BIO_EMULATES_ZONE_APPEND, /* bio emulates a zone append operation */
+	BIO_DMABUF_MAP, /* Using premmaped dma buffers */
 	BIO_FLAG_LAST
 };
 
-- 
2.53.0


