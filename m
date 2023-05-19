Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17E897098F4
	for <lists+io-uring@lfdr.de>; Fri, 19 May 2023 16:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232046AbjESOGm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 May 2023 10:06:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230116AbjESOGl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 May 2023 10:06:41 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48B7C18D
        for <io-uring@vger.kernel.org>; Fri, 19 May 2023 07:06:39 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id a640c23a62f3a-965c3f9af2aso504893266b.0
        for <io-uring@vger.kernel.org>; Fri, 19 May 2023 07:06:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1684505197; x=1687097197;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NK0RgCY6xCjXhoaj+QQFj3KkUTzbVfcIkEPsORSsdJM=;
        b=I5a7OIEl7ctTclvU3qlz2NOjyggWyLt9FIhhIuTwB36gXvEovm2BGXWLbc37ecQVLq
         C2ce6zDQ3Y6ttyrk9sKghuMmtSNgOf5j0hF2uyNHvI5yfP8fz5nMRrbfe2YlrDHb7DXL
         Tyrmia0Q+D1aXFBIBXFHU5gl0V0Pq3pCsBdnuLWdCmwjFjfH9XYNH2iZmGEA7vwxsxRV
         4vjCFF1Z15yVbBsK3CJjrvAr6YrB0dvAsvSjrpFbgVrgWDZTMlk10Jy20JeMeuuXdrX9
         es11CZ2i5EX3aQQxH5x0gLlJCRW6+PMiJovDGwm/RJVjIyemnkoUMsMclLlkAykcIuim
         EDGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684505197; x=1687097197;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NK0RgCY6xCjXhoaj+QQFj3KkUTzbVfcIkEPsORSsdJM=;
        b=Srdk5holcqMpekgBsCTaGYbgQYVyS5QGO5a4OLif0lstZPJR8cEEm5TtrmY3ZjoiAK
         GEIepUOgNeaByFM6vT+RA/uReho41bQ2+7+hMq5STzLAzz62k/GunV7170FxjKoG5aBI
         oxruJp7CyRgTW5GPGDSNV1uzQQGM4lAECmFXQphDHYFAcsZTPf3LD74ERSJW7CXkWcZI
         8TMMOci+UJqqyd5znRtYEUMjRGpSH3PKWzMdMsAJnTsf5R45GkLHKByjG5qL1znSUGN3
         I1jyiW+ldhMfZdqEnre7fcTmNps9zxvn81x0SOzBvJ8Mtfml0Nsw+ShJAmX75g7StvUn
         usTg==
X-Gm-Message-State: AC+VfDye25TlbDIRyi+lK1Ti1pwBjBVU3VDia6u3vrZ9YJGeGacZT5Xb
        W2xKN9mhrXdka5DFXETyyonNLtpQMg0=
X-Google-Smtp-Source: ACHHUZ7ESXPxqYzKpYaQHbbPtLDrSeRwbXNVuF+ZGbNWaWf+DlUamW3VICAWTLagMCtehB7BBS3uwQ==
X-Received: by 2002:a17:907:3206:b0:966:484a:335e with SMTP id xg6-20020a170907320600b00966484a335emr1550493ejb.43.1684505196421;
        Fri, 19 May 2023 07:06:36 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::2:e979])
        by smtp.gmail.com with ESMTPSA id j15-20020a1709066dcf00b0096b4ec45e10sm2339312ejt.139.2023.05.19.07.06.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 May 2023 07:06:36 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        yang lan <lanyang0908@gmail.com>
Subject: [PATCH 1/1] io_uring: more graceful request alloc OOM
Date:   Fri, 19 May 2023 15:05:14 +0100
Message-Id: <3e79156a106e8b5b3646672656f738ba157957ef.1684505086.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.40.0
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

It's ok for io_uring request allocation to fail, however there are
reports that it starts killing tasks instead of just returning back
to the userspace. Add __GFP_NORETRY, so it doesn't trigger OOM killer.

Cc: stable@vger.kernel.org
Fixes: 2b188cc1bb857 ("Add io_uring IO interface")
Reported-by: yang lan <lanyang0908@gmail.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index dab09f568294..ad34a4320dab 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1073,7 +1073,7 @@ static void io_flush_cached_locked_reqs(struct io_ring_ctx *ctx,
 __cold bool __io_alloc_req_refill(struct io_ring_ctx *ctx)
 	__must_hold(&ctx->uring_lock)
 {
-	gfp_t gfp = GFP_KERNEL | __GFP_NOWARN;
+	gfp_t gfp = GFP_KERNEL | __GFP_NOWARN | __GFP_NORETRY;
 	void *reqs[IO_REQ_ALLOC_BATCH];
 	int ret, i;
 
-- 
2.40.0

