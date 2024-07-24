Return-Path: <io-uring+bounces-2557-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E35A93AD9D
	for <lists+io-uring@lfdr.de>; Wed, 24 Jul 2024 10:00:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BC9D828661C
	for <lists+io-uring@lfdr.de>; Wed, 24 Jul 2024 08:00:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DE0D130484;
	Wed, 24 Jul 2024 07:59:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="D92RSHW+"
X-Original-To: io-uring@vger.kernel.org
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78009127E0D
	for <io-uring@vger.kernel.org>; Wed, 24 Jul 2024 07:59:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721807998; cv=none; b=Uw7k9BMhtm19SsNyS3emn/3EeN+j4ekte/aC5RitFOMsaljwpumzXvrQfg05drtl7VFPWdoQuBxcvTXrLBayz5VHD4h279JbW8OgwNjDmXwidebv/N2T5TRoJHJFyIAeI5HTf4OpbrWuYaGAWVEuvr05H53fyjWleflJm2BIxHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721807998; c=relaxed/simple;
	bh=MwCj62zE+eiiY66jfiBVDm+wh25rsSwgj7yEtf5FCLI=;
	h=From:To:Cc:Subject:Date:Message-Id:MIME-Version:Content-Type:
	 References; b=PBQhYk+KiUHH8H83NRDKcbTj45Mj6ykD9G3Ztisj6ePtIyc4vW5rvOD5i+jT/Z3lXO4KAbZmnDXrH4Ih0YY71CcRIIAaagfujBhSarOhwwKXB4n/IIXJI5u6QGTqjaZQv30sfKs1QeRJNdKWFgFZIO0P6kRwGkWu8coxuJ5ixyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=D92RSHW+; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20240724075945epoutp02958a6314ce8a10d478ff18be3f74c762~lFz2CpiTe0511905119epoutp02T
	for <io-uring@vger.kernel.org>; Wed, 24 Jul 2024 07:59:45 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20240724075945epoutp02958a6314ce8a10d478ff18be3f74c762~lFz2CpiTe0511905119epoutp02T
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1721807985;
	bh=EvY4ptdjFq3+BmHsu0pXxBMA1lO6h7rhpQVF7FFThYs=;
	h=From:To:Cc:Subject:Date:References:From;
	b=D92RSHW+Y4iv67SAjT7mJGX5jwBCerDYN1K60zxNtxK+V+SSXVWgMyMHqvqPPXJAF
	 Cqp2y+7erbxmuakIgKbp5wDzk6xLkvrdsRzhQFe/HmlCdb8+ECGWGtxrEDGSgunR7H
	 0hcArlG9I0bveDedT/jZ/z0cjvRzBHlrLt0FJ6mg=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20240724075945epcas5p1195a81ec8c9a84c15521d35fe28d63f3~lFz1uYt2q3007130071epcas5p1Z;
	Wed, 24 Jul 2024 07:59:45 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.179]) by
	epsnrtp3.localdomain (Postfix) with ESMTP id 4WTRHz2M0Mz4x9Q8; Wed, 24 Jul
	2024 07:59:43 +0000 (GMT)
