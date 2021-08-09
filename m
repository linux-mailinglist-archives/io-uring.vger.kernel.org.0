Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8553E4548
	for <lists+io-uring@lfdr.de>; Mon,  9 Aug 2021 14:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235362AbhHIMFv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Aug 2021 08:05:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235358AbhHIMFr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Aug 2021 08:05:47 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9F90C0613D3
        for <io-uring@vger.kernel.org>; Mon,  9 Aug 2021 05:05:26 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id k29so8291353wrd.7
        for <io-uring@vger.kernel.org>; Mon, 09 Aug 2021 05:05:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=C0MdYWAHPFtQX36fEaJe1N01xX30gaHsdG42C1HnIQQ=;
        b=gaxpLxAPTNRUz0DFd4hCAHwO6yiEUgFzMHlmxC1smbIq3e6ycQfzhCWH5fR3ztH61P
         3ujSLivQrYj1hcqwd+6l/8oQS7enDwtYVojsCBKPb7jgAxbZ8qelR8o7a463LCcexOvm
         10sKuwwN0naEHjZ951CX41R03Jqs4tyGx9qgND5IA4dy7ovLRsshQgEPIZDZXBGZsNL7
         z7Vi5840lzYPI/RpR3y8qDDp3fqk/CdUuSU6XOH8wJjdYct6+oYcu3F5lNLKN9lOO+iD
         FDADKaw/g828ejZRPyz3LxIR7hX13DmSsSRNCLMMJN9F4VkzI/7Y4Q79gbwq3Ukxc59V
         qAfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=C0MdYWAHPFtQX36fEaJe1N01xX30gaHsdG42C1HnIQQ=;
        b=LO6z0NijlVArS10Bs9rK4Gcr7su3z0JQK7BUSG7MXPet7gNXvLM9bGZDlKYrg9B/AJ
         Ne26tuFTocQnJ23EIwC6E92vUpH0hMON0/C9Nz2CSwF8YK2Ga2pNSpwUcv3lkw2pN9R5
         Dhv5AZOIaTYuNvYU4HfLqVmc5EcP8Q/S1v2pgFZmfWoCM+Q1ye4C6eif7K90fbYgQMND
         gkzaXSR29xExrSBq44sH0WdpwJ3jCtibPpSoF0orcunzDA7iXQ0jJoS2LsnXHoIy7GFf
         iiI2pX3mIPN1IoIrw3McXP99im5zfE54G7OFIMBZQu/wPwaZAFS9Ii7yCJEt5uI2yVkl
         Qulw==
X-Gm-Message-State: AOAM533GNbXG+jPFs3rdbxXP4auwsvfdvmR0obSZVjzq0y4IsTsbhCkb
        ljGkQ5rgF40CujyAxLCtLaw=
X-Google-Smtp-Source: ABdhPJyJ9q75yXIgL5kXdexlf1/QaaO7L+IuKszgNu38zlZWIxwM5Jt7Anym227h3E9p6oXdRNMfPw==
X-Received: by 2002:adf:b357:: with SMTP id k23mr7602575wrd.94.1628510725592;
        Mon, 09 Aug 2021 05:05:25 -0700 (PDT)
Received: from localhost.localdomain ([85.255.236.119])
        by smtp.gmail.com with ESMTPSA id g35sm4757062wmp.9.2021.08.09.05.05.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 05:05:25 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 24/28] io_uring: remove redundant args from cache_free
Date:   Mon,  9 Aug 2021 13:04:24 +0100
Message-Id: <605940169772a80dc214cbab331996a6a87e89ef.1628471125.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628471125.git.asml.silence@gmail.com>
References: <cover.1628471125.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We don't use @tsk argument of io_req_cache_free(), remove it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ec1cab2b9a91..92854f62ee21 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8646,13 +8646,11 @@ static void io_destroy_buffers(struct io_ring_ctx *ctx)
 		__io_remove_buffers(ctx, buf, index, -1U);
 }
 
-static void io_req_cache_free(struct list_head *list, struct task_struct *tsk)
+static void io_req_cache_free(struct list_head *list)
 {
 	struct io_kiocb *req, *nxt;
 
 	list_for_each_entry_safe(req, nxt, list, compl.list) {
-		if (tsk && req->task != tsk)
-			continue;
 		list_del(&req->compl.list);
 		kmem_cache_free(req_cachep, req);
 	}
@@ -8672,7 +8670,7 @@ static void io_req_caches_free(struct io_ring_ctx *ctx)
 	}
 
 	io_flush_cached_locked_reqs(ctx, cs);
-	io_req_cache_free(&cs->free_list, NULL);
+	io_req_cache_free(&cs->free_list);
 	mutex_unlock(&ctx->uring_lock);
 }
 
-- 
2.32.0

