Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46B24778FF6
	for <lists+io-uring@lfdr.de>; Fri, 11 Aug 2023 14:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234954AbjHKMzS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 11 Aug 2023 08:55:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235116AbjHKMzR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 11 Aug 2023 08:55:17 -0400
Received: from mail-ej1-x62d.google.com (mail-ej1-x62d.google.com [IPv6:2a00:1450:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA8A8109
        for <io-uring@vger.kernel.org>; Fri, 11 Aug 2023 05:55:16 -0700 (PDT)
Received: by mail-ej1-x62d.google.com with SMTP id a640c23a62f3a-98377c5d53eso269360566b.0
        for <io-uring@vger.kernel.org>; Fri, 11 Aug 2023 05:55:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1691758515; x=1692363315;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b44YcyjPbFap3yV03J2dsu1qQ4z7LC8pimOtpsft2Qc=;
        b=HbQ+nEF5gOkVhKlVEVlJq9A9JRZYcs2GtXA1jM1EXMiweB6aSVOO7WGqXqU/zkGNHY
         y7dU2wpbbrs2Hs2LEKE39ZsTgrk3T7lnKU5wIZdhcx1Xfj0Cb5UN+RAgLcYuPF9062tZ
         Y4LBmFPhdWGjzVZb8wRF1F3MxNjWCiDA5hx+P4PP6ZzD+c3CiV0dBuvgOzNPlQd1dA93
         +auaX9AjlRO3UTCBymzaA7T5x49UR8x0gm/4U5HWfgwrg1v/5fM9LtAUg447SvrgVdHK
         gRb9bEurIaRy/zxe+eTXuK5hN9c/C2e7k+IJu8qOsr/Qv250QGO+6y2BU8hGz6EIWT/J
         s3sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691758515; x=1692363315;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b44YcyjPbFap3yV03J2dsu1qQ4z7LC8pimOtpsft2Qc=;
        b=NG5EqKWHEe45A3vLWndfkwsmLwoanqD1aA8+xd9a6QAsBnahQWpqifgGSKdWORvmrr
         UBf7Ic1YQATe7F5pbD2joEjXwGJCEfYs/eykyaOqPPlW6FvrqyXqS+R1V8WEBoVlyYYv
         IP0TYqjp682/O6uiv/mRP96dSf5zxUzMxyMPB6OX5FP5ovfZN7jJgGc85sm7injqWGek
         3RHMTstlH+PzFjxBphzRm3Lk4H4KM7T1DW3iNEscK8HVXmpFUruae+yH0DGEiJbM90zN
         K/9dDtK4EsyleFaDhODNBM5jecbc5bgYxK3Sfs+tXJX090VMnZSwbes/BV6cffJ5s/9e
         1Paw==
X-Gm-Message-State: AOJu0YwvgST70j8bkJO0I4aZSXFQXfcSxHIy6N+FwjYP5/VVCzzZVl/b
        EILsglrvDqwYJWGQVgCrLzZhptXlIiU=
X-Google-Smtp-Source: AGHT+IFRoQL/vUAtm6YvdlGoo1WVdWemmsvHCeY2Cpdgp0VEB7e6gE9CcdZ8yXaXC1xSW4aOi+zQhw==
X-Received: by 2002:a17:906:18aa:b0:99c:bb4d:f590 with SMTP id c10-20020a17090618aa00b0099cbb4df590mr1439525ejf.47.1691758515080;
        Fri, 11 Aug 2023 05:55:15 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:a57e])
        by smtp.gmail.com with ESMTPSA id kk9-20020a170907766900b0099cc36c4681sm2206943ejc.157.2023.08.11.05.55.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Aug 2023 05:55:14 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 7/7] io_uring: simplify io_run_task_work_sig return
Date:   Fri, 11 Aug 2023 13:53:47 +0100
Message-ID: <3aec8a532c003d6e50739b969a82989402696170.1691757663.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1691757663.git.asml.silence@gmail.com>
References: <cover.1691757663.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Nobody cares about io_run_task_work_sig returning 1, we only check for
negative errors. Simplify by keeping to 0/-error returns.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index a7a4d637aee0..e189158ebbdd 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2477,10 +2477,10 @@ int io_run_task_work_sig(struct io_ring_ctx *ctx)
 	if (!llist_empty(&ctx->work_llist)) {
 		__set_current_state(TASK_RUNNING);
 		if (io_run_local_work(ctx) > 0)
-			return 1;
+			return 0;
 	}
 	if (io_run_task_work() > 0)
-		return 1;
+		return 0;
 	if (task_sigpending(current))
 		return -EINTR;
 	return 0;
-- 
2.41.0

