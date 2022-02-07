Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B17F44AB925
	for <lists+io-uring@lfdr.de>; Mon,  7 Feb 2022 11:57:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236908AbiBGK5T (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Feb 2022 05:57:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352158AbiBGKuq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Feb 2022 05:50:46 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5254BC0401C1
        for <io-uring@vger.kernel.org>; Mon,  7 Feb 2022 02:50:45 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id e3so9988701wra.0
        for <io-uring@vger.kernel.org>; Mon, 07 Feb 2022 02:50:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EZDSS2MYdieKNY+ptNKFPV1o4mbS/p6IjuUtTxEmOkI=;
        b=duNxmxAdk7clYt7ndWPXMcPdSolXHBq4k1vpVSHdqeR3Y4OWFGyd1weIqSmOvwZb6S
         Spl+lEN4s/4eqR+CV2VBUi31PwqNpLhu1spSm9qyFUZFnw96KF9rCAhnyUvDBEIf11z1
         PSnr7JICxX6dz2N2SJiFNsqmL9hadf/eri3EZFXn1w2FkBwZdwQP/eyRjWS5wMaFGvdn
         ZF0lDFr030L6E1u3lhpYKRKDd4tReFjacJB9q+g0p4uS1S2/apocHH72RqIDegc24uK8
         2jrlj+s/8rx96MGL4wDFQmWS8/lusi4cE2hPx9vSkIyDaelQhP2a0llYAaxuDq8JyPit
         J5CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EZDSS2MYdieKNY+ptNKFPV1o4mbS/p6IjuUtTxEmOkI=;
        b=Mqeh22Meplf05U4vxvvtPpI7zQMod1/MsF0uR5LrSvaxfAuB9rLFkGktvzG3/4FLoi
         C9zxWflMtx5BgIUUL7lp0SI1IFBCKzLj0mfna6t+3S64Pp0XQbZVNGbRcw75yeBXT6tq
         z8sSebuAGc483/uUemYNjHvlJtqBmu8u9Ojoy2H7pdMXmVtJQ7ylk/Pn4KfJyzdxVY3T
         vBnId9dVzR9Tirw5obNDG+Kr/4tsZjSqo5lTqNTnIa+p7ShOc5WPrah2ahji/58ADQyC
         GyKwnOLoq7tDDhVQghFjHiMU9maEcAteoKU0YUCXLtdRNXaXr2nEAq+rj7dQ2iewIkUv
         VY3Q==
X-Gm-Message-State: AOAM533wQL0uspgtd8L72Pq5ZOK/NLUGYFsLp/TlTLYE50dLgfo6ObrV
        oH8Hb4BrCYKDt4YcRW9mfJRKWfGDcV5LMw==
X-Google-Smtp-Source: ABdhPJxLDom1n0BQAQA7DNHaMf3QjJwyZDXY+ENwGqJe57G5ZW9q1SeMh9v9S8yRdiIbSkPeP/Mi6A==
X-Received: by 2002:a5d:6486:: with SMTP id o6mr8980127wri.454.1644231043764;
        Mon, 07 Feb 2022 02:50:43 -0800 (PST)
Received: from usaari01.cust.communityfibre.co.uk ([2a02:6b6d:f804:0:9277:27e1:ecf9:6ab6])
        by smtp.gmail.com with ESMTPSA id a22sm112080wmq.45.2022.02.07.02.50.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Feb 2022 02:50:43 -0800 (PST)
From:   Usama Arif <usama.arif@bytedance.com>
To:     io-uring@vger.kernel.org, axboe@kernel.dk, asml.silence@gmail.com,
        linux-kernel@vger.kernel.org
Cc:     fam.zheng@bytedance.com, lkp@lists.01.org, lkp@intel.com,
        Usama Arif <usama.arif@bytedance.com>,
        kernel test robot <oliver.sang@intel.com>
Subject: [PATCH] io_uring: unregister eventfd while holding lock when freeing ring ctx
Date:   Mon,  7 Feb 2022 10:50:40 +0000
Message-Id: <20220207105040.2662467-1-usama.arif@bytedance.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is because ctx->io_ev_fd is rcu_dereference_protected using
ctx->uring_lock in io_eventfd_unregister. Not locking the function
resulted in suspicious RCU usage reported by kernel test robot.

Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Usama Arif <usama.arif@bytedance.com>
---
 fs/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ad8f84376955..dbc9d3f3f6c5 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -9471,8 +9471,8 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 		__io_sqe_files_unregister(ctx);
 	if (ctx->rings)
 		__io_cqring_overflow_flush(ctx, true);
-	mutex_unlock(&ctx->uring_lock);
 	io_eventfd_unregister(ctx);
+	mutex_unlock(&ctx->uring_lock);
 	io_destroy_buffers(ctx);
 	if (ctx->sq_creds)
 		put_cred(ctx->sq_creds);
-- 
2.25.1

