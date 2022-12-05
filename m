Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 45E926421AB
	for <lists+io-uring@lfdr.de>; Mon,  5 Dec 2022 03:45:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231208AbiLECpo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 4 Dec 2022 21:45:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231186AbiLECpn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 4 Dec 2022 21:45:43 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7071FAF8
        for <io-uring@vger.kernel.org>; Sun,  4 Dec 2022 18:45:42 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id n9-20020a05600c3b8900b003d0944dba41so4273631wms.4
        for <io-uring@vger.kernel.org>; Sun, 04 Dec 2022 18:45:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ea7C17AoEV6IEO9YMzkfNZJhWQ5hTG5jtnXDl5YDDSQ=;
        b=U8DK/cdzmeRfwYMGOGn6v9Q4kXU8I6XBz+WSJIOyuLD8LD4xSilW4wpuIxlwT9kdYh
         uNoZBXqAIaHXp2Ggm4poGzdeQcoEm1K0GN6qEqZSPREvWIv8N1Fwj2au3Xcp2ErnI5eO
         jCKrJxEJm7XdaewvAMVBupo+JUVPVaNKvxlzLiQnQwwK//wCnVQn+Kz5pHVNbZX7wdAh
         TAFIfkRozxyY3e8upDRmaR6K0Omk6JrhwN9iDNNiLSGdjgT9NZ/A5Km8ugs71Z3rNKVl
         ThosgA7Iam7O4K3RibWo4AROfCWQE1U4W5SH3ndwY+gFnhbwWbcXlJUwt9Qa0P0Wqn2E
         FozQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ea7C17AoEV6IEO9YMzkfNZJhWQ5hTG5jtnXDl5YDDSQ=;
        b=Ho+Vki6kksX5c8v5EUn7neKuTU7TBYkQPhjKTgFyeu6tEL1wZ8mLTv8x+TEWxkxaUH
         vVa6CrCCpbCSvUPZ7dDXOLBjI9M5m71dDJVHL8voZi4VtjDMkixhmDcf/YkFfjUcWP6Z
         GpqVaBwZGhvX9GNrp61oU0+SJ7EJC/iAxNdPYTUWwKmeD01O6SRD2OkpU33zr1Kqq87W
         UjLukKyI8v3A+XW87OKWZPGVqh0Wj6cToL39d/GnWxGPobkiQZNQeZF90Fn41iWExwny
         T16nlSVayuoCaKDSAEQf1BHL+0UcX1NPrJK/c6nd4ng/0hf+iRC3a+wxe7OiI8hD8Yah
         4f8Q==
X-Gm-Message-State: ANoB5pmZgQGhYY1pphvWUDD0guiDxLWErHW6Ag8vAOGGE7BYuVozOR7F
        /cHnl9KWKhWWymNLEAKSzwTUFS+K+YY=
X-Google-Smtp-Source: AA0mqf47wM5MLXhcd39WZwe1ePp07ahPdGcmKNynUX6HYsLpQHb/W1qmPG52qBmzSASn5UsbgOzC7Q==
X-Received: by 2002:a05:600c:4586:b0:3cf:848a:21cc with SMTP id r6-20020a05600c458600b003cf848a21ccmr51314333wmo.5.1670208341160;
        Sun, 04 Dec 2022 18:45:41 -0800 (PST)
Received: from 127.0.0.1localhost (94.196.241.58.threembb.co.uk. [94.196.241.58])
        by smtp.gmail.com with ESMTPSA id t17-20020a05600c41d100b003cf71b1f66csm15281532wmh.0.2022.12.04.18.45.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Dec 2022 18:45:40 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 5/7] io_uring: post msg_ring CQE in task context
Date:   Mon,  5 Dec 2022 02:44:29 +0000
Message-Id: <bb0e9ee516e182802da798258f303bf22ecdc151.1670207706.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1670207706.git.asml.silence@gmail.com>
References: <cover.1670207706.git.asml.silence@gmail.com>
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

We want to limit post_aux_cqe() to the task context when ->task_complete
is set, and so we can't just deliver a IORING_OP_MSG_RING CQE to another
thread. Instead of trying to invent a new delayed CQE posting mechanism
push them into the overflow list.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 12 ++++++++++++
 io_uring/io_uring.h |  2 ++
 io_uring/msg_ring.c | 14 ++++++++++++--
 3 files changed, 26 insertions(+), 2 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 0c86df7112fb..7fda57dc0e8c 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -860,6 +860,18 @@ bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags
 	return __io_post_aux_cqe(ctx, user_data, res, cflags, true);
 }
 
+bool io_post_aux_cqe_overflow(struct io_ring_ctx *ctx,
+			      u64 user_data, s32 res, u32 cflags)
+{
+	bool filled;
+
+	io_cq_lock(ctx);
+	ctx->cq_extra++;
+	filled = io_cqring_event_overflow(ctx, user_data, res, cflags, 0, 0);
+	io_cq_unlock_post(ctx);
+	return filled;
+}
+
 bool io_aux_cqe(struct io_ring_ctx *ctx, bool defer, u64 user_data, s32 res, u32 cflags,
 		bool allow_overflow)
 {
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 62227ec3260c..a0b11a631e29 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -36,6 +36,8 @@ bool io_post_aux_cqe(struct io_ring_ctx *ctx, u64 user_data, s32 res, u32 cflags
 bool io_aux_cqe(struct io_ring_ctx *ctx, bool defer, u64 user_data, s32 res, u32 cflags,
 		bool allow_overflow);
 void __io_commit_cqring_flush(struct io_ring_ctx *ctx);
+bool io_post_aux_cqe_overflow(struct io_ring_ctx *ctx,
+			      u64 user_data, s32 res, u32 cflags);
 
 struct page **io_pin_pages(unsigned long ubuf, unsigned long len, int *npages);
 
diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index afb543aab9f6..7717fe519b07 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -23,6 +23,16 @@ struct io_msg {
 	u32 flags;
 };
 
+/* post cqes to another ring */
+static int io_msg_post_cqe(struct io_ring_ctx *ctx,
+			   u64 user_data, s32 res, u32 cflags)
+{
+	if (!ctx->task_complete || current == ctx->submitter_task)
+		return io_post_aux_cqe(ctx, user_data, res, cflags);
+	else
+		return io_post_aux_cqe_overflow(ctx, user_data, res, cflags);
+}
+
 static int io_msg_ring_data(struct io_kiocb *req)
 {
 	struct io_ring_ctx *target_ctx = req->file->private_data;
@@ -31,7 +41,7 @@ static int io_msg_ring_data(struct io_kiocb *req)
 	if (msg->src_fd || msg->dst_fd || msg->flags)
 		return -EINVAL;
 
-	if (io_post_aux_cqe(target_ctx, msg->user_data, msg->len, 0))
+	if (io_msg_post_cqe(target_ctx, msg->user_data, msg->len, 0))
 		return 0;
 
 	return -EOVERFLOW;
@@ -116,7 +126,7 @@ static int io_msg_send_fd(struct io_kiocb *req, unsigned int issue_flags)
 	 * completes with -EOVERFLOW, then the sender must ensure that a
 	 * later IORING_OP_MSG_RING delivers the message.
 	 */
-	if (!io_post_aux_cqe(target_ctx, msg->user_data, msg->len, 0))
+	if (!io_msg_post_cqe(target_ctx, msg->user_data, msg->len, 0))
 		ret = -EOVERFLOW;
 out_unlock:
 	io_double_unlock_ctx(ctx, target_ctx, issue_flags);
-- 
2.38.1

