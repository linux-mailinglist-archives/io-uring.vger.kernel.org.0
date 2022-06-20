Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 978AA550DD5
	for <lists+io-uring@lfdr.de>; Mon, 20 Jun 2022 02:26:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237207AbiFTA0f (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 19 Jun 2022 20:26:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237222AbiFTA0e (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 19 Jun 2022 20:26:34 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B6E0A1B0
        for <io-uring@vger.kernel.org>; Sun, 19 Jun 2022 17:26:34 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id k22so6021890wrd.6
        for <io-uring@vger.kernel.org>; Sun, 19 Jun 2022 17:26:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=hfKvmNhTq8ja3OOJ0fm7B/LY4GXBKz4A3F1pqiaY4Yo=;
        b=gzoZjgL5nujUiF6Jk87E0f1f4iV7iJmtsSXWBBb8aB7JESXdFi/iLVgcJx3UlSCFZT
         6xkoTzRmTTuUeXgslZZSPcQBXFxskEOsMSQ2SYNRIYik7R4zzJYDn6mclZn6TmRNifY+
         KcoBydQCk4CFtHNoHeCcoF32iQxVO6PaWgvMo90Qwtk0i8p4w3IUaK/Q6/8Js+liRyIj
         idOQdfQfE1HnYfmZtQW/IxldNvH1L4TnhbOOJ4h4F07/vzPKwY/LtSh6BenMAzI9xvsy
         ZKo/80nG0uUvIkbI0utqpHz7sVPQqBnEfSm2WIr1Ou9l9pdhIUXupnSt7LyWcHBSvBoM
         JwGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hfKvmNhTq8ja3OOJ0fm7B/LY4GXBKz4A3F1pqiaY4Yo=;
        b=QY+03iv77v0ST9lviumJ1aEFnGOvCCkfYCGkVdDfmwt/l1G/0VWYA4zLwrVJ7tHAyb
         jXFezeAkKzUGWsFV63BoUWA54SGLCgTa8HBK+Faml3pS+/+lJsFIFCQj4fFm0c+ov79H
         rT/CTYjFJad6xv/h/Fdv7ik6pWjPMZWchLgRcnRMjGcJrTUv7HZW9AwEFYU61RQFJSC1
         CtyreIwzpdnKqrPAfUklcHN8qT1Fm3yidZe2snW63xRhx2+P1Cd8lUvW3eUpwX3JEVZX
         P6f80gS5c6xt7HVRPVS++7IEOq8sMjbj2UUNJsAsljBWHgDf/x+pbh4ByaHPXSh2aHY0
         45xg==
X-Gm-Message-State: AJIora+3q+vMPAXMoZaPgclWy8js7cNg46M4NzoU9Hmc1CZQ4+u3YZDH
        C+ztRsEdhfrltTzQKevm9MLZSMdNMVCZfg==
X-Google-Smtp-Source: AGRyM1sHC8oLKpLfU9Xp6CZ0211j/P+Sfy9PziprLoVxp6G1s0Oj1BQKo47kI4DHInd1J8BlBJlBRw==
X-Received: by 2002:a5d:5342:0:b0:210:c508:956d with SMTP id t2-20020a5d5342000000b00210c508956dmr20801948wrv.205.1655684792423;
        Sun, 19 Jun 2022 17:26:32 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id h18-20020a5d4312000000b002167efdd549sm11543807wrq.38.2022.06.19.17.26.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jun 2022 17:26:31 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 02/10] io_uring: improve task exit timeout cancellations
Date:   Mon, 20 Jun 2022 01:25:53 +0100
Message-Id: <ab8a7440a60bbdf69ae514f672ad050e43dd1b03.1655684496.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655684496.git.asml.silence@gmail.com>
References: <cover.1655684496.git.asml.silence@gmail.com>
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

Don't spin trying to cancel timeouts that are reachable but not
cancellable, e.g. already executing.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/timeout.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/io_uring/timeout.c b/io_uring/timeout.c
index 557c637af158..a79a7d6ef1b3 100644
--- a/io_uring/timeout.c
+++ b/io_uring/timeout.c
@@ -49,7 +49,7 @@ static inline void io_put_req(struct io_kiocb *req)
 	}
 }
 
-static void io_kill_timeout(struct io_kiocb *req, int status)
+static bool io_kill_timeout(struct io_kiocb *req, int status)
 	__must_hold(&req->ctx->completion_lock)
 	__must_hold(&req->ctx->timeout_lock)
 {
@@ -64,7 +64,9 @@ static void io_kill_timeout(struct io_kiocb *req, int status)
 			atomic_read(&req->ctx->cq_timeouts) + 1);
 		list_del_init(&timeout->list);
 		io_req_tw_post_queue(req, status, 0);
+		return true;
 	}
+	return false;
 }
 
 __cold void io_flush_timeouts(struct io_ring_ctx *ctx)
@@ -620,10 +622,9 @@ __cold bool io_kill_timeouts(struct io_ring_ctx *ctx, struct task_struct *tsk,
 	list_for_each_entry_safe(timeout, tmp, &ctx->timeout_list, list) {
 		struct io_kiocb *req = cmd_to_io_kiocb(timeout);
 
-		if (io_match_task(req, tsk, cancel_all)) {
-			io_kill_timeout(req, -ECANCELED);
+		if (io_match_task(req, tsk, cancel_all) &&
+		    io_kill_timeout(req, -ECANCELED))
 			canceled++;
-		}
 	}
 	spin_unlock_irq(&ctx->timeout_lock);
 	io_commit_cqring(ctx);
-- 
2.36.1

