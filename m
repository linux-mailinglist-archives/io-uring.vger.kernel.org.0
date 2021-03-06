Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42D1532F99E
	for <lists+io-uring@lfdr.de>; Sat,  6 Mar 2021 12:07:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230411AbhCFLHG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 6 Mar 2021 06:07:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230526AbhCFLG1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 6 Mar 2021 06:06:27 -0500
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A50EAC06175F
        for <io-uring@vger.kernel.org>; Sat,  6 Mar 2021 03:06:26 -0800 (PST)
Received: by mail-wm1-x32c.google.com with SMTP id m20-20020a7bcb940000b029010cab7e5a9fso857038wmi.3
        for <io-uring@vger.kernel.org>; Sat, 06 Mar 2021 03:06:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=h43KL5aYt8wPP3O0MIbSiOhe7Mqz2/Fwkq10XKONZA0=;
        b=uhQuejNG01wUQfxvZX3fgEyXLvyLVxgjlm9L/O8ghMAdOdg7rd30BUgMgEORFxfE9Y
         rQvLVK/hU+GDoS6lMeb+HuuvMysFwx1QOJXzs0rpXEU75dLDj+YkX+9ltuYV9SYNMCgf
         J4TtgmbLf1r3EXojX+4es+xBwZohL150jdvGekxZWSkPGqmhu89rN1U73py//TBEc9Iy
         bYcn1tgtARJhDsenq4abheU9VAKYhD3vzQLQVoRJCN3pReHe89NFmIrW1nKj76RqHsH/
         Is4GacrEDPyWKqkhTYsULszC8Jqw6wlAxN9g2pvbLafjebaRxMMQ5OrcDZiWeQUabxNK
         3RyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=h43KL5aYt8wPP3O0MIbSiOhe7Mqz2/Fwkq10XKONZA0=;
        b=qZSCujWEO0CvNyvVJS/FTnq08+1YdykSrevgHOws4SM7/t2Yr7VS8LVqG8G9db2t7K
         FiSyMOR5l9KjsvsGDyEUx0nXGGpA4LorUn8bStPSHA1KjcdmBpCwEAbfrdXKCFlz02cB
         BCwOpjbQ1etQd6MOFnC9MfmzhZisvm0bqKlu5xMU7PD1Zr0vy8GYqX93xNQrhEAWvSio
         YesB3LfI+Ighz3px+ZPx4/vx4UFNsrbb7EW6Mk4taraVuppiJmkWvA5Ejec5fCDUxkD9
         MQLalgL1/dVK8BVsOieFflehsDK+j3/WPj/mfK6sr1ApxhiXaCU1EHdW/ziI9e/E2SeC
         L9uA==
X-Gm-Message-State: AOAM5318lMf2/vxVh+lyTOCEzcbH2sX4u+6f+5Wli8Z2VsxFjyy8kfoh
        baDGxkQbtwQ6JrX/NG+LgnU=
X-Google-Smtp-Source: ABdhPJwdH6RYsfkHjNNp1BiOvmvesRU5okkVu13HlN57tU8kRQeuot1TO69XZ2yiFdcsTMb32jDphQ==
X-Received: by 2002:a05:600c:2947:: with SMTP id n7mr13451590wmd.61.1615028785509;
        Sat, 06 Mar 2021 03:06:25 -0800 (PST)
Received: from localhost.localdomain ([148.252.133.8])
        by smtp.gmail.com with ESMTPSA id h2sm9442365wrq.81.2021.03.06.03.06.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Mar 2021 03:06:25 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v4 6/8] io_uring: warn when ring exit takes too long
Date:   Sat,  6 Mar 2021 11:02:16 +0000
Message-Id: <af506d49d5e00446392089607aba9ee82cd99cc0.1615028377.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1615028377.git.asml.silence@gmail.com>
References: <cover.1615028377.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We use system_unbound_wq to run io_ring_exit_work(), so it's hard to
monitor whether removal hang or not. Add WARN_ONCE to catch hangs.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c5436b24d221..e4c771df6364 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8555,6 +8555,7 @@ static void io_tctx_exit_cb(struct callback_head *cb)
 static void io_ring_exit_work(struct work_struct *work)
 {
 	struct io_ring_ctx *ctx = container_of(work, struct io_ring_ctx, exit_work);
+	unsigned long timeout = jiffies + HZ * 60 * 5;
 	struct io_tctx_exit exit;
 	struct io_tctx_node *node;
 	int ret;
@@ -8567,10 +8568,14 @@ static void io_ring_exit_work(struct work_struct *work)
 	 */
 	do {
 		io_uring_try_cancel_requests(ctx, NULL, NULL);
+
+		WARN_ON_ONCE(time_after(jiffies, timeout));
 	} while (!wait_for_completion_timeout(&ctx->ref_comp, HZ/20));
 
 	mutex_lock(&ctx->uring_lock);
 	while (!list_empty(&ctx->tctx_list)) {
+		WARN_ON_ONCE(time_after(jiffies, timeout));
+
 		node = list_first_entry(&ctx->tctx_list, struct io_tctx_node,
 					ctx_node);
 		exit.ctx = ctx;
-- 
2.24.0

