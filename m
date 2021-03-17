Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 445E133FACE
	for <lists+io-uring@lfdr.de>; Wed, 17 Mar 2021 23:11:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229944AbhCQWK7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Mar 2021 18:10:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230032AbhCQWKg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Mar 2021 18:10:36 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CAC4C06174A
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 15:10:36 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id v3so3027199ilj.12
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 15:10:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=INWD228NDqgvD4EQCIgWqmgA38TSZn5zi4fEppVIAaE=;
        b=JUuWX7jXSv7otlp/27lCUgHF6L3SHeEVV0M7xfAPdMkGPo+7qq8uuY5NGNUt60M/4e
         lAFtN8vfKmVH6pdcJdzGyn9nMEgtUlIHdTFBGIv+EN6DWz4HS+XWpSYuO5TwEIP00s8l
         uIuv0qD6KQLoiS7I4WAAoLavcT78MHOY3ONW800NQElifiBRzRTFeE6e1O6oAFqDBayR
         IjVnYkcnW+Fz26SddIbxHn1iYHeAcctlczlBFhNcZLl91rstJ1bgenA4xaLcDv1Btlhv
         ey87Y6vA0V4MPDONB6LHjRkhmtYOaVl+vex9qIitod9nJ9Y2+8q0A10Q53367jzwZ3dX
         L3CQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=INWD228NDqgvD4EQCIgWqmgA38TSZn5zi4fEppVIAaE=;
        b=uNY0PsCcikjGUv48ID8Xe4159hNTUksYwgxAvADZ3Trs+ECQ8z2EXjYpF1GkdYEOyZ
         teWl0BU/vvmDeXrzdVNLoBYAk2LgXsBJwMO0dgDCNdrPmxLgJeHPjMOmXFyckEAMfbee
         KglT5nrPPHZrrLLJgmUnzPkanIFGdmWQqDDm1ALjFz5MTuj7Z+uICZ4x0vrtwJqjldj7
         kxBa7ZEknatM+bQmlme+uNlf/XshCXqCaYayMY+gJDzSuzh879i4Ak5BKpw9a9SnC3m5
         4QDBuY3GBR2DYpZZyacueEZ1yps9OHTeX2Xh7/k6229uosY1LJji8KOk2N0VYsYxVEVL
         bZBw==
X-Gm-Message-State: AOAM532U61k76ajZ5FrF+fsTBG+AAGXtAJJL8NCm5FKnQ0ml5d/RjPwW
        cxIuNNVSp3V8pc2+iq51bBGP2aQs2GNksQ==
X-Google-Smtp-Source: ABdhPJy/mUmlue3lytLdRDmQyub1t+nKmUYu879MJQ25ta1InhoMKLytKtK/XjYEVz3he9ghS2AyUg==
X-Received: by 2002:a92:d5d2:: with SMTP id d18mr8389631ilq.50.1616019035543;
        Wed, 17 Mar 2021 15:10:35 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id r3sm160700ilq.42.2021.03.17.15.10.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 15:10:35 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     joshi.k@samsung.com, hch@lst.de, kbusch@kernel.org,
        linux-nvme@lists.infradead.org, metze@samba.org,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/8] io_uring: add support for IORING_OP_URING_CMD
Date:   Wed, 17 Mar 2021 16:10:23 -0600
Message-Id: <20210317221027.366780-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210317221027.366780-1-axboe@kernel.dk>
References: <20210317221027.366780-1-axboe@kernel.dk>
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
 fs/io_uring.c            | 54 ++++++++++++++++++++++++++++++++++++++++
 include/linux/io_uring.h | 16 ++++++++++++
 2 files changed, 70 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index fecf10e0625f..a66f953f71d4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -770,6 +770,7 @@ struct io_kiocb {
 		struct io_shutdown	shutdown;
 		struct io_rename	rename;
 		struct io_unlink	unlink;
+		struct io_uring_cmd	uring_cmd;
 		/* use only after cleaning per-op data, see io_clean_op() */
 		struct io_completion	compl;
 	};
