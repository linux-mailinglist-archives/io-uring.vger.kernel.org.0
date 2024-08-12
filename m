Return-Path: <io-uring+bounces-2699-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 031FD94E498
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 04:03:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AEA45280FF7
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 02:03:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 362751758F;
	Mon, 12 Aug 2024 02:03:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="bE8pvNb5"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout1.samsung.com (mailout1.samsung.com [203.254.224.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0622A8F47
	for <io-uring@vger.kernel.org>; Mon, 12 Aug 2024 02:03:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723428209; cv=none; b=cQGbpTPX/sihuHQ+u3NN04W4sJT8ElCl9aZToTpYPFGEL80XF0MB+i6WHkeXRfiWb7LspwvbJdfG+uwcqfFa4sr3fVsubUksHqd9/aTUoipBxv23G/hhIG5DHYlVlrClTamFHnGKQ7it66qWP+aWw3REmydSN3b0+YzGPJeLUiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723428209; c=relaxed/simple;
	bh=sKWbOMH4P24E6BnvZYSq6BRnKSlD5ZalDfrKb7+p5ts=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=S4MC9IIQMRz7ycHE8ueiAG8tV6RF0aZ8sp55OVVF+hN4Jhh9p6J2THA1pOKKe7sflR+JHjgVW61OJQWJohQ2dQS8jFakDk3ICqG/RbxtudHGmMCLKWmrLgcV3Ygr0DMyEberaBXPDGLYOfdmSEGO/6HAzu9dyz9GlMDN6RkICEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=bE8pvNb5; arc=none smtp.client-ip=203.254.224.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout1.samsung.com (KnoxPortal) with ESMTP id 20240812020323epoutp015022df5b8ed5aeb2020fb2754452d026~q2NH5k8MT1571015710epoutp01i
	for <io-uring@vger.kernel.org>; Mon, 12 Aug 2024 02:03:23 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20240812020323epoutp015022df5b8ed5aeb2020fb2754452d026~q2NH5k8MT1571015710epoutp01i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1723428203;
	bh=YB/Kn4zP87WsWLT08fcUQuDrLHGW9spUWa+9l41J8F0=;
	h=From:To:Cc:Subject:Date:References:From;
	b=bE8pvNb59cIlqD6Jdcj+vz2R8lZs4iZF2zFyrpuPmeOtZD6wzOeG6G8RjJYe0SNoc
	 VtN4XqgTxek74xPhpozCrijY9CVYzamDnJd93IMEHgIhZbqxXbMPHOIOCSi3DRtuaf
	 aprC/GmAoCl6fHddbKuV0/plT1eCQgRxnKmcm5ZU=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTP id
	20240812020323epcas5p41db6b7b44add12f1c79293587f8dbfb5~q2NHk5pdK1619416194epcas5p4D;
	Mon, 12 Aug 2024 02:03:23 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.174]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4WhyV16WJcz4x9Pq; Mon, 12 Aug
	2024 02:03:21 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	95.44.09642.96D69B66; Mon, 12 Aug 2024 11:03:21 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20240812015950epcas5p26c0eb254964abfe8a7ff05de0ead05f8~q2KBdMcUL1275312753epcas5p2r;
	Mon, 12 Aug 2024 01:59:50 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240812015950epsmtrp2a12add75393e5da230979bf0b6388e2e~q2KBbxnIM3032030320epsmtrp2r;
	Mon, 12 Aug 2024 01:59:50 +0000 (GMT)
X-AuditID: b6c32a4b-613ff700000025aa-46-66b96d69e738
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	ED.55.08456.69C69B66; Mon, 12 Aug 2024 10:59:50 +0900 (KST)
Received: from testpc11818.samsungds.net (unknown [109.105.118.18]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240812015949epsmtip2c9ffe16f63dc77c1899c718056755414~q2KAUAOw00030000300epsmtip2b;
	Mon, 12 Aug 2024 01:59:49 +0000 (GMT)
From: hexue <xue01.he@samsung.com>
To: axboe@kernel.dk, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, hexue
	<xue01.he@samsung.com>
Subject: [PATCH v8] io_uring: releasing CPU resources when polling
Date: Mon, 12 Aug 2024 09:59:43 +0800
Message-Id: <20240812015943.3942523-1-xue01.he@samsung.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLKsWRmVeSWpSXmKPExsWy7bCmum5m7s40gzvrNCzmrNrGaLH6bj+b
	xbvWcywWv7rvMlpc3jWHzeLshA+sFl0XTrE5sHvsnHWX3ePy2VKPvi2rGD0+b5ILYInKtslI
	TUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBOkBJoSwxpxQo
	FJBYXKykb2dTlF9akqqQkV9cYquUWpCSU2BSoFecmFtcmpeul5daYmVoYGBkClSYkJ3x5P40
	poJVLhVb1s9kbGCcaN7FyMkhIWAi0dJxibGLkYtDSGA3o8TXd4+ZIJxPjBKX37exQjjfGCX2
	zHvBDNPyqv8nVMteRokXl+dAtfxglHh2eQ8LSBWbgJLE/i0fGEFsEQFtidePpwLFOTiYBaIk
	XqzlBgkLCzhJnDl6iQ3EZhFQlZi0/zo7iM0rYC1x9N1xJohl8hI3u/YzQ8QFJU7OfAI2nhko
	3rx1NjPIXgmBY+wSD17fh2pwkfjz5AE7hC0s8er4FihbSuLzu71sEHa+xOTv6xkh7BqJdZvf
	sUDY1hL/ruyBulNTYv0ufYiwrMTUU+uYIPbySfT+fgK1ildixzwYW0liyZEVUCMlJH5PWMQK
	YXtIzD/6CCwuJBArceXiFpYJjPKzkLwzC8k7sxA2L2BkXsUomVpQnJueWmxaYJyXWg6P2OT8
	3E2M4HSo5b2D8dGDD3qHGJk4GA8xSnAwK4nwNodvShPiTUmsrEotyo8vKs1JLT7EaAoM44nM
	UqLJ+cCEnFcSb2hiaWBiZmZmYmlsZqgkzvu6dW6KkEB6YklqdmpqQWoRTB8TB6dUA1Py2q8x
	LX7XJnkvvmRrsGTnJ9mqnUJmUzfxn6kUY3V8UbYjJ/XZz4jC4z+fXF3R+i6Lrys0Npzj48KL
	1ucW2S5pOX1q7W27l353f2o9nXphneG0n0UPV1WlTZ7by62X6FkidX/H7e2rE2baskmtEX8Z
	4rDgTmE8X+bhA3tcOINykxmTSmJLnti2lP4Qr4z9rHhy7aI3R1lepkRfMcgvdT/7V1G/YKs7
	Z0btUsGfHxhPeU0SyFZa9easX/Tz5ZHN6w7u15j3Ni/Uy9Il9f4iA7P7PxPtf7yd6cB5RXkS
	w6pzgdvXBF6cpflMu/bmP8Y75012XniWUZLw/+lDjvjQooo5q4LX9v73cz0T9POb1J9zSizF
	GYmGWsxFxYkAklBYHxAEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBLMWRmVeSWpSXmKPExsWy7bCSvO60nJ1pBn92KFnMWbWN0WL13X42
	i3et51gsfnXfZbS4vGsOm8XZCR9YLbounGJzYPfYOesuu8fls6UefVtWMXp83iQXwBLFZZOS
	mpNZllqkb5fAlfHk/jSmglUuFVvWz2RsYJxo3sXIySEhYCLxqv8nYxcjF4eQwG5GiYuPbrJA
	JCQkdjz6wwphC0us/PecHaLoG6PE/lWbmUESbAJKEvu3fADq5uAQEdCVaLyrABJmFoiR+LBn
	AjuILSzgJHHm6CU2EJtFQFVi0v7rYHFeAWuJo++OM0HMl5e42bWfGSIuKHFy5hMWiDnyEs1b
	ZzNPYOSbhSQ1C0lqASPTKkbJ1ILi3PTcYsMCo7zUcr3ixNzi0rx0veT83E2M4MDU0trBuGfV
	B71DjEwcjIcYJTiYlUR4m8M3pQnxpiRWVqUW5ccXleakFh9ilOZgURLn/fa6N0VIID2xJDU7
	NbUgtQgmy8TBKdXAtO3InX/pcgua/z6LVQj6yF4mfnqdrdaq3rWeGiIX5PI6Cp+FzOASWny7
	OnqXSLUgU/VF3x/FJcc6khcXWpm4Kcj73p1eHf6h76Hb6Xnn1zwVCDXbsyeu4JuV5YF3seZW
	KjtbFk/7ukzl8/zyuB/2Fw5x5n4Okd/9rm2eXUBK++at708oH4puuF2b1cIsf6b2ek3Z6vwX
	HOWxJT11Sk0NiUINX/bxeFi9KS77WD9v0roZ2xf8V8njYjC9/5vtQbzFcXZ7hkUZ5tJPzZ7l
	5Gw4uKntBQuH2ZHrP7dslZy6/UyY1cZbH1VUzrytFwq0Vm4zYbCYePItx4bP70LqArZUJs+L
	8Js1oV/sff/B01bTlFiKMxINtZiLihMBoQnxIbsCAAA=
X-CMS-MailID: 20240812015950epcas5p26c0eb254964abfe8a7ff05de0ead05f8
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240812015950epcas5p26c0eb254964abfe8a7ff05de0ead05f8
References: <CGME20240812015950epcas5p26c0eb254964abfe8a7ff05de0ead05f8@epcas5p2.samsung.com>

This patch add a new hybrid poll at io_uring level, it also set a signal
"IORING_SETUP_HY_POLL" to application, aim to provide a interface for users
to enable use new hybrid polling flexibly.

io_uring use polling mode could improve the IO performence, but it will
spend 100% of CPU resources to do polling.

A new hybrid poll is implemented on the io_uring layer. Once IO issued,
it will not polling immediately, but block first and re-run before IO
complete, then poll to reap IO. This poll function could be a suboptimal
solution when running on a single thread, it offers the performance lower
than regular polling but higher than IRQ, and CPU utilization is also lower
than polling.

Test Result
fio-3.35, 16 poll queues, 1 thread
-------------------------------------------------------------------------
Performance
-------------------------------------------------------------------------
                write         read        randwrite  randread
regular poll BW=3939MiB/s  BW=6613MiB/s  IOPS=190K  IOPS=470K
IRQ          BW=3927MiB/s  BW=6612MiB/s  IOPS=181K  IOPS=203K
hybrid poll  BW=3937MiB/s  BW=6623MiB/s  IOPS=190K  IOPS=358K(suboptimal)
-------------------------------------------------------------------------
CPU Utilization
------------------------------------------------------
                write   read    randwrite   randread
regular poll    100%    100%    100%        100%
IRQ             50%     53%     100%        100%
hybrid poll     70%     37%     70%         85%
------------------------------------------------------

--
changes since v7:
- rebase code on for-6.12/io_uring
- remove unused varibales

changes since v6:
- Modified IO path, distinct iopoll and uring_cmd_iopoll
- update test results

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
 io_uring/rw.c                  | 99 ++++++++++++++++++++++++++++++----
 4 files changed, 97 insertions(+), 12 deletions(-)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index 3315005df117..35ac4a8bf6ab 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -422,6 +422,8 @@ struct io_ring_ctx {
 	unsigned short			n_sqe_pages;
 	struct page			**ring_pages;
 	struct page			**sqe_pages;
+	/* for io_uring hybrid poll*/
+	u64			available_time;
 };
 
 struct io_tw_state {
@@ -657,6 +659,10 @@ struct io_kiocb {
 		u64			extra1;
 		u64			extra2;
 	} big_cqe;
+    /* for io_uring hybrid iopoll */
+	bool		poll_state;
+	u64			iopoll_start;
+	u64			iopoll_end;
 };
 
 struct io_overflow_cqe {
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 2aaf7ee256ac..42ae868651b0 100644
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
index 3942db160f18..bb3dfd749572 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -301,6 +301,7 @@ static __cold struct io_ring_ctx *io_ring_ctx_alloc(struct io_uring_params *p)
 		goto err;
 
 	ctx->flags = p->flags;
+	ctx->available_time = LLONG_MAX;
 	atomic_set(&ctx->cq_wait_nr, IO_CQ_WAKE_INIT);
 	init_waitqueue_head(&ctx->sqo_sq_wait);
 	INIT_LIST_HEAD(&ctx->sqd_list);
@@ -3603,7 +3604,7 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 			IORING_SETUP_SQE128 | IORING_SETUP_CQE32 |
 			IORING_SETUP_SINGLE_ISSUER | IORING_SETUP_DEFER_TASKRUN |
 			IORING_SETUP_NO_MMAP | IORING_SETUP_REGISTERED_FD_ONLY |
-			IORING_SETUP_NO_SQARRAY))
+			IORING_SETUP_NO_SQARRAY | IORING_SETUP_HY_POLL))
 		return -EINVAL;
 
 	return io_uring_create(entries, &p, params);
