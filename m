Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6541C51530E
	for <lists+io-uring@lfdr.de>; Fri, 29 Apr 2022 19:56:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376402AbiD2SAE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 29 Apr 2022 14:00:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378215AbiD2SAB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 29 Apr 2022 14:00:01 -0400
Received: from mail-il1-x129.google.com (mail-il1-x129.google.com [IPv6:2607:f8b0:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D97F8FFB7
        for <io-uring@vger.kernel.org>; Fri, 29 Apr 2022 10:56:42 -0700 (PDT)
Received: by mail-il1-x129.google.com with SMTP id r11so4472475ila.1
        for <io-uring@vger.kernel.org>; Fri, 29 Apr 2022 10:56:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=L+edS0BhxkaTKfLd0Ao2ma1FeM/nRsP7AEjYtUpwwY4=;
        b=fZYNe/zbDznWSxHH7QauR5ePcX6R8plZCRaULOrD/y7yGOtyDTeqGsoxZ/MA5uzU6a
         iVfJeoY4TZg1UAqIeJ1VDwSsYkBOvKALPREtJgwPTS3wWpRKtVGRgCOh2w2WGGuUwmY2
         9lT0NeyqWlncevP8iM9xSj4KTHpFamTcY3VggWFvJvmz4ObXqGciiH3QBjbyYrWpHD50
         urqfKEvUXlJ8gaSr4Qf6qxIr3OL7rR25d6FN6oWYkbaMPXVjANTPOwDXjSLnvoUKiTJt
         udgouMAykYkmCNMTjMwA6d+FqLxCWMsLjDQ3G+KOAvrggil2dt2Cp1n6yrVhZ061pb7p
         jkZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=L+edS0BhxkaTKfLd0Ao2ma1FeM/nRsP7AEjYtUpwwY4=;
        b=N5Yr9dR/30G0xxz/NcL3orKtHdSi+lugtTE+AvX3xlaX3fGu4bpI7QesDmGqeMfto2
         MFzotG5fY7Tb09q4igGVZgkF+MqxDeiXUKkrONfzGp3yPxyMWFz0Ghtn9+IN1NHPXImE
         UlYHTcYQcxlYDgnk+X5RnD9aTzAWCdSwa7QYSEZG0QZomUOTn+w5Un7RyXTcp8ksB8+D
         M32/Oy6IXOZgXPgHWlXWDg+D/YC2bNLhwC7Ya2Fnlmgdl+l0N1TUUj+IUSzJIs+nStgW
         1yvv7Lc18SDugF8APXgG1Tc/OaUnLB6PNABOFQa2rfzbz0p42L5bx0y89/cfq6wtlC0Q
         hvhA==
X-Gm-Message-State: AOAM531PoKTK8w7dzn/osPiWkj6hcE0dUMJRIqp8S4Pi5DTQZqbpJVkq
        8t7RHIGbtRNlKOhvqTuTZppVlJBBAnnzKw==
X-Google-Smtp-Source: ABdhPJwnVhE4AqQdhdmQLWCevZUAd36pwmWH3h4nHFkBzYTcs21sqvBQ5jMLQXFHQz/LWUa/wY2cvg==
X-Received: by 2002:a05:6e02:1c44:b0:2cb:f7d2:92c5 with SMTP id d4-20020a056e021c4400b002cbf7d292c5mr219760ilg.234.1651255001607;
        Fri, 29 Apr 2022 10:56:41 -0700 (PDT)
Received: from m1.localdomain ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id o9-20020a02cc29000000b0032b3a78179dsm744082jap.97.2022.04.29.10.56.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 29 Apr 2022 10:56:40 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 02/11] io_uring: make io_buffer_select() return the user address directly
Date:   Fri, 29 Apr 2022 11:56:26 -0600
Message-Id: <20220429175635.230192-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220429175635.230192-1-axboe@kernel.dk>
References: <20220429175635.230192-1-axboe@kernel.dk>
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

