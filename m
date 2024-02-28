Return-Path: <io-uring+bounces-793-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 677C286AB01
	for <lists+io-uring@lfdr.de>; Wed, 28 Feb 2024 10:14:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1E74E282439
	for <lists+io-uring@lfdr.de>; Wed, 28 Feb 2024 09:14:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F16812E635;
	Wed, 28 Feb 2024 09:13:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="jxo1QgWl"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8723A2DF9D
	for <io-uring@vger.kernel.org>; Wed, 28 Feb 2024 09:13:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709111636; cv=none; b=gewz4e64KhGkGbI0Z51b0FvytwhJtUY5yj0tYwfF8RlIvkf74a0rHXKbqIZnsMrtrCkMfknwZB7To/L/3ceqmT2KLZZF2+FjY+I1KHMgw7oCmSkcziFvHnaoWMXKcRB8fA94EGB4Uu5aEWFsqmQlwgrFEfTp7DsDyojOTFkgDLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709111636; c=relaxed/simple;
	bh=LH5p+6ikC4F1sO4HqmTw5nBqUknxSYb/0ajXxACar8I=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=LDlc2yzHsaecABgvl49cw3KlxwA3yw4kM9wE6iGwEtrwkx8hHbxXQ0esFnLNHeSZrOIqrv24qsXaTpEWJVsU4wRuUu9OdNw6G7m49DV/MmNgRocm1iI0M3RKj+oR8/EQ/jR8cTneXqlZQRP8RciTzAj3M1NKLTTK4LHHDG5QyCg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=jxo1QgWl; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20240228091352epoutp039565f2536b1ff789d7ce965a025847c8~3_-l7F1BR2251022510epoutp03e
	for <io-uring@vger.kernel.org>; Wed, 28 Feb 2024 09:13:52 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20240228091352epoutp039565f2536b1ff789d7ce965a025847c8~3_-l7F1BR2251022510epoutp03e
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1709111632;
	bh=mFL+rRB6+lV65ANV28mMev1SmKf68n2ZlXKP3YKM/jQ=;
	h=From:To:Cc:Subject:Date:References:From;
	b=jxo1QgWlQ18T6BmtwSzBi4fzqwtKZB5n0CHcnYS6t70FY0PbMArFY8b4rlJ8VThKv
	 J0xDeQt4/X35OrfdZAAiI5lad0D8qlpC4p3PIMwkIVJHKlQATeZ62xjnYcTWZmK8oR
	 XoTTCWN+dQjKelQP3lgQ2IM5YwqRIysblZkcxTXU=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20240228091352epcas5p39a0caada4152f3a50c164c50d4b8a11f~3_-leC-Tr2858128581epcas5p3h;
	Wed, 28 Feb 2024 09:13:52 +0000 (GMT)
