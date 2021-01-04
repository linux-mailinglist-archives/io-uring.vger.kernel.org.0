Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57A432EA110
	for <lists+io-uring@lfdr.de>; Tue,  5 Jan 2021 00:46:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727410AbhADXqL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 4 Jan 2021 18:46:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726026AbhADXqL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 4 Jan 2021 18:46:11 -0500
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A062C061796
        for <io-uring@vger.kernel.org>; Mon,  4 Jan 2021 15:45:31 -0800 (PST)
Received: by mail-ed1-x533.google.com with SMTP id b73so29182292edf.13
        for <io-uring@vger.kernel.org>; Mon, 04 Jan 2021 15:45:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=biohuaz8qHAl2bwblz3F9N6jQTPf4tFievc4sERx/QQ=;
        b=X7QUYaJGO3skhWod6GXQrJ/b9AHrzaOt3rBSxjuYempnSMBT88m2lZFkA6b7+ZZFhP
         Zs/JCcXgetgYRu4TuBphjVKoMvN1izBUclBc1XSbd8Nw4k6FhNSkyK+/LVeIG7qEXMju
         yRxucbFspp/19N5MUCRsHcZzrBQn8G5zBCwzEUZKSHGeV1B97yG99M1tzZ8SUZ3eyOrR
         DN96reeqFI1yYJnVqUsWBwdLZX2BsEyFbxcbdRev8VjEaHNGqR8tBnazSWlflFqU5/ow
         NVzdCepF8uY/0yFfLm0m7NRdO1Xe7IGM/F5ESkVMlHjk6Ql6nKavbNOuApJRxbtszyX1
         PtUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=biohuaz8qHAl2bwblz3F9N6jQTPf4tFievc4sERx/QQ=;
        b=Khiu47Gb7zqEGt25BYzYdoGa+36GDGgOjA6bAcDwJJ8y+QGrQ8aaOiy3vC5U3zt3Y5
         RH2/cynEJ8A2Lm7U/WTyIlP1rSPTf4XO054cLVKRG/YeM7wVg4Xdo6IcsZ8jU1ph+NVB
         s9dTKisSQ+Ad8Rv06j/2Dbla7nEJ8P8HxfTXM6QT/HpYjD6aj0HLULIy21CcU2V0gVZX
         rVYJ11wI91MnxBg+TIggtOW18G/UUPDmGGLCKRjU+BJe0RxS1xQp3ChD/RoGiFweGawy
         EImmtNrQ+qA/ra0ezvKmH1XeyWfzZbC7vdWu6lDWssebCriy+H2CRUCRSvF04t5SAwfb
         dyiQ==
X-Gm-Message-State: AOAM531dv+1Sm+QRPP2osvmgdrKrJ062kH4qagVs2HAcTNY6SjkzkSNf
        bXqsKBXRk45rxtt0jsbbZm5oTzg+Siza8g==
X-Google-Smtp-Source: ABdhPJyKrpsrZ+VZQP/dS2ca3ByR8XnnxdJcegsgyfoWSrYLni5UZdrHLUP8DiicVsCEmBmUEyXIyQ==
X-Received: by 2002:a5d:4f0e:: with SMTP id c14mr81373216wru.84.1609793227515;
        Mon, 04 Jan 2021 12:47:07 -0800 (PST)
Received: from localhost.localdomain ([85.255.233.205])
        by smtp.gmail.com with ESMTPSA id n16sm54715017wrj.26.2021.01.04.12.47.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 12:47:07 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH -v2 2/2] io_uring: cancel more aggressively in exit_work
Date:   Mon,  4 Jan 2021 20:43:30 +0000
Message-Id: <f241b61d3d04b668f186af0cd465b04699274696.1609792653.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1609792653.git.asml.silence@gmail.com>
References: <cover.1609792653.git.asml.silence@gmail.com>
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
index 85de42c42433..5bccb235271f 100644
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
@@ -8675,7 +8678,7 @@ static void io_ring_exit_work(struct work_struct *work)
 	 * as nobody else will be looking for them.
 	 */
 	do {
-		io_iopoll_try_reap_events(ctx);
+		__io_uring_cancel_task_requests(ctx, NULL);
 	} while (!wait_for_completion_timeout(&ctx->ref_comp, HZ/20));
 	io_ring_ctx_free(ctx);
 }
@@ -8830,9 +8833,11 @@ static void __io_uring_cancel_task_requests(struct io_ring_ctx *ctx,
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

