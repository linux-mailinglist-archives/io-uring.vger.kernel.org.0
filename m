Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7BF86D0B61
	for <lists+io-uring@lfdr.de>; Thu, 30 Mar 2023 18:34:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231285AbjC3QeA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 30 Mar 2023 12:34:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230469AbjC3Qd6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 30 Mar 2023 12:33:58 -0400
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2ABCCC1F
        for <io-uring@vger.kernel.org>; Thu, 30 Mar 2023 09:33:51 -0700 (PDT)
Received: by mail-io1-xd35.google.com with SMTP id ca18e2360f4ac-7585535bd79so11473539f.0
        for <io-uring@vger.kernel.org>; Thu, 30 Mar 2023 09:33:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1680194031;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MHwwD4EQp3T20lnNmY/P0VesUcedWHm+7cIQwQ62HiI=;
        b=oZGkHHDV7LexfBgSsaZMHse3m/l/4uOk7uCU/NOurFyGFZxRnZwrjN59OqrfAPEsUS
         AYyhchod/O4lKZ0Be0jPLrhoKBx14mhteBF/HzYWpdJss18OpbpfWEcr///BbSFqEBJo
         bVDJ3krb44p7CAvWQvINUBs912s4BJBHn/KDq3CYZItC6jmHlnq8J982YmrphviR1LoC
         09cq/vn0TWEA/ylPSu3wrIiwN8a7RlBGIPMnjOIm4Y9JXHuhD4A/ZgyE9EIHvyUnbYSL
         SOTRjYZyVonrm5jaS9yvYMQN1jcXGYXbbgzGxAFwAmXZZOssQQPUdR7Mr8g3VwSdOuNZ
         pDdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680194031;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MHwwD4EQp3T20lnNmY/P0VesUcedWHm+7cIQwQ62HiI=;
        b=OMW7OKfLs1G+59CzcNb09P9pdwdC9bHvojv51/h4qVYpj3nlJZQE5J2eu6+ELAZ88P
         YiCRUC+S02AkDtRu6uKuR4rDu5kqY3bK1crbpe53w87iODWXZwEYfqLWQijmpJCgWHIB
         i5GCbBjSRc+ia+GLpDEGSW1WP6aYPnd4Zu/H5oRD+oQloB4EX/3zC+12C1q9usAHpNio
         UuWHAv7tHtiqk/7a2fn6noxiIUP8Au2eTgNZeP2SMIizN8eZcZAL0g8Pf53f1/ARqOwF
         aHhuN70pe73ZD6NCcKT0KosRgDC+/yl64OhH1D9daho2J8B+d0mOpWK2feixP9n5Qp57
         NTuw==
X-Gm-Message-State: AAQBX9fTQ4BMqieVMR8EcCJla8UhCEXhCqtqy+Aon3zHASKHIaKmVYb1
        KMCbUdsLhN4FMLbZsrMH712rXciPrvyXjRw3ahSwiA==
X-Google-Smtp-Source: AKy350byYQPmfMoA2XQSp5ARhuIZc37lDgvQ341isEsndvyOyyHlvDQcfmUBuTVlBhTKGuKlWJuLiw==
X-Received: by 2002:a6b:b441:0:b0:758:9c9e:d6c6 with SMTP id d62-20020a6bb441000000b007589c9ed6c6mr1448632iof.2.1680194030978;
        Thu, 30 Mar 2023 09:33:50 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id h21-20020a056638339500b003ff471861a4sm19099jav.90.2023.03.30.09.33.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Mar 2023 09:33:50 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/3] io_uring: cap io_sqring_entries() at SQ ring size
Date:   Thu, 30 Mar 2023 10:33:46 -0600
Message-Id: <20230330163347.1645578-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230330163347.1645578-1-axboe@kernel.dk>
References: <20230330163347.1645578-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=0.0 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We already do this manually for the !SQPOLL case, do it in general and
we can also dump the ugly min3() in io_submit_sqes().

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 2 +-
 io_uring/io_uring.h | 4 +++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 775b53730c2f..a0b64831c455 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2434,7 +2434,7 @@ int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 	if (unlikely(!entries))
 		return 0;
 	/* make sure SQ entry isn't read before tail */
-	ret = left = min3(nr, ctx->sq_entries, entries);
+	ret = left = min(nr, entries);
 	io_get_task_refs(left);
 	io_submit_state_start(&ctx->submit_state, left);
 
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index c33f719731ac..193b2db39fe8 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -262,9 +262,11 @@ static inline bool io_sqring_full(struct io_ring_ctx *ctx)
 static inline unsigned int io_sqring_entries(struct io_ring_ctx *ctx)
 {
 	struct io_rings *rings = ctx->rings;
+	unsigned int entries;
 
 	/* make sure SQ entry isn't read before tail */
-	return smp_load_acquire(&rings->sq.tail) - ctx->cached_sq_head;
+	entries = smp_load_acquire(&rings->sq.tail) - ctx->cached_sq_head;
+	return min(entries, ctx->sq_entries);
 }
 
 static inline int io_run_task_work(void)
-- 
2.39.2

