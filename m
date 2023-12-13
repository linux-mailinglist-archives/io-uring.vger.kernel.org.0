Return-Path: <io-uring+bounces-281-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CF8D7810944
	for <lists+io-uring@lfdr.de>; Wed, 13 Dec 2023 05:55:09 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 8B3A2281C08
	for <lists+io-uring@lfdr.de>; Wed, 13 Dec 2023 04:55:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C8A2C15B;
	Wed, 13 Dec 2023 04:55:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="gyP1rZVH"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BE159A
	for <io-uring@vger.kernel.org>; Tue, 12 Dec 2023 20:54:58 -0800 (PST)
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20231213045456epoutp02a2dd8b90d5546cc8490d81c72f6028ce~gSyiHJl5I1796917969epoutp02H
	for <io-uring@vger.kernel.org>; Wed, 13 Dec 2023 04:54:56 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20231213045456epoutp02a2dd8b90d5546cc8490d81c72f6028ce~gSyiHJl5I1796917969epoutp02H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1702443296;
	bh=MgcKzc1IORHWtSSPzD4YL1p/LjIGorkzaZhtW/BEzRA=;
	h=From:To:Cc:Subject:Date:References:From;
	b=gyP1rZVH3zLLn9LJDMETLZneVwxvOoFTMgQ9zP+ylgGqObbV09PhKIIJBQA64RJf8
	 Bt67DpBJHz0grJnpBVe/Y8xMtPknyDMdMqe/jlDQ2tdFd0gAyZjvgVdGdjDpr5VbKc
	 O4qyiYITdjplVrAYDfpI/8E5NvTZLA6btBsCr8AU=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20231213045455epcas5p2867e0f6682429d8d7929c20000d18693~gSyhF0gZM2683426834epcas5p2H;
	Wed, 13 Dec 2023 04:54:55 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.179]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4Sqjp437cPz4x9Px; Wed, 13 Dec
	2023 04:54:52 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	D7.91.09634.B1939756; Wed, 13 Dec 2023 13:54:51 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20231213033309epcas5p4a312be32080125bfe62bf5353abadd74~gRrIRE6l51492114921epcas5p44;
	Wed, 13 Dec 2023 03:33:09 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20231213033309epsmtrp236608f0b4346b2c27d0dff9145953263~gRrIQMiCF2684726847epsmtrp2M;
	Wed, 13 Dec 2023 03:33:09 +0000 (GMT)
