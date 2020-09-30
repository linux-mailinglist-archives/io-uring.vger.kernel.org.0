Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1E8527F2D3
	for <lists+io-uring@lfdr.de>; Wed, 30 Sep 2020 22:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730155AbgI3UAp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 30 Sep 2020 16:00:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725355AbgI3UAp (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 30 Sep 2020 16:00:45 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F242C0613D0
        for <io-uring@vger.kernel.org>; Wed, 30 Sep 2020 13:00:45 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id z4so3147641wrr.4
        for <io-uring@vger.kernel.org>; Wed, 30 Sep 2020 13:00:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=+13bri0T5NHswPhOGy5ksqOWWkx3uzzOza/jEFJpg+w=;
        b=c8JHbd+7XESRvRtlTXVZb2a13RTvVXVG+ywPEmNJzQhCTOMcaIi3GYPhUAHuXT90wA
         ixlJhjq3HL5o5Ao4h4OyEkZ660rxp1OQk7w5PiDKlFIOYoCyjtHgZTXh5Y1mGoLM79VO
         udfJUASyr54EJqIh+DFRa45jTZBdQLv5e7Bk3zmobKD1NF2GiPI13uJxp1hmOUrQA3DJ
         QlmSN3nhEq/tQthGRaXwulBFfHpP/LKTi2NzmiiGrYSIPJuSHNGQH6vJ9rWgdCgKcH5U
         0DXWN03VbXRqJEsKWz4ZC4QttlIK+ZhbIKfgLpKimPfIaa3qLdAEsOPaIn4Kzfz5CqsM
         3e3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+13bri0T5NHswPhOGy5ksqOWWkx3uzzOza/jEFJpg+w=;
        b=skz5n9vG3ibk5QvBOiHQP9MDkTgz9fvRL/lVB6HQ9NAQBvHWFQtSvxG3TtzMBgp6Z0
         AL+kYN9OoH6XWJG5avWPJmUfhwXR2P2ILG46USrAZreO4Rby9S/5p6J6qrD60oOQNqws
         jnw24jVm5NiXRmgONm84DxOgwQyMmag3pyyjFLUHpdD74Xxmas9GzLnycQnTGT3BI0pc
         pPtMX2+KhoomKPA/wDVWXbGgwRuKD251WJz+X2BWBPyzowhqUbBCg3keHXbLXtzt1WlH
         nUrJ6s0ZsP+0jEIY0uakCTXdl8mdYZq1XUXBT01BY422HG09FGZOt8QrdrSC/GHq8wKY
         Oi0Q==
X-Gm-Message-State: AOAM532cJU7Ielm4XLrUFzSGVGCGFqi84RORediJeBRuPe0/mq54Poy+
        Q2gLGDdF/wKzyLbtPprh6ho=
X-Google-Smtp-Source: ABdhPJwxOeoxocH9UKzIi1IIYBbFN1AN65rTIK+ai0MamTQorVLFgzv/UF4bKXRLju1LbkQh9VE5Jw==
X-Received: by 2002:adf:df05:: with SMTP id y5mr5251559wrl.39.1601496043841;
        Wed, 30 Sep 2020 13:00:43 -0700 (PDT)
Received: from localhost.localdomain (host109-152-100-194.range109-152.btcentralplus.com. [109.152.100.194])
        by smtp.gmail.com with ESMTPSA id x17sm5127176wrg.57.2020.09.30.13.00.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2020 13:00:43 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 2/4] io_uring: remove nonblock arg from io_{rw}_prep()
Date:   Wed, 30 Sep 2020 22:57:54 +0300
Message-Id: <8067400436133d16931c5c8c29363b43ce182993.1601495335.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1601495335.git.asml.silence@gmail.com>
References: <cover.1601495335.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

All io_*_prep() functions including io_{read,write}_prep() are called
only during submission where @force_nonblock is always true. Don't keep
propagating it and instead remove the @force_nonblock argument
from prep() altogether.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 2256ecec7299..24f411aa4d1f 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3024,14 +3024,13 @@ static int io_setup_async_rw(struct io_kiocb *req, const struct iovec *iovec,
 	return 0;
 }
 
-static inline int io_rw_prep_async(struct io_kiocb *req, int rw,
-				   bool force_nonblock)
+static inline int io_rw_prep_async(struct io_kiocb *req, int rw)
 {
 	struct io_async_rw *iorw = req->async_data;
 	struct iovec *iov = iorw->fast_iov;
 	ssize_t ret;
 
-	ret = __io_import_iovec(rw, req, &iov, &iorw->iter, !force_nonblock);
+	ret = __io_import_iovec(rw, req, &iov, &iorw->iter, false);
 	if (unlikely(ret < 0))
 		return ret;
 
@@ -3042,8 +3041,7 @@ static inline int io_rw_prep_async(struct io_kiocb *req, int rw,
 	return 0;
 }
 
-static int io_read_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
-			bool force_nonblock)
+static int io_read_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	ssize_t ret;
 
@@ -3057,7 +3055,7 @@ static int io_read_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	/* either don't need iovec imported or already have it */
 	if (!req->async_data)
 		return 0;
-	return io_rw_prep_async(req, READ, force_nonblock);
+	return io_rw_prep_async(req, READ);
 }
 
 /*
@@ -3267,8 +3265,7 @@ static int io_read(struct io_kiocb *req, bool force_nonblock,
 	return ret;
 }
 
-static int io_write_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
-			 bool force_nonblock)
+static int io_write_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	ssize_t ret;
 
@@ -3282,7 +3279,7 @@ static int io_write_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	/* either don't need iovec imported or already have it */
 	if (!req->async_data)
 		return 0;
-	return io_rw_prep_async(req, WRITE, force_nonblock);
+	return io_rw_prep_async(req, WRITE);
 }
 
 static int io_write(struct io_kiocb *req, bool force_nonblock,
@@ -5542,12 +5539,12 @@ static int io_req_defer_prep(struct io_kiocb *req,
 	case IORING_OP_READV:
 	case IORING_OP_READ_FIXED:
 	case IORING_OP_READ:
-		ret = io_read_prep(req, sqe, true);
+		ret = io_read_prep(req, sqe);
 		break;
 	case IORING_OP_WRITEV:
 	case IORING_OP_WRITE_FIXED:
 	case IORING_OP_WRITE:
-		ret = io_write_prep(req, sqe, true);
+		ret = io_write_prep(req, sqe);
 		break;
 	case IORING_OP_POLL_ADD:
 		ret = io_poll_add_prep(req, sqe);
@@ -5769,7 +5766,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	case IORING_OP_READ_FIXED:
 	case IORING_OP_READ:
 		if (sqe) {
-			ret = io_read_prep(req, sqe, force_nonblock);
+			ret = io_read_prep(req, sqe);
 			if (ret < 0)
 				break;
 		}
@@ -5779,7 +5776,7 @@ static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 	case IORING_OP_WRITE_FIXED:
 	case IORING_OP_WRITE:
 		if (sqe) {
-			ret = io_write_prep(req, sqe, force_nonblock);
+			ret = io_write_prep(req, sqe);
 			if (ret < 0)
 				break;
 		}
-- 
2.24.0

