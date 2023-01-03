Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B20BC65B989
	for <lists+io-uring@lfdr.de>; Tue,  3 Jan 2023 04:05:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236605AbjACDFZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 2 Jan 2023 22:05:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231327AbjACDFX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 2 Jan 2023 22:05:23 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EB0E2733
        for <io-uring@vger.kernel.org>; Mon,  2 Jan 2023 19:05:22 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id c65-20020a1c3544000000b003cfffd00fc0so25298834wma.1
        for <io-uring@vger.kernel.org>; Mon, 02 Jan 2023 19:05:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bqsHZn+qHgHSoeDc737BfWQdCtKG04zCxIEm2ZdOgbg=;
        b=XYfImAobV6SpW4yIiOnkaG5twtuWr2HOPDjb9XnIRhoyhH+2ZdnJWao4X5foK2UTnv
         qBukGaeDbhGg3KHyro99j7NReZYteSFy5TvVuSSp2MYk4G8yuLf99kWT3bW5gJpvTCqF
         yacGe3MGc7tJL7VLynGY/5NP9MrocvZeM/tXaRy4CJ5hFWgP130QZsg00VQHcYh/D3lw
         0UoU+G5mrWWbiJydB+zc1OqNvuRyALJhpHF9DoiAgh0/Db+JUgqaUkrjI0wEQ8mpOIBs
         Kbb27KTWEy5fHd4lttDzz4Ur0EY1AmVPSFTkposgCQvcLMwna+C0tY1954gtL7GW8Gg7
         lgGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bqsHZn+qHgHSoeDc737BfWQdCtKG04zCxIEm2ZdOgbg=;
        b=kc4+yZVSEk4Lsl45d5n5JU/mf6jRbPtLcWiFPe+0FxPE0U1gETcg2dQ5vjHDlmeFO8
         u/pQeSLRXyIHjXHa/TFOWKib1+JIdswXl202Uin5+noI008/1pGs9kmBQ1VMMLcvZKLf
         bCldz7M6bCrgvYdHnqIkUQa2FxN0i38DEnizNN394yE9xUQi702bZwIvkPsMUIc/BwQY
         EM52F+NTwAFaD8ZBNgh7Dpz2zV8DCfwRvtXlGywPks0/Euumn3UV7KM5Kq/mKsqXpWPF
         BVJpcObDqlN7BfGU1iCR7kK4e9k9J51Fd1WBEGp6DiylojH9FVcN2L5Fg5Hzo0GwKGpF
         mWdg==
X-Gm-Message-State: AFqh2kp8IDxF6eqV97YPjZZp27ZeKLFB/RNxDXFugMv2ewl7FENUlear
        SpSXI0qAst639pIbPn2oV0LjzXBxVNc=
X-Google-Smtp-Source: AMrXdXuJROY/4NMzvRLSzXPqTY0zlSYsIndEYdqBhMppZKbl09QekFmMoGn+gB7yXcbQCUbvieAFuQ==
X-Received: by 2002:a05:600c:18a1:b0:3d2:3ec4:7eed with SMTP id x33-20020a05600c18a100b003d23ec47eedmr33243527wmp.10.1672715120818;
        Mon, 02 Jan 2023 19:05:20 -0800 (PST)
Received: from 127.0.0.1localhost (188.28.229.101.threembb.co.uk. [188.28.229.101])
        by smtp.gmail.com with ESMTPSA id m1-20020a7bca41000000b003d1de805de5sm39967839wml.16.2023.01.02.19.05.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Jan 2023 19:05:20 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [RFC v2 01/13] io_uring: rearrange defer list checks
Date:   Tue,  3 Jan 2023 03:03:52 +0000
Message-Id: <52e8192f6e36b5918371aa139a4f62a084757622.1672713341.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1672713341.git.asml.silence@gmail.com>
References: <cover.1672713341.git.asml.silence@gmail.com>
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

There should be nothing in the ->work_llist for non DEFER_TASKRUN rings,
so we can skip flag checks and test the list emptiness directly. Also
move it out of io_run_local_work() for inlining.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 3 ---
 io_uring/io_uring.h | 2 +-
 2 files changed, 1 insertion(+), 4 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 58ac13b69dc8..4f12619f9f21 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1338,9 +1338,6 @@ int io_run_local_work(struct io_ring_ctx *ctx)
 	bool locked;
 	int ret;
 
-	if (llist_empty(&ctx->work_llist))
-		return 0;
-
 	__set_current_state(TASK_RUNNING);
 	locked = mutex_trylock(&ctx->uring_lock);
 	ret = __io_run_local_work(ctx, &locked);
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index e9f0d41ebb99..46c0f765a77a 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -274,7 +274,7 @@ static inline int io_run_task_work_ctx(struct io_ring_ctx *ctx)
 	int ret = 0;
 	int ret2;
 
-	if (ctx->flags & IORING_SETUP_DEFER_TASKRUN)
+	if (!llist_empty(&ctx->work_llist))
 		ret = io_run_local_work(ctx);
 
 	/* want to run this after in case more is added */
-- 
2.38.1

