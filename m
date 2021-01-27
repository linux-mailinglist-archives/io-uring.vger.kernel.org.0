Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA5163065F7
	for <lists+io-uring@lfdr.de>; Wed, 27 Jan 2021 22:28:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234524AbhA0V0w (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 27 Jan 2021 16:26:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234467AbhA0V02 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 27 Jan 2021 16:26:28 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9A4DC06174A
        for <io-uring@vger.kernel.org>; Wed, 27 Jan 2021 13:25:48 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id i63so2157522pfg.7
        for <io-uring@vger.kernel.org>; Wed, 27 Jan 2021 13:25:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iE8IBBSqIvD8bU9krz3GMbXrT8aDmXxe1K+naH/+wCQ=;
        b=IZ0PBR8uFF9kmcdO0agKhTNU1U20chTt2a38XmGc91dSevMHB8rlGaiVx4CeiXp++l
         MXj+azY8XP2Im8CSyvlFo7j6x/Qp2OCy8axQYena0NKbsqMI/66Gv5nRI71rfrRHc4du
         5asW1rrH1mpLY5NgsKlNYPNd6BcJplgp831OS24EP5fGfzgullQRN5Rr75iqBqR3YS0G
         NZj5Hjilj255SPbJh0/f3+4oVfN71QKOx2Vdv4XEefLVk/ZtvBfQnCdH3nhPC+C0ojdF
         tfDN7pOzxjh7DDmDmwKm0KzL/hlp2NrrYdHtub/ttoVreLXx53yudkOw9oXQSqBHUAAL
         9uXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iE8IBBSqIvD8bU9krz3GMbXrT8aDmXxe1K+naH/+wCQ=;
        b=jcfykbukYEKsHMlG/GVE27+VjCap1/VEcKZqZC3sNUjtb6kB7I3KCGAKGm/tpeMUiW
         PqSyMaFhSrD742gk8otSI+BdFwYYtYhcL7PmNz4/d/7YI0Ts+X1gVTdhGYz84Y1Cpect
         F9hIHf/nzdTVvwB/Pn09PoBIw1fhU7Q29eyH+p5Mr0OBWmHiB5EIMsTVrlVuP5XiM6vs
         0+bdRnPtFFTf1Fdk4yJZhNYYwGn7xiRz78MmISDO+OC62iD2I+2w57D+0MyK6RiA0Cq+
         49EtNPV8coLmZD867gL4+4upAv8RG+PmxKuu9mfGyDXr3AcQdt49x0j2e2qlPGs+OM1n
         /L6g==
X-Gm-Message-State: AOAM531T8WHBlMloKVwbYnAUTqDSuT3Y3BuTy47TEksQgmOgY7PaVOav
        yORyFG0nqX4ZrODvvaBp9H5oiUUUVTTpLw==
X-Google-Smtp-Source: ABdhPJyHeRFP//Rc0/78jnyTpPLskCPNjCUuM++uZHQ4pV46WR0ksYQlujelUhehBztcnI4oQjzWRA==
X-Received: by 2002:a63:fe13:: with SMTP id p19mr13228423pgh.119.1611782748021;
        Wed, 27 Jan 2021 13:25:48 -0800 (PST)
Received: from localhost.localdomain (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id mm4sm2794349pjb.1.2021.01.27.13.25.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 27 Jan 2021 13:25:47 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/5] io_uring: add support for IORING_OP_URING_CMD
Date:   Wed, 27 Jan 2021 14:25:38 -0700
Message-Id: <20210127212541.88944-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210127212541.88944-1-axboe@kernel.dk>
References: <20210127212541.88944-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is a file private kind of request. io_uring doesn't know what's
in this command type, it's for the file_operations->uring_cmd()
handler to deal with.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c                 | 59 +++++++++++++++++++++++++++++++++++
 include/linux/io_uring.h      | 12 +++++++
 include/uapi/linux/io_uring.h |  1 +
 3 files changed, 72 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 03748faa5295..55c2714a591e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -712,6 +712,7 @@ struct io_kiocb {
 		struct io_shutdown	shutdown;
 		struct io_rename	rename;
 		struct io_unlink	unlink;
+		struct io_uring_cmd	uring_cmd;
 		/* use only after cleaning per-op data, see io_clean_op() */
 		struct io_completion	compl;
 	};
@@ -805,6 +806,8 @@ struct io_op_def {
 	unsigned		needs_async_data : 1;
 	/* should block plug */
 	unsigned		plug : 1;
+	/* doesn't support personality */
+	unsigned		no_personality : 1;
 	/* size of async data needed, if any */
 	unsigned short		async_size;
 	unsigned		work_flags;
@@ -998,6 +1001,11 @@ static const struct io_op_def io_op_defs[] = {
 		.work_flags		= IO_WQ_WORK_MM | IO_WQ_WORK_FILES |
 						IO_WQ_WORK_FS | IO_WQ_WORK_BLKCG,
 	},
+	[IORING_OP_URING_CMD] = {
+		.needs_file		= 1,
+		.no_personality		= 1,
+		.work_flags		= IO_WQ_WORK_MM | IO_WQ_WORK_BLKCG,
+	},
 };
 
 enum io_mem_account {
@@ -3797,6 +3805,47 @@ static int io_unlinkat(struct io_kiocb *req, bool force_nonblock)
 	return 0;
 }
 
+static void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret)
+{
+	struct io_kiocb *req = container_of(cmd, struct io_kiocb, uring_cmd);
+
+	if (ret < 0)
+		req_set_fail_links(req);
+	io_req_complete(req, ret);
+}
+
+static int io_uring_cmd_prep(struct io_kiocb *req,
+			     const struct io_uring_sqe *sqe)
+{
+	struct io_uring_cmd *cmd = &req->uring_cmd;
+
+	if (!req->file->f_op->uring_cmd)
+		return -EOPNOTSUPP;
+
+	memcpy(&cmd->pdu, (void *) &sqe->off, sizeof(cmd->pdu));
+	cmd->done = io_uring_cmd_done;
+	return 0;
+}
+
+static int io_uring_cmd(struct io_kiocb *req, bool force_nonblock)
+{
+	enum io_uring_cmd_flags flags = 0;
+	struct file *file = req->file;
+	int ret;
+
+	if (force_nonblock)
+		flags |= IO_URING_F_NONBLOCK;
+
+	ret = file->f_op->uring_cmd(&req->uring_cmd, flags);
+	/* queued async, consumer will call ->done() when complete */
+	if (ret == -EIOCBQUEUED)
+		return 0;
+	else if (ret < 0)
+		req_set_fail_links(req);
+	io_req_complete(req, ret);
+	return 0;
+}
+
 static int io_shutdown_prep(struct io_kiocb *req,
 			    const struct io_uring_sqe *sqe)
 {
@@ -6093,6 +6142,8 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return io_renameat_prep(req, sqe);
 	case IORING_OP_UNLINKAT:
 		return io_unlinkat_prep(req, sqe);
+	case IORING_OP_URING_CMD:
+		return io_uring_cmd_prep(req, sqe);
 	}
 
 	printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
