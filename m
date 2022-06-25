Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF06D55A916
	for <lists+io-uring@lfdr.de>; Sat, 25 Jun 2022 12:56:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232676AbiFYKxe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 25 Jun 2022 06:53:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232688AbiFYKxb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 25 Jun 2022 06:53:31 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08F35193C1
        for <io-uring@vger.kernel.org>; Sat, 25 Jun 2022 03:53:31 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id n185so2583094wmn.4
        for <io-uring@vger.kernel.org>; Sat, 25 Jun 2022 03:53:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ILOlYtBJHR0amL/QmGXZ22FVloEJvHsPQZNwxmR3VJs=;
        b=OFlFSKHjJHZEn8+fwcUIyb5CqpmVFMKoC1Z1OXrqvHVJONnD4w+Lfd6+sseQy6gczJ
         zvM8JvVC3LYD9y7opVl4W9LjJYBDulILSlWLM6vZLrdIg/+KLpBJAzmDbyXu3oMVTDHP
         k09Tt07qhW3wfJiVkii7qhmMUeV3++i8+fWEUkvfRopf8fZ+49T/CF1vxdJmIbW2LLmd
         NWBQ48hxBcf6fTAaRcXb3GDXQDgfnMNx6eP6UeewR6UnGzNe4Fjukw5MUpCfiLSQZP9c
         11zc5yOONRP3gmhKNvHuuZP/xcCcE6caDvYNr1VHbAUiI7igrdUP2sQDaNXikNs4xANp
         FaLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ILOlYtBJHR0amL/QmGXZ22FVloEJvHsPQZNwxmR3VJs=;
        b=EMjbQ2G3gKN8UUePWs5xvqUJJEQTpAnrNNVKhkujv00Kv2LX3druYS3m4VvuxEnTKg
         pUEi4e2zpWzm2yKZhIJ0YyAv01aLzPGKRLAJQB5Rv/EP93dznI3VBOH6hfdPnNSBltCn
         GEFytsoGoCaoGD249JSprgbExcxC96VOa1DyTVNfPsRJWNQgQ8/kC8ppBkedkjvcYMOZ
         7L1paMrohJUEXdL6AMqwq7xoMqYEMEQKxJgVAvU7bFKtvHblMyKcjWyyadjsheGxT0mv
         5RUcUAI0NqNSH2nT62UJm4KEB08Q4keQnV9eR7oDYoLj9bxUS85snQByUXJmqwwcndyd
         edmA==
X-Gm-Message-State: AJIora+0f1cXkLY8XHizpKz1D+qn7qRUivZ0krldDleMCGZ1w8WFILqd
        vzPtEQ1UtaVDADpd0TeynxhdI3T09Dn0Pw==
X-Google-Smtp-Source: AGRyM1vXEihr/fGXxjMMjaYw7rIVS0HK8UgN/xIxxlt7K3/Ce1RSiz7M8Wp2+iiD1HAZtwhRCzvVUw==
X-Received: by 2002:a05:600c:34d0:b0:3a0:2c07:73ac with SMTP id d16-20020a05600c34d000b003a02c0773acmr8862765wmq.85.1656154409233;
        Sat, 25 Jun 2022 03:53:29 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id m17-20020a05600c3b1100b0039c5497deccsm15810144wms.1.2022.06.25.03.53.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 25 Jun 2022 03:53:28 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 5/5] io_uring: remove ctx->refs pinning on enter
Date:   Sat, 25 Jun 2022 11:53:02 +0100
Message-Id: <a11c57ad33a1be53541fce90669c1b79cf4d8940.1656153286.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1656153285.git.asml.silence@gmail.com>
References: <cover.1656153285.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_uring_enter() takes ctx->refs, which was previously preventing racing
with register quiesce. However, as register now doesn't touch the refs,
we can freely kill extra ctx pinning and rely on the fact that we're
holding a file reference preventing the ring from being destroyed.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 16 ++++------------
 1 file changed, 4 insertions(+), 12 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index e1e8dcd17df3..070ee9ec9ee7 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3049,14 +3049,10 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 			return -EBADF;
 		ret = -EOPNOTSUPP;
 		if (unlikely(!io_is_uring_fops(f.file)))
-			goto out_fput;
+			goto out;
 	}
 
-	ret = -ENXIO;
 	ctx = f.file->private_data;
-	if (unlikely(!percpu_ref_tryget(&ctx->refs)))
-		goto out_fput;
-
 	ret = -EBADFD;
 	if (unlikely(ctx->flags & IORING_SETUP_R_DISABLED))
 		goto out;
@@ -3141,10 +3137,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 					  &ctx->check_cq);
 		}
 	}
-
 out:
-	percpu_ref_put(&ctx->refs);
-out_fput:
 	fdput(f);
 	return ret;
 }
@@ -3730,11 +3723,10 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 	int ret;
 
 	/*
-	 * We're inside the ring mutex, if the ref is already dying, then
-	 * someone else killed the ctx or is already going through
-	 * io_uring_register().
+	 * We don't quiesce the refs for register anymore and so it can't be
+	 * dying as we're holding a file ref here.
 	 */
-	if (percpu_ref_is_dying(&ctx->refs))
+	if (WARN_ON_ONCE(percpu_ref_is_dying(&ctx->refs)))
 		return -ENXIO;
 
 	if (ctx->restricted) {
-- 
2.36.1

