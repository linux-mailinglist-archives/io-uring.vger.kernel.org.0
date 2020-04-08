Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A8C891A1BB8
	for <lists+io-uring@lfdr.de>; Wed,  8 Apr 2020 08:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726632AbgDHGAC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 8 Apr 2020 02:00:02 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:40982 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726627AbgDHGAB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 8 Apr 2020 02:00:01 -0400
Received: by mail-wr1-f68.google.com with SMTP id h9so6354094wrc.8;
        Tue, 07 Apr 2020 22:59:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=sUUvCvoLtB9BgaxbdgLhXAQ6BgnLG9M3Jlf9kyZEpjI=;
        b=basSX8349jAmNVvct8Z0NUGQkNURfxXaR1mPKb3TobK7R/Dk9VWnP3/NdLOYFD8WuE
         OeKSmx18g5Rj/XIgicLEbQu+qLNh3Z+IdhOKEbYnOMY8T3mbLeeM0ymjgrN7zXtTZD87
         ZG8JgVKK4Nhsp6ijeJZEnNSjiAV3fYYILXU5TTxq+hJ9iJmc9URkpvgdNtNOmwt9WSOz
         e5ULGgGy5jGOQbNHs2M+sYmW62QMKPnU61sKNp2oN4VYmc3JCyW3CjnVplE1m+/X6mGu
         u+XUD3YJk4dJU9uxMBKVS9w0TqXvMq3jlDNhyZqGt3ep5GWA3baMSHoxv2Ut65289KTJ
         nPVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=sUUvCvoLtB9BgaxbdgLhXAQ6BgnLG9M3Jlf9kyZEpjI=;
        b=jYrrqNrzrEJgwbs7BGc1bALyFfOIts67S+J31uHPS+6spN2YYfGrlH6JYoJ4LO+/R9
         UKc1g6BFtZvRCumhTCJllLSTtTjxUALhI1GY2JTkaSsHZdGxfh+H9D9hT88CLR+08ojj
         I7Ko1EVkxxOCIWtvZDXGKplNMznp32c5A5Nn9/sDs2sYD+NXBnaBEFanKegXbNnuabKa
         FyDo8MdhQcFurCcyxL3FUoGlxx4ai+SFd1nJc49ZvdxMqsido4hlDGnt8o8GDeR3lqGI
         6qhlsiW7KWnZ9OADHPfQVqIEZ9fPfwKyTbzhRWaCm66fItdkF8nLhQJwjzEWMgzNwCLp
         GILg==
X-Gm-Message-State: AGi0PuY4tcwdXsQKfATHWb38UySv+b0Sraj1l8S0JaDFVOuD+gfdDnMz
        AIz/d1YvcULO3lS359DRm3c=
X-Google-Smtp-Source: APiQypIlWnbhqK+g7qAB49Q/aDrrqNeRdBW8mI9fjJ325GlY8a0lTy5jkVVLQ22TOXS3PhLnxdmGRA==
X-Received: by 2002:a05:6000:2:: with SMTP id h2mr6332546wrx.112.1586325599141;
        Tue, 07 Apr 2020 22:59:59 -0700 (PDT)
Received: from localhost.localdomain ([109.126.129.227])
        by smtp.gmail.com with ESMTPSA id b15sm33454986wru.70.2020.04.07.22.59.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Apr 2020 22:59:58 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 2/4] io_uring: alloc req only after getting sqe
Date:   Wed,  8 Apr 2020 08:58:44 +0300
Message-Id: <378c7980b103152954e4dfd71a46732b51b84254.1586325467.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1586325467.git.asml.silence@gmail.com>
References: <cover.1586325467.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

As io_get_sqe() split into 2 stage get/consume, get an sqe before
allocating io_kiocb, so no free_req*() for a failure case is needed,
and inline back __io_req_do_free(), which has only 1 user.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 24 +++++++++---------------
 1 file changed, 9 insertions(+), 15 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index fa6b7bb62616..9c3e920e789f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1354,14 +1354,6 @@ static inline void io_put_file(struct io_kiocb *req, struct file *file,
 		fput(file);
 }
 
-static void __io_req_do_free(struct io_kiocb *req)
-{
-	if (likely(!io_is_fallback_req(req)))
-		kmem_cache_free(req_cachep, req);
-	else
-		clear_bit_unlock(0, (unsigned long *) req->ctx->fallback_req);
-}
-
 static void __io_req_aux_free(struct io_kiocb *req)
 {
 	if (req->flags & REQ_F_NEED_CLEANUP)
@@ -1392,7 +1384,10 @@ static void __io_free_req(struct io_kiocb *req)
 	}
 
 	percpu_ref_put(&req->ctx->refs);
-	__io_req_do_free(req);
+	if (likely(!io_is_fallback_req(req)))
+		kmem_cache_free(req_cachep, req);
+	else
+		clear_bit_unlock(0, (unsigned long *) req->ctx->fallback_req);
 }
 
 struct req_batch {
@@ -5841,18 +5836,17 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr,
 		struct io_kiocb *req;
 		int err;
 
+		sqe = io_get_sqe(ctx);
+		if (unlikely(!sqe)) {
+			io_consume_sqe(ctx);
+			break;
+		}
 		req = io_get_req(ctx, statep);
 		if (unlikely(!req)) {
 			if (!submitted)
 				submitted = -EAGAIN;
 			break;
 		}
-		sqe = io_get_sqe(ctx);
-		if (!sqe) {
-			__io_req_do_free(req);
-			io_consume_sqe(ctx);
-			break;
-		}
 
 		/*
 		 * All io need record the previous position, if LINK vs DARIN,
-- 
2.24.0

