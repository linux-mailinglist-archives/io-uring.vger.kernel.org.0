Return-Path: <io-uring+bounces-2464-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BBC6F92B269
	for <lists+io-uring@lfdr.de>; Tue,  9 Jul 2024 10:43:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 71B2F2823E2
	for <lists+io-uring@lfdr.de>; Tue,  9 Jul 2024 08:43:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EED7915358A;
	Tue,  9 Jul 2024 08:42:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="b2Pf43Oe"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE92C153815
	for <io-uring@vger.kernel.org>; Tue,  9 Jul 2024 08:42:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720514562; cv=none; b=WB+Y365nmPDoQGNKvm2FTwToM/m6xToeUOs14ars0U2NX9ZEJjw5peenNHcQKouOZkI0uDgyJpIPGNDivlS9jt/PlK42ekmvhezaBXenCksT6we1MrIoNTdsU0itt690jp5n+V+j/JNj+BThxle7C9eea10SVRjLaG6FMj9VMig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720514562; c=relaxed/simple;
	bh=6mFIbIDQBlr+HpPKVY9P02FJpcGJ4jVepU8lmHx49Qg=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=XZr1v6tHulb5UPDVca9PYq26KgXATsmbUTXIwzovJVYLuNv2dwkRenkiiXRD+jhKo/vf8Tt6BoPlk0ureCs0dIZixSEO8fNNGXo7eCMY3QYTcHjGQj7cRpUoA6J5SvEHlz0V51uLNVL33+1mzUKNmuFErV+ZSPYnujqcm0WzV4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=b2Pf43Oe; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240709084231epoutp041e64d36e1da55b2462a2e62b01c79020~gft6Ju-a81924019240epoutp04k
	for <io-uring@vger.kernel.org>; Tue,  9 Jul 2024 08:42:31 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240709084231epoutp041e64d36e1da55b2462a2e62b01c79020~gft6Ju-a81924019240epoutp04k
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1720514551;
	bh=gWa4sX4367N7SDdiZRThtehT9+wu6QZN+lnJvmGJ73g=;
	h=From:To:Cc:Subject:Date:References:From;
	b=b2Pf43Oer8pQkK60rFL2UvfnpkIjg35YBH6jxgXVcbUc+at0jvzxXQDOLO1bUsrs9
	 BhEeV4YMZliXl6kiPfpB6xdQJ442RGvt+M+kRrvqxX4Hi7vC9vHS+oSuEuS5ODhELa
	 Doh7ggtDOfzIbhFLcO7JGciaygIFS6wA9TttbA3w=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20240709084231epcas5p3ff11b6712821ca88c3020cf894ea5a20~gft55XoQh0827908279epcas5p3Y;
	Tue,  9 Jul 2024 08:42:31 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.174]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4WJDyG29yfz4x9Q8; Tue,  9 Jul
	2024 08:42:30 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	74.78.11095.5F7FC866; Tue,  9 Jul 2024 17:42:29 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20240709081627epcas5p3033c01e4816310394f8efbbd4b43cfd0~gfXIvaH7z0568705687epcas5p3m;
	Tue,  9 Jul 2024 08:16:27 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240709081627epsmtrp276c2c18632897965a144ab9d9c7bc31e~gfXIup_SQ0608406084epsmtrp2C;
	Tue,  9 Jul 2024 08:16:27 +0000 (GMT)
