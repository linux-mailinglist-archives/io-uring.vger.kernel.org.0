Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3AA6F216DE6
	for <lists+io-uring@lfdr.de>; Tue,  7 Jul 2020 15:38:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728121AbgGGNiS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 7 Jul 2020 09:38:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726951AbgGGNiS (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 7 Jul 2020 09:38:18 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 281D9C061755
        for <io-uring@vger.kernel.org>; Tue,  7 Jul 2020 06:38:18 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id w3so34092813wmi.4
        for <io-uring@vger.kernel.org>; Tue, 07 Jul 2020 06:38:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=tnN/2RuAXCjihiyyVXQqYnN8hK+GfmJ0N3bWnM2HCx4=;
        b=cxOrJEwkSx1SrULlO+aEPFlAclR/p/tkZywYfEthmQ5YBueGFUmcIMCXozaAUFs6RN
         jmE58pssEu7MEAg/Tl5WK+Buq2oaI52bEawNNxe/13AJfeQSLwRA1pB/HDoju1Rnw30c
         Gm7A9POtNFz0LWFX7sUT9Pldnbkwrp0oQkiytCvlJBJyir7lO8PYOooKBv6dpApjKWln
         NDXifO+lbY3/3095WUtbMASRTKQNRLw6XN4Nv1aqBvG83nNf8lzfX6EbMowF+sqVaMer
         h2ScqUHtF7ofO8uK88OYAKAjKwx4H808Xg1NStzgiR6OZBgGVstmCoMCgoi+iaLofNxD
         GqYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tnN/2RuAXCjihiyyVXQqYnN8hK+GfmJ0N3bWnM2HCx4=;
        b=E6KtRSngjK6Nzep5wOkvF8dZNDY3R+jz95Sv3+RUl5laR6/O8v8Z4ZZIFNEgtTCuV+
         Cet71aAndMeKq/u/jCYT5hdxHpHRcl1Er6RpRjNd6YLwcjFcM2OPUKPUwvSzwECLE6uw
         5fm6VGM4exPq2UUDZp9oa/bsuvFU9NXezlhoPU2DDY8gXx/mqd3WKmRaKonpJYUHieE6
         espZ11Z8ioXQPfCr5tvwJmSkgJm49pob2XsttqUleD11IlYLKU1GesKknFNUByz+9pRM
         CPC4o8ANlBkLBKL1jU2pGZzq6GseBKZ0hzI32G+1RtUCM5WJcItOVmyzYJtqb9HMPzXi
         Bdig==
X-Gm-Message-State: AOAM533tekl87jUb1R6wyq7Ol+c9AjD5g8C4B3uaXEISXQniXifVWSAo
        R27/jRWKgdB/IqCIgzpDxg9uWInR
X-Google-Smtp-Source: ABdhPJznNYPpJNK7AXH/kyJajSG57h/n3zwT6l4zi/dpF/KEDX4pKWoqW9PWL3VfGshpdBWXvVSUSg==
X-Received: by 2002:a1c:1d46:: with SMTP id d67mr4571209wmd.152.1594129096802;
        Tue, 07 Jul 2020 06:38:16 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id 14sm1093663wmk.19.2020.07.07.06.38.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Jul 2020 06:38:16 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/3] io_uring: partially inline io_iopoll_getevents()
Date:   Tue,  7 Jul 2020 16:36:20 +0300
Message-Id: <50c3b8a518d1fc3b6ff48252ddeeeacbb012b1d4.1594128832.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1594128832.git.asml.silence@gmail.com>
References: <cover.1594128832.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_iopoll_reap_events() doesn't care about returned valued of
io_iopoll_getevents() and does the same checks for list emptiness
and need_resched(). Just use io_do_iopoll().

io_sq_thread() doesn't check return value as well. It also passes min=0,
so there never be the second iteration inside io_poll_getevents().
Inline it there too.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 54756ae94bcd..db8dd2cdd2cb 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2057,7 +2057,7 @@ static void io_iopoll_reap_events(struct io_ring_ctx *ctx)
 	while (!list_empty(&ctx->poll_list)) {
 		unsigned int nr_events = 0;
 
-		io_iopoll_getevents(ctx, &nr_events, 1);
+		io_do_iopoll(ctx, &nr_events, 1);
 
 		/*
 		 * Ensure we allow local-to-the-cpu processing to take place,
@@ -6311,8 +6311,8 @@ static int io_sq_thread(void *data)
 			unsigned nr_events = 0;
 
 			mutex_lock(&ctx->uring_lock);
-			if (!list_empty(&ctx->poll_list))
-				io_iopoll_getevents(ctx, &nr_events, 0);
+			if (!list_empty(&ctx->poll_list) && !need_resched())
+				io_do_iopoll(ctx, &nr_events, 0);
 			else
 				timeout = jiffies + ctx->sq_thread_idle;
 			mutex_unlock(&ctx->uring_lock);
-- 
2.24.0

