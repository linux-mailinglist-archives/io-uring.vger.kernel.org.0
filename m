Return-Path: <io-uring+bounces-2270-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3BDFC90E687
	for <lists+io-uring@lfdr.de>; Wed, 19 Jun 2024 11:08:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B6A7E283114
	for <lists+io-uring@lfdr.de>; Wed, 19 Jun 2024 09:08:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EEAC67F7CA;
	Wed, 19 Jun 2024 09:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="EqnC1ytu"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED257770F5
	for <io-uring@vger.kernel.org>; Wed, 19 Jun 2024 09:08:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718788091; cv=none; b=LoMWWjaKLV/O0WGkSWWSmt1im04oMXPmKR1Q3PYCYAZ0B8RdXm85VHRoI6fXPXHyKkzS29AZZbLWAEkJWnAedJjUzN+MZSNtz8bx7IZ/ZXkOVIU4hyrkmAHVYU3Z3dzL8NkAdVGx2M0NDfDy8VYC65XZAdNbkaE7w++AL+xi9cs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718788091; c=relaxed/simple;
	bh=Bmp6P29F0vr7agFy7pRu/+PL/HkGLc6ZvSGF7EMCOsE=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=XRx3u1mCz8ujUL+nM/Squ1hnErmPpgqLkITdkhMCqFreTttWWjMVooppicIBZBAphrRBmFfSnUq255WkmDMDnZ9Xa6ZjW3Ey5il8QM3z78Rr8dOMKEOXbLTDNAkCIzjYs7FYGiV/C8xEtWhPn/k8nljRu0CWDhL9c2y084h/EPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=EqnC1ytu; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240619090758epoutp0465baf697e46f951b7b784e9cf4813485~aXKaRY6kI0197901979epoutp04I
	for <io-uring@vger.kernel.org>; Wed, 19 Jun 2024 09:07:58 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240619090758epoutp0465baf697e46f951b7b784e9cf4813485~aXKaRY6kI0197901979epoutp04I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1718788078;
	bh=HK8tUSGh6Eo/Y1mdyLcoROc7fNWoF/dlF+HVpaagyRU=;
	h=From:To:Cc:Subject:Date:References:From;
	b=EqnC1ytuFFlykRsSZRyLXMJ4OjgPtn+YjLPCxe4qUUOugr5SgErPVvsKiE5F9OgPd
	 CuDf3JCfovFJM4zyNFeO9XbC11pSoKZcwqMPm1zDGtzF97L1chGuICjCRpJI4Orrq8
	 CXJvklOcjLBh0T9Abd+L4e0TG8LX6biCCq/BXjXc=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20240619090757epcas5p1d9a7c1f69224d762fa17da950813d65c~aXKZ2VymC2693126931epcas5p1M;
	Wed, 19 Jun 2024 09:07:57 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.176]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4W3ySr4YRMz4x9Pq; Wed, 19 Jun
	2024 09:07:56 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	FE.4B.19174.CEF92766; Wed, 19 Jun 2024 18:07:56 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20240619071833epcas5p274ddb249a75e4b3006b48d1378071923~aVq4c1ocY1346013460epcas5p2A;
	Wed, 19 Jun 2024 07:18:33 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240619071833epsmtrp1eda7eeff51686b137820f5448d5d48b7~aVq4b7IKs3024630246epsmtrp1I;
	Wed, 19 Jun 2024 07:18:33 +0000 (GMT)
