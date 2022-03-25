Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 109C34E73E2
	for <lists+io-uring@lfdr.de>; Fri, 25 Mar 2022 14:01:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359210AbiCYND0 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 25 Mar 2022 09:03:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1359206AbiCYNDZ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 25 Mar 2022 09:03:25 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 587936EC4B
        for <io-uring@vger.kernel.org>; Fri, 25 Mar 2022 06:01:51 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id j15so15190404eje.9
        for <io-uring@vger.kernel.org>; Fri, 25 Mar 2022 06:01:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ex0gtUuTtK1NgVGJTEHDw94o+E56pC34VJ5zbHQEBC8=;
        b=Y6zwpmcQ3wUll5kp5zd6+mJx1zqV027YxMLKWLGnNJ9i8aiv0/jrCDHLnNKVj6BXjk
         bV7x5ls270o3niJ14HKhjEQ+qIU8gxH8rX2ojdRfm+H3UhGtShOD71UwfP8O4MNgZEM/
         lTGOjtUiT+WI6fS0gGOEJHTrtZAU8QqCysPFlcbo2dP8GpuSDmySJdy/xJdvuzPJbIvR
         VJXPA0RVC0566RqBFWBTk2VBgO9vMusouoLPP2lQSm2fTgZkgT5Cd6ysQi5yXyB5BFUQ
         XCWvYR5RrQRv1EhgXDG1jOcZv/On1Syw0LurrcmyU4VWDGceR+AqpFgJhQRCFHbmhOc6
         TkGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ex0gtUuTtK1NgVGJTEHDw94o+E56pC34VJ5zbHQEBC8=;
        b=U2DnD0THaLPvFGdetNLtnb56vIwYb19ufRzrbUMqQxhkNVgHhBj6rC99VZc0hPSRWr
         AV2YOP/NkLm7jjwE8UTzKDbL0zwkQzdV28MLQ16girHHr6LjVqjSyqx2nsglpyNoweqI
         KZIcGjgxINoRHFjDqENahwaCMNAWNE5/YN4QUG6zUlYBZaMde4P/RhMC7nt+sz/qoFgh
         3Qm/adJojUHyUd1cRKm0P3olYF7na2JsVP2xafn4ey3qMgWeCz7PbJjwN2CRDtK6y1n/
         aEUJ+Ubd2iMhlhhL6p2AcCh0wE6mymwvkkHe5IzYZdK60eVMELlV/zoGjtKE43cDj5ZT
         kSGg==
X-Gm-Message-State: AOAM531xxy/c77+rwoeiyhSD2MDb+epggYiUzMM6C+fWNIvKimzc41ve
        Gfy3VX0gOYD/eU4Gu9vjmpW0OfwzuMi1WQ==
X-Google-Smtp-Source: ABdhPJzlHHDGGPus2XJCLsEYGPVS5QHvLe25o+RdFYxzxn7yDYYrYL0+kMj4kHnI1mdc6Hd/ueWitw==
X-Received: by 2002:a17:907:7244:b0:6df:fb38:1d02 with SMTP id ds4-20020a170907724400b006dffb381d02mr11500988ejc.453.1648213308341;
        Fri, 25 Mar 2022 06:01:48 -0700 (PDT)
Received: from 127.0.0.1localhost ([78.179.227.119])
        by smtp.gmail.com with ESMTPSA id ky5-20020a170907778500b006d1b2dd8d4csm2326222ejc.99.2022.03.25.06.01.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Mar 2022 06:01:47 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 1/2] io_uring: fix invalid flags for io_put_kbuf()
Date:   Fri, 25 Mar 2022 13:00:42 +0000
Message-Id: <ccf602dbf8df3b6a8552a262d8ee0a13a086fbc7.1648212967.git.asml.silence@gmail.com>
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

io_req_complete_failed() doesn't require callers to hold ->uring_lock,
use IO_URING_F_UNLOCKED version of io_put_kbuf(). The only affected
place is the fail path of io_apoll_task_func(). Also add a lockdep
annotation to catch such bugs in the future.

Fixes: 3b2b78a8eb7cc ("io_uring: extend provided buf return to fails")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 862401d23a5a..c83a650ca5fa 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1388,6 +1388,8 @@ static inline unsigned int io_put_kbuf(struct io_kiocb *req,
 		cflags = __io_put_kbuf(req, &ctx->io_buffers_comp);
 		spin_unlock(&ctx->completion_lock);
 	} else {
+		lockdep_assert_held(&req->ctx->uring_lock);
+
 		cflags = __io_put_kbuf(req, &req->ctx->io_buffers_cache);
 	}
 
@@ -2182,7 +2184,7 @@ static inline void io_req_complete(struct io_kiocb *req, s32 res)
 static void io_req_complete_failed(struct io_kiocb *req, s32 res)
 {
 	req_set_fail(req);
-	io_req_complete_post(req, res, io_put_kbuf(req, 0));
+	io_req_complete_post(req, res, io_put_kbuf(req, IO_URING_F_UNLOCKED));
 }
 
 static void io_req_complete_fail_submit(struct io_kiocb *req)
-- 
2.35.1

