Return-Path: <io-uring+bounces-288-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A468816902
	for <lists+io-uring@lfdr.de>; Mon, 18 Dec 2023 10:00:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3FAA4282634
	for <lists+io-uring@lfdr.de>; Mon, 18 Dec 2023 09:00:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0459F10971;
	Mon, 18 Dec 2023 09:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="agOH0Lqi"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C07D1097A
	for <io-uring@vger.kernel.org>; Mon, 18 Dec 2023 09:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20231218090005epoutp0303a6fb25f555f9f26839fda47a309fb3~h4XAE4_5W2675526755epoutp03i
	for <io-uring@vger.kernel.org>; Mon, 18 Dec 2023 09:00:05 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20231218090005epoutp0303a6fb25f555f9f26839fda47a309fb3~h4XAE4_5W2675526755epoutp03i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1702890005;
	bh=qMRcMD68CTeJ79t1IUEsQabLz4e4QQeQOGyGUvP1UYc=;
	h=From:To:Cc:Subject:Date:References:From;
	b=agOH0Lqixdlv/VPiBVd61pCi8tEOANCzPVm6VATSRU+DY4LFA7G69/NyLtkV9qhde
	 cnarijL8tru995F+ItCj18XAxjZeK2qRRMW/1Vn6FfyYitJPDo13W0Aifo1acP3W8q
	 D3QutTbaP08KYUWnBt4M80tlPdMpnbogsQSB0Aos=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20231218090004epcas5p2c7faf10ca18d5e49e4bae886c66aecca~h4W-ll6jZ1239712397epcas5p2B;
	Mon, 18 Dec 2023 09:00:04 +0000 (GMT)
