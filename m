Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB45050CCA4
	for <lists+io-uring@lfdr.de>; Sat, 23 Apr 2022 19:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236644AbiDWRmR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 23 Apr 2022 13:42:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236646AbiDWRmQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 23 Apr 2022 13:42:16 -0400
Received: from mail-pl1-x630.google.com (mail-pl1-x630.google.com [IPv6:2607:f8b0:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A26591C82E8
        for <io-uring@vger.kernel.org>; Sat, 23 Apr 2022 10:39:19 -0700 (PDT)
Received: by mail-pl1-x630.google.com with SMTP id c23so17821254plo.0
        for <io-uring@vger.kernel.org>; Sat, 23 Apr 2022 10:39:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=9UP2teJqByE0pYAFHHt+U8enRtenb3HxFb9RNqFN6MM=;
        b=FU174YwsXglW8iah1D8kde+3CPvU5r8r+B5drywF84XomdJdwb7QytRrQwXjIzg85Y
         QKsxb+pKV7adSq2hlFmr6KttQeH/sda6VTCcudkufOrNkCf1i9RbzZHVNj7D25ZMxQOx
         VURkrF4VwINkHiwFc0weFKj+HgikM+j9EbU5VjDcgpvhPfOHojej5Mn80e++DvpA83vK
         sFQL16XEPavXmupybmZ5degOZ0u597V5ZTfx0AX/kvi5fuaue6qMKov4/2QAhJsiqcFx
         vC6nD9GtnW8ObXrBTd6czfi86vmjcPqFkzDwVaoXjT5NR4r2WJv2ix9UG59oI07jCYQr
         kF0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9UP2teJqByE0pYAFHHt+U8enRtenb3HxFb9RNqFN6MM=;
        b=p9J146YcaUGmz6aKdA8ZTyC2Yiv4c+Mio2HXM1x+YmJeoEXUTxmThuOyx46posWzjM
         NSXODEBQxoCmTXzUTtpSzC6homINgUPcDhCcfrP4pKwFsV6A66PpJ/31O71p0Yl+wJ5U
         QwuQsDxLILEsawQrgAE2tBuChubF6y15SbKB9jcax7VqTRhwzyESLDQ00JkJ10NZ67es
         dfnD5lWupEuyaasgqnOXMtBEvLAh3Dkr+e6w+RP+Bu1XDieOjDWmL5TPkdBU4+1JGpTF
         8eTC43VmBqhbYzp6Vmu0oh0HNwbfOp0NbgXF++wmRFuq5v33GaVGtc+sSiCRfCLphx3Z
         hWgA==
X-Gm-Message-State: AOAM533W3TfoMHy+yYNMCU4dZWazKH8K6sP5h0DKgYRVj19t2fgobyDt
        xqyfOFjtA7sCjixY0gK3N4AoU7/3OhyBH06R
X-Google-Smtp-Source: ABdhPJwrp6a0YQ/iCErr0MmF6Gr8d9R4sIRoWwSlSq7twD8Q48P99v2Vv9wHgBbtPQHu8G5A8FhKkQ==
X-Received: by 2002:a17:903:22c5:b0:15a:869c:605c with SMTP id y5-20020a17090322c500b0015a869c605cmr10025449plg.113.1650735558843;
        Sat, 23 Apr 2022 10:39:18 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e16-20020a63ee10000000b0039d1c7e80bcsm5198854pgi.75.2022.04.23.10.39.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 23 Apr 2022 10:39:18 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5/5] io_uring: use TWA_SIGNAL_NO_IPI if IORING_SETUP_NO_RESCHED is used
Date:   Sat, 23 Apr 2022 11:39:11 -0600
Message-Id: <20220423173911.651905-6-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220423173911.651905-1-axboe@kernel.dk>
References: <20220423173911.651905-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If this is set, io_uring will never use an IPI to deliver a task_work
notification. This can be used in the common case where a single task or
thread communicates with the ring, and doesn't rely on
io_uring_cqe_peek().

This provides a noticeable win in performance, both from eliminating
the IPI itself, but also from avoiding interrupting the submitting
task unnecessarily.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c                 | 8 +++++---
 include/uapi/linux/io_uring.h | 1 +
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 45992ada2f06..7824a615f06d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -11324,9 +11324,10 @@ static __cold int io_uring_create(unsigned entries, struct io_uring_params *p,
 		ctx->user = get_uid(current_user());
 
 	/*
-	 * For SQPOLL, we just need a wakeup, always.
+	 * For SQPOLL, we just need a wakeup, always. For !SQPOLL, if
+	 * NO_RESCHED is set, then IPIs are never needed by the app.
 	 */
-	if (ctx->flags & IORING_SETUP_SQPOLL)
+	if (ctx->flags & (IORING_SETUP_SQPOLL|IORING_SETUP_NO_RESCHED))
 		ctx->notify_method = TWA_SIGNAL_NO_IPI;
 	else
 		ctx->notify_method = TWA_SIGNAL;
@@ -11428,7 +11429,8 @@ static long io_uring_setup(u32 entries, struct io_uring_params __user *params)
 	if (p.flags & ~(IORING_SETUP_IOPOLL | IORING_SETUP_SQPOLL |
 			IORING_SETUP_SQ_AFF | IORING_SETUP_CQSIZE |
 			IORING_SETUP_CLAMP | IORING_SETUP_ATTACH_WQ |
-			IORING_SETUP_R_DISABLED | IORING_SETUP_SUBMIT_ALL))
+			IORING_SETUP_R_DISABLED | IORING_SETUP_SUBMIT_ALL |
+			IORING_SETUP_NO_RESCHED))
 		return -EINVAL;
 
 	return  io_uring_create(entries, &p, params);
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 980d82eb196e..8a32230aa6f4 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -102,6 +102,7 @@ enum {
 #define IORING_SETUP_ATTACH_WQ	(1U << 5)	/* attach to existing wq */
 #define IORING_SETUP_R_DISABLED	(1U << 6)	/* start with ring disabled */
 #define IORING_SETUP_SUBMIT_ALL	(1U << 7)	/* continue submit on error */
+#define IORING_SETUP_NO_RESCHED	(1U << 8)	/* work doesn't need resched */
 
 enum {
 	IORING_OP_NOP,
-- 
2.35.1

