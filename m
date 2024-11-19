Return-Path: <io-uring+bounces-4820-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DE54B9D2578
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 13:18:55 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9512E1F23A1E
	for <lists+io-uring@lfdr.de>; Tue, 19 Nov 2024 12:18:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6712E1CCEFE;
	Tue, 19 Nov 2024 12:16:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kFgnoIc/"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E08941CDFC3;
	Tue, 19 Nov 2024 12:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732018618; cv=none; b=bNATVQOjy2kcniCGaoYCtnQfNg2OsgN8UKFL8+1T9GHxLAgdo3PnEyGRScNpvI1jqY019ujI9FKQ8GAYp6Fh6wE6FzM4FMJkOwY4BCsc+r9q7vSINOQxu7akYsdVVrFECyOGV+b0wrIT+tXCx29Ka96bYuYujhjN61igDM/ZZA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732018618; c=relaxed/simple;
	bh=ZVGxzpQZSkqWvDD3TpC2hrlv8GOQG7h+efF32UTMDAE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZzKULCZlJIHAf0PKWKBe/jjSLrN9ndx2nojLaNeKutavGucH8YYUfi5+trZ4myJDP8Es78W7eVryeW9x9YkCMQltBxvyqFjRjE8IPV9d/R960eJ/r660boAaYeJTyPrHqlcTz6g+ROUHE3eClUJ/kpI9/cbiL2t6AWoekrgFKpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kFgnoIc/; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=IuHLWbXl17oUwGr2uJNRZmdZTGTpCXDRWm/qYEw8Z8A=; b=kFgnoIc/cdWeaAdXuvsdfYiWfC
	U9VSgKLWJU8EJEXwZLXDZ0clTG4T5FXg2IEtvvehXKCil+BEJgFL0CnBdJg20blVlo5f5B2qlt9le
	qsIsbnbIdoEPzKylF8lKP1ZSbCeusXmqVXsr95hdQJUtgUdt+OSpsCWEPSTSE/JuROXFomBtnlfHj
	TDAcAGAdfWNakEfPkDDsZ5l6ZH6oZA6t7AJ2bwLPQGPLIjapAFsMJ848T3kNKD3WlO48iUb0eYGSR
	KDl6+Ac+gLrd1WiM9mamEnJIcBVzlKsC9vuFJCQmpMHRTgRFjvB99VZ80enxfxP37v6+iyGsk1uZ/
	vSMDy8iw==;
Received: from 2a02-8389-2341-5b80-1731-a089-d2b1-3edf.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:1731:a089:d2b1:3edf] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tDNA6-0000000CIyz-02Zh;
	Tue, 19 Nov 2024 12:16:54 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: Christian Brauner <brauner@kernel.org>,
	Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Kanchan Joshi <joshi.k@samsung.com>,
	Hui Qi <hui81.qi@samsung.com>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Jan Kara <jack@suse.cz>,
	Pavel Begunkov <asml.silence@gmail.com>,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org,
	linux-fsdevel@vger.kernel.org,
	io-uring@vger.kernel.org
Subject: [PATCH 06/15] block: add a bi_write_stream field
Date: Tue, 19 Nov 2024 13:16:20 +0100
Message-ID: <20241119121632.1225556-7-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241119121632.1225556-1-hch@lst.de>
References: <20241119121632.1225556-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add the ability to pass a write stream for placement control in the bio.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/bio.c                 | 2 ++
 block/blk-crypto-fallback.c | 1 +
 block/blk-merge.c           | 4 ++++
 block/bounce.c              | 1 +
 include/linux/blk_types.h   | 1 +
 5 files changed, 9 insertions(+)

diff --git a/block/bio.c b/block/bio.c
index 699a78c85c75..2aa86edc7cd6 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -251,6 +251,7 @@ void bio_init(struct bio *bio, struct block_device *bdev, struct bio_vec *table,
 	bio->bi_flags = 0;
 	bio->bi_ioprio = 0;
 	bio->bi_write_hint = 0;
+	bio->bi_write_stream = 0;
 	bio->bi_status = 0;
 	bio->bi_iter.bi_sector = 0;
 	bio->bi_iter.bi_size = 0;
@@ -827,6 +828,7 @@ static int __bio_clone(struct bio *bio, struct bio *bio_src, gfp_t gfp)
 	bio_set_flag(bio, BIO_CLONED);
 	bio->bi_ioprio = bio_src->bi_ioprio;
 	bio->bi_write_hint = bio_src->bi_write_hint;
+	bio->bi_write_stream = bio_src->bi_write_stream;
 	bio->bi_iter = bio_src->bi_iter;
 
 	if (bio->bi_bdev) {
diff --git a/block/blk-crypto-fallback.c b/block/blk-crypto-fallback.c
index 29a205482617..66762243a886 100644
--- a/block/blk-crypto-fallback.c
+++ b/block/blk-crypto-fallback.c
@@ -173,6 +173,7 @@ static struct bio *blk_crypto_fallback_clone_bio(struct bio *bio_src)
 		bio_set_flag(bio, BIO_REMAPPED);
 	bio->bi_ioprio		= bio_src->bi_ioprio;
 	bio->bi_write_hint	= bio_src->bi_write_hint;
+	bio->bi_write_stream	= bio_src->bi_write_stream;
 	bio->bi_iter.bi_sector	= bio_src->bi_iter.bi_sector;
 	bio->bi_iter.bi_size	= bio_src->bi_iter.bi_size;
 
diff --git a/block/blk-merge.c b/block/blk-merge.c
index e01383c6e534..1e5327fb6c45 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -866,6 +866,8 @@ static struct request *attempt_merge(struct request_queue *q,
 
 	if (req->bio->bi_write_hint != next->bio->bi_write_hint)
 		return NULL;
+	if (req->bio->bi_write_stream != next->bio->bi_write_stream)
+		return NULL;
 	if (req->bio->bi_ioprio != next->bio->bi_ioprio)
 		return NULL;
 	if (!blk_atomic_write_mergeable_rqs(req, next))
@@ -987,6 +989,8 @@ bool blk_rq_merge_ok(struct request *rq, struct bio *bio)
 		return false;
 	if (rq->bio->bi_write_hint != bio->bi_write_hint)
 		return false;
+	if (rq->bio->bi_write_stream != bio->bi_write_stream)
+		return false;
 	if (rq->bio->bi_ioprio != bio->bi_ioprio)
 		return false;
 	if (blk_atomic_write_mergeable_rq_bio(rq, bio) == false)
diff --git a/block/bounce.c b/block/bounce.c
index 0d898cd5ec49..fb8f60f114d7 100644
--- a/block/bounce.c
+++ b/block/bounce.c
@@ -170,6 +170,7 @@ static struct bio *bounce_clone_bio(struct bio *bio_src)
 		bio_set_flag(bio, BIO_REMAPPED);
 	bio->bi_ioprio		= bio_src->bi_ioprio;
 	bio->bi_write_hint	= bio_src->bi_write_hint;
+	bio->bi_write_stream	= bio_src->bi_write_stream;
 	bio->bi_iter.bi_sector	= bio_src->bi_iter.bi_sector;
 	bio->bi_iter.bi_size	= bio_src->bi_iter.bi_size;
 
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index dce7615c35e7..4ca3449ce9c9 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -220,6 +220,7 @@ struct bio {
 	unsigned short		bi_flags;	/* BIO_* below */
 	unsigned short		bi_ioprio;
 	enum rw_hint		bi_write_hint;
+	u8			bi_write_stream;
 	blk_status_t		bi_status;
 	atomic_t		__bi_remaining;
 
-- 
2.45.2


