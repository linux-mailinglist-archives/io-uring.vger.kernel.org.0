Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C76B63E599E
	for <lists+io-uring@lfdr.de>; Tue, 10 Aug 2021 14:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238684AbhHJMG6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 10 Aug 2021 08:06:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240276AbhHJMG5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 10 Aug 2021 08:06:57 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3362C0613D3
        for <io-uring@vger.kernel.org>; Tue, 10 Aug 2021 05:06:35 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id h14so25915653wrx.10
        for <io-uring@vger.kernel.org>; Tue, 10 Aug 2021 05:06:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=gT5RVoiYw4ewKz5MLlH7f5i6GVE6hyuZGO2OfDPTcbU=;
        b=B9molNvOqK8n4b7ghAGwDjhcMoDBklzOpPZgZW/kvLf0gaSY54Bn1OX4lt3ouFsCmY
         4Y0QcJVzC3rOtdwAv5zweIxWhSv6IBOg4pKSkjg++mPHbSW0EDnMig6Lh6tKYA3fUdRN
         59H0uOlPPN+4LZFMlhSpTdNf0vRPnfQ/pB8A7szC35FTNunpQFZKl2lVWoI7XiN//6gt
         YLNuublDERPoVONJLdgQ/7tGY4N4elS2UwyCB89i9JFKDvamgXJxEwT0foxM22StfVKY
         IVH5fkpZI3YMpMvOWdAAfkaJ+zY3W4LWmNANQgK4/vO+Ry7G7MDYZ0O9oxApR5HrBwZ5
         8BmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gT5RVoiYw4ewKz5MLlH7f5i6GVE6hyuZGO2OfDPTcbU=;
        b=pp1HjDxDqc+02oSdix7c6XPa2YafULxiQBhmcEX/Z1Ov5Huxbpl1cOy688p1bY6VPa
         jBQ7qAiJlqc5dxxQ1SVJQ25TNLDOE/VJxtz7uwjems+3X8ojsILzcuIYDNVqd9bVuYW3
         sj9sA3Kn1QgoHkyuIH+/Xxg3oX1RtntURqpCccFHULnnIotpRzkoenPO8kEsAt/7djso
         0NsLW8B5/TFj0PCuJ2LNkvn6rByF60hZbTNZofg4YOgXW39Vu1Ir6VHt0wwi/JTVSGuT
         aIThhJlN2jxxRXmuKyIl3s93jEowr5mPkBoMqgbMkv8IaoH0yPYOIntpuSEsqkdUW79V
         7y/w==
X-Gm-Message-State: AOAM5335IiSjJg2ljdNnrxib7Cd0goupqIsE888bHGlvTvMfXluo7bgS
        Dv3NEbquRbuoVvnC2hr9mcc=
X-Google-Smtp-Source: ABdhPJygsXOuBWMxdkNVLsexvwNa8j8bL3duOEgfI8eGC6p6qqWeHWowWN1onQ28f7v4spCmv753Aw==
X-Received: by 2002:a5d:420c:: with SMTP id n12mr30845627wrq.58.1628597192599;
        Tue, 10 Aug 2021 05:06:32 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.97])
        by smtp.gmail.com with ESMTPSA id d15sm24954362wri.96.2021.08.10.05.06.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Aug 2021 05:06:32 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 3/5] io_uring: protect rsrc dealloc by uring_lock
Date:   Tue, 10 Aug 2021 13:05:52 +0100
Message-Id: <b3cdaeac6b9b20a1b219a75697cd00d5f45dd5bd.1628595748.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1628595748.git.asml.silence@gmail.com>
References: <cover.1628595748.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

As with ->async_data, also protect all rsrc deallocation by uring_lock,
so when we do refcount avoidance they're not removed unexpectedly awhile
someone is still accessing them.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8ca9895535dd..cd3a1058f657 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7664,25 +7664,24 @@ static void __io_rsrc_put_work(struct io_rsrc_node *ref_node)
 	struct io_ring_ctx *ctx = rsrc_data->ctx;
 	struct io_rsrc_put *prsrc, *tmp;
 
+	/* rsrc deallocation must be protected by ->uring_lock */
+	mutex_lock(&ctx->uring_lock);
 	list_for_each_entry_safe(prsrc, tmp, &ref_node->rsrc_list, list) {
 		list_del(&prsrc->list);
 
 		if (prsrc->tag) {
-			bool lock_ring = ctx->flags & IORING_SETUP_IOPOLL;
-
-			io_ring_submit_lock(ctx, lock_ring);
 			spin_lock_irq(&ctx->completion_lock);
 			io_cqring_fill_event(ctx, prsrc->tag, 0, 0);
 			ctx->cq_extra++;
 			io_commit_cqring(ctx);
 			spin_unlock_irq(&ctx->completion_lock);
 			io_cqring_ev_posted(ctx);
-			io_ring_submit_unlock(ctx, lock_ring);
 		}
 
 		rsrc_data->do_put(ctx, prsrc);
 		kfree(prsrc);
 	}
+	mutex_unlock(&ctx->uring_lock);
 
 	io_rsrc_node_destroy(ref_node);
 	if (atomic_dec_and_test(&rsrc_data->refs))
-- 
2.32.0