X-AuditID: b6c32a50-b33ff70000004ae6-1f-66729fec1566
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	BD.4C.19057.94682766; Wed, 19 Jun 2024 16:18:33 +0900 (KST)
Received: from testpc11818.samsungds.net (unknown [109.105.118.18]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240619071832epsmtip17a46acced9f8bb724aa2dc9305aff09a~aVq3dy3Ld1985219852epsmtip1E;
	Wed, 19 Jun 2024 07:18:32 +0000 (GMT)
From: hexue <xue01.he@samsung.com>
To: axboe@kernel.dk
Cc: asml.silence@gmail.com, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org, hexue <xue01.he@samsung.com>
Subject: [PATCH v5] Subject: io_uring: releasing CPU resources when polling
Date: Wed, 19 Jun 2024 15:18:26 +0800
Message-Id: <20240619071826.1553543-1-xue01.he@samsung.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrHKsWRmVeSWpSXmKPExsWy7bCmhu6b+UVpBjPvyFrMWbWN0WL13X42
	i3et51gsfnXfZbS4vGsOm8XZCR9YLbounGJzYPfYOesuu8fls6UefVtWMXp83iQXwBKVbZOR
	mpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDdICSQlliTilQ
	KCCxuFhJ386mKL+0JFUhI7+4xFYptSAlp8CkQK84Mbe4NC9dLy+1xMrQwMDIFKgwITtjwq2P
	TAU/PCtufvzJ3MD427qLkZNDQsBE4vmTRYwgtpDAHkaJS5/8uhi5gOxPjBIfL35lhHC+MUpM
	WfeKFabj96aJ7BCJvYwS65/dZ4ZwfjACzeplB6liE1CS2L/lA9hcEQFhif0drSwgNrNAkcTr
	mdvAJgkLeEv8eQMxlUVAVaL10HGwXl4Ba4mXf3cyQWyTl7jZtZ8ZIi4ocXLmE6g58hLNW2eD
	LZYQOMQusa75AiNEg4vExCnvmCFsYYlXx7ewQ9hSEi/726DsfInJ39dD1ddIrNv8jgXCtpb4
	d2UPkM0BtEBTYv0ufYiwrMTUU+uYIPbySfT+fgJ1G6/EjnkwtpLEkiMroEZKSPyesAgaWh4S
	O6bNgoZvrMTMlftYJzDKz0Lyziwk78xC2LyAkXkVo1RqQXFuemqyaYGhbl5qOTxmk/NzNzGC
	E6JWwA7G1Rv+6h1iZOJgPMQowcGsJML7vKsoTYg3JbGyKrUoP76oNCe1+BCjKTCQJzJLiSbn
	A1NyXkm8oYmlgYmZmZmJpbGZoZI47+vWuSlCAumJJanZqakFqUUwfUwcnFINTBrH8zPuCHie
	4eSpOClZ7Ze033b2Pc+dJ9q/7H/NdsGMYZNsTvj35PdKDMeTtvZMV4n2cTvZtfgR/4yXX5kP
	GJRsYPW9UCGecnWp6Z6PWts+/bx1bHvEXsbPd1bceH12+d0rJzdZZC+6fNkg2kIr2++ra6Ps
	t71ad8Qn1L9aFWH/YavK9JrDea+MFfsFuta6TNnrfTPUhvV4xkqVPlfZGc+f/7ly2WVu4PqQ
	aXnhHlzvFY763ZsTz/3yZGPNDV7hD2rLuj7JR+d2xITr/POpfD9RNzrkR0fguz1TH1zoOtKX
	/2D/3Euep/qzyn0inub3Ntk1PjO903zzSDFv8AzjJuWaox86nEyCz7w7cr9bYpYSS3FGoqEW
	c1FxIgBm5KRhEQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBLMWRmVeSWpSXmKPExsWy7bCSnK5nW1GawbrPchZzVm1jtFh9t5/N
	4l3rORaLX913GS0u75rDZnF2wgdWi64Lp9gc2D12zrrL7nH5bKlH35ZVjB6fN8kFsERx2aSk
	5mSWpRbp2yVwZUy49ZGp4Idnxc2PP5kbGH9bdzFyckgImEj83jSRvYuRi0NIYDejxNKF69kg
	EhISOx79YYWwhSVW/nvODmILCXxjlDhxUh/EZhNQkti/5QMjiC0CVLO/o5UFxGYWKJN4t3I9
	WK+wgLfEnzevwGwWAVWJ1kPHwebwClhLvPy7kwlivrzEza79zBBxQYmTM59AzZGXaN46m3kC
	I98sJKlZSFILGJlWMUqmFhTnpucWGxYY5aWW6xUn5haX5qXrJefnbmIEB6aW1g7GPas+6B1i
	ZOJgPMQowcGsJMLrNC0vTYg3JbGyKrUoP76oNCe1+BCjNAeLkjjvt9e9KUIC6YklqdmpqQWp
	RTBZJg5OqQYmo6WfS67zCb+sjBf/9629U+7WJotX4hfyti781hC6ctfp3yXyQoWqZUfM2eqK
	3jp3H9DseTj54zmG+M/TvWQsqv0WporlLTdrUNj/NrLbedfzb7HH8sVLq9eJfEgPYeGpW1A+
	r459uyhP07x3D5iU7jirqMkIuXBoBKZwuLyZovJtcsb2LXySJ5bOYXbdrltdX9vdz3XjEDsn
	x/bJq4RbptZ15XCsnFS2Xb4wK+lKnXH6ur6dG/axBWft1hE+zJ8lk7R2X9SbiivhB09a2Jfa
	7Pg7Z+b+jcFeW94Jbe1+efzLvs2O9aePFtktOL00zbXIdz5LbOhiZ2njPtfLekkaH+88cztr
	86/z+g8LO0MlluKMREMt5qLiRADUvsRLuwIAAA==
X-CMS-MailID: 20240619071833epcas5p274ddb249a75e4b3006b48d1378071923
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240619071833epcas5p274ddb249a75e4b3006b48d1378071923
References: <CGME20240619071833epcas5p274ddb249a75e4b3006b48d1378071923@epcas5p2.samsung.com>

io_uring use polling mode could improve the IO performence, but it will
spend 100% of CPU resources to do polling.

This set a signal "IORING_SETUP_HY_POLL" to application, aim to provide
a interface for user to enable a new hybrid polling at io_uring level.

A new hybrid poll is implemented on the io_uring layer. Once IO issued,
it will not polling immediately, but block first and re-run before IO
complete, then poll to reap IO. This poll function could keep polling
high performance and free up some CPU resources.

we considered about complex situations, such as multi-concurrency,
different processing speed of multi-disk, etc.

Test results:
set 8 poll queues, fio-3.35, Gen5 SSD, 8 CPU VM

per CPU utilization:
    read(128k, QD64, 1Job)     53%   write(128k, QD64, 1Job)     45%
    randread(4k, QD64, 16Job)  70%   randwrite(4k, QD64, 16Job)  16%
performance reduction:
    read  0.92%     write  0.92%    randread  1.61%    randwrite  0%

--

changes since v4:
- Rewrote the commit
- Update the test results
- Reorganized the code basd on 6.11

changes since v3:
- Simplified the commit
- Add some comments on code

changes since v2:
- Modified some formatting errors
- Move judgement to poll path

changes since v1:
- Extend hybrid poll to async polled io

Signed-off-by: hexue <xue01.he@samsung.com>
---
 include/linux/io_uring_types.h |  14 ++++
 include/uapi/linux/io_uring.h  |   1 +
 io_uring/io_uring.c            |   4 +-
 io_uring/io_uring.h            |   3 +
 io_uring/rw.c                  | 115 ++++++++++++++++++++++++++++++++-
 5 files changed, 135 insertions(+), 2 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 91224bbcfa73..8eab99c4122e 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -226,6 +226,11 @@ struct io_alloc_cache {
 	size_t			elem_size;
 };
 
+struct iopoll_info {
+	long		last_runtime;
+	long		last_irqtime;
+};
+
 struct io_ring_ctx {
 	/* const or read-mostly hot data */
 	struct {
@@ -428,6 +433,7 @@ struct io_ring_ctx {
 	unsigned short			n_sqe_pages;
 	struct page			**ring_pages;
 	struct page			**sqe_pages;
+	struct xarray		poll_array;
 };
 
 struct io_tw_state {
@@ -591,6 +597,12 @@ static inline void io_kiocb_cmd_sz_check(size_t cmd_sz)
 )
 #define cmd_to_io_kiocb(ptr)	((struct io_kiocb *) ptr)
 
+struct hy_poll_time {
+	int		poll_state;
+	struct timespec64		iopoll_start;
+	struct timespec64		iopoll_end;
+};
+
 struct io_kiocb {
 	union {
 		/*
@@ -665,6 +677,8 @@ struct io_kiocb {
 		u64			extra1;
 		u64			extra2;
 	} big_cqe;
+    /* for hybrid iopoll */
+	struct hy_poll_time		*hy_poll;
 };
 
 struct io_overflow_cqe {
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 994bf7af0efe..ef32ec319d1f 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -199,6 +199,7 @@ enum io_uring_sqe_flags_bit {
  * Removes indirection through the SQ index array.
  */
 #define IORING_SETUP_NO_SQARRAY		(1U << 16)
+#define IORING_SETUP_HY_POLL	(1U << 17)
 
 enum io_uring_op {
 	IORING_OP_NOP,
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 816e93e7f949..a1015ce6dde7 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -299,6 +299,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 		goto err;
 
 	ctx->flags = p->flags;
+	xa_init(&ctx->poll_array);
 	atomic_set(&ctx->cq_wait_nr, IO_CQ_WAKE_INIT);
 	init_waitqueue_head(&ctx->sqo_sq_wait);
 	INIT_LIST_HEAD(&ctx->sqd_list);
@@ -2679,6 +2680,7 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	kfree(ctx->cancel_table.hbs);
 	kfree(ctx->cancel_table_locked.hbs);
 	xa_destroy(&ctx->io_bl_xa);
+	xa_destroy(&ctx->poll_array);
 	kfree(ctx);
 }
 
@@ -3637,7 +3639,7 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 			IORING_SETUP_SQE128 | IORING_SETUP_CQE32 |
 			IORING_SETUP_SINGLE_ISSUER | IORING_SETUP_DEFER_TASKRUN |
 			IORING_SETUP_NO_MMAP | IORING_SETUP_REGISTERED_FD_ONLY |
-			IORING_SETUP_NO_SQARRAY))
+			IORING_SETUP_NO_SQARRAY | IORING_SETUP_HY_POLL))
 		return -EINVAL;
 
 	return io_uring_create(entries, &p, params);
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 624ca9076a50..665093c048ba 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -148,6 +148,9 @@ static inline void io_submit_flush_completions(struct io_ring_ctx *ctx)
 		__io_submit_flush_completions(ctx);
 }
 
+/* if sleep time less than 1us, then do not do the schedule op */
+#define MIN_SCHETIME 1000
+
 #define io_for_each_link(pos, head) \
 	for (pos = (head); pos; pos = pos->link)
 
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 1a2128459cb4..48b162becfa2 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -772,6 +772,46 @@ static bool need_complete_io(struct io_kiocb *req)
 		S_ISBLK(file_inode(req->file)->i_mode);
 }
 
