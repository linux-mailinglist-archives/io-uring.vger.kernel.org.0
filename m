Return-Path: <io-uring+bounces-359-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B0BE881E4DF
	for <lists+io-uring@lfdr.de>; Tue, 26 Dec 2023 05:47:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 094E51F2254F
	for <lists+io-uring@lfdr.de>; Tue, 26 Dec 2023 04:47:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CDD0D4A9B1;
	Tue, 26 Dec 2023 04:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="i5MLp8QI"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 595E81A719
	for <io-uring@vger.kernel.org>; Tue, 26 Dec 2023 04:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20231226044740epoutp018f29147ea405c822f9122c7c06f8cfa8~kSE54ZFy81135911359epoutp01p
	for <io-uring@vger.kernel.org>; Tue, 26 Dec 2023 04:47:40 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20231226044740epoutp018f29147ea405c822f9122c7c06f8cfa8~kSE54ZFy81135911359epoutp01p
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1703566060;
	bh=Nug3/f8Q4/ibNrOlixZTRYPd3Tv54vqC7fn1zAFy6bQ=;
	h=From:To:Cc:Subject:Date:References:From;
	b=i5MLp8QIy3pCNWdGMHVHsUkSYy8Ds6NSv5EbfPsTbNM4pQeX3YdcjHVekRqPK7cPm
	 fROT2x81T9GNGl5j+Rf1ujSyLwqQgQX4dbjrQ9sWASZ62f0d+mDtmrXI1b008hqzwc
	 16CRbxmqmVZrqhOF/RBQpMilxJGgARimMVCfS23A=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20231226044740epcas5p2707bd502c2f1b2753cc5b8a053511ecf~kSE5iDUWR2236222362epcas5p2w;
	Tue, 26 Dec 2023 04:47:40 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.179]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4Szj1l2K3yz4x9Pv; Tue, 26 Dec
	2023 04:47:39 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	69.B6.09634.BEA5A856; Tue, 26 Dec 2023 13:47:39 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20231225055252epcas5p43ae8016d329b160f688def7b4f9d4ddb~j-UiUgA7e2655526555epcas5p42;
	Mon, 25 Dec 2023 05:52:52 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20231225055252epsmtrp1035a41da09cadae0e41218bbe02795d0~j-UiTlafq3004930049epsmtrp1A;
	Mon, 25 Dec 2023 05:52:52 +0000 (GMT)
