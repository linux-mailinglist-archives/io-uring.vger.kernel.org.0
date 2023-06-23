Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E51B973B611
	for <lists+io-uring@lfdr.de>; Fri, 23 Jun 2023 13:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229902AbjFWLYo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Jun 2023 07:24:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231363AbjFWLYn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Jun 2023 07:24:43 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61F542139
        for <io-uring@vger.kernel.org>; Fri, 23 Jun 2023 04:24:42 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id a640c23a62f3a-9891c73e0fbso106318066b.1
        for <io-uring@vger.kernel.org>; Fri, 23 Jun 2023 04:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687519480; x=1690111480;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iJYqXXZ2rSE8cC4yUUULEsr78gxRL+8pWiAzPGjpLC8=;
        b=imTIlEuXTuDeeA/PWid1DZ3+BqTN9h+FKoNQ628hWXeQvfY23n76NlLbBQSh+f23Jk
         Lo3uB9xB7MgYHQ5DgHLifHa0m/gxXrP5yusuPiCKOsIXIxYF5fzHwTUpkmpNyzBU9VJJ
         qwCNIoJkaDkV51HWj1Ozo+zTVorwgjlLvrPp0JvU9okShH3m0gKYFNuM+0JlNyP3UEvT
         WlM9487KPS28BKU6zl5NZcWh4bJY3lLKb3FzhCFTSjZWLgQwVmvz8h1SY9Pf3eUmNGjw
         4sAh3eO8j1PjEMe72dVVuLaXwugfl+CyQSDhyOLZ+PC1qBuQLlnS1NLGpVUIYwRJUBXc
         FCiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687519480; x=1690111480;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iJYqXXZ2rSE8cC4yUUULEsr78gxRL+8pWiAzPGjpLC8=;
        b=HRNe+OHdR51XAnz6Mv4lIg35vDM3CFxRw7mcJczGFeEECFkDU5E9PMg2C5r3rya81A
         8DoWlv2FoyoH2qZyS6ovnIjtK+DjtbggStNxhWhXccEgohjqJhhqOvfEMlaaRDIG3Xp2
         wNRjqce8GyhSSZb7DSN3HOLtAZOljmv9wGJjB0aBkwguPXfP5e3Z9pbIfSH3q8fTINct
         gtJHyJC5pcgPN1U5oINA+os3l4+EZ1lmalpoK3UIP2Phveh9409NvwI9j02Y1aCP+K/h
         w4Sl/v1Oh1h8kcjLkM/btSiNA9cMsd1TG4oUy74HrU06A17j2VqX5fBsL83w8HCcohai
         ttSA==
X-Gm-Message-State: AC+VfDwohzg20hG6trKVj6uxF49Y3llUfLeTkP0WqAMmvlIMYDes1CDf
        Rjm0KltUwL+riFZS/WzBkBcc08pw3hQ=
X-Google-Smtp-Source: ACHHUZ65A82y6FVBc/eIPZDK+rL1dJk+fB9AfDaofzMBjPFYcAE/i8kd4np0OA7vgLid0tnkb3f3zw==
X-Received: by 2002:a17:907:7ba5:b0:982:4b35:c0b6 with SMTP id ne37-20020a1709077ba500b009824b35c0b6mr20617803ejc.1.1687519480637;
        Fri, 23 Jun 2023 04:24:40 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:7d95])
        by smtp.gmail.com with ESMTPSA id h10-20020a1709067cca00b00969f44bbef3sm5959769ejp.11.2023.06.23.04.24.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jun 2023 04:24:40 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 08/11] io_uring: fix acquire/release annotations
Date:   Fri, 23 Jun 2023 12:23:28 +0100
Message-Id: <2a098f9144c24cab622f8bf90b39f44da5d0401e.1687518903.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1687518903.git.asml.silence@gmail.com>
References: <cover.1687518903.git.asml.silence@gmail.com>
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

We do conditional locking, so __io_cq_lock() and friends not always
actually grab/release the lock, so kill misleading annotations.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 2f55abb676c0..8cb0f60d2885 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -626,7 +626,6 @@ void __io_commit_cqring_flush(struct io_ring_ctx *ctx)
 }
 
 static inline void __io_cq_lock(struct io_ring_ctx *ctx)
-	__acquires(ctx->completion_lock)
 {
 	if (!ctx->task_complete)
 		spin_lock(&ctx->completion_lock);
@@ -646,7 +645,6 @@ static inline void io_cq_lock(struct io_ring_ctx *ctx)
 
 /* keep it inlined for io_submit_flush_completions() */
 static inline void __io_cq_unlock_post(struct io_ring_ctx *ctx)
-	__releases(ctx->completion_lock)
 {
 	io_commit_cqring(ctx);
 	__io_cq_unlock(ctx);
@@ -655,7 +653,6 @@ static inline void __io_cq_unlock_post(struct io_ring_ctx *ctx)
 }
 
 static void __io_cq_unlock_post_flush(struct io_ring_ctx *ctx)
-	__releases(ctx->completion_lock)
 {
 	io_commit_cqring(ctx);
 
-- 
2.40.0

