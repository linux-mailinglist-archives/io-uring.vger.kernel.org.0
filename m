Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA2C93ABA5B
	for <lists+io-uring@lfdr.de>; Thu, 17 Jun 2021 19:14:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbhFQRQo (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Jun 2021 13:16:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231736AbhFQRQn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Jun 2021 13:16:43 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C28FEC06175F
        for <io-uring@vger.kernel.org>; Thu, 17 Jun 2021 10:14:35 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id l7-20020a05600c1d07b02901b0e2ebd6deso4125539wms.1
        for <io-uring@vger.kernel.org>; Thu, 17 Jun 2021 10:14:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=+s49K9QJpp1NAnHtvJ/kuhdrGYQ2UDJOGGRoq5Eg0ZI=;
        b=jxjA8yYGnf0/XmjCtDGNJowk11INsFdKJo5cQDmDfT22vdg3hCSL83rw0BDNGglEmw
         l4z15/pYQwDN3itwUkZqnEiOeOHNCfZh3AOnIHYHSVmbDnQXUGAgGeDsOJpafIdtY/qt
         qefpCpQVlILbHh06IoxhNsEs1xLyPIorvJ5qZub6qDktdOnin/6ued/VaLcK5FmjZh1s
         yDPLuiMeWumYKZKT0JShpRnUEw3itkFd0D18iwsFMXD2Jj2WAD63sIZR3yG8sQZPoen/
         DtBC1mySSAxC6ceue4a5Kh8v7MWSet+QW/9pWzwVexr+1rkRhrHFuNSWdKnKxar/5COf
         G+Sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+s49K9QJpp1NAnHtvJ/kuhdrGYQ2UDJOGGRoq5Eg0ZI=;
        b=efhPGWUR4CCgumCh4bB1l5NRY/lq4PZ2yoUV49+DsQ56gO7wxdqzqMVAcyqyxNN+IW
         HHvlsA/9cZUkxqS2Li/k7sjj54cLUD5McS45lhATiHa2t8wPnMqOZpGLBdudE4uiDR8L
         mtO7PfMabR1KpeB7TrfLyaSim5mecPI8npUbzcSyqnNnmoptlyas8wl1alRKvGgtBtLV
         199Xu0Omat47bugTOgJLtUdOlx4r6HbfNFn89Ndc8CvLjbp8505csIMwZderIKIKyH2c
         R9Z7DnfV32DWMnDDXEmBdBMa/LjBJHSMZNsuRBCYACxKGSOl14EDUB4QCOCpn88gOmcf
         RXNw==
X-Gm-Message-State: AOAM531j+mdLv/zbh/6z8lgVBOW9pkjCNLvtKfpDV7tzOQPiff2kFrkI
        NnhseIFTjASI4QQj37g32ER1/ZVpkRG1PA==
X-Google-Smtp-Source: ABdhPJwQ+k4bY7YTvcJil1RJzZthQBh7lE+Lhhe9Deb3nP02t17fFaUgxSYHkj22OmtdUypYiMNOTQ==
X-Received: by 2002:a05:600c:4106:: with SMTP id j6mr6371343wmi.76.1623950074451;
        Thu, 17 Jun 2021 10:14:34 -0700 (PDT)
Received: from localhost.localdomain ([148.252.132.93])
        by smtp.gmail.com with ESMTPSA id g17sm6208033wrp.61.2021.06.17.10.14.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Jun 2021 10:14:34 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 02/12] io_uring: refactor io_submit_flush_completions()
Date:   Thu, 17 Jun 2021 18:14:00 +0100
Message-Id: <44d6ca57003a82484338e95197024dbd65a1b376.1623949695.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1623949695.git.asml.silence@gmail.com>
References: <cover.1623949695.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

struct io_comp_state is always contained in struct io_ring_ctx, don't
pass them into io_submit_flush_completions() separately, it makes the
interface cleaner and simplifies it for the compiler.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d916eb2cef09..5935df64b153 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1059,8 +1059,7 @@ static void __io_queue_sqe(struct io_kiocb *req);
 static void io_rsrc_put_work(struct work_struct *work);
 
 static void io_req_task_queue(struct io_kiocb *req);
-static void io_submit_flush_completions(struct io_comp_state *cs,
-					struct io_ring_ctx *ctx);
+static void io_submit_flush_completions(struct io_ring_ctx *ctx);
 static bool io_poll_remove_waitqs(struct io_kiocb *req);
 static int io_req_prep_async(struct io_kiocb *req);
 
@@ -1879,7 +1878,7 @@ static void ctx_flush_and_put(struct io_ring_ctx *ctx)
 		return;
 	if (ctx->submit_state.comp.nr) {
 		mutex_lock(&ctx->uring_lock);
-		io_submit_flush_completions(&ctx->submit_state.comp, ctx);
+		io_submit_flush_completions(ctx);
 		mutex_unlock(&ctx->uring_lock);
 	}
 	percpu_ref_put(&ctx->refs);
@@ -2127,9 +2126,9 @@ static void io_req_free_batch(struct req_batch *rb, struct io_kiocb *req,
 		list_add(&req->compl.list, &state->comp.free_list);
 }
 
-static void io_submit_flush_completions(struct io_comp_state *cs,
-					struct io_ring_ctx *ctx)
+static void io_submit_flush_completions(struct io_ring_ctx *ctx)
 {
+	struct io_comp_state *cs = &ctx->submit_state.comp;
 	int i, nr = cs->nr;
 	struct io_kiocb *req;
 	struct req_batch rb;
@@ -6451,7 +6450,7 @@ static void __io_queue_sqe(struct io_kiocb *req)
 
 			cs->reqs[cs->nr++] = req;
 			if (cs->nr == ARRAY_SIZE(cs->reqs))
-				io_submit_flush_completions(cs, ctx);
+				io_submit_flush_completions(ctx);
 		} else {
 			io_put_req(req);
 		}
@@ -6651,7 +6650,7 @@ static void io_submit_state_end(struct io_submit_state *state,
 	if (state->link.head)
 		io_queue_sqe(state->link.head);
 	if (state->comp.nr)
-		io_submit_flush_completions(&state->comp, ctx);
+		io_submit_flush_completions(ctx);
 	if (state->plug_started)
 		blk_finish_plug(&state->plug);
 	io_state_file_put(state);
-- 
2.31.1

