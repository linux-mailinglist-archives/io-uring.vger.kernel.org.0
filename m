Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E3F74E338C
	for <lists+io-uring@lfdr.de>; Mon, 21 Mar 2022 23:56:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230241AbiCUWwn (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 21 Mar 2022 18:52:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbiCUWwe (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 21 Mar 2022 18:52:34 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B14C63BB782
        for <io-uring@vger.kernel.org>; Mon, 21 Mar 2022 15:31:50 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id w4so19586271edc.7
        for <io-uring@vger.kernel.org>; Mon, 21 Mar 2022 15:31:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=HClOKUGg0aEeA3UK3LGJIOEvUpawHkrZUfoSXDN22n8=;
        b=JMZSHPCI2mJwjVqgX2muyutWYn9LqGKeaN6M6k8IyDzCfEEjHA5f++6m1U+Ob4lrkW
         OPVwmY74gYTrqhaaUnhqMQB+qAXsn9qx493ndjWzV624t8+La9y4uUqP6ZlXeKZTmHs2
         SKKefnXDRHtHzse21muVcFGyynnXP5jlsLwZc2zNuNAcVymRfExwCScC7s6+bZJ2xBfU
         dptTg4IpzusqQ+qpLCLeC3QEpkwP2wPkjQPpEJ4BF7nLeFcPCV0S7qFnn8fCPlfu2hT8
         GslHpauwHgjxBMUUiXA9+zV+K5/8snqOrDakM1MLakTnLhVqBSYpjTNMQiBwEKa8x4mf
         kCLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HClOKUGg0aEeA3UK3LGJIOEvUpawHkrZUfoSXDN22n8=;
        b=jlvuWzwiLZsZz4q6Nq2OLhiK65zLxDDRlV3QshDMqMEjIsB82c3f7+z1443G5F3SuG
         9ZB6HxxbvHrRMvQ3yj3Fml4mulh8vapHm0fj0NM9xg45izMkvtvWHLA39sZOqXziTicu
         oqKuRaenPDHYjKx7/dQX3hxVriM/24kygfshLdEuO6vr1Fb8irXR2NlipjpJz1GB2f35
         rjUVDYEITIAzKPSHozE5YrCUBmXEkpUcnWpWEH+oHnPYQMUS3N35b1S1UgtIrCu3AnS2
         2QLF4XfoHMBuLf49QPToStUXAFfaKhGZs8jOB/Kr7t6uTdN1VI1ewq2Ix3TswA+AbSo5
         uD1Q==
X-Gm-Message-State: AOAM531TaYVdiPi2SP5i2akKQCCQ4s6nfaCv/MncnPYEuFT5GXaXfBg8
        Jz+KZrQFC5jrLaeVxPZQzDlXqSjaDWE3lg==
X-Google-Smtp-Source: ABdhPJzDUVzqto7oH6iG5iWeYzWa/49f3EU3WuiLbyG70Qnw9KpBff625DbezvQO7xyUlO1vboxJYg==
X-Received: by 2002:a05:6402:254e:b0:418:d759:dc48 with SMTP id l14-20020a056402254e00b00418d759dc48mr25490541edb.104.1647900237997;
        Mon, 21 Mar 2022 15:03:57 -0700 (PDT)
Received: from 127.0.0.1localhost ([85.105.239.232])
        by smtp.gmail.com with ESMTPSA id qb10-20020a1709077e8a00b006dfedd50ce3sm2779658ejc.143.2022.03.21.15.03.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 15:03:57 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 2/6] io_uring: remove extra ifs around io_commit_cqring
Date:   Mon, 21 Mar 2022 22:02:20 +0000
Message-Id: <36aed692dff402bba00a444a63a9cd2e97a340ea.1647897811.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1647897811.git.asml.silence@gmail.com>
References: <cover.1647897811.git.asml.silence@gmail.com>
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

Now io_commit_cqring() is simple and it tolerates well being called
without a new CQE filled, so kill a bunch of not needed anymore
guards.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index bb8a1362cb5e..71f3bea34e66 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1947,8 +1947,7 @@ static bool __io_cqring_overflow_flush(struct io_ring_ctx *ctx, bool force)
 			   ctx->rings->sq_flags & ~IORING_SQ_CQ_OVERFLOW);
 	}
 
-	if (posted)
-		io_commit_cqring(ctx);
+	io_commit_cqring(ctx);
 	spin_unlock(&ctx->completion_lock);
 	if (posted)
 		io_cqring_ev_posted(ctx);
@@ -2382,8 +2381,7 @@ static void __io_req_find_next_prep(struct io_kiocb *req)
 
 	spin_lock(&ctx->completion_lock);
 	posted = io_disarm_next(req);
-	if (posted)
-		io_commit_cqring(ctx);
+	io_commit_cqring(ctx);
 	spin_unlock(&ctx->completion_lock);
 	if (posted)
 		io_cqring_ev_posted(ctx);
@@ -10248,8 +10246,7 @@ static __cold bool io_kill_timeouts(struct io_ring_ctx *ctx,
 		}
 	}
 	spin_unlock_irq(&ctx->timeout_lock);
-	if (canceled != 0)
-		io_commit_cqring(ctx);
+	io_commit_cqring(ctx);
 	spin_unlock(&ctx->completion_lock);
 	if (canceled != 0)
 		io_cqring_ev_posted(ctx);
-- 
2.35.1

