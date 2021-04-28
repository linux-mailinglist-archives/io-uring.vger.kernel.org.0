Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47A5936D855
	for <lists+io-uring@lfdr.de>; Wed, 28 Apr 2021 15:32:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbhD1NdW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Apr 2021 09:33:22 -0400
Received: from out30-133.freemail.mail.aliyun.com ([115.124.30.133]:54149 "EHLO
        out30-133.freemail.mail.aliyun.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231166AbhD1NdW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Apr 2021 09:33:22 -0400
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R101e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=e01e04423;MF=haoxu@linux.alibaba.com;NM=1;PH=DS;RN=4;SR=0;TI=SMTPD_---0UX4Z1lB_1619616749;
Received: from e18g09479.et15sqa.tbsite.net(mailfrom:haoxu@linux.alibaba.com fp:SMTPD_---0UX4Z1lB_1619616749)
          by smtp.aliyun-inc.com(127.0.0.1);
          Wed, 28 Apr 2021 21:32:36 +0800
From:   Hao Xu <haoxu@linux.alibaba.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Pavel Begunkov <asml.silence@gmail.com>,
        Joseph Qi <joseph.qi@linux.alibaba.com>
Subject: [PATCH RFC 5.13 1/2] io_uring: add support for ns granularity of io_sq_thread_idle
Date:   Wed, 28 Apr 2021 21:32:27 +0800
Message-Id: <1619616748-17149-2-git-send-email-haoxu@linux.alibaba.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1619616748-17149-1-git-send-email-haoxu@linux.alibaba.com>
References: <1619616748-17149-1-git-send-email-haoxu@linux.alibaba.com>
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

currently unit of io_sq_thread_idle is millisecond, the smallest value
is 1ms, which means for IOPS > 1000, sqthread will very likely  take
100% cpu usage. This is not necessary in some cases, like users may
don't care about latency much in low IO pressure
(like 1000 < IOPS < 20000), but cpu resource does matter. So we offer
an option of nanosecond granularity of io_sq_thread_idle. Some test
results by fio below:

uring average latency:(us)
iops\idle	10us	60us	110us	160us	210us	260us	310us	360us	410us	460us	510us
2k	        10.93	10.68	10.72	10.7	10.79	10.52	10.59	10.54	10.47	10.39	8.4
4k	        10.55	10.48	10.51	10.42	10.35	8.34
6k	        10.82	10.5	10.39	8.4
8k	        10.44	10.45	10.34	8.39
10k	        10.45	10.39	8.33

uring cpu usage of sqthread:
iops\idle	10us	60us	110us	160us	210us	260us	310us	360us	410us	460us	510us
2k	        4%	14%	24%	34.70%	44.70%	55%	65.10%	75.40%	85.40%	95.70%	100%
4k	        7.70%	28.20%	48.50%	69%	90%	100%
6k	        11.30%	42%	73%	100%
8k	        15.30%	56.30%	97%	100%
10k	        19%	70%	100%

aio average latency:(us)
iops	latency	99th lat  cpu
2k	13.34	14.272    3%
4k	13.195	14.016	  7%
6k	13.29	14.656	  9.70%
8k	13.2	14.656	  12.70%
10k	13.2	15	  17%

fio config is:
./run_fio.sh
fio \
--ioengine=io_uring --sqthread_poll=1 --hipri=1 --thread=1 --bs=4k \
--direct=1 --rw=randread --time_based=1 --runtime=300 \
--group_reporting=1 --filename=/dev/nvme1n1 --sqthread_poll_cpu=30 \
--randrepeat=0 --cpus_allowed=35 --iodepth=128 --rate_iops=${1} \
--io_sq_thread_idle=${2}

in 2k IOPS, if latency of 10.93us is acceptable for an application,
then they get 100% - 4% = 96% reduction of cpu usage, while the latency
is smaller than aio(10.93us vs 13.34us).

Signed-off-by: Hao Xu <haoxu@linux.alibaba.com>
---
 fs/io_uring.c                 | 59 ++++++++++++++++++++++++++++++++-----------
 include/uapi/linux/io_uring.h |  3 ++-
 2 files changed, 46 insertions(+), 16 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 63ff70587d4f..1871fad48412 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -279,7 +279,8 @@ struct io_sq_data {
 	struct task_struct	*thread;
 	struct wait_queue_head	wait;
 
-	unsigned		sq_thread_idle;
+	u64			sq_thread_idle;
+	bool			idle_mode;
 	int			sq_cpu;
 	pid_t			task_pid;
 	pid_t			task_tgid;
@@ -362,7 +363,7 @@ struct io_ring_ctx {
 		unsigned		cached_sq_head;
 		unsigned		sq_entries;
 		unsigned		sq_mask;
-		unsigned		sq_thread_idle;
+		u64			sq_thread_idle;
 		unsigned		cached_sq_dropped;
 		unsigned		cached_cq_overflow;
 		unsigned long		sq_check_overflow;
@@ -6797,18 +6798,42 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
 static void io_sqd_update_thread_idle(struct io_sq_data *sqd)
 {
 	struct io_ring_ctx *ctx;
-	unsigned sq_thread_idle = 0;
+	u64 sq_thread_idle = 0;
 
-	list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
-		sq_thread_idle = max(sq_thread_idle, ctx->sq_thread_idle);
+	sqd->idle_mode = false;
+	list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
+		u64 tmp_idle = ctx->sq_thread_idle;
+
+		if (!(ctx->flags & IORING_SETUP_IDLE_NS))
+			tmp_idle = jiffies64_to_nsecs(tmp_idle);
+		else if (!sqd->idle_mode)
+			sqd->idle_mode = true;
+
+		if (sq_thread_idle < tmp_idle)
+			sq_thread_idle = tmp_idle;
+	}
+
+	if (!sqd->idle_mode)
+		sq_thread_idle = nsecs_to_jiffies64(sq_thread_idle);
 	sqd->sq_thread_idle = sq_thread_idle;
 }
 
+static inline u64 io_current_time(bool idle_mode)
+{
+	return idle_mode ? ktime_get_ns() : get_jiffies_64();
+}
+
+static inline bool io_time_after(bool idle_mode, u64 timeout)
+{
+	return idle_mode ? ktime_get_ns() > timeout :
+			time_after64(get_jiffies_64(), timeout);
+}
+
 static int io_sq_thread(void *data)
 {
 	struct io_sq_data *sqd = data;
 	struct io_ring_ctx *ctx;
-	unsigned long timeout = 0;
+	u64 timeout = 0;
 	char buf[TASK_COMM_LEN];
 	DEFINE_WAIT(wait);
 
@@ -6842,7 +6867,7 @@ static int io_sq_thread(void *data)
 				break;
 			io_run_task_work();
 			io_run_task_work_head(&sqd->park_task_work);
-			timeout = jiffies + sqd->sq_thread_idle;
+			timeout = io_current_time(sqd->idle_mode) + sqd->sq_thread_idle;
 			continue;
 		}
 		sqt_spin = false;
@@ -6859,11 +6884,11 @@ static int io_sq_thread(void *data)
 				sqt_spin = true;
 		}
 
-		if (sqt_spin || !time_after(jiffies, timeout)) {
+		if (sqt_spin || !io_time_after(sqd->idle_mode, timeout)) {
 			io_run_task_work();
 			cond_resched();
 			if (sqt_spin)
-				timeout = jiffies + sqd->sq_thread_idle;
+				timeout = io_current_time(sqd->idle_mode) + sqd->sq_thread_idle;
 			continue;
 		}
 
@@ -6896,7 +6921,7 @@ static int io_sq_thread(void *data)
 
 		finish_wait(&sqd->wait, &wait);
 		io_run_task_work_head(&sqd->park_task_work);
-		timeout = jiffies + sqd->sq_thread_idle;
+		timeout = io_current_time(sqd->idle_mode) + sqd->sq_thread_idle;
 	}
 
 	io_uring_cancel_sqpoll(sqd);
@@ -7940,7 +7965,7 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 	if (ctx->flags & IORING_SETUP_SQPOLL) {
 		struct task_struct *tsk;
 		struct io_sq_data *sqd;
-		bool attached;
+		bool attached, idle_ns;
 
 		sqd = io_get_sq_data(p, &attached);
 		if (IS_ERR(sqd)) {
@@ -7950,9 +7975,13 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 
 		ctx->sq_creds = get_current_cred();
 		ctx->sq_data = sqd;
-		ctx->sq_thread_idle = msecs_to_jiffies(p->sq_thread_idle);
+
+		idle_ns = ctx->flags & IORING_SETUP_IDLE_NS;
+		if (!idle_ns)
+			p->sq_thread_idle = nsecs_to_jiffies64(p->sq_thread_idle * NSEC_PER_MSEC);
+		ctx->sq_thread_idle = p->sq_thread_idle;
 		if (!ctx->sq_thread_idle)
-			ctx->sq_thread_idle = HZ;
+			ctx->sq_thread_idle = idle_ns ? NSEC_PER_SEC : HZ;
 
 		io_sq_thread_park(sqd);
 		list_add(&ctx->sqd_list, &sqd->ctx_list);
@@ -7990,7 +8019,7 @@ static int io_sq_offload_create(struct io_ring_ctx *ctx,
 		wake_up_new_task(tsk);
 		if (ret)
 			goto err;
-	} else if (p->flags & IORING_SETUP_SQ_AFF) {
+	} else if (p->flags & (IORING_SETUP_SQ_AFF | IORING_SETUP_IDLE_NS)) {
 		/* Can't have SQ_AFF without SQPOLL */
 		ret = -EINVAL;
 		goto err;
@@ -9680,7 +9709,7 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 	if (p.flags & ~(IORING_SETUP_IOPOLL | IORING_SETUP_SQPOLL |
 			IORING_SETUP_SQ_AFF | IORING_SETUP_CQSIZE |
 			IORING_SETUP_CLAMP | IORING_SETUP_ATTACH_WQ |
-			IORING_SETUP_R_DISABLED))
+			IORING_SETUP_R_DISABLED | IORING_SETUP_IDLE_NS))
 		return -EINVAL;
 
 	return  io_uring_create(entries, &p, params);
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index e1ae46683301..311532ff6ce3 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -98,6 +98,7 @@ enum {
 #define IORING_SETUP_CLAMP	(1U << 4)	/* clamp SQ/CQ ring sizes */
 #define IORING_SETUP_ATTACH_WQ	(1U << 5)	/* attach to existing wq */
 #define IORING_SETUP_R_DISABLED	(1U << 6)	/* start with ring disabled */
+#define IORING_SETUP_IDLE_NS	(1U << 7)	/* unit of thread_idle is nano second */
 
 enum {
 	IORING_OP_NOP,
@@ -259,7 +260,7 @@ struct io_uring_params {
 	__u32 cq_entries;
 	__u32 flags;
 	__u32 sq_thread_cpu;
-	__u32 sq_thread_idle;
+	__u64 sq_thread_idle;
 	__u32 features;
 	__u32 wq_fd;
 	__u32 resv[3];
-- 
1.8.3.1

