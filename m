Return-Path: <io-uring+bounces-91-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 056DF7EC24D
	for <lists+io-uring@lfdr.de>; Wed, 15 Nov 2023 13:32:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 244BB1C208D2
	for <lists+io-uring@lfdr.de>; Wed, 15 Nov 2023 12:32:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D7F48BA55;
	Wed, 15 Nov 2023 12:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="pim1CvP0"
X-Original-To: io-uring@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8690C1EB39
	for <io-uring@vger.kernel.org>; Wed, 15 Nov 2023 12:32:52 +0000 (UTC)
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23470C7
	for <io-uring@vger.kernel.org>; Wed, 15 Nov 2023 04:32:49 -0800 (PST)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20231115123247epoutp0496af0c40ba99ae155dc7b861ca48b2a4~Xy_ShmZzm0987409874epoutp04N
	for <io-uring@vger.kernel.org>; Wed, 15 Nov 2023 12:32:47 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20231115123247epoutp0496af0c40ba99ae155dc7b861ca48b2a4~Xy_ShmZzm0987409874epoutp04N
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1700051567;
	bh=dyApKvSFUgocVGjSlpND2ufFMIE3/xGQDXNQ1MeXyyY=;
	h=From:To:Cc:Subject:Date:References:From;
	b=pim1CvP01EJdhSD9bizN4pl18PL/E4WPz2tZXDfwDjG8/URmqbaD9tKC7ZChF6gKC
	 tihOcGJMcWKPRt7n2fnjejSB0ouR1VII2qds4k0oGOS50htInUnd+tAMKBArWcq4Ne
	 PdreMp7+a4CXQroPmkZmiD0LpHFFhsWy5HwJjmYs=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20231115123246epcas5p11d1934f4b14e2840ac0151a2e18becc9~Xy_SJpwVj3143231432epcas5p1x;
	Wed, 15 Nov 2023 12:32:46 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.181]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4SVjHK1Gj0z4x9Pw; Wed, 15 Nov
	2023 12:32:45 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	C3.C0.09634.C6AB4556; Wed, 15 Nov 2023 21:32:45 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20231115122627epcas5p37263cadafd5af20043fbb74e57fe5a4c~Xy4xJF6Od1338613386epcas5p3J;
	Wed, 15 Nov 2023 12:26:27 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20231115122627epsmtrp238bc636ff376e3d830657aca5255c12e~Xy4xIVCPk1027510275epsmtrp2C;
	Wed, 15 Nov 2023 12:26:27 +0000 (GMT)
