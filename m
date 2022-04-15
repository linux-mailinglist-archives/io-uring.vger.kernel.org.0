Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27A14503172
	for <lists+io-uring@lfdr.de>; Sat, 16 Apr 2022 01:10:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351066AbiDOVLu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Apr 2022 17:11:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350280AbiDOVLt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Apr 2022 17:11:49 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFF07C6EE4
        for <io-uring@vger.kernel.org>; Fri, 15 Apr 2022 14:09:19 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id i27so17106321ejd.9
        for <io-uring@vger.kernel.org>; Fri, 15 Apr 2022 14:09:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6Vs/VBf3x0nqFm28ShiPIE1I0XQO439HKJejn1jTQCI=;
        b=lkRVPzzzc8q0Sqcuk+dOEee1HROP9ljCSE/G39FKIM3ZfkqYBUJr1JsKCMzEVi9bey
         l+nk4K1DsgaKqi/C2Y4PskyqBd6CVoiemiABGujlpZAQchxyOIWjF+FZ+yQAw0dkLyEh
         AGvf2rFXSFzHMiq6EoJf45yOyRfJgyDkjQ/vcko0H6M19BbSL1e5LkZiBEV8tOW2Opb6
         s/inoDOYI7J6YCyak9Ewt/Rs44iF3l8rJJl1gJ5mEwFXYSGzbBj3iVEwGfPeu3ig7AQq
         0xMLCGGzrgUlDKVbNey5eaEs/RocMAxTJW6mvooLk75qYu4y+dT0tNkXEww+jr+lN3cU
         StFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6Vs/VBf3x0nqFm28ShiPIE1I0XQO439HKJejn1jTQCI=;
        b=WlAK5rLja03gCDQjQLxmP2Hl2FO0Yftekf3Ak9/ch35d8hqUuGENf1FmNllxh2fzIS
         Xez7W0kWDHMpODJtXQxHvDi/2kzvA0lsvkaQnNt4pfWmRekgueqcxVT0uxZIUnV+kVzB
         dN5WbXvQUrbJfc+3HGAnjyqEhEQo4GQNJMZ3cP6ZWF6EIYzLgLNHAJ7dpU0bLEii2y0L
         boYJnFJo1YM5SbjqCFoAaQJQUG+UOiYvgKfRw/cHPm5ijQow5d/uLtqf9VuDeF4tHPO7
         uyfTGvT7sN96z/0mBhoKSWFD98aZGkq0baTEOAaCgNh09wBhdV1sVWVSA+QrpBFIfzRa
         F26A==
X-Gm-Message-State: AOAM530QNAj6bF8dNLwSFhzuEWqmrYniSvRRRkl1q2hRmAAWFFQF5LH2
        dNr02MbWnDqBF8wAg7cQBzNutja72q0=
X-Google-Smtp-Source: ABdhPJxuD+M1g+JUCSqcKVxI4jk8enWLmXXLgvMFEUV32OHiDCZ4kMdhcnfSiyDTpCo6FRMac7sixg==
X-Received: by 2002:a17:906:144e:b0:6ce:6126:6a6d with SMTP id q14-20020a170906144e00b006ce61266a6dmr655220ejc.662.1650056958084;
        Fri, 15 Apr 2022 14:09:18 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.133.118])
        by smtp.gmail.com with ESMTPSA id j10-20020aa7de8a000000b004215209b077sm2602938edv.37.2022.04.15.14.09.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Apr 2022 14:09:17 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 07/14] io_uring: inline io_queue_sqe()
Date:   Fri, 15 Apr 2022 22:08:26 +0100
Message-Id: <d5742683b7a7caceb1c054e91e5b9135b0f3b858.1650056133.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <cover.1650056133.git.asml.silence@gmail.com>
References: <cover.1650056133.git.asml.silence@gmail.com>
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

Inline io_queue_sqe() as there is only one caller left, and rename
__io_queue_sqe().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 21 ++++++++-------------
 1 file changed, 8 insertions(+), 13 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index df588e4d3bee..959e244cb01d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1200,7 +1200,7 @@ static inline struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
 static inline struct file *io_file_get_normal(struct io_kiocb *req, int fd);
 static void io_drop_inflight_file(struct io_kiocb *req);
 static bool io_assign_file(struct io_kiocb *req, unsigned int issue_flags);
-static void __io_queue_sqe(struct io_kiocb *req);
+static void io_queue_sqe(struct io_kiocb *req);
 static void io_rsrc_put_work(struct work_struct *work);
 
 static void io_req_task_queue(struct io_kiocb *req);
@@ -2654,7 +2654,7 @@ static void io_req_task_submit(struct io_kiocb *req, bool *locked)
 	io_tw_lock(req->ctx, locked);
 	/* req->task == current here, checking PF_EXITING is safe */
 	if (likely(!(req->task->flags & PF_EXITING)))
-		__io_queue_sqe(req);
+		io_queue_sqe(req);
 	else
 		io_req_complete_failed(req, -EFAULT);
 }
@@ -7512,7 +7512,7 @@ static void io_queue_sqe_arm_apoll(struct io_kiocb *req)
 		io_queue_linked_timeout(linked_timeout);
 }
 
-static inline void __io_queue_sqe(struct io_kiocb *req)
+static inline void io_queue_sqe(struct io_kiocb *req)
 	__must_hold(&req->ctx->uring_lock)
 {
 	int ret;
@@ -7553,15 +7553,6 @@ static void io_queue_sqe_fallback(struct io_kiocb *req)
 	}
 }
 
-static inline void io_queue_sqe(struct io_kiocb *req)
-	__must_hold(&req->ctx->uring_lock)
-{
-	if (likely(!(req->flags & (REQ_F_FORCE_ASYNC | REQ_F_FAIL))))
-		__io_queue_sqe(req);
-	else
-		io_queue_sqe_fallback(req);
-}
-
 /*
  * Check SQE restrictions (opcode and flags).
  *
@@ -7762,7 +7753,11 @@ static int io_submit_sqe(struct io_ring_ctx *ctx, struct io_kiocb *req,
 		return 0;
 	}
 
-	io_queue_sqe(req);
+	if (likely(!(req->flags & (REQ_F_FORCE_ASYNC | REQ_F_FAIL))))
+		io_queue_sqe(req);
+	else
+		io_queue_sqe_fallback(req);
+
 	return 0;
 }
 
-- 
2.35.2

