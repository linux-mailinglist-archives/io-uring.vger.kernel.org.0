Return-Path: <io-uring+bounces-4654-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 13ED79C767F
	for <lists+io-uring@lfdr.de>; Wed, 13 Nov 2024 16:22:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 94FBC1F2299D
	for <lists+io-uring@lfdr.de>; Wed, 13 Nov 2024 15:22:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0408315ADA4;
	Wed, 13 Nov 2024 15:21:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="eQDnb20t"
X-Original-To: io-uring@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C7C70835;
	Wed, 13 Nov 2024 15:21:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731511272; cv=none; b=YrtIZ02VsDAzOepziZuMapVkLQuWUwcMs7nY9vSogPGBuOFWW8GuVPMO41wiOBTki/LfUuaKxPm3WZLwdMDN6JUvlpCORetwe6hIzZa46pabE7EXv5CuJ5mmnSpxDC8E14Rd2j2jmbmxL14W93agV13xUlIGk6vl6zYxJE+CLdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731511272; c=relaxed/simple;
	bh=4DWJ/zzbakZLID8RqBHafikeQRTSqI17daSq5XHHrNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=biblVh5t2ChMdeHqk+DZQTpC9/xQ2iIZfkcorngZ/rcShwu3Ti3KDVfHWZv5vd/QEdguNjYws/a20ANIPbyqpyhiBwdp17jgNQuSvQ76IhBM67Z/SaUIlO8KdQcTRHPkUEbdwO+Sbj7YWd0sLW0yi19rvV0uNpeiB9uAnrB9WYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=eQDnb20t; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=qM6MND3vnG3a/oYFxVefpwUMNZpAPApcwoUL7ZGEt6A=; b=eQDnb20t4PKuL1/834t857e6iP
	gxFLjyEP+oWL0tb31NpVVAFb+SRFwlEIqBSIEf7WZalCtjYIqNja3kNBUvDu9wa7vjgcUsxvCw6G+
	1eGokS8kuOnBlS7z21cZHj2xqsB6P+tO60eUBEvSosRl069OAwgUxyGaKzQTPvP9gRLPJ8sTTAC3R
	J04KKjmCAkQAwyi6FHTZFvql1vUSlvnXwcu7yvZIQWZWyqpP5BIq4/QcU9m2yeNHP/k1TFhKYecA1
	9/BfzJl2L4Pu9Naz+ie5e/3N6w+U/UtV7p5fwKum2Rp+IguRyjHFVWuUc0WEnSn2Y65ZiNLG/jBz5
	YQS191rA==;
