Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10DF53233AC
	for <lists+io-uring@lfdr.de>; Tue, 23 Feb 2021 23:22:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231523AbhBWWWJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Feb 2021 17:22:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230434AbhBWWWI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Feb 2021 17:22:08 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF995C06178C
        for <io-uring@vger.kernel.org>; Tue, 23 Feb 2021 14:21:21 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id l12so2083wry.2
        for <io-uring@vger.kernel.org>; Tue, 23 Feb 2021 14:21:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Br7TK/h7Dn9lY5Q2tzGiLyDX64T8XtRq4ELOGBnzVaE=;
        b=aSgD+ZT2gLeYP21wOfMa5ZLMh5CgkAdOku2oCNpZzF1ANijewJIBQzRO6tXSyBJUjW
         /oOz9KHiUnvPNfPN8skK/sN9+SPVyriXbja/OZpIimA+cTGEF37oULs/807tZ4NqIV18
         PjtdkoY7dAo+w0bWtmr1M1QibF3PVYiRzPk1NEX8G3Uwg4yplsC4TRQT+WvEpktZ9UXD
         o6XxrCVxFKgRWqJ1vuA7+oX544TwHjpVTFAII1zQybVKTGj2KK899VYhAAok45t4eMTp
         wgWG/tOPdM3MeeUcrULcs/hy/OLpwImgU9ycwsQm0k/VZRzCOY5PGiI50/7z6dLyiIC7
         Z9Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Br7TK/h7Dn9lY5Q2tzGiLyDX64T8XtRq4ELOGBnzVaE=;
        b=A710d0NP9yMGqoNzp2EfUZm4vtyDqCzHc0z8qVfWEKuxoNkHcV2K4biPcY79pVa08V
         As3qHMwIZWD/chtpdYc5XeJJTPUhQBtBY4FPomPNxK5HNcAO+YIbxK6h5HrPme21SW5t
         AnCMbUu9mv505ieDOXgZS2ZzZ6bE26xVHuondk47ScKEoRFR4Lgf2hQm5sE0CqukFfOQ
         J4UkE+cCf2YX0PXUsE8JWZ8WjbGjYS5T6YlZUU9vSrFeomlX4lE4YK6zgqK+UE8BoCfj
         kKMB91guvibPRtbJMdoyC7eejM5x3G3eGQCwHzeT4lh9rcjt5qGYPH8dDCZURYJGD7IB
         Xc7g==
X-Gm-Message-State: AOAM531LVS1xKXHtGX+EpyCQNUIYNvbtt1j3JrdNLfbvaiXMIuOmH3Pd
        RL9MbeSkIkxo0c+KRdhqp9s=
X-Google-Smtp-Source: ABdhPJxN3xmHVdtYMWzrKwL5kdtTdo6HIEfNH4vGaVd4/AZ2lRh4DDslGsm7oVIrAN0Hvnce8gsjEg==
X-Received: by 2002:a05:6000:1184:: with SMTP id g4mr15513684wrx.322.1614118880310;
        Tue, 23 Feb 2021 14:21:20 -0800 (PST)
Received: from localhost.localdomain ([148.252.132.56])
        by smtp.gmail.com with ESMTPSA id 75sm4550716wma.23.2021.02.23.14.21.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Feb 2021 14:21:19 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 5.12] io_uring: fix locked_free_list caches_free()
Date:   Tue, 23 Feb 2021 22:17:20 +0000
Message-Id: <feff96ab5f6c2d5aff64b465533adcf59ec21894.1614118564.git.asml.silence@gmail.com>
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
 fs/io_uring.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bf9ad810c621..1a26898d23ed 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8701,6 +8701,7 @@ static void io_req_cache_free(struct list_head *list, struct task_struct *tsk)
 static void io_req_caches_free(struct io_ring_ctx *ctx, struct task_struct *tsk)
 {
 	struct io_submit_state *submit_state = &ctx->submit_state;
+	struct io_comp_state *cs = &ctx->submit_state.comp;
 
 	mutex_lock(&ctx->uring_lock);
 
@@ -8710,12 +8711,13 @@ static void io_req_caches_free(struct io_ring_ctx *ctx, struct task_struct *tsk)
 		submit_state->free_reqs = 0;
 	}
 
-	io_req_cache_free(&submit_state->comp.free_list, NULL);
-
 	spin_lock_irq(&ctx->completion_lock);
-	io_req_cache_free(&submit_state->comp.locked_free_list, NULL);
+	list_splice_init(&cs->locked_free_list, &cs->free_list);
+	cs->locked_free_nr = 0;
 	spin_unlock_irq(&ctx->completion_lock);
 
+	io_req_cache_free(&cs->free_list, NULL);
+
 	mutex_unlock(&ctx->uring_lock);
 }
 
-- 
2.24.0

