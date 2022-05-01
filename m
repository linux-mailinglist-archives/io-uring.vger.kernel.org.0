Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72D3E5167EA
	for <lists+io-uring@lfdr.de>; Sun,  1 May 2022 22:57:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348720AbiEAVAd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 1 May 2022 17:00:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354861AbiEAVAb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 1 May 2022 17:00:31 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 732072B272
        for <io-uring@vger.kernel.org>; Sun,  1 May 2022 13:57:05 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id fv2so11231604pjb.4
        for <io-uring@vger.kernel.org>; Sun, 01 May 2022 13:57:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=bSlFIvNfrDD1kYdKSVgb1JjW1BXFQ3n8FVD18SyAgQM=;
        b=xsbASM419Y+hXThMO/A6jZP+EocQPmbQPP+3kkr5Wa5EAC2n7BiQHxaDhUjRTvSd7v
         54KahtxSDQss5uhaUW+5Dg/NEd/DOlxNbEvRslyVQE1PLiqX/3KfY1bfCIQKM/YKSz3M
         2xquylwmIxc92108ReWmgnWyD5HEg4SJ+C8PdGG7uVxox9wuIgWS5sprIXZhJ9v9Tzic
         w1eV6N+0G6SxkzFSkw9u5M/iv4d2KBDpiAtT7WOcMsBGZSTuDrD67Tn0USOeIBuGJ6t3
         qf+zGbKTF7fPnSel4o7NZcErvygELliC8TmE77syLRJ4uvQzYNs2NUIZgBYMsCzDTRsj
         8XqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=bSlFIvNfrDD1kYdKSVgb1JjW1BXFQ3n8FVD18SyAgQM=;
        b=CW/XGEo3qmJVr7cbTOnbzh68jJUST0WOqWq0QS0GCeslXubnDS4Rn0kQkko9OX35rB
         EHamIEyBiA97vzIMB6PcDLEVYpv1iuLvqkkett+QYZyV4UX5FBDk+Aym/O62t9xJ6Coy
         a8Jub4aPdy+TfqeyX/nibno936updejvI7jU8QDmZEWWlOPlMo0fI6mAAosLpDneDkf1
         rHBhPXjtrQhJmdUtB0cbrQk2C3k5LLSqfvXQ1/rLHFCDLIe+N6oZ5jWjXail7EA+Ld9E
         Xtjd7ZFII4UpxKC5w5AKF9u2Ka5cxt8FlxiKZFeeKS946MfmiWkpqocPbh53U2rmHHqj
         TW2g==
X-Gm-Message-State: AOAM530l3p15j/fGVXnkG8tx2u43uB6PxhShNeleeUymdHsErURx32if
        sDNhouYM0h8XJlymyu9VsW33Zgu1P8Nj9w==
X-Google-Smtp-Source: ABdhPJwENO+rO4M+D/f3fAezLSFiyC2LMBAWiDYRaIxwp4u+YEcNftKmqaKbK+R7SNUAfgboGl9OOQ==
X-Received: by 2002:a17:90b:1e0b:b0:1d2:dabc:9929 with SMTP id pg11-20020a17090b1e0b00b001d2dabc9929mr9813610pjb.39.1651438624611;
        Sun, 01 May 2022 13:57:04 -0700 (PDT)
