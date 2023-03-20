Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D26026C1B34
	for <lists+io-uring@lfdr.de>; Mon, 20 Mar 2023 17:21:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231977AbjCTQVD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 20 Mar 2023 12:21:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232022AbjCTQUi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 20 Mar 2023 12:20:38 -0400
Received: from mx0a-00082601.pphosted.com (mx0a-00082601.pphosted.com [67.231.145.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFECDBDFC
        for <io-uring@vger.kernel.org>; Mon, 20 Mar 2023 09:12:18 -0700 (PDT)
Received: from pps.filterd (m0044010.ppops.net [127.0.0.1])
        by mx0a-00082601.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32K97VxD004745
        for <io-uring@vger.kernel.org>; Mon, 20 Mar 2023 09:12:18 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=meta.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding :
 content-type; s=s2048-2021-q4;
 bh=hP2ugGUfXZWB7bKpwBhxX4WMaPOtLeBAzvbfIhFoCrs=;
 b=DexflX2SavfCjvFTytG4J7fS6jt/ilzeP5NXKX7m68mRaijocRuWyyHwQLJLXc4Db70O
 EQvLtVAuRfdpkCn5ft7d9LTa4/3vQvhMSaWh9e2gLKYH5xm9KNKnwSn30gYFQ1IWSRfK
 rF4Gptj6j0xi7MyuMThOq54rcPxs62WhmIIgAtwHtwM0z6SLLuFB5mYqrLf410upsL8v
 ezmL4qC2fDgbwkjCbye7qO5R4Na4mnwEeZw8A0BQNvv+CQ1/NS/5Ya6Ty7fWiQ4wl1tn
 wWhm9Ahf6GCHyIajDUXQmUSJRaHts4jhpG3loDXV+TE8zsZcDfL/rPKoSVg8GYa+1pBb bg== 
Received: from maileast.thefacebook.com ([163.114.130.16])
        by mx0a-00082601.pphosted.com (PPS) with ESMTPS id 3pd8mrtenu-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
        for <io-uring@vger.kernel.org>; Mon, 20 Mar 2023 09:12:18 -0700
Received: from twshared4419.04.ash8.facebook.com (2620:10d:c0a8:1b::d) by
 mail.thefacebook.com (2620:10d:c0a8:82::e) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.17; Mon, 20 Mar 2023 09:12:13 -0700
Received: by devbig007.nao1.facebook.com (Postfix, from userid 544533)
        id 439AF13FD65A1; Mon, 20 Mar 2023 09:12:06 -0700 (PDT)
From:   Keith Busch <kbusch@meta.com>
To:     <linux-block@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>,
        <io-uring@vger.kernel.org>
CC:     Pavel Begunkov <asml.silence@gmail.com>,
        Keith Busch <kbusch@kernel.org>
Subject: [PATCH] blk-mq: remove hybrid polling
Date:   Mon, 20 Mar 2023 09:12:05 -0700
Message-ID: <20230320161205.1714865-1-kbusch@meta.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-FB-Internal: Safe
Content-Type: text/plain
X-Proofpoint-GUID: u603LKdJmpmKeyXBm_bnVsT-Wj00BTtu
X-Proofpoint-ORIG-GUID: u603LKdJmpmKeyXBm_bnVsT-Wj00BTtu
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-20_13,2023-03-20_02,2023-02-09_01
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Keith Busch <kbusch@kernel.org>

io_uring provides the only way user space can poll completions, and that
always sets BLK_POLL_NOSLEEP. This effectively makes hybrid polling dead
code, so remove it and everything supporting it.

Signed-off-by: Keith Busch <kbusch@kernel.org>
---
 block/blk-core.c       |   6 --
 block/blk-mq-debugfs.c |  26 ------
 block/blk-mq.c         | 205 ++---------------------------------------
 block/blk-stat.c       |  18 ----
 block/blk-sysfs.c      |  33 +------
 include/linux/blk-mq.h |   2 -
 include/linux/blkdev.h |  12 ---
 io_uring/rw.c          |   2 +-
 8 files changed, 9 insertions(+), 295 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 9e5e0277a4d95..269765d16cfd9 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -263,13 +263,7 @@ static void blk_free_queue_rcu(struct rcu_head *rcu_=
head)
=20
 static void blk_free_queue(struct request_queue *q)
 {
-	if (q->poll_stat)
-		blk_stat_remove_callback(q, q->poll_cb);
-	blk_stat_free_callback(q->poll_cb);
-
 	blk_free_queue_stats(q->stats);
-	kfree(q->poll_stat);
-
 	if (queue_is_mq(q))
 		blk_mq_release(q);
=20
diff --git a/block/blk-mq-debugfs.c b/block/blk-mq-debugfs.c
index b01818f8e216e..212a7f301e730 100644
--- a/block/blk-mq-debugfs.c
+++ b/block/blk-mq-debugfs.c
@@ -15,33 +15,8 @@
 #include "blk-mq-tag.h"
 #include "blk-rq-qos.h"
=20
-static void print_stat(struct seq_file *m, struct blk_rq_stat *stat)
-{
-	if (stat->nr_samples) {
-		seq_printf(m, "samples=3D%d, mean=3D%llu, min=3D%llu, max=3D%llu",
-			   stat->nr_samples, stat->mean, stat->min, stat->max);
-	} else {
-		seq_puts(m, "samples=3D0");
-	}
-}
-
 static int queue_poll_stat_show(void *data, struct seq_file *m)
 {
-	struct request_queue *q =3D data;
-	int bucket;
-
-	if (!q->poll_stat)
-		return 0;
-
-	for (bucket =3D 0; bucket < (BLK_MQ_POLL_STATS_BKTS / 2); bucket++) {
-		seq_printf(m, "read  (%d Bytes): ", 1 << (9 + bucket));
-		print_stat(m, &q->poll_stat[2 * bucket]);
-		seq_puts(m, "\n");
-
-		seq_printf(m, "write (%d Bytes): ",  1 << (9 + bucket));
-		print_stat(m, &q->poll_stat[2 * bucket + 1]);
-		seq_puts(m, "\n");
-	}
 	return 0;
 }
=20
@@ -282,7 +257,6 @@ static const char *const rqf_name[] =3D {
 	RQF_NAME(STATS),
 	RQF_NAME(SPECIAL_PAYLOAD),
 	RQF_NAME(ZONE_WRITE_LOCKED),
-	RQF_NAME(MQ_POLL_SLEPT),
 	RQF_NAME(TIMED_OUT),
 	RQF_NAME(ELV),
 	RQF_NAME(RESV),
diff --git a/block/blk-mq.c b/block/blk-mq.c
index a875b1cdff9b5..4e30459df8151 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -46,51 +46,15 @@
=20
 static DEFINE_PER_CPU(struct llist_head, blk_cpu_done);
=20
-static void blk_mq_poll_stats_start(struct request_queue *q);
-static void blk_mq_poll_stats_fn(struct blk_stat_callback *cb);
-
-static int blk_mq_poll_stats_bkt(const struct request *rq)
-{
-	int ddir, sectors, bucket;
-
-	ddir =3D rq_data_dir(rq);
-	sectors =3D blk_rq_stats_sectors(rq);
-
-	bucket =3D ddir + 2 * ilog2(sectors);
-
-	if (bucket < 0)
-		return -1;
-	else if (bucket >=3D BLK_MQ_POLL_STATS_BKTS)
-		return ddir + BLK_MQ_POLL_STATS_BKTS - 2;
-
-	return bucket;
-}
-
-#define BLK_QC_T_SHIFT		16
-#define BLK_QC_T_INTERNAL	(1U << 31)
-
 static inline struct blk_mq_hw_ctx *blk_qc_to_hctx(struct request_queue =
*q,
 		blk_qc_t qc)
 {
-	return xa_load(&q->hctx_table,
-			(qc & ~BLK_QC_T_INTERNAL) >> BLK_QC_T_SHIFT);
-}
-
-static inline struct request *blk_qc_to_rq(struct blk_mq_hw_ctx *hctx,
-		blk_qc_t qc)
-{
-	unsigned int tag =3D qc & ((1U << BLK_QC_T_SHIFT) - 1);
-
-	if (qc & BLK_QC_T_INTERNAL)
-		return blk_mq_tag_to_rq(hctx->sched_tags, tag);
-	return blk_mq_tag_to_rq(hctx->tags, tag);
+	return xa_load(&q->hctx_table, qc);
 }
=20
 static inline blk_qc_t blk_rq_to_qc(struct request *rq)
 {
-	return (rq->mq_hctx->queue_num << BLK_QC_T_SHIFT) |
-		(rq->tag !=3D -1 ?
-		 rq->tag : (rq->internal_tag | BLK_QC_T_INTERNAL));
+	return rq->mq_hctx->queue_num;
 }
=20
 /*
@@ -1038,10 +1002,8 @@ static inline void blk_account_io_start(struct req=
uest *req)
=20
 static inline void __blk_mq_end_request_acct(struct request *rq, u64 now=
)
 {
-	if (rq->rq_flags & RQF_STATS) {
-		blk_mq_poll_stats_start(rq->q);
+	if (rq->rq_flags & RQF_STATS)
 		blk_stat_add(rq, now);
-	}
=20
 	blk_mq_sched_completed_request(rq, now);
 	blk_account_io_done(rq, now);
@@ -4222,14 +4184,8 @@ int blk_mq_init_allocated_queue(struct blk_mq_tag_=
set *set,
 	/* mark the queue as mq asap */
 	q->mq_ops =3D set->ops;
=20
-	q->poll_cb =3D blk_stat_alloc_callback(blk_mq_poll_stats_fn,
-					     blk_mq_poll_stats_bkt,
-					     BLK_MQ_POLL_STATS_BKTS, q);
-	if (!q->poll_cb)
-		goto err_exit;
-
 	if (blk_mq_alloc_ctxs(q))
-		goto err_poll;
+		goto err_exit;
=20
 	/* init q->mq_kobj and sw queues' kobjects */
 	blk_mq_sysfs_init(q);
@@ -4257,11 +4213,6 @@ int blk_mq_init_allocated_queue(struct blk_mq_tag_=
set *set,
=20
 	q->nr_requests =3D set->queue_depth;
=20
-	/*
-	 * Default to classic polling
-	 */
-	q->poll_nsec =3D BLK_MQ_POLL_CLASSIC;
-
 	blk_mq_init_cpu_queues(q, set->nr_hw_queues);
 	blk_mq_add_queue_tag_set(set, q);
 	blk_mq_map_swqueue(q);
@@ -4269,9 +4220,6 @@ int blk_mq_init_allocated_queue(struct blk_mq_tag_s=
et *set,
=20
 err_hctxs:
 	blk_mq_release(q);
-err_poll:
-	blk_stat_free_callback(q->poll_cb);
-	q->poll_cb =3D NULL;
 err_exit:
 	q->mq_ops =3D NULL;
 	return -ENOMEM;
@@ -4768,138 +4716,8 @@ void blk_mq_update_nr_hw_queues(struct blk_mq_tag=
_set *set, int nr_hw_queues)
 }
 EXPORT_SYMBOL_GPL(blk_mq_update_nr_hw_queues);
=20
-/* Enable polling stats and return whether they were already enabled. */
-static bool blk_poll_stats_enable(struct request_queue *q)
-{
-	if (q->poll_stat)
-		return true;
-
-	return blk_stats_alloc_enable(q);
-}
-
-static void blk_mq_poll_stats_start(struct request_queue *q)
-{
-	/*
-	 * We don't arm the callback if polling stats are not enabled or the
-	 * callback is already active.
-	 */
-	if (!q->poll_stat || blk_stat_is_active(q->poll_cb))
-		return;
-
-	blk_stat_activate_msecs(q->poll_cb, 100);
-}
-
-static void blk_mq_poll_stats_fn(struct blk_stat_callback *cb)
-{
-	struct request_queue *q =3D cb->data;
-	int bucket;
-
-	for (bucket =3D 0; bucket < BLK_MQ_POLL_STATS_BKTS; bucket++) {
-		if (cb->stat[bucket].nr_samples)
-			q->poll_stat[bucket] =3D cb->stat[bucket];
-	}
-}
-
-static unsigned long blk_mq_poll_nsecs(struct request_queue *q,
-				       struct request *rq)
-{
-	unsigned long ret =3D 0;
-	int bucket;
-
-	/*
-	 * If stats collection isn't on, don't sleep but turn it on for
-	 * future users
-	 */
-	if (!blk_poll_stats_enable(q))
-		return 0;
-
-	/*
-	 * As an optimistic guess, use half of the mean service time
-	 * for this type of request. We can (and should) make this smarter.
-	 * For instance, if the completion latencies are tight, we can
-	 * get closer than just half the mean. This is especially
-	 * important on devices where the completion latencies are longer
-	 * than ~10 usec. We do use the stats for the relevant IO size
-	 * if available which does lead to better estimates.
-	 */
-	bucket =3D blk_mq_poll_stats_bkt(rq);
-	if (bucket < 0)
-		return ret;
-
-	if (q->poll_stat[bucket].nr_samples)
-		ret =3D (q->poll_stat[bucket].mean + 1) / 2;
-
-	return ret;
-}
-
-static bool blk_mq_poll_hybrid(struct request_queue *q, blk_qc_t qc)
-{
-	struct blk_mq_hw_ctx *hctx =3D blk_qc_to_hctx(q, qc);
-	struct request *rq =3D blk_qc_to_rq(hctx, qc);
-	struct hrtimer_sleeper hs;
-	enum hrtimer_mode mode;
-	unsigned int nsecs;
-	ktime_t kt;
-
-	/*
-	 * If a request has completed on queue that uses an I/O scheduler, we
-	 * won't get back a request from blk_qc_to_rq.
-	 */
-	if (!rq || (rq->rq_flags & RQF_MQ_POLL_SLEPT))
-		return false;
-
-	/*
-	 * If we get here, hybrid polling is enabled. Hence poll_nsec can be:
-	 *
-	 *  0:	use half of prev avg
-	 * >0:	use this specific value
-	 */
-	if (q->poll_nsec > 0)
-		nsecs =3D q->poll_nsec;
-	else
-		nsecs =3D blk_mq_poll_nsecs(q, rq);
-
-	if (!nsecs)
-		return false;
-
-	rq->rq_flags |=3D RQF_MQ_POLL_SLEPT;
-
-	/*
-	 * This will be replaced with the stats tracking code, using
-	 * 'avg_completion_time / 2' as the pre-sleep target.
-	 */
-	kt =3D nsecs;
-
-	mode =3D HRTIMER_MODE_REL;
-	hrtimer_init_sleeper_on_stack(&hs, CLOCK_MONOTONIC, mode);
-	hrtimer_set_expires(&hs.timer, kt);
-
-	do {
-		if (blk_mq_rq_state(rq) =3D=3D MQ_RQ_COMPLETE)
-			break;
-		set_current_state(TASK_UNINTERRUPTIBLE);
-		hrtimer_sleeper_start_expires(&hs, mode);
-		if (hs.task)
-			io_schedule();
-		hrtimer_cancel(&hs.timer);
-		mode =3D HRTIMER_MODE_ABS;
-	} while (hs.task && !signal_pending(current));
-
-	__set_current_state(TASK_RUNNING);
-	destroy_hrtimer_on_stack(&hs.timer);
-
-	/*
-	 * If we sleep, have the caller restart the poll loop to reset the
-	 * state.  Like for the other success return cases, the caller is
-	 * responsible for checking if the IO completed.  If the IO isn't
-	 * complete, we'll get called again and will go straight to the busy
-	 * poll loop.
-	 */
-	return true;
-}
-
-static int blk_mq_poll_classic(struct request_queue *q, blk_qc_t cookie,
-			       struct io_comp_batch *iob, unsigned int flags)
+int blk_mq_poll(struct request_queue *q, blk_qc_t cookie, struct io_comp=
_batch *iob,
+		unsigned int flags)
 {
 	struct blk_mq_hw_ctx *hctx =3D blk_qc_to_hctx(q, cookie);
 	long state =3D get_current_state();
@@ -4926,17 +4744,6 @@ static int blk_mq_poll_classic(struct request_queu=
e *q, blk_qc_t cookie,
 	return 0;
 }
=20
-int blk_mq_poll(struct request_queue *q, blk_qc_t cookie, struct io_comp=
_batch *iob,
-		unsigned int flags)
-{
-	if (!(flags & BLK_POLL_NOSLEEP) &&
-	    q->poll_nsec !=3D BLK_MQ_POLL_CLASSIC) {
-		if (blk_mq_poll_hybrid(q, cookie))
-			return 1;
-	}
-	return blk_mq_poll_classic(q, cookie, iob, flags);
-}
-
 unsigned int blk_mq_rq_cpu(struct request *rq)
 {
 	return rq->mq_ctx->cpu;
diff --git a/block/blk-stat.c b/block/blk-stat.c
index c6ca16abf911e..74a1a8c32d86f 100644
--- a/block/blk-stat.c
+++ b/block/blk-stat.c
@@ -231,21 +231,3 @@ void blk_free_queue_stats(struct blk_queue_stats *st=
ats)
=20
 	kfree(stats);
 }
-
-bool blk_stats_alloc_enable(struct request_queue *q)
-{
-	struct blk_rq_stat *poll_stat;
-
-	poll_stat =3D kcalloc(BLK_MQ_POLL_STATS_BKTS, sizeof(*poll_stat),
-				GFP_ATOMIC);
-	if (!poll_stat)
-		return false;
-
-	if (cmpxchg(&q->poll_stat, NULL, poll_stat) !=3D NULL) {
-		kfree(poll_stat);
-		return true;
-	}
-
-	blk_stat_add_callback(q, q->poll_cb);
-	return false;
-}
diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
index f1fce1c7fa44b..c6c231f3d0f10 100644
--- a/block/blk-sysfs.c
+++ b/block/blk-sysfs.c
@@ -408,36 +408,7 @@ queue_rq_affinity_store(struct request_queue *q, con=
st char *page, size_t count)
=20
 static ssize_t queue_poll_delay_show(struct request_queue *q, char *page=
)
 {
-	int val;
-
-	if (q->poll_nsec =3D=3D BLK_MQ_POLL_CLASSIC)
-		val =3D BLK_MQ_POLL_CLASSIC;
-	else
-		val =3D q->poll_nsec / 1000;
-
-	return sprintf(page, "%d\n", val);
-}
-
-static ssize_t queue_poll_delay_store(struct request_queue *q, const cha=
r *page,
-				size_t count)
-{
-	int err, val;
-
-	if (!q->mq_ops || !q->mq_ops->poll)
-		return -EINVAL;
-
-	err =3D kstrtoint(page, 10, &val);
-	if (err < 0)
-		return err;
-
-	if (val =3D=3D BLK_MQ_POLL_CLASSIC)
-		q->poll_nsec =3D BLK_MQ_POLL_CLASSIC;
-	else if (val >=3D 0)
-		q->poll_nsec =3D val * 1000;
-	else
-		return -EINVAL;
-
-	return count;
+	return sprintf(page, "%d\n", -1);
 }
=20
 static ssize_t queue_poll_show(struct request_queue *q, char *page)
@@ -617,7 +588,7 @@ QUEUE_RO_ENTRY(queue_max_active_zones, "max_active_zo=
nes");
 QUEUE_RW_ENTRY(queue_nomerges, "nomerges");
 QUEUE_RW_ENTRY(queue_rq_affinity, "rq_affinity");
 QUEUE_RW_ENTRY(queue_poll, "io_poll");
-QUEUE_RW_ENTRY(queue_poll_delay, "io_poll_delay");
+QUEUE_RO_ENTRY(queue_poll_delay, "io_poll_delay");
 QUEUE_RW_ENTRY(queue_wc, "write_cache");
 QUEUE_RO_ENTRY(queue_fua, "fua");
 QUEUE_RO_ENTRY(queue_dax, "dax");
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index dd5ce1137f04a..1dacb2c81fdda 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -57,8 +57,6 @@ typedef __u32 __bitwise req_flags_t;
 #define RQF_SPECIAL_PAYLOAD	((__force req_flags_t)(1 << 18))
 /* The per-zone write lock is held for this request */
 #define RQF_ZONE_WRITE_LOCKED	((__force req_flags_t)(1 << 19))
-/* already slept for hybrid poll */
-#define RQF_MQ_POLL_SLEPT	((__force req_flags_t)(1 << 20))
 /* ->timeout has been called, don't expire again */
 #define RQF_TIMED_OUT		((__force req_flags_t)(1 << 21))
 /* queue has elevator attached */
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index d1aee08f8c181..6ede578dfbc64 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -44,12 +44,6 @@ extern const struct device_type disk_type;
 extern struct device_type part_type;
 extern struct class block_class;
=20
-/* Must be consistent with blk_mq_poll_stats_bkt() */
-#define BLK_MQ_POLL_STATS_BKTS 16
-
-/* Doing classic polling */
-#define BLK_MQ_POLL_CLASSIC -1
-
 /*
  * Maximum number of blkcg policies allowed to be registered concurrentl=
y.
  * Defined here to simplify include dependency.
@@ -468,10 +462,6 @@ struct request_queue {
 #endif
=20
 	unsigned int		rq_timeout;
-	int			poll_nsec;
-
-	struct blk_stat_callback	*poll_cb;
-	struct blk_rq_stat	*poll_stat;
=20
 	struct timer_list	timeout;
 	struct work_struct	timeout_work;
@@ -870,8 +860,6 @@ blk_status_t errno_to_blk_status(int errno);
=20
 /* only poll the hardware once, don't continue until a completion was fo=
und */
 #define BLK_POLL_ONESHOT		(1 << 0)
-/* do not sleep to wait for the expected completion time */
-#define BLK_POLL_NOSLEEP		(1 << 1)
 int bio_poll(struct bio *bio, struct io_comp_batch *iob, unsigned int fl=
ags);
 int iocb_bio_iopoll(struct kiocb *kiocb, struct io_comp_batch *iob,
 			unsigned int flags);
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 4c233910e2009..a099dc0543d95 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -1002,7 +1002,7 @@ void io_rw_fail(struct io_kiocb *req)
 int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 {
 	struct io_wq_work_node *pos, *start, *prev;
-	unsigned int poll_flags =3D BLK_POLL_NOSLEEP;
+	unsigned int poll_flags =3D 0;
 	DEFINE_IO_COMP_BATCH(iob);
 	int nr_events =3D 0;
=20
--=20
2.34.1

