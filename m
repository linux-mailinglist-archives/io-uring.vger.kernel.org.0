Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74E793DA722
	for <lists+io-uring@lfdr.de>; Thu, 29 Jul 2021 17:06:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237212AbhG2PGp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Jul 2021 11:06:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237783AbhG2PGp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Jul 2021 11:06:45 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F63CC0613C1
        for <io-uring@vger.kernel.org>; Thu, 29 Jul 2021 08:06:41 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id n11so3940641wmd.2
        for <io-uring@vger.kernel.org>; Thu, 29 Jul 2021 08:06:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=PsV6DeBTQhAPfztqIRsxkQ9/qBTeC5cjYHfl2mIeWfs=;
        b=NQ8/IvDbA7hLzznk+VjXA3N1WERS3fTGDei2kcWYKTCZdGg15tTvjtzLdq86Fnl/Uz
         KUW27N4rdb+0K5CMSh3PfQqa+f0eGTTM3utD60s/JNs07olR6Tl3m/s833o+Kxw6Eok2
         VEKF/pjy7ljUnp73miT1Z3AdOptBePJVRezU10hRaOSzpQmQgtQJShg8jL8vtuyOD/VX
         /T4WIvkN5faCvmTIBZaueG/QaQ1mTmjLhmTmF5XVtNqkrUfM84KV6spfSssBCRKA0YT3
         2Zc7p5YQqgSIXhI0gmtw9uM/EufP4DRBO7DjhLGtu4lkzBXb43OwUAEZZFSd0UeQZT8t
         Ev4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=PsV6DeBTQhAPfztqIRsxkQ9/qBTeC5cjYHfl2mIeWfs=;
        b=QPeog3OMxvPmWmYE89ZFjPb/WDCjHB5u2U9vZ0gbbCBFu6BCh2RCX867riPgJeGaNQ
         e4Tlqw5gCCK5u8xH9v/vWnh/VEtZCDohKk7+PeoIPr1COwtWWB84AfChecax7l4aS99K
         UDARKafuFegkxQFWue5DvtBdgds9TdTITYApeo/VJc3UwE0P6IdIY7VG/UUoZ4bET1Yt
         zAIDLHU7LR9A7SiMwMcZrCUJdp0DlkevnFUXEZPFKZ7P2ar4bEfPvwCub67x3RIAbnPB
         bROAG7oBmi08orpa5jxE4mCtALcIaki0eLvehh1CZlJ8rsZ6gLL+40hCIO6n2VdkqD1r
         FE5w==
X-Gm-Message-State: AOAM531Eyt1ikDPeUupzvFfJ8HbpJ3IaxieXRqPFV2LUbGsGTTwvHjLK
        bHWXjOc1PQ+YP9916wXkEBM=
X-Google-Smtp-Source: ABdhPJyv2DeJs/FfhGc5qozdZa3fH+K9rihSl6Vqgu9Kjryjdj6xLJdxnZbLEIsVmgPoq0ES2Kmkig==
X-Received: by 2002:a05:600c:2908:: with SMTP id i8mr5171789wmd.108.1627571200274;
        Thu, 29 Jul 2021 08:06:40 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.141])
        by smtp.gmail.com with ESMTPSA id e6sm4764577wrg.18.2021.07.29.08.06.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 08:06:39 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 20/23] io_uring: remove redundant args from cache_free
Date:   Thu, 29 Jul 2021 16:05:47 +0100
Message-Id: <7ea011999932a01765091bf8dadbe2e45572191c.1627570633.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1627570633.git.asml.silence@gmail.com>
References: <cover.1627570633.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We don't use @tsk argument of io_req_cache_free(), remove it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 6d843a956570..33a1c45ecd13 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8634,13 +8634,11 @@ static void io_destroy_buffers(struct io_ring_ctx *ctx)
 		__io_remove_buffers(ctx, buf, index, -1U);
 }
 
-static void io_req_cache_free(struct list_head *list, struct task_struct *tsk)
+static void io_req_cache_free(struct list_head *list)
 {
 	struct io_kiocb *req, *nxt;
 
 	list_for_each_entry_safe(req, nxt, list, inflight_entry) {
-		if (tsk && req->task != tsk)
-			continue;
 		list_del(&req->inflight_entry);
 		kmem_cache_free(req_cachep, req);
 	}
@@ -8660,7 +8658,7 @@ static void io_req_caches_free(struct io_ring_ctx *ctx)
 	}
 
 	io_flush_cached_locked_reqs(ctx, cs);
-	io_req_cache_free(&cs->free_list, NULL);
+	io_req_cache_free(&cs->free_list);
 	mutex_unlock(&ctx->uring_lock);
 }
 
-- 
2.32.0