Received: from localhost.localdomain (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id l8-20020a17090270c800b0015e8d4eb1e9sm1894013plt.51.2022.05.01.13.57.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 May 2022 13:57:04 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 08/16] io_uring: never call io_buffer_select() for a buffer re-select
Date:   Sun,  1 May 2022 14:56:45 -0600
Message-Id: <20220501205653.15775-9-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220501205653.15775-1-axboe@kernel.dk>
References: <20220501205653.15775-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Callers already have room to store the addr and length information,
clean it up by having the caller just assign the previously provided
data.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7efe2de5ce81..b4bcfd5c4c3d 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3568,9 +3568,6 @@ static void __user *io_buffer_select(struct io_kiocb *req, size_t *len,
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_buffer_list *bl;
 
-	if (req->flags & REQ_F_BUFFER_SELECTED)
-		return u64_to_user_ptr(kbuf->addr);
-
 	io_ring_submit_lock(req->ctx, issue_flags);
 
 	bl = io_buffer_get_list(ctx, req->buf_index);
@@ -3610,8 +3607,9 @@ static ssize_t io_compat_import(struct io_kiocb *req, struct iovec *iov,
 	buf = io_buffer_select(req, &len, issue_flags);
 	if (IS_ERR(buf))
 		return PTR_ERR(buf);
+	req->rw.addr = (unsigned long) buf;
 	iov[0].iov_base = buf;
-	iov[0].iov_len = (compat_size_t) len;
+	req->rw.len = iov[0].iov_len = (compat_size_t) len;
 	return 0;
 }
 #endif
@@ -3632,8 +3630,9 @@ static ssize_t __io_iov_buffer_select(struct io_kiocb *req, struct iovec *iov,
 	buf = io_buffer_select(req, &len, issue_flags);
 	if (IS_ERR(buf))
 		return PTR_ERR(buf);
+	req->rw.addr = (unsigned long) buf;
 	iov[0].iov_base = buf;
-	iov[0].iov_len = len;
+	req->rw.len = iov[0].iov_len = len;
 	return 0;
 }
 
@@ -3641,10 +3640,8 @@ static ssize_t io_iov_buffer_select(struct io_kiocb *req, struct iovec *iov,
 				    unsigned int issue_flags)
 {
 	if (req->flags & REQ_F_BUFFER_SELECTED) {
-		struct io_buffer *kbuf = req->kbuf;
-
-		iov[0].iov_base = u64_to_user_ptr(kbuf->addr);
-		iov[0].iov_len = kbuf->len;
+		iov[0].iov_base = u64_to_user_ptr(req->rw.addr);
+		iov[0].iov_len = req->rw.len;
 		return 0;
 	}
 	if (req->rw.len != 1)
@@ -3658,6 +3655,13 @@ static ssize_t io_iov_buffer_select(struct io_kiocb *req, struct iovec *iov,
 	return __io_iov_buffer_select(req, iov, issue_flags);
 }
 
+static inline bool io_do_buffer_select(struct io_kiocb *req)
+{
+	if (!(req->flags & REQ_F_BUFFER_SELECT))
+		return false;
+	return !(req->flags & REQ_F_BUFFER_SELECTED);
+}
+
 static struct iovec *__io_import_iovec(int rw, struct io_kiocb *req,
 				       struct io_rw_state *s,
 				       unsigned int issue_flags)
@@ -3680,10 +3684,11 @@ static struct iovec *__io_import_iovec(int rw, struct io_kiocb *req,
 	sqe_len = req->rw.len;
 
 	if (opcode == IORING_OP_READ || opcode == IORING_OP_WRITE) {
-		if (req->flags & REQ_F_BUFFER_SELECT) {
+		if (io_do_buffer_select(req)) {
 			buf = io_buffer_select(req, &sqe_len, issue_flags);
 			if (IS_ERR(buf))
 				return ERR_CAST(buf);
+			req->rw.addr = (unsigned long) buf;
 			req->rw.len = sqe_len;
 		}
 
@@ -5950,7 +5955,7 @@ static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 		kmsg = &iomsg;
 	}
 
-	if (req->flags & REQ_F_BUFFER_SELECT) {
+	if (io_do_buffer_select(req)) {
 		void __user *buf;
 
 		buf = io_buffer_select(req, &sr->len, issue_flags);
@@ -6011,12 +6016,13 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	if (unlikely(!sock))
 		return -ENOTSOCK;
 
-	if (req->flags & REQ_F_BUFFER_SELECT) {
+	if (io_do_buffer_select(req)) {
 		void __user *buf;
 
 		buf = io_buffer_select(req, &sr->len, issue_flags);
 		if (IS_ERR(buf))
 			return PTR_ERR(buf);
+		sr->buf = buf;
 	}
 
 	ret = import_single_range(READ, buf, sr->len, &iov, &msg.msg_iter);
-- 
2.35.1

