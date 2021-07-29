Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 714FD3DA717
	for <lists+io-uring@lfdr.de>; Thu, 29 Jul 2021 17:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237648AbhG2PGh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Jul 2021 11:06:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237703AbhG2PGf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Jul 2021 11:06:35 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB316C0613C1
        for <io-uring@vger.kernel.org>; Thu, 29 Jul 2021 08:06:30 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id z4so7345300wrv.11
        for <io-uring@vger.kernel.org>; Thu, 29 Jul 2021 08:06:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=3IpSg/QABQuxrPAk5AC82qgeIinovIPVIY7LX6AiwQ4=;
        b=CE2apuav3m3i9kYZMw3fMQYZkzSWs0VbmAcJfPI5dODem/HYI6INFCaOqWigq82oKm
         +KPgHN/cnzPNjMwcowL+O6iKMCPXbYqjd/GN928hdbzk255sJwHIcWzYoGFFeXxnMKCX
         oTRqWYq2A9IpXvNTjJ3Oqz9MpopaVKPIxmbdoVY+cCVo3pYYHpPQ5/HzPZRluSVw8kgk
         KPRfNJZd/eSxyiTtP8vtJJSFoD1BEi4CghuDmLmHYHhRFQd9ES5e/ZYUWj0C0oF9a8ER
         pUQnaVIFCRcWH6sctIFUWSKAIAsxWe4bE3UYEXxDxb/WC/IZV8+wcPjB4M+8EPb/tv40
         eFqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3IpSg/QABQuxrPAk5AC82qgeIinovIPVIY7LX6AiwQ4=;
        b=KVLCEq4TSD682kMLZhMtfV6U0LEqF2wjUkMhwX7ica10ueKWHm7804N567IKwNKb0f
         EHyxYOQR4p5Dlys1m10MqhXdrgk0NAXLg7TEF+vhCs3/btsWpZeeE7wZDkpKVZ+udimC
         oE/mJGOQ/2q8iK8cwGLfm6lOyJR49S6AXxy1pSQqRgvA6Nfkii4ROEugL3j9x76rL1Eg
         LaMI+vCkUol3oHrIvNgh8/nTqpPb3Tlsl+VYj/INI4y4gYuAgO6io4XfVsP1vQE2f0Ck
         k9GWTTs7t1YQr/82DMiQVwl7YZXk88u0+5Basvg/eiVzW1yx47HPDfdOkNpaEIDprSjg
         Z4vQ==
X-Gm-Message-State: AOAM532l5a7vxIpVD/cHCvaSApS5f9eWg7EaPj0jg/oNoLMfYw1iAb+/
        3Ejh2/NdTNQJMGJOYWHTgS8=
X-Google-Smtp-Source: ABdhPJxGzN3i3/t/QMIP+dasdx1nJVk7LLC5yp7MQdzIMqwkEFgQldPkyWnc1VvYDiPIU8AJBSvzOQ==
X-Received: by 2002:adf:d225:: with SMTP id k5mr5357714wrh.10.1627571189303;
        Thu, 29 Jul 2021 08:06:29 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.141])
        by smtp.gmail.com with ESMTPSA id e6sm4764577wrg.18.2021.07.29.08.06.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 08:06:28 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 07/23] io_uring: extract a helper for ctx quiesce
Date:   Thu, 29 Jul 2021 16:05:34 +0100
Message-Id: <f466e8502993fcfafefeea0895660e197c1a8ba0.1627570633.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1627570633.git.asml.silence@gmail.com>
References: <cover.1627570633.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Refactor __io_uring_register() by extracting a helper responsible for
ctx queisce. Looks better and will make it easier to add more
optimisations.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 53 ++++++++++++++++++++++++++++-----------------------
 1 file changed, 29 insertions(+), 24 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 85cd8c3a33e1..db43aedcfc42 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -10066,6 +10066,33 @@ static bool io_register_op_must_quiesce(int op)
 	}
 }
 
+static int io_ctx_quiesce(struct io_ring_ctx *ctx)
+{
+	long ret;
+
+	percpu_ref_kill(&ctx->refs);
+
+	/*
+	 * Drop uring mutex before waiting for references to exit. If another
+	 * thread is currently inside io_uring_enter() it might need to grab the
+	 * uring_lock to make progress. If we hold it here across the drain
+	 * wait, then we can deadlock. It's safe to drop the mutex here, since
+	 * no new references will come in after we've killed the percpu ref.
+	 */
+	mutex_unlock(&ctx->uring_lock);
+	do {
+		ret = wait_for_completion_interruptible(&ctx->ref_comp);
+		if (!ret)
+			break;
+		ret = io_run_task_work_sig();
+	} while (ret >= 0);
+	mutex_lock(&ctx->uring_lock);
+
+	if (ret)
+		io_refs_resurrect(&ctx->refs, &ctx->ref_comp);
+	return ret;
+}
+
 static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			       void __user *arg, unsigned nr_args)
 	__releases(ctx->uring_lock)
@@ -10090,31 +10117,9 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 	}
 
 	if (io_register_op_must_quiesce(opcode)) {
-		percpu_ref_kill(&ctx->refs);
-
-		/*
-		 * Drop uring mutex before waiting for references to exit. If
-		 * another thread is currently inside io_uring_enter() it might
-		 * need to grab the uring_lock to make progress. If we hold it
-		 * here across the drain wait, then we can deadlock. It's safe
-		 * to drop the mutex here, since no new references will come in
-		 * after we've killed the percpu ref.
-		 */
-		mutex_unlock(&ctx->uring_lock);
-		do {
-			ret = wait_for_completion_interruptible(&ctx->ref_comp);
-			if (!ret)
-				break;
-			ret = io_run_task_work_sig();
-			if (ret < 0)
-				break;
-		} while (1);
-		mutex_lock(&ctx->uring_lock);
-
-		if (ret) {
-			io_refs_resurrect(&ctx->refs, &ctx->ref_comp);
+		ret = io_ctx_quiesce(ctx);
+		if (ret)
 			return ret;
-		}
 	}
 
 	switch (opcode) {
-- 
2.32.0

