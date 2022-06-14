Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3162B54B0E1
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 14:37:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242448AbiFNMd6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 08:33:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236203AbiFNMdj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 08:33:39 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B2BF4B1E3
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 05:30:43 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id q15so11035735wrc.11
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 05:30:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZERg2Xd6SMB5hSrov8OFN4NG5smSNMpMwnWVwGCVfsI=;
        b=TMF70ux0ORmxHcwA9Muq6mgAIcWz+yJpMzv9ijdikxSCoMmb0Udhtp3Ydb3I2p3qtu
         LJjc2OJXu53qCvTPces7PzxVVXjBy3Ac5wvvwvfAxTCjRsAgiJirY54qOB5xenw0R83d
         +/dmwKzG3g4NgC3dBtIGZO6UXHaC1eFuCkWipZjZhSAPHKULhzc/SD9SheOcv7Qm/cDe
         5TdhEGwUSaLUsoSQPJkzn+AQ1geqRqJ8V0djrN5u6Ex6x8g9MIy4JagtseGrEWRSu3v7
         9pYNoOk0VPJQywhdHexcGO9m8xzKfC++kLCjRp4oWOUZavo2mk0Y/op/j+hCWcYs8Yug
         Y+lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZERg2Xd6SMB5hSrov8OFN4NG5smSNMpMwnWVwGCVfsI=;
        b=uiRB/Em90K8EKooV2P+51T5tdQmDrP/foSwNqa0wOiIL9/Q3lU5+wAxQbzt1FmWJi8
         fW6VZT4PbwdXZHqRGLORj94O8y+5/rVxJHBlCj9Tr5AoHkePTBSINL0E3iR+Wy1/1Dpi
         Sgz5I2ZJBMv/0yYYVRbyWLfB/aOmbMXRaZlgcYnJFzTHa9Zk45loDqHxa3xhnyqfBUSu
         FN83h8rjZhE2jayIBQouietlVZoSkHxzH8Rl6vcrm7JiV4vhRhFkcEQTsZ7USiCoOMEn
         RLrqpYSVYsHV4Q09GP5WoBrcPjOcsGxtzfD+NNhXrIef9ScrW94IsqepyoAGSQLL+QHw
         l5fA==
X-Gm-Message-State: AJIora+7S1ABF7zeaqhP6Q8kmw3ROEJJiBNk/hV0or+q2qc2jUfdtXTS
        ohCkpPu0yzLGVeCZoi1XMYnMa8tQBqcvpQ==
X-Google-Smtp-Source: AGRyM1vhhogDCG+9fI8tX2qtX7pnPpP15MpF34zHouKVCPi2FfntlG4FTLPjWgfVm8fLlDiMGuuM6Q==
X-Received: by 2002:a5d:6d0c:0:b0:216:2433:5317 with SMTP id e12-20020a5d6d0c000000b0021624335317mr4705534wrq.263.1655209841142;
        Tue, 14 Jun 2022 05:30:41 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id t7-20020a05600c198700b0039c5fb1f592sm12410651wmq.14.2022.06.14.05.30.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 05:30:40 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 05/25] io_uring: move cancel_seq out of io-wq
Date:   Tue, 14 Jun 2022 13:29:43 +0100
Message-Id: <e25a399d960ee8b6b44e53d46968e1075a86f77e.1655209709.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655209709.git.asml.silence@gmail.com>
References: <cover.1655209709.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io-wq doesn't use ->cancel_seq, it's only important to io_uring and
should be stored there.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/cancel.c         |  4 ++--
 io_uring/io-wq.h          |  1 -
 io_uring/io_uring.c       |  2 +-
 io_uring/io_uring_types.h |  1 +
 io_uring/poll.c           | 10 +++++-----
 io_uring/timeout.c        |  4 ++--
 6 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index 83cceb52d82d..2e72231882b7 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -44,9 +44,9 @@ static bool io_cancel_cb(struct io_wq_work *work, void *data)
 			return false;
 	}
 	if (cd->flags & (IORING_ASYNC_CANCEL_ALL|IORING_ASYNC_CANCEL_ANY)) {
-		if (cd->seq == req->work.cancel_seq)
+		if (cd->seq == req->cancel_seq)
 			return false;
-		req->work.cancel_seq = cd->seq;
+		req->cancel_seq = cd->seq;
 	}
 	return true;
 }