X-AuditID: b6c32a49-159fd700000025a2-5b-6554ba6c2bdc
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	89.28.07368.3F8B4556; Wed, 15 Nov 2023 21:26:27 +0900 (KST)
Received: from AHRE124.. (unknown [109.105.118.124]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20231115122626epsmtip2dead156a71ac95e0b720a62e6de210f3~Xy4vud8Xq0811008110epsmtip2a;
	Wed, 15 Nov 2023 12:26:26 +0000 (GMT)
From: Xiaobing Li <xiaobing.li@samsung.com>
To: axboe@kernel.dk, asml.silence@gmail.com
Cc: linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
	kun.dou@samsung.com, peiwei.li@samsung.com, joshi.k@samsung.com,
	kundan.kumar@samsung.com, wenwen.chen@samsung.com, ruyi.zhang@samsung.com,
	cliang01.li@samsung.com, xue01.he@samsung.com, Xiaobing Li
	<xiaobing.li@samsung.com>
Subject: [PATCH v3] io_uring: Statistics of the true utilization of sq
 threads.
Date: Wed, 15 Nov 2023 20:18:39 +0800
Message-Id: <20231115121839.12556-1-xiaobing.li@samsung.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprFJsWRmVeSWpSXmKPExsWy7bCmhm7urpBUgzuNTBZzVm1jtFh9t5/N
	4vTfxywW71rPsVgc/f+WzeJX911Gi61fvrJaXN41h83i2V5Oiy+Hv7NbTN2yg8mio+Uyo0XX
	hVNsDrweO2fdZfe4fLbUo2/LKkaPz5vkAliism0yUhNTUosUUvOS81My89JtlbyD453jTc0M
	DHUNLS3MlRTyEnNTbZVcfAJ03TJzgK5TUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQXl9gqpRak
	5BSYFOgVJ+YWl+al6+WlllgZGhgYmQIVJmRnrPoYUrDHqGLV/yb2BsbVGl2MnBwSAiYSq871
	sXYxcnEICexmlDj/8wIjhPOJUWL2tw9QmW+MEps2PmCDaVm07RobRGIvo0Tjw24WCOclo8Sc
	LcfBqtgEtCWur+tiBbFFgOzXj6eCFTELLGGS2PrtMBNIQlggUGLtlU1ARRwcLAKqEn+/54OE
	eQVsJF6v+skCsU1eYv/Bs8wQcUGJkzOfgMWZgeLNW2czg8yUEPjKLtE04RM7RIOLxLf9fVCn
	Cku8Or4FKi4l8fndXqh4scSRnu+sEM0NjBLTb1+FKrKW+HdlDwvIQcwCmhLrd+lDhGUlpp5a
	xwSxmE+i9/cTJog4r8SOeTC2qsTqSw+hjpaWeN3wmwlkjISAh8SOaVkgYSGBWIlruw+xTmCU
	n4XknVlI3pmFsHgBI/MqRsnUguLc9NRi0wLDvNRyeMQm5+duYgQnUi3PHYx3H3zQO8TIxMF4
	iFGCg1lJhNdcLiRViDclsbIqtSg/vqg0J7X4EKMpMIgnMkuJJucDU3leSbyhiaWBiZmZmYml
	sZmhkjjv69a5KUIC6YklqdmpqQWpRTB9TBycUg1M6clvyk/dq4p3vjbp0iktxq41fRN7JNLm
	nfN8vbPR6/ftLcYeh590pv3J64os+zdxevezv/vE4zzqDfcw7dmczFBhu/3Sugy+E8f3aN3S
	Vuuct8DLKkTaVM2ifuXfk0+TGldNUMvZtNtvw+ND1+t1D7rOXl4nuLG7X+eeaA/jt8Sdv7bJ
	1v5hOxg9g52r5HZUC5Nf/pnDHDKdUff+u0vnOR1SMix+qhXMsjfkkIevi/1rtXnz3TVWpfRp
	lD3Lu7/L1cHuMfO3FIXYcwm6hlcMNHVvlfudkOQWOLtEPsX78kch7lTP2TWO24VYjQ5eP3ro
	UFv8SdbPFgd2Pc5Zy7mLj1clzrRC7Kj7Bes37wWUWIozEg21mIuKEwHVLqOWLQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsWy7bCSvO7nHSGpBmva1C3mrNrGaLH6bj+b
	xem/j1ks3rWeY7E4+v8tm8Wv7ruMFlu/fGW1uLxrDpvFs72cFl8Of2e3mLplB5NFR8tlRouu
	C6fYHHg9ds66y+5x+WypR9+WVYwenzfJBbBEcdmkpOZklqUW6dslcGWs+hhSsMeoYtX/JvYG
	xtUaXYycHBICJhKLtl1j62Lk4hAS2M0o8bH1F2MXIwdQQlriz59yiBphiZX/nrND1DxnlNj+
	5C0jSIJNQFvi+rouVpB6EQFdica7CiA1zAIbmCT2P53HClIjLOAvMWHSIyaQGhYBVYm/3/NB
	wrwCNhKvV/1kgZgvL7H/4FlmiLigxMmZT8DizEDx5q2zmScw8s1CkpqFJLWAkWkVo2RqQXFu
	em6yYYFhXmq5XnFibnFpXrpecn7uJkZwOGtp7GC8N/+f3iFGJg7GQ4wSHMxKIrzmciGpQrwp
	iZVVqUX58UWlOanFhxilOViUxHkNZ8xOERJITyxJzU5NLUgtgskycXBKNTAdLimb6q5teKFs
	A9O9nBNZZ5fNPBeyVdxn2nMZQdm+K6yCc+N65gSee/HmrJF96Zy1+wKfvF++yEFji8CGZIbq
	pdom0itZolK+5c6e3Ni4kGfKB/42uWrtsyszv/+2ZvTWnn7qzzyJ+33Ly7k9I83DF/LaqQTd
	z5juKrLz5H3PRU+sH+1TcrqY7LuILd2xbOEXt6tKu6WrU9+zxGR2ZB89/KRH/+My68QzLeVN
	D0XMM1cKTrqnkOPS9NX9A8eJObUBSz/qXl639Fvm4R9R6QdPNf5c/ez3Wm7zu9wB/2NfX5/5
	qU0xTfERU7dJtreCzvJgyUMX1XqcHLQ6P/74NpHDb7/75+RbefP+uF/LXy2ixFKckWioxVxU
	nAgAbSfh39YCAAA=
X-CMS-MailID: 20231115122627epcas5p37263cadafd5af20043fbb74e57fe5a4c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20231115122627epcas5p37263cadafd5af20043fbb74e57fe5a4c
References: <CGME20231115122627epcas5p37263cadafd5af20043fbb74e57fe5a4c@epcas5p3.samsung.com>

v3:
1.Since the sq thread has a while(1) structure, during this process,
  there may be a lot of time that is not processing IO but does not
exceed the timeout period, therefore, the sqpoll thread will keep
running and will keep occupying the CPU. Obviously, the CPU is wasted at
this time;Our goal is to count the part of the time that the sqpoll
thread actually processes IO, so as to reflect the part of the CPU it
uses to process IO, which can be used to help improve the actual
utilization of the CPU in the future.

2."work_time" in the code represents the sum of the jiffies count of the
  sq thread actually processing IO, that is, how many milliseconds it
actually takes to process IO. "total_time" represents the total time
that the sq thread has elapsed from the beginning of the loop to the
current time point, that is, how many milliseconds it has spent in
total.
The output "SqBusy" represents the percentage of time utilization that
the sq thread actually uses to process IO.

3.The task_pid value in the io_sq_data structure should be assigned
  after the sq thread is created, otherwise the pid of its parent
process will be recorded.

4.After many tests, we do not need to obtain ctx->uring_lock in advance
  when obtaining ctx->sq_data. We can avoid null pointer references by
judging that ctx is not null.

Signed-off-by: Xiaobing Li <xiaobing.li@samsung.com>

The test results are as follows:
Every 0.5s: cat /proc/281126/fdinfo/6 | grep Sq
SqMask: 0x3
SqHead: 1168417
SqTail: 1168418
CachedSqHead:   1168418
SqThread:       281126
SqThreadCpu:    55
SqBusy: 96%
---
 io_uring/fdinfo.c | 31 ++++++++++++++++---------------
 io_uring/sqpoll.c | 20 ++++++++++++++++----
 io_uring/sqpoll.h |  2 ++
 3 files changed, 34 insertions(+), 19 deletions(-)

diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index f04a43044d91..b9e2e339140d 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -64,6 +64,7 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
 	unsigned int sq_shift = 0;
 	unsigned int sq_entries, cq_entries;
 	int sq_pid = -1, sq_cpu = -1;
+	int sq_busy = 0;
 	bool has_lock;
 	unsigned int i;
 
@@ -134,6 +135,21 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
 		seq_printf(m, "\n");
 	}
 