Received: from epsmges5p2new.samsung.com (unknown [182.195.38.175]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4Stv0g1ncxz4x9Pv; Mon, 18 Dec
	2023 09:00:03 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmges5p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	1B.E1.10009.31A00856; Mon, 18 Dec 2023 18:00:03 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20231218085950epcas5p4171efba84d8c14bf1307aa16c48414ca~h4Wx84vKY1264712647epcas5p4U;
	Mon, 18 Dec 2023 08:59:50 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20231218085950epsmtrp170f68502b769549f1acdcbf1cd544197~h4Wx7nvhk2610226102epsmtrp19;
	Mon, 18 Dec 2023 08:59:50 +0000 (GMT)
X-AuditID: b6c32a4a-ff1ff70000002719-76-65800a131a9f
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	D6.22.07368.60A00856; Mon, 18 Dec 2023 17:59:50 +0900 (KST)
Received: from AHRE124.. (unknown [109.105.118.124]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20231218085948epsmtip15b010f284672e6634ab5e8d943f102bd~h4WwXb-jR0522205222epsmtip1S;
	Mon, 18 Dec 2023 08:59:48 +0000 (GMT)
From: Xiaobing Li <xiaobing.li@samsung.com>
To: axboe@kernel.dk, asml.silence@gmail.com
Cc: linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
	kun.dou@samsung.com, peiwei.li@samsung.com, joshi.k@samsung.com,
	kundan.kumar@samsung.com, wenwen.chen@samsung.com, ruyi.zhang@samsung.com,
	cliang01.li@samsung.com, xue01.he@samsung.com, Xiaobing Li
	<xiaobing.li@samsung.com>
Subject: [PATCH v5] io_uring: Statistics of the true utilization of sq
 threads.
Date: Mon, 18 Dec 2023 16:51:52 +0800
Message-Id: <20231218085152.14720-1-xiaobing.li@samsung.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNJsWRmVeSWpSXmKPExsWy7bCmuq4wV0OqQfszNos5q7YxWqy+289m
	cfrvYxaLd63nWCyO/n/LZvGr+y6jxdYvX1ktLu+aw2bxbC+nxZfD39ktpm7ZwWTR0XKZ0aLr
	wik2B16PnbPusntcPlvq0bdlFaPH501yASxR2TYZqYkpqUUKqXnJ+SmZeem2St7B8c7xpmYG
	hrqGlhbmSgp5ibmptkouPgG6bpk5QNcpKZQl5pQChQISi4uV9O1sivJLS1IVMvKLS2yVUgtS
	cgpMCvSKE3OLS/PS9fJSS6wMDQyMTIEKE7Iz+i9+ZylYrlQx+cMmpgbGT9JdjJwcEgImEtve
	T2TsYuTiEBLYzSix8vBZFpCEkMAnRonGS7IQiW+MEu/urWeF6fg5ZSsbRGIvo8SKJ1fYITpe
	MkpMvW0NYrMJaEtcX9cF1iACZL9+PJUFpIFZYAmTxNZvh5lAEsICgRLXJh9hA7FZBFQlbsz5
	xwxi8wrYSPw4eIgdYpu8xP6DZ6HighInZz4BO48ZKN68dTYzyFAJgVYOicfb57JANLhIfHn/
	ixHCFpZ4dXwL1CApiZf9bVB2scSRnu+sEM0NjBLTb1+FSlhL/LuyB2gQB9AGTYn1u/QhwrIS
	U0+tY4JYzCfR+/sJE0ScV2LHPBhbVWL1pYdQN0hLvG74DRX3kHj17hM0hGIltr39wDSBUX4W
	kn9mIflnFsLmBYzMqxglUwuKc9NTi00LjPJSy+Exm5yfu4kRnEq1vHYwPnzwQe8QIxMH4yFG
	CQ5mJRFel0X1qUK8KYmVValF+fFFpTmpxYcYTYGBPJFZSjQ5H5jM80riDU0sDUzMzMxMLI3N
	DJXEeV+3zk0REkhPLEnNTk0tSC2C6WPi4JRqYFIvUNOdyNDwsKGwL6nHplnqRNbCefn5cwW2
	Biqo7+RMWDP9ZOmSXRPPNPGGfO813iX1Rjjm5+QEVSt7L5mmCVzfL3fydD+z4Ux7IRYgdqp2
	5SY7+4wtM4MZI/TOq2RrnDa6dWXDuqyq03P46zWyb4YEXPwrWpagZ/J/ewfT05OetaJz87tW
	/GpUv9dXprzvxdl14Sn/9GZs2d3PevqBWpQa2/bQazz1NSHSUw9b+HEtW3hisblA9+v4uKbP
	jI97Trm+P2Yk9mKlOPMZqYSyX6ItsvvL5i3foXGvcJue4WeV/Y4CTmrVtianvQ6VTI7jVDDb
	eHlz56N4li2nXCUveu7b+/BVgnNLgETAt4W7lViKMxINtZiLihMBhs8any4EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrJLMWRmVeSWpSXmKPExsWy7bCSnC4bV0OqweTtrBZzVm1jtFh9t5/N
	4vTfxywW71rPsVgc/f+WzeJX911Gi61fvrJaXN41h83i2V5Oiy+Hv7NbTN2yg8mio+Uyo0XX
	hVNsDrweO2fdZfe4fLbUo2/LKkaPz5vkAliiuGxSUnMyy1KL9O0SuDL6L35nKViuVDH5wyam
	BsZP0l2MnBwSAiYSP6dsZQOxhQR2M0q8OurfxcgBFJeW+POnHKJEWGLlv+fsXYxcQCXPGSU2
	3//LBJJgE9CWuL6uixWkXkRAV6LxrgJIDbPABiaJ/U/ngcWFBfwlHm5QASlnEVCVuDHnHzOI
	zStgI/Hj4CF2iPnyEvsPnoWKC0qcnPmEBaSVWUBdYv08IZAwM1BJ89bZzBMY+WchqZqFUDUL
	SdUCRuZVjJKpBcW56bnJhgWGeanlesWJucWleel6yfm5mxjBoa+lsYPx3vx/eocYmTgYDzFK
	cDArifC6LKpPFeJNSaysSi3Kjy8qzUktPsQozcGiJM5rOGN2ipBAemJJanZqakFqEUyWiYNT
	qoFJo7to74WSr9ObXQICLdMsDYx9d559eMCxRpPtgPBdjyfC6qIzF+jOWj372IRNS9acXZbB
	s/W3yOm9C1QSZ/f/4dJy63lYquzVzbfKSs3eqiNB8FxesFjp77daLsFf2lgXhLyapbNCZLr3
	0p7HjovDqswqdv6yneP/l4Gn+0HsmbPRjVeOz+k8fuXjrgRB1zX7HFsCay4Vf73YWXb16g7T
	eQfTnb37Df4y9ui8ZNgh9bM9cVL/nYheg7C6ZqH7DE82GS949pJp0aSHDqG+/jv8L03PyX7F
	eDJp0Y/LJ5oTZuq2Kt6f+PNbb/6iwjs/Hd497Gd87nPjyby5votu/xQoLQqSer3o9ulf0yvn
	2EW7KrEUZyQaajEXFScCAOjmTizsAgAA
X-CMS-MailID: 20231218085950epcas5p4171efba84d8c14bf1307aa16c48414ca
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20231218085950epcas5p4171efba84d8c14bf1307aa16c48414ca
References: <CGME20231218085950epcas5p4171efba84d8c14bf1307aa16c48414ca@epcas5p4.samsung.com>

The running time of the sq thread and the actual IO processing time are
counted, and the proportion of time actually used to process IO is
output as a percentage.

Variable description:
"work_time" in the code represents the sum of the jiffies of the sq
thread actually processing IO, that is, how many milliseconds it
actually takes to process IO. "total_time" represents the total time
that the sq thread has elapsed from the beginning of the loop to the
current time point, that is, how many milliseconds it has spent in
total.
The output "SqBusy" represents the percentage of time utilization that
the sq thread actually uses to process IO.

The test results are as follows:
Every 0.5s: cat /proc/23112/fdinfo/6 | grep Sq
SqMask: 0x3
SqHead: 1168417
SqTail: 1168418
CachedSqHead:   1168418
SqThread:       23112
SqThreadCpu:    55
SqBusy: 97%

changes：
v5：
 - list the changes in each iteration.
 
v4：
 - Resubmit the patch based on removing sq->lock
 - https://lore.kernel.org/io-uring/20231213032513.12591-1-xiaobing.li@samsung.com/T/#u
 
v3：
 - output actual working time as a percentage of total time
 - detailed description of the meaning of each variable
 - added test results
 - https://lore.kernel.org/io-uring/50ec567f-6b79-42ea-bf2c-2c9b2ecb427d@suswa.mountain/T/#t
 
v2：
 - output the total statistical time and work time to fdinfo
 - https://lore.kernel.org/io-uring/9e2b679c-fc1e-3d83-2303-e053f330a21a@gmail.com/T/#t

v1：
 - initial version
 - Statistics of total time and work time
 - https://lore.kernel.org/io-uring/2a1bdb5a-1216-45b0-a78d-5542b36ccd17@kernel.dk/T/#t

Signed-off-by: Xiaobing Li <xiaobing.li@samsung.com>
---
 io_uring/fdinfo.c | 4 ++++
 io_uring/sqpoll.c | 8 ++++++++
 io_uring/sqpoll.h | 2 ++
 3 files changed, 14 insertions(+)

diff --git a/io_uring/fdinfo.c b/io_uring/fdinfo.c
index 976e9500f651..b0f9d296c5aa 100644
--- a/io_uring/fdinfo.c
+++ b/io_uring/fdinfo.c
@@ -64,6 +64,7 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
 	unsigned int sq_shift = 0;
 	unsigned int sq_entries, cq_entries;
 	int sq_pid = -1, sq_cpu = -1;
+	int sq_busy = 0;
 	bool has_lock;
 	unsigned int i;
 
@@ -147,10 +148,13 @@ __cold void io_uring_show_fdinfo(struct seq_file *m, struct file *f)
 
 		sq_pid = sq->task_pid;
 		sq_cpu = sq->sq_cpu;
+		if (sq->total_time != 0)
+			sq_busy = (int)(sq->work_time * 100 / sq->total_time);
 	}
 
 	seq_printf(m, "SqThread:\t%d\n", sq_pid);
 	seq_printf(m, "SqThreadCpu:\t%d\n", sq_cpu);
+	seq_printf(m, "SqBusy:\t%d%%\n", sq_busy);
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
2.34.1