X-AuditID: b6c32a49-159fd700000025a2-a7-6579391bc399
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	59.48.08755.5F529756; Wed, 13 Dec 2023 12:33:09 +0900 (KST)
Received: from AHRE124.. (unknown [109.105.118.124]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20231213033308epsmtip1679095a847f903ea9f7e7d97cb1a9565~gRrG4SE7m2763727637epsmtip1a;
	Wed, 13 Dec 2023 03:33:08 +0000 (GMT)
From: Xiaobing Li <xiaobing.li@samsung.com>
To: axboe@kernel.dk, asml.silence@gmail.com
Cc: linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
	kun.dou@samsung.com, peiwei.li@samsung.com, joshi.k@samsung.com,
	kundan.kumar@samsung.com, wenwen.chen@samsung.com, ruyi.zhang@samsung.com,
	cliang01.li@samsung.com, xue01.he@samsung.com, Xiaobing Li
	<xiaobing.li@samsung.com>
Subject: [PATCH v4] io_uring: Statistics of the true utilization of sq
 threads.
Date: Wed, 13 Dec 2023 11:25:13 +0800
Message-Id: <20231213032513.12591-1-xiaobing.li@samsung.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNJsWRmVeSWpSXmKPExsWy7bCmhq60ZWWqwf4HshZzVm1jtFh9t5/N
	4vTfxywW71rPsVgc/f+WzeJX911Gi61fvrJaXN41h83i2V5Oiy+Hv7NbTN2yg8mio+Uyo0XX
	hVNsDrweO2fdZfe4fLbUo2/LKkaPz5vkAliism0yUhNTUosUUvOS81My89JtlbyD453jTc0M
	DHUNLS3MlRTyEnNTbZVcfAJ03TJzgK5TUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQXl9gqpRak
	5BSYFOgVJ+YWl+al6+WlllgZGhgYmQIVJmRnbDn4jqngu1zF+iXNjA2MbyW6GDk5JARMJCa+
	PMrWxcjFISSwm1Hi/54pzBDOJ0aJmxdWsEM43xglHm+4xAjTMr/vJ1RiL6PE8dNTWCGcl4wS
	r1f+ZAWpYhPQlri+rgvMFgGyXz+eygJSxCywhEli67fDTCAJYYFAiVfPFgIt5OBgEVCVaJ3B
	ARLmFbCRmH/vPQvENnmJ/QfPMkPEBSVOznwCFmcGijdvnQ12q4TAT3aJO/ueM0M0uEhs+bUc
	6lRhiVfHt7BD2FISn9/tZYOwiyWO9HxnhWhuYJSYfvsqVJG1xL8re1hADmIW0JRYv0sfIiwr
	MfXUOiaIxXwSvb+fMEHEeSV2zIOxVSVWX3oIdbS0xOuG30wgYyQEPCSWXo8FCQsJxEp8OXKJ
	fQKj/Cwk78xC8s4shMULGJlXMUqmFhTnpqcWmxYY5qWWw2M2OT93EyM4lWp57mC8++CD3iFG
	Jg7GQ4wSHMxKIrwnd5SnCvGmJFZWpRblxxeV5qQWH2I0BQbxRGYp0eR8YDLPK4k3NLE0MDEz
	MzOxNDYzVBLnfd06N0VIID2xJDU7NbUgtQimj4mDU6qBqers+31XDvF2zlLg2TUhY9PVzxPP
	aScrMyortHvVdHpdeOt/52LCh/Ny+09/zWG4U/y8fFqeg2eeEss6hZs/pF+wHIxQkF995Fl5
	k9+EAif1eRa7RVMsUzxT+kXkTb099N5dPiCas9Lt8+6N2xa2LdM7dEbhleDqlNTDF0tdTswW
	kK0vbLnXV6Tme+fi+owPkQxGB99IZmg2sHamKtz6NFHMybntisWkFz8nF4u/D5rw4slieZ2F
	gbzamTGfpI8JeEiei5pZfa5LnO3p/ICyb3fUgifxtbYLFd+d4LXvbvb9HeXt9VXzF3X0hnAu
	3WPD/+7zY72OjyUZ0oeURdpajhp4vr7HPFXoswqT8eQTSizFGYmGWsxFxYkAdpFmvy4EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsWy7bCSnO5X1cpUg+cL1C3mrNrGaLH6bj+b
	xem/j1ks3rWeY7E4+v8tm8Wv7ruMFlu/fGW1uLxrDpvFs72cFl8Of2e3mLplB5NFR8tlRouu
	C6fYHHg9ds66y+5x+WypR9+WVYwenzfJBbBEcdmkpOZklqUW6dslcGVsOfiOqeC7XMX6Jc2M
	DYxvJboYOTkkBEwk5vf9ZO9i5OIQEtjNKHHmUg9zFyMHUEJa4s+fcogaYYmV/56zg9hCAs8Z
	JfoW+YDYbALaEtfXdbGClIsI6Eo03lUAGcMssIFJYv/TeawgNcIC/hJTri5kAalhEVCVaJ3B
	ARLmFbCRmH/vPQvEeHmJ/QfPMkPEBSVOznwCFmcGijdvnc08gZFvFpLULCSpBYxMqxglUwuK
	c9Nziw0LDPNSy/WKE3OLS/PS9ZLzczcxgsNZS3MH4/ZVH/QOMTJxMB5ilOBgVhLhPbmjPFWI
	NyWxsiq1KD++qDQntfgQozQHi5I4r/iL3hQhgfTEktTs1NSC1CKYLBMHp1QD0+QL373O7dVY
	4vonPNDSc9pkwbuXH99cX8QT+6NtzhytrVPe6Gfor41uuvpx66uq/wlxr/9ve2IbxqozV6uA
	1fKPyKMynn5eqQvPHTxrropZ5jlaTN2UwiY466eN7VmOnrTOmGeLgxKvtl4tOPrRSOvYDea1
	Z48Z+i+Yuqfj0TpWfW3GmoTsaxxt8+buK02Yc0JfsIip5IcF6+3pv9h/TLr4UmeB453d/+c/
	enVhRuerMo5fqvt2bmjZv/fD50v1287WvO/P/e5xo/7iVj4m5nk7mtTaHA5FvmV/IBpVwrd8
	TtN0GfH+G0cuV5fabdWJlJCwi7tgmHp/Rv+Lu9nXU9bs+NFd6ltdwn5mD0Nc1VYlluKMREMt
	5qLiRADUuThV1gIAAA==
X-CMS-MailID: 20231213033309epcas5p4a312be32080125bfe62bf5353abadd74
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20231213033309epcas5p4a312be32080125bfe62bf5353abadd74
References: <CGME20231213033309epcas5p4a312be32080125bfe62bf5353abadd74@epcas5p4.samsung.com>

v4:
1.Since the sq thread has a while(1) structure, during this process,
  there may be a lot of time that is not processing IO but does not
exceed the timeout period, therefore, the sqpoll thread will keep
running and will keep occupying the CPU. Obviously, the CPU is wasted at
this time;Our goal is to count the part of the time that the sqpoll
thread actually processes IO, so as to reflect the part of the CPU it
uses to process IO, which can be used to help improve the actual
utilization of the CPU in the future.

2."work_time" in the code represents the sum of the jiffies of the sq
  thread actually processing IO, that is, how many milliseconds it
actually takes to process IO. "total_time" represents the total time
that the sq thread has elapsed from the beginning of the loop to the
current time point, that is, how many milliseconds it has spent in
total.
The output "SqBusy" represents the percentage of time utilization that
the sq thread actually uses to process IO.

Signed-off-by: Xiaobing Li <xiaobing.li@samsung.com>

The test results are as follows:
Every 0.5s: cat /proc/23112/fdinfo/6 | grep Sq
SqMask: 0x3
SqHead: 1168417
SqTail: 1168418
CachedSqHead:   1168418
SqThread:       23112
SqThreadCpu:    55
SqBusy: 97%
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


