Return-Path: <io-uring+bounces-2467-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 31E5D92B3D8
	for <lists+io-uring@lfdr.de>; Tue,  9 Jul 2024 11:30:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id B65F51F2359C
	for <lists+io-uring@lfdr.de>; Tue,  9 Jul 2024 09:30:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7A7413C36;
	Tue,  9 Jul 2024 09:30:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="gG0USvMX"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E634815535D
	for <io-uring@vger.kernel.org>; Tue,  9 Jul 2024 09:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720517415; cv=none; b=h/kCOLxUcmkrtWaYqubquv8zQjwpZyzW6wFQQevdDQclVouUFAUViQ9Mxrfe2GQM5nw3gIe2Zevnw5Aout7LsIVkNv2oLs5c5wTCFUEANDveyHJR+KDb1Hry0lHfbK2VouVQqSlyMKoRaOZq9knTcO050ok+2yOPkKA24S3FxIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720517415; c=relaxed/simple;
	bh=IME8rCB7fAt9u3OMchcky2jiuiqkjWjQijSuJ80AbgI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=Z21NFZnZuKSUjFDId3/PmAhuE2h6VVTpiPDUwbVM6yLDtq3tDwF7+84P1e/R+KhIUbMFJQ3OLTT9lqMZxnQEwYuo/ujLkRlc93iT0mYx1xkaEeZVZk8BdJoihAfckBBgOHtQL5UA9KB6qSkl2v5eNL0qxUqgreh9qQhpwoBf9tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=gG0USvMX; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20240709093010epoutp0201c5d88e28bd0b8cd5339f4f7fa659a9~ggXgv_q_s1463314633epoutp029
	for <io-uring@vger.kernel.org>; Tue,  9 Jul 2024 09:30:10 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20240709093010epoutp0201c5d88e28bd0b8cd5339f4f7fa659a9~ggXgv_q_s1463314633epoutp029
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1720517410;
	bh=tyY0FHvDKzaeY0VE76aQeCLX5GFhktpWQTUjKu+w1AU=;
	h=From:To:Cc:Subject:Date:References:From;
	b=gG0USvMXJgeRKxuhFBBoJHpJFHqiKj3SSvCAvgddGxDMMTVe/oXJlNziUD/xs+65A
	 AlhDolVPGfYHKRIHl5POY8K2SQXN3cyUm9+6Se53gFF2q9O5jdp3RhE/I7iW8LF8sv
	 VKEbD4xxMxDF246zYTqtupuZeMP3u9fnZUgKvLV4=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTP id
	20240709093010epcas5p311e4703dbd7fd32f152af5bce94ddffe~ggXgTK3ub0830008300epcas5p3o;
	Tue,  9 Jul 2024 09:30:10 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.179]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4WJG1F0rYfz4x9Q3; Tue,  9 Jul
	2024 09:30:09 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	DA.63.11095.F130D866; Tue,  9 Jul 2024 18:30:07 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20240709092951epcas5p24783c3bb5c23277cf23a72a6e1855751~ggXOeidZb2755427554epcas5p2A;
	Tue,  9 Jul 2024 09:29:51 +0000 (GMT)