X-AuditID: b6c32a49-3c3ff70000012b57-3c-668cf7f5abba
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	9B.88.07412.AD1FC866; Tue,  9 Jul 2024 17:16:26 +0900 (KST)
Received: from testpc11818.samsungds.net (unknown [109.105.118.18]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240709081625epsmtip1e2afe68191ca8c444baac2d6c5df3cec~gfXHt01KE3067830678epsmtip1e;
	Tue,  9 Jul 2024 08:16:25 +0000 (GMT)
From: hexue <xue01.he@samsung.com>
To: axboe@kernel.dk
Cc: asml.silence@gmail.com, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org, hexue <xue01.he@samsung.com>
Subject: [PATCH v6] io_uring: releasing CPU resources when polling
Date: Tue,  9 Jul 2024 16:16:19 +0800
Message-Id: <20240709081619.3177418-1-xue01.he@samsung.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDKsWRmVeSWpSXmKPExsWy7bCmlu7X7z1pBiveWlvMWbWN0WL13X42
	i3et51gsfnXfZbS4vGsOm8XZCR9YLbounGJzYPfYOesuu8fls6UefVtWMXp83iQXwBKVbZOR
	mpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDdICSQlliTilQ
	KCCxuFhJ386mKL+0JFUhI7+4xFYptSAlp8CkQK84Mbe4NC9dLy+1xMrQwMDIFKgwITtj8nmd
	gtU2FQd2nmFpYJxi0MXIySEhYCJxbN41pi5GLg4hgd2MEsund7BCOJ8YJSbe7WWEcL4xShy7
	/JcJpuX750dQVXsZJeZfWwZV9YNR4mL3AnaQKjYBJYn9Wz4wgtgiAsIS+ztaWUBsZoEiidcz
	t7GC2MICThLfvuwHq2cRUJW43HwezOYVsJZ42TaNGWKbvMTNrv3MEHFBiZMzn0DNkZdo3jqb
	GWSxhMA+dom/zVehGlwkJnROgTpVWOLV8S3sELaUxOd3e9kg7HyJyd/XM0LYNRLrNr9jgbCt
	Jf5d2QNkcwAt0JRYv0sfIiwrMfXUOiaIvXwSvb+fQI3nldgxD8ZWklhyZAXUSAmJ3xMWsULY
	HhInr05lBBkpJBAr8WW72QRG+VlIvpmF5JtZCIsXMDKvYpRMLSjOTU8tNi0wzEsth8drcn7u
	JkZwMtTy3MF498EHvUOMTByMhxglOJiVRHjn3+hOE+JNSaysSi3Kjy8qzUktPsRoCgziicxS
	osn5wHScVxJvaGJpYGJmZmZiaWxmqCTO+7p1boqQQHpiSWp2ampBahFMHxMHp1QDU+Wvt7c3
	CDdxhp4r//uAL2GhxT/vaW+l3hxRXfNBI/b6qcfcyh847CMNetXmcLhx6zScE39RrnVqwtVs
	TaU3h16tWnWmzyrF7e2jAw7hq+UF7icfnrzo5J+el22/jctv+T6eZHssfG/QM66s9S/CDfjt
	H4YnVyzZosgR0Ci84ob9bYc+5sv+BXPfhVxb7F9cLli2Id303Odb6/Z+Dntm3CbttvLGhY3N
	PiVhU9MaGNx27M9f2l3SENnfbqK6M1zQdP+MrStmiqjoOFwT3rOvSM5kQ6Wl28FXd1P2CEwJ
	3pKS5mvclG3opld1Zc3x/8tm8X2bUctfItxa5jezz6qe+8Cui2r7l7s47Dgl06wgosRSnJFo
	qMVcVJwIAIfPMFoPBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBLMWRmVeSWpSXmKPExsWy7bCSnO6tjz1pBjdfm1rMWbWN0WL13X42
	i3et51gsfnXfZbS4vGsOm8XZCR9YLbounGJzYPfYOesuu8fls6UefVtWMXp83iQXwBLFZZOS
	mpNZllqkb5fAlTH5vE7BapuKAzvPsDQwTjHoYuTkkBAwkfj++RFrFyMXh5DAbkaJN9NeMEIk
	JCR2PPrDCmELS6z895wdougbo8TCDwvBEmwCShL7t3wAaxABKtrf0coCYjMLlEm8W7kerEZY
	wEni25f97CA2i4CqxOXm82A2r4C1xMu2acwQC+QlbnbtZ4aIC0qcnPkEao68RPPW2cwTGPlm
	IUnNQpJawMi0ilEytaA4Nz032bDAMC+1XK84Mbe4NC9dLzk/dxMjODC1NHYw3pv/T+8QIxMH
	4yFGCQ5mJRHe+Te604R4UxIrq1KL8uOLSnNSiw8xSnOwKInzGs6YnSIkkJ5YkpqdmlqQWgST
	ZeLglGpg8lFY/Om3k8Tq5KcF+yUEOiLXvpxdIbhxUQJTYHO99uXjd7cnexXNmcQpE1JmUWBf
	8GDW5eZjPxPyPY4XXpljcnaHc7JYzxzhUxYClxIcmK7o7XGdtffexmbZxt8i+d/airn+zSpJ
	DbnwQfjUd41sN921Bx5kmOvIrCuffXeKb/viXM3vWRtWGlTH7lidoBb/PmaD06t5tfuZA0S2
	vN3xMKvg/ZmrvIbl3Pvm6mhJBm8WLv1+9ZXw1U1OS6/cPs21omNXcvn/T1PW8RxrmFjqFfGp
	/+eGE/qGHZK/3Ft4a71msj+Z++mnSISHU6RxWs5+e9f/6799EbGXqbwiNWFGp31L+cbrmcW9
	/7+yPahJU2Ipzkg01GIuKk4EABpcsAO7AgAA
X-CMS-MailID: 20240709081627epcas5p3033c01e4816310394f8efbbd4b43cfd0
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240709081627epcas5p3033c01e4816310394f8efbbd4b43cfd0
References: <CGME20240709081627epcas5p3033c01e4816310394f8efbbd4b43cfd0@epcas5p3.samsung.com>

io_uring use polling mode could improve the IO performence, but it will
spend 100% of CPU resources to do polling.

This set a signal "IORING_SETUP_HY_POLL" to application, aim to provide
a interface for user to enable a new hybrid polling at io_uring level.

A new hybrid poll is implemented on the io_uring layer. Once IO issued,
it will not polling immediately, but block first and re-run before IO
complete, then poll to reap IO. This poll function could be a suboptimal
solution when running on a single thread, it offers the performance lower
than regular polling but higher than IRQ, and CPU utilization is also lower
than polling.

Test Result
fio-3.35, Gen 4 device
-------------------------------------------------------------------------------------
Performance
-------------------------------------------------------------------------------------
                            write                      read                 randwrite          randread
regular poll    BW=3939MiB/s    BW=6596MiB/s    IOPS=190K       IOPS=526K
IRQ                 BW=3927MiB/s    BW=6567MiB/s    IOPS=181K       IOPS=216K
hybrid poll     BW=3933MiB/s    BW=6600MiB/s    IOPS=190K       IOPS=390K(suboptimal)
-------------------------------------------------------------------------------------
CPU Utilization
------------------------------------------------------------------
                        write   read    randwrite       randread
regular poll    100%    100%    100%            100%
IRQ                 38%       53%      100%            100%
hybrid poll     76%       32%      70%              85%
------------------------------------------------------------------

--
changes since v5:
- Remove cstime recorder
- Use minimize sleep time in different drivers
- Use the half of whole runtime to do schedule
- Consider as a suboptimal solution between
  regular poll and IRQ

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
 include/linux/io_uring_types.h |  6 +++
 include/uapi/linux/io_uring.h  |  1 +
 io_uring/io_uring.c            |  3 +-
 io_uring/rw.c                  | 74 +++++++++++++++++++++++++++++++++-
 4 files changed, 82 insertions(+), 2 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 91224bbcfa73..0897126fb2d7 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -428,6 +428,8 @@ struct io_ring_ctx {
 	unsigned short			n_sqe_pages;
 	struct page			**ring_pages;
 	struct page			**sqe_pages;
+	/* for hybrid poll*/
+	u64			available_time;
 };
 
 struct io_tw_state {
@@ -665,6 +667,10 @@ struct io_kiocb {
 		u64			extra1;
 		u64			extra2;
 	} big_cqe;
+    /* for hybrid iopoll */
+	bool		poll_state;
+	u64			iopoll_start;
+	u64			iopoll_end;
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
index 816e93e7f949..b38f8af118c5 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -299,6 +299,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 		goto err;
 
 	ctx->flags = p->flags;
+	ctx->available_time = LLONG_MAX;
 	atomic_set(&ctx->cq_wait_nr, IO_CQ_WAKE_INIT);
 	init_waitqueue_head(&ctx->sqo_sq_wait);
 	INIT_LIST_HEAD(&ctx->sqd_list);
@@ -3637,7 +3638,7 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 			IORING_SETUP_SQE128 | IORING_SETUP_CQE32 |
 			IORING_SETUP_SINGLE_ISSUER | IORING_SETUP_DEFER_TASKRUN |
 			IORING_SETUP_NO_MMAP | IORING_SETUP_REGISTERED_FD_ONLY |
-			IORING_SETUP_NO_SQARRAY))
+			IORING_SETUP_NO_SQARRAY | IORING_SETUP_HY_POLL))
 		return -EINVAL;
 
 	return io_uring_create(entries, &p, params);
