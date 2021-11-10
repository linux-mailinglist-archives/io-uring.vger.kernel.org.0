Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBF2144C4A1
	for <lists+io-uring@lfdr.de>; Wed, 10 Nov 2021 16:49:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232312AbhKJPwe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 Nov 2021 10:52:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232318AbhKJPwd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 Nov 2021 10:52:33 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7143EC061766
        for <io-uring@vger.kernel.org>; Wed, 10 Nov 2021 07:49:44 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id 133so2663994wme.0
        for <io-uring@vger.kernel.org>; Wed, 10 Nov 2021 07:49:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p1eSMwG1GvalASQa3wUVmi3xT42dMCeBWIybtyOG254=;
        b=h1Ht2LWtgnkButF9U00mGDQi8PP4MtETAcFIIChP3BnBeaU0y7moNHDqk2T7kJYT13
         X3avjdKCwJYt4yTcdNDloN0P6wgL/thUYvuL/WBuJzDkGFn4ESuIDxAl0vmjoXSSXj9h
         zaVm6Nlrpx3IfmG1SpA50WbD2U+SfcZt/wo7XsbzPnTQZ2/fHRqgKt9AKeJSpTVoL+GJ
         urycd5zELi7dFsAo8t/IeN4Jn6/I2hCrmKAky5aMQ042FNGwM29QMXio2Z80vmAMxfpr
         V8ssilsLC9d9oQkF5VL5LW5jjF03LZ7GJNDgd3SJw+vMSNm49pyZyvED5HOTQM4DE3d6
         6efA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p1eSMwG1GvalASQa3wUVmi3xT42dMCeBWIybtyOG254=;
        b=fUxstPeizNO0+mg5EUCwuTOqBZAj3pYgKWcsFUOMXUrkIrJgE4pObcEbKFf3n10mcE
         FjAjx0ajGL1JXBTEXaQukOayaLJg9OBvBM3Wh8Fg8d58bSv3Cdt036gWoisPn4kCUpUZ
         Rjizrq6T8l6hbYW68i6xiqG3G10dUP6l4ZRE/gFiVBy/ij/glI/pPunJGWNCW4KkECml
         QFzoojgf4RUCF3SSYT85YJyH2WHYfDCHGhEiWdm9V4jn9l7t7mLUQPDvxR5A4Z5fvaae
         jr2nFHUS1p+gfaFFD01Z/FbIuwooeOlAbN1pSuacxmXfqXhV/oHC1mUngFWMXsZVr7LM
         PUjA==
X-Gm-Message-State: AOAM533DU9Um/o6Jw/ySsOIo+qd5DHBgr4TsbYPEfAmfLdbRGVWL5sU9
        +jSjuf97euy00t54Lqtlo5tGzGrMfHU=
X-Google-Smtp-Source: ABdhPJxbfbliv7xT/23JkurONEaEmOcClV3ezGpBEUmB6WxMFhoU6SIsA9sNqHFVSxSYRJ+439/dpA==
X-Received: by 2002:a05:600c:1d9b:: with SMTP id p27mr17569774wms.123.1636559382918;
        Wed, 10 Nov 2021 07:49:42 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.232.183])
        by smtp.gmail.com with ESMTPSA id l15sm108820wme.47.2021.11.10.07.49.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Nov 2021 07:49:42 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH v2 3/4] io_uring: don't spinlock when not posting CQEs
Date:   Wed, 10 Nov 2021 15:49:33 +0000
Message-Id: <8d4b4a08bca022cbe19af00266407116775b3e4d.1636559119.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <cover.1636559119.git.asml.silence@gmail.com>
References: <cover.1636559119.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When no of queued for the batch completion requests need to post an CQE,
see IOSQE_CQE_SKIP_SUCCESS, avoid grabbing ->completion_lock and other
commit/post.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 26 +++++++++++++++++---------
 1 file changed, 17 insertions(+), 9 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 22572cfd6864..0c0ea3bbb50a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -321,6 +321,7 @@ struct io_submit_state {
 
 	bool			plug_started;
 	bool			need_plug;
+	bool			flush_cqes;
 	unsigned short		submit_nr;
 	struct blk_plug		plug;
 };
@@ -1525,8 +1526,11 @@ static void io_prep_async_link(struct io_kiocb *req)
 
 static inline void io_req_add_compl_list(struct io_kiocb *req)
 {
+	struct io_ring_ctx *ctx = req->ctx;
 	struct io_submit_state *state = &req->ctx->submit_state;
 
+	if (!(req->flags & REQ_F_CQE_SKIP))
+		ctx->submit_state.flush_cqes = true;
 	wq_list_add_tail(&req->comp_list, &state->compl_reqs);
 }
 
@@ -2386,18 +2390,22 @@ static void __io_submit_flush_completions(struct io_ring_ctx *ctx)
 	struct io_wq_work_node *node, *prev;
 	struct io_submit_state *state = &ctx->submit_state;
 
-	spin_lock(&ctx->completion_lock);
-	wq_list_for_each(node, prev, &state->compl_reqs) {
-		struct io_kiocb *req = container_of(node, struct io_kiocb,
+	if (state->flush_cqes) {
+		spin_lock(&ctx->completion_lock);
+		wq_list_for_each(node, prev, &state->compl_reqs) {
+			struct io_kiocb *req = container_of(node, struct io_kiocb,
 						    comp_list);
 
-		if (!(req->flags & REQ_F_CQE_SKIP))
-			__io_fill_cqe(ctx, req->user_data, req->result,
-				      req->cflags);
+			if (!(req->flags & REQ_F_CQE_SKIP))
+				__io_fill_cqe(ctx, req->user_data, req->result,
+					      req->cflags);
+		}
+
+		io_commit_cqring(ctx);
+		spin_unlock(&ctx->completion_lock);
+		io_cqring_ev_posted(ctx);
+		state->flush_cqes = false;
 	}
-	io_commit_cqring(ctx);
-	spin_unlock(&ctx->completion_lock);
-	io_cqring_ev_posted(ctx);
 
 	io_free_batch_list(ctx, state->compl_reqs.first);
 	INIT_WQ_LIST(&state->compl_reqs);
-- 
2.33.1

