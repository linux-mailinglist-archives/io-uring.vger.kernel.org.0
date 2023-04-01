Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D33186D33A5
	for <lists+io-uring@lfdr.de>; Sat,  1 Apr 2023 21:51:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbjDATvq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 1 Apr 2023 15:51:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjDATvq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 1 Apr 2023 15:51:46 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 035F29750
        for <io-uring@vger.kernel.org>; Sat,  1 Apr 2023 12:51:45 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id l27so25595831wrb.2
        for <io-uring@vger.kernel.org>; Sat, 01 Apr 2023 12:51:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680378703;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1Bl66kphnyflU0aRVRYU88zgNOUTlgi1RdM9ndpSwiM=;
        b=nSOsPgjQ0xF/+qjW+a3cxiqGq/crwB7VXbZq+TAzq/cbwYA49+dUFQUPkycEDeFV1k
         w5JWcHa0mza23aXee8U+eiXzyv3xNboOnhjOcfZdGy3BfZW5kjegxjdvS+FYykqGWMhz
         vvsAdJE9i1EmJKo04nFlIzmeDOakxJ+pHoZjXZXkyWTbnOa/WpDJbtcyW6A7q5d802z8
         UnndLVaRrOkcgVgcjzM/awfvd2zarQ6fgfgNJ9+q+jz4UhCecVT3k1Ttp6YERE3q+sOw
         NfCi/UaZDJAIV3Hzvoh4i4BDwiHLgkTyGZXEZmMR9AZM3453GvFDvSLQRB3XCm5eVuAE
         4IZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680378703;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1Bl66kphnyflU0aRVRYU88zgNOUTlgi1RdM9ndpSwiM=;
        b=fEGh8+AKXJkRo8QMypivDB1FzAZ5qqcCcs0p8Wv3XH3lgGsHEfSo0/UQKlmWNn/3BP
         FV7Hh/kkMeAwn7//lQlNG+HYyRSv9C7Jf/eiTXjqHGb2PAaimMe0HzwoO4QXieG6Rbqv
         HAFs6lOf+CZgyuau39YoM+FALDMROFQwL32c0lgIO94zhsZLciCmu3oc4DL1tpycKpsC
         kc2tMB3JWyA1pbUsSnA4K8kQqC7z8J5hp/6N9WTmf7zSBO90p+oSmBOGefrNJbX0bc8/
         dxS7p4seXWWWyNkccv5PToyqi28P69wxJpJSlUiWAbeDyWAv1/2nWciF/93tVDVgSadW
         8xjw==
X-Gm-Message-State: AAQBX9fLnZzccms9j6Wf+qgr/cBpHkAkKkIzsuKYkcsr4WZC5+Fk2RPr
        BxPAFf39lZLrOFhJF6brg7yRiGftqco=
X-Google-Smtp-Source: AKy350ZIUijgNT2XDKo5VhVqrWoBTWJv49wB4UxKv3WuY9lylQkKUNjsahRb9pwx2QTvgR7RHxAW9g==
X-Received: by 2002:a5d:66d1:0:b0:2cf:e8f4:d1ea with SMTP id k17-20020a5d66d1000000b002cfe8f4d1eamr22394219wrw.29.1680378703371;
        Sat, 01 Apr 2023 12:51:43 -0700 (PDT)
Received: from localhost.localdomain ([152.37.82.41])
        by smtp.gmail.com with ESMTPSA id b6-20020a5d5506000000b002e463bd49e3sm5561009wrv.66.2023.04.01.12.51.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 01 Apr 2023 12:51:42 -0700 (PDT)
From:   Wojciech Lukowicz <wlukowicz01@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, Wojciech Lukowicz <wlukowicz01@gmail.com>
Subject: [PATCH 2/2] io_uring: fix memory leak when removing provided buffers
Date:   Sat,  1 Apr 2023 20:50:39 +0100
Message-Id: <20230401195039.404909-3-wlukowicz01@gmail.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20230401195039.404909-1-wlukowicz01@gmail.com>
References: <20230401195039.404909-1-wlukowicz01@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.1 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

When removing provided buffers, io_buffer structs are not being disposed
of, leading to a memory leak. They can't be freed individually, because
they are allocated in page-sized groups. They need to be added to some
free list instead, such as io_buffers_cache. All callers already hold
the lock protecting it, apart from when destroying buffers, so had to
extend the lock there.

Fixes: cc3cec8367cb ("io_uring: speedup provided buffer handling")
Signed-off-by: Wojciech Lukowicz <wlukowicz01@gmail.com>
---
 io_uring/io_uring.c | 2 +-
 io_uring/kbuf.c     | 5 ++++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 722624b6d0dc..2a8b8c304d2a 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2789,8 +2789,8 @@ static __cold void io_ring_ctx_free(struct io_ring_ctx *ctx)
 	io_eventfd_unregister(ctx);
 	io_alloc_cache_free(&ctx->apoll_cache, io_apoll_cache_free);
 	io_alloc_cache_free(&ctx->netmsg_cache, io_netmsg_cache_free);
-	mutex_unlock(&ctx->uring_lock);
 	io_destroy_buffers(ctx);
+	mutex_unlock(&ctx->uring_lock);
 	if (ctx->sq_creds)
 		put_cred(ctx->sq_creds);
 	if (ctx->submitter_task)
diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 0fdcc0adbdbc..a90c820ce99e 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -228,11 +228,14 @@ static int __io_remove_buffers(struct io_ring_ctx *ctx,
 		return i;
 	}
 
+	/* protects io_buffers_cache */
+	lockdep_assert_held(&ctx->uring_lock);
+
 	while (!list_empty(&bl->buf_list)) {
 		struct io_buffer *nxt;
 
 		nxt = list_first_entry(&bl->buf_list, struct io_buffer, list);
-		list_del(&nxt->list);
+		list_move(&nxt->list, &ctx->io_buffers_cache);
 		if (++i == nbufs)
 			return i;
 		cond_resched();
-- 
2.30.2

