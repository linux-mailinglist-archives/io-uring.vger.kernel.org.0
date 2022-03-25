Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85BA04E73E3
	for <lists+io-uring@lfdr.de>; Fri, 25 Mar 2022 14:01:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359206AbiCYND0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Mar 2022 09:03:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359211AbiCYND0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Mar 2022 09:03:26 -0400
Received: from mail-ed1-x533.google.com (mail-ed1-x533.google.com [IPv6:2a00:1450:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 372AFCC516
        for <io-uring@vger.kernel.org>; Fri, 25 Mar 2022 06:01:52 -0700 (PDT)
Received: by mail-ed1-x533.google.com with SMTP id z92so9125583ede.13
        for <io-uring@vger.kernel.org>; Fri, 25 Mar 2022 06:01:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=NMvDYL1/jlGMcaUeoDFqsnYI1ccA8jjn6IBSyFZSmKk=;
        b=mX4n/JSxqBn91qS+k1ytFx5kK5qz1arYyOONI7DWf1+nuK4Herc1HAQVI3QhPCEZ8e
         Tt0gg1VRDxpPJPyxeZWB2hUYS+E8CgX0Un256WbuDZoOKTmGoiqjrWxSKx6MNSBcooRQ
         uHQJSjaCYjd1dHSxwvXlKzpQ4E2lb92tdesaSG/JFjHeL7NwWccwvCLMMysGiUYUiZ+p
         AdPrGz+Ri3VhQguTA35KDUfOBGeQWGlou6oEzQUg8czUzHawGMEFOgT7LWku++15hFrr
         YRvAUXjKMYM3YG3aLwFYCZ5TcmSY+wfQPDom4zrPWn0g+U/8RG4T76hy1HtrnK3jAGj9
         rhzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=NMvDYL1/jlGMcaUeoDFqsnYI1ccA8jjn6IBSyFZSmKk=;
        b=DtHWcG2wxynWRASNzHO0aMdHIUM0GDhK6bYefKeY7klyEDeacpyqYJQgsOerCSqSmH
         9WT8Kz9MxqYVHywXfkeUyX79AeFPHHb7LWJpqcjvpVwpYDpleZsaAsV16mqqIrvcXi9i
         XJU99XQJzeTfPUJQU/FMLMopGcaNiZMLT4PaqDUkznMih0o6KORxPdp8ih8b7a1zQx8o
         Y2ra/J17puLPQqHhxrWpRxIuA1DVs+DrYEZKNZrgv9xlvYLJq7EQNPkB+Q7vJ/c5Arsu
         B5cfwX9FeoMSB2JTxcKaRQ6zV3NEMoJrD84/uR/zn473DcuspmuxDtBJ2s0DMmzSSJBg
         XNog==
X-Gm-Message-State: AOAM532fDn3yL8WwLZR5xZGI3/XG+IZf7LvIOpBrRntjqUUIkh7H+xg4
        3zJm8tq4Be1E/NneD0lLbkmdVfyS7cyYgA==
X-Google-Smtp-Source: ABdhPJyj1uqArMBo1CEqwE67qEWa1hOdWUtp8+d1c4f0ok4mcOZuBB/0ToGY5qTTF4iS9TYBQyMDew==
X-Received: by 2002:a05:6402:1941:b0:413:2555:53e3 with SMTP id f1-20020a056402194100b00413255553e3mr13078831edz.164.1648213309693;
        Fri, 25 Mar 2022 06:01:49 -0700 (PDT)
Received: from 127.0.0.1localhost ([78.179.227.119])
        by smtp.gmail.com with ESMTPSA id ky5-20020a170907778500b006d1b2dd8d4csm2326222ejc.99.2022.03.25.06.01.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Mar 2022 06:01:49 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 2/2] io_uring: fix put_kbuf without proper locking
Date:   Fri, 25 Mar 2022 13:00:43 +0000
Message-Id: <743e2130b73ec6d48c4c5dd15db896c433431e6d.1648212967.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1648212967.git.asml.silence@gmail.com>
References: <cover.1648212967.git.asml.silence@gmail.com>
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

io_put_kbuf_comp() should only be called while holding
->completion_lock, however there is no such assumption in io_clean_op()
and thus it can corrupt ->io_buffer_comp. Take the lock there, and
workaround the only user of io_clean_op() calling it with locks. Not
the prettiest solution, but it's easier to refactor it for-next.

Fixes: cc3cec8367cba ("io_uring: speedup provided buffer handling")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c83a650ca5fa..e5769287b3b8 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1356,6 +1356,8 @@ static unsigned int __io_put_kbuf(struct io_kiocb *req, struct list_head *list)
 
 static inline unsigned int io_put_kbuf_comp(struct io_kiocb *req)
 {
+	lockdep_assert_held(&req->ctx->completion_lock);
+
 	if (likely(!(req->flags & REQ_F_BUFFER_SELECTED)))
 		return 0;
 	return __io_put_kbuf(req, &req->ctx->io_buffers_comp);
@@ -2140,6 +2142,12 @@ static void __io_req_complete_post(struct io_kiocb *req, s32 res,
 			}
 		}
 		io_req_put_rsrc(req, ctx);
+		/*
+		 * Selected buffer deallocation in io_clean_op() assumes that
+		 * we don't hold ->completion_lock. Clean them here to avoid
+		 * deadlocks.
+		 */
+		io_put_kbuf_comp(req);
 		io_dismantle_req(req);
 		io_put_task(req->task, 1);
 		wq_list_add_head(&req->comp_list, &ctx->locked_free_list);
@@ -7115,8 +7123,11 @@ static __cold void io_drain_req(struct io_kiocb *req)
 
 static void io_clean_op(struct io_kiocb *req)
 {
-	if (req->flags & REQ_F_BUFFER_SELECTED)
+	if (req->flags & REQ_F_BUFFER_SELECTED) {
+		spin_lock(&req->ctx->completion_lock);
 		io_put_kbuf_comp(req);
+		spin_unlock(&req->ctx->completion_lock);
+	}
 
 	if (req->flags & REQ_F_NEED_CLEANUP) {
 		switch (req->opcode) {
-- 
2.35.1

