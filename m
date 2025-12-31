Return-Path: <io-uring+bounces-11339-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 52321CEB296
	for <lists+io-uring@lfdr.de>; Wed, 31 Dec 2025 04:05:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 2168430BD511
	for <lists+io-uring@lfdr.de>; Wed, 31 Dec 2025 03:01:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4937F258EE9;
	Wed, 31 Dec 2025 03:01:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gdj5A3gJ"
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A902EEA8
	for <io-uring@vger.kernel.org>; Wed, 31 Dec 2025 03:01:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767150083; cv=none; b=ZRrTSqSVjhYg5BAEQEYfgFFkKQ+lzlNfAlyo310AaOgab0YPvt+R8newJNf9Je0F4U0EapFfw6ZqtfKbeP6O+7OZjxJva1qU/Ek0Qc0z7yg5wmfPzQPV5e3b6czOT3Tu2/RNnv5r7sDj0fcWqsedX/WD6g/PLTRwCw1SmfQkIgk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767150083; c=relaxed/simple;
	bh=+yS1Xgm7ZTndxTjMkLUQsPJ/ktcS2b8Oj0Qr8rZAopo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CnGhEPQPgWw9aUrEDw0WKfKhOOv7dxGRDodbixirMgE32N4BBdK09oA6PJ+u/gnhmXkmu38+yZkjbjhKr1zcmpF96pqQigxXrM7Wl+FITAqqcFD0Ge5SJW73hvHEGYeKtAA+1/iuw17+5Y+/STRMQDt0EeEjq3ZeFPGu7CM3JzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gdj5A3gJ; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1767150079;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+c9s53QwusPZZbohRndeyrv2RkXWiDdmDG8EtGNuFhM=;
	b=gdj5A3gJhQlEfXZjMPXJG82lRaW6wvhIrwHcTB2q6t77MQHhY4TuMgnbEZtI5BG+BRk473
	1CA1YfBQ3onfdzcfEX4//+oUtbUhF/Awl9Kye4mmvGuMDg4iBancSNg344NFkRo1Y8dluS
	DuWugITedN0LuCk7gcOfqPvxfw1uBeU=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-400-WjYDp-0aNQGOxPvX7laKdg-1; Tue,
 30 Dec 2025 22:01:15 -0500
X-MC-Unique: WjYDp-0aNQGOxPvX7laKdg-1
X-Mimecast-MFC-AGG-ID: WjYDp-0aNQGOxPvX7laKdg_1767150074
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 48EB6180065F;
	Wed, 31 Dec 2025 03:01:14 +0000 (UTC)
Received: from localhost (unknown [10.72.116.52])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 9AA4030001A7;
	Wed, 31 Dec 2025 03:01:11 +0000 (UTC)
From: Ming Lei <ming.lei@redhat.com>
To: Jens Axboe <axboe@kernel.dk>,
	linux-block@vger.kernel.org
Cc: io-uring@vger.kernel.org,
	Caleb Sander Mateos <csander@purestorage.com>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V2 1/3] block: use bvec iterator helper for bio_may_need_split()
Date: Wed, 31 Dec 2025 11:00:55 +0800
Message-ID: <20251231030101.3093960-2-ming.lei@redhat.com>
In-Reply-To: <20251231030101.3093960-1-ming.lei@redhat.com>
References: <20251231030101.3093960-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

bio_may_need_split() uses bi_vcnt to determine if a bio has a single
segment, but bi_vcnt is unreliable for cloned bios. Cloned bios share
the parent's bi_io_vec array but iterate over a subset via bi_iter,
so bi_vcnt may not reflect the actual segment count being iterated.

Replace the bi_vcnt check with bvec iterator access via
__bvec_iter_bvec(), comparing bi_iter.bi_size against the current
bvec's length. This correctly handles both cloned and non-cloned bios.

Move bi_io_vec into the first cache line adjacent to bi_iter. This is
a sensible layout since bi_io_vec and bi_iter are commonly accessed
together throughout the block layer - every bvec iteration requires
both fields. This displaces bi_end_io to the second cache line, which
is acceptable since bi_end_io and bi_private are always fetched
together in bio_endio() anyway.

The struct layout change requires bio_reset() to preserve and restore
bi_io_vec across the memset, since it now falls within BIO_RESET_BYTES.

Nitesh verified that this patch doesn't regress NVMe 512-byte IO perf [1].

Link: https://lore.kernel.org/linux-block/20251220081607.tvnrltcngl3cc2fh@green245.gost/ [1]
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/bio.c               |  3 +++
 block/blk.h               | 12 +++++++++---
 include/linux/blk_types.h |  4 ++--
 3 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index e726c0e280a8..0e936288034e 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -301,9 +301,12 @@ EXPORT_SYMBOL(bio_init);
  */
 void bio_reset(struct bio *bio, struct block_device *bdev, blk_opf_t opf)
 {
+	struct bio_vec          *bv = bio->bi_io_vec;
+
 	bio_uninit(bio);
 	memset(bio, 0, BIO_RESET_BYTES);
 	atomic_set(&bio->__bi_remaining, 1);
+	bio->bi_io_vec = bv;
 	bio->bi_bdev = bdev;
 	if (bio->bi_bdev)
 		bio_associate_blkg(bio);
diff --git a/block/blk.h b/block/blk.h
index e4c433f62dfc..98f4dfd4ec75 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -371,12 +371,18 @@ struct bio *bio_split_zone_append(struct bio *bio,
 static inline bool bio_may_need_split(struct bio *bio,
 		const struct queue_limits *lim)
 {
+	const struct bio_vec *bv;
+
 	if (lim->chunk_sectors)
 		return true;
-	if (bio->bi_vcnt != 1)
+
+	if (!bio->bi_io_vec)
+		return true;
+
+	bv = __bvec_iter_bvec(bio->bi_io_vec, bio->bi_iter);
+	if (bio->bi_iter.bi_size > bv->bv_len)
 		return true;
-	return bio->bi_io_vec->bv_len + bio->bi_io_vec->bv_offset >
-		lim->max_fast_segment_size;
+	return bv->bv_len + bv->bv_offset > lim->max_fast_segment_size;
 }
 
 /**
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 5dc061d318a4..19a888a2f104 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -232,6 +232,8 @@ struct bio {
 
 	atomic_t		__bi_remaining;
 
+	/* The actual vec list, preserved by bio_reset() */
+	struct bio_vec		*bi_io_vec;
 	struct bvec_iter	bi_iter;
 
 	union {
@@ -275,8 +277,6 @@ struct bio {
 
 	atomic_t		__bi_cnt;	/* pin count */
 
-	struct bio_vec		*bi_io_vec;	/* the actual vec list */
-
 	struct bio_set		*bi_pool;
 };
 
-- 
2.47.0


