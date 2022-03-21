Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A8B74E3333
	for <lists+io-uring@lfdr.de>; Mon, 21 Mar 2022 23:56:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbiCUWxr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Mar 2022 18:53:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35526 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbiCUWxU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Mar 2022 18:53:20 -0400
Received: from mail-lf1-x135.google.com (mail-lf1-x135.google.com [IPv6:2a00:1450:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D731D43AE6
        for <io-uring@vger.kernel.org>; Mon, 21 Mar 2022 15:32:39 -0700 (PDT)
Received: by mail-lf1-x135.google.com with SMTP id e16so12726010lfc.13
        for <io-uring@vger.kernel.org>; Mon, 21 Mar 2022 15:32:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=2ADSs1NVxEb84GGpwd/ovt2QGuXc7nFn9QOB/ZbvE6A=;
        b=SXfLLkxlUxcFr6fTWDs9I2BnwY5aGffgo275faWMcT2n2MkE8pcR5JR0Oxxgr9wLr5
         jCZiBPvA6GoNqnMZm98WjWLeihL7A+Rjq4+mJgWYX6Z1PD5XcOg9AXIHzwl7bfAIc8SY
         jlLDbw70sR1VOyJj6X8mp5cgjFPB4QfvxQ3uyyPlP2BsiiMrGpEBwNApu+k9h54cXsC8
         UeW91NQGo2T960cZC45vi/A/WKESmrQxBOcsaDppsNCihGSfYYCqOqM+oG+uqfbH1ZkN
         NKG01C4/yhdpRrHVJEQ1Jspk4//IkUHTPh/UBEZt0WpLe2EtLu72XuXIulE6tbhlvMoF
         OtQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=2ADSs1NVxEb84GGpwd/ovt2QGuXc7nFn9QOB/ZbvE6A=;
        b=oJ3DWmp1WhkF46Y+oo9+EgX2nlHpbrfO6AKJ//HB7qvl7f+Yni43tDNoCSP2pLi1Wz
         iYMJZLLE+4zBD+9M+ZmJQNIRCbHAXA03oAZzkkhJLH4YaZjJN2JRGfOd4TArvgfFdELG
         JItRawzfrttCgUk852bDPBQb5am1BYNcjR79EjtGex2xw2+bHflSjGfUwywDr40mNQ3J
         7Su/18iMDNC2IkHfdFPuH0w7HBjqOs2ZP3wu1gLDBCQ85m8MB5S7tqw987DPEIwOb5wK
         2FqDmnHsvPk//ZK5Xo8GybtHXiTb9CguJV9P+iEcok3noZVD2iopukj/1HPJxRHUa9y8
         k/4Q==
X-Gm-Message-State: AOAM5338xcPmYJJWvMgrUNJM4ejlDPkZ2XykQpugeuCZlRGvANmvU45W
        uvXqc431iwHP/no9IIYwwJKVTjDsQ6fFsA==
X-Google-Smtp-Source: ABdhPJwjt/iFVgcRpLqQua8FkV01msDRfwpJJGO9280lOwkn3XZ8kuOm6WfP7qCq1YGGqni2Np0r0g==
X-Received: by 2002:a05:6402:40c9:b0:419:4b81:162e with SMTP id z9-20020a05640240c900b004194b81162emr4673522edb.380.1647900242255;
        Mon, 21 Mar 2022 15:04:02 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.105.239.232])
        by smtp.gmail.com with ESMTPSA id qb10-20020a1709077e8a00b006dfedd50ce3sm2779658ejc.143.2022.03.21.15.04.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 15:04:02 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 6/6] io_uring: clean up io_queue_next()
Date:   Mon, 21 Mar 2022 22:02:24 +0000
Message-Id: <1f9e1cc80adbb11b37017d511df4a2c6141a3f08.1647897811.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1647897811.git.asml.silence@gmail.com>
References: <cover.1647897811.git.asml.silence@gmail.com>
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

Move fast check out of io_queue_next(), it makes req->flags checks in
__io_submit_flush_completions() a bit clearer and grants us better
comtrol, e.g. can remove now not justified unlikely() in
__io_submit_flush_completions(). Also, we don't care about having this
check in io_free_req() as the function is a slow path and
io_req_find_next() handles it correctly.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 79294a7455d6..9baa120a96f9 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2612,14 +2612,12 @@ static void io_req_task_queue_reissue(struct io_kiocb *req)
 	io_req_task_work_add(req, false);
 }
 
-static inline void io_queue_next(struct io_kiocb *req)
+static void io_queue_next(struct io_kiocb *req)
 {
-	if (unlikely(req->flags & (REQ_F_LINK|REQ_F_HARDLINK))) {
-		struct io_kiocb *nxt = io_req_find_next(req);
+	struct io_kiocb *nxt = io_req_find_next(req);
 
-		if (nxt)
-			io_req_task_queue(nxt);
-	}
+	if (nxt)
+		io_req_task_queue(nxt);
 }
 
 static void io_free_req(struct io_kiocb *req)
@@ -2659,7 +2657,8 @@ static void io_free_batch_list(struct io_ring_ctx *ctx,
 						&ctx->apoll_cache);
 				req->flags &= ~REQ_F_POLLED;
 			}
-			io_queue_next(req);
+			if (req->flags & (REQ_F_LINK|REQ_F_HARDLINK))
+				io_queue_next(req);
 			if (unlikely(req->flags & IO_REQ_CLEAN_FLAGS))
 				io_clean_op(req);
 		}
-- 
2.35.1

