Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F06AF3492CA
	for <lists+io-uring@lfdr.de>; Thu, 25 Mar 2021 14:13:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230252AbhCYNMd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Mar 2021 09:12:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230332AbhCYNM1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Mar 2021 09:12:27 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5491BC06174A
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 06:12:27 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id j9so507878wrx.12
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 06:12:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=XLQcXFDXWkcyPlg6K14NFLtu6iuyqmMeY+AOQkrZayU=;
        b=IdHg/a4oE3aaMwT12r5G3nlWoz6Ksg5DlldhchoqVLh4QswbO+UhubfH2TcZZByjn+
         XET6/ROyoYEM46C1nBPIN1n/vpi8AdyXVZ3olUSlTaCdG3LIA8E7npmhwTiGsJGMlKsw
         I+mze2PFY83Ac0QsygrGeWZ7ztQbuZ/1y8aqWoIM7O6jg3xx9qtHN+QQjHqAUqXl8r/Q
         pAXzPPPiFVNm6x2ySGHq94RIS3oggtbKI2OfHg+ZX/Er0Ohag4dYL7hS0kJplEmYr5dd
         qTcz8j8fzAtImQJM/sqDjIVgQA8kIswQP+yP9kyPt4VETQ5ROIanJIfVHdBNj9yu0GKK
         D3eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XLQcXFDXWkcyPlg6K14NFLtu6iuyqmMeY+AOQkrZayU=;
        b=K3J6SS4SAyI1jdsU/I+z1de09kAgefwgvcBrDfBuAEmFKNCezlsFo9t/j0vRA0XlfG
         v6k4KMKW7+hzwhLi8xoM1KiQ+td2xreSCihF6XZQQVAJN4bEw8H4lpGiGwWTNuUH1b4s
         +mtIlgEO39GqQ9dAxyXpgxpob9UN8AO35n8P2GKni5Eb94/2Wpgx4cAGtnWYTEdL0bQh
         M7YEe4UWyUsUcl+NM8G080nb/oI1UCfCg7GEUfaQju8QIUw3Xy64MnnArtOl581lC99p
         wFKSUphbGPxLxICiJb6a8HbYU0mMU3BvjkU4JnMDjQLpK71JNoQb9z68+2yV4j2cgbxt
         7DfA==
X-Gm-Message-State: AOAM533U0dZromFdCywqkdZBcQFg50i3UWbuvCSyHicx/fqs7b1yLjjp
        e8nb6EP2Guttr0jAs0iJd/O5jwyfRO3M5g==
X-Google-Smtp-Source: ABdhPJyZRb6BmdRXLAEJhozEr9O19oU2Ll8Z2DYBbC7UZxeMUZBUzHy7TBAPEKFh9jQLowsWsFc7/Q==
X-Received: by 2002:a5d:658d:: with SMTP id q13mr9017756wru.388.1616677945803;
        Thu, 25 Mar 2021 06:12:25 -0700 (PDT)
Received: from localhost.localdomain ([148.252.129.162])
        by smtp.gmail.com with ESMTPSA id i4sm5754285wmq.12.2021.03.25.06.12.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 06:12:25 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v3 11/17] io_uring: combine lock/unlock sections on exit
Date:   Thu, 25 Mar 2021 13:08:00 +0000
Message-Id: <b462cc11c9897c853df8189bc5414c14de16cb38.1616677487.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1616677487.git.asml.silence@gmail.com>
References: <cover.1616677487.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_ring_exit_work() already does uring_lock lock/unlock, no need to
repeat it for lock waiting trick in io_ring_ctx_free(). Move the waiting
with comments and spinlocking into io_ring_exit_work.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 350ada47d5fb..454381c19d25 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8345,16 +8345,6 @@ static void io_req_caches_free(struct io_ring_ctx *ctx)
 
 static void io_ring_ctx_free(struct io_ring_ctx *ctx)
 {
-	/*
-	 * Some may use context even when all refs and requests have been put,
-	 * and they are free to do so while still holding uring_lock or
-	 * completion_lock, see __io_req_task_submit(). Wait for them to finish.
-	 */
-	mutex_lock(&ctx->uring_lock);
-	mutex_unlock(&ctx->uring_lock);
-	spin_lock_irq(&ctx->completion_lock);
-	spin_unlock_irq(&ctx->completion_lock);
-
 	io_sq_thread_finish(ctx);
 	io_sqe_buffers_unregister(ctx);
 
@@ -8505,6 +8495,12 @@ static void io_ring_exit_work(struct work_struct *work)
 		WARN_ON_ONCE(time_after(jiffies, timeout));
 	} while (!wait_for_completion_timeout(&ctx->ref_comp, HZ/20));
 
+	/*
+	 * Some may use context even when all refs and requests have been put,
+	 * and they are free to do so while still holding uring_lock or
+	 * completion_lock, see __io_req_task_submit(). Apart from other work,
+	 * this lock/unlock section also waits them to finish.
+	 */
 	mutex_lock(&ctx->uring_lock);
 	while (!list_empty(&ctx->tctx_list)) {
 		WARN_ON_ONCE(time_after(jiffies, timeout));
@@ -8525,6 +8521,8 @@ static void io_ring_exit_work(struct work_struct *work)
 		mutex_lock(&ctx->uring_lock);
 	}
 	mutex_unlock(&ctx->uring_lock);
+	spin_lock_irq(&ctx->completion_lock);
+	spin_unlock_irq(&ctx->completion_lock);
 
 	io_ring_ctx_free(ctx);
 }
-- 
2.24.0