Received: from epcas5p1.samsung.com ( [182.195.41.39]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	A3.41.09642.E64B0A66; Wed, 24 Jul 2024 16:59:42 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20240724075936epcas5p26fd9f74eb54b58bae4f2ceda43af88fe~lFztkdCTO1269212692epcas5p2Q;
	Wed, 24 Jul 2024 07:59:36 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20240724075936epsmtrp29ea4c9807c1742cf6739d5486bec64e9~lFztjhCT60650706507epsmtrp2u;
	Wed, 24 Jul 2024 07:59:36 +0000 (GMT)
X-AuditID: b6c32a4b-613ff700000025aa-ca-66a0b46ed75f
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	93.BE.19367.864B0A66; Wed, 24 Jul 2024 16:59:36 +0900 (KST)
Received: from testpc11818.samsungds.net (unknown [109.105.118.18]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20240724075935epsmtip18d72c35cad6a09eaec69fb6bce69047f~lFzsu2G8i1287512875epsmtip1L;
	Wed, 24 Jul 2024 07:59:35 +0000 (GMT)
From: hexue <xue01.he@samsung.com>
To: axboe@kernel.dk
Cc: asml.silence@gmail.com, io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org, hexue <xue01.he@samsung.com>
Subject: [PATCH v7] io_uring: releasing CPU resources when polling
Date: Wed, 24 Jul 2024 15:59:29 +0800
Message-Id: <20240724075929.19647-1-xue01.he@samsung.com>
X-Mailer: git-send-email 2.40.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrLKsWRmVeSWpSXmKPExsWy7bCmum7elgVpBntecFjMWbWN0WL13X42
	i3et51gsfnXfZbS4vGsOm8XZCR9YLbounGJzYPfYOesuu8fls6UefVtWMXp83iQXwBKVbZOR
	mpiSWqSQmpecn5KZl26r5B0c7xxvamZgqGtoaWGupJCXmJtqq+TiE6DrlpkDdICSQlliTilQ
	KCCxuFhJ386mKL+0JFUhI7+4xFYptSAlp8CkQK84Mbe4NC9dLy+1xMrQwMDIFKgwITtjxaRt
	7AX3HSuWHfrM1MD4z6SLkZNDQsBE4vm956wgtpDAbkaJzc8Fuxi5gOxPjBIfN3Wwwznb+vaz
	wXRcWbWCFSKxk1Hi7s9TUFU/GCVeda0Aq2ITUJLYv+UDI4gtIiAssb+jlQXEZhYokng9cxvY
	PmEBJ4lTe7+AxVkEVCXedD8Fs3kFLCWuv17FDLFNXuJm135miLigxMmZT6DmyEs0b53NDLJY
	QmAXu8SXOS+hznORmN+2gB3CFpZ4dXwLlC0l8fndXqiafInJ39czQtg1Eus2v2OBsK0l/l3Z
	A2RzAC3QlFi/Sx8iLCsx9dQ6Joi9fBK9v58wQcR5JXbMg7GVJJYcWQE1UkLi94RFrBC2h8SP
	F1vZIOEbK3H83X7mCYzys5C8MwvJO7MQNi9gZF7FKJlaUJybnlpsWmCcl1oOj9jk/NxNjOB0
	qOW9g/HRgw96hxiZOBgPMUpwMCuJ8D55NTdNiDclsbIqtSg/vqg0J7X4EKMpMIwnMkuJJucD
	E3JeSbyhiaWBiZmZmYmlsZmhkjjv69a5KUIC6YklqdmpqQWpRTB9TBycUg1M+x5JbN7zVvPT
	5u9bgw9VrbNpP/y0vFNWY/Lrdc36jxxmSn//klfoHbbJZsI58fxbuwPNLfz/Z/ddmZR/8F3m
	oxvHbH8c+T2pWeew/6HrEUHTZV/HROZL2jDKZ9y79D5xxbaFtXs37NGVn8wYfynuelnt3JwH
	dpv5NtQffz3RkmvBhu12Mvpyia9elzQ+0WBaXipvcuzSVwNOSb7W6Zsm7/h+tl7TPO9E/kJ3
	s3UbX3Vf13CZ7nz05OknkS5T1ldrx8f8EtsiPu9krnlgzr4b5nusT1Y7X+Ip/vjmyfG08O85
	pz2s0+82cH3yd2A9XPNuscCmlqNbrHI8S5bNOdbNUigUxqeRtVfeo6Irl0n0rBJLcUaioRZz
	UXEiAMKFV+sQBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrKLMWRmVeSWpSXmKPExsWy7bCSnG7GlgVpBrN+ClrMWbWN0WL13X42
	i3et51gsfnXfZbS4vGsOm8XZCR9YLbounGJzYPfYOesuu8fls6UefVtWMXp83iQXwBLFZZOS
	mpNZllqkb5fAlbFi0jb2gvuOFcsOfWZqYPxn0sXIySEhYCJxZdUK1i5GLg4hge2MEps/7mCF
	SEhI7Hj0B8oWllj57zk7RNE3RonVl3vAEmwCShL7t3xgBLFFgIr2d7SygNjMAmUS71auB6sR
	FnCSOLX3C1icRUBV4k33UzCbV8BS4vrrVcwQC+QlbnbtZ4aIC0qcnPkEao68RPPW2cwTGPlm
	IUnNQpJawMi0ilE0taA4Nz03ucBQrzgxt7g0L10vOT93EyM4JLWCdjAuW/9X7xAjEwfjIUYJ
	DmYlEd4nr+amCfGmJFZWpRblxxeV5qQWH2KU5mBREudVzulMERJITyxJzU5NLUgtgskycXBK
	NTAF6Z3ZGDKje9t2lb/tL+5MPl9y4v6K2n7pi6rGie89o6Kfxbft2X3xcsnR1Yz6U5+rBDob
	h/t329i78K/41mXXLuj5T5hjSSHjew6PybaCf/Zftk2YFXcrvngCN/uf5Y+f/+c+l/eV98jC
	8GKvP4dWuyQqGZ+x8WYtMrefmXtlQ8OFtuZnak91XU4cm1Hx/LyGhtCXuQd2Vd++/E55mUm+
	nNSBI+ySnAr6Jw0E3ZOEd64S/6H2Wum4wLXKeRPfX3vh8SXDcsFHaVPTd2bd547lr26pPd21
	u1L12+sm2Z+/uC0feapvMTDc52ikdaDXctr50G1J76c6xs/V/faV30HnlEPij28PZesarqyy
	TnJUYinOSDTUYi4qTgQAu4MU5LgCAAA=
X-CMS-MailID: 20240724075936epcas5p26fd9f74eb54b58bae4f2ceda43af88fe
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: REQ_APPROVE
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20240724075936epcas5p26fd9f74eb54b58bae4f2ceda43af88fe
References: <CGME20240724075936epcas5p26fd9f74eb54b58bae4f2ceda43af88fe@epcas5p2.samsung.com>

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
index 1a2128459cb4..eff040f5e5f6 100644
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
@@ -1106,6 +1115,83 @@ void io_rw_fail(struct io_kiocb *req)
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
+										poll_flags);
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
@@ -1133,17 +1219,11 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
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


