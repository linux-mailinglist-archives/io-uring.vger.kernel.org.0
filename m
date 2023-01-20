Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6D756759D1
	for <lists+io-uring@lfdr.de>; Fri, 20 Jan 2023 17:22:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229834AbjATQWU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Jan 2023 11:22:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229936AbjATQWT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Jan 2023 11:22:19 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F3F45648C
        for <io-uring@vger.kernel.org>; Fri, 20 Jan 2023 08:22:14 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id bk15so15202905ejb.9
        for <io-uring@vger.kernel.org>; Fri, 20 Jan 2023 08:22:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lL/MFQt8b8dhap63osJLhrmA3bFPT55Fdb32RgCKHtM=;
        b=XpnNg3W57ntM/qtWoQLEGLuGEEe8oycuXUmfYOlzQkukfykPLHLF/S+J0b28/+jH7+
         rbNbZU/pyY4VyoNxrSeyvQGt6nm11eCYKcR2km2Xj9Zl4VAWugn8zleeSZBsbgt5swxr
         Mqz8Y4ApG2XaZjbJjKOHrxrfnzInj+AB0St1asGi8LqV+E+sO1CQjODrZS8l9CB+VmP3
         enAtzYtVbtCiQ/nPIPoJB+KJi6rm8DDczQXw57wk0LD1BIcIk8D3LcPRF9FuVgAv/los
         ZPugvTrTSj7sFxJyItp+mPf21l/V+Brst/xa0DydhuBWv/H9FiQ+94IWgKJUU241wBOO
         3+IA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lL/MFQt8b8dhap63osJLhrmA3bFPT55Fdb32RgCKHtM=;
        b=AA6hYSGzEyQUC4ojkfxGf3k9rasZov8SwFqnMli8H9cZWGEr9AoHr4+trdxx/C0mnB
         RBYk593G0Vwhw1OBOElUPU8l1uVzXgTjBCRbNupsMwlNeh1EIrDTdc2IBsAmZx/nMGMy
         kINCgq4umqBQpDDac2sP6ByGK54F6Ts3JqsQXqdWsskAB9qyG7553/03ebGqMahG2RaJ
         Y5AHXvou5B9Xaizf/d00P7fSXuf18Ko36iwlgFEc0PXnbYqlv8yQh13gtTvXsLhhmt0m
         XtKy2S+5m6GYNYJRJKA/xda6A24MKU6oeKsrXnpl0hZ7zy6w+EVCRge8QlApG7w7WYgW
         UiCQ==
X-Gm-Message-State: AFqh2kpCFBK3UkSskLz699kGVtaZ0z6Kq8fVjqWS3AfOpOpp9d8mnMoy
        OP0iLspkrIRnHmKQQR9snJQW9lp5XpI=
X-Google-Smtp-Source: AMrXdXv87X56bSi2Zj3DJw9LKtfjL8u2i44TFQjDuwQcfUA7A0uJSdETQZrNPFKe8tJH7Gyw2JhLKQ==
X-Received: by 2002:a17:907:d406:b0:846:8c9a:68a0 with SMTP id vi6-20020a170907d40600b008468c9a68a0mr18339938ejc.30.1674231732818;
        Fri, 20 Jan 2023 08:22:12 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::2:4670])
        by smtp.gmail.com with ESMTPSA id s12-20020a1709060c0c00b0086621d9d9b0sm11406040ejf.81.2023.01.20.08.22.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jan 2023 08:22:12 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-6.2 2/3] io_uring/msg_ring: fix remote queue to disabled ring
Date:   Fri, 20 Jan 2023 16:21:00 +0000
Message-Id: <845f25277fd30f80ecff4a1352bb10739f300b28.1674231554.git.asml.silence@gmail.com>
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

IORING_SETUP_R_DISABLED rings don't have the submitter task set, so
it's not always safe to use ->submitter_task and we have to check if
it has already been set.

Fixes: 6d043ee1164ca ("io_uring: do msg_ring in target task via tw")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 4 ++--
 io_uring/msg_ring.c | 4 ++++
 2 files changed, 6 insertions(+), 2 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 2ac1cd8d23ea..0a4efada9b3c 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3674,7 +3674,7 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 
 	if (ctx->flags & IORING_SETUP_SINGLE_ISSUER
 	    && !(ctx->flags & IORING_SETUP_R_DISABLED))
-		ctx->submitter_task = get_task_struct(current);
+		WRITE_ONCE(ctx->submitter_task, get_task_struct(current));
 
 	file = io_uring_get_file(ctx);
 	if (IS_ERR(file)) {
@@ -3868,7 +3868,7 @@ static int io_register_enable_rings(struct io_ring_ctx *ctx)
 		return -EBADFD;
 
 	if (ctx->flags & IORING_SETUP_SINGLE_ISSUER && !ctx->submitter_task)
-		ctx->submitter_task = get_task_struct(current);
+		WRITE_ONCE(ctx->submitter_task, get_task_struct(current));
 
 	if (ctx->restrictions.registered)
 		ctx->restricted = 1;
diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index bb868447dcdf..c68cd3898035 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -69,6 +69,10 @@ static int io_msg_exec_remote(struct io_kiocb *req, task_work_func_t func)
 {
 	struct io_ring_ctx *ctx = req->file->private_data;
 	struct io_msg *msg = io_kiocb_to_cmd(req, struct io_msg);
+	struct task_struct *task = READ_ONCE(ctx->submitter_task);
+
+	if (unlikely(!task))
+		return -EOWNERDEAD;
 
 	init_task_work(&msg->tw, func);
 	if (task_work_add(ctx->submitter_task, &msg->tw, TWA_SIGNAL))
-- 
2.38.1

