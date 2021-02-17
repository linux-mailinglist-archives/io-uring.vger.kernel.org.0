Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 299F831D9C4
	for <lists+io-uring@lfdr.de>; Wed, 17 Feb 2021 13:51:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232772AbhBQMvT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Feb 2021 07:51:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232768AbhBQMvS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Feb 2021 07:51:18 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 175BCC061574
        for <io-uring@vger.kernel.org>; Wed, 17 Feb 2021 04:50:38 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id l17so2036297wmq.2
        for <io-uring@vger.kernel.org>; Wed, 17 Feb 2021 04:50:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=OonlWob+x+yCpT8kBZtZGeZwMZ43DSEVQRqLiLt1DBk=;
        b=EIaRacb2qbvJxAwy0QO42bXFhVfgHf0hU9BLbYKK7uQGT4cfe0dVpua0diARBRJRgf
         EG2f2N7EO4/eFJrlNoGvVLYfswNoAfpN34DHWYx3u9SrNkwY1zzQS1WukJ5ZcayMnXgL
         wDFRj8IiW5RpYviZ4C4fUOOhQFks/Q1VWx+Myx3aFpYWh+yeUJKP4uIzHRrNr/EbKqHV
         IdR7h1ExhEF6cWZi8uFdYQe9uXpuK5MRP4YReojt7IuR90/LFkB7dFZWEkL3N0T1TOuQ
         RrMwR5gL2vOCTM8Th2epNapoK7K1eSJwpKCssmNNmR2r1tTAgYP7dqdXSC7JPJ3sRViI
         M2yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=OonlWob+x+yCpT8kBZtZGeZwMZ43DSEVQRqLiLt1DBk=;
        b=KU8W3DYSflz7nwx/hrcDneSeiNQm1xlgDJBsbfKBxlPQw3m1l+rZDxaY21BtUEuWx1
         vNDCi/bkSs9G3mCyPsV25rsvs2xiePM432x0zS5jW4d9kYpMUYSiRCfW63CCO1QW49hD
         1e3CYV2nFIq4AEyXSsLtk59raEFxGf0vJrcLrao2PmmDrExN+a5h8Wi9ZH1stjx/3S7z
         i6+MXBeo6iyKld4ngRC6i9/g9Bk1P7FbSpuj2F+G+jbWC8E+JLwEmH3EHGwxhom88LpY
         +7pVhHYs1yqVpQSpQg+telDdlhgpNwKxeNOO34hGkQZvItV+giBGRvr+TAdiVjVHP7oL
         rDCA==
X-Gm-Message-State: AOAM530LcEvJdPCxbbdOtlZMt3ihLbXJt7BrdW0+euT84I1kXouFwsPD
        gNAy+rgBBBLcgTTszvf3drHOr2J/c+1oQA==
X-Google-Smtp-Source: ABdhPJzHKZW1tmJ/jxDHhacFPq/QzOIpoOyswuW700JiEmPY/8Jn/kIf113exdFseyt+Zq1E5s+X2A==
X-Received: by 2002:a05:600c:4c19:: with SMTP id d25mr7125243wmp.181.1613565728913;
        Wed, 17 Feb 2021 04:42:08 -0800 (PST)
Received: from localhost.localdomain ([85.255.235.13])
        by smtp.gmail.com with ESMTPSA id t9sm3589979wrw.76.2021.02.17.04.42.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Feb 2021 04:42:03 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 3/4] io_uring: add IORING_OP_BPF
Date:   Wed, 17 Feb 2021 12:38:05 +0000
Message-Id: <b9ff5972067ba23026e2340d492bf0d06c538468.1613563964.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1613563964.git.asml.silence@gmail.com>
References: <cover.1613563964.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Wire up a new io_uring operation type IORING_OP_BPF, which executes a
specified BPF program from the registered prog table. It doesn't allow
to do anything useful for now, no BPF functions are allowed apart from
basic ones.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c                 | 83 +++++++++++++++++++++++++++++++++++
 include/uapi/linux/io_uring.h |  1 +
 2 files changed, 84 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 524cf1eb1cec..716881ca0b48 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -637,6 +637,11 @@ struct io_unlink {
 	struct filename			*filename;
 };
 
