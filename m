Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07541382157
	for <lists+io-uring@lfdr.de>; Sun, 16 May 2021 23:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbhEPV7v (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 16 May 2021 17:59:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbhEPV7r (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 16 May 2021 17:59:47 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBF65C061573
        for <io-uring@vger.kernel.org>; Sun, 16 May 2021 14:58:30 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id o6-20020a05600c4fc6b029015ec06d5269so2469702wmq.0
        for <io-uring@vger.kernel.org>; Sun, 16 May 2021 14:58:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=X92UrMGAYxg8M49sxed4byoZfA6xgxE2bUcm0SnVD7M=;
        b=iTxBJ2ByHDWcj6e5/ndflHVBN/nMcVMGoLqNVA/js+pQyqwoy1xPXkPLUFm864dulC
         ACjRqqAvuWIWJdEb680bHY4JyAU7dZHyICHBF4I1z4a/PmvdDfd9c20z3P90wHhCnXVL
         G6hUAfbKMO86RBAL/bI9MhX/2s+7eXyx93fuViunRc31f7bgwLNUXXgJsOLExIO/dEmV
         ro1YNUj7qjPWFgi9FQjGatHZVGx3tEjaiH0zU1ibIGoHJeCVpW8M2fsCZREG43yy2q3Q
         T/4T+GDfByy8jhzYzFk5RgRdk1VSwov8gZjuQeAcdnqtEuHhwfh2HNP/vXaD1iKneByI
         D6yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=X92UrMGAYxg8M49sxed4byoZfA6xgxE2bUcm0SnVD7M=;
        b=bbnC/A4iz75QNv5efY0BP/IzNJLduD45HHsn9iLgXsUby0WL35ewVjnayqTdcv9mnF
         hKG1NRQLsn4q/3YOABPzOBv1BP2KEvSppSstor9s129WUvbHNSImAEPsoEOVjJQYiLS0
         aWQTtMTiN7s4xmf18/gW/RGQBAZwONd3QpR+9izB5rj/q3rh1SZho/YNn3MbbitdHv12
         1bBcGThB/BK4gH2bBqyMnn+D8HlvW8ELxzykac65WcQh6iw7GtTzLR9eqkIYAanoPxjy
         B6UoaBjJimI7bFSvTMDBD3117A7sXdSrAgp1ekue/9kqLezy3j2AUaxM+RfVwsN9nzXf
         xGnQ==
X-Gm-Message-State: AOAM530jish7cIcB8GOHdoh6uXdwMcEGQ3TbT6xAIG3kjs7ssxCK++zl
        9m0RqsB3lhagHpazo688Dl/mfgby678=
X-Google-Smtp-Source: ABdhPJwvXnd7Cu9zxx1pkZjaCSEMBKP6qr21/EG5Igzq8AsDLai6j62a1MHLmTukKUt88V9RgwGwpA==
X-Received: by 2002:a05:600c:2dd7:: with SMTP id e23mr92949wmh.186.1621202309512;
        Sun, 16 May 2021 14:58:29 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.7])
        by smtp.gmail.com with ESMTPSA id p10sm13666365wmq.14.2021.05.16.14.58.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 May 2021 14:58:29 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 04/13] io_uring: simplify waking sqo_sq_wait
Date:   Sun, 16 May 2021 22:58:03 +0100
Message-Id: <e2e91751e87b1a39f8d63ef884aaff578123f61e.1621201931.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1621201931.git.asml.silence@gmail.com>
References: <cover.1621201931.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Going through submission in __io_sq_thread() and still having a full SQ
is rather unexpected, so remove a check for SQ fullness and just wake up
whoever wait on sqo_sq_wait. Also skip if it doesn't do submission in
the first place, likely may to happen for SQPOLL sharing and/or IOPOLL.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 152873b88efe..192ce31d310c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -6796,10 +6796,10 @@ static int __io_sq_thread(struct io_ring_ctx *ctx, bool cap_entries)
 		    !(ctx->flags & IORING_SETUP_R_DISABLED))
 			ret = io_submit_sqes(ctx, to_submit);
 		mutex_unlock(&ctx->uring_lock);
-	}
 
-	if (!io_sqring_full(ctx) && wq_has_sleeper(&ctx->sqo_sq_wait))
-		wake_up(&ctx->sqo_sq_wait);
+		if (to_submit && wq_has_sleeper(&ctx->sqo_sq_wait))
+			wake_up(&ctx->sqo_sq_wait);
+	}
 
 	return ret;
 }
-- 
2.31.1

