Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E79D3223F2
	for <lists+io-uring@lfdr.de>; Tue, 23 Feb 2021 03:00:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230367AbhBWCA3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Feb 2021 21:00:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230099AbhBWCA2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Feb 2021 21:00:28 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0C819C06174A
        for <io-uring@vger.kernel.org>; Mon, 22 Feb 2021 17:59:48 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id c7so4253210wru.8
        for <io-uring@vger.kernel.org>; Mon, 22 Feb 2021 17:59:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=cYAfvE8BgaxYiiBjqMnZHr5Wgtwa2xLUBswA6ihN85w=;
        b=G4aLJjwM3Z46dXH5kOQfAOBhkA4TMZV5k7esNjOJx8Z67b4DgBodTgEhmYUYRI0+Nn
         FoOuG4xmpsEuvwwh9nUzTy2I+4IcInUjNxHmrMtFtdnHjFWP7U0b/KGyFFToqxW1iTrc
         cZyUYDdQll/VarxTR3+MFo7Cc682NMCpxhIH9U2L4rdA8xojfdLQSi5b8+tO+MqNakJm
         3oZ4FHA9GVFNJpUNAFbcZh9uzERyDmkuJ8jq+zenlIDZHptVPVUqMMOm24MKWxBp+tu6
         Ad7vcKZq5CLP9iGn3FwaqPO2UXkVb1yVgjvu6QQyVdzXc22/32YzTn+HSIDtC8+Mh/H5
         KswA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cYAfvE8BgaxYiiBjqMnZHr5Wgtwa2xLUBswA6ihN85w=;
        b=SS+rS0uJLzmGT+gQ8kIYwHCB8sHZjSKKVE1B6/+XIv2URnzqbFSYAi103oPdHGS+U5
         bcdR5fX4zEHk5J4yi6fmpt4d8dEOY0OHut4iq1sYnhz8D1NWtnJ3ex3K9XRVbgLZDYXy
         GPcCkS6+zXcQTFySC+HOcVZGLmWqDoZmGpMGdlSE1lMs1L29Wn3tdGePKDVAnd0002z8
         9aAlwMpSdNG7bg6CFs8aQW0nMp4k4sTHipPqkD3QuD2Ya3uVHutauifSsciDDqTt+Ih6
         x/eXo7faIUFJDexmYuTw3Tb+j/XmItOeK7meEybSTRSRxzDDMP0S5stecbwNAd7Y2+Tu
         mmng==
X-Gm-Message-State: AOAM533Hubl/b+7RXSxCt6rNIZQeCk10wHJ34z/P7dplS5Iwwpr0gm6p
        vrskPEIGezw8px9xjV+jpF2k3b7BVns=
X-Google-Smtp-Source: ABdhPJw9yVbq92bgHx8ynMpkx8laCdnfXmBZHdvwYB9xG0FKcOm6EovA7CZ78TrfHMmtJ9LWO2wXxw==
X-Received: by 2002:adf:e842:: with SMTP id d2mr11650577wrn.243.1614045586742;
        Mon, 22 Feb 2021 17:59:46 -0800 (PST)
Received: from localhost.localdomain ([148.252.132.56])
        by smtp.gmail.com with ESMTPSA id 4sm32425501wrr.27.2021.02.22.17.59.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 17:59:46 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 01/13] io_uring: introduce a new helper for ctx quiesce
Date:   Tue, 23 Feb 2021 01:55:36 +0000
Message-Id: <9f40843d172aa8dfb631755b9a71ced79d310f49.1614045169.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1614045169.git.asml.silence@gmail.com>
References: <cover.1614045169.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Extract a helper io_uring_quiesce_ctx(), which takes care of ctx
quiesce, it's complex enough.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 52 ++++++++++++++++++++++++++++-----------------------
 1 file changed, 29 insertions(+), 23 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 3f764f2f2982..6e781c064e74 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9683,6 +9683,33 @@ static bool io_register_op_must_quiesce(int op)
 	}
 }
 
+static int io_uring_quiesce_ctx(struct io_ring_ctx *ctx)
+{
+	int ret;
+
+	percpu_ref_kill(&ctx->refs);
+	/*
+	 * Drop uring mutex before waiting for references to exit. If
+	 * another thread is currently inside io_uring_enter() it might
+	 * need to grab the uring_lock to make progress. If we hold it
+	 * here across the drain wait, then we can deadlock. It's safe
+	 * to drop the mutex here, since no new references will come in
+	 * after we've killed the percpu ref.
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
+	if (ret && io_refs_resurrect(&ctx->refs, &ctx->ref_comp))
+		return ret;
+	return 0;
+}
+
 static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 			       void __user *arg, unsigned nr_args)
 	__releases(ctx->uring_lock)
@@ -9699,29 +9726,8 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 		return -ENXIO;
 
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
-
-		mutex_lock(&ctx->uring_lock);
-
-		if (ret && io_refs_resurrect(&ctx->refs, &ctx->ref_comp))
+		ret = io_uring_quiesce_ctx(ctx);
+		if (ret)
 			return ret;
 	}
 
-- 
2.24.0

