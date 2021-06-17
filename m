Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D26713ABA63
	for <lists+io-uring@lfdr.de>; Thu, 17 Jun 2021 19:14:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232041AbhFQRQw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Jun 2021 13:16:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232068AbhFQRQw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Jun 2021 13:16:52 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CAD1C061574
        for <io-uring@vger.kernel.org>; Thu, 17 Jun 2021 10:14:43 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id t4-20020a1c77040000b029019d22d84ebdso6866837wmi.3
        for <io-uring@vger.kernel.org>; Thu, 17 Jun 2021 10:14:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=fPm1VhHHAkUf+D3WOzN5r9jite12Z64GIFUeEdXWDdw=;
        b=Yi5OqMBe7siIAVBdIbsoPlTuEh28rfiww0PwVFLFFJlEeYXbT28GdT8cacTBooVvD5
         Gc7dZeCi+GlhiWhiwGtMFNJv4s47riVnVuP/ixNl0XbByCbBTU1uQqW7aud7/XHv+n7m
         27jyk1ZPxEO/92irbtEgepSA+ClCisSnD9l3WKIh18o7NAdx5AH9Bo5CVw3LxzGVmjjg
         c9h/4wPdYcslLvxk+nAZzO6u6GHLEaRzoaD7CQiT+mfuoNyjenQE2/25JXtUZ1cs6WdU
         hgKmXhSEOBOKXh8wEsDw4XuwDW8rP5mOy0edV0Tx4GDxJMjsL35pnBn78iEyulz1JZ7+
         6t8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=fPm1VhHHAkUf+D3WOzN5r9jite12Z64GIFUeEdXWDdw=;
        b=fxMqcrXnVVAk50v3DwYBbmnzSH4vGM3te9davvIjkz+6Op+9zvNocY0wDcwMBsck/o
         VMbU0G/t97DEOuqqdVkHNJrN0yopnjZ2XIbVGgMYSH/Rggk8hd4LupoAFONNe/BbviCP
         BLQpwEBn/kim/u3QFrXeLiv2QMusnC+siJdgUlh9J8NbU5xvoJ/GkwavgMhh8zZJ+Jax
         Ryl+3p1+fnlkIK34aZ9hePpLBOqLpRLfV8FTd4e2gKnkQRd7dl91d0J+pSFRcuLHcYtn
         PeEsw341CL/CgIG//cdBcPyuXMNOpHwSdpe9HVpvNbTsnsCxP5osa4Do7LBaBQKhMBwv
         8nxw==
X-Gm-Message-State: AOAM532a680thfs7PEK6KGcI2XKGwQR8d0o/9LzLfY5lASfAywXk8J1V
        C740EjkxvNQlEBJssl8IF9f+2VMSVTTwSw==
X-Google-Smtp-Source: ABdhPJx0ZgK1sElWYuEboFp0JtJV17RpZ+G2DHgQLDXa48VNf6Q4WMdMUtLQu9p0a+ThlHCa2D9biQ==
X-Received: by 2002:a1c:5fc1:: with SMTP id t184mr6437027wmb.148.1623950082066;
        Thu, 17 Jun 2021 10:14:42 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.93])
        by smtp.gmail.com with ESMTPSA id g17sm6208033wrp.61.2021.06.17.10.14.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 10:14:41 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 09/12] io_uring: optimise task_work submit flushing
Date:   Thu, 17 Jun 2021 18:14:07 +0100
Message-Id: <3cac83934e4fbce520ff8025c3524398b3ae0270.1623949695.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1623949695.git.asml.silence@gmail.com>
References: <cover.1623949695.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

tctx_task_work() tries to fetch a next batch of requests, but before it
would flush completions from the previous batch that may be sub-optimal.
E.g. io_req_task_queue() executes a head of the link where all the
linked may be enqueued through the same io_req_task_queue(). And there
are more cases for that.

Do the flushing at the end, so it can cache completions of several waves
of a single tctx_task_work(), and do the flush at the very end.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d8bc4f82efd1..f31f00c6e829 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1890,13 +1890,13 @@ static void ctx_flush_and_put(struct io_ring_ctx *ctx)
 
 static void tctx_task_work(struct callback_head *cb)
 {
+	struct io_ring_ctx *ctx = NULL;
 	struct io_uring_task *tctx = container_of(cb, struct io_uring_task,
 						  task_work);
 
 	clear_bit(0, &tctx->task_state);
 
 	while (!wq_list_empty(&tctx->task_list)) {
-		struct io_ring_ctx *ctx = NULL;
 		struct io_wq_work_list list;
 		struct io_wq_work_node *node;
 
@@ -1920,11 +1920,12 @@ static void tctx_task_work(struct callback_head *cb)
 			node = next;
 		}
 
-		ctx_flush_and_put(ctx);
 		if (!list.first)
 			break;
 		cond_resched();
 	}
+
+	ctx_flush_and_put(ctx);
 }
 
 static int io_req_task_work_add(struct io_kiocb *req)
-- 
2.31.1

