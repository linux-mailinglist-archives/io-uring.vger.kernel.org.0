Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A34A273BD1E
	for <lists+io-uring@lfdr.de>; Fri, 23 Jun 2023 18:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232528AbjFWQtS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Jun 2023 12:49:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232537AbjFWQs3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Jun 2023 12:48:29 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 188222954
        for <io-uring@vger.kernel.org>; Fri, 23 Jun 2023 09:48:20 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-668842bc50dso142760b3a.1
        for <io-uring@vger.kernel.org>; Fri, 23 Jun 2023 09:48:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1687538899; x=1690130899;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v75mpzl9fkP5ZQu9rl58jq//4xdzKQhZFyBCXftL/E4=;
        b=Hf43mXM8enmbqRUypvAOTaPKQ7lIGzkINharwKgiloWSTvlxaD88JE3Ien8s3I5pJJ
         +J5la6mRNgJupGn9Qqkl46/icpcgRWrU0xwJE7FxwZvL5tAs479SsJIXxj8ItmcR66JI
         YY557eEnpuE6h4qINh4vpT6x6cPehJcKGVPNXGIXUGEVIjzcxDom2j7AkdJFPRF46Iaq
         0I4h3XtXrIZ3JcadAmHkU2Vmsv/0RYBSDYjVhVWt7u5NDHzBtmP021g70E4mRmYX+rhm
         ucZBmgAHjSa3Hqu0kS/FCk3rV6Vfzv4CC16K88ZotPgYGqKZjZShr1kGvkGCOMB6JWRk
         lqgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687538899; x=1690130899;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=v75mpzl9fkP5ZQu9rl58jq//4xdzKQhZFyBCXftL/E4=;
        b=gebM4HTNNxVNBcXmXESdvh32a5p9l0z/+0KpnHEMnM2Qm1FUnsIYTrxQDAcSZGxaNY
         EzstZhobYU9CdRHL6yYbBcMlKK6iMfUm80KK/gfBDihWDuK1QqLQqj4uxprpWo9DX6n7
         WEOhoh9JOcwUcT1hLco/TAJqnqp6aRxWPn0HUKMbQRcZB+hqlIExSfNr/wS7kYW1ZjqO
         k1BEwBQ4OSkInxHH23eO0TEmnlyqxn6KyeHBfYgA0/2mMoHk4/17BgWX28kXVjd9K8ms
         RUQdZSjly7AbkJWULLBujyjwHFpZ8mjNNEGvIV9tGVs1eXST7ibf+UdLQc+cWLIJY7mX
         39/g==
X-Gm-Message-State: AC+VfDyAci5rIjNT+eXDDKa4X+kiVFpf1s+S+axlXPkmgNlMpDfTets1
        pkF/4VVqHGokdSfx7355J9Z8aPoWZyn5tDGpozI=
X-Google-Smtp-Source: ACHHUZ7vuanziOmA7zOqFsyN+qjdoAOt7Pc16Cc7u7ebcfgV4j2Wzc1jN+PY2mFpC7V39iZdy4ArmQ==
X-Received: by 2002:a05:6a20:8f04:b0:121:d102:248c with SMTP id b4-20020a056a208f0400b00121d102248cmr16511560pzk.6.1687538898810;
        Fri, 23 Jun 2023 09:48:18 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id n4-20020a170903110400b001b55c0548dfsm7454411plh.97.2023.06.23.09.48.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jun 2023 09:48:17 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 7/8] io_uring/cancel: support opcode based lookup and cancelation
