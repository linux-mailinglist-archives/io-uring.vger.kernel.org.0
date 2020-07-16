Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4D61222CD4
	for <lists+io-uring@lfdr.de>; Thu, 16 Jul 2020 22:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726218AbgGPUaK (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jul 2020 16:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725921AbgGPUaJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jul 2020 16:30:09 -0400
Received: from mail-wm1-x344.google.com (mail-wm1-x344.google.com [IPv6:2a00:1450:4864:20::344])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81BE0C061755
        for <io-uring@vger.kernel.org>; Thu, 16 Jul 2020 13:30:09 -0700 (PDT)
Received: by mail-wm1-x344.google.com with SMTP id 17so12895649wmo.1
        for <io-uring@vger.kernel.org>; Thu, 16 Jul 2020 13:30:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=SPET3zFeJ4X44nPP3f3fEAl8Xb6uBh/iaenDAy5J7Iw=;
        b=sxZ0/x/G8TQVW8mm0o7xkjETPIxe1MujzzrFRM6QVPQ9g4SstbWpjAChVmoeYRliQ+
         P+VyMU9lmOZqrVNllIXnkGtGqHYkw0xN371VR4OL4hXU6gzeyebn0sHuRrIMDMzbUt0I
         eER+bsaAFjA1pWR3nnnWDyY0vJ4Fi13ejHYMPS/CG+DAI8m0LnyH9UOO9KB13zKRbm0m
         N7lG4F6xc9sht3JBXzr7CcC5l13rEo7t3JLwi2RkF0TBnliCpSODQp0WLWwGjE/pOEVe
         yjJI+v9LhGsvH6wAPmyoIYT7F+ocx3El4x8+tNBEAWqBdDeTxqi0P7ZvjQ6OArAaFvHM
         g38w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=SPET3zFeJ4X44nPP3f3fEAl8Xb6uBh/iaenDAy5J7Iw=;
        b=EwMb511ost1Bz43s8XetT+BTVx6IvFnbl1j4fKkJg3EVH47LGdRuHXZQGNX1oZgKck
         5v65GElbaiGOoiruVS0IcyisELSvaR9uXpG7XcRz/mQvi+2TCY7xze+yNh8Wt6Oxjfza
         E9cXUgjnGBDeKTtLWU77qbqAKi8eP6jSWiAaYtBB0DR9RxtsQUuyKYgfLIFwrSpUFBFb
         Rg4cTd/ui6V/oaaTPJDh1Md6zhs7d95T/j0lWpTMP5TmkbtRgL/8ZlinvKUXdB6W+zsQ
         hPFjJ+L+jzJd9W6wEgaAyo/LRaoKyMVqk95KzwKeXafuyXO7iz0bKKFMJsZZFlElTCMQ
         rkqQ==
X-Gm-Message-State: AOAM532U9GKEsQLgAfN8j+94WbLxzrkIT2Vzkj2AI43wOi8aKuvSBcGQ
        3HNN7L9Y8NkfAwNB6m8ViIc=
X-Google-Smtp-Source: ABdhPJzeNHUsaopz9M39i9TvksKuK6ZCal7c7CVih5GvReJRByJzJ1uNBuInnoxS4anuJDB25eSURw==
X-Received: by 2002:a7b:c09a:: with SMTP id r26mr5741341wmh.176.1594931408216;
        Thu, 16 Jul 2020 13:30:08 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id v5sm9939823wmh.12.2020.07.16.13.30.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 13:30:07 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 5/7] io_uring: move BUFFER_SELECT check into *recv[msg]
Date:   Thu, 16 Jul 2020 23:28:03 +0300
Message-Id: <34b905526712be27ba8af56c4a00fd1d7b8ac69d.1594930020.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1594930020.git.asml.silence@gmail.com>
References: <cover.1594930020.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Move REQ_F_BUFFER_SELECT flag check out of io_recv_buffer_select(), and
do that in its call sites That saves us from double error checking and
possibly an extra func call.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 22 ++++++++++------------
 1 file changed, 10 insertions(+), 12 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index c837a465b53a..eabc03320901 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4101,9 +4101,6 @@ static struct io_buffer *io_recv_buffer_select(struct io_kiocb *req,
 	struct io_sr_msg *sr = &req->sr_msg;
 	struct io_buffer *kbuf;
 
-	if (!(req->flags & REQ_F_BUFFER_SELECT))
-		return NULL;
-
 	kbuf = io_buffer_select(req, &sr->len, sr->bgid, sr->kbuf, needs_lock);
 	if (IS_ERR(kbuf))
 		return kbuf;
@@ -4153,7 +4150,7 @@ static int io_recvmsg(struct io_kiocb *req, bool force_nonblock,
 {
 	struct io_async_msghdr iomsg, *kmsg;
 	struct socket *sock;
-	struct io_buffer *kbuf;
+	struct io_buffer *kbuf = NULL;
 	unsigned flags;
 	int ret, cflags = 0;
 
@@ -4175,10 +4172,10 @@ static int io_recvmsg(struct io_kiocb *req, bool force_nonblock,
 		kmsg = &iomsg;
 	}
 
-	kbuf = io_recv_buffer_select(req, &cflags, !force_nonblock);
-	if (IS_ERR(kbuf)) {
-		return PTR_ERR(kbuf);
-	} else if (kbuf) {
+	if (req->flags & REQ_F_BUFFER_SELECT) {
+		kbuf = io_recv_buffer_select(req, &cflags, !force_nonblock);
+		if (IS_ERR(kbuf))
+			return PTR_ERR(kbuf);
 		kmsg->fast_iov[0].iov_base = u64_to_user_ptr(kbuf->addr);
 		iov_iter_init(&kmsg->msg.msg_iter, READ, kmsg->iov,
 				1, req->sr_msg.len);
@@ -4225,11 +4222,12 @@ static int io_recv(struct io_kiocb *req, bool force_nonblock,
 	if (unlikely(!sock))
 		return ret;
 
-	kbuf = io_recv_buffer_select(req, &cflags, !force_nonblock);
-	if (IS_ERR(kbuf))
-		return PTR_ERR(kbuf);
-	else if (kbuf)
+	if (req->flags & REQ_F_BUFFER_SELECT) {
+		kbuf = io_recv_buffer_select(req, &cflags, !force_nonblock);
+		if (IS_ERR(kbuf))
+			return PTR_ERR(kbuf);
 		buf = u64_to_user_ptr(kbuf->addr);
+	}
 
 	ret = import_single_range(READ, buf, sr->len, &iov, &msg.msg_iter);
 	if (unlikely(ret))
-- 
2.24.0