Received: from 2a02-8389-2341-5b80-9e61-c6cf-2f07-a796.cable.dynamic.v6.surfer.at ([2a02:8389:2341:5b80:9e61:c6cf:2f07:a796] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1tBFB3-00000007HO9-1yHX;
	Wed, 13 Nov 2024 15:21:05 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>
Cc: "Michael S. Tsirkin" <mst@redhat.com>,
	Jason Wang <jasowang@redhat.com>,
	Keith Busch <kbusch@kernel.org>,
	Sagi Grimberg <sagi@grimberg.me>,
	Pavel Begunkov <asml.silence@gmail.com>,
	linux-block@vger.kernel.org,
	virtualization@lists.linux.dev,
	linux-nvme@lists.infradead.org,
	io-uring@vger.kernel.org
Subject: [PATCH 4/6] block: add a rq_list type
Date: Wed, 13 Nov 2024 16:20:44 +0100
Message-ID: <20241113152050.157179-5-hch@lst.de>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241113152050.157179-1-hch@lst.de>
References: <20241113152050.157179-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Replace the semi-open coded request list helpers with a proper rq_list
type that mirrors the bio_list and has head and tail pointers.  Besides
better type safety this actually allows to insert at the tail of the
list, which will be useful soon.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-core.c              |  6 +--
 block/blk-merge.c             |  2 +-
 block/blk-mq.c                | 40 ++++++++--------
 block/blk-mq.h                |  2 +-
 drivers/block/null_blk/main.c |  9 ++--
 drivers/block/virtio_blk.c    | 13 +++---
 drivers/nvme/host/apple.c     |  2 +-
 drivers/nvme/host/pci.c       | 15 +++---
 include/linux/blk-mq.h        | 88 +++++++++++++++++++++--------------
 include/linux/blkdev.h        | 11 +++--
 io_uring/rw.c                 |  4 +-
 11 files changed, 104 insertions(+), 88 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 0387172e8259..666efe8fa202 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1120,8 +1120,8 @@ void blk_start_plug_nr_ios(struct blk_plug *plug, unsigned short nr_ios)
 		return;
 
 	plug->cur_ktime = 0;
-	plug->mq_list = NULL;
-	plug->cached_rq = NULL;
+	rq_list_init(&plug->mq_list);
+	rq_list_init(&plug->cached_rqs);
 	plug->nr_ios = min_t(unsigned short, nr_ios, BLK_MAX_REQUEST_COUNT);
 	plug->rq_count = 0;
 	plug->multiple_queues = false;
@@ -1217,7 +1217,7 @@ void __blk_flush_plug(struct blk_plug *plug, bool from_schedule)
 	 * queue for cached requests, we don't want a blocked task holding
 	 * up a queue freeze/quiesce event.
 	 */
-	if (unlikely(!rq_list_empty(plug->cached_rq)))
+	if (unlikely(!rq_list_empty(&plug->cached_rqs)))
 		blk_mq_free_plug_rqs(plug);
 
 	plug->cur_ktime = 0;
diff --git a/block/blk-merge.c b/block/blk-merge.c
index df36f83f3738..e0b28e9298c9 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -1179,7 +1179,7 @@ bool blk_attempt_plug_merge(struct request_queue *q, struct bio *bio,
 	struct blk_plug *plug = current->plug;
 	struct request *rq;
 
-	if (!plug || rq_list_empty(plug->mq_list))
+	if (!plug || rq_list_empty(&plug->mq_list))
 		return false;
 
 	rq_list_for_each(&plug->mq_list, rq) {
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 3c6cadba75e3..ff0b819e35fc 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -478,7 +478,7 @@ __blk_mq_alloc_requests_batch(struct blk_mq_alloc_data *data)
 		prefetch(tags->static_rqs[tag]);
 		tag_mask &= ~(1UL << i);
 		rq = blk_mq_rq_ctx_init(data, tags, tag);
-		rq_list_add(data->cached_rq, rq);
+		rq_list_add_head(data->cached_rqs, rq);
 		nr++;
 	}
 	if (!(data->rq_flags & RQF_SCHED_TAGS))
@@ -487,7 +487,7 @@ __blk_mq_alloc_requests_batch(struct blk_mq_alloc_data *data)
 	percpu_ref_get_many(&data->q->q_usage_counter, nr - 1);
 	data->nr_tags -= nr;
 
-	return rq_list_pop(data->cached_rq);
+	return rq_list_pop(data->cached_rqs);
 }
 
 static struct request *__blk_mq_alloc_requests(struct blk_mq_alloc_data *data)
@@ -584,7 +584,7 @@ static struct request *blk_mq_rq_cache_fill(struct request_queue *q,
 		.flags		= flags,
 		.cmd_flags	= opf,
 		.nr_tags	= plug->nr_ios,
-		.cached_rq	= &plug->cached_rq,
+		.cached_rqs	= &plug->cached_rqs,
 	};
 	struct request *rq;
 
@@ -609,14 +609,14 @@ static struct request *blk_mq_alloc_cached_request(struct request_queue *q,
 	if (!plug)
 		return NULL;
 
-	if (rq_list_empty(plug->cached_rq)) {
+	if (rq_list_empty(&plug->cached_rqs)) {
 		if (plug->nr_ios == 1)
 			return NULL;
 		rq = blk_mq_rq_cache_fill(q, plug, opf, flags);
 		if (!rq)
 			return NULL;
 	} else {
-		rq = rq_list_peek(&plug->cached_rq);
+		rq = rq_list_peek(&plug->cached_rqs);
 		if (!rq || rq->q != q)
 			return NULL;
 
@@ -625,7 +625,7 @@ static struct request *blk_mq_alloc_cached_request(struct request_queue *q,
 		if (op_is_flush(rq->cmd_flags) != op_is_flush(opf))
 			return NULL;
 
-		plug->cached_rq = rq_list_next(rq);
+		rq_list_pop(&plug->cached_rqs);
 		blk_mq_rq_time_init(rq, blk_time_get_ns());
 	}
 
@@ -802,7 +802,7 @@ void blk_mq_free_plug_rqs(struct blk_plug *plug)
 {
 	struct request *rq;
 
-	while ((rq = rq_list_pop(&plug->cached_rq)) != NULL)
+	while ((rq = rq_list_pop(&plug->cached_rqs)) != NULL)
 		blk_mq_free_request(rq);
 }
 
@@ -1392,8 +1392,7 @@ static void blk_add_rq_to_plug(struct blk_plug *plug, struct request *rq)
 	 */
 	if (!plug->has_elevator && (rq->rq_flags & RQF_SCHED_TAGS))
 		plug->has_elevator = true;
-	rq->rq_next = NULL;
-	rq_list_add(&plug->mq_list, rq);
+	rq_list_add_head(&plug->mq_list, rq);
 	plug->rq_count++;
 }
 
@@ -2785,7 +2784,7 @@ static void blk_mq_plug_issue_direct(struct blk_plug *plug)
 	blk_status_t ret = BLK_STS_OK;
 
 	while ((rq = rq_list_pop(&plug->mq_list))) {
-		bool last = rq_list_empty(plug->mq_list);
+		bool last = rq_list_empty(&plug->mq_list);
 
 		if (hctx != rq->mq_hctx) {
 			if (hctx) {
@@ -2828,8 +2827,7 @@ static void blk_mq_dispatch_plug_list(struct blk_plug *plug, bool from_sched)
 {
 	struct blk_mq_hw_ctx *this_hctx = NULL;
 	struct blk_mq_ctx *this_ctx = NULL;
-	struct request *requeue_list = NULL;
-	struct request **requeue_lastp = &requeue_list;
+	struct rq_list requeue_list = {};
 	unsigned int depth = 0;
 	bool is_passthrough = false;
 	LIST_HEAD(list);
@@ -2843,12 +2841,12 @@ static void blk_mq_dispatch_plug_list(struct blk_plug *plug, bool from_sched)
 			is_passthrough = blk_rq_is_passthrough(rq);
 		} else if (this_hctx != rq->mq_hctx || this_ctx != rq->mq_ctx ||
 			   is_passthrough != blk_rq_is_passthrough(rq)) {
-			rq_list_add_tail(&requeue_lastp, rq);
+			rq_list_add_tail(&requeue_list, rq);
 			continue;
 		}
 		list_add(&rq->queuelist, &list);
 		depth++;
-	} while (!rq_list_empty(plug->mq_list));
+	} while (!rq_list_empty(&plug->mq_list));
 
 	plug->mq_list = requeue_list;
 	trace_block_unplug(this_hctx->queue, depth, !from_sched);
@@ -2903,19 +2901,19 @@ void blk_mq_flush_plug_list(struct blk_plug *plug, bool from_schedule)
 		if (q->mq_ops->queue_rqs) {
 			blk_mq_run_dispatch_ops(q,
 				__blk_mq_flush_plug_list(q, plug));
-			if (rq_list_empty(plug->mq_list))
+			if (rq_list_empty(&plug->mq_list))
 				return;
 		}
 
 		blk_mq_run_dispatch_ops(q,
 				blk_mq_plug_issue_direct(plug));
-		if (rq_list_empty(plug->mq_list))
+		if (rq_list_empty(&plug->mq_list))
 			return;
 	}
 
 	do {
 		blk_mq_dispatch_plug_list(plug, from_schedule);
-	} while (!rq_list_empty(plug->mq_list));
+	} while (!rq_list_empty(&plug->mq_list));
 }
 
 static void blk_mq_try_issue_list_directly(struct blk_mq_hw_ctx *hctx,
@@ -2980,7 +2978,7 @@ static struct request *blk_mq_get_new_requests(struct request_queue *q,
 	if (plug) {
 		data.nr_tags = plug->nr_ios;
 		plug->nr_ios = 1;
-		data.cached_rq = &plug->cached_rq;
+		data.cached_rqs = &plug->cached_rqs;
 	}
 
 	rq = __blk_mq_alloc_requests(&data);
@@ -3003,7 +3001,7 @@ static struct request *blk_mq_peek_cached_request(struct blk_plug *plug,
 
 	if (!plug)
 		return NULL;
-	rq = rq_list_peek(&plug->cached_rq);
+	rq = rq_list_peek(&plug->cached_rqs);
 	if (!rq || rq->q != q)
 		return NULL;
 	if (type != rq->mq_hctx->type &&
@@ -3017,14 +3015,14 @@ static struct request *blk_mq_peek_cached_request(struct blk_plug *plug,
 static void blk_mq_use_cached_rq(struct request *rq, struct blk_plug *plug,
 		struct bio *bio)
 {
-	WARN_ON_ONCE(rq_list_peek(&plug->cached_rq) != rq);
+	if (rq_list_pop(&plug->cached_rqs) != rq)
+		WARN_ON_ONCE(1);
 
 	/*
 	 * If any qos ->throttle() end up blocking, we will have flushed the
 	 * plug and hence killed the cached_rq list as well. Pop this entry
 	 * before we throttle.
 	 */
-	plug->cached_rq = rq_list_next(rq);
 	rq_qos_throttle(rq->q, bio);
 
 	blk_mq_rq_time_init(rq, blk_time_get_ns());
diff --git a/block/blk-mq.h b/block/blk-mq.h
index f4ac1af77a26..89a20fffa4b1 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -155,7 +155,7 @@ struct blk_mq_alloc_data {
 
 	/* allocate multiple requests/tags in one go */
 	unsigned int nr_tags;
-	struct request **cached_rq;
+	struct rq_list *cached_rqs;
 
 	/* input & output parameter */
 	struct blk_mq_ctx *ctx;
diff --git a/drivers/block/null_blk/main.c b/drivers/block/null_blk/main.c
index 2f0431e42c49..3c3d8d200abb 100644
--- a/drivers/block/null_blk/main.c
+++ b/drivers/block/null_blk/main.c
@@ -1638,10 +1638,9 @@ static blk_status_t null_queue_rq(struct blk_mq_hw_ctx *hctx,
 	return BLK_STS_OK;
 }
 
-static void null_queue_rqs(struct request **rqlist)
+static void null_queue_rqs(struct rq_list *rqlist)
 {
-	struct request *requeue_list = NULL;
-	struct request **requeue_lastp = &requeue_list;
+	struct rq_list requeue_list = {};
 	struct blk_mq_queue_data bd = { };
 	blk_status_t ret;
 
@@ -1651,8 +1650,8 @@ static void null_queue_rqs(struct request **rqlist)
 		bd.rq = rq;
 		ret = null_queue_rq(rq->mq_hctx, &bd);
 		if (ret != BLK_STS_OK)
-			rq_list_add_tail(&requeue_lastp, rq);
-	} while (!rq_list_empty(*rqlist));
+			rq_list_add_tail(&requeue_list, rq);
+	} while (!rq_list_empty(rqlist));
 
 	*rqlist = requeue_list;
 }
diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
index b25f7c06a28e..a19f24c19140 100644
--- a/drivers/block/virtio_blk.c
+++ b/drivers/block/virtio_blk.c
@@ -472,7 +472,7 @@ static bool virtblk_prep_rq_batch(struct request *req)
 }
 
 static void virtblk_add_req_batch(struct virtio_blk_vq *vq,
-					struct request **rqlist)
+		struct rq_list *rqlist)
 {
 	struct request *req;
 	unsigned long flags;
@@ -499,11 +499,10 @@ static void virtblk_add_req_batch(struct virtio_blk_vq *vq,
 		virtqueue_notify(vq->vq);
 }
 
-static void virtio_queue_rqs(struct request **rqlist)
+static void virtio_queue_rqs(struct rq_list *rqlist)
 {
-	struct request *submit_list = NULL;
-	struct request *requeue_list = NULL;
-	struct request **requeue_lastp = &requeue_list;
+	struct rq_list submit_list = { };
+	struct rq_list requeue_list = { };
 	struct virtio_blk_vq *vq = NULL;
 	struct request *req;
 
@@ -515,9 +514,9 @@ static void virtio_queue_rqs(struct request **rqlist)
 		vq = this_vq;
 
 		if (virtblk_prep_rq_batch(req))
-			rq_list_add(&submit_list, req); /* reverse order */
+			rq_list_add_head(&submit_list, req); /* reverse order */
 		else
-			rq_list_add_tail(&requeue_lastp, req);
+			rq_list_add_tail(&requeue_list, req);
 	}
 
 	if (vq)
diff --git a/drivers/nvme/host/apple.c b/drivers/nvme/host/apple.c
index b1387dc459a3..7cd1102a8d2c 100644
--- a/drivers/nvme/host/apple.c
+++ b/drivers/nvme/host/apple.c
@@ -649,7 +649,7 @@ static bool apple_nvme_handle_cq(struct apple_nvme_queue *q, bool force)
 
 	found = apple_nvme_poll_cq(q, &iob);
 
-	if (!rq_list_empty(iob.req_list))
+	if (!rq_list_empty(&iob.req_list))
 		apple_nvme_complete_batch(&iob);
 
 	return found;
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index c66ea2c23690..c3a00a13946d 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -902,7 +902,7 @@ static blk_status_t nvme_queue_rq(struct blk_mq_hw_ctx *hctx,
 	return BLK_STS_OK;
 }
 
-static void nvme_submit_cmds(struct nvme_queue *nvmeq, struct request **rqlist)
+static void nvme_submit_cmds(struct nvme_queue *nvmeq, struct rq_list *rqlist)
 {
 	struct request *req;
 
@@ -930,11 +930,10 @@ static bool nvme_prep_rq_batch(struct nvme_queue *nvmeq, struct request *req)
 	return nvme_prep_rq(nvmeq->dev, req) == BLK_STS_OK;
 }
 
-static void nvme_queue_rqs(struct request **rqlist)
+static void nvme_queue_rqs(struct rq_list *rqlist)
 {
-	struct request *submit_list = NULL;
-	struct request *requeue_list = NULL;
-	struct request **requeue_lastp = &requeue_list;
+	struct rq_list submit_list = { };
+	struct rq_list requeue_list = { };
 	struct nvme_queue *nvmeq = NULL;
 	struct request *req;
 
@@ -944,9 +943,9 @@ static void nvme_queue_rqs(struct request **rqlist)
 		nvmeq = req->mq_hctx->driver_data;
 
 		if (nvme_prep_rq_batch(nvmeq, req))
-			rq_list_add(&submit_list, req); /* reverse order */
+			rq_list_add_head(&submit_list, req); /* reverse order */
 		else
-			rq_list_add_tail(&requeue_lastp, req);
+			rq_list_add_tail(&requeue_list, req);
 	}
 
 	if (nvmeq)
@@ -1078,7 +1077,7 @@ static irqreturn_t nvme_irq(int irq, void *data)
 	DEFINE_IO_COMP_BATCH(iob);
 
 	if (nvme_poll_cq(nvmeq, &iob)) {
-		if (!rq_list_empty(iob.req_list))
+		if (!rq_list_empty(&iob.req_list))
 			nvme_pci_complete_batch(&iob);
 		return IRQ_HANDLED;
 	}
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index ad26a41d13f9..c61e04365677 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -229,44 +229,60 @@ static inline unsigned short req_get_ioprio(struct request *req)
 #define rq_dma_dir(rq) \
 	(op_is_write(req_op(rq)) ? DMA_TO_DEVICE : DMA_FROM_DEVICE)
 
-#define rq_list_add(listptr, rq)	do {		\
-	(rq)->rq_next = *(listptr);			\
-	*(listptr) = rq;				\
-} while (0)
-
-#define rq_list_add_tail(lastpptr, rq)	do {		\
-	(rq)->rq_next = NULL;				\
-	**(lastpptr) = rq;				\
-	*(lastpptr) = &rq->rq_next;			\
-} while (0)
-
-#define rq_list_pop(listptr)				\
-({							\
-	struct request *__req = NULL;			\
-	if ((listptr) && *(listptr))	{		\
-		__req = *(listptr);			\
-		*(listptr) = __req->rq_next;		\
-	}						\
-	__req;						\
-})
+static inline int rq_list_empty(const struct rq_list *rl)
+{
+	return rl->head == NULL;
+}
 
-#define rq_list_peek(listptr)				\
-({							\
-	struct request *__req = NULL;			\
-	if ((listptr) && *(listptr))			\
-		__req = *(listptr);			\
-	__req;						\
-})
+static inline void rq_list_init(struct rq_list *rl)
+{
+	rl->head = NULL;
+	rl->tail = NULL;
+}
+
+static inline void rq_list_add_tail(struct rq_list *rl, struct request *rq)
+{
+	rq->rq_next = NULL;
+	if (rl->tail)
+		rl->tail->rq_next = rq;
+	else
+		rl->head = rq;
+	rl->tail = rq;
+}
+
+static inline void rq_list_add_head(struct rq_list *rl, struct request *rq)
+{
+	rq->rq_next = rl->head;
+	rl->head = rq;
+	if (!rl->tail)
+		rl->tail = rq;
+}
+
+static inline struct request *rq_list_pop(struct rq_list *rl)
+{
+	struct request *rq = rl->head;
+
+	if (rq) {
+		rl->head = rl->head->rq_next;
+		if (!rl->head)
+			rl->tail = NULL;
+		rq->rq_next = NULL;
+	}
+
+	return rq;
+}
 
-#define rq_list_for_each(listptr, pos)			\
-	for (pos = rq_list_peek((listptr)); pos; pos = rq_list_next(pos))
+static inline struct request *rq_list_peek(struct rq_list *rl)
+{
+	return rl->head;
+}
 
-#define rq_list_for_each_safe(listptr, pos, nxt)			\
-	for (pos = rq_list_peek((listptr)), nxt = rq_list_next(pos);	\
-		pos; pos = nxt, nxt = pos ? rq_list_next(pos) : NULL)
+#define rq_list_for_each(rl, pos)					\
+	for (pos = rq_list_peek((rl)); (pos); pos = pos->rq_next)
 
-#define rq_list_next(rq)	(rq)->rq_next
-#define rq_list_empty(list)	((list) == (struct request *) NULL)
+#define rq_list_for_each_safe(rl, pos, nxt)				\
+	for (pos = rq_list_peek((rl)), nxt = pos->rq_next;		\
+		pos; pos = nxt, nxt = pos ? pos->rq_next : NULL)
 
 /**
  * enum blk_eh_timer_return - How the timeout handler should proceed
@@ -559,7 +575,7 @@ struct blk_mq_ops {
 	 * empty the @rqlist completely, then the rest will be queued
 	 * individually by the block layer upon return.
 	 */
-	void (*queue_rqs)(struct request **rqlist);
+	void (*queue_rqs)(struct rq_list *rqlist);
 
 	/**
 	 * @get_budget: Reserve budget before queue request, once .queue_rq is
@@ -868,7 +884,7 @@ static inline bool blk_mq_add_to_batch(struct request *req,
 	else if (iob->complete != complete)
 		return false;
 	iob->need_ts |= blk_mq_need_time_stamp(req);
-	rq_list_add(&iob->req_list, req);
+	rq_list_add_head(&iob->req_list, req);
 	return true;
 }
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 65f37ae70712..ce8b65503ff0 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1006,6 +1006,11 @@ extern void blk_put_queue(struct request_queue *);
 void blk_mark_disk_dead(struct gendisk *disk);
 
 #ifdef CONFIG_BLOCK
+struct rq_list {
+	struct request *head;
+	struct request *tail;
+};
+
 /*
  * blk_plug permits building a queue of related requests by holding the I/O
  * fragments for a short period. This allows merging of sequential requests
@@ -1018,10 +1023,10 @@ void blk_mark_disk_dead(struct gendisk *disk);
  * blk_flush_plug() is called.
  */
 struct blk_plug {
-	struct request *mq_list; /* blk-mq requests */
+	struct rq_list mq_list; /* blk-mq requests */
 
 	/* if ios_left is > 1, we can batch tag/rq allocations */
-	struct request *cached_rq;
+	struct rq_list cached_rqs;
 	u64 cur_ktime;
 	unsigned short nr_ios;
 
@@ -1683,7 +1688,7 @@ int bdev_thaw(struct block_device *bdev);
 void bdev_fput(struct file *bdev_file);
 
 struct io_comp_batch {
-	struct request *req_list;
+	struct rq_list req_list;
 	bool need_ts;
 	void (*complete)(struct io_comp_batch *);
 };
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 354c4e175654..9daef985543e 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -1160,12 +1160,12 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 			poll_flags |= BLK_POLL_ONESHOT;
 
 		/* iopoll may have completed current req */
-		if (!rq_list_empty(iob.req_list) ||
+		if (!rq_list_empty(&iob.req_list) ||
 		    READ_ONCE(req->iopoll_completed))
 			break;
 	}
 
-	if (!rq_list_empty(iob.req_list))
+	if (!rq_list_empty(&iob.req_list))
 		iob.complete(&iob);
 	else if (!pos)
 		return 0;
-- 
2.45.2