@@ -1002,6 +1003,7 @@ static const struct io_op_def io_op_defs[] = {
 	[IORING_OP_RENAMEAT] = {},
 	[IORING_OP_UNLINKAT] = {},
 	[IORING_OP_URING_CMD] = {
+		.needs_file		= 1,
 		.offsets		= 1,
 	},
 };
@@ -3565,6 +3567,53 @@ static int io_unlinkat(struct io_kiocb *req, unsigned int issue_flags)
 	return 0;
 }
 
+/*
+ * Called by consumers of io_uring_cmd, if they originally returned
+ * -EIOCBQUEUED upon receiving the command.
+ */
+void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret)
+{
+	struct io_kiocb *req = container_of(cmd, struct io_kiocb, uring_cmd);
+
+	if (ret < 0)
+		req_set_fail_links(req);
+	io_req_complete(req, ret);
+}
+EXPORT_SYMBOL(io_uring_cmd_done);
+
+static int io_uring_cmd_prep(struct io_kiocb *req,
+			     const struct io_uring_sqe *sqe)
+{
+	const struct io_uring_cmd_sqe *csqe = (const void *) sqe;
+	struct io_uring_cmd *cmd = &req->uring_cmd;
+
+	if (!req->file->f_op->uring_cmd)
+		return -EOPNOTSUPP;
+
+	cmd->op = READ_ONCE(csqe->op);
+	cmd->len = READ_ONCE(csqe->len);
+
+	/*
+	 * The payload is the last 40 bytes of an io_uring_cmd_sqe, with the
+	 * type being defined by the recipient.
+	 */
+	memcpy(&cmd->pdu, &csqe->pdu, sizeof(cmd->pdu));
+	return 0;
+}
+
+static int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct file *file = req->file;
+	int ret;
+
+	ret = file->f_op->uring_cmd(&req->uring_cmd, issue_flags);
+	/* queued async, consumer will call io_uring_cmd_done() when complete */
+	if (ret == -EIOCBQUEUED)
+		return 0;
+	io_uring_cmd_done(&req->uring_cmd, ret);
+	return 0;
+}
+
 static int io_shutdown_prep(struct io_kiocb *req,
 			    const struct io_uring_sqe *sqe)
 {
@@ -5858,6 +5907,8 @@ static int io_req_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		return io_renameat_prep(req, sqe);
 	case IORING_OP_UNLINKAT:
 		return io_unlinkat_prep(req, sqe);
+	case IORING_OP_URING_CMD:
+		return io_uring_cmd_prep(req, sqe);
 	}
 
 	printk_once(KERN_WARNING "io_uring: unhandled opcode %d\n",
@@ -6114,6 +6165,9 @@ static int io_issue_sqe(struct io_kiocb *req, unsigned int issue_flags)
 	case IORING_OP_UNLINKAT:
 		ret = io_unlinkat(req, issue_flags);
 		break;
+	case IORING_OP_URING_CMD:
+		ret = io_uring_cmd(req, issue_flags);
+		break;
 	default:
 		ret = -EINVAL;
 		break;
diff --git a/include/linux/io_uring.h b/include/linux/io_uring.h
index 9761a0ec9f95..fd5c8ca40a70 100644
--- a/include/linux/io_uring.h
+++ b/include/linux/io_uring.h
@@ -30,7 +30,20 @@ struct io_uring_task {
 	struct callback_head	task_work;
 };
 
+/*
+ * Note that the first member here must be a struct file, as the
+ * io_uring command layout depends on that.
+ */
+struct io_uring_cmd {
+	struct file	*file;
+	__u16		op;
+	__u16		unused;
+	__u32		len;
+	__u64		pdu[5];	/* 40 bytes available inline for free use */
+};
+
 #if defined(CONFIG_IO_URING)
+void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret);
 struct sock *io_uring_get_socket(struct file *file);
 void __io_uring_task_cancel(void);
 void __io_uring_files_cancel(struct files_struct *files);
@@ -52,6 +65,9 @@ static inline void io_uring_free(struct task_struct *tsk)
 		__io_uring_free(tsk);
 }
 #else
+static inline void io_uring_cmd_done(struct io_uring_cmd *cmd, ssize_t ret)
+{
+}
 static inline struct sock *io_uring_get_socket(struct file *file)
 {
 	return NULL;
-- 
2.31.0

