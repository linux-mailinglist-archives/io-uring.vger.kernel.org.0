Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C2E0332E09F
	for <lists+io-uring@lfdr.de>; Fri,  5 Mar 2021 05:22:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229797AbhCEEW3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Mar 2021 23:22:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229463AbhCEEW3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Mar 2021 23:22:29 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA55EC061574
        for <io-uring@vger.kernel.org>; Thu,  4 Mar 2021 20:22:28 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id d11so608677wrj.7
        for <io-uring@vger.kernel.org>; Thu, 04 Mar 2021 20:22:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=yhuORutF+eVhBKIoPZ4Q178xO+N7qkHfZ5A57L+QjuU=;
        b=eIeGjbvjTcfEor23Vn407B/rzjV9BkxvTnkAFPlq0poV56S1CdutO4NTcZEeuZwDJ+
         OH9L3G6E/ZQdenuWDutxc3UGS54oa7GIRmBt0ydUQBYahySC/kAgdiqunC/3XLcl6mf+
         B9qPqs7ASuMWFeSRs4KeJ++sz6LeirkEhZeKmExDjEj0Yrh7ySo9vT4C3wcCEC6PFwEE
         wQeVaRmD/OHf2Hs8L4NgrL4W0j7wsA2i4R2qwJb1koOHCsZon+NDdY450a1odatFdhmv
         x4qhi6pPGfkgIJmNA9BjV1fl68SxnK4NmA2YBr2MbvJ//JxWfGcDjmlSBeSn2FohSKMb
         DXnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=yhuORutF+eVhBKIoPZ4Q178xO+N7qkHfZ5A57L+QjuU=;
        b=O0BLH8PB43Z/6jAP52uT4DkEzDEBPsaJsU0fFweKbIatLZSA/eFHpY+nkUTrF1L8rP
         AcIjTcHsAF/aQJm3j8j8PK55ewWuElfddHwl4/dFng4sBEQ5zb86PWFeUVVHEaGVpiSM
         1NRsjO9UnELr+mEx1qAsWsyHgoWhPj0Rq/G7hkCeeBSXS/XzTM2Xfeypv0DWtHu9ZYnD
         jbrAjPWYBO05JrGH4BkzHPa6j6JMD0EFj/z6RtN/7ajvGiXndXtb5fm0DPORDBxTaLjK
         pILgt5xaXjB3w8K0Df1b27oJBbdFOJHFai4R2HJ8H4PtigUVMFUjTuki2yvH8Sk+u+FZ
         iLmQ==
X-Gm-Message-State: AOAM5310n3XF7SbGAAMvMbM0CnHQd1jAZRyaQ0w5W0uJBs3b7y996nYw
        HfTiMDVizr72+EQExe5469c=
X-Google-Smtp-Source: ABdhPJxBha+Ppg6Gi/Pa84mNGN7cKfaqJ36cPZSabjgE3XUr0EPtun8urxYBx8EqV3ljzCzSqRM37A==
X-Received: by 2002:a5d:404f:: with SMTP id w15mr7580491wrp.106.1614918147717;
        Thu, 04 Mar 2021 20:22:27 -0800 (PST)
Received: from localhost.localdomain ([148.252.129.216])
        by smtp.gmail.com with ESMTPSA id z3sm2170446wrs.55.2021.03.04.20.22.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Mar 2021 20:22:27 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 4/6] io_uring: don't take task ring-file notes
Date:   Fri,  5 Mar 2021 04:18:22 +0000
Message-Id: <5c394abd70bf5c3b21437c5a3dfd3f9ddfbc7ab3.1614917790.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1614917790.git.asml.silence@gmail.com>
References: <cover.1614917790.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

With ->flush() gone we're now leaving all uring file notes until the
task dies/execs, so the ctx will not be freed until all tasks that have
ever submit a request die. It was nicer with flush but not much, we
could have locked as described ctx in many cases.

Now we guarantee that ctx outlives all tctx in a sense that
io_ring_exit_work() waits for all tctxs to drop their corresponding
enties in ->xa, and ctx won't go away until then. Hence, additional
io_uring file reference (a.k.a. task file notes) are not needed anymore.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9865b2c708c2..d819d389f4ee 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8815,11 +8815,9 @@ static int io_uring_add_task_file(struct io_ring_ctx *ctx, struct file *file)
 			node->file = file;
 			node->task = current;
 
-			get_file(file);
 			ret = xa_err(xa_store(&tctx->xa, (unsigned long)file,
 						node, GFP_KERNEL));
 			if (ret) {
-				fput(file);
 				kfree(node);
 				return ret;
 			}
@@ -8850,6 +8848,8 @@ static void io_uring_del_task_file(unsigned long index)
 	struct io_uring_task *tctx = current->io_uring;
 	struct io_tctx_node *node;
 
+	if (!tctx)
+		return;
 	node = xa_erase(&tctx->xa, index);
 	if (!node)
 		return;
@@ -8863,7 +8863,6 @@ static void io_uring_del_task_file(unsigned long index)
 
 	if (tctx->last == node->file)
 		tctx->last = NULL;
-	fput(node->file);
 	kfree(node);
 }
 
-- 
2.24.0

