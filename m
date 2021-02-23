Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6B7A323387
	for <lists+io-uring@lfdr.de>; Tue, 23 Feb 2021 22:59:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230268AbhBWV7D (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Feb 2021 16:59:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232291AbhBWV7A (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Feb 2021 16:59:00 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B894C061574
        for <io-uring@vger.kernel.org>; Tue, 23 Feb 2021 13:58:18 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id n4so24106829wrx.1
        for <io-uring@vger.kernel.org>; Tue, 23 Feb 2021 13:58:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4JbYpt5E+8rgE+cQZceZeEI5S8zXSlSSpK+sEDOqyMY=;
        b=NNkXiw3lbOKNHFq6nQboTUoKFJbQ1WzboSLHbbfFrOjg7lYdIp3Wdpc+jbZ6/+B4ou
         P9epeK/9iCtHPkuIt0ldRj0HQnYNpoh1sh39KmQ/27BG28jyMrpb1AciTERhL/tGHLgX
         D7KBZI4eEvjlFK1AEOuITvS4yASOaqa6mBvtkHl3tZyjSJ7HCZrmH4nF9M+IkbBpzVVl
         taZ+iee+gVzIrIEdJk+e2YILhOUnEiZitXAknf2VHOX9uOiusaNbEz3lhRkSjfo0kTkp
         WOki44m0P36u1g5Gvu0WQhxbyQ5uKMqZ1+CwHjmzCCeZ4J/kcc/NeKw7YWpgHACTUZQs
         gdAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=4JbYpt5E+8rgE+cQZceZeEI5S8zXSlSSpK+sEDOqyMY=;
        b=sIh8t5qtbUJ8jbpXb6HnMgppkckF0rAeScKzFUEXrceDSCeHQs2Gin/761e5WSCfQy
         ranhLUiUqsbvmaUw1aekl9TavPz8+krvUeXhFLn1ce6YFGD6tlVdkIFhW/8Hr7WC+pEh
         VOekqhWS4Rwl1u+FBv+656c+HFWLznzWlAfoJAuoHvqkuABtfZgKsDTatHuMYdzCnbKF
         cYT275voUaHQYYQhREXJgUEgU82UYXAbLbLZ7TeXNurJX1grERMzLpYgxDBAx1QcpOfs
         GqtHHC77spp+ng3R0zcokpGhC7UpK6+jcQDwFbI7mvScflceB4nu+ANhN/CeI3/+wWNN
         vrKQ==
X-Gm-Message-State: AOAM532fKjuR2XUZFNquvKNk/uKdoiNCr2BhRO5EupVWberM733c4B67
        lSpdTMqwHyt3Lr8+6TpKzi3gKBpKosjxTA==
X-Google-Smtp-Source: ABdhPJzjqcxg+I4U85621b9U0+/EEbm9NetGz84HtuAtvkqxC440XilmlaEJS68nhCw2W4PA9UPJFQ==
X-Received: by 2002:adf:9bd7:: with SMTP id e23mr28227678wrc.48.1614117496047;
        Tue, 23 Feb 2021 13:58:16 -0800 (PST)
Received: from localhost.localdomain ([148.252.132.56])
        by smtp.gmail.com with ESMTPSA id s23sm3774561wmc.29.2021.02.23.13.58.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 13:58:15 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/1] io_uring: fix locked_free_list caches_free()
Date:   Tue, 23 Feb 2021 21:53:49 +0000
Message-Id: <3375ffb5767effcf8792e8425e189e78eb843431.1614117221.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Don't forget to zero locked_free_nr, it's not a disaster but makes it
attempting to flush it with extra locking when there is nothing in the
list. Also, don't traverse a potentially long list freeing requests
under spinlock, splice the list and do it afterwards.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bf9ad810c621..dedcf971e2d5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8710,12 +8710,13 @@ static void io_req_caches_free(struct io_ring_ctx *ctx, struct task_struct *tsk)
 		submit_state->free_reqs = 0;
 	}
 
-	io_req_cache_free(&submit_state->comp.free_list, NULL);
-
 	spin_lock_irq(&ctx->completion_lock);
-	io_req_cache_free(&submit_state->comp.locked_free_list, NULL);
+	list_splice_init(&cs->locked_free_list, &cs->free_list);
+	cs->locked_free_nr = 0;
 	spin_unlock_irq(&ctx->completion_lock);
 
+	io_req_cache_free(&submit_state->comp.free_list, NULL);
+
 	mutex_unlock(&ctx->uring_lock);
 }
 
-- 
2.24.0

