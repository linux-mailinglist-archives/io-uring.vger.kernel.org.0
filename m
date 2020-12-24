Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0FB0D2E23DC
	for <lists+io-uring@lfdr.de>; Thu, 24 Dec 2020 04:03:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728357AbgLXDDO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Dec 2020 22:03:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728334AbgLXDDN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Dec 2020 22:03:13 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF344C061794;
        Wed, 23 Dec 2020 19:02:33 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id m6so529619pfm.6;
        Wed, 23 Dec 2020 19:02:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=GRMfSD0hOG9tGug8egu8jwvDbLH93zJrtHkBnX2vV9I=;
        b=Z0oLgouTFdXuyGtg3YRd4GkY/0DP87nE/EIebJcea1UvIe6pUiAGXeVU4FQoaOAs5f
         C+YuZRmiBmC2kVlei7ZeYpjUtiflWut6gqg2SJk0KUmjlT4Sesu/lGwdMKRcNuAJX3iv
         F4g6UAMKUB7VvQ+bWAgUEse9n8lp+NQKUxTscj06pkJavh6NrgNvfE4jvV8lSEftFIJ6
         n6nLIYcsoP9uwZb9KP/SXLELWfzWZD/UmqfTWkV/tHBOAfZpW/eJ8UJ8XQtQB48gZ+J7
         ErcBarHjSop578bk1/kXo3fFEhE1K4LcE7LqWHcDx6D7lHZBRVSItZW/Df5EgjmpS9In
         M89A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=GRMfSD0hOG9tGug8egu8jwvDbLH93zJrtHkBnX2vV9I=;
        b=hCVQVI3z4V4pUCNNFvd7dNOCBizMibx4CxGyKeCQHAwbMVSTa4uPXgC8Z4VcYMnieU
         uZysxywZlCqPY0t8ER8QpZyEX/Vg1BJ/6BfBov/clEobfDxcroonwa2Yd18E29sMsEwq
         1K/hATq23A5wRuKgGOSySRZK9Tru3BOzEWWDjRfqDVOflAEzCzTXfngmJYliN9wTqayT
         hKs8hZP7HOF+/FhplDe22m1xA3ajPp5p/eepuYPQasISGJ5571BhfL8ykIF8gEOnfFiq
         7o4GMC0UNljcESfzMclLDXilkiANy09GV9GvJZQdK5vrjPqblXeELz7bAuy86LQdGFbX
         oLfA==
X-Gm-Message-State: AOAM530VA53+7pEONpHVPXUFm54Nu1Mb3nuiPUbWzJa3/fYFnrHhzG64
        cZui8GXsQWhaoxYCXQxaaevEiAMWnhfdYw==
X-Google-Smtp-Source: ABdhPJz4X+b8KpmudA+s1pPDzRtlNMnvrrvdTgWQUE4t76ncjObyc21IZQbwdVSpBNZuyflQbDaFNA==
X-Received: by 2002:a63:e246:: with SMTP id y6mr26674222pgj.412.1608778953280;
        Wed, 23 Dec 2020 19:02:33 -0800 (PST)
Received: from localhost.localdomain ([122.10.161.207])
        by smtp.gmail.com with ESMTPSA id k125sm22153751pga.57.2020.12.23.19.02.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 23 Dec 2020 19:02:32 -0800 (PST)
From:   Yejune Deng <yejune.deng@gmail.com>
To:     viro@zeniv.linux.org.uk, axboe@kernel.dk
Cc:     linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org, yejune.deng@gmail.com
Subject: [PATCH] io_uring: simplify io_remove_personalities()
Date:   Thu, 24 Dec 2020 11:02:20 +0800
Message-Id: <1608778940-16049-1-git-send-email-yejune.deng@gmail.com>
X-Mailer: git-send-email 1.9.1
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

The function io_remove_personalities() is very similar to
io_unregister_personality(),so implement io_remove_personalities()
calling io_unregister_personality().

Signed-off-by: Yejune Deng <yejune.deng@gmail.com>
---
 fs/io_uring.c | 28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index b749578..dc913fa 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8608,9 +8608,8 @@ static int io_uring_fasync(int fd, struct file *file, int on)
 	return fasync_helper(fd, file, on, &ctx->cq_fasync);
 }
 
-static int io_remove_personalities(int id, void *p, void *data)
+static int io_unregister_personality(struct io_ring_ctx *ctx, unsigned id)
 {
-	struct io_ring_ctx *ctx = data;
 	struct io_identity *iod;
 
 	iod = idr_remove(&ctx->personality_idr, id);
@@ -8618,7 +8617,17 @@ static int io_remove_personalities(int id, void *p, void *data)
 		put_cred(iod->creds);
 		if (refcount_dec_and_test(&iod->count))
 			kfree(iod);
+		return 0;
 	}
+
+	return -EINVAL;
+}
+
+static int io_remove_personalities(int id, void *p, void *data)
+{
+	struct io_ring_ctx *ctx = data;
+
+	io_unregister_personality(ctx, id);
 	return 0;
 }
 
@@ -9679,21 +9688,6 @@ static int io_register_personality(struct io_ring_ctx *ctx)
 	return ret;
 }
 
-static int io_unregister_personality(struct io_ring_ctx *ctx, unsigned id)
-{
-	struct io_identity *iod;
-
-	iod = idr_remove(&ctx->personality_idr, id);
-	if (iod) {
-		put_cred(iod->creds);
-		if (refcount_dec_and_test(&iod->count))
-			kfree(iod);
-		return 0;
-	}
-
-	return -EINVAL;
-}
-
 static int io_register_restrictions(struct io_ring_ctx *ctx, void __user *arg,
 				    unsigned int nr_args)
 {
-- 
1.9.1

