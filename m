Return-Path: <io-uring+bounces-4299-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id AB2479B8DE9
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 10:32:46 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2F1331F231B9
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 09:32:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7771157476;
	Fri,  1 Nov 2024 09:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="QtFn5mvp"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73D1D158845
	for <io-uring@vger.kernel.org>; Fri,  1 Nov 2024 09:32:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730453559; cv=none; b=esd/405FUZ44IHm5SfJtphGTcspTDnvaoD0/X+JKgMNLbOuVy64xCBfHly44p9T7yqVNngg5CWZ70hJfCtrEOS0w+E/8rZ9k3/Zg08Pr36PVK6rGejZfrxOji4GrOPveiFLWRYjOHxR0F9+vAoKa5bCUmdEXWNe25598/PGv7qI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730453559; c=relaxed/simple;
	bh=Z1C9IS6DtyqUDr/deB7GoU4OCJCe7kHRGfzDF+yLLT8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:MIME-Version:
	 Content-Type:References; b=FvGSzrrfmTNzYi6RlmSfjfdFVaRhYiEXyJSFPy2g0zj8EU9aWbauTV7ve7hnDzuwDw6GXvSvihCvOGHXEXFRZGSWhNwpcuH3m9pbq/kQMCdoLp4KhLHMZyu2mMyXDLF6E8VPhZy/YQr41iDru/fs3sFVdo76GrssHTpkrx3q7iM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=QtFn5mvp; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20241101093233epoutp019304d47090b1dc5951cf59687ff8bffe~Dzlarn3jo1960919609epoutp01p
	for <io-uring@vger.kernel.org>; Fri,  1 Nov 2024 09:32:33 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20241101093233epoutp019304d47090b1dc5951cf59687ff8bffe~Dzlarn3jo1960919609epoutp01p
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1730453553;
	bh=QhYGaAi2ZczsV6BtaVaFakG5WfEnqVIU4LVh5dxCyew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QtFn5mvp9Gc/LqJS9mdoPBaMwT+dUYAs+FRCle3T8TL+jzIDTpInp9bksZd/S6iQ+
	 j+NaJjcDikIT1q+Q35wcFyH+pkyCRcw1BNU+S16UChQTFt1Qpg025SsjDSCBFk/KpL
	 LooOSmBbFCvKEWsP95f7+fDrjOOxPtN+h7XLtWu8=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20241101093233epcas5p41efc1b400dd4abf205ac67234db4a0c9~DzlabwjkR3265932659epcas5p4C;
	Fri,  1 Nov 2024 09:32:33 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.180]) by
	epsnrtp2.localdomain (Postfix) with ESMTP id 4Xfwcv51Txz4x9Q0; Fri,  1 Nov
	2024 09:32:31 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	00.C2.09800.F20A4276; Fri,  1 Nov 2024 18:32:31 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20241101092009epcas5p117843070fa5edd377469f13af388fc06~Dzal6ytn21956919569epcas5p1M;
	Fri,  1 Nov 2024 09:20:09 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20241101092009epsmtrp18300544981917112b047f55b4ec513c0~Dzal51GQm1706517065epsmtrp1E;
	Fri,  1 Nov 2024 09:20:09 +0000 (GMT)
