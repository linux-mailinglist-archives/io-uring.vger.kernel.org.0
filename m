Return-Path: <io-uring+bounces-3221-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BE12B97B6B5
	for <lists+io-uring@lfdr.de>; Wed, 18 Sep 2024 04:11:00 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 33ABE2865CF
	for <lists+io-uring@lfdr.de>; Wed, 18 Sep 2024 02:10:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA05261FED;
	Wed, 18 Sep 2024 02:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="fr+tv+DV"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2453658210
	for <io-uring@vger.kernel.org>; Wed, 18 Sep 2024 02:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726625453; cv=none; b=LjdCuYSpr7dBihWCzulu86YcJ0Mp7Aw7OxOOH+IfXjA/njfHpjM68jFRxcXoBW+jyg1ehUHef618zD61Tem/5FAHJVffU8W0UX86gjPQ+CJ9HZEASU/dVLdfB/9QAnRwXnNoUYbdtUVbRXh+qG6vSk++4hhETIzNHqma+yTx5fI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726625453; c=relaxed/simple;
	bh=sKWbOMH4P24E6BnvZYSq6BRnKSlD5ZalDfrKb7+p5ts=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=gduiAXkAGKJZwzcdm8zF6PAFs7OBLBqcA47oEXrb9v22MFDHhMxB6phCz3xHjPCH6rAHlSuE1JbGKPK6nzmWa9NpLrwcuGjfP0Xq9qcJdZP35iv7hfEKWMNYXO6Om63XPldZ15v/nDfqZ5nBWppeROGKfMZaxQ3VJ3sK9N1lcPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=fr+tv+DV; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20240918021046epoutp045e924d39571a5b8c64f32a34f952b9b0~2NLIkc3lu2230722307epoutp04Y
	for <io-uring@vger.kernel.org>; Wed, 18 Sep 2024 02:10:46 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20240918021046epoutp045e924d39571a5b8c64f32a34f952b9b0~2NLIkc3lu2230722307epoutp04Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1726625446;
	bh=YB/Kn4zP87WsWLT08fcUQuDrLHGW9spUWa+9l41J8F0=;
	h=From:To:Cc:Subject:Date:References:From;
	b=fr+tv+DVcU0i6Xvo7GJDeUtnr3J9wVQp6hm+YPn67l97c5sMPX5Jw7hNebJsg4xak
	 dgF+rRvZex9qytwKv2/Xh+Rr12mZdl+TbJfBQSLkBYF3uItFEOmvl/87SJ2icwrcl4
	 Ovgb2zS39MQY0J2c8A2s8yhnR/1RGkg23nz5Hl7g=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20240918021046epcas5p2128cd368a1f05cd72891245ddc1c63fa~2NLH8ScxI3272332723epcas5p2I;
	Wed, 18 Sep 2024 02:10:46 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.174]) by
	epsnrtp4.localdomain (Postfix) with ESMTP id 4X7hvS1NVVz4x9Pv; Wed, 18 Sep
	2024 02:10:44 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	31.53.09642.4A63AE66; Wed, 18 Sep 2024 11:10:44 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPA id
	20240918021016epcas5p14d6e771ee39bee5dddf253c39b84110c~2NKspVdSG2902629026epcas5p1f;
	Wed, 18 Sep 2024 02:10:16 +0000 (GMT)
