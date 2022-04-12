Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE5D4FE375
	for <lists+io-uring@lfdr.de>; Tue, 12 Apr 2022 16:10:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355669AbiDLOM5 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 12 Apr 2022 10:12:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350319AbiDLOMz (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 12 Apr 2022 10:12:55 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C207F1CFE4
        for <io-uring@vger.kernel.org>; Tue, 12 Apr 2022 07:10:37 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id k22so9355886wrd.2
        for <io-uring@vger.kernel.org>; Tue, 12 Apr 2022 07:10:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gRc+9flPxf8erdBOV218X755HnvL16j9sR2YHeZVpLg=;
        b=XLbvJLifKsrlrWMPRs0xCtMkTmIOzXzU8QOFGtzPQBz1ePlRUk1z8KStkFSzCfOAzH
         4++TY6w3s5dgYPmwDmXI21oiR+AEjfhEUWB5j33fd4JJ/bx8V36rBg6tOIsP7wjdZoxZ
         2m/9U/ZksWsIknwB6V6rGny0UywJjTk7qtdOe6gwBb821ZT5TTGBl7PhfVI3PdapMb1V
         +YYcTPIiyhULuDNuvyv799ZsuVSqsHOACLI9NAO5e7pUnhcpyDpexIfANlkDPqy5JI6e
         a6TcdyD8yPIB1RWFS7AD7eoZYcs3qRMx0vHpLZDD/4WkZpCNhST8+fF2YIwxsmkp1sIk
         TUUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gRc+9flPxf8erdBOV218X755HnvL16j9sR2YHeZVpLg=;
        b=iGo0Bis/1xrKx+RfyTfyuu78cwqWQA0BcObRKLrbIGyFMWGop+14sk+rObBoHLllPj
         Q4EdIe+cpnZhCLZikW2RY8tL/BEr3ZRsIPIrbss9qvFxSriQnWn45UxfDViTv8p2PM6b
         KDYz6RayiL5Ar1HnNCeJ84SUygwleQtTWqEw/Ab+/8niOkLj3mymgXH4BoTpgZoBMvF6
         1btWekRzlEI9vC+HuGMoERuyFjuTqXkyQPDUs1MHz8VyG4WRBYYIMQFHMAjGg6UNNMKT
         7Xt8cRtgW2gtLyD/AQoKl8FjFEwkIG8n/J7Ct0nqd1bGmwrwNM1HPh64MZ70b2O0L4q4
         s0jQ==
X-Gm-Message-State: AOAM531vOoD/wOtQzYsJpo6cyv58YL8BPaTxIlM92Bsij8s5QjeD5TyO
        VdQmatWdHDzQAOJIgY8/ZbGsezFNf6A=
X-Google-Smtp-Source: ABdhPJwzFIgFXQ9Ewd+XJbJrwUBNqzllXSZIyW1JgRw0cciiguvMNPOwOq1AV/bNAY+hxiEZU7CR0Q==
X-Received: by 2002:a5d:6c68:0:b0:205:a0ee:c871 with SMTP id r8-20020a5d6c68000000b00205a0eec871mr28554083wrz.526.1649772636220;
        Tue, 12 Apr 2022 07:10:36 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.129.222])
        by smtp.gmail.com with ESMTPSA id ay41-20020a05600c1e2900b0038e75fda4edsm2363703wmb.47.2022.04.12.07.10.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Apr 2022 07:10:35 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 3/9] io_uring: shrink final link flush
Date:   Tue, 12 Apr 2022 15:09:45 +0100
Message-Id: <01fb5e417ef49925d544a0b0bae30409845ed2b4.1649771823.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1649771823.git.asml.silence@gmail.com>
References: <cover.1649771823.git.asml.silence@gmail.com>
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

All good users should not set IOSQE_IO_*LINK flags for the last request
of a link. io_uring flushes collected links at the end of submission,
but it's not the optimal way and so we don't care too much about it.
Replace io_queue_sqe() call with io_queue_sqe_fallback() as the former
one is inlined and will generate a bunch of extra code. This will also
help compilers with the submission path inlining.

> size ./fs/io_uring.o
   text    data     bss     dec     hex filename
  87265   13734       8  101007   18a8f ./fs/io_uring.o
> size ./fs/io_uring.o
   text    data     bss     dec     hex filename
  87073   13734       8  100815   189cf ./fs/io_uring.o

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 66dbd25bd3ae..d996d7f82d5d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7766,8 +7766,8 @@ static void io_submit_state_end(struct io_ring_ctx *ctx)
 {
 	struct io_submit_state *state = &ctx->submit_state;
 
-	if (state->link.head)
-		io_queue_sqe(state->link.head);
+	if (unlikely(state->link.head))
+		io_queue_sqe_fallback(state->link.head);
 	/* flush only after queuing links as they can generate completions */
 	io_submit_flush_completions(ctx);
 	if (state->plug_started)
-- 
2.35.1