diff --git a/io_uring/io-wq.h b/io_uring/io-wq.h
index ba6eee76d028..dbecd27656c7 100644
--- a/io_uring/io-wq.h
+++ b/io_uring/io-wq.h
@@ -155,7 +155,6 @@ struct io_wq_work_node *wq_stack_extract(struct io_wq_work_node *stack)
 struct io_wq_work {
 	struct io_wq_work_node list;
 	unsigned flags;
-	int cancel_seq;
 };
 
 static inline struct io_wq_work *wq_next_work(struct io_wq_work *work)
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 6a94d1682aaf..af9188c8e2eb 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -849,7 +849,7 @@ static void io_prep_async_work(struct io_kiocb *req)
 
 	req->work.list.next = NULL;
 	req->work.flags = 0;
-	req->work.cancel_seq = atomic_read(&ctx->cancel_seq);
+	req->cancel_seq = atomic_read(&ctx->cancel_seq);
 	if (req->flags & REQ_F_FORCE_ASYNC)
 		req->work.flags |= IO_WQ_WORK_CONCURRENT;
 
diff --git a/io_uring/io_uring_types.h b/io_uring/io_uring_types.h
index ca8e25992ece..25e07c3f7b2a 100644
--- a/io_uring/io_uring_types.h
+++ b/io_uring/io_uring_types.h
@@ -486,6 +486,7 @@ struct io_kiocb {
 	/* custom credentials, valid IFF REQ_F_CREDS is set */
 	const struct cred		*creds;
 	struct io_wq_work		work;
+	int				cancel_seq;
 };
 
 struct io_cancel_data {
diff --git a/io_uring/poll.c b/io_uring/poll.c
index 0df5eca93b16..b46973140ffd 100644
--- a/io_uring/poll.c
+++ b/io_uring/poll.c
@@ -405,7 +405,7 @@ static int __io_arm_poll_handler(struct io_kiocb *req,
 	int v;
 
 	INIT_HLIST_NODE(&req->hash_node);
-	req->work.cancel_seq = atomic_read(&ctx->cancel_seq);
+	req->cancel_seq = atomic_read(&ctx->cancel_seq);
 	io_init_poll_iocb(poll, mask, io_poll_wake);
 	poll->file = req->file;
 
@@ -565,9 +565,9 @@ static struct io_kiocb *io_poll_find(struct io_ring_ctx *ctx, bool poll_only,
 		if (poll_only && req->opcode != IORING_OP_POLL_ADD)
 			continue;
 		if (cd->flags & IORING_ASYNC_CANCEL_ALL) {
-			if (cd->seq == req->work.cancel_seq)
+			if (cd->seq == req->cancel_seq)
 				continue;
-			req->work.cancel_seq = cd->seq;
+			req->cancel_seq = cd->seq;
 		}
 		return req;
 	}
@@ -589,9 +589,9 @@ static struct io_kiocb *io_poll_file_find(struct io_ring_ctx *ctx,
 			if (!(cd->flags & IORING_ASYNC_CANCEL_ANY) &&
 			    req->file != cd->file)
 				continue;
-			if (cd->seq == req->work.cancel_seq)
+			if (cd->seq == req->cancel_seq)
 				continue;
-			req->work.cancel_seq = cd->seq;
+			req->cancel_seq = cd->seq;
 			return req;
 		}
 	}
diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index 69cca42d6835..89000aae65d9 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -227,9 +227,9 @@ static struct io_kiocb *io_timeout_extract(struct io_ring_ctx *ctx,
 		    cd->data != tmp->cqe.user_data)
 			continue;
 		if (cd->flags & (IORING_ASYNC_CANCEL_ALL|IORING_ASYNC_CANCEL_ANY)) {
-			if (cd->seq == tmp->work.cancel_seq)
+			if (cd->seq == tmp->cancel_seq)
 				continue;
-			tmp->work.cancel_seq = cd->seq;
+			tmp->cancel_seq = cd->seq;
 		}
 		req = tmp;
 		break;
-- 
2.36.1

