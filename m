Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F5785A9538
	for <lists+io-uring@lfdr.de>; Thu,  1 Sep 2022 12:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234294AbiIAK6u (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Sep 2022 06:58:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234278AbiIAK6i (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Sep 2022 06:58:38 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB4AEC120B
        for <io-uring@vger.kernel.org>; Thu,  1 Sep 2022 03:58:36 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id nc14so28928004ejc.4
        for <io-uring@vger.kernel.org>; Thu, 01 Sep 2022 03:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=Ptdaov+t0lsQRnbggPHhuGUW/hDLOu5jgVe0NOTacCo=;
        b=WI7YySC7luA38iaSTNWfDOYWNv9eMOvHROTNpdRUC06epbA/Rg3whEFlvjjFXMozAK
         wsrgtGMP0raFSvl2HIr+AmxwG00AGIpr/Bqn5QODkfkLwZnkK7AJ9ejXoiQKbR8z/Xvg
         xpcL4Y3iYv8nct+liksJsQBQnF4172HOtJAICdE9a83V0RX9x446zV6Sx72TOEw/VXvV
         JtHaKeYLQx6mRplgLtmcR2jW3g19fGDyiyC+ThVG1ePS1VZULjcsyjwtakhljsnWMT+w
         G6SvDWabeG/wdlcxLxG36iEFUV6FwyOIvUq6vGbAE+XtyLXVhFv+MdkfRAk/iX1s52mI
         gGOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=Ptdaov+t0lsQRnbggPHhuGUW/hDLOu5jgVe0NOTacCo=;
        b=XyLJg/PVihI8qCBAQXIR54mXuAT6AmuEocI6WaxpIkAZlj2ycIREcGMEBCJzSSHbSH
         LfohDr4iI1lfOlcNK8k4eaDudQwapZqO22ENrVdmFhD+LX2Ty2KGPLV+J3uHPNY32WlJ
         3aEJu6nE8XJHDWIvWo7C4yF39cn+aTQReWzKYhWM/XkXk6vUvePTS/lYxnnRrC8duaVt
         vXUeGP//JdonkaxZz7ktiqqRBlNOSf1/k7JYxIwokLs9jmo7AE1LeKIL0xEuYG+no6F6
         ONdkG3bz0qugq8YA1rlHO3BCB+XkIDvCwDY/x7aFn3BbHtjQ26DtyDdohImh953Nlg5r
         60YA==
X-Gm-Message-State: ACgBeo1BiVCG/1bF8nlUaJjeqEhpMME6+Zu6lz3YsoGOIMSmjnAIpjRz
        AFoJCpBj/ctPAA9DBOHRePSjeZQNj8k=
X-Google-Smtp-Source: AA6agR7bwOILshPwc6zkPHJfZYSvtXBe50hZcMkKTFDeLVm9df1WxP+89uOiT5wACKzVQlkB0adYeg==
X-Received: by 2002:a17:907:9693:b0:73d:cc84:deb with SMTP id hd19-20020a170907969300b0073dcc840debmr23162076ejc.552.1662029914438;
        Thu, 01 Sep 2022 03:58:34 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:e81f])
        by smtp.gmail.com with ESMTPSA id z14-20020a1709060ace00b0073d6d6e698bsm8277762ejf.187.2022.09.01.03.58.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 03:58:34 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [RFC 3/6] Revert "io_uring: rename IORING_OP_FILES_UPDATE"
Date:   Thu,  1 Sep 2022 11:54:02 +0100
Message-Id: <89edc3905350f91e1b6e26d9dbf42ee44fd451a2.1662027856.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1662027856.git.asml.silence@gmail.com>
References: <cover.1662027856.git.asml.silence@gmail.com>
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

This reverts commit 4379d5f15b3fd4224c37841029178aa8082a242e.

