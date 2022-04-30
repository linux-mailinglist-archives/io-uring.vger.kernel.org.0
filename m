Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D067651608B
	for <lists+io-uring@lfdr.de>; Sat, 30 Apr 2022 22:54:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245115AbiD3Uzj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 30 Apr 2022 16:55:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245109AbiD3Uxw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 30 Apr 2022 16:53:52 -0400
Received: from mail-pj1-x102f.google.com (mail-pj1-x102f.google.com [IPv6:2607:f8b0:4864:20::102f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2782115A2D
        for <io-uring@vger.kernel.org>; Sat, 30 Apr 2022 13:50:29 -0700 (PDT)
Received: by mail-pj1-x102f.google.com with SMTP id w5-20020a17090aaf8500b001d74c754128so13293794pjq.0
        for <io-uring@vger.kernel.org>; Sat, 30 Apr 2022 13:50:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=L+edS0BhxkaTKfLd0Ao2ma1FeM/nRsP7AEjYtUpwwY4=;
        b=uSE0xUJJ/SX5KinoG6UXcP8aun+sIrOXFuYU0ikvAw4YpWsuCP1DcspJnLlXZj8l2k
         x4Ldc2G0QMh7+HtGq7Q8COOXkZAXUQ4gdR5ZCBY/E9vUinjBk17ogGQ3piWl6c4AC3kI
         aNksQ1O87eGWyWGK0lFZCw23qGKUBwSRrKtSGZ5DZzdb9PdRHb1M8o6eW1xWT2g602aK
         JdWlsgAg0k0AFfa5QxSlWQ4GZvYlcF04j/aNgSHo7YycX8wEA3Qad9szWkm3S+K66VHe
         xwhIyZePShewMb3HcVz2rqclhI+ibPnqOb0hofqD9LHln7g3TD2/MjlkUtbpPN84+rNU
         YkvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L+edS0BhxkaTKfLd0Ao2ma1FeM/nRsP7AEjYtUpwwY4=;
        b=UtJHVQxT4GBiuyHMD2dB1EpFAFWu4BGNOULnvFM7Mo5njcwTRLo5+vvF+OFAOhBTgo
         zLMwmFBD4WTqJQzJFeDsD0/hmJth7SVbYRo+3Mq7LcPDpGORkb08ioUibCdPg9svD96V
         QxF+Yh3UiEkxBPmZdcl2NGd9xEszPhLxhftv9AtjHf0htvmHZZMSX9Wwbt0GcyyBFbXW
         AwM5VaDrWdQbEF20tLKG/uJogNvsXi4A0T5P7kamOPbPOB9+pmc7tFJxt1YqvkSj8pc6
         E3y+VeZVAMLTBRc5sKpLwidnyJ7e9tmXJKtc8NwX83vBgA6IOJEpF3aWWbO8UAzZVH7V
         EbiA==
X-Gm-Message-State: AOAM531Z0dwOgWAqYULl+J3Zu5iwtKX3hMnAQelJ960pghxUubcNV+R4
        e5RvFI0WIEhT/Tw5YpXMkm/YWFdjgOa//P1X
X-Google-Smtp-Source: ABdhPJwMjwHsa1u4B8kDMuTU7phzio3SIlnuzItyk4VRjmTjekfE4zgtrXPP/hVIT+z1Sd2OjWdyjg==
X-Received: by 2002:a17:90a:1f4f:b0:1d8:23d9:de1e with SMTP id y15-20020a17090a1f4f00b001d823d9de1emr5592578pjy.42.1651351828335;
        Sat, 30 Apr 2022 13:50:28 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id t13-20020a17090340cd00b0015e8d4eb1c4sm1854066pld.14.2022.04.30.13.50.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 30 Apr 2022 13:50:27 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 02/12] io_uring: make io_buffer_select() return the user address directly
Date:   Sat, 30 Apr 2022 14:50:12 -0600
Message-Id: <20220430205022.324902-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220430205022.324902-1-axboe@kernel.dk>
References: <20220430205022.324902-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
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
index 12f61ce429dc..19dfa974ebcf 100644
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
 		kmsg->fast_iov[0].iov_len = req->sr_msg.len;
 		iov_iter_init(&kmsg->msg.msg_iter, READ, kmsg->fast_iov,
 				1, req->sr_msg.len);
@@ -5999,7 +5993,6 @@ static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 
 static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 {
-	struct io_buffer *kbuf;
 	struct io_sr_msg *sr = &req->sr_msg;
 	struct msghdr msg;
 	void __user *buf = sr->buf;
@@ -6014,10 +6007,11 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
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