X-AuditID: b6c32a49-eebff700000025a2-f8-658a5aebd68e
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	A1.A3.07368.4B819856; Mon, 25 Dec 2023 14:52:52 +0900 (KST)
Received: from localhost.localdomain (unknown [109.105.118.124]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20231225055250epsmtip2369aa83565ac7aebec79ef864bf5ce60~j-UgepQ100550205502epsmtip2O;
	Mon, 25 Dec 2023 05:52:50 +0000 (GMT)
From: Xiaobing Li <xiaobing.li@samsung.com>
To: axboe@kernel.dk
Cc: asml.silence@gmail.com, linux-kernel@vger.kernel.org,
	io-uring@vger.kernel.org, kun.dou@samsung.com, peiwei.li@samsung.com,
	joshi.k@samsung.com, kundan.kumar@samsung.com, wenwen.chen@samsung.com,
	ruyi.zhang@samsung.com, cliang01.li@samsung.com, xue01.he@samsung.com,
	Xiaobing Li <xiaobing.li@samsung.com>
Subject: [PATCH v6] io_uring: Statistics of the true utilization of sq
 threads.
Date: Mon, 25 Dec 2023 13:44:38 +0800
Message-ID: <20231225054438.44581-1-xiaobing.li@samsung.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAJsWRmVeSWpSXmKPExsWy7bCmpu7rqK5Ug4W3+CzmrNrGaLH6bj+b
	xem/j1ks3rWeY7E4+v8tm8Wv7ruMFlu/fGW1uLxrDpvFs72cFl8Of2e3ODvhA6vF1C07mCw6
	Wi4zWnRdOMXmwOexc9Zddo/LZ0s9+rasYvT4vEkugCUq2yYjNTEltUghNS85PyUzL91WyTs4
	3jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMH6EQlhbLEnFKgUEBicbGSvp1NUX5pSapCRn5x
	ia1SakFKToFJgV5xYm5xaV66Xl5qiZWhgYGRKVBhQnbGjtUz2QpaFCp6FixgaWC8JtnFyMkh
	IWAiMfvwS5YuRi4OIYHdjBIbum8yQzifGCVuvZ/ICuF8Y5S42dPLDNNyZW4rVMteRomfZzug
	qr4ySiz808IKUsUmoC1xfV0XmC0iICyxvwOig1lgD5PE9nsH2UASwgKBEotvdIMVsQioSuya
	soGpi5GDg1fARuLxFXuIbfISi3csB9vMKyAocXLmExYQmxko3rx1NtRFnRwSvdesIWwXiakb
	+hghbGGJV8e3sEPYUhIv+9ug7GKJIz3fwY6WEGhglJh++ypUwlri35U9LCA3MAtoSqzfpQ8R
	lpWYemodE8RePone30+YIOK8EjvmwdiqEqsvPWSBsKUlXjf8hop7SBzY/RgsLiQQK7Hr21L2
	CYzys5C8MwvJO7MQNi9gZF7FKJlaUJybnlpsWmCYl1oOj9nk/NxNjOCkquW5g/Hugw96hxiZ
	OBgPMUpwMCuJ8MoqdqQK8aYkVlalFuXHF5XmpBYfYjQFBvFEZinR5HxgWs8riTc0sTQwMTMz
	M7E0NjNUEud93To3RUggPbEkNTs1tSC1CKaPiYNTqoHJ/9Hvx6e5MxZKvud+oLiovv589P49
	PVc+SXdUBTXq1GW0t0y2PlgZGhZnciT93bFZ3g41r1hr/8xjlMnwOOGvW1XHJpjLKiNxRmym
	+3HGhFbxD+YeIdX+5/xebrphZs63JIfzq2ai/Gq5RbUb10V1OJWuVb1hs5HPyHHFkz96m/Lv
	T3FnnXz+vEtF3MlFX15JTXy5uXdvJkt6pfHk6m1inRP9Yo4vmr78arGh3M9bCsbGu5xFk5xz
	6s2tj95a1RG0zSTtyr5mW4eKadLPOr/uETFolFHYVDajhiv14BUT+VCLxpVzdmo72RXWX2kR
	3rdIUT7jlA1Hsp62YSH3qakGHU9nf3lsvvpq5u5DWkosxRmJhlrMRcWJABzF3WUzBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrHLMWRmVeSWpSXmKPExsWy7bCSvO4Wic5Ug8tnWSzmrNrGaLH6bj+b
	xem/j1ks3rWeY7E4+v8tm8Wv7ruMFlu/fGW1uLxrDpvFs72cFl8Of2e3ODvhA6vF1C07mCw6
	Wi4zWnRdOMXmwOexc9Zddo/LZ0s9+rasYvT4vEkugCWKyyYlNSezLLVI3y6BK2PH6plsBS0K
	FT0LFrA0MF6T7GLk5JAQMJG4MreVBcQWEtjNKDFlqVgXIwdQXFriz59yiBJhiZX/nrN3MXIB
	lXxmlHi+fzMTSIJNQFvi+rouVhBbBKhofwfEHGaBU0wS7b9cQWxhAX+J3bfugtWzCKhK7Jqy
	gQlkPq+AjcTjK/YQ8+UlFu9Yzgxi8woISpyc+YQFpIRZQF1i/TwhiInyEs1bZzNPYOSfhaRq
	FkLVLCRVCxiZVzFKphYU56bnJhsWGOallusVJ+YWl+al6yXn525iBEeBlsYOxnvz/+kdYmTi
	YDzEKMHBrCTCK6vYkSrEm5JYWZValB9fVJqTWnyIUZqDRUmc13DG7BQhgfTEktTs1NSC1CKY
	LBMHp1QDE4/wzeN/vt54L7x+dgnvui+BBadjE/iSn0b+FfGqUrpcnH0/csHi5HTR5fuPTPix
	J6fl9OVdvzivMXjIf1p+/kF/aDxj14aCxE617cue3uwM19ay53kiJbn0x/cJRoETLRx6xAV5
	Nu/a9KciyVTfv+qc1bQJLy2jeV1OvA0u+Mzq8silaOJCzTPmm5ecDpdJjVF9qJK2/q9Pw50P
	NUt/cnyu3+zO9nnT1ZrIVibpmCCrbvvuKxli3GUzDv79MMFJvvGKYpHx5NxXeZ+f6nTZPjhg
	KWezReOf0ayDL1YZzfVkSpRKOsH472Os18J6jYT53FvP2t7Z8dXX9KXPwbJjXmEc3pbM1ptq
	Gr9PO/g9UYmlOCPRUIu5qDgRAFG4wlPxAgAA
X-CMS-MailID: 20231225055252epcas5p43ae8016d329b160f688def7b4f9d4ddb
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20231225055252epcas5p43ae8016d329b160f688def7b4f9d4ddb
References: <CGME20231225055252epcas5p43ae8016d329b160f688def7b4f9d4ddb@epcas5p4.samsung.com>

Count the running time and actual IO processing time of the sqpoll
thread, and output the statistical data to fdinfo.

Variable description:
"work_time" in the code represents the sum of the jiffies of the sq
thread actually processing IO, that is, how many milliseconds it
actually takes to process IO. "total_time" represents the total time
that the sq thread has elapsed from the beginning of the loop to the
current time point, that is, how many milliseconds it has spent in
total.

The test results are as follows:
Every 0.5s: cat /proc/23112/fdinfo/6 | grep Sq
SqMask: 0x3
SqHead: 1168417
SqTail: 1168418
CachedSqHead:   1168418
SqThread:       23112
SqThreadCpu:    55
SqWorkTime:     12423
SqTotalTime:    12843

changes：
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

Signed-off-by: Xiaobing Li <xiaobing.li@samsung.com>
---
 io_uring/fdinfo.c | 6 ++++++
 io_uring/sqpoll.c | 8 ++++++++
 io_uring/sqpoll.h | 2 ++
 3 files changed, 16 insertions(+)

diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index 976e9500f651..82d3d9471bac 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -64,6 +64,8 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
 	unsigned int sq_shift = 0;
 	unsigned int sq_entries, cq_entries;
 	int sq_pid = -1, sq_cpu = -1;
+	unsigned long work_time = 0;
+	unsigned long total_time = 0;
 	bool has_lock;
 	unsigned int i;
 
@@ -147,10 +149,14 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
 
 		sq_pid = sq->task_pid;
 		sq_cpu = sq->sq_cpu;
+		work_time = sq->work_time;
+		total_time = sq->total_time;
 	}
 
 	seq_printf(m, "SqThread:\t%d\n", sq_pid);
 	seq_printf(m, "SqThreadCpu:\t%d\n", sq_cpu);