@@ -6351,6 +6402,9 @@ static int io_issue_sqe(struct io_kiocb *req, bool force_nonblock,
 	case IORING_OP_UNLINKAT:
 		ret = io_unlinkat(req, force_nonblock);
 		break;
+	case IORING_OP_URING_CMD:
+		ret = io_uring_cmd(req, force_nonblock);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
@@ -6865,6 +6919,9 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	if (id) {
 		struct io_identity *iod;
 
+		if (io_op_defs[req->opcode].no_personality)
+			return -EINVAL;
+
 		iod = idr_find(&ctx->personality_idr, id);
 		if (unlikely(!iod))
 			return -EINVAL;
@@ -10260,6 +10317,8 @@ static int __init io_uring_init(void)
 	BUILD_BUG_SQE_ELEM(40, __u16,  buf_index);
 	BUILD_BUG_SQE_ELEM(42, __u16,  personality);
 	BUILD_BUG_SQE_ELEM(44, __s32,  splice_fd_in);
+	BUILD_BUG_ON(offsetof(struct io_uring_sqe, user_data) !=
+		     offsetof(struct io_uring_pdu, reserved));
 
 	BUILD_BUG_ON(ARRAY_SIZE(io_op_defs) != IORING_OP_LAST);
 	BUILD_BUG_ON(__REQ_F_LAST_BIT >= 8 * sizeof(int));
diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 35b2d845704d..e4e822d86e22 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -34,6 +34,18 @@ struct io_uring_task {
 	bool			sqpoll;
 };
 
+struct io_uring_pdu {
+	__u64 data[4];	/* available for free use */
+	__u64 reserved;	/* can't be used by application! */
+	__u64 data2;	/* available or free use */
+};
+
+struct io_uring_cmd {
+	struct file *file;
+	struct io_uring_pdu pdu;
+	void (*done)(struct io_uring_cmd *, ssize_t);
+};
+
 #if defined(CONFIG_IO_URING)
 struct sock *io_uring_get_socket(struct file *file);
 void __io_uring_task_cancel(void);
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index ac4e1738a9af..0a0de40a3a5c 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -137,6 +137,7 @@ enum {
 	IORING_OP_SHUTDOWN,
 	IORING_OP_RENAMEAT,
 	IORING_OP_UNLINKAT,
+	IORING_OP_URING_CMD,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
-- 
2.30.0

