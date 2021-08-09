Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8ADE53E4547
	for <lists+io-uring@lfdr.de>; Mon,  9 Aug 2021 14:05:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235356AbhHIMFu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 9 Aug 2021 08:05:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235329AbhHIMFr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 9 Aug 2021 08:05:47 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0145C06179A
        for <io-uring@vger.kernel.org>; Mon,  9 Aug 2021 05:05:25 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id q11-20020a7bce8b0000b02902e6880d0accso2586580wmj.0
        for <io-uring@vger.kernel.org>; Mon, 09 Aug 2021 05:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=ZgadrtinuTz61Cq+jiwY0boIBsrpp3K2bUODFG5B4I4=;
        b=EzDoXwc18Whjq/uyIs3j17iAsYEuSSNVuhRIAuqE36XyDIYmyiQsU79P6JuiWoZIlP
         d32sRMO8ApR9vqVGdMUAUhMo6L9W8nqIHNk6jz0FRyc6ZqXVlZZX+VaMD2Q5rkT16iw0
         9WJ0nQy1HRUb+DT1krpC/VFGuw56vnaloCYY0lnUG3TYNmHu9ZXHioQLpXPehy43n8Ls
         XzxPdxQmEFwqPcTpiGL9jAh/BkRFvuC10t8LAdDUjiG2nzthVFQMY+rXqlnomKR9CnhF
         rbDIla8b6y3JhZ375UaGznTdpb5DFXvZtBVJPpobSZecL/lhQ/vjr74XFuiTVot23q/B
         YypA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZgadrtinuTz61Cq+jiwY0boIBsrpp3K2bUODFG5B4I4=;
        b=FL+rryGRNRDw5HZOnudRl5jHFIapwEkH3nj0Z4ivJGqbkob3m+1v99wtkbDFCMOk7x
         /o9X78wrcXexI7+FYnIKKP8mOvRruwFf6rt8NQw5RZg2lHGjeHec7uG9qdjOVu35W0jT
         PORTpG1oXypN9Y0hNtT9Vv6HYmmE4E3RL6t5gF8SU9fuJHN9Rh3iKhkJMnDX4cwRLNBE
         JwimBmMxnr+bhNvTr+Vw21f9mh8QEH3g6fjlr/ZlLv9eITA7sgXCh7bk0qhziHFuV3Se
         KaPc8Ezg33oTuAJAL79TtN2r9CMyk92OeopR9HGWFkBkm9I5VyB4Ur3Wis8hPnABiB26
         KtAw==
X-Gm-Message-State: AOAM533FqjInFVnZU3Fnkiui+hKJ6LVMP//ihttBoGZwBfkJZHB4MnlF
        ex8kIvAU0mvuze1HiX5GuPc=
X-Google-Smtp-Source: ABdhPJxJi0auAphfPAwUZ1vUrCaAeJLdk+niBQ3JdNoYNS1KVDxqYhRPfiJGr0ox/XHUDXLgT7YjMw==
X-Received: by 2002:a1c:1bcd:: with SMTP id b196mr16225739wmb.160.1628510724677;
        Mon, 09 Aug 2021 05:05:24 -0700 (PDT)
Received: from localhost.localdomain ([85.255.236.119])
        by smtp.gmail.com with ESMTPSA id g35sm4757062wmp.9.2021.08.09.05.05.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Aug 2021 05:05:24 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 23/28] io_uring: cache __io_free_req()'d requests
Date:   Mon,  9 Aug 2021 13:04:23 +0100
Message-Id: <39d226beb88ec68aef4d639847272aafd6f5ed85.1628471125.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628471125.git.asml.silence@gmail.com>
References: <cover.1628471125.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Don't kfree requests in __io_free_req() but put them back into the
internal request cache. That makes allocations more sustainable and will
be used for refcounting optimisations.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8b07bdb11430..ec1cab2b9a91 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1835,11 +1835,16 @@ static void io_dismantle_req(struct io_kiocb *req)
 static void __io_free_req(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
+	unsigned long flags;
 
 	io_dismantle_req(req);
 	io_put_task(req->task, 1);
 
-	kmem_cache_free(req_cachep, req);
+	spin_lock_irqsave(&ctx->completion_lock, flags);
+	list_add(&req->compl.list, &ctx->locked_free_list);
+	ctx->locked_free_nr++;
+	spin_unlock_irqrestore(&ctx->completion_lock, flags);
+
 	percpu_ref_put(&ctx->refs);
 }
 
-- 
2.32.0

