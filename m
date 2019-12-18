Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 737D7124EF1
	for <lists+io-uring@lfdr.de>; Wed, 18 Dec 2019 18:18:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727024AbfLRRSw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 18 Dec 2019 12:18:52 -0500
Received: from mail-io1-f67.google.com ([209.85.166.67]:34655 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726996AbfLRRSw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 18 Dec 2019 12:18:52 -0500
Received: by mail-io1-f67.google.com with SMTP id z193so2800644iof.1
        for <io-uring@vger.kernel.org>; Wed, 18 Dec 2019 09:18:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=tj7dHKqVLn6iS+X38eNGiHhjp6IsTUIBSbDpe0xNxqc=;
        b=V4TBzfbE2B+Ww7xeFyFvfJ3uFb/aJeDjxl6WGmfE5Lg4SA6H6D5+R17Liq2IWBLjDO
         m+Oh8OHTrV8SZAKZHSH2eSz7GFqOOaWf0myL9tPd9xzC5/KPSoQvyxO4ifBi5Ag/Z7V4
         P4pdstME0dFsF/7AXOVreoTmoeMMLsSEs9mRwmsZlYSpVVqcLwYJBlzZJYPX8OBgm8R6
         XrG9jfVltxbozfAsEia9c6mh0acMD6l3VDGxcEM2T8uZZcEX15AasORv24KtCbTnscgB
         fFaTZ8aUDiuP9PbfKYr+ZXTd0e3JNiiw+3BnUFaQaur9NUpn3UlNIOfxU3uelY7Ps+Rv
         VjjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=tj7dHKqVLn6iS+X38eNGiHhjp6IsTUIBSbDpe0xNxqc=;
        b=A/CKUnPwTDlK83dpvU4AAq2u1XhZa3KBvdwqxc8pS+EMN8uEBspFggNQ4OH66O7O2B
         u8Yzmxcg8xpj42IhY73yeh4rNs9Zv6v+EPls7QV/ZlyfBp1iGwJXJtPL+4pT0FBi/V4G
         54n6lzX1EoVBF4GPzGS9Y4dal9B2S+sPTOVYn/ZsG6rENoKxdsJGhMDBmGTrZHOFIxxn
         VKz76HhtSDGrNOLyi6+qwTBEF5DJ3w4Coy00nPH0GZhzLoaak04C2Xv5p+7OBCgnA6q7
         la2rGYna9cWeUnwgwYlMgkrxahKy89pyA5ON+ElE0smZ8XIsCDJC2xZqF8UsntSIgMVD
         /EIg==
X-Gm-Message-State: APjAAAUZvkMjo19npFRVIl7aftqKQGCQkGx0VNYRbe/J6asUl24F86ie
        LjQigADH5+fzXU6IBLJHWKn/7FnWrl264A==
X-Google-Smtp-Source: APXvYqxX1+ucgYcb4Ktu6RpfM8j6RHWjiFTmRZsI3JKANvdRpcgiG3aM8yMLNZPU8NihnTv0OajfCg==
X-Received: by 2002:a5e:9617:: with SMTP id a23mr2406091ioq.243.1576689531201;
        Wed, 18 Dec 2019 09:18:51 -0800 (PST)
Received: from x1.thefacebook.com ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id o12sm577488ioh.42.2019.12.18.09.18.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Dec 2019 09:18:50 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 09/13] io_uring: make IORING_OP_CANCEL_ASYNC deferrable
Date:   Wed, 18 Dec 2019 10:18:31 -0700
Message-Id: <20191218171835.13315-10-axboe@kernel.dk>
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
the SQE data has been read upfront. Integrate the async cancel op into
the prep handling to make it safe for SQE reuse.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 32 ++++++++++++++++++++++++++++----
 1 file changed, 28 insertions(+), 4 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index aa5d6232c536..5ae8408a0240 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -321,6 +321,11 @@ struct io_sync {
 	int				flags;
 };
 
+struct io_cancel {
+	struct file			*file;
+	u64				addr;
+};
+
 struct io_async_connect {
 	struct sockaddr_storage		address;
 };
@@ -362,6 +367,7 @@ struct io_kiocb {
 		struct io_poll_iocb	poll;
 		struct io_accept	accept;
 		struct io_sync		sync;
+		struct io_cancel	cancel;
 	};
 
 	const struct io_uring_sqe	*sqe;
@@ -3016,18 +3022,33 @@ static void io_async_find_and_cancel(struct io_ring_ctx *ctx,
 	io_put_req_find_next(req, nxt);
 }
 
-static int io_async_cancel(struct io_kiocb *req, struct io_kiocb **nxt)
+static int io_async_cancel_prep(struct io_kiocb *req)
 {
 	const struct io_uring_sqe *sqe = req->sqe;
-	struct io_ring_ctx *ctx = req->ctx;
 
-	if (unlikely(ctx->flags & IORING_SETUP_IOPOLL))
+	if (req->flags & REQ_F_PREPPED)
+		return 0;
+	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
 	if (sqe->flags || sqe->ioprio || sqe->off || sqe->len ||
 	    sqe->cancel_flags)
 		return -EINVAL;
 
-	io_async_find_and_cancel(ctx, req, READ_ONCE(sqe->addr), nxt, 0);
+	req->flags |= REQ_F_PREPPED;
+	req->cancel.addr = READ_ONCE(sqe->addr);
+	return 0;
+}
+
+static int io_async_cancel(struct io_kiocb *req, struct io_kiocb **nxt)
+{
+	struct io_ring_ctx *ctx = req->ctx;
+	int ret;
+
+	ret = io_async_cancel_prep(req);
+	if (ret)
+		return ret;
+
+	io_async_find_and_cancel(ctx, req, req->cancel.addr, nxt, 0);
 	return 0;
 }
 
@@ -3085,6 +3106,9 @@ static int io_req_defer_prep(struct io_kiocb *req)
 	case IORING_OP_TIMEOUT:
 		ret = io_timeout_prep(req, io, false);
 		break;
+	case IORING_OP_ASYNC_CANCEL:
+		ret = io_async_cancel_prep(req);
+		break;
 	case IORING_OP_LINK_TIMEOUT:
 		ret = io_timeout_prep(req, io, true);
 		break;
-- 
2.24.1