Received: from epsmgms1p2new.samsung.com (unknown [182.195.42.42]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240709092951epsmtrp2b1caac7ca39e0ec522e6c310da05cdfa~ggXOd31bz1559415594epsmtrp20;
	Tue,  9 Jul 2024 09:29:51 +0000 (GMT)
X-AuditID: b6c32a49-3c3ff70000012b57-f2-668d031f564e
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgms1p2new.samsung.com (Symantec Messaging Gateway) with SMTP id
	4A.0A.19057.F030D866; Tue,  9 Jul 2024 18:29:51 +0900 (KST)
Received: from testpc11818.samsungds.net (unknown [109.105.118.18]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240709092950epsmtip1f834d0e8ae3365473ef66a2cc0370072~ggXNmB8JQ0898508985epsmtip1O;
	Tue,  9 Jul 2024 09:29:50 +0000 (GMT)
From: hexue <xue01.he@samsung.com>
To: axboe@kernel.dk
Cc: asml.silence@gmail.com, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org, hexue <xue01.he@samsung.com>
Subject: [PATCH v6 RESEND] io_uring: releasing CPU resources when polling
Date: Tue,  9 Jul 2024 17:29:44 +0800
Message-Id: <20240709092944.3208051-1-xue01.he@samsung.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFKsWRmVeSWpSXmKPExsWy7bCmhq48c2+awbctZhZzVm1jtFh9t5/N
	4l3rORaLX913GS0u75rDZnF2wgdWi64Lp9gc2D12zrrL7nH5bKlH35ZVjB6fN8kFsERl22Sk
	JqakFimk5iXnp2TmpdsqeQfHO8ebmhkY6hpaWpgrKeQl5qbaKrn4BOi6ZeYAHaCkUJaYUwoU
	CkgsLlbSt7Mpyi8tSVXIyC8usVVKLUjJKTAp0CtOzC0uzUvXy0stsTI0MDAyBSpMyM74taSb
	sWCOTcWXaz+ZGxh3GXQxcnJICJhI3N35mBnEFhLYzSixaadMFyMXkP2JUaJl/R0WCOcbo8SF
	5SfZYDq+HpnIBpHYyyjxdPNjJgjnB6PEwTmnGUGq2ASUJPZv+QBmiwgIS+zvaGUBsZkFiiRe
	z9zGCmILC3hKnPq0H2w3i4CqxOdvR4HiHBy8AtYSN7aGQiyTl7jZBVHCKyAocXLmE6gx8hLN
	W2czQ9QcY5fYPMERwnaR2LFwAdShwhKvjm9hh7ClJD6/2wsVz5eY/H09I4RdI7Fu8zsWCNta
	4t+VPSwgJzALaEqs36UPEZaVmHpqHRPEWj6J3t9PmCDivBI75sHYShJLjqyAGikh8XvCIrBP
	JAQ8JOYv94YEbqzE8i3r2CYwys9C8swsJM/MQli8gJF5FaNkakFxbnpqsWmBYV5qOTxWk/Nz
	NzGCE6GW5w7Guw8+6B1iZOJgPMQowcGsJMI7/0Z3mhBvSmJlVWpRfnxRaU5q8SFGU2AAT2SW
	Ek3OB6bivJJ4QxNLAxMzMzMTS2MzQyVx3tetc1OEBNITS1KzU1MLUotg+pg4OKUamOZVtT/i
	2+EQERF1iv/jmkDfqv9xnm7y7e9+7OYJnbSSifO+h1t5Udz8yeYnDl6v9nnAUO/n7XeiZxFf
	0Jv4ebcPH/a6Gxf25nKShUpq4OK1eXKnJhczVk09FHhMLb90gvbFF84d/S49NcuPyRWkrt22
	yzVHdGmDhtif17YfF3f5BwW9cb/JcK5hn078PPYVlr+8DSs7LT6IBe498Fj/dHF0f0xzyo9i
	1yL2Hzx9e+uepa56av/v+4vzcx68Kr14/F1jxOLyL/s/Hepxfm5hwMIWaJAQMs80SPV+usBD
	5qQ8h89L+Z9tsRXj0v2Zu6dt+o3m1vOve2+2Tt5e6/9y1pWVJ6+5LI+dfDJJcmn3GiWW4oxE
	Qy3mouJEAA+zfh8NBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrBLMWRmVeSWpSXmKPExsWy7bCSnC4/c2+awed+Tos5q7YxWqy+289m
	8a71HIvFr+67jBaXd81hszg74QOrRdeFU2wO7B47Z91l97h8ttSjb8sqRo/Pm+QCWKK4bFJS
	czLLUov07RK4Mn4t6WYsmGNT8eXaT+YGxl0GXYycHBICJhJfj0xk62Lk4hAS2M0o0Tx/LzNE
	QkJix6M/rBC2sMTKf8/ZIYq+MUosWPEerIhNQEli/5YPjCC2CFDR/o5WFhCbWaBM4t3K9WDN
	wgKeEqc+7QerZxFQlfj87ShQnIODV8Ba4sbWUIj58hI3uyBKeAUEJU7OfAI1Rl6ieets5gmM
	fLOQpGYhSS1gZFrFKJlaUJybnltsWGCUl1quV5yYW1yal66XnJ+7iREcmFpaOxj3rPqgd4iR
	iYPxEKMEB7OSCO/8G91pQrwpiZVVqUX58UWlOanFhxilOViUxHm/ve5NERJITyxJzU5NLUgt
	gskycXBKNTAJF9/5cXnFMeXDK9PnxQeu+XL/1WWZ3GWzyidJv3yw7KuQ+uSlayZ1CfedWjfl
	ZtS//DTJBmuuz9depjucftrXLOC79Pr8/H9MjMY3e2a2bTP5a/bg2O+JM+yN7cyPPFxx4+Hf
	sl0rPwpuWTpXc9ll19hvLSKPVa9+uJo/cW6OaJH0wdTHO86KHJEN/t3uU8aqfIl1eYzlnji3
	1inXLkztvriWMWqiZ03/7Tvzz5yfyRM0Odroh+nvSQ8jbvZGv9iV/HGa97e368OmzNy9ctLp
	yoehU7h2RVfxyWQ8C7D+/OCc452YKc8kbLW37J91THGttH3gi73Z7S/amOu2Pvu1tz2L/35p
	3YeoSUaC9pEluRVKLMUZiYZazEXFiQDGVpJ4uwIAAA==
X-CMS-MailID: 20240709092951epcas5p24783c3bb5c23277cf23a72a6e1855751
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240709092951epcas5p24783c3bb5c23277cf23a72a6e1855751
References: <CGME20240709092951epcas5p24783c3bb5c23277cf23a72a6e1855751@epcas5p2.samsung.com>

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
                  write          read           randwrite       randread
regular poll    BW=3939MiB/s    BW=6596MiB/s    IOPS=190K       IOPS=526K
IRQ             BW=3927MiB/s    BW=6567MiB/s    IOPS=181K       IOPS=216K
hybrid poll     BW=3933MiB/s    BW=6600MiB/s    IOPS=190K       IOPS=390K(suboptimal)
-------------------------------------------------------------------------------------
CPU Utilization
-------------------------------------------------------------------------------------
                write   read    randwrite       randread
regular poll    100%    100%    100%            100%
IRQ             38%     53%     100%            100%
hybrid poll     76%     32%     70%              85%
-------------------------------------------------------------------------------------

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


