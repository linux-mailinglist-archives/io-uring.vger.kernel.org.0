Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70F9865C383
	for <lists+io-uring@lfdr.de>; Tue,  3 Jan 2023 17:05:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233259AbjACQFk (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 3 Jan 2023 11:05:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233189AbjACQF1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 3 Jan 2023 11:05:27 -0500
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 832BC1263A;
        Tue,  3 Jan 2023 08:05:26 -0800 (PST)
Received: by mail-ej1-f45.google.com with SMTP id vm8so67976329ejc.2;
        Tue, 03 Jan 2023 08:05:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ALdfU8ZO8rqFBn1mDer2pV3gsBHbhPZCOUnZOd4Obdo=;
        b=pqA74LmIQawWlAhzY9g4gtDh2WN0DHnKAtJX4ZOB10t9A9MxPHAHVUNbWuYSFeGdGY
         krQmYs6V91Tfgl9Boh9DXPSjASGMwWoyaZKJE1ccQ5LkaDJ/qmhZC1EDaFCWxbLZAc3h
         U13vQTWAvxfLrS821arqS+H5Lm32jDafUV5CLSMKiwNlQTiJ6zmsniG15OrarNdZ3s1U
         UtB5hpanXQhrNksFJggPYOyit+/Y1Z7pfW3zKltddF4Jpfy/nvR0BNkFWs52waVo9maw
         HpccypeoMjZiMxrY2Y3WSg3FjJ7xJvFOKKa24SFErgwUYzoC+fhSv06JBwuX/G1IOwVU
         C9Bw==
X-Gm-Message-State: AFqh2krnOGTO0Wlsg1w/oxBiNIPHQCafgpmDX3T58G+0tI0Z7yWqQaen
        9Grg0egKFSk4Hh8a48W95n17xTa+SIJ8NUog
X-Google-Smtp-Source: AMrXdXuKseAICDbA0WwcriUo7oNQ/ud4AdOzksIdFppMr2SfMvg01pHklF6xfFwElrcAD8r2FsmRUw==
X-Received: by 2002:a17:907:d306:b0:84c:95c7:3036 with SMTP id vg6-20020a170907d30600b0084c95c73036mr15257977ejc.5.1672761925026;
        Tue, 03 Jan 2023 08:05:25 -0800 (PST)
Received: from localhost (fwdproxy-cln-005.fbsv.net. [2a03:2880:31ff:5::face:b00c])
        by smtp.gmail.com with ESMTPSA id kv3-20020a17090778c300b007c00323cc23sm14216260ejc.27.2023.01.03.08.05.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Jan 2023 08:05:24 -0800 (PST)
From:   leitao@debian.org
To:     dylany@meta.com, axboe@kernel.dk, asml.silence@gmail.com,
        io-uring@vger.kernel.org
Cc:     leit@meta.com, linux-kernel@vger.kernel.org,
        Breno Leitao <leitao@debian.org>
Subject: [PATCH] io_uring/msg_ring: Pass custom flags to the cqe
Date:   Tue,  3 Jan 2023 08:05:07 -0800
Message-Id: <20230103160507.617416-1-leitao@debian.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Breno Leitao <leitao@debian.org>

This patch adds a new flag (IORING_MSG_RING_FLAGS_PASS) in the message
ring operations (IORING_OP_MSG_RING). This new flag enables the sender
to specify custom flags, which will be copied over to cqe->flags in the
receiving ring.  These custom flags should be specified using the
sqe->file_index field.

This mechanism provides additional flexibility when sending messages
between rings.

The changes on liburing side could be seen at
https://github.com/axboe/liburing/pull/765

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 include/uapi/linux/io_uring.h |  2 ++
 io_uring/msg_ring.c           | 23 +++++++++++++++++++----
 2 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 2780bce62faf..636a4c2c1294 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -347,6 +347,8 @@ enum {
  *				applicable for IORING_MSG_DATA, obviously.
  */
 #define IORING_MSG_RING_CQE_SKIP	(1U << 0)
+/* Pass through the flags from sqe->file_index to cqe->flags */
+#define IORING_MSG_RING_FLAGS_PASS	(1U << 1)
 
 /*
  * IO completion data structure (Completion Queue Entry)
diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index 2d3cd945a531..dc233f72a541 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -13,6 +13,11 @@
 #include "filetable.h"
 #include "msg_ring.h"
 
+
+/* All valid masks for MSG_RING */
+#define IORING_MSG_RING_MASK		(IORING_MSG_RING_CQE_SKIP | \
+					IORING_MSG_RING_FLAGS_PASS)
+
 struct io_msg {
 	struct file			*file;
 	struct file			*src_file;
@@ -21,7 +26,10 @@ struct io_msg {
 	u32 len;
 	u32 cmd;
 	u32 src_fd;
-	u32 dst_fd;
+	union {
+		u32 dst_fd;
+		u32 cqe_flags;
+	};
 	u32 flags;
 };
 
@@ -57,10 +65,17 @@ static int io_msg_ring_data(struct io_kiocb *req)
 {
 	struct io_ring_ctx *target_ctx = req->file->private_data;
 	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
+	u32 flags = 0;
 
-	if (msg->src_fd || msg->dst_fd || msg->flags)
+	if (msg->src_fd || msg->flags & ~IORING_MSG_RING_FLAGS_PASS)
 		return -EINVAL;
 
+	if (!(msg->flags & IORING_MSG_RING_FLAGS_PASS) && msg->dst_fd)
+		return -EINVAL;
+
+	if (msg->flags & IORING_MSG_RING_FLAGS_PASS)
+		flags = msg->cqe_flags;
+
 	if (target_ctx->task_complete && current != target_ctx->submitter_task) {
 		init_task_work(&msg->tw, io_msg_tw_complete);
 		if (task_work_add(target_ctx->submitter_task, &msg->tw,
@@ -71,7 +86,7 @@ static int io_msg_ring_data(struct io_kiocb *req)
 		return IOU_ISSUE_SKIP_COMPLETE;
 	}
 
-	if (io_post_aux_cqe(target_ctx, msg->user_data, msg->len, 0))
+	if (io_post_aux_cqe(target_ctx, msg->user_data, msg->len, flags))
 		return 0;
 
 	return -EOVERFLOW;
@@ -207,7 +222,7 @@ int io_msg_ring_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	msg->src_fd = READ_ONCE(sqe->addr3);
 	msg->dst_fd = READ_ONCE(sqe->file_index);
 	msg->flags = READ_ONCE(sqe->msg_ring_flags);
-	if (msg->flags & ~IORING_MSG_RING_CQE_SKIP)
+	if (msg->flags & ~IORING_MSG_RING_MASK)
 		return -EINVAL;
 
 	return 0;
-- 
2.30.2