diff --git a/io_uring/rw.c b/io_uring/rw.c
index 1a2128459cb4..5505f4292ce5 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -772,6 +772,13 @@ static bool need_complete_io(struct io_kiocb *req)
 		S_ISBLK(file_inode(req->file)->i_mode);
 }
 
+static void init_hybrid_poll(struct io_ring_ctx *ctx, struct io_kiocb *req)
+{
+	/* make sure every req only block once*/
+	req->poll_state = false;
+	req->iopoll_start = ktime_get_ns();
+}
+
 static int io_rw_init_file(struct io_kiocb *req, fmode_t mode)
 {
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
@@ -809,6 +816,8 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode)
 		kiocb->ki_flags |= IOCB_HIPRI;
 		kiocb->ki_complete = io_complete_rw_iopoll;
 		req->iopoll_completed = 0;
+		if (ctx->flags & IORING_SETUP_HY_POLL)
+			init_hybrid_poll(ctx, req);
 	} else {
 		if (kiocb->ki_flags & IOCB_HIPRI)
 			return -EINVAL;
@@ -1106,6 +1115,67 @@ void io_rw_fail(struct io_kiocb *req)
 	io_req_set_res(req, res, req->cqe.flags);
 }
 
+static u64 io_delay(struct io_ring_ctx *ctx, struct io_kiocb *req)
+{
+	struct hrtimer_sleeper timer;
+	enum hrtimer_mode mode;
+	ktime_t kt;
+	u64 sleep_time;
+
+	if (req->poll_state)
+		return 0;
+
+	if (ctx->available_time == LLONG_MAX)
+		return 0;
+
+	/* Using half running time to do schedul */
+	sleep_time = ctx->available_time / 2;
+
+	kt = ktime_set(0, sleep_time);
+	req->poll_state = true;
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
+
+	return sleep_time;
+}
+
+static int io_uring_hybrid_poll(struct io_kiocb *req,
+				struct io_comp_batch *iob, unsigned int poll_flags)
+{
+	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
+	struct io_ring_ctx *ctx = req->ctx;
+	int ret;
+	u64 runtime, sleep_time;
+
+	sleep_time = io_delay(ctx, req);
+
+	/* it doesn't implement with io_uring passthrough now */
+	ret = req->file->f_op->iopoll(&rw->kiocb, iob, poll_flags);
+
+	req->iopoll_end = ktime_get_ns();
+	runtime = req->iopoll_end - req->iopoll_start - sleep_time;
+	if (runtime < 0)
+		return 0;
+
+	/* use minimize sleep time if there are different speed
+	 * drivers, it could get more completions from fast one
+	 */
+	if (ctx->available_time > runtime)
+		ctx->available_time = runtime;
+	return ret;
+}
+
 int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 {
 	struct io_wq_work_node *pos, *start, *prev;
@@ -1133,7 +1203,9 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
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


