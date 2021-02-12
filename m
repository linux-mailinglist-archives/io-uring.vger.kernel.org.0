Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53F553198C5
	for <lists+io-uring@lfdr.de>; Fri, 12 Feb 2021 04:28:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229547AbhBLD2c (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 11 Feb 2021 22:28:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbhBLD2b (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 11 Feb 2021 22:28:31 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AABAC061788
        for <io-uring@vger.kernel.org>; Thu, 11 Feb 2021 19:27:51 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id v7so1221036wrr.12
        for <io-uring@vger.kernel.org>; Thu, 11 Feb 2021 19:27:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=X0MgbxIzPI2XYvzj4gCTTjsu5AQIINwA8VgYeaABBVk=;
        b=KQNO9qSfTnEez2thI2aDsMnPzDYSPfjWtGx+jAQrdYcneHJGnyAfn3YoybXj7mgSo+
         hNIXbSbxbKv+nfd/j6SV/oMWo7m4trGZ6aZ7l51pVRx4MwfijAKQtzi5rgwwL91QQUOm
         a2mcaC2GqdoJE6ctAF4bey6zNGPvyZoCVP/DUoUFbANPNcAMI2m0FBBZzbU9eVxex7Tl
         XcZlEOcAPr1MkzLYrFxCTESSTZMlIvbh9UNun4Rz9WPpvH4kt4yHTMfvqZ5m6ohDYHNZ
         BdAh1vuhKrZC70hUFXx43FOTV6eKV/PSwj2w05vRzfBuTTnvuvrcJgsJoXvtXbl2eglW
         CiCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X0MgbxIzPI2XYvzj4gCTTjsu5AQIINwA8VgYeaABBVk=;
        b=JX3a3LmUu6GjQnDWOj/vPhOgju3TWsWe+pDEg7kvjXussdKsaFPD4jzXw6hqTviVc7
         RApEnU4zaqdK7o/mkpjxXN3N8uygZrUvqC6lA+zoOyFtW3TthOmHDUICyq0qEavMD/RM
         Kw4nF6F369tXwsqRfQn4qb5nax3qBFelSAL9jBoyUYAeRFsLzhiHj2HR76f9zOKDh51W
         Rt279FxRIbawtYsbzoiwGgT5U4ym/LwuNYdI5cbr6Chp92AZqlXGz+OepOmnNl/w1ZU3
         TYoUEu1ElxsWYRKZ1Y1wwff/dRsJZiWBbjxml4zbzBdiK7uH/W7/5TH4pvOMNF0rt1Kh
         fumg==
X-Gm-Message-State: AOAM530ROUuooH0E7qWWlwmHSelYUOfMSWJ2gxv8D3hNUR3G7P0w9IcW
        enErdmFuDWNNImniYl06Od4=
X-Google-Smtp-Source: ABdhPJyt80/6xiw6fxZ3CGddNMc+/PpUbUYc6Ltdg9KRhhkowpgoHHEWAIaV5SZJRdfh0tisCIs4uA==
X-Received: by 2002:a5d:4988:: with SMTP id r8mr931627wrq.26.1613100470181;
        Thu, 11 Feb 2021 19:27:50 -0800 (PST)
Received: from localhost.localdomain ([185.69.144.228])
        by smtp.gmail.com with ESMTPSA id c62sm12973479wmd.43.2021.02.11.19.27.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 11 Feb 2021 19:27:49 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 4/5] io_uring: don't duplicate io_req_task_queue()
Date:   Fri, 12 Feb 2021 03:23:53 +0000
Message-Id: <044a0f4799bc340d5fab9d3d3845d2615d7c5d37.1613099986.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1613099986.git.asml.silence@gmail.com>
References: <cover.1613099986.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Don't hand code io_req_task_queue() inside of io_async_buf_func(), just
call it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 813d1ccd7a69..5c0b1a7dba80 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3494,7 +3494,6 @@ static int io_async_buf_func(struct wait_queue_entry *wait, unsigned mode,
 	struct wait_page_queue *wpq;
 	struct io_kiocb *req = wait->private;
 	struct wait_page_key *key = arg;
-	int ret;
 
 	wpq = container_of(wait, struct wait_page_queue, wait);
 
@@ -3504,14 +3503,9 @@ static int io_async_buf_func(struct wait_queue_entry *wait, unsigned mode,
 	req->rw.kiocb.ki_flags &= ~IOCB_WAITQ;
 	list_del_init(&wait->entry);
 
-	req->task_work.func = io_req_task_submit;
-	percpu_ref_get(&req->ctx->refs);
-
 	/* submit ref gets dropped, acquire a new one */
 	refcount_inc(&req->refs);
-	ret = io_req_task_work_add(req);
-	if (unlikely(ret))
-		io_req_task_work_add_fallback(req, io_req_task_cancel);
+	io_req_task_queue(req);
 	return 1;
 }
 
-- 
2.24.0