We removed notification flushing, also cleanup uapi preparation changes
to not pollute it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring.h | 12 +-----------
 io_uring/opdef.c              |  9 ++++-----
 io_uring/rsrc.c               | 17 ++---------------
 io_uring/rsrc.h               |  4 ++--
 4 files changed, 9 insertions(+), 33 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 18ae5caf1773..111b651366bd 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -178,8 +178,7 @@ enum io_uring_op {
 	IORING_OP_FALLOCATE,
 	IORING_OP_OPENAT,
 	IORING_OP_CLOSE,
-	IORING_OP_RSRC_UPDATE,
-	IORING_OP_FILES_UPDATE = IORING_OP_RSRC_UPDATE,
+	IORING_OP_FILES_UPDATE,
 	IORING_OP_STATX,
 	IORING_OP_READ,
 	IORING_OP_WRITE,
@@ -228,7 +227,6 @@ enum io_uring_op {
 #define IORING_TIMEOUT_ETIME_SUCCESS	(1U << 5)
 #define IORING_TIMEOUT_CLOCK_MASK	(IORING_TIMEOUT_BOOTTIME | IORING_TIMEOUT_REALTIME)
 #define IORING_TIMEOUT_UPDATE_MASK	(IORING_TIMEOUT_UPDATE | IORING_LINK_TIMEOUT_UPDATE)
-
 /*
  * sqe->splice_flags
  * extends splice(2) flags
@@ -295,14 +293,6 @@ enum io_uring_op {
  */
 #define IORING_ACCEPT_MULTISHOT	(1U << 0)
 
-
-/*
- * IORING_OP_RSRC_UPDATE flags
- */
-enum {
-	IORING_RSRC_UPDATE_FILES,
-};
-
 /*
  * IORING_OP_MSG_RING command types, stored in sqe->addr
  */
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 41410126c1c6..10b301ccf5cd 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -246,13 +246,12 @@ const struct io_op_def io_op_defs[] = {
 		.prep			= io_close_prep,
 		.issue			= io_close,
 	},
-	[IORING_OP_RSRC_UPDATE] = {
+	[IORING_OP_FILES_UPDATE] = {
 		.audit_skip		= 1,
 		.iopoll			= 1,
-		.name			= "RSRC_UPDATE",
-		.prep			= io_rsrc_update_prep,
-		.issue			= io_rsrc_update,
-		.ioprio			= 1,
+		.name			= "FILES_UPDATE",
+		.prep			= io_files_update_prep,
+		.issue			= io_files_update,
 	},
 	[IORING_OP_STATX] = {
 		.audit_skip		= 1,
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 048f7483fe8a..cf3272113214 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -21,7 +21,6 @@ struct io_rsrc_update {
 	u64				arg;
 	u32				nr_args;
 	u32				offset;
-	int				type;
 };
 
 static int io_sqe_buffer_register(struct io_ring_ctx *ctx, struct iovec *iov,
@@ -654,7 +653,7 @@ __cold int io_register_rsrc(struct io_ring_ctx *ctx, void __user *arg,
 	return -EINVAL;
 }
 
-int io_rsrc_update_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+int io_files_update_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_rsrc_update *up = io_kiocb_to_cmd(req, struct io_rsrc_update);
 
@@ -668,7 +667,6 @@ int io_rsrc_update_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (!up->nr_args)
 		return -EINVAL;
 	up->arg = READ_ONCE(sqe->addr);
-	up->type = READ_ONCE(sqe->ioprio);
 	return 0;
 }
 
@@ -711,7 +709,7 @@ static int io_files_update_with_index_alloc(struct io_kiocb *req,
 	return ret;
 }
 
-static int io_files_update(struct io_kiocb *req, unsigned int issue_flags)
+int io_files_update(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_rsrc_update *up = io_kiocb_to_cmd(req, struct io_rsrc_update);
 	struct io_ring_ctx *ctx = req->ctx;
@@ -740,17 +738,6 @@ static int io_files_update(struct io_kiocb *req, unsigned int issue_flags)
 	return IOU_OK;
 }
 
-int io_rsrc_update(struct io_kiocb *req, unsigned int issue_flags)
-{
-	struct io_rsrc_update *up = io_kiocb_to_cmd(req, struct io_rsrc_update);
-
-	switch (up->type) {
-	case IORING_RSRC_UPDATE_FILES:
-		return io_files_update(req, issue_flags);
-	}
-	return -EINVAL;
-}
-
 int io_queue_rsrc_removal(struct io_rsrc_data *data, unsigned idx,
 			  struct io_rsrc_node *node, void *rsrc)
 {
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index f3a9a177941f..9bce15665444 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -167,8 +167,8 @@ static inline u64 *io_get_tag_slot(struct io_rsrc_data *data, unsigned int idx)
 	return &data->tags[table_idx][off];
 }
 
-int io_rsrc_update(struct io_kiocb *req, unsigned int issue_flags);
-int io_rsrc_update_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+int io_files_update(struct io_kiocb *req, unsigned int issue_flags);
+int io_files_update_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 
 int __io_account_mem(struct user_struct *user, unsigned long nr_pages);
 
-- 
2.37.2

