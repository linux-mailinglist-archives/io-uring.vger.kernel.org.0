Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 438EA6759D2
	for <lists+io-uring@lfdr.de>; Fri, 20 Jan 2023 17:22:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229475AbjATQWV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 20 Jan 2023 11:22:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229966AbjATQWT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 20 Jan 2023 11:22:19 -0500
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20C75E3B0
        for <io-uring@vger.kernel.org>; Fri, 20 Jan 2023 08:22:15 -0800 (PST)
Received: by mail-ej1-x635.google.com with SMTP id vw16so15189825ejc.12
        for <io-uring@vger.kernel.org>; Fri, 20 Jan 2023 08:22:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VgfhYJXc6p1/AlgNYL1c0MKlj8csbE9UKF7fOgnyQxk=;
        b=lPB82oHib2j0TdeQIhpB15CFCYNCcmCe77NzlClq5GwU1DMtOGYg8C9FRAYJRGlqpv
         RCFDRXuf/TJdQuV8I3+O171ixMC/b25UwOZ75ZRi2mEtG/7yL4fdoiLWGpQ72u2oYQqW
         JTUNdMISRd/JRIya/iIVXsFLcilqmekVMytR+W7zEPPSlslPs+gDCEsLEsa7QOzVf5U1
         VxA9hr847OX2CcA93Ysoj1ReEffiaD+A5bhaSH38iLk14vrLNdn2exrpicsUL0bQ6RQP
         urdcftECn5JJ7Et82mZqZ8P3xYnC3hdrqipxxsQHzQ3S2qAt0Vk1mUj3zE3X8ZLdf3kd
         /tuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VgfhYJXc6p1/AlgNYL1c0MKlj8csbE9UKF7fOgnyQxk=;
        b=ycJz0KaYZvAhfuVSdi5wwc8UTzgygtNyIpUc9rhbgwn4znGKBXmyUyTkawBXj8u7Pe
         PU/U2xIy2qBv5u16uWyKpWTOtuLy8O7xhZHx+Z2+4RM74JeEP3ymHInVIHSiT43CdShR
         MmJN8uEniQ9/XFCHKjKLg8VhO77iNX+GUNu9e3mgV2cJ+gUKwJVKT+bfxL/KewaPLbwm
         M09ZTCfM1q+WhRq/aoCnPBnMxGK8EQIOkx+k2z9XKBGc2gSEs9iQJLUC7rHGLkZpReFd
         ChJKDVHObllB/b9eLFitqAcSE8gP4QBaUz7Hgsi2ulkihWG/Dcy08GPFkO3td0Kc3Lie
         7Pig==
X-Gm-Message-State: AFqh2kpMYTQfTrZIKkiQ+0nG/A9WMh9YRpdWG++IwruxExz69ZnKXGn5
        jLvvrrqQzeR4O+BYUtiYeN+3Ft6Mt28=
X-Google-Smtp-Source: AMrXdXtTmLD82l4TOReZB+9E6HCHYq6rKwhE1YShP3ayB7jAO/jQoomBn4sm1tU9wYwhkCJyKlN/ng==
X-Received: by 2002:a17:907:3e18:b0:84d:3403:f4f2 with SMTP id hp24-20020a1709073e1800b0084d3403f4f2mr21279103ejc.62.1674231733576;
        Fri, 20 Jan 2023 08:22:13 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::2:4670])
        by smtp.gmail.com with ESMTPSA id s12-20020a1709060c0c00b0086621d9d9b0sm11406040ejf.81.2023.01.20.08.22.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Jan 2023 08:22:13 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-6.2 3/3] io_uring/msg_ring: optimise with correct tw notify method
Date:   Fri, 20 Jan 2023 16:21:01 +0000
Message-Id: <205404218a6f113709407d596bc5a97ecfabedf9.1674231554.git.asml.silence@gmail.com>
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
index c68cd3898035..12dc9ed3d062 100644
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

