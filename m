Return-Path: <io-uring+bounces-791-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2541186AA75
	for <lists+io-uring@lfdr.de>; Wed, 28 Feb 2024 09:52:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A70F52828F1
	for <lists+io-uring@lfdr.de>; Wed, 28 Feb 2024 08:52:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8CE902D059;
	Wed, 28 Feb 2024 08:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="u3yQSvVM"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D14A421A06
	for <io-uring@vger.kernel.org>; Wed, 28 Feb 2024 08:52:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709110344; cv=none; b=nYxPkHsmaVfig9regy+CVAkoYw7DwtVvmAhhUrMaAQmUJax38gMupv/AVLIISCuKjd4wZeub4v3Q/boi4HuooB4DNAd1hisH1qXImumF5Mr/0LHqzGUx18YPJhi8Wzsb6EcpHPqcMbFVb9UpSs+FwqV+JSWGPVXG/6uTiQgr+gM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709110344; c=relaxed/simple;
	bh=L9bjFJ/dOqbtdH0g9oG3AMTC72XkuZmJlua2NRa7UyI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=VI5blCx5okB2I93EbccWj3n3Ivr5VC/50wmfJ3y0/ZZcmLos7lpcRaHrnpOBE1JHr1Hrb+TjqY6NcJc2lvO9ShaGxIEQ+/vlEs+t1L8cdAndF/JnPPDql7XhpX9SHENZDZcExRWjBhE9ee/pkWzK4/9l6e5uskARv8JX0bGOjbg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=u3yQSvVM; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20240228085218epoutp01f67048ded4692551ec343c15ff9d63e9~3_sw2cTRN2753627536epoutp01_
	for <io-uring@vger.kernel.org>; Wed, 28 Feb 2024 08:52:18 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20240228085218epoutp01f67048ded4692551ec343c15ff9d63e9~3_sw2cTRN2753627536epoutp01_
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1709110338;
	bh=eXJALbBIdD7HZh78nv7RcwGYAGev1xTXLCQxJmMWp4Y=;
	h=From:To:Cc:Subject:Date:References:From;
	b=u3yQSvVMhVygbIE9XynUbHOabLwmHZpeLEyQErVL98CKiZfwcuQswMl+T9AWxpWb3
	 V00MgNKWF/SyEjTnhYPFhWaW4n1Iew/e2dr3nS4iOIJqYqtTCeIYDaxoslvrKglf/k
	 pR0+1ULwNzINOuwNGxK//hx2zWUjIse7AtUOAALg=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20240228085217epcas5p29c44050931bc2a0da2aea47e124518c4~3_swHlQpY0066800668epcas5p2W;
	Wed, 28 Feb 2024 08:52:17 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.179]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4Tl7QS4PpHz4x9Pw; Wed, 28 Feb
	2024 08:52:16 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	A2.A6.09672.044FED56; Wed, 28 Feb 2024 17:52:16 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20240228085203epcas5p420cb18119eec3559793c2249f3d8727b~3_sjDK7mi2480324803epcas5p4D;
	Wed, 28 Feb 2024 08:52:03 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240228085203epsmtrp2f7c2397bf6ca079873336c466bfe7980~3_sjBDrUE0093400934epsmtrp2m;
	Wed, 28 Feb 2024 08:52:03 +0000 (GMT)
