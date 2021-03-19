Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F261C3419DF
	for <lists+io-uring@lfdr.de>; Fri, 19 Mar 2021 11:26:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229648AbhCSKZm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 19 Mar 2021 06:25:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229469AbhCSKZ1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 19 Mar 2021 06:25:27 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 910D8C06174A
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 03:25:26 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id o16so8561180wrn.0
        for <io-uring@vger.kernel.org>; Fri, 19 Mar 2021 03:25:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aCNY79cPDb1zaO+eg+dDtiYN6W1XJ16wUZtp8byX9LE=;
        b=Zj9OZWntiH3ll3+pi8P0LWnhOTcjSC2WTzeapmkhjtNFbfJ2jxBBjx87pHNwheJWTQ
         BgbyDr78tmfGrU2Gz0oGye9QfyteySSSmkiFreos8j5ROQBXuShkA8wYiEEtwapewkvG
         /fpHNf6tp3S+kvAwjUpz+b1E1bfykVrClUyRNVQzvYz6Z8oXCQN1CRXO/kcC0QuLO5lE
         z395u9X7t7F881rmyWe9zChNeQsRwK0Vrv8F9okiNHXO6sUJRZiGCqHIQiuXQyh5Myno
         MsjYZQfK/GQGSTpa3yepi0PAD1NEwBV+dQ3EGsdFPxRjTa17JNSb/NVfezHFO9PwVwOO
         Kl1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=aCNY79cPDb1zaO+eg+dDtiYN6W1XJ16wUZtp8byX9LE=;
        b=O58F9GDPP8RMEXmBgh3HQe+ONDwWn9LniG7Ge3Ys/1P2HSSEhqjFDYpAfOZkFuYIec
         AW0p5OlM9LP6/TKVfj2CutK+MmWIRmSt0gYqgfsb8NWMjsfY4oh/mNuueHD/f1PdnbKu
         yig9lJlRsotlFQnKHYAx4Ug43egcBeOgxHenHwkyaWkyx5fjgGfQcuJN8baAYidLADIH
         1ucegHQkZzfJGz1oNEz5Gc+lCh5ZUpbEs2oxK8xMbyGUWxcGe7SEtns7foE1XcL8Uvka
         COeB7SR8oRGkl7tuVtpAclU/ehPbU3hoVHsJ2TuXD6t56lwZQWJ3DUxCNFQfa3Q1idDo
         gnVQ==
X-Gm-Message-State: AOAM530+N2aZ3Xa4cGQygKZR897Vw6OPrpoiz1QyWw0Ojy4vuiIwln8R
        izsaskBISwqvlEc4JBpWXNbSldy+XE8=
X-Google-Smtp-Source: ABdhPJxevBK+J8tAw4rz41+zh2FNY2OUEgCcYpBvYJEBZ98U2NBq+kZ6wdAJu7AOhHpPgADiR/80JQ==
X-Received: by 2002:adf:ebc9:: with SMTP id v9mr3772849wrn.387.1616149525135;
        Fri, 19 Mar 2021 03:25:25 -0700 (PDT)
Received: from localhost.localdomain ([185.69.144.156])
        by smtp.gmail.com with ESMTPSA id k11sm5749148wmj.1.2021.03.19.03.25.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 03:25:24 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Colin Ian King <colin.king@canonical.com>
Subject: [PATCH] io_uring: fix provide_buffers sign extension
Date:   Fri, 19 Mar 2021 10:21:19 +0000
Message-Id: <562376a39509e260d8532186a06226e56eb1f594.1616149233.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_provide_buffers_prep()'s "p->len * p->nbufs" to sign extension
problems. Not a huge problem as it's only used for access_ok() and
increases the checked length, but better to keep typing right.

Reported-by: Colin Ian King <colin.king@canonical.com>
Fixes: efe68c1ca8f49 ("io_uring: validate the full range of provided buffers for access")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c2489b463eb9..4f1c98502a09 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3978,6 +3978,7 @@ static int io_remove_buffers(struct io_kiocb *req, unsigned int issue_flags)
 static int io_provide_buffers_prep(struct io_kiocb *req,
 				   const struct io_uring_sqe *sqe)
 {
+	unsigned long size;
 	struct io_provide_buf *p = &req->pbuf;
 	u64 tmp;
 
@@ -3991,7 +3992,8 @@ static int io_provide_buffers_prep(struct io_kiocb *req,
 	p->addr = READ_ONCE(sqe->addr);
 	p->len = READ_ONCE(sqe->len);
 
-	if (!access_ok(u64_to_user_ptr(p->addr), (p->len * p->nbufs)))
+	size = (unsigned long)p->len * p->nbufs;
+	if (!access_ok(u64_to_user_ptr(p->addr), size))
 		return -EFAULT;
 
 	p->bgid = READ_ONCE(sqe->buf_group);
-- 
2.24.0

