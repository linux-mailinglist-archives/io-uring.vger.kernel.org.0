Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 37118635BDC
	for <lists+io-uring@lfdr.de>; Wed, 23 Nov 2022 12:35:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237271AbiKWLfL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Nov 2022 06:35:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237278AbiKWLfF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Nov 2022 06:35:05 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1B9010EA1A
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 03:35:03 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id v124-20020a1cac82000000b003cf7a4ea2caso1200862wme.5
        for <io-uring@vger.kernel.org>; Wed, 23 Nov 2022 03:35:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A0DW1JSauK3bY460xsnmlLPiYfNI+QTI3O3eNQDmUns=;
        b=YtnIqCvh/xgvy2X9x1j79mdcWmrmExXdVsfIXSyqnntQIF//PNQYWkV51zvtgmJb6W
         KgWaD3VvK55Qf5pRiephud5trgZiSVOvh/1ApBsOKHd/HVJNUepBSnUKrVsY+6+M40mc
         XB4+8OSY5IXv2mqqNOl98xxJWVqwgkCLyuTkc76yh6CdId934tCte8HqpL7JL05cHKVg
         fUJspkR3FoAeHwzZqrl/MlqHy6XjsvglQKY7SaPM3QM15FVmgYzs41LknLka+1bBum0o
         LvGAhdCITvWcTVAmlUjxpv6BgMhQowb/W5IIxFq3QtfGesQyOi8cJSZOVkrBXbg178Jw
         A4WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A0DW1JSauK3bY460xsnmlLPiYfNI+QTI3O3eNQDmUns=;
        b=nxw4dyWGDXwFJ6uum2wWqeLgxpvlHXnP9cDydbkD1jDDFoQEChXECJvMzd/8Pui/lm
         pmWicwheZaDOAtC2WS4bVj6tzoYOkHLwclM9gX+QhXYva13bLMhvOMZ+3xHtDqD28uHg
         A/u1Rj8b9qFaTqZjk5lNhpey3PHk4FMA1pTu+dnKceydrj90gt269Ebi79X+VKc71vHr
         yRVoSWfSr55iC+W8nSL63BaDGvIWawEZCFuRxefaPFEuhkBFwFuuYCojbh5+HAQ9P49X
         gubkUavU0yChU9DQoUKWUJHSxRJTuMLXlnq6Gx3cBAld44JJIdMaMOivapU7kVeac7KH
         /5dQ==
X-Gm-Message-State: ANoB5pn29pHHiAcAPNRhD8UEJLU9DocmfH4u2tUo7W81f8ZO8846ODUA
        98B6F0r1ngY2RoTVAv5RYT6h7W+q4lg=
X-Google-Smtp-Source: AA0mqf7SgqYT6X2V+myj6s5fN/ozUC+QsWKUMSOVgFCHaOKBYnxkgs65F+21dXlUHtzMhQl8oBwXew==
X-Received: by 2002:a05:600c:4fcd:b0:3cf:a11a:c775 with SMTP id o13-20020a05600c4fcd00b003cfa11ac775mr9466668wmq.153.1669203302272;
        Wed, 23 Nov 2022 03:35:02 -0800 (PST)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:e1b])
        by smtp.gmail.com with ESMTPSA id g9-20020a05600c4ec900b003cfd58409desm2262064wmq.13.2022.11.23.03.35.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Nov 2022 03:35:01 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 1/7] io_uring: add completion locking for iopoll
Date:   Wed, 23 Nov 2022 11:33:36 +0000
Message-Id: <84d86b5c117feda075471c5c9e65208e0dccf5d0.1669203009.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1669203009.git.asml.silence@gmail.com>
References: <cover.1669203009.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

There are pieces of code that may allow iopoll to race filling cqes,
temporarily add spinlocking around posting events.

Cc: stable@vger.kernel.org
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/rw.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index 1ce065709724..61c326831949 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -1049,6 +1049,7 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 	else if (!pos)
 		return 0;
 
+	spin_lock(&ctx->completion_lock);
 	prev = start;
 	wq_list_for_each_resume(pos, prev) {
 		struct io_kiocb *req = container_of(pos, struct io_kiocb, comp_list);
@@ -1063,11 +1064,11 @@ int io_do_iopoll(struct io_ring_ctx *ctx, bool force_nonspin)
 		req->cqe.flags = io_put_kbuf(req, 0);
 		__io_fill_cqe_req(req->ctx, req);
 	}
-
+	io_commit_cqring(ctx);
+	spin_unlock(&ctx->completion_lock);
 	if (unlikely(!nr_events))
 		return 0;
 
-	io_commit_cqring(ctx);
 	io_cqring_ev_posted_iopoll(ctx);
 	pos = start ? start->next : ctx->iopoll_list.first;
 	wq_list_cut(&ctx->iopoll_list, prev, start);
-- 
2.38.1

