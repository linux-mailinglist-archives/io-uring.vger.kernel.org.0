Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A02877D124
	for <lists+io-uring@lfdr.de>; Tue, 15 Aug 2023 19:34:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238886AbjHORdd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 15 Aug 2023 13:33:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49652 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238920AbjHORdU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 15 Aug 2023 13:33:20 -0400
Received: from mail-lf1-x131.google.com (mail-lf1-x131.google.com [IPv6:2a00:1450:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7DB71BDD
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 10:33:17 -0700 (PDT)
Received: by mail-lf1-x131.google.com with SMTP id 2adb3069b0e04-4fe389d6f19so8896556e87.3
        for <io-uring@vger.kernel.org>; Tue, 15 Aug 2023 10:33:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692120796; x=1692725596;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TNuX+XOKOpOPnPfeKjKStgxGv91vortKXWoWHq+NGN8=;
        b=EYQigw78nE/PUxM7VAdE5/X4ykw8KQdcvNt6RUIlMfyDqmtR5S31cwnoXkN2KJzzzT
         OP0PiFGlMgqLAV3cuI/S8H6Y7MYV9FP3zMvb5j5ZJmeYxF6/9uSY3GnbhzL6lzTxEtMs
         uQfHq+3oOf64EfXnnF4T2Vv/s+Za0Li3144DSFLEdnZ+TNlPMHpH3o12n++dsl3FaWN0
         jO8L2KN3oEYrZ4GMEn33G+Lu0vdQRQ7KFm1algRuSk+MFyzEs5Y3OVq7j7hGN9nGf/bw
         qF/alXJ2fJIgqDQszt4fNlKlJBYuSu4B7vPSqnFOaoXVl7CzIRK+bhKXH0pa5MmDNEvK
         tdng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692120796; x=1692725596;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TNuX+XOKOpOPnPfeKjKStgxGv91vortKXWoWHq+NGN8=;
        b=esIOtOqjHyXSFo5s5oOxm8Ns7ODK3iurHrVseYRk3ZgcsUbGLwHzPrqxQTDDVI7uAq
         2wXEz718jnsrk6usec/DQj8ylbPgi/26rLI9Be7se8vKJ/ARQBicADoq654GyiEZFeoP
         G+V/ofWLXC48/CKQ9EKLLwwprEQp6M8Ya1ElyAkODOaGD7lZAzh9te950SqtS57JyrEn
         pd2afxhLeTu9G+FDKk+EmqQty931UFeJ6j9FBh+66PWJTZgBYQkXy2eQGvXHemdt8aRX
         e5fHQDBdhJfckm6oDsPQjYDUbiNsTEtzRNITc3QCljad66ayQm9qF5yv6344A7ozdqHO
         nRlA==
X-Gm-Message-State: AOJu0Yy/bebzcQkHbCYLnHwFqiMEkaWXi0PzI67NY74yfNRdIgwIq72T
        C52QAe7gJziYSzVfo+fOtUcQXY3aLpU=
X-Google-Smtp-Source: AGHT+IET6Ndt5Guu505JTXnZUHOObdpWfHHqnFM5GsJa9GAtW0vmQOkMHHYOMfhsRGE4A1pdTHCRww==
X-Received: by 2002:a19:7b10:0:b0:4f4:c6ab:f119 with SMTP id w16-20020a197b10000000b004f4c6abf119mr7109247lfc.64.1692120795716;
        Tue, 15 Aug 2023 10:33:15 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:6d35])
        by smtp.gmail.com with ESMTPSA id kk9-20020a170907766900b0099cc36c4681sm7269878ejc.157.2023.08.15.10.33.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Aug 2023 10:33:15 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 01/16] io_uring: improve cqe !tracing hot path
Date:   Tue, 15 Aug 2023 18:31:30 +0100
Message-ID: <130dd5980d00ad88912362a33bfddb09cf53bb3c.1692119257.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1692119257.git.asml.silence@gmail.com>
References: <cover.1692119257.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

While looking at io_fill_cqe_req()'s asm I stumbled on our trace points
turning into the chunk below:

trace_io_uring_complete(req->ctx, req, req->cqe.user_data,
			req->cqe.res, req->cqe.flags,
			req->extra1, req->extra2);

io_uring/io_uring.c:898: 	trace_io_uring_complete(req->ctx, req, req->cqe.user_data,
	movq	232(%rbx), %rdi	# req_44(D)->big_cqe.extra2, _5
	movq	224(%rbx), %rdx	# req_44(D)->big_cqe.extra1, _6
	movl	84(%rbx), %r9d	# req_44(D)->cqe.D.81184.flags, _7
	movl	80(%rbx), %r8d	# req_44(D)->cqe.res, _8
	movq	72(%rbx), %rcx	# req_44(D)->cqe.user_data, _9
	movq	88(%rbx), %rsi	# req_44(D)->ctx, _10
./arch/x86/include/asm/jump_label.h:27: 	asm_volatile_goto("1:"
	1:jmp .L1772 # objtool NOPs this 	#
	...

It does a jump_label for actual tracing, but those 6 moves will stay
there in the hottest io_uring path. As an optimisation, add a
trace_io_uring_complete_enabled() check, which is also uses jump_labels,
it tricks the compiler into behaving. It removes the junk without
changing anything else int the hot path.

Note: apparently, it's not only me noticing it, and people are also
working it around. We should remove the check when it's solved
generically or rework tracing.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.h | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 3e6ff3cd9a24..465598223386 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -145,10 +145,11 @@ static inline bool io_fill_cqe_req(struct io_ring_ctx *ctx, struct io_kiocb *req
 	if (unlikely(!cqe))
 		return false;
 
-	trace_io_uring_complete(req->ctx, req, req->cqe.user_data,
-				req->cqe.res, req->cqe.flags,
-				(req->flags & REQ_F_CQE32_INIT) ? req->extra1 : 0,
-				(req->flags & REQ_F_CQE32_INIT) ? req->extra2 : 0);
+	if (trace_io_uring_complete_enabled())
+		trace_io_uring_complete(req->ctx, req, req->cqe.user_data,
+					req->cqe.res, req->cqe.flags,
+					(req->flags & REQ_F_CQE32_INIT) ? req->extra1 : 0,
+					(req->flags & REQ_F_CQE32_INIT) ? req->extra2 : 0);
 
 	memcpy(cqe, &req->cqe, sizeof(*cqe));
 
-- 
2.41.0

