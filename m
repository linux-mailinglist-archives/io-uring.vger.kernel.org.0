Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F231424A66
	for <lists+io-uring@lfdr.de>; Thu,  7 Oct 2021 01:13:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230492AbhJFXPa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Oct 2021 19:15:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231135AbhJFXP3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Oct 2021 19:15:29 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EA82C061746
        for <io-uring@vger.kernel.org>; Wed,  6 Oct 2021 16:13:36 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id p80so4641544iod.10
        for <io-uring@vger.kernel.org>; Wed, 06 Oct 2021 16:13:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=f0CDhZ3n9c9Wbis2PmGVaPgugzsGmtUSf+fxsIMVGmw=;
        b=phyA3KEXMh7wFtX0TNaStaUPlzsaKWMq5abW5zZGdgeA4IonWOPutibqdId0q9sYK2
         PBTzKCzmlfQAytFcdXvgBhLO37dK/Wooy0AAmFw0ZMW9RN1ajgCXzQUJpl+WlRoui8RE
         3mi659LwzDjaXs4jlZE9/ALpU9tdiYevtaD5pMCp2E+zisOzgp4+CRXV5lho9kX3nri9
         Um+hMRVpc/MVzO7xxLc4a6ZJS7Mhwxf8E27wvcVOxgIsaWt1OawixvBXD/ECmVF1y/Jt
         qCBwNw+1eoyzXaVwlNpFrPOWJgld2/xcGrGO9gYZebzPqeaVADnSARqcUYWhEW06Ekdr
         nqaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=f0CDhZ3n9c9Wbis2PmGVaPgugzsGmtUSf+fxsIMVGmw=;
        b=exfz5bPZrtLByUSXbV8vxCzO1oFw32rhtvNzg2veWGvK+98AV0owsqMw2bCvnlZUh4
         LCbv3bdE5HOlBdhsXGZnyqKL58Bn8y/T1cq4Q5J0l55IaJNwxjlh/gibcMcyTe7DPJlY
         bILmaBjy6gWMwLQiPvvhtcnCYK1Gtq6s/QS328kU4C5dN4qT2cp7fRvTZa+ld24ZqMVP
         nnhZTpn7f+tZPYuHEIT5u9csZ/HOvf6XGHXjH+lyhxFMr16Gg72vlekFtvt1we1dp5HR
         PMvelMXvvR0ydgpdHRcAPsYFLHgNhRXmYm3SnB6O6UfIkKOYkqR4adZz78XI4PAlXEYa
         WzTw==
X-Gm-Message-State: AOAM532RRsQOmottNypurdL44uN5hDStsLfBRhLlg+mJVwYcvqynVb/L
        jHR7NEIWpnAf19moSVTieCSY1g==
X-Google-Smtp-Source: ABdhPJymVS9ebXOcm3pIk39zBp0lxakeabhdHebYp44tR5qTHf/9daOekgARzxH1f0Xt/fCZN5CrEw==
X-Received: by 2002:a6b:8b52:: with SMTP id n79mr808914iod.8.1633562015797;
        Wed, 06 Oct 2021 16:13:35 -0700 (PDT)
Received: from p1.localdomain ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id o1sm12955203ilj.41.2021.10.06.16.13.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Oct 2021 16:13:35 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     linux-block@vger.kernel.org
Cc:     io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/3] block: pre-allocate requests if plug is started and is a batch
Date:   Wed,  6 Oct 2021 17:13:29 -0600
Message-Id: <20211006231330.20268-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211006231330.20268-1-axboe@kernel.dk>
References: <20211006231330.20268-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The caller typically has a good (or even exact) idea of how many requests
it needs to submit. We can make the request/tag allocation a lot more
efficient if we just allocate N requests/tags upfront when we queue the
first bio from the batch.

