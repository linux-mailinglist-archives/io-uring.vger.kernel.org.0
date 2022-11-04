Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0611619519
	for <lists+io-uring@lfdr.de>; Fri,  4 Nov 2022 12:03:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbiKDLDT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 4 Nov 2022 07:03:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229900AbiKDLCi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 4 Nov 2022 07:02:38 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76A562CDC1
        for <io-uring@vger.kernel.org>; Fri,  4 Nov 2022 04:02:36 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id k2so12342182ejr.2
        for <io-uring@vger.kernel.org>; Fri, 04 Nov 2022 04:02:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HrKFQ51HZlKuVt9GY4ZNgwEwhz5/8UDovxxA86AN5mc=;
        b=bU6JVE+EJbIOlsetxvV/1/i53fyeXnSn2uaE7yigQBdUE1g3bfxTY32cVom/xAL2Uq
         kfawbUBgoz3sFLBa150ccBZEy2sSXmXPW7t6gsQKLd3rEiTtwAt+wdLm0Ii1nfVxW5S4
         YfJdTgakQTESKzaCl9McmEVGrqQuowXHO6okNdsVtLTlLVJV9XdyqbyzmAD7z11Mfu+N
         EhG98OpHmn4+dEMzsaHnKeQAMGvXkvkFZN/r/DEwVZ5blJ36L7FqCpu7N6jjUNYVO4/U
         3/nYbK4crR2qjtqm1RjNLXUFLboQA5llxA01iHddkSCGzKnyhhYIsef6oo4THbSt4gLE
         SLNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HrKFQ51HZlKuVt9GY4ZNgwEwhz5/8UDovxxA86AN5mc=;
        b=UwJhU4gl2MBIU9eIzhLo+b2g0mGTBNM5z9LnEE4BALCtyvLxD8CwcKSawbdNKfHaNx
         YnrGZyvI3lhbshV8DtEqY6R/vFoeeaOtduhtEpjIYIhvDjSZUV22blQ5ozh9hyOOwxOp
         zEsfBRPIUWTFYXUTZuGo+dnMn4S35pQB5c9iKMfADFZuVwFJnens2db++jLE0HNvb0Dl
         kekzOy+F39M/yZxaTtmOzLBqt8jCa/c4eU89BM1zORGVkhn0BXugQI4tu3wV4kyPeRe/
         X2BxF0/q1LtwViuDX/tYlhj7QmHD8Ing1+0ukH7Lbh2uELgMmw8rRD8+NwRHIqqgd/62
         j59w==
X-Gm-Message-State: ACrzQf2pKyU5YaF9H5Lpx+sNZ2ewCHNypcPyzbPeOEHUZx2p0gSWQaHV
        ZpwXNlB745+LFhamEZJLthzDBKuOxuQ=
X-Google-Smtp-Source: AMsMyM5qUXix6wJGqGU8twKx6WZY+Ne/sPotEsNTyUizqy3mk5EaypB+bWssg8enjnEn/35g+XnM1g==
X-Received: by 2002:a17:907:25c5:b0:783:f5df:900e with SMTP id ae5-20020a17090725c500b00783f5df900emr31926173ejc.491.1667559750918;
        Fri, 04 Nov 2022 04:02:30 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:4173])
        by smtp.gmail.com with ESMTPSA id u25-20020aa7db99000000b00458947539desm1757768edt.78.2022.11.04.04.02.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Nov 2022 04:02:30 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-next 3/7] io_uring/net: preset notif tw handler
Date:   Fri,  4 Nov 2022 10:59:42 +0000
Message-Id: <7acdbea5e20eadd844513320cd454af14ba50f64.1667557923.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <cover.1667557923.git.asml.silence@gmail.com>
References: <cover.1667557923.git.asml.silence@gmail.com>
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

We're going to have multiple notification tw functions. In preparation
for future changes default the tw callback in advance so later we can
replace it with other versions.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/notif.c | 9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

diff --git a/io_uring/notif.c b/io_uring/notif.c
index 59dafc42b8e0..6afb58b94297 100644
--- a/io_uring/notif.c
+++ b/io_uring/notif.c
@@ -39,10 +39,8 @@ static void io_uring_tx_zerocopy_callback(struct sk_buff *skb,
 			WRITE_ONCE(nd->zc_copied, true);
 	}
 
-	if (refcount_dec_and_test(&uarg->refcnt)) {
-		notif->io_task_work.func = __io_notif_complete_tw;
+	if (refcount_dec_and_test(&uarg->refcnt))
 		io_req_task_work_add(notif);
-	}
 }
 
 struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx)
@@ -60,6 +58,7 @@ struct io_kiocb *io_alloc_notif(struct io_ring_ctx *ctx)
 	notif->task = current;
 	io_get_task_refs(1);
 	notif->rsrc_node = NULL;
+	notif->io_task_work.func = __io_notif_complete_tw;
 
 	nd = io_notif_to_data(notif);
 	nd->account_pages = 0;
@@ -76,8 +75,6 @@ void io_notif_flush(struct io_kiocb *notif)
 	struct io_notif_data *nd = io_notif_to_data(notif);
 
 	/* drop slot's master ref */
-	if (refcount_dec_and_test(&nd->uarg.refcnt)) {
-		notif->io_task_work.func = __io_notif_complete_tw;
+	if (refcount_dec_and_test(&nd->uarg.refcnt))
 		io_req_task_work_add(notif);
-	}
 }
-- 
2.38.0

