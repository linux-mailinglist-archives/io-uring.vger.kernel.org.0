Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 355475167E5
	for <lists+io-uring@lfdr.de>; Sun,  1 May 2022 22:57:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354803AbiEAVA2 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 1 May 2022 17:00:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238355AbiEAVA0 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 1 May 2022 17:00:26 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50DAF18B01
        for <io-uring@vger.kernel.org>; Sun,  1 May 2022 13:57:00 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id qe3-20020a17090b4f8300b001dc24e4da73so2798997pjb.1
        for <io-uring@vger.kernel.org>; Sun, 01 May 2022 13:57:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=plVeEyL643cRaY9fb0tUq384hiemrGMJBKU66jEDCMU=;
        b=duk8Z4UdR0Z3AqjMOyIjjcG4jIVcZTxWXaDwhhXrDTGWHoLKyMKKqzQmBb10+Va1kA
         v4fDpEbIGWcr65r5hNZKlG27Txnw2ujDkJ5fMxK0HHm/B5bAJogYIsK72bH4Tmr/FuG/
         6jl8aYU8RN30yDLxbXxUrEgDLb5w2OMqA7jvEPk7zYtuCrxAsJjtVg3hf+Mpj8GuIXaW
         tUfSbWRg1pt3cPxcL5uJkt/zwJopQsq9aPRWFi0BWyvJlK6cmkti9Fs3JxT8H+rSwiXe
         ZiJGWSTGQu6EWo7cAgkbTXz+XGu7QzlH8U6ytR9s5c2sEIlXkk9DJN5nvICMaeGOOG9o
         dqaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=plVeEyL643cRaY9fb0tUq384hiemrGMJBKU66jEDCMU=;
        b=lvqxDq+WKWhUqkblJ8B5D4w41KH/CEmzp7yzsPTrY9OgKGcWGibDgjnlR5ihA4Agvc
         t6Ub0CNXolZQibDXDYK3WviHQ/BU00QHnWHgeTJX+SX+B4h/MG/KAgx3wPQgLvHLuBjt
         9/03b6QXlrmVoCtKjBBaFcnkK8ldWnMBnTD2NJu2uQbdoKcg/u3zvyZhHIXAyk9oruFQ
         cnPMtnECSrO+PUr4vy2v8X+DmWJgAa7X0/EQHE5ryhg/Pv3QXkhOnMILPDzsKHD20ZGj
         qOYnWjrjJtuDMKhKRQaPPMKIQqyCKBgMWBN+R8NyMtpASU+xSps7xGWVYwspgDR6fr5Y
         0keQ==
X-Gm-Message-State: AOAM530mGoUuz9/x6mKy5J0gimVWoFQadAkile1zWiygMer7TOH1nJS0
        wucVeh1fw8sBnaZHMLTFTjU/mG9xxY2beQ==
X-Google-Smtp-Source: ABdhPJyhGa0AzSPiELpzEF4pJMT4Y8qT8NCmjSpIxTqok8Vp+WsAZMbDYOwKlwzp/rD+XsrDrkcHoQ==
X-Received: by 2002:a17:90b:388c:b0:1dc:542b:a596 with SMTP id mu12-20020a17090b388c00b001dc542ba596mr3079107pjb.76.1651438619403;
        Sun, 01 May 2022 13:56:59 -0700 (PDT)
Received: from localhost.localdomain (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id l8-20020a17090270c800b0015e8d4eb1e9sm1894013plt.51.2022.05.01.13.56.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 May 2022 13:56:58 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com, Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 03/16] io_uring: make io_buffer_select() return the user address directly
Date:   Sun,  1 May 2022 14:56:40 -0600
Message-Id: <20220501205653.15775-4-axboe@kernel.dk>
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

There's no point in having callers provide a kbuf, we're just returning
the address anyway.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 42 ++++++++++++++++++------------------------
 1 file changed, 18 insertions(+), 24 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 38bd5dfb4160..d9c9eb5e4bab 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3571,15 +3571,15 @@ static void io_buffer_add_list(struct io_ring_ctx *ctx,
 	list_add(&bl->list, list);
 }
 
