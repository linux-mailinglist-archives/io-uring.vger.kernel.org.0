Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9F21675A22
	for <lists+io-uring@lfdr.de>; Fri, 20 Jan 2023 17:39:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbjATQjG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Jan 2023 11:39:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbjATQjG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Jan 2023 11:39:06 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1CEB6580
        for <io-uring@vger.kernel.org>; Fri, 20 Jan 2023 08:39:02 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id az20so15417340ejc.1
        for <io-uring@vger.kernel.org>; Fri, 20 Jan 2023 08:39:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kNXtuGs/ChtdEeAKTWqgirpCrA/uohpZGq3JkDE5JVo=;
        b=QwaOFeHQRLJYVwVgP2Q4/ZaFlTczZHXPK40kI2LmnWox2UuFIoc/PX+sXWh6PA6sIL
         TLiTPVWo6VBwW2oi9dmo2zIlZb25fg7iD4ZeiN2+H9hV6De+WJ/Lh1a58GWNUQqfm+cW
         2OKosn74L+tiMJjROUmSctWENKeGRFNzq2T7OHPARvoAKZ3iQmjLcB/d77/3QWbBDE3M
         cRNKmX6uBFjaqQwUD6mAvuVtnOjsmUcY9SLMTBilBia/vTRJmqY+DvLBZ6+jtams6bbj
         8Bf4QGhyF8GKS/kIZIe3xA9KutEW7KxmcfHfMaJLSHYAwSDlkqa9UdJyql7yvPQcszwO
         7h0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kNXtuGs/ChtdEeAKTWqgirpCrA/uohpZGq3JkDE5JVo=;
        b=sTOiqwtdZI/MpMH07udsm6O1MHBwMx+pPLDv5feYw7NN++jQDxqvr6DM4Vhd3yMpSB
         BiGYD7STpuB5KmqxbH7HBoTx77PUXeLxNuSF3TYxmAAv1XMSOgbn+fnLcESbC7JpRKTn
         mAmoX5zJbCiupxUweIk6jUtQcm+xfqTuvLNoPZafOP5snZ1UkaaP3anClHFkaxu+igx/
         xduXY1kEQAPy0ltMbA7ghG0nIGqp4kMRDPYL5BfXO4pc1KuVKNAyQpPRRhLjU9VUfMZl
         JK2x/WE4PD4sZHDJrVOWvBT0JOMxIVTexC32TjnCk7NqKCITLyGrnJHboAOQ6rsDgXMw
         3lxw==
X-Gm-Message-State: AFqh2kpoJDEEkTz5RPnCdadmi26BH3yFQ68jIAe8IGcJxzOBfGnaIdBi
        7SgwaefnejctvMMKko8ZlpthKgR/5MY=
X-Google-Smtp-Source: AMrXdXsfipxzwCIgIxJEqEH8FYEbqzCX/Ekj1LVyuT7cykB1ICM1Vki7r2a1FxlV48shdvKU8Ezp4A==
X-Received: by 2002:a17:906:6b8f:b0:877:74e6:67a4 with SMTP id l15-20020a1709066b8f00b0087774e667a4mr6320336ejr.47.1674232740645;
        Fri, 20 Jan 2023 08:39:00 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::2:4670])
        by smtp.gmail.com with ESMTPSA id t27-20020a170906179b00b008762e2b7004sm4702124eje.208.2023.01.20.08.39.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jan 2023 08:39:00 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-6.2 v2 1/3] io_uring/msg_ring: fix flagging remote execution
Date:   Fri, 20 Jan 2023 16:38:05 +0000
Message-Id: <a7f4ea1798499de6e3a8ceb6b669863373f9ac52.1674232514.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1674232514.git.asml.silence@gmail.com>
References: <cover.1674232514.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There is a couple of problems with queueing a tw in io_msg_ring_data()
for remote execution. First, once we queue it the target ring can
go away and so setting IORING_SQ_TASKRUN there is not safe. Secondly,
the userspace might not expect IORING_SQ_TASKRUN.

Extract a helper and uniformly use TWA_SIGNAL without TWA_SIGNAL_NO_IPI
tricks for now, just as it was done in the original patch.

Fixes: 6d043ee1164ca ("io_uring: do msg_ring in target task via tw")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/msg_ring.c | 40 +++++++++++++++++++++++-----------------
 1 file changed, 23 insertions(+), 17 deletions(-)

diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index a333781565d3..bb868447dcdf 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -58,6 +58,25 @@ void io_msg_ring_cleanup(struct io_kiocb *req)
 	msg->src_file = NULL;
 }
 
+static inline bool io_msg_need_remote(struct io_ring_ctx *target_ctx)
+{
+	if (!target_ctx->task_complete)
+		return false;
+	return current != target_ctx->submitter_task;
+}
+
+static int io_msg_exec_remote(struct io_kiocb *req, task_work_func_t func)
+{
+	struct io_ring_ctx *ctx = req->file->private_data;
+	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
+
+	init_task_work(&msg->tw, func);
+	if (task_work_add(ctx->submitter_task, &msg->tw, TWA_SIGNAL))
+		return -EOWNERDEAD;
+
+	return IOU_ISSUE_SKIP_COMPLETE;
+}
+
 static void io_msg_tw_complete(struct callback_head *head)
 {
 	struct io_msg *msg = container_of(head, struct io_msg, tw);
@@ -96,15 +115,8 @@ static int io_msg_ring_data(struct io_kiocb *req, unsigned int issue_flags)
 	if (msg->src_fd || msg->dst_fd || msg->flags)
 		return -EINVAL;
 
-	if (target_ctx->task_complete && current != target_ctx->submitter_task) {
-		init_task_work(&msg->tw, io_msg_tw_complete);
-		if (task_work_add(target_ctx->submitter_task, &msg->tw,
-				  TWA_SIGNAL_NO_IPI))
-			return -EOWNERDEAD;
-
-		atomic_or(IORING_SQ_TASKRUN, &target_ctx->rings->sq_flags);
-		return IOU_ISSUE_SKIP_COMPLETE;
-	}
+	if (io_msg_need_remote(target_ctx))
+		return io_msg_exec_remote(req, io_msg_tw_complete);
 
 	ret = -EOVERFLOW;
 	if (target_ctx->flags & IORING_SETUP_IOPOLL) {
@@ -202,14 +214,8 @@ static int io_msg_send_fd(struct io_kiocb *req, unsigned int issue_flags)
 		req->flags |= REQ_F_NEED_CLEANUP;
 	}
 
-	if (target_ctx->task_complete && current != target_ctx->submitter_task) {
-		init_task_work(&msg->tw, io_msg_tw_fd_complete);
-		if (task_work_add(target_ctx->submitter_task, &msg->tw,
-				  TWA_SIGNAL))
-			return -EOWNERDEAD;
-
-		return IOU_ISSUE_SKIP_COMPLETE;
-	}
+	if (io_msg_need_remote(target_ctx))
+		return io_msg_exec_remote(req, io_msg_tw_fd_complete);
 	return io_msg_install_complete(req, issue_flags);
 }
 
-- 
2.38.1