Date:   Fri, 23 Jun 2023 10:48:03 -0600
Message-Id: <20230623164804.610910-8-axboe@kernel.dk>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230623164804.610910-1-axboe@kernel.dk>
References: <20230623164804.610910-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add IORING_ASYNC_CANCEL_OP flag for cancelation, which allows the
application to target cancelation based on the opcode of the original
request.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/uapi/linux/io_uring.h |  2 ++
 io_uring/cancel.c             | 17 ++++++++++++++---
 io_uring/cancel.h             |  2 +-
 io_uring/poll.c               |  3 ++-
 4 files changed, 19 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index e8bf70610568..af3b862fa905 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -298,12 +298,14 @@ enum io_uring_op {
  * IORING_ASYNC_CANCEL_ANY	Match any request
  * IORING_ASYNC_CANCEL_FD_FIXED	'fd' passed in is a fixed descriptor
  * IORING_ASYNC_CANCEL_USERDATA	Match on user_data, default for no other key
+ * IORING_ASYNC_CANCEL_OP	Match request based on opcode
  */
 #define IORING_ASYNC_CANCEL_ALL	(1U << 0)
 #define IORING_ASYNC_CANCEL_FD	(1U << 1)
 #define IORING_ASYNC_CANCEL_ANY	(1U << 2)
 #define IORING_ASYNC_CANCEL_FD_FIXED	(1U << 3)
 #define IORING_ASYNC_CANCEL_USERDATA	(1U << 4)
+#define IORING_ASYNC_CANCEL_OP	(1U << 5)
 
 /*
  * send/sendmsg and recv/recvmsg flags (sqe->ioprio)
diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index 20612e93a354..d91116b032eb 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -22,11 +22,12 @@ struct io_cancel {
 	u64				addr;
 	u32				flags;
 	s32				fd;
+	u8				opcode;
 };
 
 #define CANCEL_FLAGS	(IORING_ASYNC_CANCEL_ALL | IORING_ASYNC_CANCEL_FD | \
 			 IORING_ASYNC_CANCEL_ANY | IORING_ASYNC_CANCEL_FD_FIXED | \
-			 IORING_ASYNC_CANCEL_USERDATA)
+			 IORING_ASYNC_CANCEL_USERDATA | IORING_ASYNC_CANCEL_OP)
 
 /*
  * Returns true if the request matches the criteria outlined by 'cd'.
@@ -38,7 +39,7 @@ bool io_cancel_req_match(struct io_kiocb *req, struct io_cancel_data *cd)
 	if (req->ctx != cd->ctx)
 		return false;
 
-	if (!(cd->flags & (IORING_ASYNC_CANCEL_FD)))
+	if (!(cd->flags & (IORING_ASYNC_CANCEL_FD | IORING_ASYNC_CANCEL_OP)))
 		match_user_data = true;
 
 	if (cd->flags & IORING_ASYNC_CANCEL_ANY)
@@ -47,6 +48,10 @@ bool io_cancel_req_match(struct io_kiocb *req, struct io_cancel_data *cd)
 		if (req->file != cd->file)
 			return false;
 	}
+	if (cd->flags & IORING_ASYNC_CANCEL_OP) {
+		if (req->opcode != cd->opcode)
+			return false;
+	}
 	if (match_user_data && req->cqe.user_data != cd->data)
 		return false;
 	if (cd->flags & IORING_ASYNC_CANCEL_ALL) {
@@ -127,7 +132,7 @@ int io_async_cancel_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 
 	if (unlikely(req->flags & REQ_F_BUFFER_SELECT))
 		return -EINVAL;
-	if (sqe->off || sqe->len || sqe->splice_fd_in)
+	if (sqe->off || sqe->splice_fd_in)
 		return -EINVAL;
 
 	cancel->addr = READ_ONCE(sqe->addr);
@@ -139,6 +144,11 @@ int io_async_cancel_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 			return -EINVAL;
 		cancel->fd = READ_ONCE(sqe->fd);
 	}
+	if (cancel->flags & IORING_ASYNC_CANCEL_OP) {
+		if (cancel->flags & IORING_ASYNC_CANCEL_ANY)
+			return -EINVAL;
+		cancel->opcode = READ_ONCE(sqe->len);
+	}
 
 	return 0;
 }
@@ -185,6 +195,7 @@ int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags)
 		.ctx	= req->ctx,
 		.data	= cancel->addr,
 		.flags	= cancel->flags,
+		.opcode	= cancel->opcode,
 		.seq	= atomic_inc_return(&req->ctx->cancel_seq),
 	};
 	struct io_uring_task *tctx = req->task->io_uring;
diff --git a/io_uring/cancel.h b/io_uring/cancel.h
index 496ce4dac78e..fc98622e6166 100644
--- a/io_uring/cancel.h
+++ b/io_uring/cancel.h
@@ -8,11 +8,11 @@ struct io_cancel_data {
 		u64 data;
 		struct file *file;
 	};
+	u8 opcode;
 	u32 flags;
 	int seq;
 };
 
-
 int io_async_cancel_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_async_cancel(struct io_kiocb *req, unsigned int issue_flags);
 
diff --git a/io_uring/poll.c b/io_uring/poll.c
index dc1219f606e5..65ec363f6377 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -851,7 +851,8 @@ static int __io_poll_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd,
 	struct io_hash_bucket *bucket;
 	struct io_kiocb *req;
 
-	if (cd->flags & (IORING_ASYNC_CANCEL_FD|IORING_ASYNC_CANCEL_ANY))
+	if (cd->flags & (IORING_ASYNC_CANCEL_FD | IORING_ASYNC_CANCEL_OP |
+			 IORING_ASYNC_CANCEL_ANY))
 		req = io_poll_file_find(ctx, cd, table, &bucket);
 	else
 		req = io_poll_find(ctx, false, cd, table, &bucket);
-- 
2.40.1