Provide a new plug start helper that allows the caller to specify how many
IOs are expected. This sets plug->nr_ios, and we can use that for smarter
request allocation. The plug provides a holding spot for requests, and
request allocation will check it before calling into the normal request
allocation path.

The blk_finish_plug() is called, check if there are unused requests and
free them. This should not happen in normal operations. The exception is
if we get merging, then we may be left with requests that need freeing
when done.

This raises the per-core performance on my setup from ~5.8M to ~6.1M
IOPS.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 block/blk-core.c       | 47 ++++++++++++++++------------
 block/blk-mq.c         | 70 ++++++++++++++++++++++++++++++++++--------
 block/blk-mq.h         |  5 +++
 include/linux/blk-mq.h |  5 ++-
 include/linux/blkdev.h | 15 ++++++++-
 5 files changed, 109 insertions(+), 33 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index d83e56b2f64e..9b8c70670190 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1624,6 +1624,31 @@ int kblockd_mod_delayed_work_on(int cpu, struct delayed_work *dwork,
 }
 EXPORT_SYMBOL(kblockd_mod_delayed_work_on);
 
+void blk_start_plug_nr_ios(struct blk_plug *plug, unsigned short nr_ios)
+{
+	struct task_struct *tsk = current;
+
+	/*
+	 * If this is a nested plug, don't actually assign it.
+	 */
+	if (tsk->plug)
+		return;
+
+	INIT_LIST_HEAD(&plug->mq_list);
+	plug->cached_rq = NULL;
+	plug->nr_ios = min_t(unsigned short, nr_ios, BLK_MAX_REQUEST_COUNT);
+	plug->rq_count = 0;
+	plug->multiple_queues = false;
+	plug->nowait = false;
+	INIT_LIST_HEAD(&plug->cb_list);
+
+	/*
+	 * Store ordering should not be needed here, since a potential
+	 * preempt will imply a full memory barrier
+	 */
+	tsk->plug = plug;
+}
+
 /**
  * blk_start_plug - initialize blk_plug and track it inside the task_struct
  * @plug:	The &struct blk_plug that needs to be initialized
@@ -1649,25 +1674,7 @@ EXPORT_SYMBOL(kblockd_mod_delayed_work_on);
  */
 void blk_start_plug(struct blk_plug *plug)
 {
-	struct task_struct *tsk = current;
-
-	/*
-	 * If this is a nested plug, don't actually assign it.
-	 */
-	if (tsk->plug)
-		return;
-
-	INIT_LIST_HEAD(&plug->mq_list);
-	INIT_LIST_HEAD(&plug->cb_list);
-	plug->rq_count = 0;
-	plug->multiple_queues = false;
-	plug->nowait = false;
-
-	/*
-	 * Store ordering should not be needed here, since a potential
-	 * preempt will imply a full memory barrier
-	 */
-	tsk->plug = plug;
+	blk_start_plug_nr_ios(plug, 1);
 }
 EXPORT_SYMBOL(blk_start_plug);
 
@@ -1719,6 +1726,8 @@ void blk_flush_plug_list(struct blk_plug *plug, bool from_schedule)
 
 	if (!list_empty(&plug->mq_list))
 		blk_mq_flush_plug_list(plug, from_schedule);
+	if (unlikely(!from_schedule && plug->cached_rq))
+		blk_mq_free_plug_rqs(plug);
 }
 
 /**
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 5327abbefbab..ced94eb8e297 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -352,6 +352,7 @@ static struct request *__blk_mq_alloc_request(struct blk_mq_alloc_data *data)
 	struct request_queue *q = data->q;
 	struct elevator_queue *e = q->elevator;
 	u64 alloc_time_ns = 0;
+	struct request *rq;
 	unsigned int tag;
 
 	/* alloc_time includes depth and tag waits */
@@ -385,10 +386,21 @@ static struct request *__blk_mq_alloc_request(struct blk_mq_alloc_data *data)
 	 * case just retry the hctx assignment and tag allocation as CPU hotplug
 	 * should have migrated us to an online CPU by now.
 	 */