+	if (ctx && (ctx->flags & IORING_SETUP_SQPOLL)) {
+		struct io_sq_data *sq = ctx->sq_data;
+
+		if (sq && sq->total_time != 0)
+			sq_busy = (int)(sq->work_time * 100 / sq->total_time);
+
+		sq_pid = sq->task_pid;
+		sq_cpu = sq->sq_cpu;
+	}
+
+	seq_printf(m, "SqThread:\t%d\n", sq_pid);
+	seq_printf(m, "SqThreadCpu:\t%d\n", sq_cpu);
+	seq_printf(m, "SqBusy:\t%d%%\n", sq_busy);
+	seq_printf(m, "UserFiles:\t%u\n", ctx->nr_user_files);
+
 	/*
 	 * Avoid ABBA deadlock between the seq lock and the io_uring mutex,
 	 * since fdinfo case grabs it in the opposite direction of normal use
@@ -142,21 +158,6 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
 	 */
 	has_lock = mutex_trylock(&ctx->uring_lock);
 
-	if (has_lock && (ctx->flags & IORING_SETUP_SQPOLL)) {
-		struct io_sq_data *sq = ctx->sq_data;
-
-		if (mutex_trylock(&sq->lock)) {
-			if (sq->thread) {
-				sq_pid = task_pid_nr(sq->thread);
-				sq_cpu = task_cpu(sq->thread);
-			}
-			mutex_unlock(&sq->lock);
-		}
-	}
-
-	seq_printf(m, "SqThread:\t%d\n", sq_pid);
-	seq_printf(m, "SqThreadCpu:\t%d\n", sq_cpu);
-	seq_printf(m, "UserFiles:\t%u\n", ctx->nr_user_files);
 	for (i = 0; has_lock && i < ctx->nr_user_files; i++) {
 		struct file *f = io_file_from_index(&ctx->file_table, i);
 
diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index bd6c2c7959a5..dc093adc1ce5 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -224,17 +224,21 @@ static int io_sq_thread(void *data)
 	struct io_ring_ctx *ctx;
 	unsigned long timeout = 0;
 	char buf[TASK_COMM_LEN];
+	unsigned long sq_start, sq_work_begin, sq_work_end;
 	DEFINE_WAIT(wait);
 
 	snprintf(buf, sizeof(buf), "iou-sqp-%d", sqd->task_pid);
 	set_task_comm(current, buf);
 
-	if (sqd->sq_cpu != -1)
+	if (sqd->sq_cpu != -1) {
 		set_cpus_allowed_ptr(current, cpumask_of(sqd->sq_cpu));
-	else
+	} else {
 		set_cpus_allowed_ptr(current, cpu_online_mask);
+		sqd->sq_cpu = raw_smp_processor_id();
+	}
 
 	mutex_lock(&sqd->lock);
+	sq_start = jiffies;
 	while (1) {
 		bool cap_entries, sqt_spin = false;
 
@@ -245,6 +249,7 @@ static int io_sq_thread(void *data)
 		}
 
 		cap_entries = !list_is_singular(&sqd->ctx_list);
+		sq_work_begin = jiffies;
 		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
 			int ret = __io_sq_thread(ctx, cap_entries);
 
@@ -254,6 +259,11 @@ static int io_sq_thread(void *data)
 		if (io_run_task_work())
 			sqt_spin = true;
 
+		sq_work_end = jiffies;
+		sqd->total_time = sq_work_end - sq_start;
+		if (sqt_spin == true)
+			sqd->work_time += sq_work_end - sq_work_begin;
+
 		if (sqt_spin || !time_after(jiffies, timeout)) {
 			if (sqt_spin)
 				timeout = jiffies + sqd->sq_thread_idle;
@@ -261,6 +271,7 @@ static int io_sq_thread(void *data)
 				mutex_unlock(&sqd->lock);
 				cond_resched();
 				mutex_lock(&sqd->lock);
+				sqd->sq_cpu = raw_smp_processor_id();
 			}
 			continue;
 		}
