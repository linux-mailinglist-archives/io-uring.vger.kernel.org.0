Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E42AC50A110
	for <lists+io-uring@lfdr.de>; Thu, 21 Apr 2022 15:45:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1386729AbiDUNsG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 21 Apr 2022 09:48:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1386691AbiDUNsD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 21 Apr 2022 09:48:03 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C95FAE6C
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 06:45:13 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id bg25so2527020wmb.4
        for <io-uring@vger.kernel.org>; Thu, 21 Apr 2022 06:45:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iwf7B/JoObKukmaAm7gltrLYGrS6GCfPNu+o9swiNC0=;
        b=MofLb1xS4gd/3a/vyjdEDkC3T5v8FNu3+c0rPDkSTDqcB/IHhVcociPazVYbynn8gi
         4O4H4wKyvC5woL6WzNe0Pma5Qr/BiDGGjjkuKUEwdrB4/DEpbJAO7av1KxJkrS51exqe
         tKYoUZvHU3hI0f9A3L8NyogV/1Kmah5Rjoi/Zrm0HQgA2nUm3yW/iv6SjQ9HRPZefwm9
         uo5fPOHD6SQ5+/Mpx5S2TaXJ3LdH8LP5xfgCWGzI9v8edqPIm03EPzREROmtKpiTxoYp
         MVM2Vs8NF7sqNMA3hYS9KUv/BFq/KSl8saadun+nZMehAYCtf2V2IbYEyYlNKcrwbfN2
         0ACw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iwf7B/JoObKukmaAm7gltrLYGrS6GCfPNu+o9swiNC0=;
        b=ky4mdLCN585aVbnMrT/WbQ5YYt5qaGcb4NCHZkadb9TRbKzmpaBIsuwyLp5cutZFz6
         BG0Vikl5J7Sn+3DNkEEeZ4c2rThz8uUY2RRjIoPa3yHvB+eqpPsTEP5xTjMr3Kgx1baY
         hLUyPT9z7z276araBfP9hqH2rYfX1a2CtZCBGyPLg87khdBt5hPoZpF281Imw2+7yiXX
         x9yzKTaVmuK5eUlBa2zyVoLF+CqG6Ewy/RFQrLQPjUsUXpqVi78X261JXOSbR1wRE4ja
         4XF43uKWYGDr+rAc0jMyRY2osmPQDcRbnMv9mloiWSF8YlTCXmaKNNcocIBthxJZCB8a
         TqUQ==
X-Gm-Message-State: AOAM532zoOodOjUzuvtdE1e5t+vVlPXpKOEkVm7r8DjmVpK0w1DgqDLt
        WZG96VN/gBj1TQG9AE3xOl2GAjQbPkQ=
X-Google-Smtp-Source: ABdhPJxR/22gW7liJGIe4s2okqxNdsah+az48ygUQxb8tbOgDfhOR+eF2G3cSNj34FUwL3j//MMbyg==
X-Received: by 2002:a05:600c:4e87:b0:38e:ada5:5c6f with SMTP id f7-20020a05600c4e8700b0038eada55c6fmr8546158wmq.21.1650548711961;
        Thu, 21 Apr 2022 06:45:11 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.129.218])
        by smtp.gmail.com with ESMTPSA id m7-20020adfe0c7000000b002060e7bbe49sm2837821wri.45.2022.04.21.06.45.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 21 Apr 2022 06:45:11 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [RFC 04/11] io_uring: don't take ctx refs in tctx_task_work()
Date:   Thu, 21 Apr 2022 14:44:17 +0100
Message-Id: <92eb2d1f934ad16752cc3b764d8be75ca04d1ffe.1650548192.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <cover.1650548192.git.asml.silence@gmail.com>
References: <cover.1650548192.git.asml.silence@gmail.com>
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

Now we ban any new req-task_works to be added after we start the task
cancellation. Because tctx is removed from ctx lists only during
task cancellation, and considering that it's removed from the task
context, we'll have current accounted in all rings tctx_task_work() is
working with and so they will stay alive at least awhile it's running.
Don't takes extra ctx refs.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ec5fe55ab265..8d5aff1ecb4c 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2475,7 +2475,6 @@ static void ctx_flush_and_put(struct io_ring_ctx *ctx, bool *locked)
 		mutex_unlock(&ctx->uring_lock);
 		*locked = false;
 	}
-	percpu_ref_put(&ctx->refs);
 }
 
 static inline void ctx_commit_and_unlock(struct io_ring_ctx *ctx)
@@ -2506,7 +2505,6 @@ static void handle_prev_tw_list(struct io_wq_work_node *node,
 			*ctx = req->ctx;
 			/* if not contended, grab and improve batching */
 			*uring_locked = mutex_trylock(&(*ctx)->uring_lock);
-			percpu_ref_get(&(*ctx)->refs);
 			if (unlikely(!*uring_locked))
 				spin_lock(&(*ctx)->completion_lock);
 		}
@@ -2537,7 +2535,6 @@ static void handle_tw_list(struct io_wq_work_node *node,
 			*ctx = req->ctx;
 			/* if not contended, grab and improve batching */
 			*locked = mutex_trylock(&(*ctx)->uring_lock);
-			percpu_ref_get(&(*ctx)->refs);
 		}
 		req->io_task_work.func(req, locked);
 		node = next;
-- 
2.36.0