-	tag = blk_mq_get_tag(data);
-	if (tag == BLK_MQ_NO_TAG) {
+	do {
+		tag = blk_mq_get_tag(data);
+		if (tag != BLK_MQ_NO_TAG) {
+			rq = blk_mq_rq_ctx_init(data, tag, alloc_time_ns);
+			if (!--data->nr_tags)
+				return rq;
+			if (e || data->hctx->flags & BLK_MQ_F_TAG_QUEUE_SHARED)
+				return rq;
+			rq->rq_next = *data->cached_rq;
+			*data->cached_rq = rq;
+			data->flags |= BLK_MQ_REQ_NOWAIT;
+			continue;
+		}
 		if (data->flags & BLK_MQ_REQ_NOWAIT)
-			return NULL;
+			break;
 
 		/*
 		 * Give up the CPU and sleep for a random short time to ensure
@@ -397,8 +409,15 @@ static struct request *__blk_mq_alloc_request(struct blk_mq_alloc_data *data)
 		 */
 		msleep(3);
 		goto retry;
+	} while (1);
+
+	if (data->cached_rq) {
+		rq = *data->cached_rq;
+		*data->cached_rq = rq->rq_next;
+		return rq;
 	}
-	return blk_mq_rq_ctx_init(data, tag, alloc_time_ns);
+
+	return NULL;
 }
 
 struct request *blk_mq_alloc_request(struct request_queue *q, unsigned int op,
@@ -408,6 +427,7 @@ struct request *blk_mq_alloc_request(struct request_queue *q, unsigned int op,
 		.q		= q,
 		.flags		= flags,
 		.cmd_flags	= op,
+		.nr_tags	= 1,
 	};
 	struct request *rq;
 	int ret;
@@ -436,6 +456,7 @@ struct request *blk_mq_alloc_request_hctx(struct request_queue *q,
 		.q		= q,
 		.flags		= flags,
 		.cmd_flags	= op,
+		.nr_tags	= 1,
 	};
 	u64 alloc_time_ns = 0;
 	unsigned int cpu;
@@ -537,6 +558,18 @@ void blk_mq_free_request(struct request *rq)
 }
 EXPORT_SYMBOL_GPL(blk_mq_free_request);
 
