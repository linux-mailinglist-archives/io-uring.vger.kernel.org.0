Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FD38124EF2
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2019 18:18:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727030AbfLRRSx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Dec 2019 12:18:53 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:36706 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726996AbfLRRSx (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Dec 2019 12:18:53 -0500
Received: by mail-io1-f67.google.com with SMTP id r13so2794152ioa.3
        for <io-uring@vger.kernel.org>; Wed, 18 Dec 2019 09:18:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=iHPiskbCZfPIW2GflonUQH3yV+ITStqgSkUt84nkGBA=;
        b=Hyf+mAysWji/9vgA2dorDWoelyi1wNbojm7bADQTbhkriqJjIRb6YNrpyrexAYRdk4
         MiRsqYlpBCi6kO2Cyd3/CGFN9KlAbUdqYWYgRDAb3fdyCe9Ogisfk7QXRYkdLBykaqYZ
         ME/6xZn9zAaCJXO4bDyPUbobDsnxa1fIMVR9K5Gd8z6swb7p/9jmoBY8Dk8hxXk0kcJJ
         CSsp0rLMzUmSn4I0Ijq5KGyrGklkU9mBacbXBFyzWVXtijVLT+bDyhLDIri3jcE9lnZt
         IG05FBF1zm3Lxzqqi8Ndb2QdO1vP9X/pWBLSO2xSd9RKaMQVgpc59i1DVXjUUq6ExrXv
         fUTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iHPiskbCZfPIW2GflonUQH3yV+ITStqgSkUt84nkGBA=;
        b=P469V69j1hOZ8zdYgXupW73jy0vHJ2OBmccPLLBPdN1RsRuR5Rg56K9SyF6xjfNH2F
         G5WzGFm3vUb5+F/QxERwTSsaknaTG9/R6o7t9zAcKtI9IntgY0Tc+ah2saVHrPYcaVL6
         Pnw2GUEJQghOPVfjMGzzeaBAGIZfcaBWxNDpM+6pUrEej8LqlB2rZeGt1+e1e96BeB8J
         JJqzoxwch8RnNTdKG4xWHVS7YpsXCPEAc0XihgKx/M3WDOtSymV6+9kNqveENp7Dv+9Y
         P1jAet2vCPz2gRyCgXru+d1pDYP1XFOYurUWjAAo9uq1gVTWRmTGjmonuwGYX5C6HChS
         BbaQ==
X-Gm-Message-State: APjAAAWcxCu8tWUbLV4zaLwbwyYdP06vwTEFZHI8y+01E2EIMs8PWlAO
        yYw0V2oHjpE1NVS6pCAH4DKl0aE7DbG44w==
X-Google-Smtp-Source: APXvYqy7zvH9/tkYjWSw6H6cW/lg1cCzp/lBaCKIdQVIDhcGRzijP0cS31aQn65erbd/YPzaxXVVtg==
X-Received: by 2002:a5e:920a:: with SMTP id y10mr2552787iop.292.1576689532089;
        Wed, 18 Dec 2019 09:18:52 -0800 (PST)
Received: from x1.thefacebook.com ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id o12sm577488ioh.42.2019.12.18.09.18.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 09:18:51 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 10/13] io_uring: make IORING_OP_TIMEOUT_REMOVE deferrable
Date:   Wed, 18 Dec 2019 10:18:32 -0700
Message-Id: <20191218171835.13315-11-axboe@kernel.dk>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191218171835.13315-1-axboe@kernel.dk>
References: <20191218171835.13315-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

If we defer this command as part of a link, we have to make sure that
the SQE data has been read upfront. Integrate the timeout remove op into
the prep handling to make it safe for SQE reuse.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 44 ++++++++++++++++++++++++++++++++++----------
 1 file changed, 34 insertions(+), 10 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 5ae8408a0240..c269229e45ef 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -326,6 +326,12 @@ struct io_cancel {
 	u64				addr;
 };
 
+struct io_timeout {
+	struct file			*file;
+	u64				addr;
+	int				flags;
+};
+
 struct io_async_connect {
 	struct sockaddr_storage		address;
 };
@@ -368,6 +374,7 @@ struct io_kiocb {
 		struct io_accept	accept;
 		struct io_sync		sync;
 		struct io_cancel	cancel;
+		struct io_timeout	timeout;
 	};
 
 	const struct io_uring_sqe	*sqe;
@@ -2816,26 +2823,40 @@ static int io_timeout_cancel(struct io_ring_ctx *ctx, __u64 user_data)
 	return 0;
 }
 
+static int io_timeout_remove_prep(struct io_kiocb *req)
+{
+	const struct io_uring_sqe *sqe = req->sqe;
+
+	if (req->flags & REQ_F_PREPPED)
+		return 0;
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
+		return -EINVAL;
+	if (sqe->flags || sqe->ioprio || sqe->buf_index || sqe->len)
+		return -EINVAL;
+
+	req->timeout.addr = READ_ONCE(sqe->addr);
+	req->timeout.flags = READ_ONCE(sqe->timeout_flags);
+	if (req->timeout.flags)
+		return -EINVAL;
+
+	req->flags |= REQ_F_PREPPED;
+	return 0;
+}
+
 /*
  * Remove or update an existing timeout command
  */
 static int io_timeout_remove(struct io_kiocb *req)
 {
-	const struct io_uring_sqe *sqe = req->sqe;
 	struct io_ring_ctx *ctx = req->ctx;
-	unsigned flags;
 	int ret;
 
-	if (unlikely(ctx->flags & IORING_SETUP_IOPOLL))
-		return -EINVAL;
-	if (sqe->flags || sqe->ioprio || sqe->buf_index || sqe->len)
-		return -EINVAL;
-	flags = READ_ONCE(sqe->timeout_flags);
-	if (flags)
-		return -EINVAL;
+	ret = io_timeout_remove_prep(req);
+	if (ret)
+		return ret;
 
 	spin_lock_irq(&ctx->completion_lock);
-	ret = io_timeout_cancel(ctx, READ_ONCE(sqe->addr));
+	ret = io_timeout_cancel(ctx, req->timeout.addr);
 
 	io_cqring_fill_event(req, ret);
 	io_commit_cqring(ctx);
@@ -3106,6 +3127,9 @@ static int io_req_defer_prep(struct io_kiocb *req)
 	case IORING_OP_TIMEOUT:
 		ret = io_timeout_prep(req, io, false);
 		break;
+	case IORING_OP_TIMEOUT_REMOVE:
+		ret = io_timeout_remove_prep(req);
+		break;
 	case IORING_OP_ASYNC_CANCEL:
 		ret = io_async_cancel_prep(req);
 		break;
-- 
2.24.1

