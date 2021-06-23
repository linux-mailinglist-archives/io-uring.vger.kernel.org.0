Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD6953B1D82
	for <lists+io-uring@lfdr.de>; Wed, 23 Jun 2021 17:18:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231390AbhFWPUR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Jun 2021 11:20:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231381AbhFWPUQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Jun 2021 11:20:16 -0400
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A6D7C061756
        for <io-uring@vger.kernel.org>; Wed, 23 Jun 2021 08:17:58 -0700 (PDT)
Received: by mail-io1-xd30.google.com with SMTP id b7so3858090ioq.12
        for <io-uring@vger.kernel.org>; Wed, 23 Jun 2021 08:17:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=t4u/kAIed02Wt2quW7e3LI/PP2g01D4YOTswdqhIIpU=;
        b=0Kz+1xf251hAIyz/tmodU2ANxxhCQImhGaTGJisZQsT+f2DLwEPvIfDXQdUe9U6RBM
         MCsR9sxkasM48cgBikgv5LujHLn3XCVFuce3I5lM6ElJjnMfg69DSJkhQ6I0piB7G7Jm
         rgij5/qp/UzLhz76d5NcGnqP7Z371FpiMxGdPaTdB/c6r9TNVVdfs2OhdoJEJzwVg++z
         eU12O+nu/AnvkkkwIcIy55qTQKD7GMHGcDIc/RK1EVSNhJ0AHXjkznTPvblfFmvUQi+X
         l8Hr0n1w7dcNO/xf3a1RO0xyTmgBKkUr1fJqyOytxIyf54nc7pE9rBYFZN4jUM6DI39i
         pkaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=t4u/kAIed02Wt2quW7e3LI/PP2g01D4YOTswdqhIIpU=;
        b=r6QqZPENymDgr+aTqzBr9fM0V4CkQMdMdfhOY/zykVYUL3KOGEUpk734mKXq4XTZTY
         X8gtCsREHcQIJR6ihEHN9MqePwYm1UMk1gDJ4ZnKwR9dOAltQghX4kedqnoppfFrJZkU
         zqfs1inZmFxtyEn3nC900DW4Ua/EkWvEJLtgZVZKbLH+lrJBS5OSV2Ci+BKqZnShER7o
         5E6PADWq6eYvXg0zUofz4/r6ef+Xjt4monlz8K8uZ0qaFuBgqMyOCUt3bPzCX9OXhdGh
         +6Q/PyRg/rvATG7jstQBLdP3mHGDlQ2shOoMwjGP4SGY653ppyA7z4bENIPvNOfu3RG1
         7m1g==
X-Gm-Message-State: AOAM532Qjlw6jAXnuPp3J4KejDPDthY1XMVtsxboaLVby2Ce8PyT+HL3
        b9iGZOXAMIF7bA13RA0wfV9Io6YqqsLKIw==
X-Google-Smtp-Source: ABdhPJzRrS+RO4qUS2hpKc9YqL+Rp8OwAXaMyZd3Jiyk/3xYMaBIJpOPhvxUv/tadXJKszJym0cuzQ==
X-Received: by 2002:a02:c906:: with SMTP id t6mr82100jao.117.1624461477435;
        Wed, 23 Jun 2021 08:17:57 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.61])
        by smtp.gmail.com with ESMTPSA id t6sm97967ils.72.2021.06.23.08.17.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Jun 2021 08:17:57 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     dkadashev@gmail.com, Jens Axboe <axboe@kernel.dk>,
        stable@vger.kernel.org
Subject: [PATCH 2/2] io_uring: add IOPOLL and reserved field checks to IORING_OP_UNLINKAT
Date:   Wed, 23 Jun 2021 09:17:53 -0600
Message-Id: <20210623151753.191481-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210623151753.191481-1-axboe@kernel.dk>
References: <20210623151753.191481-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We can't support IOPOLL with non-pollable request types, and we should
check for unused/reserved fields like we do for other request types.

Fixes: 14a1143b68ee ("io_uring: add support for IORING_OP_UNLINKAT")
Cc: stable@vger.kernel.org
Reported-by: Dmitry Kadashev <dkadashev@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 9b6c7dad0b73..45c606846303 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3504,6 +3504,10 @@ static int io_unlinkat_prep(struct io_kiocb *req,
 	struct io_unlink *un = &req->unlink;
 	const char __user *fname;
 
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
+	if (sqe->ioprio || sqe->off || sqe->len || sqe->buf_index)
+		return -EINVAL;
 	if (unlikely(req->flags & REQ_F_FIXED_FILE))
 		return -EBADF;
 
-- 
2.32.0

