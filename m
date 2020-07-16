Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48CCB222CD3
	for <lists+io-uring@lfdr.de>; Thu, 16 Jul 2020 22:32:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726210AbgGPUaJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 16 Jul 2020 16:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725921AbgGPUaI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 16 Jul 2020 16:30:08 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29789C061755
        for <io-uring@vger.kernel.org>; Thu, 16 Jul 2020 13:30:08 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id o11so8465694wrv.9
        for <io-uring@vger.kernel.org>; Thu, 16 Jul 2020 13:30:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=Gs8gNEt3Ut2lGGaVKRH7hKO3MvYoXj/msCqmXMF8sT4=;
        b=WY61zpIU4XS0XyH1N7cTd6PQw4ynVs+rjsY04ebHJRXEaSJufkujgr50oJXInhW3gm
         o+uaS9noMFCUtiGA9j7LQhH0BNmCllehHrfEMTfIyd8Ffw1vVefHEbhjiiQtVCWgyMlH
         zFHSYIN4U3htPYl84DqhjKMMI2itybAJtpceQ8dESRCpngE7YzWutP0AW06ZbxgJWvgu
         Ye/Z/GvCuFfysnUOFOlNckCKtmx2nL58hr7uTnc+xfW79xTpdBvrjv/7Pt+Jh1uLZcpE
         19Q0FA3L3ePfnI392+QS8BtUHUuOYC22D+nt2v8vUc4DKNAlb++kzloo/YkVquPONCgH
         5Unw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Gs8gNEt3Ut2lGGaVKRH7hKO3MvYoXj/msCqmXMF8sT4=;
        b=aoZDia1WqPZeI6lWNLmulXH4FXTuae7uRidwZhyU73iKYlFfR9NOyiqVED/JcD/Dp+
         uGkWnMeHAYqGAiWRguB9jo4SMuMcIZS5hcyhiELvglJRlqMHZhYQ8s4v6751/A36syzF
         1gKBLh3j6KG4N/fpuGKgDgYQF40iPAX72xXpsO/4Nj/GxriTGjcua1OTC0YcGR898raU
         wtNRCAYS7RJhAPcjo9WWgcU34cnofMDF7S0+PyMn4VL7xGzRVsVHagK92doRWGZuBNPC
         dHS4f6robZpbvn6pm7I8oKuDxS+7LtojSZASQFFm7Uu3EsPdzokkscIzakE9hbMya5J1
         Dj1Q==
X-Gm-Message-State: AOAM532FsumivJswttvjqvFm41G1WDF/SBzfaB+qfYhE+7yOLqQLCNAy
        oZzbYO7tvZbzwToH1D99i4Eo7yzA/Vc=
X-Google-Smtp-Source: ABdhPJx96vNx17tLophDykLIQW9aeisHPAUsESbmQFsWFXacBMbctG4FMpNFi3g9NJyuXI2behCFMg==
X-Received: by 2002:adf:fa10:: with SMTP id m16mr6284831wrr.134.1594931406822;
        Thu, 16 Jul 2020 13:30:06 -0700 (PDT)
Received: from localhost.localdomain ([5.100.193.69])
        by smtp.gmail.com with ESMTPSA id v5sm9939823wmh.12.2020.07.16.13.30.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Jul 2020 13:30:06 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 4/7] io_uring: free selected-bufs if error'ed
Date:   Thu, 16 Jul 2020 23:28:02 +0300
Message-Id: <f3347e5a20d85a23aa609a45272b4d7822e5487c.1594930020.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1594930020.git.asml.silence@gmail.com>
References: <cover.1594930020.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

io_clean_op() may be skipped even if there is a selected io_buffer,
that's because *select_buffer() funcions never set REQ_F_NEED_CLEANUP.

Trigger io_clean_op() when REQ_F_BUFFER_SELECTED is set as well, and
and clear the flag if was freed out of it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 85 ++++++++++++++++++++++++++-------------------------
 1 file changed, 44 insertions(+), 41 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index ba6f68fd2038..c837a465b53a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -957,7 +957,7 @@ static void io_get_req_task(struct io_kiocb *req)
 
 static inline void io_clean_op(struct io_kiocb *req)
 {
-	if (req->flags & REQ_F_NEED_CLEANUP)
+	if (req->flags & (REQ_F_NEED_CLEANUP | REQ_F_BUFFER_SELECTED))
 		__io_clean_op(req);
 }
 
@@ -1931,6 +1931,7 @@ static int io_put_kbuf(struct io_kiocb *req)
 	cflags = kbuf->bid << IORING_CQE_BUFFER_SHIFT;
 	cflags |= IORING_CQE_F_BUFFER;
 	req->rw.addr = 0;
+	req->flags &= ~REQ_F_BUFFER_SELECTED;
 	kfree(kbuf);
 	return cflags;
 }