+struct io_bpf {
+	struct file			*file;
+	struct bpf_prog			*prog;
+};
+
 struct io_completion {
 	struct file			*file;
 	struct list_head		list;
@@ -773,6 +778,7 @@ struct io_kiocb {
 		struct io_shutdown	shutdown;
 		struct io_rename	rename;
 		struct io_unlink	unlink;
+		struct io_bpf		bpf;
 		/* use only after cleaning per-op data, see io_clean_op() */
 		struct io_completion	compl;
 	};
@@ -839,6 +845,10 @@ struct io_op_def {
 	unsigned		work_flags;
 };
 
+
+struct io_bpf_ctx {
+};
+
 static const struct io_op_def io_op_defs[] = {
 	[IORING_OP_NOP] = {},
 	[IORING_OP_READV] = {
@@ -1029,6 +1039,9 @@ static const struct io_op_def io_op_defs[] = {
 		.work_flags		= IO_WQ_WORK_MM | IO_WQ_WORK_FILES |
 						IO_WQ_WORK_FS | IO_WQ_WORK_BLKCG,
 	},
+	[IORING_OP_BPF]	= {
+		.work_flags		= IO_WQ_WORK_MM,
+	},
 };
 
 static void io_uring_try_cancel_requests(struct io_ring_ctx *ctx,
@@ -1068,6 +1081,7 @@ static int io_setup_async_rw(struct io_kiocb *req, const struct iovec *iovec,
 static void io_req_task_queue(struct io_kiocb *req);
 static void io_submit_flush_completions(struct io_comp_state *cs,
 					struct io_ring_ctx *ctx);
+static void io_bpf_run(struct io_kiocb *req);
 
 static struct kmem_cache *req_cachep;
 
@@ -4208,6 +4222,53 @@ static int io_openat(struct io_kiocb *req, unsigned int issue_flags)
 	return io_openat2(req, issue_flags & IO_URING_F_NONBLOCK);
 }
 
+static int io_bpf_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	struct bpf_prog *prog;
+	unsigned int idx;
+
+	if (unlikely(ctx->flags & (IORING_SETUP_IOPOLL|IORING_SETUP_SQPOLL)))
+		return -EINVAL;
+	if (unlikely(req->flags & (REQ_F_FIXED_FILE | REQ_F_BUFFER_SELECT)))
+		return -EINVAL;
+	if (sqe->ioprio || sqe->len || sqe->cancel_flags)
+		return -EINVAL;
+	if (sqe->addr)
+		return -EINVAL;
+
+	idx = READ_ONCE(sqe->off);
+	if (unlikely(idx >= ctx->nr_bpf_progs))
+		return -EFAULT;
+	idx = array_index_nospec(idx, ctx->nr_bpf_progs);
+	prog = ctx->bpf_progs[idx].prog;
+	if (!prog)
+		return -EFAULT;
+
+	req->bpf.prog = prog;
+	return 0;
+}
+
+static void io_bpf_run_task_work(struct callback_head *cb)
+{
+	struct io_kiocb *req = container_of(cb, struct io_kiocb, task_work);
+	struct io_ring_ctx *ctx = req->ctx;
+
+	mutex_lock(&ctx->uring_lock);
+	io_bpf_run(req);
+	mutex_unlock(&ctx->uring_lock);
+}
+
+static int io_bpf(struct io_kiocb *req, unsigned int issue_flags)
+{
+	init_task_work(&req->task_work, io_bpf_run_task_work);
+	if (unlikely(io_req_task_work_add(req))) {
+		percpu_ref_get(&req->ctx->refs);
+		io_req_task_work_add_fallback(req, io_req_task_cancel);
+	}
+	return 0;
+}
+
 static int io_remove_buffers_prep(struct io_kiocb *req,
 				  const struct io_uring_sqe *sqe)
 {
@@ -6142,6 +6203,8 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return io_renameat_prep(req, sqe);
 	case IORING_OP_UNLINKAT:
 		return io_unlinkat_prep(req, sqe);
+	case IORING_OP_BPF:
+		return io_bpf_prep(req, sqe);
 	}
 
 	printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
@@ -6380,6 +6443,9 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 	case IORING_OP_UNLINKAT:
 		ret = io_unlinkat(req, issue_flags);
 		break;
+	case IORING_OP_BPF:
+		ret = io_bpf(req, issue_flags);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
@@ -10267,6 +10333,23 @@ const struct bpf_verifier_ops bpf_io_uring_verifier_ops = {
 	.is_valid_access	= io_bpf_is_valid_access,
 };
 
+static void io_bpf_run(struct io_kiocb *req)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	struct io_bpf_ctx bpf_ctx;
+
+	lockdep_assert_held(&req->ctx->uring_lock);
+
+	if (unlikely(percpu_ref_is_dying(&ctx->refs))) {
+		io_req_complete(req, -EAGAIN);
+		return;
+	}
+
+	memset(&bpf_ctx, 0, sizeof(bpf_ctx));
+	BPF_PROG_RUN(req->bpf.prog, &bpf_ctx);
+	io_req_complete(req, 0);
+}
+
 SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, unsigned int, opcode,
 		void __user *, arg, unsigned int, nr_args)
 {
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index d95e04d6d316..b75dfbf4f2cb 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -137,6 +137,7 @@ enum {
 	IORING_OP_SHUTDOWN,
 	IORING_OP_RENAMEAT,
 	IORING_OP_UNLINKAT,
+	IORING_OP_BPF,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
-- 
2.24.0

