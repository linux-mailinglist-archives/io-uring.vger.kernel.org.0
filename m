Return-Path: <io-uring+bounces-624-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D2403859CBC
	for <lists+io-uring@lfdr.de>; Mon, 19 Feb 2024 08:22:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 027C61C20C54
	for <lists+io-uring@lfdr.de>; Mon, 19 Feb 2024 07:22:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 054E620B28;
	Mon, 19 Feb 2024 07:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="DqDnKtzh"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8709C20B0C
	for <io-uring@vger.kernel.org>; Mon, 19 Feb 2024 07:22:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708327337; cv=none; b=ZvVktqk9ChSpu8Tf7Vj/m5UQINdtbSQfOIKui86YHnKkfp2Ox+3lR2BXbg1Sw0slkd2+n4mLhKP0mR6+IpDvRNEXGuc0vsx1qDyzJyMIsllOdtwSCVyxoxlJIYS23/GxdKkzL1FjHn9Gf/M92mzSyKlNo7iLzqKe8zL3McojIw0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708327337; c=relaxed/simple;
	bh=hM2078OiTib/x95otys9s1/rI9Z/Fl8gvbHNop8S0T8=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=aPgdkKOOpQkDQSOTx7BZI59fB/lhd4Lf05tq4KJG/DlbbzZ8/hkaeUr9/wqETg4xxJwI4UqGNKsffPPQbGSpZ40HwNel79LDrcMccWeB4rYlUgcwHwpTsTc8kabX40NlRh4cKLSCKcUqLMR8qCCSx+hcmqoFTs5t7eSPnyBYyQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=DqDnKtzh; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240219072207epoutp04f6323b5c2a777cca8efbfae0ccbb660b~1MqdKHu0t1307613076epoutp04E
	for <io-uring@vger.kernel.org>; Mon, 19 Feb 2024 07:22:07 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240219072207epoutp04f6323b5c2a777cca8efbfae0ccbb660b~1MqdKHu0t1307613076epoutp04E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1708327327;
	bh=Iv95Eb6L/ARkoTmdNirj17GtPhmXPpDoLjdbyBvtWjI=;
	h=From:To:Cc:Subject:Date:References:From;
	b=DqDnKtzhNmDYk+MdZ3KdN3+KBR3nUOrhjT5JYdRkofPs4fIbuwjVq96+SblB60hbA
	 D9AAr5fYR7e0+r+6qTgFccjuJ2zXbNtOEF4ES1PKNTW2OBZQ4aEf887VKgUiJVZ7tx
	 FFbP1LFp6Hacm22IXcnx/KiSNlakYzrDaiCYhL7w=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20240219072207epcas5p122a869102f255af25574b3742b377ad8~1MqcwUZoe2172121721epcas5p1S;
	Mon, 19 Feb 2024 07:22:07 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.177]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4TdYrY0q5Tz4x9QN; Mon, 19 Feb
	2024 07:22:05 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	2A.80.10009.C9103D56; Mon, 19 Feb 2024 16:22:05 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20240219064250epcas5p10e883fb39a12909946028672c0b5d6f3~1MIJoa6ct1439314393epcas5p1b;
	Mon, 19 Feb 2024 06:42:50 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240219064250epsmtrp2995ae29545c2e7c79c2693a1094b8026~1MIJmd1mh0459004590epsmtrp2O;
	Mon, 19 Feb 2024 06:42:50 +0000 (GMT)