+	seq_printf(m, "SqWorkTime:\t%lu\n", work_time);
+	seq_printf(m, "SqTotalTime:\t%lu\n", total_time);
 	seq_printf(m, "UserFiles:\t%u\n", ctx->nr_user_files);
 	for (i = 0; has_lock && i < ctx->nr_user_files; i++) {
 		struct file *f = io_file_from_index(&ctx->file_table, i);
diff --git a/io_uring/sqpoll.c b/io_uring/sqpoll.c
index 65b5dbe3c850..9b74e344c52a 100644
--- a/io_uring/sqpoll.c
+++ b/io_uring/sqpoll.c
@@ -225,6 +225,7 @@ static int io_sq_thread(void *data)
 	struct io_ring_ctx *ctx;
 	unsigned long timeout = 0;
 	char buf[TASK_COMM_LEN];
+	unsigned long sq_start, sq_work_begin, sq_work_end;
 	DEFINE_WAIT(wait);
 
 	snprintf(buf, sizeof(buf), "iou-sqp-%d", sqd->task_pid);
@@ -241,6 +242,7 @@ static int io_sq_thread(void *data)
 	}
 
 	mutex_lock(&sqd->lock);
+	sq_start = jiffies;
 	while (1) {
 		bool cap_entries, sqt_spin = false;
 
@@ -251,6 +253,7 @@ static int io_sq_thread(void *data)
 		}
 
 		cap_entries = !list_is_singular(&sqd->ctx_list);
+		sq_work_begin = jiffies;
 		list_for_each_entry(ctx, &sqd->ctx_list, sqd_list) {
 			int ret = __io_sq_thread(ctx, cap_entries);
 
@@ -260,6 +263,11 @@ static int io_sq_thread(void *data)
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
diff --git a/io_uring/sqpoll.h b/io_uring/sqpoll.h
index 8df37e8c9149..92b4b07220fa 100644
--- a/io_uring/sqpoll.h
+++ b/io_uring/sqpoll.h
@@ -16,6 +16,8 @@ struct io_sq_data {
 	pid_t			task_pid;
 	pid_t			task_tgid;
 
+	unsigned long		work_time;
+	unsigned long		total_time;
 	unsigned long		state;
 	struct completion	exited;
 };
-- 
2.43.0