-static struct io_buffer *io_buffer_select(struct io_kiocb *req, size_t *len,
-					  int bgid, unsigned int issue_flags)
+static void __user *io_buffer_select(struct io_kiocb *req, size_t *len,
+				     int bgid, unsigned int issue_flags)
 {
 	struct io_buffer *kbuf = req->kbuf;
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_buffer_list *bl;
 
 	if (req->flags & REQ_F_BUFFER_SELECTED)
-		return kbuf;
+		return u64_to_user_ptr(kbuf->addr);
 
 	io_ring_submit_lock(req->ctx, issue_flags);
 
@@ -3591,25 +3591,18 @@ static struct io_buffer *io_buffer_select(struct io_kiocb *req, size_t *len,
 			*len = kbuf->len;
 		req->flags |= REQ_F_BUFFER_SELECTED;
 		req->kbuf = kbuf;
-	} else {
-		kbuf = ERR_PTR(-ENOBUFS);
+		io_ring_submit_unlock(req->ctx, issue_flags);
+		return u64_to_user_ptr(kbuf->addr);
 	}
 
 	io_ring_submit_unlock(req->ctx, issue_flags);
-	return kbuf;
+	return ERR_PTR(-ENOBUFS);
 }
 
 static void __user *io_rw_buffer_select(struct io_kiocb *req, size_t *len,
 					unsigned int issue_flags)
 {
-	struct io_buffer *kbuf;
-	u16 bgid;
-
-	bgid = req->buf_index;
-	kbuf = io_buffer_select(req, len, bgid, issue_flags);
-	if (IS_ERR(kbuf))
-		return kbuf;
-	return u64_to_user_ptr(kbuf->addr);
+	return io_buffer_select(req, len, req->buf_index, issue_flags);
 }
 
 #ifdef CONFIG_COMPAT
@@ -5934,7 +5927,6 @@ static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_async_msghdr iomsg, *kmsg;
 	struct io_sr_msg *sr = &req->sr_msg;
 	struct socket *sock;
-	struct io_buffer *kbuf;
 	unsigned flags;
 	int ret, min_ret = 0;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
@@ -5953,10 +5945,12 @@ static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 	}
 
 	if (req->flags & REQ_F_BUFFER_SELECT) {
-		kbuf = io_buffer_select(req, &sr->len, sr->bgid, issue_flags);
-		if (IS_ERR(kbuf))
-			return PTR_ERR(kbuf);
-		kmsg->fast_iov[0].iov_base = u64_to_user_ptr(kbuf->addr);
+		void __user *buf;
+
+		buf = io_buffer_select(req, &sr->len, sr->bgid, issue_flags);
+		if (IS_ERR(buf))
+			return PTR_ERR(buf);
+		kmsg->fast_iov[0].iov_base = buf;
 		kmsg->fast_iov[0].iov_len = sr->len;
 		iov_iter_init(&kmsg->msg.msg_iter, READ, kmsg->fast_iov, 1,
 				sr->len);
@@ -5998,7 +5992,6 @@ static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 
 static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 {
-	struct io_buffer *kbuf;
 	struct io_sr_msg *sr = &req->sr_msg;
 	struct msghdr msg;
 	void __user *buf = sr->buf;
@@ -6013,10 +6006,11 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 		return -ENOTSOCK;
 
 	if (req->flags & REQ_F_BUFFER_SELECT) {
-		kbuf = io_buffer_select(req, &sr->len, sr->bgid, issue_flags);
-		if (IS_ERR(kbuf))
-			return PTR_ERR(kbuf);
-		buf = u64_to_user_ptr(kbuf->addr);
+		void __user *buf;
+
+		buf = io_buffer_select(req, &sr->len, sr->bgid, issue_flags);
+		if (IS_ERR(buf))
+			return PTR_ERR(buf);
 	}
 
 	ret = import_single_range(READ, buf, sr->len, &iov, &msg.msg_iter);
-- 
2.35.1