X-AuditID: b6c32a4a-261fd70000002719-a6-65d3019c6e18
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	82.BE.07368.A68F2D56; Mon, 19 Feb 2024 15:42:50 +0900 (KST)
Received: from testpc118124.samsungds.net (unknown [109.105.118.124]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240219064248epsmtip187df19d852c641985512f01147afd3b6~1MIHgHIvN2069320693epsmtip1P;
	Mon, 19 Feb 2024 06:42:47 +0000 (GMT)
From: Xiaobing Li <xiaobing.li@samsung.com>
To: axboe@kernel.dk, asml.silence@gmail.com
Cc: linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
	kun.dou@samsung.com, peiwei.li@samsung.com, joshi.k@samsung.com,
	kundan.kumar@samsung.com, wenwen.chen@samsung.com, ruyi.zhang@samsung.com,
	cliang01.li@samsung.com, xue01.he@samsung.com, Xiaobing Li
	<xiaobing.li@samsung.com>
Subject: [PATCH v9] io_uring: Statistics of the true utilization of sq
 threads.
Date: Mon, 19 Feb 2024 14:42:41 +0800
Message-Id: <20240219064241.20531-1-xiaobing.li@samsung.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPJsWRmVeSWpSXmKPExsWy7bCmlu5cxsupBnsmMVvMWbWN0WL13X42
	i9N/H7NYvGs9x2Jx9P9bNotf3XcZLbZ++cpqcXnXHDaLZ3s5Lb4c/s5ucXbCB1aLqVt2MFl0
	tFxmtOi6cIrNgc9j56y77B6Xz5Z69G1ZxejxeZNcAEtUtk1GamJKapFCal5yfkpmXrqtkndw
	vHO8qZmBoa6hpYW5kkJeYm6qrZKLT4CuW2YO0IlKCmWJOaVAoYDE4mIlfTubovzSklSFjPzi
	Elul1IKUnAKTAr3ixNzi0rx0vbzUEitDAwMjU6DChOyMVzNmsxdM1Ku4feE+YwPjCtUuRk4O
	CQETiT2H+llAbCGB3YwS3Z9rIOxPjBLb7qlC2N8YJZbcZoGpX//9E2sXIxdQfC+jxOs5s1kg
	nF+MEifXnWIHqWIT0Ja4vq6LFcQWAbJfP54KVsQssIRJYuu3w0wgCWGBQInmxnVgNouAqsSf
	pndsIDavgI3E85kvmSDWyUvsP3iWGSIuKHFy5hOwM5iB4s1bZzODDJUQ6OWQmLl4FxtEg4vE
	hw1fGSFsYYlXx7ewQ9hSEp/f7YWqKZY40vOdFaK5gVFi+u2rUEXWEv+u7AHawAG0QVNi/S59
	iLCsxNRTEIcyC/BJ9P5+AnUcr8SOeTC2qsTqSw+hYSQt8brhN1TcQ2LS1s1skHCMlTi65xLT
	BEb5WUj+mYXkn1kImxcwMq9ilEwtKM5NTy02LTDKSy2HR2xyfu4mRnBK1fLawfjwwQe9Q4xM
	HIyHGCU4mJVEeN2bLqQK8aYkVlalFuXHF5XmpBYfYjQFBvJEZinR5HxgUs8riTc0sTQwMTMz
	M7E0NjNUEud93To3RUggPbEkNTs1tSC1CKaPiYNTqoFppcNrlidSrQdVHjOX8N7xWKLU49xU
	qrz6y+wOj8+2py+U9SyryZIod5hzXskoK559+qeeeVxNvN/7NAJ21jnJ+PIZavxI6ll/9k6T
	V9ziWK1Tt37f2N7C1fzrynehTftvfru05PeTiaZHpf3sS/QqJnFz9c2z0ik8/fLHVsbwzRL8
	1dkHXPhPKAdwR3HOdFj9tPTeQn6JT7OvFfnIx92vL1XzfSmVa5IWdUlr7q5IuQpjw+9PJ+zY
	aNebKq3bevj+sV0BGfmFyYulH1fFb7L8V7jf9uS1J9V8W7WFUnmcZp6KfRNWPa9bZnV0r/LZ
	8B+vTz/tFn29+JAF84q16kcOt/6bNeGCrJv6ntgv2+8psRRnJBpqMRcVJwIAK0UG3TIEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrALMWRmVeSWpSXmKPExsWy7bCSnG7Wj0upBsu+c1rMWbWN0WL13X42
	i9N/H7NYvGs9x2Jx9P9bNotf3XcZLbZ++cpqcXnXHDaLZ3s5Lb4c/s5ucXbCB1aLqVt2MFl0
	tFxmtOi6cIrNgc9j56y77B6Xz5Z69G1ZxejxeZNcAEsUl01Kak5mWWqRvl0CV8arGbPZCybq
	Vdy+cJ+xgXGFahcjJ4eEgInE+u+fWLsYuTiEBHYzSvxsWc3SxcgBlJCW+POnHKJGWGLlv+fs
	EDU/GCUWtm9iBEmwCWhLXF/XxQpSLyKgK9F4VwGkhllgA5PE/qfzWEFqhAX8JTpndLGA2CwC
	qhJ/mt6xgdi8AjYSz2e+ZIJYIC+x/+BZZoi4oMTJmU/AbmAWUJdYP08IJMwMVNK8dTbzBEb+
	WUiqZiFUzUJStYCReRWjZGpBcW56brJhgWFearlecWJucWleul5yfu4mRnAkaGnsYLw3/5/e
	IUYmDsZDjBIczEoivO5NF1KFeFMSK6tSi/Lji0pzUosPMUpzsCiJ8xrOmJ0iJJCeWJKanZpa
	kFoEk2Xi4JRqYHrYc9xguz5j4x3jO+Frbmbf33TrzyTfiphfRydUunZkT7/PdG1bjeDj5uen
	qtTZn9e+Lp7X9dzJV2lWf+zRZXzu6/PlxR7MKvpZb/2ou3nCqjcf3DvO7SxfsFnq08xFvk9N
	+fltz0VvWT0/nd9n90LWtjIOrS2Gj6sqlrcEOniYpgWca1ap1UqrCbaaefbI7+kOOqXnZvB6
	N3PJql/l6rTPshd5ERauc/gml1Da//kH+Tarh7g31E/KvMM3pSLBUcnlF79gxdcCqfKgcusd
	r79/lVrzXfQIa7uUzKO1wtPNFuWopH+ue3YwzfsVz9SFUhLb5m5a+znXymOZ5cFnGzV2y08w
	vdb3qu9w8iV5OyWW4oxEQy3mouJEANtw09TzAgAA
X-CMS-MailID: 20240219064250epcas5p10e883fb39a12909946028672c0b5d6f3
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240219064250epcas5p10e883fb39a12909946028672c0b5d6f3
References: <CGME20240219064250epcas5p10e883fb39a12909946028672c0b5d6f3@epcas5p1.samsung.com>

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
index 65b5dbe3c850..006d7fc9cf92 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -219,10 +219,22 @@ static bool io_sqd_handle_event(struct io_sq_data *sqd)
 	return did_sig || test_bit(IO_SQ_THREAD_SHOULD_STOP, &sqd->state);
 }
 
+static void io_sq_update_worktime(struct io_sq_data *sqd, struct rusage *start)
+{
+		struct rusage end;
+
+		getrusage(current, RUSAGE_SELF, &end);
+		end.ru_stime.tv_sec -= start->ru_stime.tv_sec;
+		end.ru_stime.tv_usec -= start->ru_stime.tv_usec;
+
+		sqd->work_time += end.ru_stime.tv_usec + end.ru_stime.tv_sec * 1000000;
+}
+
 static int io_sq_thread(void *data)
 {
 	struct io_sq_data *sqd = data;
 	struct io_ring_ctx *ctx;
+	struct rusage start;
 	unsigned long timeout = 0;
 	char buf[TASK_COMM_LEN];
 	DEFINE_WAIT(wait);
@@ -251,6 +263,7 @@ static int io_sq_thread(void *data)
 		}
 
 		cap_entries = !list_is_singular(&sqd->ctx_list);
+		getrusage(current, RUSAGE_SELF, &start);
 		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
 			int ret = __io_sq_thread(ctx, cap_entries);
 
@@ -261,8 +274,10 @@ static int io_sq_thread(void *data)
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


