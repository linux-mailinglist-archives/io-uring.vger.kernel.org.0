Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 65F123274BD
	for <lists+io-uring@lfdr.de>; Sun, 28 Feb 2021 23:09:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231246AbhB1WJg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 28 Feb 2021 17:09:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231164AbhB1WJg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 28 Feb 2021 17:09:36 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE6CCC06174A
        for <io-uring@vger.kernel.org>; Sun, 28 Feb 2021 14:08:55 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id o16so12631825wmh.0
        for <io-uring@vger.kernel.org>; Sun, 28 Feb 2021 14:08:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=EUm1xnl2r3QfBSS1L8YfFvOnc1RBr6mjFH6B0BqdGq0=;
        b=Obk+3F9YIBIKRpZSXgtkixKet4XvhxomKnxX/GVR2ebVv3oVHAU2eG8wMde1O3/EJv
         3X0vV42S3j8pO6SMjnYWAF3A6VldfA0wuY6DpaWoIejbw3uV5P+BSjoIwQJ9qwAwwhXe
         4EPbwlxfqb+pAec0Im0pZv/NrupY+PzjplLJJAi+sr5gi0WpNikjCxd6++38COs+yC8v
         A+Lyv97CtY58wnlgw5lWllPACzTHU+Pb3QoUpAhmjMUGUmGWSrTFD45YaBv+RE6aPOzG
         Hw6wI7TBrA7Xv6bYfgOlVGMP1OzmCHQhvkFKh4wzYwAGyC0PinO/vjAKWU4vVuQtHQej
         1sbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=EUm1xnl2r3QfBSS1L8YfFvOnc1RBr6mjFH6B0BqdGq0=;
        b=HxkWWG5tr8IpN+mOepJctMoecywTZxr4GLfbqu9LYcBtcTU158FM5urUc38+iNEEL2
         CrGD0/jkvePc1WrDjI4YUk1+j3NrTxt+oVeGq/tovH/sWJ9e9rai6+3uydaZzoPxhV/f
         sUiuPta4VIywaw9WZvfuoF8m64vg1UtEwWTU0hvsFxJT4pWQjH6nyZQPPtrMO2uU+5gj
         ZSMJPwORa6gidPNAOFBiKWVqfr2PIMC1+n8+Q6ag0RMVWBIEg2C0RqPtqaHJ+jhZ0Tbr
         1G5kXCwD3wWDGIt7zde52TVGtAa/lCDNMzmM42tADQ3ATta7qCLv83dA/UrWnjMuS47j
         Hw1g==
X-Gm-Message-State: AOAM533BcqtqujS02GuMCK1l3Le8H8NB7un1KnZRogpy5ZKSqIssg5bP
        sY8vewVVR/PSu2jKVRmpFLg=
X-Google-Smtp-Source: ABdhPJy1iS2LlOEt9757TiuVgp/mhWumb0kYnJCXT+lmeOnFkQWk4gfWD7qVkxWdyWkJrzd5GJhfiw==
X-Received: by 2002:a05:600c:4f46:: with SMTP id m6mr12666642wmq.160.1614550134535;
        Sun, 28 Feb 2021 14:08:54 -0800 (PST)
Received: from localhost.localdomain ([85.255.232.38])
        by smtp.gmail.com with ESMTPSA id w4sm19780396wmc.13.2021.02.28.14.08.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Feb 2021 14:08:54 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/2] io_uring: fix __tctx_task_work() ctx race
Date:   Sun, 28 Feb 2021 22:04:53 +0000
Message-Id: <c05ae0077d4e248256e6d6fdcd4e25a0c4f640e6.1614549667.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1614549667.git.asml.silence@gmail.com>
References: <cover.1614549667.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There is an unlikely but possible race using a freed context. That's
because req->task_work.func() can free a request, but we won't
necessarily find a completion in submit_state.comp and so all ctx refs
may be put by the time we do mutex_lock(&ctx->uring_ctx);

There are several reasons why it can miss going through
submit_state.comp: 1) req->task_work.func() didn't complete it itself,
but punted to iowq (e.g. reissue) and it got freed later, or a similar
situation with it overflowing and getting flushed by someone else, or
being submitted to IRQ completion, 2) As we don't hold the uring_lock,
someone else can do io_submit_flush_completions() and put our ref.
3) Bugs and code obscurities, e.g. failing to propagate issue_flags
properly.

One example is as follows

  CPU1                                  |  CPU2
=======================================================================
@req->task_work.func()                  |
  -> @req overflwed,                    |
     so submit_state.comp,nr==0         |
                                        | flush overflows, and free @req
                                        | ctx refs == 0, free it
ctx is dead, but we do                  |
	lock + flush + unlock           |

So take a ctx reference for each new ctx we see in __tctx_task_work(),
and do release it until we do all our flushing.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d0ca0b819f1c..365e75b53a78 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1822,6 +1822,9 @@ static bool __tctx_task_work(struct io_uring_task *tctx)
 
 		req = container_of(node, struct io_kiocb, io_task_work.node);
 		this_ctx = req->ctx;
+		if (this_ctx != ctx)
+			percpu_ref_get(&this_ctx->refs);
+
 		req->task_work.func(&req->task_work);
 		node = next;
 
@@ -1831,14 +1834,18 @@ static bool __tctx_task_work(struct io_uring_task *tctx)
 			mutex_lock(&ctx->uring_lock);
 			io_submit_flush_completions(&ctx->submit_state.comp, ctx);
 			mutex_unlock(&ctx->uring_lock);
+			percpu_ref_put(&ctx->refs);
 			ctx = node ? this_ctx : NULL;
 		}
 	}
 
-	if (ctx && ctx->submit_state.comp.nr) {
-		mutex_lock(&ctx->uring_lock);
-		io_submit_flush_completions(&ctx->submit_state.comp, ctx);
-		mutex_unlock(&ctx->uring_lock);
+	if (ctx) {
+		if (ctx->submit_state.comp.nr) {
+			mutex_lock(&ctx->uring_lock);
+			io_submit_flush_completions(&ctx->submit_state.comp, ctx);
+			mutex_unlock(&ctx->uring_lock);
+		}
+		percpu_ref_put(&ctx->refs);
 	}
 
 	return list.first != NULL;
-- 
2.24.0

