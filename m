Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ED1369AFEF
	for <lists+io-uring@lfdr.de>; Fri, 17 Feb 2023 16:56:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229956AbjBQP4j (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 17 Feb 2023 10:56:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229736AbjBQP4i (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 17 Feb 2023 10:56:38 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08336711B8
        for <io-uring@vger.kernel.org>; Fri, 17 Feb 2023 07:56:09 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id p131so618203iod.1
        for <io-uring@vger.kernel.org>; Fri, 17 Feb 2023 07:56:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1676649366;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MYiRkoDr/59G/WfgT6vWN5FHUskwrwDkk1Z3Z/MPV2k=;
        b=TeeosUCcW+2q4pdcFUzx4HZopnFsMRXRQjjkbdQcJEujb6KA+8aAg7Eux4JlmwShoT
         8tX6FWWziShpNxDk7R/JGO/3LLYqhveDEQO7VjBc0QRjNattdDIKqIxI7Gr2yg/qE4l5
         Udce0+Osw+FMAfs3Y8qrS0luhZ5Krh3/BDi+l89O8MAcry/MEV3CbD5mBlIWIm0MiClc
         Zd0LSXojcR/drDwxTP5RHbA7cUbO6grckxRFdbJaETUnX88fWhzNsE/j8UC+ZZVEJ5Te
         Wr+Mau1d0zUBZeuC9w1Yk/6PO6xJAICJoJEkGiZ5E62AXCZcK/RQVDxcoztgKmthsvc0
         ZOZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676649367;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MYiRkoDr/59G/WfgT6vWN5FHUskwrwDkk1Z3Z/MPV2k=;
        b=580k30vrnT54MqWNzC2Ss3l6HrKeedZpk0p27pUzy1Hnje3iGh51a3+5vsvu4wp0In
         aaoEIGqJXMh9+edC0G8duaCA2MNcsQeZm4Fjh3JrZbW3+ZEC3jivEFoDWaXvLuW+G0qk
         4Tm/q4xh1Ln7Vj9Qgzclz+j1h26HFsEvQF0pU52FldvSvYrClUV4+W09TtJhoQHnc3mZ
         lJ6ZrD1Ohyfx3hE9xyYlsy8YASzqw8zxqrCYAoRIVPD6P+x4/gNZdWFs7bQgWkyuCPgl
         FbiyXDGK2tsKZUe/z2EtzsfhuoLMEcluiixhhD/XYpzzcm0HpM1HCzY5rmp5kdPxrLVS
         MN2w==
X-Gm-Message-State: AO0yUKV1sF2d3g58O1mn3LrezwlJ+rEpq8/2Uzb7VdgsJHCYdql67dYc
        DMPn+8e3Ey8nav0/KPc7NPN7xprlc4uppuLy
X-Google-Smtp-Source: AK7set9vDUvJpJDyCpCatOd60E6Kxyi+nhpVCa+2IdTihcaXU/dY9yojedIzZyG7KSrH1y3yvQwOGw==
X-Received: by 2002:a6b:6619:0:b0:715:f031:a7f5 with SMTP id a25-20020a6b6619000000b00715f031a7f5mr1179298ioc.1.1676649366620;
        Fri, 17 Feb 2023 07:56:06 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id d22-20020a0566022d5600b007046e9e138esm1551156iow.22.2023.02.17.07.56.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Feb 2023 07:56:05 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/4] io_uring: consolidate the put_ref-and-return section of adding work
Date:   Fri, 17 Feb 2023 08:55:57 -0700
Message-Id: <20230217155600.157041-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230217155600.157041-1-axboe@kernel.dk>
References: <20230217155600.157041-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We've got a few cases of this, move them to one section and just use
gotos to get there. Reduces the text section on both arm64 and x86-64,
using gcc-12.2.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 3b915deb4d08..cbe06deb84ff 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1285,17 +1285,15 @@ static void io_req_local_work_add(struct io_kiocb *req)
 
 	percpu_ref_get(&ctx->refs);
 
-	if (!llist_add(&req->io_task_work.node, &ctx->work_llist)) {
-		percpu_ref_put(&ctx->refs);
-		return;
-	}
+	if (!llist_add(&req->io_task_work.node, &ctx->work_llist))
+		goto put_ref;
+
 	/* needed for the following wake up */
 	smp_mb__after_atomic();
 
 	if (unlikely(atomic_read(&req->task->io_uring->in_idle))) {
 		io_move_task_work_from_local(ctx);
-		percpu_ref_put(&ctx->refs);
-		return;
+		goto put_ref;
 	}
 
 	if (ctx->flags & IORING_SETUP_TASKRUN_FLAG)
@@ -1305,6 +1303,8 @@ static void io_req_local_work_add(struct io_kiocb *req)
 
 	if (READ_ONCE(ctx->cq_waiting))
 		wake_up_state(ctx->submitter_task, TASK_INTERRUPTIBLE);
+
+put_ref:
 	percpu_ref_put(&ctx->refs);
 }
 
-- 
2.39.1

