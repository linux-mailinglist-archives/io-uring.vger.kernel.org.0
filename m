Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3CCE15B22EF
	for <lists+io-uring@lfdr.de>; Thu,  8 Sep 2022 17:59:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230168AbiIHP7H (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 8 Sep 2022 11:59:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230237AbiIHP7G (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 8 Sep 2022 11:59:06 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F563E55BB
        for <io-uring@vger.kernel.org>; Thu,  8 Sep 2022 08:59:05 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id y3so39153703ejc.1
        for <io-uring@vger.kernel.org>; Thu, 08 Sep 2022 08:59:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=YPoIhoDFX2A1i6MxaTOuMCYaYD7lnGFKcVCbZxdaug4=;
        b=dtJwG2IQRnGMTPvQFa+5b18Cwss9mEuL70A5ZmbOd6G+23rmBpygtGPIS0dQpcsidY
         G3Zzi4YOiI1fttMcCBbNeHSS7ilk3WRMP/LpWlWOlh2+/gt8GneBK/XxmbivUjrOXmzm
         kobncWUSA+uUfAvNElyL9SDzYdkukNYoqXI6GDhLEhzKpVrUeIDsp4kkPs8Qv58lgR7U
         m8G90Deh4+u1N7tSwdRMD5eJDOj4RyUPbBApb8XtM8tt65gYfiV279CD6EKZLwqELwql
         52iEH3WUEHnFJOQocr3fGrvU70HWd0CAWsCwU6gZQ5cFz7p92WHVE61TrAMv19U/8GDM
         WT2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=YPoIhoDFX2A1i6MxaTOuMCYaYD7lnGFKcVCbZxdaug4=;
        b=7KFIYnsFv73qi13fT5TfpAkoa8+IYmj2DB8CbOxHGDCYPZbZP7MIDCCooszJqnxIjE
         m7MTIfp/8m+r6FU/BaMaO6pbjh9ntqi2uA5S+UZS23PTsZaBV6PoguQX8a34d1AApOmY
         yOzFIUBml2wO1L2YqUaE2yGZkXQ7C9OUh2OVHiAR+D89QLgzvJo7cZU8kVgPqPDmXgrT
         zLVmR8C40pXxNpJ6bI/HUxbjijb+E32QTLexTmO1lqvAHz5JOTw53rwAo5bDcGzYxCVF
         JipSd4KZxhygR+bR32YNIJFxauBxLF7WZ0TNRePiYcsYqs0HUfk+JPd+yrv7PVfM4U4S
         q2Fg==
X-Gm-Message-State: ACgBeo1Vr9AQW1OI4WJdCCu3MqPA36Lu4TMTIXxiJPG2w3PAuGGuWXfW
        Q5x6AcBJm1GzFNCLtT0Czz0d/WHGX68=
X-Google-Smtp-Source: AA6agR7ERR9NXv2XvpwnkNKFDrHd2dimxQzRVLUe5OFnXP1JyVV4gbuZYX+2w2WE6kbfLph0BAxOpA==
X-Received: by 2002:a17:906:99c5:b0:73d:70c5:1a4f with SMTP id s5-20020a17090699c500b0073d70c51a4fmr6383526ejn.302.1662652744438;
        Thu, 08 Sep 2022 08:59:04 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:cfb9])
        by smtp.gmail.com with ESMTPSA id q26-20020a1709060e5a00b0073872f367cesm1392503eji.112.2022.09.08.08.59.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 08:59:04 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        Dylan Yudaken <dylany@fb.com>
Subject: [PATCH 6/6] io_uring: remove unused return from io_disarm_next
Date:   Thu,  8 Sep 2022 16:56:57 +0100
Message-Id: <9a441c9a32a58bcc586076fa9a7d0dc33f1fb3cb.1662652536.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1662652536.git.asml.silence@gmail.com>
References: <cover.1662652536.git.asml.silence@gmail.com>
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

We removed conditional io_commit_cqring_flush() guarding against
spurious eventfd and the io_disarm_next()'s return value is not used
anymore, just void it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/timeout.c | 13 +++----------
 io_uring/timeout.h |  2 +-
 2 files changed, 4 insertions(+), 11 deletions(-)

diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index 78ea2c64b70e..e8a8c2099480 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -149,11 +149,10 @@ static inline void io_remove_next_linked(struct io_kiocb *req)
 	nxt->link = NULL;
 }
 
-bool io_disarm_next(struct io_kiocb *req)
+void io_disarm_next(struct io_kiocb *req)
 	__must_hold(&req->ctx->completion_lock)
 {
 	struct io_kiocb *link = NULL;
-	bool posted = false;
 
 	if (req->flags & REQ_F_ARM_LTIMEOUT) {
 		link = req->link;
@@ -161,7 +160,6 @@ bool io_disarm_next(struct io_kiocb *req)
 		if (link && link->opcode == IORING_OP_LINK_TIMEOUT) {
 			io_remove_next_linked(req);
 			io_req_tw_post_queue(link, -ECANCELED, 0);
-			posted = true;
 		}
 	} else if (req->flags & REQ_F_LINK_TIMEOUT) {
 		struct io_ring_ctx *ctx = req->ctx;
@@ -169,17 +167,12 @@ bool io_disarm_next(struct io_kiocb *req)
 		spin_lock_irq(&ctx->timeout_lock);
 		link = io_disarm_linked_timeout(req);
 		spin_unlock_irq(&ctx->timeout_lock);
-		if (link) {
-			posted = true;
+		if (link)
 			io_req_tw_post_queue(link, -ECANCELED, 0);
-		}
 	}
 	if (unlikely((req->flags & REQ_F_FAIL) &&
-		     !(req->flags & REQ_F_HARDLINK))) {
-		posted |= (req->link != NULL);
+		     !(req->flags & REQ_F_HARDLINK)))
 		io_fail_links(req);
-	}
-	return posted;
 }
 
 struct io_kiocb *__io_disarm_linked_timeout(struct io_kiocb *req,
diff --git a/io_uring/timeout.h b/io_uring/timeout.h
index 858c62644897..a6939f18313e 100644
--- a/io_uring/timeout.h
+++ b/io_uring/timeout.h
@@ -27,7 +27,7 @@ int io_timeout_cancel(struct io_ring_ctx *ctx, struct io_cancel_data *cd);
 __cold bool io_kill_timeouts(struct io_ring_ctx *ctx, struct task_struct *tsk,
 			     bool cancel_all);
 void io_queue_linked_timeout(struct io_kiocb *req);
-bool io_disarm_next(struct io_kiocb *req);
+void io_disarm_next(struct io_kiocb *req);
 
 int io_timeout_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_link_timeout_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
-- 
2.37.2