@@ -4191,20 +4192,16 @@ static int io_recvmsg(struct io_kiocb *req, bool force_nonblock,
 
 	ret = __sys_recvmsg_sock(sock, &kmsg->msg, req->sr_msg.umsg,
 					kmsg->uaddr, flags);
-	if (force_nonblock && ret == -EAGAIN) {
-		ret = io_setup_async_msg(req, kmsg);
-		if (ret != -EAGAIN)
-			kfree(kbuf);
-		return ret;
-	}
+	if (force_nonblock && ret == -EAGAIN)
+		return io_setup_async_msg(req, kmsg);
 	if (ret == -ERESTARTSYS)
 		ret = -EINTR;
+
 	if (kbuf)
 		kfree(kbuf);
-
 	if (kmsg->iov != kmsg->fast_iov)
 		kfree(kmsg->iov);
-	req->flags &= ~REQ_F_NEED_CLEANUP;
+	req->flags &= ~(REQ_F_NEED_CLEANUP | REQ_F_BUFFER_SELECTED);
 
 	if (ret < 0)
 		req_set_fail_links(req);
@@ -4238,7 +4235,6 @@ static int io_recv(struct io_kiocb *req, bool force_nonblock,
 	if (unlikely(ret))
 		goto out_free;
 
-	req->flags |= REQ_F_NEED_CLEANUP;
 	msg.msg_name = NULL;
 	msg.msg_control = NULL;
 	msg.msg_controllen = 0;
@@ -4258,7 +4254,8 @@ static int io_recv(struct io_kiocb *req, bool force_nonblock,
 	if (ret == -ERESTARTSYS)
 		ret = -EINTR;
 out_free:
-	kfree(kbuf);
+	if (kbuf)
+		kfree(kbuf);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
 	if (ret < 0)
 		req_set_fail_links(req);
@@ -5426,39 +5423,45 @@ static void __io_clean_op(struct io_kiocb *req)
 {
 	struct io_async_ctx *io = req->io;
 
-	switch (req->opcode) {
-	case IORING_OP_READV:
-	case IORING_OP_READ_FIXED:
-	case IORING_OP_READ:
-		if (req->flags & REQ_F_BUFFER_SELECTED)
+	if (req->flags & REQ_F_BUFFER_SELECTED) {
+		switch (req->opcode) {
+		case IORING_OP_READV:
+		case IORING_OP_READ_FIXED:
+		case IORING_OP_READ:
 			kfree((void *)(unsigned long)req->rw.addr);
-		/* fallthrough */
-	case IORING_OP_WRITEV:
-	case IORING_OP_WRITE_FIXED:
-	case IORING_OP_WRITE:
-		if (io->rw.iov != io->rw.fast_iov)
-			kfree(io->rw.iov);
-		break;
-	case IORING_OP_RECVMSG:
-		if (req->flags & REQ_F_BUFFER_SELECTED)
-			kfree(req->sr_msg.kbuf);
-		/* fallthrough */
-	case IORING_OP_SENDMSG:
-		if (io->msg.iov != io->msg.fast_iov)
-			kfree(io->msg.iov);
-		break;
-	case IORING_OP_RECV:
-		if (req->flags & REQ_F_BUFFER_SELECTED)
+			break;
+		case IORING_OP_RECVMSG:
+		case IORING_OP_RECV:
 			kfree(req->sr_msg.kbuf);
-		break;
-	case IORING_OP_SPLICE:
-	case IORING_OP_TEE:
-		io_put_file(req, req->splice.file_in,
-			    (req->splice.flags & SPLICE_F_FD_IN_FIXED));
-		break;
+			break;
+		}
+		req->flags &= ~REQ_F_BUFFER_SELECTED;
+	}
+
+	if (req->flags & REQ_F_NEED_CLEANUP) {
+		switch (req->opcode) {
+		case IORING_OP_READV:
+		case IORING_OP_READ_FIXED:
+		case IORING_OP_READ:
+		case IORING_OP_WRITEV:
+		case IORING_OP_WRITE_FIXED:
+		case IORING_OP_WRITE:
+			if (io->rw.iov != io->rw.fast_iov)
+				kfree(io->rw.iov);
+			break;
+		case IORING_OP_RECVMSG:
+		case IORING_OP_SENDMSG:
+			if (io->msg.iov != io->msg.fast_iov)
+				kfree(io->msg.iov);
+			break;
+		case IORING_OP_SPLICE:
+		case IORING_OP_TEE:
+			io_put_file(req, req->splice.file_in,
+				    (req->splice.flags & SPLICE_F_FD_IN_FIXED));
+			break;
+		}
+		req->flags &= ~REQ_F_NEED_CLEANUP;
 	}
-
-	req->flags &= ~REQ_F_NEED_CLEANUP;
 }
 
 static int io_issue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
-- 
2.24.0

