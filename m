Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 381576452BC
	for <lists+io-uring@lfdr.de>; Wed,  7 Dec 2022 04:54:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229838AbiLGDyr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 6 Dec 2022 22:54:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229828AbiLGDyn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 6 Dec 2022 22:54:43 -0500
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEBDD52165
        for <io-uring@vger.kernel.org>; Tue,  6 Dec 2022 19:54:42 -0800 (PST)
Received: by mail-ed1-x536.google.com with SMTP id e13so23144168edj.7
        for <io-uring@vger.kernel.org>; Tue, 06 Dec 2022 19:54:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W6AZVOd5+CvwsZBv9HzpXB3puSLMulw5+42cLdFvuTo=;
        b=jn55tq4vWKouaacc90kTGTerojt/VHK6Yn/SSxrikk9RjqR0EP1r8sItbvfX/JFkNv
         MdEuFnSTZQIgwW6vgSz3xUK9elYg4PEYrdiTNmvBegVmfFvxerrCkkaVjlIZ0FLJNadp
         MMdm/Vws06YPesFe+igfuEobKbu/ng1fj+uRl88j9juhijS6U+9MfV1fSVCgHiDHTY2K
         SuTPQKjHvooel1Z8asBoqZa3iHmAXpNsyUCTAGneRQ7NKngqXcPzqZzo38I8vu9vE07/
         c4KfPozAwU+Epy4scbSJQ7i3n5kYzoJulHMd2RYgkmX7H28qcoyz3gP7PgPjH9dFstzQ
         l2JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W6AZVOd5+CvwsZBv9HzpXB3puSLMulw5+42cLdFvuTo=;
        b=sYd6tUKnppf6pSe5gn5YvniDk++OCwHiZZnk5hAnScLkwepsP4J/IoMV1mQNpTWUgl
         ftN7/omitqYrW0l8IGcPDsNWS/i9bHQP2fFg8UHRS/xzF9L32JAbkd4JfiZ2EeB+bCLd
         wYxIZc+j5+VvhCPDXeczvE+dK6agsP5ikqFzXxVz8JaoPjGPHX2RHBapU4R+asiTJqyG
         SrILAQbTX32bmVIw4oNLKl3yEuQC4fzGzE30cvlBzOQXRJT5DemnqlHm1axsuzzJZJTb
         CTvBCl0z4UucOmtxmrTiPA6lGs0E8ydrBgylujG79aYRwEBuQomYqDpaJJ91/vkaWHz8
         qmdQ==
X-Gm-Message-State: ANoB5plJW+Ozx33PfBZ4B11gbW3+PN9OGQQHm+zm5mrewc68rDH0kTfI
        BCfzjhKEHa7cF5R2T7kyvAyYgiTARUo=
X-Google-Smtp-Source: AA0mqf71qryQdtW4v2qxqvSJDjg/nEnBHw9Bt5iUdgU3BtQ8jkrHxec9P3eugCWeNLnaXbgmcfqIGQ==
X-Received: by 2002:a05:6402:5406:b0:467:4b3d:f2ed with SMTP id ev6-20020a056402540600b004674b3df2edmr63311147edb.101.1670385282137;
        Tue, 06 Dec 2022 19:54:42 -0800 (PST)
Received: from 127.0.0.1localhost (94.196.241.58.threembb.co.uk. [94.196.241.58])
        by smtp.gmail.com with ESMTPSA id 9-20020a170906210900b0073de0506745sm7938939ejt.197.2022.12.06.19.54.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 19:54:41 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next v2 11/12] io_uring: do msg_ring in target task via tw
Date:   Wed,  7 Dec 2022 03:53:36 +0000
Message-Id: <4d76c7b28ed5d71b520de4482fbb7f660f21cd80.1670384893.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1670384893.git.asml.silence@gmail.com>
References: <cover.1670384893.git.asml.silence@gmail.com>
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

While executing in a context of one io_uring instance msg_ring
manipulates another ring. We're trying to keep CQEs posting contained in
the context of the ring-owner task, use task_work to send the request to
the target ring's task when we're modifying its CQ or trying to install
a file. Note, we can't safely use io_uring task_work infra and have to
use task_work directly.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/msg_ring.c | 56 ++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 53 insertions(+), 3 deletions(-)

diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index 525063ac3dab..24e6cc477515 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -16,6 +16,7 @@
 struct io_msg {
 	struct file			*file;
 	struct file			*src_file;
+	struct callback_head		tw;
 	u64 user_data;
 	u32 len;
 	u32 cmd;
@@ -35,6 +36,23 @@ void io_msg_ring_cleanup(struct io_kiocb *req)
 	msg->src_file = NULL;
 }
 
+static void io_msg_tw_complete(struct callback_head *head)
+{
+	struct io_msg *msg = container_of(head, struct io_msg, tw);
+	struct io_kiocb *req = cmd_to_io_kiocb(msg);
+	struct io_ring_ctx *target_ctx = req->file->private_data;
+	int ret = 0;
+
+	if (current->flags & PF_EXITING)
+		ret = -EOWNERDEAD;
+	else if (!io_post_aux_cqe(target_ctx, msg->user_data, msg->len, 0))
+		ret = -EOVERFLOW;
+
+	if (ret < 0)
+		req_set_fail(req);
+	io_req_queue_tw_complete(req, ret);
+}
+
 static int io_msg_ring_data(struct io_kiocb *req)
 {
 	struct io_ring_ctx *target_ctx = req->file->private_data;
@@ -43,6 +61,15 @@ static int io_msg_ring_data(struct io_kiocb *req)
 	if (msg->src_fd || msg->dst_fd || msg->flags)
 		return -EINVAL;
 
+	if (target_ctx->task_complete && current != target_ctx->submitter_task) {
+		init_task_work(&msg->tw, io_msg_tw_complete);
+		if (task_work_add(target_ctx->submitter_task, &msg->tw,
+				  TWA_SIGNAL))
+			return -EOWNERDEAD;
+
+		return IOU_ISSUE_SKIP_COMPLETE;
+	}
+
 	if (io_post_aux_cqe(target_ctx, msg->user_data, msg->len, 0))
 		return 0;
 
@@ -124,6 +151,19 @@ static int io_msg_install_complete(struct io_kiocb *req, unsigned int issue_flag
 	return ret;
 }
 
+static void io_msg_tw_fd_complete(struct callback_head *head)
+{
+	struct io_msg *msg = container_of(head, struct io_msg, tw);
+	struct io_kiocb *req = cmd_to_io_kiocb(msg);
+	int ret = -EOWNERDEAD;
+
+	if (!(current->flags & PF_EXITING))
+		ret = io_msg_install_complete(req, IO_URING_F_UNLOCKED);
+	if (ret < 0)
+		req_set_fail(req);
+	io_req_queue_tw_complete(req, ret);
+}
+
 static int io_msg_send_fd(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_ring_ctx *target_ctx = req->file->private_data;
@@ -140,6 +180,15 @@ static int io_msg_send_fd(struct io_kiocb *req, unsigned int issue_flags)
 		msg->src_file = src_file;
 		req->flags |= REQ_F_NEED_CLEANUP;
 	}
+
+	if (target_ctx->task_complete && current != target_ctx->submitter_task) {
+		init_task_work(&msg->tw, io_msg_tw_fd_complete);
+		if (task_work_add(target_ctx->submitter_task, &msg->tw,
+				  TWA_SIGNAL))
+			return -EOWNERDEAD;
+
+		return IOU_ISSUE_SKIP_COMPLETE;
+	}
 	return io_msg_install_complete(req, issue_flags);
 }
 
@@ -185,10 +234,11 @@ int io_msg_ring(struct io_kiocb *req, unsigned int issue_flags)
 	}
 
 done:
-	if (ret == -EAGAIN)
-		return -EAGAIN;
-	if (ret < 0)
+	if (ret < 0) {
+		if (ret == -EAGAIN || ret == IOU_ISSUE_SKIP_COMPLETE)
+			return ret;
 		req_set_fail(req);
+	}
 	io_req_set_res(req, ret, 0);
 	return IOU_OK;
 }
-- 
2.38.1

