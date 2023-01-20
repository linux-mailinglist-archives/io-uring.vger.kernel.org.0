Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 391DF675A23
	for <lists+io-uring@lfdr.de>; Fri, 20 Jan 2023 17:39:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbjATQjH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Jan 2023 11:39:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbjATQjG (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Jan 2023 11:39:06 -0500
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD8BECDF9
        for <io-uring@vger.kernel.org>; Fri, 20 Jan 2023 08:39:03 -0800 (PST)
Received: by mail-ej1-x629.google.com with SMTP id ud5so15402185ejc.4
        for <io-uring@vger.kernel.org>; Fri, 20 Jan 2023 08:39:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gE9MO3GkkyiofAW2y8qFay5Pv9XYefZ9N3l0wWOfkt8=;
        b=BYDJioRHr86x2BWXEu/ZAp85zapovJfGmjqEI/GC+6LqhhLZI5LmtdPmOeX2uyZqlh
         oE9fgGE93nuACkZIZzf3c81Kb6doWsFOtO0C0v5c8X3DV7DzKXT/VBR6S1lHxj//Ijev
         i0bOGvsTUfpHN4hCQRaT3PmGZWiymTz2duw1wXQHXAMy5HMPHnnSlhZZfAVTgAT4M1ey
         YDzgyiyf93y5CFnrlksojRluUiFVLfxzFzJZ+FssvgnzIIa+WfMfcTwdM0uDoXoP95Z4
         P68/O50rqrqFN8dEC6GLPVrogCpQgfhn9I3xmtgam++AWrezecuOyhPGWfCcIJLFYRaR
         1Y7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gE9MO3GkkyiofAW2y8qFay5Pv9XYefZ9N3l0wWOfkt8=;
        b=tSsWZM96oVH+BNrUxF0Rzwfl5MeDB0gRS63BBuhK8P2kb4ON1ZYrsftS5K3dTtjdev
         CA1sT3aegwXWkNDlG8m9jaUiP/hDjDb3k62yBZSyOyjwNsBwiMr0TdJlhCOHXtQrsRgx
         AfcSbLpGDCcj57teb+h8BPuZ7C7sWTOCJrJJTJQkGCHGXn0UNHo0EbkEWIh6wxoPEOlm
         EzPxSx6qs3AycycNJSwdGPRPVi41G1VuMf74lXcnPDpcoOFIFmJXuUkx3pt1SCblhSCB
         p/OD03IW2lCbDnW915OaP9jKGuyE4B4iesVUeqYfRSEUI27eyAuXM1qkQ8ZCU0DcjL4w
         h9kA==
X-Gm-Message-State: AFqh2krUtIAl7dO71Q3fHGPYmSku7k47Jp8+OL9AgPPw+x3IitUiZ3BR
        7N46TaKBcXnwsT5+CiSA0gXrVJ/m/No=
X-Google-Smtp-Source: AMrXdXtr3IrdDVepPo/qE+Jk7zkMGrsCm9j1Fs9+W+qv4VR6GzsekKYYozuV390x8/lPRZhJzHrzTQ==
X-Received: by 2002:a17:907:6e05:b0:871:dd2:4afb with SMTP id sd5-20020a1709076e0500b008710dd24afbmr25165736ejc.42.1674232742183;
        Fri, 20 Jan 2023 08:39:02 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::2:4670])
        by smtp.gmail.com with ESMTPSA id t27-20020a170906179b00b008762e2b7004sm4702124eje.208.2023.01.20.08.39.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jan 2023 08:39:01 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-6.2 v2 3/3] io_uring/msg_ring: optimise with correct tw notify method
Date:   Fri, 20 Jan 2023 16:38:07 +0000
Message-Id: <018a3d4ce4d8653dd6a6710b959c597b9f98f87e.1674232514.git.asml.silence@gmail.com>
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

We may want to use TWA_SIGNAL_NO_IPI instead of TWA_SIGNAL if the target
ring is configured with IORING_SETUP_COOP_TASKRUN, change
io_msg_exec_remote() to use the target ring's ->notify_method.

The caveat is that we have to set IORING_SQ_TASKRUN if the rings asks
for it. However, once task_work_add() succeeds the target ring might go
away and so we grab a ctx reference to pin the ring until we set
IORING_SQ_TASKRUN.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/msg_ring.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index 15602a136821..af802cd645b4 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -70,15 +70,22 @@ static int io_msg_exec_remote(struct io_kiocb *req, task_work_func_t func)
 	struct io_ring_ctx *ctx = req->file->private_data;
 	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
 	struct task_struct *task = READ_ONCE(ctx->submitter_task);
+	int ret = IOU_ISSUE_SKIP_COMPLETE;
 
 	if (unlikely(!task))
 		return -EOWNERDEAD;
 
+	percpu_ref_get(&ctx->refs);
 	init_task_work(&msg->tw, func);
-	if (task_work_add(ctx->submitter_task, &msg->tw, TWA_SIGNAL))
-		return -EOWNERDEAD;
-
-	return IOU_ISSUE_SKIP_COMPLETE;
+	if (task_work_add(ctx->submitter_task, &msg->tw, ctx->notify_method)) {
+		ret = -EOWNERDEAD;
+		goto out;
+	}
+	if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
+		atomic_or(IORING_SQ_TASKRUN, &ctx->rings->sq_flags);
+out:
+	percpu_ref_put(&ctx->refs);
+	return ret;
 }
 
 static void io_msg_tw_complete(struct callback_head *head)
-- 
2.38.1

