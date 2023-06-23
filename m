Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78A4273B60E
	for <lists+io-uring@lfdr.de>; Fri, 23 Jun 2023 13:24:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231329AbjFWLYm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 23 Jun 2023 07:24:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231214AbjFWLYk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 23 Jun 2023 07:24:40 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 524432139
        for <io-uring@vger.kernel.org>; Fri, 23 Jun 2023 04:24:39 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id 4fb4d7f45d1cf-51bde6a8c20so548112a12.0
        for <io-uring@vger.kernel.org>; Fri, 23 Jun 2023 04:24:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687519477; x=1690111477;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MucC/umbtesljG3Fj1Nw4ax1NtgiGvOG45XGet5fe6Q=;
        b=YdNyYymG4yxn2S+DQeZxhE3IvhNLdmRNsYB3+LDRheESKslSk+COgR2Ywt0dHMpIts
         qePUxGfpx5khIjZ4ugnVbGUHOPl9fN4VtDENQdEBoCA909tigRrd4n4Mu1sPLgFcQsgS
         8zVKBKg61EB9ebo4xyeNlA1h7F9J8qC1mZO7SL0j88xEHRWESws0o3uee/x1OoiptKqf
         p1bHlVI+M6/DRUjN+u9ywNoyKdD40TIlnSsxUe4fN209xE0I6OyT2grXSLIpJjU/RHjU
         /GrEhdqGlTMybKWKKvUbgd9HYlKvlevPs9EqixDHM6FfEWNS04pd54xjjVU86ZZqqBBa
         +QTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687519477; x=1690111477;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MucC/umbtesljG3Fj1Nw4ax1NtgiGvOG45XGet5fe6Q=;
        b=RBUTL4uSRxxUMBhB3A42f/4Mf/Jl0WtuisAOJX6Y85IwQk+SedQj9Ja2zDUbaGherQ
         94bC61jNp/F8cPooRnbszxaPwASvwT2ZTyzR5js+v8HtNGYmPZz/0n6/dRV4l98FZbyn
         JEBYa4bEQZryE6EHc6813scl9RDtuxj7kqE4KhUmxnmgOE7cK/7h0x6ILraP7IntZvKt
         +Ri5isyeDR6bvgVkYChlW8c6ap9pyjOJsMDDAUyOdfrn5/fjPFrO19BykQIcCwx+PoyM
         9pe94RLBWSM6IcvYKpXUIMoJVBlHTETQTc6BO6M6ecxWw1hc7ZLXgljwE/wSdmq2fp5u
         oXoA==
X-Gm-Message-State: AC+VfDyBlQ9BcgJYeN69WwJ3I3Ickeg/+n3DkJQCc5WivDMd4EF9Nzb+
        x8ZWnPyPoWE6lXGFw80fCQrvhnC2ZJE=
X-Google-Smtp-Source: ACHHUZ6YiqUywxIAwlPPeglLki1SAIlPwE56wWdjuLiAdKz0CeVIIfsHo1Ih0gKPjt5gY75PKVcmrw==
X-Received: by 2002:a17:907:7f0f:b0:989:1f66:e452 with SMTP id qf15-20020a1709077f0f00b009891f66e452mr9205346ejc.2.1687519477495;
        Fri, 23 Jun 2023 04:24:37 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:7d95])
        by smtp.gmail.com with ESMTPSA id h10-20020a1709067cca00b00969f44bbef3sm5959769ejp.11.2023.06.23.04.24.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Jun 2023 04:24:36 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 02/11] io_uring: remove io_free_req_tw
Date:   Fri, 23 Jun 2023 12:23:22 +0100
Message-Id: <434a2be8f33d474ad888ce1c17fe5ea7bbcb2a55.1687518903.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <cover.1687518903.git.asml.silence@gmail.com>
References: <cover.1687518903.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Request completion is a very hot path in general, but there are 3 places
that can be doing it: io_free_batch_list(), io_req_complete_post() and
io_free_req_tw().

io_free_req_tw() is used rather marginally and we don't care about it.
Killing it can help to clean up and optimise the left two, do that by
replacing it with io_req_task_complete().

There are two things to consider:
1) io_free_req() is called when all refs are put, so we need to reinit
   references. The easiest way to do that is to clear REQ_F_REFCOUNT.
2) We also don't need a cqe from it, so silence it with REQ_F_CQE_SKIP.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 23 +++++------------------
 1 file changed, 5 insertions(+), 18 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index b488a03ba009..43805d2621f5 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1121,26 +1121,13 @@ static inline void io_dismantle_req(struct io_kiocb *req)
 		io_put_file(req->file);
 }
 
-static __cold void io_free_req_tw(struct io_kiocb *req, struct io_tw_state *ts)
-{
-	struct io_ring_ctx *ctx = req->ctx;
-
-	if (req->rsrc_node) {
-		io_tw_lock(ctx, ts);
-		io_put_rsrc_node(ctx, req->rsrc_node);
-	}
-	io_dismantle_req(req);
-	io_put_task_remote(req->task, 1);
-
-	spin_lock(&ctx->completion_lock);
-	wq_list_add_head(&req->comp_list, &ctx->locked_free_list);
-	ctx->locked_free_nr++;
-	spin_unlock(&ctx->completion_lock);
-}
-
 __cold void io_free_req(struct io_kiocb *req)
 {
-	req->io_task_work.func = io_free_req_tw;
+	/* refs were already put, restore them for io_req_task_complete() */
+	req->flags &= ~REQ_F_REFCOUNT;
+	/* we only want to free it, don't post CQEs */
+	req->flags |= REQ_F_CQE_SKIP;
+	req->io_task_work.func = io_req_task_complete;
 	io_req_task_work_add(req);
 }
 
-- 
2.40.0

