Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AFAF1E2916
	for <lists+io-uring@lfdr.de>; Tue, 26 May 2020 19:38:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389277AbgEZRfs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 26 May 2020 13:35:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389264AbgEZRfr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 26 May 2020 13:35:47 -0400
Received: from mail-ed1-x542.google.com (mail-ed1-x542.google.com [IPv6:2a00:1450:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ABB2C03E96D;
        Tue, 26 May 2020 10:35:46 -0700 (PDT)
Received: by mail-ed1-x542.google.com with SMTP id g9so18336310edw.10;
        Tue, 26 May 2020 10:35:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=oRCoOKG6n792Uft3QuY79MALpzXxmbefAeR0TN6gqZ8=;
        b=r0kP3mGG7xRmIHhVugzcGvdtsWvbm8focNbE9sZrFhvWyotDQ+wGkGHXMSONQliGwy
         QlzJ9iu+2s2Zn6l3zuW6qZP7x6aBh4udTR75PYcOiIIZpQReYEZZBLJCXcgNoUt5gBDL
         vwQRIeqINPBsQgaf67G6pM+N4aEO4j5SCZhJZ9jKWcvaUinuoMZ9O+Q+wMZVfaJk72O7
         5DBbqDehDJexG1PFpxX1hfWMGl+uzFe6+CIWnCLTWN7EZGmSLdiLakB/r4a1YZClScfq
         ipeE3w21lTkbpLxIPc2SiaLrd3ltNoiFhyESsxsQCxhCnUbv/6uPqF/EEC19Y6YoOkz2
         L6Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oRCoOKG6n792Uft3QuY79MALpzXxmbefAeR0TN6gqZ8=;
        b=ZOJNNn/ddTmGIskr5vQAbVUvJVBEcv6fRx0fO91iZFNM9mHb4WtSs0HZAP6APkY7b+
         E9MagbqmO428spFaxbLYWLg0w00VGag4J8ElsecZaaokq+vEnW932hy7GjNTrj6ysndb
         WQFF/JmliSpPOKvlQ4Cr+JbnhbVzcIvYuWNoGNdG2xNjMe2wOxgCISiluIZNrmz0td1k
         xBKgO5zeu93PlGd6LfnK59ATzsvWCKQ1cEhukpItO1ParloBmeDu56BcY+W990l5RLhR
         FOiGBfFxkb0NmgX75RQT3VkY0YzdfeAGeaspw118b/rzYXA1ELF28lDV/vCTwsxRkOJc
         KlOA==
X-Gm-Message-State: AOAM5317r9739Cs0R04tyfCWl4kG3pnnA9TmA9ZKPKo9/GErMudPo1sZ
        AEZpFK1XTwA0BVHVkCRNUJw=
X-Google-Smtp-Source: ABdhPJzjCxU7PesLbJdA1/9IXSNHs/HY1FQ9SVbQm/7CnleQDzyF+ggew1QbmLvhUJnk9mZ7n8tZKA==
X-Received: by 2002:a05:6402:1547:: with SMTP id p7mr20485077edx.31.1590514545098;
        Tue, 26 May 2020 10:35:45 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.151])
        by smtp.gmail.com with ESMTPSA id bz8sm391326ejc.94.2020.05.26.10.35.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 May 2020 10:35:44 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/6] io_uring: don't re-read sqe->off in timeout_prep()
Date:   Tue, 26 May 2020 20:34:04 +0300
Message-Id: <dfb9555d60282d5c8f5eb43d70af0e5980f32ab3.1590513806.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1590513806.git.asml.silence@gmail.com>
References: <cover.1590513806.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

SQEs are user writable, don't read sqe->off twice in io_timeout_prep()

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e30fc17dd268..067ebdeb1ba4 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4803,18 +4803,19 @@ static int io_timeout_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 {
 	struct io_timeout_data *data;
 	unsigned flags;
+	u32 off = READ_ONCE(sqe->off);
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
 	if (sqe->ioprio || sqe->buf_index || sqe->len != 1)
 		return -EINVAL;
-	if (sqe->off && is_timeout_link)
+	if (off && is_timeout_link)
 		return -EINVAL;
 	flags = READ_ONCE(sqe->timeout_flags);
 	if (flags & ~IORING_TIMEOUT_ABS)
 		return -EINVAL;
 
-	req->timeout.count = READ_ONCE(sqe->off);
+	req->timeout.count = off;
 
 	if (!req->io && io_alloc_async_ctx(req))
 		return -ENOMEM;
-- 
2.24.0

