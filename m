Return-Path: <io-uring+bounces-3101-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 378A0972E49
	for <lists+io-uring@lfdr.de>; Tue, 10 Sep 2024 11:41:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EA868287B04
	for <lists+io-uring@lfdr.de>; Tue, 10 Sep 2024 09:41:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E2FB18C030;
	Tue, 10 Sep 2024 09:40:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="oweMkvx0"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98EB418C90A
	for <io-uring@vger.kernel.org>; Tue, 10 Sep 2024 09:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961256; cv=none; b=IToZmX3KaVfj1DALrYaGhikU4T8TLeUzWvGoAXFq6N7KFZjZvYFssIHrCjcV0dfsDVtKpCsGmaqtK1ZAVcknOtzrOG8V/iUs18DpPSI4rpDOZsJOWrZ6IG7RdQWDPOLGxxhfb+frRHYPd1f5a1RcmGmq0SzB1nkjP0AlLPe+6xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961256; c=relaxed/simple;
	bh=sKWbOMH4P24E6BnvZYSq6BRnKSlD5ZalDfrKb7+p5ts=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=aA9WyJe4m6/JBtM5C5Sr0oigirUnCpfFzVj0sq64Pu357onY577sQYhTzlzzCAm/DmTkPNsPzxluBirGCANd9nLzvIzOhIGWA5jK93iT8Wf2qvGeC/qCUkhruGa0ZxBaAFa56R9Nu2gB22eKkO/lMYszA/Jzfdrh3V5KixBA/7o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=oweMkvx0; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240910094051epoutp0434c9b7ed655149fa48c6c6c00e852b6d~z2J0gRKpI2209022090epoutp04z
	for <io-uring@vger.kernel.org>; Tue, 10 Sep 2024 09:40:51 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240910094051epoutp0434c9b7ed655149fa48c6c6c00e852b6d~z2J0gRKpI2209022090epoutp04z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1725961251;
	bh=YB/Kn4zP87WsWLT08fcUQuDrLHGW9spUWa+9l41J8F0=;
	h=From:To:Cc:Subject:Date:References:From;
	b=oweMkvx0B2lx0ZJd0vHRirSyI5Jyb+eAp+dKyKTSg/7hD7/0URVKPgNGTix1jeT+P
	 kphPkO3E03f2Ik438aA6p8tpnAIw0F1Yf1Luu446Jzikp+T0AYcjJa2FQ8wl8zDZuD
	 1G+1mBBtGw2+1s9PYj0ZuP2tV0Pro9s5wEA1wU8I=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20240910094051epcas5p2c235021bd753f06362025ef2760346bd~z2J0CrBEj2969129691epcas5p2o;
	Tue, 10 Sep 2024 09:40:51 +0000 (GMT)