+static void init_hybrid_poll(struct io_ring_ctx *ctx, struct io_kiocb *req)
+{
+	/*
+	 * In multiple concurrency, a thread may operate several files
+	 * under different file systems, the inode numbers may be
+	 * duplicated. Each device has a different IO command processing
+	 * capability, so using device number to record the running time
+	 * of device
+	 */
+	u32 index = req->file->f_inode->i_rdev;
+	struct iopoll_info *entry = xa_load(&ctx->poll_array, index);
+	struct hy_poll_time *hpt = kmalloc(sizeof(struct hy_poll_time), GFP_KERNEL);
+
+	/* if alloc fail, go to regular poll */
+	if (!hpt) {
+		ctx->flags &= ~IORING_SETUP_HY_POLL;
+		return;
+	}
+	hpt->poll_state = 0;
+	req->hy_poll = hpt;
+
+	if (!entry) {
+		entry = kmalloc(sizeof(struct iopoll_info), GFP_KERNEL);
+		if (!entry) {
+			ctx->flags &= ~IORING_SETUP_HY_POLL;
+			return;
+		}
+		entry->last_runtime = 0;
+		entry->last_irqtime = 0;
+		xa_store(&ctx->poll_array, index, entry, GFP_KERNEL);
+	}
+
+	/*
+	 * Here we need nanosecond timestamps, some ways of reading
+	 * timestamps directly are only accurate to microseconds, so
+	 * there's no better alternative here for now
+	 */
+	ktime_get_ts64(&hpt->iopoll_start);
+}
+
 static int io_rw_init_file(struct io_kiocb *req, fmode_t mode)
 {
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
@@ -809,6 +849,8 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode)
 		kiocb->ki_flags |= IOCB_HIPRI;
 		kiocb->ki_complete = io_complete_rw_iopoll;
 		req->iopoll_completed = 0;
