Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9E9C1731DE
	for <lists+io-uring@lfdr.de>; Fri, 28 Feb 2020 08:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726816AbgB1Hhh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 28 Feb 2020 02:37:37 -0500
Received: from mail-wm1-f65.google.com ([209.85.128.65]:56289 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726740AbgB1Hhh (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 28 Feb 2020 02:37:37 -0500
Received: by mail-wm1-f65.google.com with SMTP id q9so2084798wmj.5
        for <io-uring@vger.kernel.org>; Thu, 27 Feb 2020 23:37:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=ZHj/hDvf/cca3hakeWVvMEln9l5fE1H946KoOEpyfuI=;
        b=IMS4EbZ2oCx3OjrPh/LqvPIo8ctVqRr2VwrW+C5W7CmI4OpH3l8qG524yXpyp2YkDg
         y+GV6jwvh3lrQSJQzx3NqnZh9XGTw+yQCyBCWcuzC60LZhIzCyA7rj38LeI4XtPoljDe
         8ZaWSRFG1QqFpxHNQazO+hGdaYVRQFe6P1yn9oJMeRwkTbpv9OhIvRFIDLjgL6JJZl9l
         wIvO2LpNS1ocIBJ5ly3hB77pP5JMUgtigJ96XYUzF7B1xwYmIJg4lNlX/TDzPjvkVga/
         W/gUvIkAplD1zAr+TH3NpbtSZ4b7mQIpnjQaWCS0Nib9DoXYiT1hWckSX+VHif8RNd53
         2cAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZHj/hDvf/cca3hakeWVvMEln9l5fE1H946KoOEpyfuI=;
        b=ByKnuwpfMWCkK1fsS5xTckmDRmt98/gho/gkA+c7xE8PJLh6RAzqGFWiPQKx75bfOr
         uTF3TRRBdaU+KovgJZj1mVaV7NvSHSZ9Yxo0Q1VNWeyj0KWSBEwdw/sBJxZesBO1gpqT
         dSyv9ogtTl8yBa5U12Nur9qWrfzQLwC4t4yHkvwudTuclKTkJ1VHBwr5UhgjHpYGk0bp
         4KMqNOrAK8nyz3CuRlnz2ac9tBiY5GNz30L3Pjsem/KjRB7B3cU03VM/uGWurzA1mrNl
         IdoKyT/AhprpGup7ElB6MXL5UP5KRy1sUYjAMcDoaZv5jzcrEc9PY3/CW3CiL2nN+NWs
         GdPA==
X-Gm-Message-State: APjAAAU9ZT9PkiwhxQSOnW8mBMTJZO2xJ7NuyBqnE88caebheZofi9ol
        9Wk6vmPxbIJLV6V4phVhpu3pPmHt
X-Google-Smtp-Source: APXvYqzqmpVx67HpjCZBV7ZEykkG+OPdnmeKvcurWfTvnwPlJrggvMPt1HxwwFaVeQnn7arSGi9ZjQ==
X-Received: by 2002:a05:600c:22d3:: with SMTP id 19mr3368800wmg.20.1582875455288;
        Thu, 27 Feb 2020 23:37:35 -0800 (PST)
Received: from localhost.localdomain ([109.126.130.242])
        by smtp.gmail.com with ESMTPSA id h2sm11369425wrt.45.2020.02.27.23.37.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Feb 2020 23:37:34 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/5] io_uring: clean io_poll_complete
Date:   Fri, 28 Feb 2020 10:36:35 +0300
Message-Id: <03a82a0acf501a8cbb1a9e1acf3fc394c1255839.1582874853.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1582874853.git.asml.silence@gmail.com>
References: <cover.1582874853.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Deduplicate call to io_cqring_fill_event(), plain and easy

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index d88346d4b781..87dfe397de74 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3636,10 +3636,7 @@ static void io_poll_complete(struct io_kiocb *req, __poll_t mask, int error)
 	struct io_ring_ctx *ctx = req->ctx;
 
 	req->poll.done = true;
-	if (error)
-		io_cqring_fill_event(req, error);
-	else
-		io_cqring_fill_event(req, mangle_poll(mask));
+	io_cqring_fill_event(req, error ? error : mangle_poll(mask));
 	io_commit_cqring(ctx);
 }
 
-- 
2.24.0

