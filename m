Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C533D33F585
	for <lists+io-uring@lfdr.de>; Wed, 17 Mar 2021 17:30:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232556AbhCQQaR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 Mar 2021 12:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232552AbhCQQ3t (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 Mar 2021 12:29:49 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEA77C06175F
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 09:29:48 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id m6so2068752ilh.6
        for <io-uring@vger.kernel.org>; Wed, 17 Mar 2021 09:29:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wmEcBva95A+W8W1tYnAXEyfI/absXxh9yvOKkmyVUPk=;
        b=jQXfflkzBL9vNdn3SNf3JyWnNV5fliXBOgdjVliOKtNpKcNdXIvYOSKXbhvKa4H0FO
         mCi0udszuEphcx/1qQ1j1vpZ8t5KYWL2N4OtR/Oo5bH5L9SQUNp5UoEa+Yh3lEfzQbmj
         a5WEfSX9JbRYqTOgZrU/kYabkzPyHomwADkORQ3o0ZJnY/SGKJmzWZel9+y0yKaPvbv2
         UiHplT04nGsFY/AmdqTXbq3eyCpPvVPvpjeKYT0/WiBoEnJ1SyKYwkPXZY/s5SUSZ+AG
         mdEVwBUjHhS6t2gZgOnFzu79oUEZehZcdp8gUhoq8vH3vpkbHdlQCRkR7rf3xANinrTO
         aB2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wmEcBva95A+W8W1tYnAXEyfI/absXxh9yvOKkmyVUPk=;
        b=XZIMOs50+xu0K1kG42rtFexafLZ/EKu+PNxk4Ndzd2OgRMg5m8aDL6Qc6wMd6PBjQ1
         SbOzsU1cpOuQgepCWLk43w9QpmomzzuTgoHz8hYvClAhhuhlvcvjokshfluEtj3AiI2x
         vMGW+hSP8JuUdXcPfioBwL6wuulzf6V/h92nKgdTX5U/m22QngyX5Cjl8Njd8zTZlRwG
         4gTn3Hu3VpOYSTPRBXUSLp5Rd6IEcd3G1Z6ge4Y+v38pSQ/ZwAKLXa05z+Zn5xRIRi0c
         FmBkYSjuCpJO/htxMNdADP5JWRQgWSiTiQBoSCE6Kzr7ZsqPSt1EmCCvjRQOCyf7KZ6b
         fbgg==
X-Gm-Message-State: AOAM5337BFPaLixnw+XUe3J+cBK+jO5bSZlTf7fpHKWSqfBNpOphk3BV
        qFaVtBxxVaqh9xhalKxOg/Sh3oDzx2XNdw==
X-Google-Smtp-Source: ABdhPJz0wzaJl8Iw9jVI0RsFkVA2q6bbwFlPuTxrMDAcZjIWvDqR2smcJGXf+LF372nQkNjVYyYemw==
X-Received: by 2002:a05:6e02:489:: with SMTP id b9mr8132302ils.37.1615998588044;
        Wed, 17 Mar 2021 09:29:48 -0700 (PDT)
Received: from p1.localdomain ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id h1sm11164271ilo.64.2021.03.17.09.29.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Mar 2021 09:29:47 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/9] io_uring: include cflags in completion trace event
Date:   Wed, 17 Mar 2021 10:29:38 -0600
Message-Id: <20210317162943.173837-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210317162943.173837-1-axboe@kernel.dk>
References: <20210317162943.173837-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We should be including the completion flags for better introspection on
exactly what completion event was logged.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c                   |  2 +-
 include/trace/events/io_uring.h | 11 +++++++----
 2 files changed, 8 insertions(+), 5 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 37413a9127b7..140029f730d7 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1510,7 +1510,7 @@ static void __io_cqring_fill_event(struct io_kiocb *req, long res,
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_uring_cqe *cqe;
 
-	trace_io_uring_complete(ctx, req->user_data, res);
+	trace_io_uring_complete(ctx, req->user_data, res, cflags);
 
 	/*
 	 * If we can't get a cq entry, userspace overflowed the
diff --git a/include/trace/events/io_uring.h b/include/trace/events/io_uring.h
index 9f0d3b7d56b0..bd528176a3d5 100644
--- a/include/trace/events/io_uring.h
+++ b/include/trace/events/io_uring.h
@@ -290,29 +290,32 @@ TRACE_EVENT(io_uring_fail_link,
  * @ctx:		pointer to a ring context structure
  * @user_data:		user data associated with the request
  * @res:		result of the request
+ * @cflags:		completion flags
  *
  */
 TRACE_EVENT(io_uring_complete,
 
-	TP_PROTO(void *ctx, u64 user_data, long res),
+	TP_PROTO(void *ctx, u64 user_data, long res, unsigned cflags),
 
-	TP_ARGS(ctx, user_data, res),
+	TP_ARGS(ctx, user_data, res, cflags),
 
 	TP_STRUCT__entry (
 		__field(  void *,	ctx		)
 		__field(  u64,		user_data	)
 		__field(  long,		res		)
+		__field(  unsigned,	cflags		)
 	),
 
 	TP_fast_assign(
 		__entry->ctx		= ctx;
 		__entry->user_data	= user_data;
 		__entry->res		= res;
+		__entry->cflags		= cflags;
 	),
 
-	TP_printk("ring %p, user_data 0x%llx, result %ld",
+	TP_printk("ring %p, user_data 0x%llx, result %ld, cflags %x",
 			  __entry->ctx, (unsigned long long)__entry->user_data,
-			  __entry->res)
+			  __entry->res, __entry->cflags)
 );
 
 
-- 
2.31.0