Received: from epsmges5p1new.samsung.com (unknown [182.195.38.180]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4X2zGT2vSsz4x9Q1; Tue, 10 Sep
	2024 09:40:49 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	1F.63.09640.12410E66; Tue, 10 Sep 2024 18:40:49 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20240910092236epcas5p47ae276bce273adcda52aa5ac24cdb777~z155DDxhb2593125931epcas5p4i;
	Tue, 10 Sep 2024 09:22:36 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240910092236epsmtrp10dd9ea10fae154ca16eb346507df04eb~z155CX3Ug0130801308epsmtrp1H;
	Tue, 10 Sep 2024 09:22:36 +0000 (GMT)
X-AuditID: b6c32a49-aabb8700000025a8-d6-66e014219114
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	67.79.19367.CDF00E66; Tue, 10 Sep 2024 18:22:36 +0900 (KST)
Received: from testpc11818.samsungds.net (unknown [109.105.118.18]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240910092235epsmtip1d96d5bdbc58b7c24628473ddab9a2381~z154IXow20264702647epsmtip1D;
	Tue, 10 Sep 2024 09:22:35 +0000 (GMT)
From: hexue <xue01.he@samsung.com>
To: axboe@kernel.dk, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, hexue
	<xue01.he@samsung.com>
Subject: [PATCH v8 RESENT] io_uring: releasing CPU resources when polling
Date: Tue, 10 Sep 2024 17:22:23 +0800
Message-Id: <20240910092223.161685-1-xue01.he@samsung.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrFKsWRmVeSWpSXmKPExsWy7bCmuq6iyIM0gw8XWC3mrNrGaLH6bj+b
	xbvWcywWv7rvMlpc3jWHzeLshA+sFl0XTrE5sHvsnHWX3ePy2VKPvi2rGD0+b5ILYInKtslI
	TUxJLVJIzUvOT8nMS7dV8g6Od443NTMw1DW0tDBXUshLzE21VXLxCdB1y8wBOkBJoSwxpxQo
	FJBYXKykb2dTlF9akqqQkV9cYquUWpCSU2BSoFecmFtcmpeul5daYmVoYGBkClSYkJ3x5P40
	poJVLhVb1s9kbGCcaN7FyMEhIWAicWaubRcjF4eQwG5GidU9a1khnE+MEvemtLMgOGc2M3cx
	coJ1tHb3skEkdjJKnNg/iR0kISTwg1Hi7858EJtNQEli/5YPjCC2iIC2xOvHU1lA1jELREm8
	WMsNEhYW8JTYuvcLK4jNIqAqcfPjTSaQEl4BK4lfbQUQq+QlbnbtB1vLKyAocXLmExYQmxko
	3rx1NjPICRICh9glZs/6yQLR4CJxa/9MKFtY4tXxLewQtpTEy/42KDtfYvL39YwQdo3Eus3v
	oOqtJf5d2QN1pqbE+l36EGFZiamn1jFB7OWT6P39hAkiziuxYx6MrSSx5MgKqJESEr8nLGKF
	sD0kbu16wwQJnViJGWuamSYwys9C8s4sJO/MQti8gJF5FaNkakFxbnpqsWmBYV5qOTxWk/Nz
	NzGCE6GW5w7Guw8+6B1iZOJgPMQowcGsJMLbb3cvTYg3JbGyKrUoP76oNCe1+BCjKTCIJzJL
	iSbnA1NxXkm8oYmlgYmZmZmJpbGZoZI47+vWuSlCAumJJanZqakFqUUwfUwcnFINTFmay971
	x3aJfw6eq7NT9iPjpkyvoy9rf5go68gJz/y+r0B5X8UL2St/5VkfTNzIIrdSSPqttu+a9COT
	nkQccwnP4pnPu/zDHaPEabIul76fqc5L2XZwg+bsHYYJIZXimQvfztwj49d3806PsPtJvfsz
	/RxKZne/d6jMSha/ZnrbVcnkeYvZ1k8vapnk1jvenrMkQ/Shz67ihHJ+PeayNcE7Hh6LLLDX
	X5vCqcxTzZ/+5HbPnImy54K1D+pfDNc5orD0+KaIiafZ7KappG0rNr7Zc/Xv8dKWWyxMP7bO
	Z9xeuWHPueCHy6UyqzSjplZOeflwx6WC1JoH83w3myw7/evFWY5E96on8uWdM8WypiixFGck
	GmoxFxUnAgC+jCKqDQQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrMLMWRmVeSWpSXmKPExsWy7bCSnO4d/gdpBndnGFjMWbWN0WL13X42
	i3et51gsfnXfZbS4vGsOm8XZCR9YLbounGJzYPfYOesuu8fls6UefVtWMXp83iQXwBLFZZOS
	mpNZllqkb5fAlfHk/jSmglUuFVvWz2RsYJxo3sXIySEhYCLR2t3L1sXIxSEksJ1RYum0LjaI
	hITEjkd/WCFsYYmV/56zQxR9Y5RYc34dWIJNQEli/5YPjF2MHBwiAroSjXcVQMLMAjESH/ZM
	YAexhQU8Jbbu/QJWziKgKnHz400mkHJeASuJX20FEOPlJW527WcGsXkFBCVOznzCAjFGXqJ5
	62zmCYx8s5CkZiFJLWBkWsUomlpQnJuem1xgqFecmFtcmpeul5yfu4kRHI5aQTsYl63/q3eI
	kYmD8RCjBAezkghvv929NCHelMTKqtSi/Pii0pzU4kOM0hwsSuK8yjmdKUIC6YklqdmpqQWp
	RTBZJg5OqQamGTsCr6zNP20/+dG9na42Wxh1ansiNqUtNzuvGByrFB6wwjHR+huP7Tqf9hV/
	5rVsNntqeHILUzKfQNOjEjfRDWs+2W0z+acUmFt89uh/tUWNWs7fDsy8Nm+Fxto6CU3mXzYp
	ZjxO2vcuHn0Y8SVDsnh7YmeOfUs0r9Qv+X0i+XmX4hMmn3V59+/37VX8HxqeHjeVjJX+eW5t
	wR+eumzfGy9mHWvdGOPROnfFIdu6R1aH1V8nsy2IE35t/jL83lIf0bv7rsaFbOmYy1TAM+sD
	b850m/D1igc//PZ1/6TqEf+2RHIhj7PpFDYP3RfNbx2LgwJTf54LjDJLvH7twYVlVxgMVGZq
	zypri5r/8vUfJZbijERDLeai4kQA2aJCnrYCAAA=
X-CMS-MailID: 20240910092236epcas5p47ae276bce273adcda52aa5ac24cdb777
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240910092236epcas5p47ae276bce273adcda52aa5ac24cdb777
References: <CGME20240910092236epcas5p47ae276bce273adcda52aa5ac24cdb777@epcas5p4.samsung.com>

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


