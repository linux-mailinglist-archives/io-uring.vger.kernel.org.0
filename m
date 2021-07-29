Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9350F3DA726
	for <lists+io-uring@lfdr.de>; Thu, 29 Jul 2021 17:06:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237763AbhG2PGt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Jul 2021 11:06:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237799AbhG2PGs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Jul 2021 11:06:48 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38379C061765
        for <io-uring@vger.kernel.org>; Thu, 29 Jul 2021 08:06:44 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id b7so7357762wri.8
        for <io-uring@vger.kernel.org>; Thu, 29 Jul 2021 08:06:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=zswthz0tVklOufrTNO64MtwjVS+wd+RLP6DophstSOw=;
        b=au/mtPFuzl0939SMzhUVwvbM3udR0HElbke2+rPYdeB2etOnD0EV7nFuux4BnsUA/a
         P+8SWeg47h//ehR5VTfKdRkS2kvkS0eg3AieLeI5gauXRGapFuLeCA2vYS0It0PC3s1m
         3xqWMgE2wya6hxy9AQNlNSaLYeeuMfnTwKBnM6YA+PXlWLQ5xJdqrLWs60OjQi4wQkkg
         NKwoxHPwWlS3V1Jus+lQi3XFDkEYzQ70rdUOxHvANMbrEWo9ATCLCwFGsAMx3YGjw05N
         DaEc1v8pYtm4lW1VAnnyqbO1Wt1oMRACEi4kD1kCYB5wNqetCeIdM9fUYJ/2hYOEMXxq
         r52Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zswthz0tVklOufrTNO64MtwjVS+wd+RLP6DophstSOw=;
        b=NKT3x6vW8eZ82/YZ4+LEDuPhlPutj69vpKNr7oiESdHVAVVX40XKWIuz+ymoOK+lFs
         HK3xt0gvNwoNpk+Tc54sAMikhs86BbtyUAWmERPyEyCyU+F48fDPVcDdxnO+z5WtdmRu
         RX6zg908a3i4hY/jSfMAyRiwuy9ATRlTdTaYt7pqS5Q8lr0X+7Uhb5qnV9mLWHb/Cnrw
         84Bsaxc+QJKyKh3GVC1KGFDUxiPI/fsxU1h98NkJiepaD1u/dq0cPCa2N1+0l4ECxABr
         S+AWA3MdAsX/nrhGsq8gOfXawY9SUTb4+Eqj96rYMfezj+qLBhdudOtKsgkN7KdJGw+P
         55bg==
X-Gm-Message-State: AOAM532uN+AdMdjGsY0g81VTRezNs+9nZzOnmNOY4po5q6/5nZ9FsGxo
        FCKQ7FcJi7s5nFWxWMHSCq8=
X-Google-Smtp-Source: ABdhPJxXRLNuTZUjBQCOSDymZmXqh5pOgU4xYTtW44t4nmx8Xh9UXAzwmCQhbvosAtRtOSvfTvZIwQ==
X-Received: by 2002:a5d:488f:: with SMTP id g15mr5636779wrq.98.1627571202883;
        Thu, 29 Jul 2021 08:06:42 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.141])
        by smtp.gmail.com with ESMTPSA id e6sm4764577wrg.18.2021.07.29.08.06.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 08:06:42 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 23/23] io_uring: inline io_poll_remove_waitqs
Date:   Thu, 29 Jul 2021 16:05:50 +0100
Message-Id: <6c659d864f0fbd2e1bb93e5da645f35e6dad90fe.1627570633.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1627570633.git.asml.silence@gmail.com>
References: <cover.1627570633.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Inline io_poll_remove_waitqs() into its only user and clean it up.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 23 ++++++-----------------
 1 file changed, 6 insertions(+), 17 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e3fb15cc113c..32989a0a7460 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1071,7 +1071,6 @@ static void io_rsrc_put_work(struct work_struct *work);
 
 static void io_req_task_queue(struct io_kiocb *req);
 static void io_submit_flush_completions(struct io_ring_ctx *ctx);
-static bool io_poll_remove_waitqs(struct io_kiocb *req);
 static int io_req_prep_async(struct io_kiocb *req);
 
 static struct kmem_cache *req_cachep;
@@ -5251,34 +5250,24 @@ static bool __io_poll_remove_one(struct io_kiocb *req,
 	return do_complete;
 }
 
-static bool io_poll_remove_waitqs(struct io_kiocb *req)
+static bool io_poll_remove_one(struct io_kiocb *req)
 	__must_hold(&req->ctx->completion_lock)
 {
+	int refs;
 	bool do_complete;
 
 	io_poll_remove_double(req);
 	do_complete = __io_poll_remove_one(req, io_poll_get_single(req), true);
 
-	if (req->opcode != IORING_OP_POLL_ADD && do_complete) {
-		/* non-poll requests have submit ref still */
-		req_ref_put(req);
-	}
-	return do_complete;
-}
-
-static bool io_poll_remove_one(struct io_kiocb *req)
-	__must_hold(&req->ctx->completion_lock)
-{
-	bool do_complete;
-
-	do_complete = io_poll_remove_waitqs(req);
 	if (do_complete) {
 		io_cqring_fill_event(req->ctx, req->user_data, -ECANCELED, 0);
 		io_commit_cqring(req->ctx);
 		req_set_fail(req);
-		io_put_req_deferred(req, 1);
-	}
 
+		/* non-poll requests have submit ref still */
+		refs = 1 + (req->opcode != IORING_OP_POLL_ADD);
+		io_put_req_deferred(req, refs);
+	}
 	return do_complete;
 }
 
-- 
2.32.0

