Return-Path: <io-uring+bounces-2672-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id AAF8494B7E9
	for <lists+io-uring@lfdr.de>; Thu,  8 Aug 2024 09:32:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 613A6281141
	for <lists+io-uring@lfdr.de>; Thu,  8 Aug 2024 07:32:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C06CA12CDBE;
	Thu,  8 Aug 2024 07:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="NSLNq9bD"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AFAF2F23
	for <io-uring@vger.kernel.org>; Thu,  8 Aug 2024 07:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723102367; cv=none; b=C4GVW7kACTjG3i1Ad/RsHn1AleEsvfO7Kt6CHmEKMQVxhTponoyAygKJbc8GYFzntF21arEIBXU1elw4MXrHCHoKJFoGlndFss6Qb1cAGqkChkj+68s0BBK4Ly7oOpiYsiFmgPQJetposLLoeIeCOrVpXdA1aZL39923wNqw8Uo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723102367; c=relaxed/simple;
	bh=cqNish2sPaUlgM6zf1lIGZDVqBz+nPZafITAYSseAfc=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=euDDRuSIzHYukBNKvUI/FUYCURc/9mYElWMr+350RpELvRIVk7iGPndIC/oUT79SPUV9fpAf2Xh5xsHM/D5SPYmEzIDTxTekzkj6sc0Uw1YcNCO9b4iNjuNil0ob4eeAloyw+6Q+zTbGwzx+aY0cZMxfGe4XVHLxBMqlfEs1NHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=NSLNq9bD; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20240808073242epoutp02a77780e05342cf3a4e2887c0299ce1f5~psHgmqvP20353903539epoutp02C
	for <io-uring@vger.kernel.org>; Thu,  8 Aug 2024 07:32:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20240808073242epoutp02a77780e05342cf3a4e2887c0299ce1f5~psHgmqvP20353903539epoutp02C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1723102362;
	bh=UUCk6uRsH8SHF7h5ZO9Nuf/1IJy6fQyZVwmOXiAxEOg=;
	h=From:To:Cc:Subject:Date:References:From;
	b=NSLNq9bDKBHkYlPSjMiwf01Ug5CABjMCPcWX83gCWDRFsBQE+IW0vv3HEfZZ7ItCt
	 luF3YFlOksYJ3T29i1UQjdn5Z42JWPSyKN8zjAQpagw9LWA4iY+Ru0sfsNRVFV2qKk
	 jS3DhxzruJqy/ZS2YA5lNbC1o2dMIJaU27RBmU5I=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTP id
	20240808073242epcas5p2a96159ac90529e149b9c7c383c430e49~psHgHrYST1495914959epcas5p2r;
	Thu,  8 Aug 2024 07:32:42 +0000 (GMT)