diff --git a/io_uring/rw.c b/io_uring/rw.c
index c004d21e2f12..4d32b9b9900b 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -772,6 +772,13 @@ static bool need_complete_io(struct io_kiocb *req)
 		S_ISBLK(file_inode(req->file)->i_mode);
 }
 
+static void init_hybrid_poll(struct io_kiocb *req)
+{
+	/* make sure every req only block once*/
+	req->poll_state = false;
+	req->iopoll_start = ktime_get_ns();
+}
+
 static int io_rw_init_file(struct io_kiocb *req, fmode_t mode, int rw_type)
 {
 	struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
@@ -809,6 +816,8 @@ static int io_rw_init_file(struct io_kiocb *req, fmode_t mode, int rw_type)
 		kiocb->ki_flags |= IOCB_HIPRI;
 		kiocb->ki_complete = io_complete_rw_iopoll;
 		req->iopoll_completed = 0;
+		if (ctx->flags & IORING_SETUP_HY_POLL)
+			init_hybrid_poll(req);
 	} else {
 		if (kiocb->ki_flags & IOCB_HIPRI)
 			return -EINVAL;
@@ -1105,6 +1114,81 @@ void io_rw_fail(struct io_kiocb *req)
 	io_req_set_res(req, res, req->cqe.flags);
 }
 