X-AuditID: b6c32a4b-4a7fa70000002648-70-6724a02f8f24
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	65.8E.18937.94D94276; Fri,  1 Nov 2024 18:20:09 +0900 (KST)
Received: from testpc11818.samsungds.net (unknown [109.105.118.18]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20241101092008epsmtip2e1f4edc1b71e89348cd6da42a5993ecd~Dzak0PNQk0193801938epsmtip2v;
	Fri,  1 Nov 2024 09:20:08 +0000 (GMT)
From: hexue <xue01.he@samsung.com>
To: axboe@kernel.dk, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, hexue
	<xue01.he@samsung.com>
Subject: [PATCH v9 1/1] io_uring: releasing CPU resources when polling
Date: Fri,  1 Nov 2024 17:19:57 +0800
Message-Id: <20241101091957.564220-2-xue01.he@samsung.com>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20241101091957.564220-1-xue01.he@samsung.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupgk+LIzCtJLcpLzFFi42LZdlhTU1d/gUq6we9uZYs5q7YxWqy+289m
	8a71HIvFr+67jBaXd81hszg74QOrRdeFU2wO7B47Z91l97h8ttSjb8sqRo/Pm+QCWKKybTJS
	E1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOADlBSKEvMKQUK
	BSQWFyvp29kU5ZeWpCpk5BeX2CqlFqTkFJgU6BUn5haX5qXr5aWWWBkaGBiZAhUmZGec2r6G
	pWCyQ8WE45oNjBtMuhg5OSQETCT2T5vN2sXIxSEksJtRYtGGl+wQzidGiW9v9rDAOXMW72WC
	ael8uAyqaiejxNqf/cwQzg9GiacbXjKDVLEJKEns3/KBEcQWEdCWeP14KtAoDg5mgSiJF2u5
	QcLCAm4Svx6vZQGxWQRUJVpuTmUHKeEVsJI4+iQSYpe8xM2u/WATOQWsJV6/uANWzisgKHFy
	5hMwmxmopnnrbLATJARusUtMbT3PAtHsInH39TU2CFtY4tXxLewQtpTEy/42KDtfYvL39YwQ
	do3Eus3voHqtJf5d2QN1sqbE+l36EGFZiamn1jFB7OWT6P39BBomvBI75sHYShJLjqyAGikh
	8XvCIlYI20OiYdp0NkhQ9TFKbHzwjXkCo8IsJP/MQvLPLITVCxiZVzFKphYU56anFpsWGOel
	lsPjODk/dxMjOElqee9gfPTgg94hRiYOxkOMEhzMSiK8HwqU04V4UxIrq1KL8uOLSnNSiw8x
	mgLDeyKzlGhyPjBN55XEG5pYGpiYmZmZWBqbGSqJ875unZsiJJCeWJKanZpakFoE08fEwSnV
	wPTmi1fG48ri3JbfTw87trySUdb/oXj615W/qZMYLDKfveBfkddSayJeVBspXmMfpzb5zsOb
	FmYson8yGj2XNr5VK1ZumvZz/4e4KgYui/Yjbr6HFqi+3FLxVI77Udi0zV7NZf+WVIWujjvM
	lRt/hTsm9Pja2kK1oM8ck64GLQ285vB6bqbO47lODctsKotvmS5jjvr8rlRbfnGI9sL43xJ3
	5hy2PJ+5RXxla8eLgzpsYtMSG067HJi7yitpGdfDgEnhp398MPTmOxhja+16UvTJW769nVad
	Ht7rTPMetT49Xq+iUxMRO6XX99VsseavOQ+bj65Tl427vLnrll73941/Vq4/WeVyLSxyZ1J9
	hRJLcUaioRZzUXEiAM29pdYbBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrFLMWRmVeSWpSXmKPExsWy7bCSvK7nXJV0gwd75SzmrNrGaLH6bj+b
	xbvWcywWv7rvMlpc3jWHzeLshA+sFl0XTrE5sHvsnHWX3ePy2VKPvi2rGD0+b5ILYInisklJ
	zcksSy3St0vgyji1fQ1LwWSHignHNRsYN5h0MXJySAiYSHQ+XMbexcjFISSwnVHi/oHvbBAJ
	CYkdj/6wQtjCEiv/PYcq+sYosWTGFRaQBJuAksT+LR8Yuxg5OEQEdCUa7yqAhJkFYiQ+7JnA
	DmILC7hJ/Hq8FqycRUBVouXmVHaQcl4BK4mjTyIhxstL3OzazwxicwpYS7x+cQesXAio5OnD
	tYwgNq+AoMTJmU9YIMbLSzRvnc08gVFgFpLULCSpBYxMqxhFUwuKc9NzkwsM9YoTc4tL89L1
	kvNzNzGCg1craAfjsvV/9Q4xMnEwHmKU4GBWEuH9UKCcLsSbklhZlVqUH19UmpNafIhRmoNF
	SZxXOaczRUggPbEkNTs1tSC1CCbLxMEp1cCUrDV36p4GsSOyt2Zd1Tra+ant27Gr17eY33u4
	8aLzm6vztrr9y09QyS0r5k/1tPwY//HnVN2PkftrnZzZj/fc4bFPThNkyNZoK7lcUhWRa8bG
	e0vvU5dkrF0KV6Ho9x32F82dt4e/6b/2dcVH4e+Ziya01iulPPt1I2ziJ0f9xBC3lZFq0zO2
	7jis/uWc39pVH5JUViXlzjY4r/reeb7L5guBq9IvdP6+GdZoPyvPpuFjgLZlbu2FIs/Vxsru
	yd/MZ5vHJryoEmPoMq3JYnwU6vyR+ZmRe5u+XpuXhxm7znrfv8LTjLlkU7+oRqyzqJrx+JRV
	wrTbvBNmOxcEL5z6s3ne7CMHokNiFf0/aCqxFGckGmoxFxUnAgDOXqR0zQIAAA==
X-CMS-MailID: 20241101092009epcas5p117843070fa5edd377469f13af388fc06
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241101092009epcas5p117843070fa5edd377469f13af388fc06
References: <20241101091957.564220-1-xue01.he@samsung.com>
	<CGME20241101092009epcas5p117843070fa5edd377469f13af388fc06@epcas5p1.samsung.com>

A new hybrid poll is implemented on the io_uring layer. Once IO issued,
it will not polling immediately, but block first and re-run before IO
complete, then poll to reap IO. This poll function could be a suboptimal
solution when running on a single thread, it offers the performance lower
than regular polling but higher than IRQ, and CPU utilization is also lower
than polling.

Signed-off-by: hexue <xue01.he@samsung.com>
---
 include/linux/io_uring_types.h | 19 ++++++-
 include/uapi/linux/io_uring.h  |  3 ++
 io_uring/io_uring.c            |  8 ++-
 io_uring/rw.c                  | 92 ++++++++++++++++++++++++++++++----
 4 files changed, 108 insertions(+), 14 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 4b9ba523978d..4a85a823b888 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -302,6 +302,11 @@ struct io_ring_ctx {
 		 * ->uring_cmd() by io_uring_cmd_insert_cancelable()
 		 */
 		struct hlist_head	cancelable_uring_cmd;
+		/*
+		 * For Hybrid IOPOLL, runtime in hybrid polling, without
+		 * scheduling time
+		 */
+		u64					hybrid_poll_time;
 	} ____cacheline_aligned_in_smp;
 
 	struct {
@@ -447,6 +452,7 @@ enum {
 	REQ_F_LINK_TIMEOUT_BIT,
 	REQ_F_NEED_CLEANUP_BIT,
 	REQ_F_POLLED_BIT,
+	REQ_F_HYBRID_IOPOLL_STATE_BIT,
 	REQ_F_BUFFER_SELECTED_BIT,
 	REQ_F_BUFFER_RING_BIT,
 	REQ_F_REISSUE_BIT,
@@ -506,6 +512,8 @@ enum {
 	REQ_F_NEED_CLEANUP	= IO_REQ_FLAG(REQ_F_NEED_CLEANUP_BIT),
 	/* already went through poll handler */
 	REQ_F_POLLED		= IO_REQ_FLAG(REQ_F_POLLED_BIT),
+	/* every req only blocks once in hybrid poll */
+	REQ_F_IOPOLL_STATE        = IO_REQ_FLAG(REQ_F_HYBRID_IOPOLL_STATE_BIT),
 	/* buffer already selected */
 	REQ_F_BUFFER_SELECTED	= IO_REQ_FLAG(REQ_F_BUFFER_SELECTED_BIT),
 	/* buffer selected from ring, needs commit */
@@ -643,8 +651,15 @@ struct io_kiocb {
 	atomic_t			refs;
 	bool				cancel_seq_set;
 	struct io_task_work		io_task_work;
-	/* for polled requests, i.e. IORING_OP_POLL_ADD and async armed poll */
-	struct hlist_node		hash_node;
+	union {
+		/*
+		 * for polled requests, i.e. IORING_OP_POLL_ADD and async armed
+		 * poll
+		 */
+		struct hlist_node	hash_node;
+		/* For IOPOLL setup queues, with hybrid polling */
+		u64                     iopoll_start;
+	};
 	/* internal polling, see IORING_FEAT_FAST_POLL */
 	struct async_poll		*apoll;
 	/* opcode allocated if it needs to store data for async defer */
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 1fe79e750470..ddd6e42b134d 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -200,6 +200,9 @@ enum io_uring_sqe_flags_bit {
  */
 #define IORING_SETUP_NO_SQARRAY		(1U << 16)
 
+/* Use hybrid poll in iopoll process */
+#define IORING_SETUP_HYBRID_IOPOLL	(1U << 17)
+
 enum io_uring_op {
 	IORING_OP_NOP,
 	IORING_OP_READV,
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 4199fbe6ce13..ed131fc824a0 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -301,6 +301,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 		goto err;
 
 	ctx->flags = p->flags;
+	ctx->hybrid_poll_time = LLONG_MAX;
 	atomic_set(&ctx->cq_wait_nr, IO_CQ_WAKE_INIT);
 	init_waitqueue_head(&ctx->sqo_sq_wait);
 	INIT_LIST_HEAD(&ctx->sqd_list);
@@ -3545,6 +3546,11 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 	ctx->clockid = CLOCK_MONOTONIC;
 	ctx->clock_offset = 0;
 
+	/* HYBRID_IOPOLL only valid with IOPOLL */
+	if ((ctx->flags & (IORING_SETUP_IOPOLL|IORING_SETUP_HYBRID_IOPOLL)) ==
+			IORING_SETUP_HYBRID_IOPOLL)
+		return -EINVAL;
+
 	if ((ctx->flags & IORING_SETUP_DEFER_TASKRUN) &&
 	    !(ctx->flags & IORING_SETUP_IOPOLL) &&
 	    !(ctx->flags & IORING_SETUP_SQPOLL))
@@ -3724,7 +3730,7 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 			IORING_SETUP_SQE128 | IORING_SETUP_CQE32 |
 			IORING_SETUP_SINGLE_ISSUER | IORING_SETUP_DEFER_TASKRUN |
 			IORING_SETUP_NO_MMAP | IORING_SETUP_REGISTERED_FD_ONLY |
-			IORING_SETUP_NO_SQARRAY))
+			IORING_SETUP_NO_SQARRAY | IORING_SETUP_HYBRID_IOPOLL))
 		return -EINVAL;
 
 	return io_uring_create(entries, &p, params);
diff --git a/io_uring/rw.c b/io_uring/rw.c
index f023ff49c688..340dc4b7b84f 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -808,6 +808,11 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode, int rw_type)
 		kiocb->ki_flags |= IOCB_HIPRI;
 		kiocb->ki_complete = io_complete_rw_iopoll;
 		req->iopoll_completed = 0;
+		if (ctx->flags & IORING_SETUP_HYBRID_IOPOLL) {
+			/* make sure every req only blocks once*/
+			req->flags &= ~REQ_F_IOPOLL_STATE;
+			req->iopoll_start = ktime_get_ns();
+		}
 	} else {
 		if (kiocb->ki_flags & IOCB_HIPRI)
 			return -EINVAL;
@@ -1112,6 +1117,78 @@ void io_rw_fail(struct io_kiocb *req)
 	io_req_set_res(req, res, req->cqe.flags);
 }
 
+static int io_uring_classic_poll(struct io_kiocb *req, struct io_comp_batch *iob,
+				unsigned int poll_flags)
+{
+	struct file *file = req->file;
+
+	if (req->opcode == IORING_OP_URING_CMD) {
+		struct io_uring_cmd *ioucmd;
+
+		ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
+		return file->f_op->uring_cmd_iopoll(ioucmd, iob, poll_flags);
+	} else {
+		struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
+
+		return file->f_op->iopoll(&rw->kiocb, iob, poll_flags);
+	}
+}
+
+static u64 io_hybrid_iopoll_delay(struct io_ring_ctx *ctx, struct io_kiocb *req)
+{
+	struct hrtimer_sleeper timer;
+	enum hrtimer_mode mode;
+	ktime_t kt;
+	u64 sleep_time;
+
+	if (req->flags & REQ_F_IOPOLL_STATE)
+		return 0;
+
+	if (ctx->hybrid_poll_time == LLONG_MAX)
+		return 0;
+
+	/* Using half the running time to do schedule */
+	sleep_time = ctx->hybrid_poll_time / 2;
+
+	kt = ktime_set(0, sleep_time);
+	req->flags |= REQ_F_IOPOLL_STATE;
+
+	mode = HRTIMER_MODE_REL;
+	hrtimer_init_sleeper_on_stack(&timer, CLOCK_MONOTONIC, mode);
+	hrtimer_set_expires(&timer.timer, kt);
+	set_current_state(TASK_INTERRUPTIBLE);
+	hrtimer_sleeper_start_expires(&timer, mode);
+
+	if (timer.task)
+		io_schedule();
+
+	hrtimer_cancel(&timer.timer);
+	__set_current_state(TASK_RUNNING);
+	destroy_hrtimer_on_stack(&timer.timer);
+	return sleep_time;
+}
+
+static int io_uring_hybrid_poll(struct io_kiocb *req,
+				struct io_comp_batch *iob, unsigned int poll_flags)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	u64 runtime, sleep_time;
+	int ret;
+
+	sleep_time = io_hybrid_iopoll_delay(ctx, req);
+	ret = io_uring_classic_poll(req, iob, poll_flags);
+	runtime = ktime_get_ns() - req->iopoll_start - sleep_time;
+
+	/*
+	 * Use minimum sleep time if we're polling devices with different
+	 * latencies. We could get more completions from the faster ones.
+	 */
+	if (ctx->hybrid_poll_time > runtime)
+		ctx->hybrid_poll_time = runtime;
+
+	return ret;
+}
+
 int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 {
 	struct io_wq_work_node *pos, *start, *prev;
@@ -1128,7 +1205,6 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 
 	wq_list_for_each(pos, start, &ctx->iopoll_list) {
 		struct io_kiocb *req = container_of(pos, struct io_kiocb, comp_list);
-		struct file *file = req->file;
 		int ret;
 
 		/*
@@ -1139,17 +1215,11 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 		if (READ_ONCE(req->iopoll_completed))
 			break;
 
-		if (req->opcode == IORING_OP_URING_CMD) {
-			struct io_uring_cmd *ioucmd;
-
-			ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
-			ret = file->f_op->uring_cmd_iopoll(ioucmd, &iob,
-								poll_flags);
-		} else {
-			struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
+		if (ctx->flags & IORING_SETUP_HYBRID_IOPOLL)
+			ret = io_uring_hybrid_poll(req, &iob, poll_flags);
+		else
+			ret = io_uring_classic_poll(req, &iob, poll_flags);
 
-			ret = file->f_op->iopoll(&rw->kiocb, &iob, poll_flags);
-		}
 		if (unlikely(ret < 0))
 			return ret;
 		else if (ret)
-- 
2.40.1


