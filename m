Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6991B2E8F55
	for <lists+io-uring@lfdr.de>; Mon,  4 Jan 2021 03:03:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727810AbhADCDo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 3 Jan 2021 21:03:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727709AbhADCDk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 3 Jan 2021 21:03:40 -0500
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6594CC061794
        for <io-uring@vger.kernel.org>; Sun,  3 Jan 2021 18:02:59 -0800 (PST)
Received: by mail-wm1-x329.google.com with SMTP id q75so17939402wme.2
        for <io-uring@vger.kernel.org>; Sun, 03 Jan 2021 18:02:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=YpRnfTlMNEuKQfmQ5l5ez6viG/jsyZ67SweETcrPyfI=;
        b=j4TdB4WvT6S6TFuEBWeh/mWVvC4q30DqFfpPO/QcZIBaYkadDA8yGyI17xt2+JVEIg
         Sr+/J1giu/7JFYUGBMiGHKwGIAZv80tfu79Ju2OnDt3ptRMxsAe00dYcsU5aNUaOZTwk
         tIDdcXRLVHpdslfUON+CwzlzEWkBYyvOg+QMT6N6CUeG3fk3qOOMxmn0r4yaCWm1rWlP
         EBHgE66stZre5Xq4beVswefhMtkR9yXW/ZYjz1xXy3t+SAwCH8qn4qzohvc9F54zLZlG
         A+uKIbW39uvq5NO3DH/P3yQ/T4Tah7tDq7kMby9pMHa+orbFjyNh1o17+wdHXFPkasnN
         vlLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=YpRnfTlMNEuKQfmQ5l5ez6viG/jsyZ67SweETcrPyfI=;
        b=AoAhjJTzxyr9AYmIiIsw/H5Saj6dALXYrwyn4t3d66MlwJfMhJuxjXaKnbVmUertZt
         ny8zImylZWtbK7Ap1LTR4VXIT/Y6sV0kC/U3H1n2J0qshLFssSV+ncq5iLTl3VpZZ44U
         FDucNDksuPUSKbeh9ObO4T5r81iJFWD826v49pHEywWFSJqf0fRuWYIWV82VRpnMnuLY
         bCkjMIhnMFnHHOJ7fFSetyUPA5eES9rVRlQjNs7ECEX468Cfm8cqSRax/mwthTR7RrXF
         s8idBK+H7XZdEAPFm0w+qkApQ6C+ESxFw2Isv+qP1QT9aZ2UvupLfzzjPZ+YiIcMAHIE
         3QOA==
X-Gm-Message-State: AOAM5336UE2jriw/rnBePkw1LVNB1MP2vSaoSNX9MOXLnxq/o+5Wavmm
        7QZP8T1tm2IYuWsBDWFPN5mbv9p47zAy2A==
X-Google-Smtp-Source: ABdhPJziYwlMW8thXmVRbKDbN4wvdsAJ+v9qwPhmoGTttaCUek5FYqiHT/epbXkim++vlFa8bkQArA==
X-Received: by 2002:a1c:a1c1:: with SMTP id k184mr24682490wme.101.1609725778120;
        Sun, 03 Jan 2021 18:02:58 -0800 (PST)
Received: from localhost.localdomain ([85.255.233.205])
        by smtp.gmail.com with ESMTPSA id c4sm96632893wrw.72.2021.01.03.18.02.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 03 Jan 2021 18:02:57 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 2/6] io_uring: cancel more aggressively in exit_work
Date:   Mon,  4 Jan 2021 01:59:15 +0000
Message-Id: <ab26f494b29ad7df90bbee5595179bd4cb7b5f1b.1609725418.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1609725418.git.asml.silence@gmail.com>
References: <cover.1609725418.git.asml.silence@gmail.com>
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
index ee1beec7a04d..cacb14246dbb 100644
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
@@ -8663,7 +8666,7 @@ static void io_ring_exit_work(struct work_struct *work)
 	 * as nobody else will be looking for them.
 	 */
 	do {
-		io_iopoll_try_reap_events(ctx);
+		__io_uring_cancel_task_requests(ctx, NULL);
 	} while (!wait_for_completion_timeout(&ctx->ref_comp, HZ/20));
 	io_ring_ctx_free(ctx);
 }
@@ -8818,9 +8821,11 @@ static void __io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
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