+		if (ctx->flags & IORING_SETUP_HY_POLL)
+			init_hybrid_poll(ctx, req);
 	} else {
 		if (kiocb->ki_flags & IOCB_HIPRI)
 			return -EINVAL;
@@ -1106,6 +1148,75 @@ void io_rw_fail(struct io_kiocb *req)
 	io_req_set_res(req, res, req->cqe.flags);
 }
 
+static void io_delay(struct hy_poll_time *hpt, struct iopoll_info *entry)
+{
+	struct hrtimer_sleeper timer;
+	struct timespec64 tc, oldtc;
+	enum hrtimer_mode mode;
+	ktime_t kt;
+	long sleep_ti;
+
+	if (hpt->poll_state == 1)
+		return;
+
+	if (entry->last_runtime <= entry->last_irqtime)
+		return;
+
+	/*
+	 * Avoid excessive scheduling time affecting performance
+	 * by using only 25 per cent of the remaining time
+	 */
+	sleep_ti = (entry->last_runtime - entry->last_irqtime) / 4;
+
+	/*
+	 * If the time available for sleep is too short, i.e. the
+	 * totle running time and the context switching loss time
+	 * are very close to each other, the scheduling operation
+	 * is not performed to avoid increasing latency
+	 */
+	if (sleep_ti < MIN_SCHETIME)
+		return;
+
+	ktime_get_ts64(&oldtc);
+	kt = ktime_set(0, sleep_ti);
+	hpt->poll_state = 1;
+
+	mode = HRTIMER_MODE_REL;
+	hrtimer_init_sleeper_on_stack(&timer, CLOCK_MONOTONIC, mode);
+	hrtimer_set_expires(&timer.timer, kt);
+	set_current_state(TASK_UNINTERRUPTIBLE);
+	hrtimer_sleeper_start_expires(&timer, mode);
+
+	if (timer.task)
+		io_schedule();
+
+	hrtimer_cancel(&timer.timer);
+	mode = HRTIMER_MODE_ABS;
+	__set_current_state(TASK_RUNNING);
+	destroy_hrtimer_on_stack(&timer.timer);
+
+	ktime_get_ts64(&tc);
+	entry->last_irqtime = tc.tv_nsec - oldtc.tv_nsec - sleep_ti;
+}
+
+static int io_uring_hybrid_poll(struct io_kiocb *req,
+				struct io_comp_batch *iob, unsigned int poll_flags)
+{
+	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
+	struct io_ring_ctx *ctx = req->ctx;
+	struct hy_poll_time *hpt = req->hy_poll;
+	u32 index = req->file->f_inode->i_rdev;
+	struct iopoll_info *entry = xa_load(&ctx->poll_array, index);
+	int ret;
+
+	io_delay(hpt, entry);
+	ret = req->file->f_op->iopoll(&rw->kiocb, iob, poll_flags);
+
+	ktime_get_ts64(&hpt->iopoll_end);
+	entry->last_runtime = hpt->iopoll_end.tv_nsec - hpt->iopoll_start.tv_nsec;
+	return ret;
+}
+
 int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 {
 	struct io_wq_work_node *pos, *start, *prev;
@@ -1133,7 +1244,9 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 		if (READ_ONCE(req->iopoll_completed))
 			break;
 
-		if (req->opcode == IORING_OP_URING_CMD) {
+		if (ctx->flags & IORING_SETUP_HY_POLL) {
+			ret = io_uring_hybrid_poll(req, &iob, poll_flags);
+		} else if (req->opcode == IORING_OP_URING_CMD) {
 			struct io_uring_cmd *ioucmd;
 
 			ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
-- 
2.40.1


