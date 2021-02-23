Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8862E3223FB
	for <lists+io-uring@lfdr.de>; Tue, 23 Feb 2021 03:01:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230511AbhBWCBM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Feb 2021 21:01:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231164AbhBWCBJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Feb 2021 21:01:09 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09D7BC0617A9
        for <io-uring@vger.kernel.org>; Mon, 22 Feb 2021 17:59:58 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id n10so968678wmq.0
        for <io-uring@vger.kernel.org>; Mon, 22 Feb 2021 17:59:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=zARydy9KHa4zMucJQtXXaOrdZ1S+MqX74XtLfxKfPvM=;
        b=KazqUSYPBDqJ47JZSJ8kpeqeJGVHJUhivY2xCYlBIF+MOimYD26cbv4uziXJ5Zlhmx
         +qFGGT6vUlp5xaZ+muQja7BzKibd9B9j2+FLy5b0BBAk0BjnWKLYxzkMonqlY/mhmY7C
         A2q9rfpY9QwaJvXmOqbbCUFPBFbaK8QgzrF47SKAEM9juo9L57nd7Dq9N0A2VDU7DgiG
         oWwYakZmzOoOJJa42Psyigdkd83lS9KU61ZlxmZaZYz9WfoBhWUKWWocroQJPPt83ShH
         JjnAdT8Hg3ykxVgN/W+VwSq4mgdwg8kTfcfP2bDKZBiZw6OYk12OTqDNiKJ2slj6twbN
         GxoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zARydy9KHa4zMucJQtXXaOrdZ1S+MqX74XtLfxKfPvM=;
        b=JaZhV/EBPOpmCoAPssrmcM9CYRB/SHwpxKFaTAdTPVzbTi4hWJxeUk/8SzlUaCRnVe
         W5piFMYQ31Znxb6xpqQ/FiwURH1vmJvDdQ8w2CTHJCsvu+AwRpSXnkzysiiGi+79DYli
         ZtiSIljTHfavCaael4alZF342jLXp9WZqlBiYoD7j4RiOJTeoJPjvPWH93Am7taE9en2
         0UsHUv8/eAeoSgUmbOKClaa5rY6G8Pluux6fQwR3GoV0Yf8QivTB9SgL5l25vOr6FYWK
         wYSNXN9VR0uHbBLMlFgs5nd15td4sqqBTQmJ6jv/Wv3iyC14l6pVAsGRInW0Zlt0Y8On
         tsNw==
X-Gm-Message-State: AOAM532fa5YjaHiIWOYAxTcmkghNaqIyyuIS6tOwO8ANEj7ebVVHJDTk
        6tbzejsFFunoPFY3C1Dv+fGxBHNS3Mk=
X-Google-Smtp-Source: ABdhPJxCdP703NygSDRQ2aSYvMvtXb7a/N7h10OjhtAJXgQalEofCAaYIhrW5WSUegMs2iZtkok69A==
X-Received: by 2002:a05:600c:210f:: with SMTP id u15mr5833172wml.119.1614045596825;
        Mon, 22 Feb 2021 17:59:56 -0800 (PST)
Received: from localhost.localdomain ([148.252.132.56])
        by smtp.gmail.com with ESMTPSA id 4sm32425501wrr.27.2021.02.22.17.59.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 17:59:56 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 10/13] io_uring: untie alloc_async_data and needs_async_data
Date:   Tue, 23 Feb 2021 01:55:45 +0000
Message-Id: <54ef00e365c9f4dd89f396be72c1387039277ba5.1614045169.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1614045169.git.asml.silence@gmail.com>
References: <cover.1614045169.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

All opcode handlers pretty well know whether they need async data or
not, and can skip testing for needs_async_data. The exception is rw
the generic path, but those test the flag by hand anyway. So, check the
flag and make io_alloc_async_data() allocating unconditionally.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 14 +++-----------
 1 file changed, 3 insertions(+), 11 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b3585226bfb5..8f25371ae904 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3105,21 +3105,13 @@ static void io_req_map_rw(struct io_kiocb *req, const struct iovec *iovec,
 	}
 }
 
-static inline int __io_alloc_async_data(struct io_kiocb *req)
+static inline int io_alloc_async_data(struct io_kiocb *req)
 {
 	WARN_ON_ONCE(!io_op_defs[req->opcode].async_size);
 	req->async_data = kmalloc(io_op_defs[req->opcode].async_size, GFP_KERNEL);
 	return req->async_data == NULL;
 }
 
-static int io_alloc_async_data(struct io_kiocb *req)
-{
-	if (!io_op_defs[req->opcode].needs_async_data)
-		return 0;
-
-	return  __io_alloc_async_data(req);
-}
-
 static int io_setup_async_rw(struct io_kiocb *req, const struct iovec *iovec,
 			     const struct iovec *fast_iov,
 			     struct iov_iter *iter, bool force)
@@ -3127,7 +3119,7 @@ static int io_setup_async_rw(struct io_kiocb *req, const struct iovec *iovec,
 	if (!force && !io_op_defs[req->opcode].needs_async_data)
 		return 0;
 	if (!req->async_data) {
-		if (__io_alloc_async_data(req)) {
+		if (io_alloc_async_data(req)) {
 			kfree(iovec);
 			return -ENOMEM;
 		}
@@ -5814,7 +5806,7 @@ static int io_req_defer_prep(struct io_kiocb *req)
 	/* some opcodes init it during the inital prep */
 	if (req->async_data)
 		return 0;
-	if (__io_alloc_async_data(req))
+	if (io_alloc_async_data(req))
 		return -EAGAIN;
 	return io_req_prep_async(req);
 }
-- 
2.24.0

