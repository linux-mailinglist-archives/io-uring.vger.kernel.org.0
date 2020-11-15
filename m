Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81AC42B335D
	for <lists+io-uring@lfdr.de>; Sun, 15 Nov 2020 11:20:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbgKOKUg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 15 Nov 2020 05:20:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726634AbgKOKUf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 15 Nov 2020 05:20:35 -0500
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6AC2C0613D2
        for <io-uring@vger.kernel.org>; Sun, 15 Nov 2020 02:20:34 -0800 (PST)
Received: by mail-wr1-x442.google.com with SMTP id l1so15432423wrb.9
        for <io-uring@vger.kernel.org>; Sun, 15 Nov 2020 02:20:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=hp+hpfX8pa8xQUJpKGjJJC3r+JF9l8FIUZj1DQhjLKg=;
        b=bP8Dl4eLFMUCH5+4z789n/SradXMrfKa1Dyfxu1NrZcXLoe3efTXsaMcs9lEXYJO5/
         VKC2eLXv858gSVXoeRQd7NbWanBDvmaBHTeX/wIwM4BVIHSZ6M6RohmiAl7T+HDVTbAc
         2k8BM8aGVc46OQAS63PsKk+a7+PnXGa13ARID+FZCP+3jQhCg9Cd5uEYmcUpRllBtsVc
         Bom3l/SE3TBp/Uq3g4wv8p/0UV+mcV0NYKFZRECUOmaXd4slKDwNLBS1hHxrrnlFG3Gc
         YTFDviRhM269TOMQnb/Z7POV7bfy9+fXhqkGNhI8qe4uppk9eJFci6I4sIBoEtKljcmf
         Adsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=hp+hpfX8pa8xQUJpKGjJJC3r+JF9l8FIUZj1DQhjLKg=;
        b=dWdF88n6skREockBba03xrHvkxn+l0bTQghFYoKbCBou7UYqZ0nH2ujztx99KMIjSi
         mGuXf858RKcxKiccJkjucN1M4Tz3gA/3ZJz4fo3/DPdUX6VQHcg7n6OrBW/5y40tCrK3
         aCANZoX9Ndup3whP7sEt5qFrYDsI8OIarLaAtWZixKPmqifPTdZyMtG/0pf7P2W4el4T
         ioIUe8toKbG3rLCplSSvaPJn45nP2gIOHtaUQgTPmrCQjKs1IMMn3t/Oay6tPh+R6aZ2
         dZh1xxR0JaBVhqNZDk+BH9nP0C0tzza096ktI05RZMXcNiQwP57u/LhlokGDBqvklOFY
         KXQA==
X-Gm-Message-State: AOAM533JZKYppqr8tf8qzsHkkkIfBeKfRDoOcgswOAs9fmdRMXHSd/iN
        4SJ7P34H4U34nWW/ex/rLBzK8/uGVFw=
X-Google-Smtp-Source: ABdhPJxyfLDmRHCoIFWqvBVsTTlt0kMEHoEED5bYgwuI24YUxqqFjhPxSdRSKn7HCT1qk1ljPPBzrQ==
X-Received: by 2002:a5d:4a0a:: with SMTP id m10mr14351834wrq.16.1605435633562;
        Sun, 15 Nov 2020 02:20:33 -0800 (PST)
Received: from localhost.localdomain (host109-152-100-135.range109-152.btcentralplus.com. [109.152.100.135])
        by smtp.gmail.com with ESMTPSA id b14sm17746961wrs.46.2020.11.15.02.20.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2020 02:20:33 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/2] io_uring: update msg header on copy
Date:   Sun, 15 Nov 2020 10:17:17 +0000
Message-Id: <9f972b6c52969ad24237f65dced2ca85ad10ebbe.1605434816.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1605434816.git.asml.silence@gmail.com>
References: <cover.1605434816.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

After copying a send/recv msg header, fix up all the fields right away
instead of delaying it. Keeping it in one place makes it easier to
follow.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 32 +++++++++++++-------------------
 1 file changed, 13 insertions(+), 19 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 365a583033c5..02811c90f711 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -4487,6 +4487,10 @@ static int io_setup_async_msg(struct io_kiocb *req,
 	async_msg = req->async_data;
 	req->flags |= REQ_F_NEED_CLEANUP;
 	memcpy(async_msg, kmsg, sizeof(*kmsg));
+	async_msg->msg.msg_name = &async_msg->addr;
+	/* if iov is not set, it uses fast_iov */
+	if (!async_msg->iov)
+		async_msg->msg.msg_iter.iov = async_msg->fast_iov;
 	return -EAGAIN;
 }
 
@@ -4537,14 +4541,8 @@ static int io_sendmsg(struct io_kiocb *req, bool force_nonblock,
 	if (unlikely(!sock))
 		return ret;
 
-	if (req->async_data) {
-		kmsg = req->async_data;
-		kmsg->msg.msg_name = &kmsg->addr;
-		/* if iov is set, it's allocated already */
-		if (!kmsg->iov)
-			kmsg->iov = kmsg->fast_iov;
-		kmsg->msg.msg_iter.iov = kmsg->iov;
-	} else {
+	kmsg = req->async_data;
+	if (!kmsg) {
 		ret = io_sendmsg_copy_hdr(req, &iomsg);
 		if (ret)
 			return ret;
@@ -4563,7 +4561,8 @@ static int io_sendmsg(struct io_kiocb *req, bool force_nonblock,
 	if (ret == -ERESTARTSYS)
 		ret = -EINTR;
 
-	if (kmsg->iov != kmsg->fast_iov)
+	/* it's reportedly faster to check for null here */
+	if (kmsg->iov)
 		kfree(kmsg->iov);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 	if (ret < 0)
@@ -4765,14 +4764,8 @@ static int io_recvmsg(struct io_kiocb *req, bool force_nonblock,
 	if (unlikely(!sock))
 		return ret;
 
-	if (req->async_data) {
-		kmsg = req->async_data;
-		kmsg->msg.msg_name = &kmsg->addr;
-		/* if iov is set, it's allocated already */
-		if (!kmsg->iov)
-			kmsg->iov = kmsg->fast_iov;
-		kmsg->msg.msg_iter.iov = kmsg->iov;
-	} else {
+	kmsg = req->async_data;
+	if (!kmsg) {
 		ret = io_recvmsg_copy_hdr(req, &iomsg);
 		if (ret)
 			return ret;
@@ -4784,7 +4777,7 @@ static int io_recvmsg(struct io_kiocb *req, bool force_nonblock,
 		if (IS_ERR(kbuf))
 			return PTR_ERR(kbuf);
 		kmsg->fast_iov[0].iov_base = u64_to_user_ptr(kbuf->addr);
-		iov_iter_init(&kmsg->msg.msg_iter, READ, kmsg->iov,
+		iov_iter_init(&kmsg->msg.msg_iter, READ, kmsg->fast_iov,
 				1, req->sr_msg.len);
 	}
 
@@ -4803,7 +4796,8 @@ static int io_recvmsg(struct io_kiocb *req, bool force_nonblock,
 
 	if (req->flags & REQ_F_BUFFER_SELECTED)
 		cflags = io_put_recv_kbuf(req);
-	if (kmsg->iov != kmsg->fast_iov)
+	/* it's reportedly faster to check for null here */
+	if (kmsg->iov)
 		kfree(kmsg->iov);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 	if (ret < 0)
-- 
2.24.0

