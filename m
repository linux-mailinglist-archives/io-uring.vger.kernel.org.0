Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45ECA3E453C
	for <lists+io-uring@lfdr.de>; Mon,  9 Aug 2021 14:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235338AbhHIMFg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Aug 2021 08:05:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235344AbhHIMFg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Aug 2021 08:05:36 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD4E6C061796
        for <io-uring@vger.kernel.org>; Mon,  9 Aug 2021 05:05:15 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id f5so5304889wrm.13
        for <io-uring@vger.kernel.org>; Mon, 09 Aug 2021 05:05:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=XKaossVkwUeIhI9Bc1FJaN2Dz3h1CCVq2L+SYub7w6M=;
        b=mwgBqR8OZOc6PXS+JEqFHQdKANgq+6M9M4GaSAFSnj0O4Jhgu0SQDNDSEui1REqhbc
         c1oMB8evsr9DNDfK2qSpAtXefH6z/HeyEbrCFoIWc37J5lV1AC1fqwUAE/h7aAa//IGH
         MLe1FG0ubpnZJXfgv0mmtxuvUKOmJombVaBhtVQPSzmH+SthkLGvWKhgNaD7v3uZgcoe
         ZZBRNmhZ+Uxnl+wTMz5hJw0Dq5Uk+Pnh0VwH8KRBqG88WtT4M+zRWvmoGTz2ia6zV4zO
         R5xur8VleQVMLoXhSVD/SXBw2o6CQUJ9hTd6jnU3p0UNJ+dzplE9AH6UAxBhzyUAo3te
         4VBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=XKaossVkwUeIhI9Bc1FJaN2Dz3h1CCVq2L+SYub7w6M=;
        b=pMd14ZSf6x5MWKTdngvbI81Lv4Q7LhuJlVujmzDTHYsBz+9amz+NFHk5oMhbGwxySp
         FJozl9V10ljEnpYCi1/sh0B6+gPRjFW+pFlOBsmiIOT2qJxUJiCr5OeG7gKvwAvwc20M
         0OBPURnNp494m88WrY/QdFZxz/u92VUaCFJwZRX8d1NlZfLtLnH22+RB3li/b+70TWVH
         S6AJE7Nmvs50glqYGjA9uScqj64ZPSk6KHa0GLuzLmfBApKs0VMYMV0zaVLRMTkGNfTx
         d529iklW3GmQ2mVkXQRojPx1CKLhc9z0prsTsHTnoVeWZbFciS13trz+mu84femA1b2y
         lecg==
X-Gm-Message-State: AOAM530za1/RyJz98eMQuEEJlzUXzok+C72nX/IqM3vxBilbREAgYHnd
        hLRiph56d7lR+l6AOOQo5MA=
X-Google-Smtp-Source: ABdhPJzyyaZDdZR1ttvNtcYSZaV9IqLS6oTimNwAr8SWfGQdXAMJ1uoOTut/DhYLDAKifX+AVxwCBQ==
X-Received: by 2002:a5d:444e:: with SMTP id x14mr24427772wrr.385.1628510714408;
        Mon, 09 Aug 2021 05:05:14 -0700 (PDT)
Received: from localhost.localdomain ([85.255.236.119])
        by smtp.gmail.com with ESMTPSA id g35sm4757062wmp.9.2021.08.09.05.05.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 05:05:14 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 12/28] io_uring: extract a helper for ctx quiesce
Date:   Mon,  9 Aug 2021 13:04:12 +0100
Message-Id: <0339e0027504176be09237eefa7945bf9a6f153d.1628471125.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628471125.git.asml.silence@gmail.com>
References: <cover.1628471125.git.asml.silence@gmail.com>
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
index 0fd04d25c520..292dbf10e316 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -10077,6 +10077,33 @@ static bool io_register_op_must_quiesce(int op)
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
@@ -10101,31 +10128,9 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
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