@@ -294,6 +305,7 @@ static int io_sq_thread(void *data)
 				mutex_unlock(&sqd->lock);
 				schedule();
 				mutex_lock(&sqd->lock);
+				sqd->sq_cpu = raw_smp_processor_id();
 			}
 			list_for_each_entry(ctx, &sqd->ctx_list, sqd_list)
 				atomic_andnot(IORING_SQ_NEED_WAKEUP,
@@ -395,14 +407,14 @@ __cold int io_sq_offload_create(struct io_ring_ctx *ctx,
 			sqd->sq_cpu = -1;
 		}
 
-		sqd->task_pid = current->pid;
-		sqd->task_tgid = current->tgid;
+		sqd->task_tgid = current->pid;
 		tsk = create_io_thread(io_sq_thread, sqd, NUMA_NO_NODE);
 		if (IS_ERR(tsk)) {
 			ret = PTR_ERR(tsk);
 			goto err_sqpoll;
 		}
 
+		sqd->task_pid = task_pid_nr(tsk);
 		sqd->thread = tsk;
 		ret = io_uring_alloc_task_context(tsk, ctx);
 		wake_up_new_task(tsk);
diff --git a/io_uring/sqpoll.h b/io_uring/sqpoll.h
index 8df37e8c9149..fd6fa9587843 100644
--- a/io_uring/sqpoll.h
+++ b/io_uring/sqpoll.h
@@ -16,6 +16,8 @@ struct io_sq_data {
 	pid_t			task_pid;
 	pid_t			task_tgid;
 
+	unsigned long       work_time;
+	unsigned long       total_time;
 	unsigned long		state;
 	struct completion	exited;
 };
-- 
2.34.1