+static int io_uring_classic_poll(struct io_kiocb *req,
+		struct io_comp_batch *iob, unsigned int poll_flags)
+{
+	int ret;
+	struct file *file = req->file;
+
+	if (req->opcode == IORING_OP_URING_CMD) {
+		struct io_uring_cmd *ioucmd;
+
+		ioucmd = io_kiocb_to_cmd(req, struct io_uring_cmd);
+		ret = file->f_op->uring_cmd_iopoll(ioucmd, iob,
+						poll_flags);
+	} else {
+		struct io_rw *rw = io_kiocb_to_cmd(req, struct io_rw);
+
+		ret = file->f_op->iopoll(&rw->kiocb, iob, poll_flags);
+	}
+	return ret;
+}
+
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
+	struct io_ring_ctx *ctx = req->ctx;
+	int ret;
+	u64 runtime, sleep_time;
+
+	sleep_time = io_delay(ctx, req);
+	ret = io_uring_classic_poll(req, iob, poll_flags);
+	req->iopoll_end = ktime_get_ns();
+	runtime = req->iopoll_end - req->iopoll_start - sleep_time;
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
@@ -1121,7 +1205,6 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 
 	wq_list_for_each(pos, start, &ctx->iopoll_list) {
 		struct io_kiocb *req = container_of(pos, struct io_kiocb, comp_list);
-		struct file *file = req->file;
 		int ret;
 
 		/*
@@ -1132,17 +1215,11 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
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
+		if (ctx->flags & IORING_SETUP_HY_POLL)
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