X-AuditID: b6c32a4b-39fff700000025c8-db-65def4400dd4
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	3A.BD.18939.334FED56; Wed, 28 Feb 2024 17:52:03 +0900 (KST)
Received: from testpc118124.samsungds.net (unknown [109.105.118.124]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240228085200epsmtip1f95553ad32e7ede9594644bd04b9b4f8~3_sfpDyZ_2359823598epsmtip1c;
	Wed, 28 Feb 2024 08:52:00 +0000 (GMT)
From: Xiaobing Li <xiaobing.li@samsung.com>
To: axboe@kernel.dk, asml.silence@gmail.com
Cc: linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
	kun.dou@samsung.com, peiwei.li@samsung.com, joshi.k@samsung.com,
	kundan.kumar@samsung.com, wenwen.chen@samsung.com, ruyi.zhang@samsung.com,
	cliang01.li@samsung.com, xue01.he@samsung.com, Xiaobing Li
	<xiaobing.li@samsung.com>
Subject: [PATCH v10] io_uring: Statistics of the true utilization of sq
 threads.
Date: Wed, 28 Feb 2024 16:51:54 +0800
Message-Id: <20240228085154.193363-1-xiaobing.li@samsung.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPJsWRmVeSWpSXmKPExsWy7bCmhq7Dl3upBu0H5SzmrNrGaLH6bj+b
	xem/j1ks3rWeY7E4+v8tm8Wv7ruMFlu/fGW1uLxrDpvFs72cFl8Of2e3ODvhA6vF1C07mCw6
	Wi4zWnRdOMXmwOexc9Zddo/LZ0s9+rasYvT4vEkugCUq2yYjNTEltUghNS85PyUzL91WyTs4
	3jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6EQlhbLEnFKgUEBicbGSvp1NUX5pSapCRn5x
	ia1SakFKToFJgV5xYm5xaV66Xl5qiZWhgYGRKVBhQnbGydM1Bae0Kyb1bWJuYJyh3MXIySEh
	YCLRfG0zUxcjF4eQwG5Gib+nLjBDOJ8YJR49OcwKUgXmrDoZCdex7gFUx05GiTvXmtkgnF+M
	Ep9ezGYCqWIT0Ja4vq4LrFsEyH79eCoLSBGzwBImia3fDoMVCQsESayY3s0MYrMIqEpMO30J
	rIFXwFai7cFuZoh18hL7D55lhogLSpyc+YQFxGYGijdvnQ12q4RAJ4fE5E8zoBpcJFbvOMAO
	YQtLvDq+BcqWkvj8bi8bhF0scaTnOytEcwOjxPTbV6GKrCX+XdkDtIEDaIOmxPpd+hBhWYmp
	p9YxQSzmk+j9/YQJIs4rsWMejK0qsfrSQxYIW1ridcNvqLiHxLGbU9hBRgoJxEosP1owgVF+
	FpJ3ZiF5ZxbC4gWMzKsYJVMLinPTU4tNC4zzUsvhEZucn7uJEZxStbx3MD568EHvECMTB+Mh
	RgkOZiURXhnBu6lCvCmJlVWpRfnxRaU5qcWHGE2BYTyRWUo0OR+Y1PNK4g1NLA1MzMzMTCyN
	zQyVxHlft85NERJITyxJzU5NLUgtgulj4uCUamBiDnu4+v8t7ZQ2/h+61313316ysLzBzrR0
	xeIzfRemGV4w7xc7Hd+074p8injYrBz7rb8nbhbq6bCXt7qsyCnHvSFf7J9fbJpjWa5cdaX4
	gncpPDwWHiEWfrVTvndz+XJ/6z62kFdI+7ege42A6YPMJTFei1n5b/Ie3yUiOjPi0mvrYw/t
	xb9MFrxyIUTjsZzx+Xs/sh9uNPMwWzfz0LI480vP+rgfZs4wWrGJrdfa8vcTs8pZrQfmeS7i
	Nfq51Yfj+lLf9FMnEhlqnxVK56x6Gvt4Q0tS28R9BlFMp4/tnGmx10v+lf5rB5EJLxfu0Vm5
	xLjkQsSBq3Lb9TXDPvQdWJrt8HNVmZr4ZZnAk41KLMUZiYZazEXFiQDdFPU+MgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrNLMWRmVeSWpSXmKPExsWy7bCSnK7xl3upBtfPaVrMWbWN0WL13X42
	i9N/H7NYvGs9x2Jx9P9bNotf3XcZLbZ++cpqcXnXHDaLZ3s5Lb4c/s5ucXbCB1aLqVt2MFl0
	tFxmtOi6cIrNgc9j56y77B6Xz5Z69G1ZxejxeZNcAEsUl01Kak5mWWqRvl0CV8bJ0zUFp7Qr
	JvVtYm5gnKHcxcjJISFgItG87gFTFyMXh5DAdkaJu9tnsHQxcgAlpCX+/CmHqBGWWPnvOTtE
	zQ9GiUkNvxhBEmwC2hLX13WxgtSLCOhKNN5VAKlhFtjAJLH/6TxWkBphgQCJC3/fs4HYLAKq
	EtNOXwKL8wrYSrQ92M0MsUBeYv/Bs8wQcUGJkzOfgN3ALKAusX6eEEiYGaikeets5gmM/LOQ
	VM1CqJqFpGoBI/MqRtHUguLc9NzkAkO94sTc4tK8dL3k/NxNjODw1wrawbhs/V+9Q4xMHIyH
	GCU4mJVEeGUE76YK8aYkVlalFuXHF5XmpBYfYpTmYFES51XO6UwREkhPLEnNTk0tSC2CyTJx
	cEo1MOW3yu+rTXVpmr6HUaX6qaxPaXTftQ38Pg3tzxZz+Ike4NnYubclboO4SGbu1vdzWlg7
	frDOFNOcFSF1NPb18pKDyUvVf3rcru+bxcXF+X39xz0i7FYeawJPRvtz900XTbjSPPn4iXf7
	mXwevNW/ma1zK8vx1XJXbqb+5q8GD2ymzVoe979ZakHe91nvOK3lPi4UPmXp7b75NuM381k3
	jj5ZKBH5+5jr0lVeu/gvBFWL3X4h3b2t++Kuk6dvOU+fqvH5w6635yLf1V770/hAf8r+pw2r
	ly9fa6A2/SDvsfaOOVtjXBW4Fj+5vDUgYR93u4xR8O3ZHSWX58Y8vrF3c8cbNvNFez8HCDYo
	bPTcvXS+EktxRqKhFnNRcSIA5P7JLu4CAAA=
X-CMS-MailID: 20240228085203epcas5p420cb18119eec3559793c2249f3d8727b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240228085203epcas5p420cb18119eec3559793c2249f3d8727b
References: <CGME20240228085203epcas5p420cb18119eec3559793c2249f3d8727b@epcas5p4.samsung.com>

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

 io_uring/fdinfo.c |  6 ++++++
 io_uring/sqpoll.c | 17 ++++++++++++++++-
 io_uring/sqpoll.h |  1 +
 3 files changed, 23 insertions(+), 1 deletion(-)

diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index 976e9500f651..42b449e53535 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -64,6 +64,7 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
 	unsigned int sq_shift = 0;
 	unsigned int sq_entries, cq_entries;
 	int sq_pid = -1, sq_cpu = -1;
+	u64 sq_total_time = 0, sq_work_time = 0;
 	bool has_lock;
 	unsigned int i;
 
@@ -147,10 +148,15 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
 
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