Received: from epsmgec5p1-new.samsung.com (unknown [182.195.38.181]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4Wfdzr2nzSz4x9QS; Thu,  8 Aug
	2024 07:32:40 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmgec5p1-new.samsung.com (Symantec Messaging Gateway) with SMTP id
	8F.13.19863.89474B66; Thu,  8 Aug 2024 16:32:40 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPA id
	20240808071720epcas5p3f6f4f8abc6d4c02523dd4f64153a7cec~pr6F94mRS2136221362epcas5p3B;
	Thu,  8 Aug 2024 07:17:20 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
	epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
	20240808071720epsmtrp1dcfa43b2337bb47b9bcbddd865450478~pr6F9P9Gt1560815608epsmtrp1g;
	Thu,  8 Aug 2024 07:17:20 +0000 (GMT)
X-AuditID: b6c32a50-c73ff70000004d97-10-66b47498f87f
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
	30.E5.08964.00174B66; Thu,  8 Aug 2024 16:17:20 +0900 (KST)
Received: from testpc11818.samsungds.net (unknown [109.105.118.18]) by
	epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
	20240808071719epsmtip2855c50da3224d3c4be37744b01a6d3e1~pr6EtEsbO1505915059epsmtip2f;
	Thu,  8 Aug 2024 07:17:19 +0000 (GMT)
From: hexue <xue01.he@samsung.com>
To: axboe@kernel.dk, asml.silence@gmail.com
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, hexue
	<xue01.he@samsung.com>
Subject: [PATCH v7 RESENT] io_uring: releasing CPU resources when polling
Date: Thu,  8 Aug 2024 15:17:12 +0800
Message-Id: <20240808071712.2429842-1-xue01.he@samsung.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrDKsWRmVeSWpSXmKPExsWy7bCmhu6Mki1pBqdec1nMWbWN0WL13X42
	i3et51gsfnXfZbS4vGsOm8XZCR9YLbounGJzYPfYOesuu8fls6UefVtWMXp83iQXwBKVbZOR
	mpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDdICSQlliTilQ
	KCCxuFhJ386mKL+0JFUhI7+4xFYptSAlp8CkQK84Mbe4NC9dLy+1xMrQwMDIFKgwITtj/9FX
	TAWLnSqWfb/E0sC4w7SLkZNDQsBEYlbzd8YuRi4OIYE9jBKfFzQxQzifGCV+XpzBCuF8Y5Q4
	MGkKM0zL4yn/2EFsIYG9jBKb10RBFP0AslcsBytiE1CS2L/lAyOILSKgLfH68VSWLkYODmaB
	KIkXa7lBwsICnhJ/1x8FK2ERUJWY0LaeFaSEV8Ba4thmZ4hV8hI3u/aDTeQVEJQ4OfMJC4jN
	DBRv3job7FAJgVPsEs13LrBANLhI3OifyAhhC0u8Or6FHcKWknjZ3wZl50tM/r4eqqZGYt3m
	d1C91hL/ruyBOlNTYv0ufYiwrMTUU+uYIPbySfT+fsIEEeeV2DEPxlaSWHJkBdRICYnfExax
	QtgeEnd2LGaDBFWsxKvmXpYJjPKzkLwzC8k7sxA2L2BkXsUolVpQnJuemmxaYKibl1oOj9fk
	/NxNjOBkqBWwg3H1hr96hxiZOBgPMUpwMCuJ8DaHb0oT4k1JrKxKLcqPLyrNSS0+xGgKDOOJ
	zFKiyfnAdJxXEm9oYmlgYmZmZmJpbGaoJM77unVuipBAemJJanZqakFqEUwfEwenVAMTb8CM
	TX2uSy93ftq68p2m34/I3Lh5tufY2RZvut7dE+ycVFr4/ML3GRF3TCSs2/h+nfYREttx6wfT
	Q94jTuLLVt4v+Jzl8Jbl2ItXt3+o55v4dm7bPHFDy0l14Yvz6/i6+hcsCViafiF/ounLSF5R
	Ofnby15ZRewP0+kSbGhdwfAwr1JqX7RbVIjJvSUKUyrahFflGehYb00Tvsjh4b3qnMqaVVNU
	3vwryDGQVopzaj4UcHjr5GhG/qkGk0oOspp9VfmUu0bo0ueF/If7iyv7r15fM8naLHX3n7WP
	2ATWfj56kHXrhAmlBtsPs96UFIoPKbxcbRgq8etc+z2OFnGv5pt72bbt8Z16V2u7TAyLEktx
	RqKhFnNRcSIAt9vVaw8EAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrOLMWRmVeSWpSXmKPExsWy7bCSvC5D4ZY0g11TJSzmrNrGaLH6bj+b
	xbvWcywWv7rvMlpc3jWHzeLshA+sFl0XTrE5sHvsnHWX3ePy2VKPvi2rGD0+b5ILYInisklJ
	zcksSy3St0vgyth/9BVTwWKnimXfL7E0MO4w7WLk5JAQMJF4POUfexcjF4eQwG5GiTU33zND
	JCQkdjz6wwphC0us/Pccqugbo0T/ss0sIAk2ASWJ/Vs+MHYxcnCICOhKNN5VAAkzC8RIfNgz
	gR3EFhbwlPi7/igjiM0ioCoxoW09K0g5r4C1xLHNzhDj5SVudu0HW8srIChxcuYTFogx8hLN
	W2czT2Dkm4UkNQtJagEj0ypGydSC4tz03GLDAsO81HK94sTc4tK8dL3k/NxNjOCw1NLcwbh9
	1Qe9Q4xMHIyHGCU4mJVEeJvDN6UJ8aYkVlalFuXHF5XmpBYfYpTmYFES5xV/0ZsiJJCeWJKa
	nZpakFoEk2Xi4JRqYMo/yRZi8tHhGMOrqguepsvZLjhltFq6t1foHvXseZ+69GmH7If0Yz09
	+f/MzeIez17WsIhhRumSzZubTlt45551er1IZvvU2Um1T3oXz+fauKhb327zrTdTZm0tfsuT
	w7+nfuGhOHv2Y+mmIUf7d/+y2uITx734qq2tWWZxef2S0zHvIo1q1ousfLQnd6JM8J34Ob/W
	NvexXDr7v+aqXblqbaep/oOv8RX+og4LD+u2TLKYoCikk/t6od2T98lLHuxIYmp/abGd21fV
	KEZ3p/Bl4UXrJzyUTl606sK+uNcdz3bNFg7o8Tyf4lkduPeDy8kV/75FfTy0n6ProeaH42Wt
	t6Qflt8tOFLaYDxpU7ESS3FGoqEWc1FxIgCxdsNhugIAAA==
X-CMS-MailID: 20240808071720epcas5p3f6f4f8abc6d4c02523dd4f64153a7cec
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240808071720epcas5p3f6f4f8abc6d4c02523dd4f64153a7cec
References: <CGME20240808071720epcas5p3f6f4f8abc6d4c02523dd4f64153a7cec@epcas5p3.samsung.com>

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
changes of RESENT:
- rebase code on for-6.12/io_uring

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
 include/linux/io_uring_types.h |   6 ++
 include/uapi/linux/io_uring.h  |   1 +
 io_uring/io_uring.c            |   3 +-
 io_uring/rw.c                  | 100 +++++++++++++++++++++++++++++----
 4 files changed, 99 insertions(+), 11 deletions(-)

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
index c004d21e2f12..eb9791b50d36 100644
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
@@ -1105,6 +1114,83 @@ void io_rw_fail(struct io_kiocb *req)
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
@@ -1132,17 +1218,11 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
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


