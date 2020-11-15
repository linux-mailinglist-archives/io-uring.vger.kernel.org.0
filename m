Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1367B2B33CB
	for <lists+io-uring@lfdr.de>; Sun, 15 Nov 2020 11:41:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727136AbgKOKjZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 15 Nov 2020 05:39:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727080AbgKOKjF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 15 Nov 2020 05:39:05 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6707FC061A04
        for <io-uring@vger.kernel.org>; Sun, 15 Nov 2020 02:39:05 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id a65so20993470wme.1
        for <io-uring@vger.kernel.org>; Sun, 15 Nov 2020 02:39:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=HIW6WpPR/0LrgH1nlg5GdZOnY9kj1E0BsOd6rwVbf5A=;
        b=STEqsAnUCAztuZcY7IZ+PldFU43YUAFsXfANCk4HulwvjOCImFDMV0b1XazKFHOn87
         XYIUfsbhpmzmTVBkQmHhJGxjAz415n9yaa5N/8ltQbuzeB5BfaQATpfD4RiwFi4caigK
         pNS+o9gaSRTehtq9jqujg+GMw+77Q9jr0+B7s9XX7kaKYeD/AM2sYGdlYlj5/PynKFn4
         moKte2hqORy6ipBxu2DK14J6FvBfqa+kUJb0FQq8G8bIvXX07ujp3hkTRwaC+9gTQXLR
         F6dQQBqKjVvcA46+Ekay3fND8Rg/H/cVXEAFk6fDqm/eX0IwgvhPc/MSDkR+vYGDXfBz
         O9jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=HIW6WpPR/0LrgH1nlg5GdZOnY9kj1E0BsOd6rwVbf5A=;
        b=A+M3XKpLqwTpCqze2a3pojGrb0hB2wlnFcdBbY5nzdhox8U5Zsmsntwo5Y9rGN+zdw
         5kfwlk0Ri+pm3G+SRcH8LfxdCpDuUH+K5Qmovw5wrJCmnsVf9vxGtZqDyp08rFXVR8YQ
         mEQ5G+HUhLbxdMJXjP6ARqax3OHGNyLVd766lf7TErdOHMkghGX4TXxfogBz1R55GO3W
         sHlMh73lWFUuDNJ7LBZzaXfZMLVrs8pU0LDICxfMlgRF+NCotJmOGKtlNji+WgAIdcRE
         4vDA7eRREAvUza94RotjXvRKCUDxgQPWBPz7Ui6vuRJinh1YQPIYV5E10uFXFX1xy/cJ
         XfAA==
X-Gm-Message-State: AOAM531FP9LEj8VAg31e4KvBFjEEcP1BBuZgoxIso6cwxu+ukwPTUuH6
        95YaamUqk3cgqcvXHW6dQ/c=
X-Google-Smtp-Source: ABdhPJyIIYEauRf5PBBF+BOTU324jwPgms9TDZtstxom93fzt3e7AXvU+k+kk/wKWd4lpgpwlVo+GQ==
X-Received: by 2002:a1c:e286:: with SMTP id z128mr10558655wmg.33.1605436744215;
        Sun, 15 Nov 2020 02:39:04 -0800 (PST)
Received: from localhost.localdomain (host109-152-100-189.range109-152.btcentralplus.com. [109.152.100.189])
        by smtp.gmail.com with ESMTPSA id b14sm17790900wrs.46.2020.11.15.02.39.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Nov 2020 02:39:03 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        v@nametag.social
Subject: [PATCH 4/5] io_uring: send/recv with registered buffer
Date:   Sun, 15 Nov 2020 10:35:43 +0000
Message-Id: <67aa100f8fb62691281a605f28e621152e768c52.1605435507.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1605435507.git.asml.silence@gmail.com>
References: <cover.1605435507.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add support of registered buffers to send() and recv(). Done by
exploiting last bit of send/recv flags, IO_MSG_FIXED, which is cleared
before going into net stack.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 39 +++++++++++++++++++++++++++------------
 1 file changed, 27 insertions(+), 12 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7703291617f3..390495170fb0 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -104,6 +104,8 @@
 #define IORING_MAX_RESTRICTIONS	(IORING_RESTRICTION_LAST + \
 				 IORING_REGISTER_LAST + IORING_OP_LAST)
 
+#define IO_MSG_FIXED		(1U << 31)
+
 struct io_uring {
 	u32 head ____cacheline_aligned_in_smp;
 	u32 tail ____cacheline_aligned_in_smp;
@@ -4689,18 +4691,25 @@ static int io_send(struct io_kiocb *req, bool force_nonblock,
 		   struct io_comp_state *cs)
 {
 	struct io_sr_msg *sr = &req->sr_msg;
+	unsigned int flags = sr->msg_flags;
 	struct msghdr msg;
 	struct iovec iov;
 	struct socket *sock;
-	unsigned flags;
 	int ret;
 
 	sock = sock_from_file(req->file, &ret);
 	if (unlikely(!sock))
 		return ret;
 
-	ret = import_single_range(WRITE, sr->buf, sr->len, &iov, &msg.msg_iter);
-	if (unlikely(ret))
+	if (flags & IO_MSG_FIXED) {
+		ret = io_import_fixed(req, WRITE, (u64)sr->buf, sr->len,
+				      &msg.msg_iter);
+		flags &= ~IO_MSG_FIXED;
+	} else {
+		ret = import_single_range(WRITE, sr->buf, sr->len, &iov,
+					  &msg.msg_iter);
+	}
+	if (unlikely(ret < 0))
 		return ret;
 
 	msg.msg_name = NULL;
@@ -4708,7 +4717,6 @@ static int io_send(struct io_kiocb *req, bool force_nonblock,
 	msg.msg_controllen = 0;
 	msg.msg_namelen = 0;
 
-	flags = req->sr_msg.msg_flags;
 	if (flags & MSG_DONTWAIT)
 		req->flags |= REQ_F_NOWAIT;
 	else if (force_nonblock)
@@ -4821,15 +4829,22 @@ static int io_recv(struct io_kiocb *req, bool force_nonblock,
 	if (unlikely(!sock))
 		return ret;
 
-	if (req->flags & REQ_F_BUFFER_SELECT) {
-		kbuf = io_recv_buffer_select(req, !force_nonblock);
-		if (IS_ERR(kbuf))
-			return PTR_ERR(kbuf);
-		buf = u64_to_user_ptr(kbuf->addr);
-	}
+	if (flags & IO_MSG_FIXED) {
+		ret = io_import_fixed(req, READ, (u64)buf, sr->len,
+				      &msg.msg_iter);
+		flags &= ~IO_MSG_FIXED;
+	} else {
+		if (req->flags & REQ_F_BUFFER_SELECT) {
+			kbuf = io_recv_buffer_select(req, !force_nonblock);
+			if (IS_ERR(kbuf))
+				return PTR_ERR(kbuf);
+			buf = u64_to_user_ptr(kbuf->addr);
+		}
 
-	ret = import_single_range(READ, buf, sr->len, &iov, &msg.msg_iter);
-	if (unlikely(ret))
+		ret = import_single_range(READ, buf, sr->len, &iov,
+					  &msg.msg_iter);
+	}
+	if (unlikely(ret < 0))
 		goto out_free;
 
 	msg.msg_name = NULL;
-- 
2.24.0

