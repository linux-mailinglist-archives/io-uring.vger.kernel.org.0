Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 001B2417CBD
	for <lists+io-uring@lfdr.de>; Fri, 24 Sep 2021 23:01:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346683AbhIXVCq (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 24 Sep 2021 17:02:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348491AbhIXVCm (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 24 Sep 2021 17:02:42 -0400
Received: from mail-ed1-x52c.google.com (mail-ed1-x52c.google.com [IPv6:2a00:1450:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71BD5C061613
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 14:01:08 -0700 (PDT)
Received: by mail-ed1-x52c.google.com with SMTP id dm26so6658446edb.12
        for <io-uring@vger.kernel.org>; Fri, 24 Sep 2021 14:01:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Xq8Ytnc6SpLOyb8+dhG7isOrbzXvcKn4wOFk9uxEVrI=;
        b=HriKAErAls0HyuZeB8pHhsjP04aL0hLv1X8WWCPrswbLH9v9JaxmpnuNLCiHq2HCEW
         brCkQZIY/ujrWchn9BHi9+e6VNN7IQjFZACVteUVd1TRSoQ/x41LCxTJRFVt+VgrAIZk
         ezMg3mtGljkk6EHSzPRTHFlkNJIgPPnRtV8Ir54dvzFtNpRfMjaWN+zckue6cQhJefCy
         BXdzkz/RuIiPd8rbUQkBug4UHhyCPHPqsae3PlXy+ecIKqKNI5ChjWVVdIRHe6w74JYR
         3vhDXmSTamqCfPP8PnpQdYXEWXQFiMnTKJ86maaURAs35jw0vWnPcYvkBa6bwIvzOdeZ
         M4tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Xq8Ytnc6SpLOyb8+dhG7isOrbzXvcKn4wOFk9uxEVrI=;
        b=hx1S7iT9Wx9ea7eFfms+HM8Ssa9YD188IYrjFWerDSbmUxjDMF6SKEPOn97Q9xkm9E
         yW19/xkmQ6fk7lMr/bDPBruSSBgyDmCaEqc2+JXmnoj14R9pUBB2xqcqUe0mHZlaa8ry
         xtDyKdGCiELSBJ670CvUjOQyTm1lgJKA5m/lrDjoZ0Dk/vr4Uih+SWMDzYI7qoRQPmyn
         tnzotCDEjteNQ4Hh157NegE9bHvXa6GbdfcLxwamG8r/lzm+UCKGKWRVJpZWbKw2HqCA
         ezC3GazvB8LSGE/AQg2CzTUNsLGIZp1n4qn8FNHS0mgNS6CP3kKOfCZ3GJx075olHw59
         29Lw==
X-Gm-Message-State: AOAM533wL8qOX0pLU5cJI55co/MGlQHvs9S9i7HmaeSB6qPVYOuCuroA
        yoJOdWm0mQDVI5tWUlSmbIGQ6eY9duY=
X-Google-Smtp-Source: ABdhPJxbSqpom7GDsJ4xSsB55nzsBDcr50+Eadq9NfhWHPAxUZF7N5cYavBQqIgDTGAuvxEHS7xw6w==
X-Received: by 2002:a17:906:39cb:: with SMTP id i11mr14213776eje.168.1632517267062;
        Fri, 24 Sep 2021 14:01:07 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.225])
        by smtp.gmail.com with ESMTPSA id bc4sm6276048edb.18.2021.09.24.14.01.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Sep 2021 14:01:06 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH v2 21/24] io_uring: restructure submit sqes to_submit checks
Date:   Fri, 24 Sep 2021 22:00:01 +0100
Message-Id: <5926baadd20c28feab7a5e1725fedf32e4553ff7.1632516769.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1632516769.git.asml.silence@gmail.com>
References: <cover.1632516769.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Put an explicit check for number of requests to submit. First,
we can turn while into do-while and it generates better code, and second
that if can be cheaper, e.g. by using CPU flags after sub in
io_sqring_entries().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 695c751434c3..b3444a7c8c89 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7233,16 +7233,19 @@ static const struct io_uring_sqe *io_get_sqe(struct io_ring_ctx *ctx)
 static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 	__must_hold(&ctx->uring_lock)
 {
+	unsigned int entries = io_sqring_entries(ctx);
 	int submitted = 0;
 
+	if (!entries)
+		return 0;
 	/* make sure SQ entry isn't read before tail */
-	nr = min3(nr, ctx->sq_entries, io_sqring_entries(ctx));
+	nr = min3(nr, ctx->sq_entries, entries);
 	if (!percpu_ref_tryget_many(&ctx->refs, nr))
 		return -EAGAIN;
 	io_get_task_refs(nr);
 
 	io_submit_state_start(&ctx->submit_state, nr);
-	while (submitted < nr) {
+	do {
 		const struct io_uring_sqe *sqe;
 		struct io_kiocb *req;
 
@@ -7261,7 +7264,7 @@ static int io_submit_sqes(struct io_ring_ctx *ctx, unsigned int nr)
 		submitted++;
 		if (io_submit_sqe(ctx, req, sqe))
 			break;
-	}
+	} while (submitted < nr);
 
 	if (unlikely(submitted != nr)) {
 		int ref_used = (submitted == -EAGAIN) ? 0 : submitted;
-- 
2.33.0

