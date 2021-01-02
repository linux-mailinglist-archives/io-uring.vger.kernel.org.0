Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68B4C2E8805
	for <lists+io-uring@lfdr.de>; Sat,  2 Jan 2021 17:12:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbhABQLr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 2 Jan 2021 11:11:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726648AbhABQLq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 2 Jan 2021 11:11:46 -0500
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40158C06179E
        for <io-uring@vger.kernel.org>; Sat,  2 Jan 2021 08:11:06 -0800 (PST)
Received: by mail-wm1-x32a.google.com with SMTP id r4so13804103wmh.5
        for <io-uring@vger.kernel.org>; Sat, 02 Jan 2021 08:11:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=jq0Ax03i14oUneEPVJY1RS+onxf1/JUHlBxRaqSFcj4=;
        b=aKCpECai58RwpeziAdRGRY/JsxpZe+Baz/Z91YgtF9wqk+FES9JgZ1gGgH8b+HRxyH
         5/QIqOtVEa146Om7JFSDRX3vi3O2RrZ071Ign264NKRBucWPNGCMtuNrG/fCH5ePob+u
         u3W1M/6/c0quCfz+IOzULoxzu+O+/YiPqP+efLKPvsiqPNwnVCcBbHKahJHjKyxaU+4I
         tfADTx8VjNMKvxAgkDjTGpClpEA8ES8I7Xlw5rbfubH+jJEjoxNG0lcfuLEY0La6beLc
         KL8SjKg6YIyqjPuShg49wSbumc5TpLRMdNDgt4gUtElQXo4arYby1IBlcCmgYcxv2drx
         3igw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=jq0Ax03i14oUneEPVJY1RS+onxf1/JUHlBxRaqSFcj4=;
        b=A/DYiLRPKp/ey91VgqUWl4PCe8P3kU5BgDzDcGlqKHcQ1jnPfLGVvix8qWBRl7amBW
         xYqmHqFu2+09yI8KjDn6KkYxzDdEaP1rWVqWngLm2q9XzbB8TKwaKSOKIJNIISr2o3ha
         skLGnEOqKtVeGenud5YsWrck0Sl49Z1BJr3bmmIlZuHsR6r0Ys3MPq1v0kajinCamZjt
         jOXCRUINHjGOMEQv+T8sNIV8tCXX6HlZhURhlr0pnAc/ufeNpxatTxkuwePJIZW4WJbK
         H6xrsEtAQl4Y0dRuF5aPophI7ZHB4nzh6trMcEP1aYfByvzMo92us8YR1cLMWUEseoDi
         vlHw==
X-Gm-Message-State: AOAM5309JsQtIPl1/fCbxqxyTThGJZ6qpy/QOI4HWxYEIhSARL7dOj44
        L+J77cLWGhzS3Jd6FMSjJhCA1xkB5+U=
X-Google-Smtp-Source: ABdhPJwO0TnmJRhhC2Q12yOwB1/5jd/XB9w6L/joUpLOMJQaY8thcv8aUI606SHU+W0xt89qcGWZuQ==
X-Received: by 2002:a7b:c35a:: with SMTP id l26mr19292831wmj.182.1609603865085;
        Sat, 02 Jan 2021 08:11:05 -0800 (PST)
Received: from localhost.localdomain ([85.255.236.0])
        by smtp.gmail.com with ESMTPSA id b83sm25222377wmd.48.2021.01.02.08.11.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 Jan 2021 08:11:04 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 4/4] io_uring: cancel more aggressively in exit_work
Date:   Sat,  2 Jan 2021 16:06:54 +0000
Message-Id: <a43cd71f93bfbb28f5405c241232e8a1ea9772c5.1609600704.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1609600704.git.asml.silence@gmail.com>
References: <cover.1609600704.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

While io_ring_exit_work() is running new requests of all sorts may be
issued, so it should do a bit more to cancel them, otherwise they may
just get stuck. e.g. in io-wq, in poll lists, etc.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3f38c252860b..389e6d359c3b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -992,6 +992,9 @@ enum io_mem_account {
 	ACCT_PINNED,
 };
 
+static void __io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
+					    struct task_struct *task);
+
 static void destroy_fixed_file_ref_node(struct fixed_file_ref_node *ref_node);
 static struct fixed_file_ref_node *alloc_fixed_file_ref_node(
 			struct io_ring_ctx *ctx);
@@ -8673,7 +8676,7 @@ static void io_ring_exit_work(struct work_struct *work)
 	 * as nobody else will be looking for them.
 	 */
 	do {
-		io_iopoll_try_reap_events(ctx);
+		__io_uring_cancel_task_requests(ctx, NULL);
 	} while (!wait_for_completion_timeout(&ctx->ref_comp, HZ/20));
 	io_ring_ctx_free(ctx);
 }
@@ -8828,9 +8831,11 @@ static void __io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
 		enum io_wq_cancel cret;
 		bool ret = false;
 
-		cret = io_wq_cancel_cb(ctx->io_wq, io_cancel_task_cb, &cancel, true);
-		if (cret != IO_WQ_CANCEL_NOTFOUND)
-			ret = true;
+		if (ctx->io_wq) {
+			cret = io_wq_cancel_cb(ctx->io_wq, io_cancel_task_cb,
+					       &cancel, true);
+			ret |= (cret != IO_WQ_CANCEL_NOTFOUND);
+		}
 
 		/* SQPOLL thread does its own polling */
 		if (!(ctx->flags & IORING_SETUP_SQPOLL)) {
-- 
2.24.0