Received: from epsmgec5p1new.samsung.com (unknown [182.195.38.182]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4Tl7vL3HVLz4x9Pp; Wed, 28 Feb
	2024 09:13:50 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmgec5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	D2.5B.08567.E49FED56; Wed, 28 Feb 2024 18:13:50 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20240228091258epcas5p2a1ca7f77ab84ce3041b08d63c411412f~3__zUNTWC0634306343epcas5p2f;
	Wed, 28 Feb 2024 09:12:58 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240228091258epsmtrp287d4b791b85989ebec7524ccb66c4ddf~3__zTXLr51452314523epsmtrp2d;
	Wed, 28 Feb 2024 09:12:58 +0000 (GMT)
X-AuditID: b6c32a44-617fd70000002177-2f-65def94e8419
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	61.9B.07368.919FED56; Wed, 28 Feb 2024 18:12:58 +0900 (KST)
Received: from testpc118124.samsungds.net (unknown [109.105.118.124]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240228091256epsmtip1f1777be21536afd7cd780727d5ed3770~3__xwCDFF0400604006epsmtip1Z;
	Wed, 28 Feb 2024 09:12:56 +0000 (GMT)
From: Xiaobing Li <xiaobing.li@samsung.com>
To: axboe@kernel.dk, asml.silence@gmail.com
Cc: linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
	kun.dou@samsung.com, peiwei.li@samsung.com, joshi.k@samsung.com,
	kundan.kumar@samsung.com, wenwen.chen@samsung.com, ruyi.zhang@samsung.com,
	cliang01.li@samsung.com, xue01.he@samsung.com, Xiaobing Li
	<xiaobing.li@samsung.com>
Subject: [PATCH v10] io_uring: Statistics of the true utilization of sq
 threads.
Date: Wed, 28 Feb 2024 17:12:51 +0800
Message-Id: <20240228091251.543383-1-xiaobing.li@samsung.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPJsWRmVeSWpSXmKPExsWy7bCmlq7fz3upBltnilvMWbWN0WL13X42
	i9N/H7NYvGs9x2Jx9P9bNotf3XcZLbZ++cpqcXnXHDaLZ3s5Lb4c/s5ucXbCB1aLqVt2MFl0
	tFxmtOi6cIrNgc9j56y77B6Xz5Z69G1ZxejxeZNcAEtUtk1GamJKapFCal5yfkpmXrqtkndw
	vHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0IlKCmWJOaVAoYDE4mIlfTubovzSklSFjPzi
	Elul1IKUnAKTAr3ixNzi0rx0vbzUEitDAwMjU6DChOyMG+9Xshc81Kt4sXMJSwPjC9UuRk4O
	CQETie4101i7GLk4hAR2M0r8XfeNCcL5xCgxsfU4M4TzjVHifNMRRpiWBV0Xoar2MkpsPdQA
	VfWLUWLdtyYWkCo2AW2J6+u6WEFsESD79eOpLCBFzAJLmCS2fjvMBJIQFgiSWDG9G6ibg4NF
	QFXi6HVOEJNXwFbi4D4niGXyEvsPnmUGsXkFBCVOznwCNp4ZKN68dTbYXgmBiRwSt3ofsIL0
	Sgi4SLx5nw/RKyzx6vgWdghbSuLzu71sEHaxxJGe76wQvQ2MEtNvX4Uqspb4d2UPC8gcZgFN
	ifW79CHCshJTT61jgtjLJ9H7+wkTRJxXYsc8GFtVYvWlhywQtrTE64bfUHEPiWdPboEDTkgg
	VmLVtW1sExjlZyF5ZxaSd2YhbF7AyLyKUTK1oDg3PTXZtMAwL7UcHrHJ+bmbGMEpVctlB+ON
	+f/0DjEycTAeYpTgYFYS4ZURvJsqxJuSWFmVWpQfX1Sak1p8iNEUGMITmaVEk/OBST2vJN7Q
	xNLAxMzMzMTS2MxQSZz3devcFCGB9MSS1OzU1ILUIpg+Jg5OqQYm/t2mwT+UOsQZ2KoZTm9q
	jPr3MTPgyEX9ZVf1d/Cc3TXx89MXTcZnnbJYvDe1vva4MVv+9L9ef4Ge9U3Kf7sNF730cI56
	qvf3WWuMDlvVKvfvF57stXkTbPuHa0fvTO69i2UPBJ87vkA1ocz5p9jdKV3VIVFTuDmP9q61
	eijE9GqScsmeL+VTH3QE/Jt6Tmz/uXC3yRW1f1V8JY9c6QrYd2Xh9fZPx1dESdnFHUoP6LRp
	2xjRfi6iev2ROS9276/Meveb675RrnJg87GqUtGWGa9/GVzjPblXatu290lLX3/8/Pi1/ven
	mYq7Nv36rGPlHfj7Ur+C+aU7h74YmUdwWxt4Rkasem99aPIbtkLhqUosxRmJhlrMRcWJAMeD
	vd4yBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrLLMWRmVeSWpSXmKPExsWy7bCSnK7Uz3upBpuamS3mrNrGaLH6bj+b
	xem/j1ks3rWeY7E4+v8tm8Wv7ruMFlu/fGW1uLxrDpvFs72cFl8Of2e3ODvhA6vF1C07mCw6
	Wi4zWnRdOMXmwOexc9Zddo/LZ0s9+rasYvT4vEkugCWKyyYlNSezLLVI3y6BK+PG+5XsBQ/1
	Kl7sXMLSwPhCtYuRk0NCwERiQddFpi5GLg4hgd2MEt19U1i6GDmAEtISf/6UQ9QIS6z895wd
	xBYS+MEocX27E4jNJqAtcX1dFytIuYiArkTjXQWQMcwCG5gk9j+dxwpSIywQIHHh73s2kBoW
	AVWJo9c5QUxeAVuJg/ucIKbLS+w/eJYZxOYVEJQ4OfMJ2AHMAuoS6+cJgYSZgUqat85mnsDI
	PwtJ1SyEqllIqhYwMq9ilEwtKM5Nz002LDDMSy3XK07MLS7NS9dLzs/dxAiOAS2NHYz35v/T
	O8TIxMF4iFGCg1lJhFdG8G6qEG9KYmVValF+fFFpTmrxIUZpDhYlcV7DGbNThATSE0tSs1NT
	C1KLYLJMHJxSDUycp/dsyAoV6K791HCE/XfIkulRRi/uqH2f3ma08yqvoUKv6xSljz7sG14V
	+n1aFfOyNmlpc9gKzSj35piNR+du5P51I7H3cYj8U9nec+7HPjuun3tm5YfFR0WO/vjw8dOO
	/IQN93TLD0hsuqnSfnDb7T8PfB2Y1CMuR9cu3zdFPP8Bz9Yju1+4b3ZxvJupprqoe1nTaxP/
	eEHF1IlHg93tb+U1vQpzXRu/n6FyhYSmC5vA1++TGyqrDPvXy06/05NjYPvBt8Do8Zzy+Ey9
	f6cUHmTn/2J/nPPui3bWHf6Cl74/qsJqI69Fz9gp/L3szfZ7hWm+k/qTrTdK+q22YOJw0nxq
	dozdapHHceUt6QZKLMUZiYZazEXFiQDPS16i8AIAAA==
X-CMS-MailID: 20240228091258epcas5p2a1ca7f77ab84ce3041b08d63c411412f
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240228091258epcas5p2a1ca7f77ab84ce3041b08d63c411412f
References: <CGME20240228091258epcas5p2a1ca7f77ab84ce3041b08d63c411412f@epcas5p2.samsung.com>

Count the running time and actual IO processing time of the sqpoll
thread, and output the statistical data to fdinfo.

Variable description:
"work_time" in the code represents the sum of the jiffies of the sq
thread actually processing IO, that is, how many milliseconds it
actually takes to process IO. "total_time" represents the total time
that the sq thread has elapsed from the beginning of the loop to the
current time point, that is, how many milliseconds it has spent in
total.

The test tool is fio, and its parameters are as follows:
[global]
ioengine=io_uring
direct=1
group_reporting
bs=128k
norandommap=1
randrepeat=0
refill_buffers
ramp_time=30s
time_based
runtime=1m
clocksource=clock_gettime
overwrite=1
log_avg_msec=1000
numjobs=1

[disk0]
filename=/dev/nvme0n1
rw=read
iodepth=16
hipri
sqthread_poll=1

The test results are as follows:
Every 2.0s: cat /proc/9230/fdinfo/6 | grep -E Sq
SqMask: 0x3
SqHead: 3197153
SqTail: 3197153
CachedSqHead:   3197153
SqThread:       9231
SqThreadCpu:    11
SqTotalTime:    18099614
SqWorkTime:     16748316

The test results corresponding to different iodepths are as follows:
|-----------|-------|-------|-------|------|-------|
|   iodepth |   1   |   4   |   8   |  16  |  64   |
|-----------|-------|-------|-------|------|-------|
|utilization| 2.9%  | 8.8%  | 10.9% | 92.9%| 84.4% |
|-----------|-------|-------|-------|------|-------|
|    idle   | 97.1% | 91.2% | 89.1% | 7.1% | 15.6% |
|-----------|-------|-------|-------|------|-------|

Signed-off-by: Xiaobing Li <xiaobing.li@samsung.com>

---

changes：
v10:
 - Resubmission based on for - 6.9 / io_uring

v9:
 - Modified the encoding format

v8:
 - Get the work time of the sqpoll thread through getrusage

v7:
 - Get the total time of the sqpoll thread through getrusage
 - The working time of the sqpoll thread is obtained through ktime_get()

v6:
 - Replace the percentages in the fdinfo output with the actual running
time and the time actually processing IO

v5：
 - list the changes in each iteration.

v4：
 - Resubmit the patch based on removing sq->lock

v3：
 - output actual working time as a percentage of total time
 - detailed description of the meaning of each variable
 - added test results

v2：
 - output the total statistical time and work time to fdinfo

v1：
 - initial version
 - Statistics of total time and work time

 io_uring/fdinfo.c |  7 +++++++
 io_uring/sqpoll.c | 17 ++++++++++++++++-
 io_uring/sqpoll.h |  1 +
 3 files changed, 24 insertions(+), 1 deletion(-)

diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index 976e9500f651..37afc5bac279 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -55,6 +55,7 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
 	struct io_ring_ctx *ctx = f->private_data;
 	struct io_overflow_cqe *ocqe;
 	struct io_rings *r = ctx->rings;
+	struct rusage sq_usage;
 	unsigned int sq_mask = ctx->sq_entries - 1, cq_mask = ctx->cq_entries - 1;
 	unsigned int sq_head = READ_ONCE(r->sq.head);
 	unsigned int sq_tail = READ_ONCE(r->sq.tail);
@@ -64,6 +65,7 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
 	unsigned int sq_shift = 0;
 	unsigned int sq_entries, cq_entries;
 	int sq_pid = -1, sq_cpu = -1;
+	u64 sq_total_time = 0, sq_work_time = 0;
 	bool has_lock;
 	unsigned int i;
 
@@ -147,10 +149,15 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
 
 		sq_pid = sq->task_pid;
 		sq_cpu = sq->sq_cpu;
+		getrusage(sq->thread, RUSAGE_SELF, &sq_usage);
+		sq_total_time = sq_usage.ru_stime.tv_sec * 1000000 + sq_usage.ru_stime.tv_usec;
+		sq_work_time = sq->work_time;
 	}
 
 	seq_printf(m, "SqThread:\t%d\n", sq_pid);
 	seq_printf(m, "SqThreadCpu:\t%d\n", sq_cpu);
+	seq_printf(m, "SqTotalTime:\t%llu\n", sq_total_time);
+	seq_printf(m, "SqWorkTime:\t%llu\n", sq_work_time);
 	seq_printf(m, "UserFiles:\t%u\n", ctx->nr_user_files);
 	for (i = 0; has_lock && i < ctx->nr_user_files; i++) {
 		struct file *f = io_file_from_index(&ctx->file_table, i);
diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 82672eaaee81..363052b4ea76 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -253,11 +253,23 @@ static bool io_sq_tw_pending(struct llist_node *retry_list)
 	return retry_list || !llist_empty(&tctx->task_list);
 }
 
+static void io_sq_update_worktime(struct io_sq_data *sqd, struct rusage *start)
+{
+	struct rusage end;
+
+	getrusage(current, RUSAGE_SELF, &end);
+	end.ru_stime.tv_sec -= start->ru_stime.tv_sec;
+	end.ru_stime.tv_usec -= start->ru_stime.tv_usec;
+
+	sqd->work_time += end.ru_stime.tv_usec + end.ru_stime.tv_sec * 1000000;
+}
+
 static int io_sq_thread(void *data)
 {
 	struct llist_node *retry_list = NULL;
 	struct io_sq_data *sqd = data;
 	struct io_ring_ctx *ctx;
+	struct rusage start;
 	unsigned long timeout = 0;
 	char buf[TASK_COMM_LEN];
 	DEFINE_WAIT(wait);
@@ -286,6 +298,7 @@ static int io_sq_thread(void *data)
 		}
 
 		cap_entries = !list_is_singular(&sqd->ctx_list);
+		getrusage(current, RUSAGE_SELF, &start);
 		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
 			int ret = __io_sq_thread(ctx, cap_entries);
 
@@ -296,8 +309,10 @@ static int io_sq_thread(void *data)
 			sqt_spin = true;
 
 		if (sqt_spin || !time_after(jiffies, timeout)) {
-			if (sqt_spin)
+			if (sqt_spin) {
+				io_sq_update_worktime(sqd, &start);
 				timeout = jiffies + sqd->sq_thread_idle;
+			}
 			if (unlikely(need_resched())) {
 				mutex_unlock(&sqd->lock);
 				cond_resched();
diff --git a/io_uring/sqpoll.h b/io_uring/sqpoll.h
index 8df37e8c9149..4171666b1cf4 100644
--- a/io_uring/sqpoll.h
+++ b/io_uring/sqpoll.h
@@ -16,6 +16,7 @@ struct io_sq_data {
 	pid_t			task_pid;
 	pid_t			task_tgid;
 
+	u64			work_time;
 	unsigned long		state;
 	struct completion	exited;
 };
-- 
2.34.1


