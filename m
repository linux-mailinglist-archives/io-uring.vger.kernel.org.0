Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C241F20C74F
	for <lists+io-uring@lfdr.de>; Sun, 28 Jun 2020 11:54:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbgF1JyX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 28 Jun 2020 05:54:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725999AbgF1JyX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 28 Jun 2020 05:54:23 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEE77C061794
        for <io-uring@vger.kernel.org>; Sun, 28 Jun 2020 02:54:22 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id d16so3554529edz.12
        for <io-uring@vger.kernel.org>; Sun, 28 Jun 2020 02:54:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=0eyEP70nF6qRPt7eHrpgrTsqWsM5x6Hr/VIvFYVwMFs=;
        b=M2SmOf9oPS3KJmfS6MCLhXdPHgWP8m0bLoCtivYvmbNhLso9ZvcJ4RrypiRzOTEz9c
         6HUASm9U576wtIWSlu9JBmr4MPo54SwXaspc0eOKsBsaQvElmsu8OxSDVCRswnx7Q0cO
         UAasZAVfEbnRLxRL2n3490e1u/QKxp0BwfTvha/I4i5oPHXzjiRlxiLcqeri/quqaz4h
         hOB2GudtBrpQjhAY3uhoCpGS9ZFS4HGhLU3zofEQo+nk+sFIrvyzQroFdQ/3D34UZcZg
         z2fWNnvfQEQIUJBwZSUB6UVNmiUd8alwC+vp+oFTc0ElBIq9vp/zzLpSSxNlR6ORp1+b
         +FbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=0eyEP70nF6qRPt7eHrpgrTsqWsM5x6Hr/VIvFYVwMFs=;
        b=a4gTgiTz12ihsQkVOrX8fI7VAQJVLNa+ww/V8wWTLhXWXRQqaPrTCKylAU2INPq5M4
         NkYOZ0NTso7hsjIlQF0Wh5pJiKy7jbtLZcTJbqqMtwhpcmFYbWnpx6F6wHufy0AcXgyY
         pOXBx1fZmyd7aTn+Y1HSth7aP+tpCPf9222k3nODR/UYPnpTciwpDoR0Or0elwnbqEom
         s87378oAPL3Da8tnJqnWX8urj7nmGr025l6dEjEqh1rsEHLta4jPnI6NX9htVrIqBDq5
         MDYU1MxEjAHm9Q7YHIU16OhhXuzbR3CvF2iviC39hFxM5j7iLzaI7w2MVuOi3y9udluU
         uVuw==
X-Gm-Message-State: AOAM5300kfbBhRlcLJCEpDqWpVGI69A2rF4IjGZGHSMgdRD6wSf+fXRf
        7hrZjGuO72t77h3gbQimKoFLkCpQ
X-Google-Smtp-Source: ABdhPJzzlmlWGsxWvCGRuLxjHbRYBFofjR2IPhwn18KLBEuo17k9ctrsrWV0ZM3uBOoB+Etaa455aQ==
X-Received: by 2002:a50:8adb:: with SMTP id k27mr11751101edk.267.1593338061663;
        Sun, 28 Jun 2020 02:54:21 -0700 (PDT)
Received: from localhost.localdomain ([82.209.196.123])
        by smtp.gmail.com with ESMTPSA id w15sm10089490ejk.103.2020.06.28.02.54.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Jun 2020 02:54:21 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 03/10] io_uring: dismantle req early and remove need_iter
Date:   Sun, 28 Jun 2020 12:52:31 +0300
Message-Id: <4f56207c1ac5ae6a26f7bb0e4d45fd197d9623de.1593337097.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1593337097.git.asml.silence@gmail.com>
References: <cover.1593337097.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Every request in io_req_multi_free() is having ->file, instead of
pointlessly defering and counting reqs with file, dismantle it
on place and save for batch dealloc.

It also saves us from potentially skipping io_cleanup_req(), put_task(),
etc. Never happens though, becacuse ->file is always there.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 28a66e85ef9f..f3c6506e9df1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1540,22 +1540,16 @@ static void __io_free_req(struct io_kiocb *req)
 struct req_batch {
 	void *reqs[IO_IOPOLL_BATCH];
 	int to_free;
-	int need_iter;
 };
 
 static void io_free_req_many(struct io_ring_ctx *ctx, struct req_batch *rb)
 {
 	if (!rb->to_free)
 		return;
-	if (rb->need_iter) {
-		int i;
 
-		for (i = 0; i < rb->to_free; i++)
-			io_dismantle_req(rb->reqs[i]);
-	}
 	kmem_cache_free_bulk(req_cachep, rb->to_free, rb->reqs);
 	percpu_ref_put_many(&ctx->refs, rb->to_free);
-	rb->to_free = rb->need_iter = 0;
+	rb->to_free = 0;
 }
 
 static bool io_link_cancel_timeout(struct io_kiocb *req)
@@ -1846,9 +1840,7 @@ static inline bool io_req_multi_free(struct req_batch *rb, struct io_kiocb *req)
 	if ((req->flags & REQ_F_LINK_HEAD) || io_is_fallback_req(req))
 		return false;
 
-	if (req->file || req->io)
-		rb->need_iter++;
-
+	io_dismantle_req(req);
 	rb->reqs[rb->to_free++] = req;
 	if (unlikely(rb->to_free == ARRAY_SIZE(rb->reqs)))
 		io_free_req_many(req->ctx, rb);
@@ -1900,7 +1892,7 @@ static void io_iopoll_complete(struct io_ring_ctx *ctx, unsigned int *nr_events,
 	/* order with ->result store in io_complete_rw_iopoll() */
 	smp_rmb();
 
-	rb.to_free = rb.need_iter = 0;
+	rb.to_free = 0;
 	while (!list_empty(done)) {
 		int cflags = 0;
 
-- 
2.24.0

