Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 316133DA716
	for <lists+io-uring@lfdr.de>; Thu, 29 Jul 2021 17:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237661AbhG2PGh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 29 Jul 2021 11:06:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237737AbhG2PGg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 29 Jul 2021 11:06:36 -0400
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7510FC061765
        for <io-uring@vger.kernel.org>; Thu, 29 Jul 2021 08:06:31 -0700 (PDT)
Received: by mail-wm1-x32b.google.com with SMTP id e25-20020a05600c4b99b0290253418ba0fbso4276761wmp.1
        for <io-uring@vger.kernel.org>; Thu, 29 Jul 2021 08:06:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=b03rB4RIvVnMhyEKQjApfgsNfwcDobxdzZG7kLlB3M8=;
        b=RN8fV8dlX78JhcdAINJHGwXL9YJmIREE41CPTqpp8j/EASauJCmlrahRZ+t+Ao35gk
         ZJA8vjUygdKthDq9nok9dJxvFvOkKnkHwu8s3jWeLGBl7S0Pr96oc8zuQ2mV9xRg7uCa
         9rBUo8pRQa6wyHeKILZWfR376R/ODS9/iSNmsgy+xtoEp4cm8mwZbYhAxPffd2isTy6K
         hVzaIyyf8Adg45FhqB+5gMavFj1ZwZLEYijut4QO4qzUM5EAseahIPA18dxNdZg02Vnb
         zmSFscOh0X0UVtCtoqsgoQrhxcA+MB1QOJWbN3rA2rKvenHHiAvWaF36SVA89n2aFcFk
         ojLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=b03rB4RIvVnMhyEKQjApfgsNfwcDobxdzZG7kLlB3M8=;
        b=daRG9gfBHkRdPDI9532i4k7btIZzCAFMKJl90aZmzWZKdyZF4H2atBwJskm9EFlJhL
         gXRkm4Qb2GcLWvfFodIgnZE22aGeGbhZ3vJFIXJWlh/ifxF1Ai4IN02cPwTtDplGcUqd
         fE3rr0rXnOAqZoonXIquZzd/YwbM3DuPvE2PTTAPj06WRyEtMJThsrqD6CTBPUGnVUdC
         xVcOD29lZ/pvOlc58+L4BOj7q9DdbbzFnq/AqJ8gPZMGUU3zYYw+13noQZwy2a+k7Y3Q
         AqanXcx3yZ7LjJyImFKc+f6yscGOB/yRFgFsQ2eLIcxJCBcbEK7Us4jvNH6jT2ZN2BaT
         hjng==
X-Gm-Message-State: AOAM531LDVq6ZSWIg43UvP8nM6NqlJSVzwoPEPKaP6lALi6JB0gnDJ+h
        NfCpq1F2MZhb2BoYkg2Bh4o=
X-Google-Smtp-Source: ABdhPJyENr3FORwtaSM9lzsbwtIp6lSQNYed5NqiEUddjiBHRfijDgw+BDiEG9BM7sv9oYKroZ4smw==
X-Received: by 2002:a05:600c:2908:: with SMTP id i8mr5170814wmd.108.1627571190127;
        Thu, 29 Jul 2021 08:06:30 -0700 (PDT)
Received: from localhost.localdomain ([148.252.128.141])
        by smtp.gmail.com with ESMTPSA id e6sm4764577wrg.18.2021.07.29.08.06.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jul 2021 08:06:29 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 08/23] io_uring: move io_put_task() definition
Date:   Thu, 29 Jul 2021 16:05:35 +0100
Message-Id: <fd782cc555c6b78cd359c7df031fd095edd00032.1627570633.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <cover.1627570633.git.asml.silence@gmail.com>
References: <cover.1627570633.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Move the function in the source file as it is to get rid of forward
declarations.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 23 +++++++++++------------
 1 file changed, 11 insertions(+), 12 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index db43aedcfc42..a5f58d8ea70f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1057,7 +1057,6 @@ static bool io_cqring_fill_event(struct io_ring_ctx *ctx, u64 user_data,
 static void io_put_req(struct io_kiocb *req);
 static void io_put_req_deferred(struct io_kiocb *req, int nr);
 static void io_dismantle_req(struct io_kiocb *req);
-static void io_put_task(struct task_struct *task, int nr);
 static struct io_kiocb *io_prep_linked_timeout(struct io_kiocb *req);
 static void io_queue_linked_timeout(struct io_kiocb *req);
 static int __io_register_rsrc_update(struct io_ring_ctx *ctx, unsigned type,
@@ -1561,6 +1560,17 @@ static inline void req_ref_get(struct io_kiocb *req)
 	atomic_inc(&req->refs);
 }
 
+/* must to be called somewhat shortly after putting a request */
+static inline void io_put_task(struct task_struct *task, int nr)
+{
+	struct io_uring_task *tctx = task->io_uring;
+
+	percpu_counter_sub(&tctx->inflight, nr);
+	if (unlikely(atomic_read(&tctx->in_idle)))
+		wake_up(&tctx->wait);
+	put_task_struct_many(task, nr);
+}
+
 static bool io_cqring_event_overflow(struct io_ring_ctx *ctx, u64 user_data,
 				     long res, unsigned int cflags)
 {
@@ -1797,17 +1807,6 @@ static void io_dismantle_req(struct io_kiocb *req)
 	}
 }
 
-/* must to be called somewhat shortly after putting a request */
-static inline void io_put_task(struct task_struct *task, int nr)
-{
-	struct io_uring_task *tctx = task->io_uring;
-
-	percpu_counter_sub(&tctx->inflight, nr);
-	if (unlikely(atomic_read(&tctx->in_idle)))
-		wake_up(&tctx->wait);
-	put_task_struct_many(task, nr);
-}
-
 static void __io_free_req(struct io_kiocb *req)
 {
 	struct io_ring_ctx *ctx = req->ctx;
-- 
2.32.0

