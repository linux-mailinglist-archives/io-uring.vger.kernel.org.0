Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5BA016759D0
	for <lists+io-uring@lfdr.de>; Fri, 20 Jan 2023 17:22:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229847AbjATQWT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Jan 2023 11:22:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229672AbjATQWS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Jan 2023 11:22:18 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9824E56487
        for <io-uring@vger.kernel.org>; Fri, 20 Jan 2023 08:22:13 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id mp20so15213644ejc.7
        for <io-uring@vger.kernel.org>; Fri, 20 Jan 2023 08:22:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kNXtuGs/ChtdEeAKTWqgirpCrA/uohpZGq3JkDE5JVo=;
        b=QEhP2CwCpfdThhnz+396awlWOnS4yOuvezx3naUmfbIGQTK3V8Ta5779GTmUHXleZF
         VgqchxAaImFMo+UZM6QQ6EFkuZeZmvxXE2tlASc1JRbEFA4LGxEe/ZD+yBPdzDQOjtBj
         Yhb7euVGDg1ZvMA7VbT2BTqYe7ehlaqu5kwc4tDR0ra5uABQOT2uqC8WnJ+YJcYYtm3W
         WYG0YVTGy5KIfpoktcRWYM7eqeZvh0o0lzmcQpDJgEwcswGLBMZ5KSdbgwFS2yKt0CUo
         2U8XVtEKvnYz97lFJIdLViFy/8wXw6LpUHhiDoyoQ4wZtcvOH/b1pYrYHw1W7i9oqOii
         eBQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kNXtuGs/ChtdEeAKTWqgirpCrA/uohpZGq3JkDE5JVo=;
        b=k3CX2bdiO2J62WbQ1fGZLGI3xHS/4D+y1L78IhuFI1TLr5IeO35VLwqMIgciemkeod
         iDORQSOLN+piUCqN0VKer5Rf43nRu2rpuohGeeKHvHZw64gnXPl/rwFb7bsEd72sqFAu
         OLJYl7igWZAt4pqj/K07jzePvnGpBVv2LMv/2tjdhGcpyxs8eIAW3NHt/Zrxpu6Gvaxi
         fRJ7HZsSxQEphkmpw3vO9LS3kOPYiHf+GMd60nfLJr33rmoDYqd1VleRDZHdKTjksHin
         Xi1N2rrqpHblf4xy0N1mdqQt5QqnKoBlwKHmJOhexXP276BwzmM1HUWaNtc22ObgUJqH
         UG/A==
X-Gm-Message-State: AFqh2korKVn2cEJaqifLw3h1TZA8S85AdZnh9GZ25CPP8W6IXeqKKWJ5
        P/xnRP8SJX9PKoPAVcsVS2NBuXsASOk=
X-Google-Smtp-Source: AMrXdXvwmBRAk1DOu45sr8hEeh5EIEVkB6TByM9SV3CCs7gFTLFEuO+GofDipGn4xx5fvHtGcVD63Q==
X-Received: by 2002:a17:907:a07b:b0:7c1:3f04:efa2 with SMTP id ia27-20020a170907a07b00b007c13f04efa2mr28555624ejc.29.1674231731878;
        Fri, 20 Jan 2023 08:22:11 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::2:4670])
        by smtp.gmail.com with ESMTPSA id s12-20020a1709060c0c00b0086621d9d9b0sm11406040ejf.81.2023.01.20.08.22.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jan 2023 08:22:11 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-6.2 1/3] io_uring/msg_ring: fix flagging remote execution
Date:   Fri, 20 Jan 2023 16:20:59 +0000
Message-Id: <a7f4ea1798499de6e3a8ceb6b669863373f9ac52.1674231554.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1674231554.git.asml.silence@gmail.com>
References: <cover.1674231554.git.asml.silence@gmail.com>
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

