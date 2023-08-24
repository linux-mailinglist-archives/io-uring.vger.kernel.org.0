Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EED3787BB2
	for <lists+io-uring@lfdr.de>; Fri, 25 Aug 2023 00:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234851AbjHXWzm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 24 Aug 2023 18:55:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244010AbjHXWz2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 24 Aug 2023 18:55:28 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7A651FD6
        for <io-uring@vger.kernel.org>; Thu, 24 Aug 2023 15:55:20 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id a640c23a62f3a-99bc9e3cbf1so86996766b.0
        for <io-uring@vger.kernel.org>; Thu, 24 Aug 2023 15:55:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692917719; x=1693522519;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TNuX+XOKOpOPnPfeKjKStgxGv91vortKXWoWHq+NGN8=;
        b=GN7Y51rkxh/KDEYJopcAC0JCE27tT3N8tM7IhoR+81h6Lp3NJDp7fWI28+2C9jbsE/
         5oegkyfnn3A/ffz8pDOOKtYjNkUl3uILDcvZ1q95F5yuA+6a7q4Sd2fWSSz2zsBBjEH7
         v3GaiR/YzYqKAkSU/cdJUDxoHubEPbdaLTCokhsbx/71rbvWAG1orcQxv7t5s3Q+eElW
         1fLhCrE94RH0tTHgYzezABuneZEhJqbxq4/McgsNYAni9rbRojHE0vJ2OkIVh0nX9aBJ
         7otJ1W4gp7buPvCqvReJASaR9CCTDSdiWdmkI9WvimzSUmDz0ZRKqyBHrx/Sw+tQwy96
         +RNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692917719; x=1693522519;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TNuX+XOKOpOPnPfeKjKStgxGv91vortKXWoWHq+NGN8=;
        b=OhEtAxO1UhZlsF+fwzKdoEjmfsIo6O3rR2FqWi+c/6QlBjOBQtkc/sE6P4vxLg+JMg
         pe1ZO4XPyMnNzrEUMrm61ALvHbsa5iZC1wKiwLbgWObS941YGzSkI+tHr8zGgk+d6+jQ
         vHwh1wzgekYK37OVSCqy2Xjn4PYyXDv9JZdrDtBWXFR3h5lJEnwQjV5i99vbM47QeKbZ
         WZQK2+9/4IXsdPOCDpJ9Tr68hiWDRlcGtMuz/x03KD+JZ1no2ifH+ZEriNvN3aZlNm8U
         2XGwP7xww8p2G3MgQCZkjOnYnDJMkXjFSwqwLG96TkPCS4Jnzc6eIRy1QPylrA2UOund
         p2MQ==
X-Gm-Message-State: AOJu0YzMime8hXzOvK+Zv452Uamon3ILb9xUsoWi96EhoUew1QSOfwDV
        lTCtmQyh0a/ycS4YSXhJUMlJWRSdc/Y=
X-Google-Smtp-Source: AGHT+IEV2wWabq7ntU5I449SamtsFWtTSO6aZzb8f78mtoI0n8IAlfLbCTifxplbWkayRUlRyKhOow==
X-Received: by 2002:a17:907:1c84:b0:9a1:c32c:a69c with SMTP id nb4-20020a1709071c8400b009a1c32ca69cmr9542348ejc.17.1692917718748;
        Thu, 24 Aug 2023 15:55:18 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.140.69])
        by smtp.gmail.com with ESMTPSA id q4-20020a170906144400b00992f81122e1sm173469ejc.21.2023.08.24.15.55.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Aug 2023 15:55:18 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH v2 01/15] io_uring: improve cqe !tracing hot path
Date:   Thu, 24 Aug 2023 23:53:23 +0100
Message-ID: <555d8312644b3776f4be7e23f9b92943875c4bc7.1692916914.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1692916914.git.asml.silence@gmail.com>
References: <cover.1692916914.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
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

