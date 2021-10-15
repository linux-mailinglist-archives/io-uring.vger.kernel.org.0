Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 735E542F7BE
	for <lists+io-uring@lfdr.de>; Fri, 15 Oct 2021 18:10:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241136AbhJOQMU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 15 Oct 2021 12:12:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241143AbhJOQMQ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 15 Oct 2021 12:12:16 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11502C061570
        for <io-uring@vger.kernel.org>; Fri, 15 Oct 2021 09:10:10 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id 63-20020a1c0042000000b0030d60716239so3424896wma.4
        for <io-uring@vger.kernel.org>; Fri, 15 Oct 2021 09:10:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=rjLkkn1IeZ4JReykm1Dk3oDgE2wviS+IYQuEth7Ndzw=;
        b=hVcZ2heKEHY4COSO8TOLA67sfEQs9EotIUWDh7qYEJfgC+3hEqzy+Yn5qQzp4pNbSO
         ORTswmv6Z/AW2QP4K03tsoevKu2kG0kDMeAh2KHkaa+PzdSrcYe+3nfSG3Yj0WtCNCw+
         Gd+MxDChJXS9fa9Quc2Oc5mOXfyQvameg7RfwQnX/ClW3LN2fMrlGVtvQ+SESZBxdyFk
         IIGQF/MBGxDnBSc0qA8UcvmY1SN8m3XFJRT56xYu+hwqLDUSj8WNaEa/WKB23RInU/l7
         yjulaHb8ag20tLUTJSY6kKkmMWHom8fG849Jstijdg/OQ5ArSATg1Mb7g+fgNMcg/ZTS
         us7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=rjLkkn1IeZ4JReykm1Dk3oDgE2wviS+IYQuEth7Ndzw=;
        b=wS+MhpcdVqssFbpcfMg1VFoOZyKMRRLRIu6BfbVC11bW1ezFlON0jqXQ38M2KMcyX9
         kH90MK/so4gf0uBczzfYTsYZkLxBwwbAjV92QYoTBZM97HoBYWTlaALwBJtIwdnuUEEw
         4a1tmo1JSMVovXmH6UWf/+53Ah6QTJg0KLH+RHZqo8ay2M2hAg47PTpjaGwWYinzrAWr
         hZ89yENw8hDYmonKqe/NW7h5rolWV55RWG/zliUd6ltupAHevXSXyqmu4SOtOgduFAW3
         soPIR8zE2mHh9faXjwLPUfPa39/FCB5mQYdCsk73HrWqNlRkAINbbnu1t41Rx7gBII7P
         sqBw==
X-Gm-Message-State: AOAM533Up24nc4KUBRJvoFEutV6M+jin+h7K1WgmtLXqi60w/x31o+aR
        Kr/4iAX5tieA5OGpfC7Rn8zlvO3UiSk=
X-Google-Smtp-Source: ABdhPJxMmrFAMP49IbrTGTO3Bh77nqy/HzMyOZKcsx98feDRIFHJ4UxQqj4KLq2CtS3zy4EfzJKEew==
X-Received: by 2002:a1c:2395:: with SMTP id j143mr13645380wmj.107.1634314208525;
        Fri, 15 Oct 2021 09:10:08 -0700 (PDT)
Received: from localhost.localdomain ([185.69.145.218])
        by smtp.gmail.com with ESMTPSA id c15sm5282811wrs.19.2021.10.15.09.10.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 15 Oct 2021 09:10:08 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 5/8] io_uring: optimise fixed rw rsrc node setting
Date:   Fri, 15 Oct 2021 17:09:15 +0100
Message-Id: <68c06f66d5aa9661f1e4b88d08c52d23528297ec.1634314022.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1634314022.git.asml.silence@gmail.com>
References: <cover.1634314022.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Move fixed rw io_req_set_rsrc_node() from rw prep into
io_import_fixed(), if we're using fixed buffers it will always be called
during submission as we save the state in advance,

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 11 ++++-------
 1 file changed, 4 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a2514d2937c0..64ef04c9628d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -2874,12 +2874,7 @@ static int io_prep_rw(struct io_kiocb *req, const struct io_uring_sqe *sqe,
 		kiocb->ki_complete = io_complete_rw;
 	}
 
-	if (req->opcode == IORING_OP_READ_FIXED ||
-	    req->opcode == IORING_OP_WRITE_FIXED) {
-		req->imu = NULL;
-		io_req_set_rsrc_node(req, ctx);
-	}
-
+	req->imu = NULL;
 	req->rw.addr = READ_ONCE(sqe->addr);
 	req->rw.len = READ_ONCE(sqe->len);
 	req->buf_index = READ_ONCE(sqe->buf_index);
@@ -3008,13 +3003,15 @@ static int __io_import_fixed(struct io_kiocb *req, int rw, struct iov_iter *iter
 
 static int io_import_fixed(struct io_kiocb *req, int rw, struct iov_iter *iter)
 {
-	struct io_ring_ctx *ctx = req->ctx;
 	struct io_mapped_ubuf *imu = req->imu;
 	u16 index, buf_index = req->buf_index;
 
 	if (likely(!imu)) {
+		struct io_ring_ctx *ctx = req->ctx;
+
 		if (unlikely(buf_index >= ctx->nr_user_bufs))
 			return -EFAULT;
+		io_req_set_rsrc_node(req, ctx);
 		index = array_index_nospec(buf_index, ctx->nr_user_bufs);
 		imu = READ_ONCE(ctx->user_bufs[index]);
 		req->imu = imu;
-- 
2.33.0

