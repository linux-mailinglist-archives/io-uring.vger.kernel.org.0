Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B36636C875
	for <lists+io-uring@lfdr.de>; Tue, 27 Apr 2021 17:14:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237164AbhD0POu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 27 Apr 2021 11:14:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235466AbhD0POu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 27 Apr 2021 11:14:50 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF71CC061574
        for <io-uring@vger.kernel.org>; Tue, 27 Apr 2021 08:14:05 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id n2so6696415wrm.0
        for <io-uring@vger.kernel.org>; Tue, 27 Apr 2021 08:14:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=5FXGc7LbcprPPafTigenRVmTagq9hTc7XnYitirT/u4=;
        b=DOAc4VFMNmoxYPYGSN46pPzY7ZripziO5WklJaPUMfe5bCGB9kNYJZ2ttmEFpod1aj
         I0j8JpT4VS0PxZBjQLgk9t0RUHvJ8S0Nzh29Xako+LWM4mSi6s6QgsPppSz2swWPBK2C
         Kgt2PQ4RVNLrALafBevAaViyMS2X82HEsKY2Czp7jA5dSNuWyyMstAXa2P3NJ7NMDMPL
         D9pi9mzB7RnVR/WTEW/wwOYjwU1t2fws2NEiUcqLM1hBhMZtna9J89hWM4082Nd8mOcR
         ouXdy7RhDS2e6EG/A7wv1wgAMQuIqRdj0Wnb6nya9qScUdZqS0IHy019/SwuKVkquMLu
         ux4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=5FXGc7LbcprPPafTigenRVmTagq9hTc7XnYitirT/u4=;
        b=eQ4c79H9EHNCzjIh1B/eWfA1YWqFP+1JuTrks9uxbk8S/10NiS5eGmh8O9fcPOxZer
         2iTpLPeddakklqQTg2hQ3F2O6R2vqC5PQOgtKkRx5RMFsP4xuDpjRnKFMVZ4tUx7O2gN
         rTnkebrbQ/pnqQMZ+nyVz9MXWcoPN+CxGcNKlKHe5TBGbTpkeTCn46D4bDHnKgsXe67a
         Lyi/Ci7HW3vDzFKw6pHv8sfV3S2hZIEnSdszgURTweit5zqrsyhshS1BBenU0vY1cgnh
         TYbR81ORUQzvVov9wdQMhdUdjgmJUefM3DAmIPfVEReZIuHxa8pfAZeJm/A6zImFDk/U
         ZLpQ==
X-Gm-Message-State: AOAM533GBEPlrkvUvJzjNK1030pw/6fsHZpRh+nV4WxktvN70GEYQkyw
        +9DH1rHm6mQmIhjS3HurXZzck9jzdgA=
X-Google-Smtp-Source: ABdhPJwHv3rHd1tnofy+vqWFGebaqGlYQ1whNMevDNF5O9kl4KdStLAAAY+/8aRc3dCeDEUvv3Ctqg==
X-Received: by 2002:adf:8046:: with SMTP id 64mr29159969wrk.176.1619536444549;
        Tue, 27 Apr 2021 08:14:04 -0700 (PDT)
Received: from localhost.localdomain ([148.252.129.131])
        by smtp.gmail.com with ESMTPSA id i2sm1629630wro.0.2021.04.27.08.14.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Apr 2021 08:14:04 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/3] io_uring: fix drain with rsrc CQEs
Date:   Tue, 27 Apr 2021 16:13:51 +0100
Message-Id: <2b32f5f0a40d5928c3466d028f936e167f0654be.1619536280.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1619536280.git.asml.silence@gmail.com>
References: <cover.1619536280.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Resource emitted CQEs are not bound to requests, so fix up counters used
for DRAIN/defer logic.

Fixes: b60c8dce33895 ("io_uring: preparation for rsrc tagging")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 63ff70587d4f..d3b7fe6ccb0e 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7536,6 +7536,7 @@ static void __io_rsrc_put_work(struct io_rsrc_node *ref_node)
 			io_ring_submit_lock(ctx, lock_ring);
 			spin_lock_irqsave(&ctx->completion_lock, flags);
 			io_cqring_fill_event(ctx, prsrc->tag, 0, 0);
+			ctx->cq_extra++;
 			io_commit_cqring(ctx);
 			spin_unlock_irqrestore(&ctx->completion_lock, flags);
 			io_cqring_ev_posted(ctx);
-- 
2.31.1