Received: from epsmgmc1p1new.samsung.com (unknown [182.195.42.40]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240918021016epsmtrp1e9e33ed7808cb8043d28b50da0774e92~2NKsopQyB1650416504epsmtrp17;
	Wed, 18 Sep 2024 02:10:16 +0000 (GMT)
X-AuditID: b6c32a4b-613ff700000025aa-e2-66ea36a4f73d
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmc1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	7A.B5.07567.8863AE66; Wed, 18 Sep 2024 11:10:16 +0900 (KST)
Received: from testpc11818.samsungds.net (unknown [109.105.118.18]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240918021015epsmtip12bb6b10ee58bc7ef822daf5a7a49d632~2NKrfmte33116131161epsmtip1K;
	Wed, 18 Sep 2024 02:10:15 +0000 (GMT)
From: hexue <xue01.he@samsung.com>
To: axboe@kernel.dk, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, hexue
	<xue01.he@samsung.com>
Subject: [PATCH v8 RESEND] io_uring: releasing CPU resources when polling
Date: Wed, 18 Sep 2024 10:10:10 +0800
Message-Id: <20240918021010.12894-1-xue01.he@samsung.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLKsWRmVeSWpSXmKPExsWy7bCmlu4Ss1dpBsumslnMWbWN0WL13X42
	i3et51gsfnXfZbS4vGsOm8XZCR9YLbounGJzYPfYOesuu8fls6UefVtWMXp83iQXwBKVbZOR
	mpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDdICSQlliTilQ
	KCCxuFhJ386mKL+0JFUhI7+4xFYptSAlp8CkQK84Mbe4NC9dLy+1xMrQwMDIFKgwITvjyf1p
	TAWrXCq2rJ/J2MA40byLkZNDQsBEouNHN3sXIxeHkMBuRokLB8+yQDifGCX+nNsBlfnGKLH0
	8m8WmJbl8/pYIRJ7GSVWzX3BCOH8YJS4vPEEK0gVm4CSxP4tHxhBbBEBbYnXj6cCdXNwMAtE
	SbxYyw0SFhbwlOg808kOYrMIqEps3bIKzOYVsJSY3DcHapm8xM2u/cwQcUGJkzOfgMWZgeLN
	W2czg+yVEDjELrFi/w0miAYXiQOnHrND2MISr45vgbKlJF72t0HZ+RKTv69nhLBrJNZtfge1
	zFri35U9UHdqSqzfpQ8RlpWYemodE8RePone30+gVvFK7JgHYytJLDmyAmqkhMTvCYtYIWwP
	iQnP/4PdLyQQK/Hpzi/2CYzys5C8MwvJO7MQNi9gZF7FKJlaUJybnlpsWmCcl1oOj9jk/NxN
	jOB0qOW9g/HRgw96hxiZOBgPMUpwMCuJ8Ip/eJkmxJuSWFmVWpQfX1Sak1p8iNEUGMYTmaVE
	k/OBCTmvJN7QxNLAxMzMzMTS2MxQSZz3devcFCGB9MSS1OzU1ILUIpg+Jg5OqQYmVbMVh67d
	zr/lte5k5tQNm5hDtJ+YJp+/GfDlY0I938SX0bte7EyY1b/9dGxwp8zNldVrfk87/iPpb/Yi
	G8t9G+9bLrQ8EhW+6jjLWwmHGufavg+fHLeqbVh5ndUimr9CLqBN/1bthvVfG7plPkxVEozY
	1bH8mYemWP+MP5c6HtwM4Ul2uKonav/o1PxFkkv5F/X8bfDam3D9j3Bylq7xnB0lErl98rvv
	Myw61y0mcGHF+T2dS8Ws67MVDGNrpttI9jHs0VJaW7dg13zx/UnunbzTJ7s//bfGxebYjrCv
	k56ubnzx9/XMIz5/HsXVMqWs9nh0UvnuydK2Sw8zHFyuGH5WfcX4W1Hr57+2W/NK5iuxFGck
	GmoxFxUnAgAnk7xuEAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOLMWRmVeSWpSXmKPExsWy7bCSnG6H2as0g+MLdC3mrNrGaLH6bj+b
	xbvWcywWv7rvMlpc3jWHzeLshA+sFl0XTrE5sHvsnHWX3ePy2VKPvi2rGD0+b5ILYInisklJ
	zcksSy3St0vgynhyfxpTwSqXii3rZzI2ME4072Lk5JAQMJFYPq+PFcQWEtjNKDH3lzdEXEJi
	x6M/rBC2sMTKf8/Zuxi5gGq+MUq87t8MlmATUJLYv+UDYxcjB4eIgK5E410FkDCzQIzEhz0T
	2EFsYQFPic4znWA2i4CqxNYtq8BsXgFLicl9c1gg5stL3OzazwwRF5Q4OfMJC8QceYnmrbOZ
	JzDyzUKSmoUktYCRaRWjZGpBcW56brJhgWFearlecWJucWleul5yfu4mRnBYamnsYLw3/5/e
	IUYmDsZDjBIczEoivOIfXqYJ8aYkVlalFuXHF5XmpBYfYpTmYFES5zWcMTtFSCA9sSQ1OzW1
	ILUIJsvEwSnVwPTaZ+IPgduP2DVOs90ve6+l/vnU7idKTTvY3QtyHqor+bcr9Of/anU3Elpd
	LHXhH88+u2/RqT5WTJuSF959f3f/kXLpOWt9V86oOcQUUbHm1QFV1dkxDWszEiYs5oifePiX
	a5j+rQB35T8n564zC+HqiW8VfBc5ffmx809LVV0bf65mXRawR6omqFe/JmT/J2FOj0/CfwwU
	U3Sqvzg5fE1Z5LB96tFJtUwSJjvmvP2edK1nVwb/X/87SSyxF5mqHO7pWpzQO7f8RL9m7qpv
	mVOYtbesudn1Od1j+TslJwW5GSXpnrlCYo/anWc1CHRxeF9frtiZOFPl38vo/Qcyqzbf2i52
	iMVSSv27zezztkosxRmJhlrMRcWJANtZQv66AgAA
X-CMS-MailID: 20240918021016epcas5p14d6e771ee39bee5dddf253c39b84110c
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240918021016epcas5p14d6e771ee39bee5dddf253c39b84110c
References: <CGME20240918021016epcas5p14d6e771ee39bee5dddf253c39b84110c@epcas5p1.samsung.com>

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