+void blk_mq_free_plug_rqs(struct blk_plug *plug)
+{
+	while (plug->cached_rq) {
+		struct request *rq;
+
+		rq = plug->cached_rq;
+		plug->cached_rq = rq->rq_next;
+		percpu_ref_get(&rq->q->q_usage_counter);
+		blk_mq_free_request(rq);
+	}
+}
+
 inline void __blk_mq_end_request(struct request *rq, blk_status_t error)
 {
 	u64 now = 0;
@@ -2178,6 +2211,7 @@ blk_qc_t blk_mq_submit_bio(struct bio *bio)
 	const int is_flush_fua = op_is_flush(bio->bi_opf);
 	struct blk_mq_alloc_data data = {
 		.q		= q,
+		.nr_tags	= 1,
 	};
 	struct request *rq;
 	struct blk_plug *plug;
@@ -2204,13 +2238,26 @@ blk_qc_t blk_mq_submit_bio(struct bio *bio)
 
 	hipri = bio->bi_opf & REQ_HIPRI;
 
-	data.cmd_flags = bio->bi_opf;
-	rq = __blk_mq_alloc_request(&data);
-	if (unlikely(!rq)) {
-		rq_qos_cleanup(q, bio);
-		if (bio->bi_opf & REQ_NOWAIT)
-			bio_wouldblock_error(bio);
-		goto queue_exit;
+	plug = blk_mq_plug(q, bio);
+	if (plug && plug->cached_rq) {
+		rq = plug->cached_rq;
+		plug->cached_rq = rq->rq_next;
+		INIT_LIST_HEAD(&rq->queuelist);
+		data.hctx = rq->mq_hctx;
+	} else {
+		data.cmd_flags = bio->bi_opf;
+		if (plug) {
+			data.nr_tags = plug->nr_ios;
+			plug->nr_ios = 1;
+			data.cached_rq = &plug->cached_rq;
+		}
+		rq = __blk_mq_alloc_request(&data);
+		if (unlikely(!rq)) {
+			rq_qos_cleanup(q, bio);
+			if (bio->bi_opf & REQ_NOWAIT)
+				bio_wouldblock_error(bio);
+			goto queue_exit;
+		}
 	}
 
 	trace_block_getrq(bio);
@@ -2229,7 +2276,6 @@ blk_qc_t blk_mq_submit_bio(struct bio *bio)
 		return BLK_QC_T_NONE;
 	}
 
-	plug = blk_mq_plug(q, bio);
 	if (unlikely(is_flush_fua)) {
 		/* Bypass scheduler for flush requests */
 		blk_insert_flush(rq);
diff --git a/block/blk-mq.h b/block/blk-mq.h
index 171e8cdcff54..5da970bb8865 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -125,6 +125,7 @@ extern int __blk_mq_register_dev(struct device *dev, struct request_queue *q);
 extern int blk_mq_sysfs_register(struct request_queue *q);
 extern void blk_mq_sysfs_unregister(struct request_queue *q);
 extern void blk_mq_hctx_kobj_init(struct blk_mq_hw_ctx *hctx);
+void blk_mq_free_plug_rqs(struct blk_plug *plug);
 
 void blk_mq_release(struct request_queue *q);
 
@@ -152,6 +153,10 @@ struct blk_mq_alloc_data {
 	unsigned int shallow_depth;
 	unsigned int cmd_flags;
 
+	/* allocate multiple requests/tags in one go */
+	unsigned int nr_tags;
+	struct request **cached_rq;
+
 	/* input & output parameter */
 	struct blk_mq_ctx *ctx;
 	struct blk_mq_hw_ctx *hctx;
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 75d75657df21..0e941f217578 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -90,7 +90,10 @@ struct request {
 	struct bio *bio;
 	struct bio *biotail;
 
-	struct list_head queuelist;
+	union {
+		struct list_head queuelist;
+		struct request *rq_next;
+	};
 
 	/*
 	 * The hash is used inside the scheduler, and killed once the
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 472b4ab007c6..17705c970d7e 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -722,10 +722,17 @@ extern void blk_set_queue_dying(struct request_queue *);
  */
 struct blk_plug {
 	struct list_head mq_list; /* blk-mq requests */
-	struct list_head cb_list; /* md requires an unplug callback */
+
+	/* if ios_left is > 1, we can batch tag/rq allocations */
+	struct request *cached_rq;
+	unsigned short nr_ios;
+
 	unsigned short rq_count;
+
 	bool multiple_queues;
 	bool nowait;
+
+	struct list_head cb_list; /* md requires an unplug callback */
 };
 
 struct blk_plug_cb;
@@ -738,6 +745,7 @@ struct blk_plug_cb {
 extern struct blk_plug_cb *blk_check_plugged(blk_plug_cb_fn unplug,
 					     void *data, int size);
 extern void blk_start_plug(struct blk_plug *);
+extern void blk_start_plug_nr_ios(struct blk_plug *, unsigned short);
 extern void blk_finish_plug(struct blk_plug *);
 extern void blk_flush_plug_list(struct blk_plug *, bool);
 
@@ -772,6 +780,11 @@ long nr_blockdev_pages(void);
 struct blk_plug {
 };
 
+static inline void blk_start_plug_nr_ios(struct blk_plug *plug,
+					 unsigned short nr_ios)
+{
+}
+
 static inline void blk_start_plug(struct blk_plug *plug)
 {
 }
-- 
2.33.0

