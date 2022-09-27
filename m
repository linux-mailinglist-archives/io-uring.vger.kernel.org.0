Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F8B75ED151
	for <lists+io-uring@lfdr.de>; Wed, 28 Sep 2022 01:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbiI0Xx4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 27 Sep 2022 19:53:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230338AbiI0Xxn (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 27 Sep 2022 19:53:43 -0400
Received: from mail-wm1-x329.google.com (mail-wm1-x329.google.com [IPv6:2a00:1450:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D8AB402CD
        for <io-uring@vger.kernel.org>; Tue, 27 Sep 2022 16:53:42 -0700 (PDT)
Received: by mail-wm1-x329.google.com with SMTP id z13-20020a7bc7cd000000b003b5054c6f9bso144957wmk.2
        for <io-uring@vger.kernel.org>; Tue, 27 Sep 2022 16:53:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date;
        bh=q56Gqo+JNysl12QurIe93tg8d9bZvnw6fZYQbt5N8wA=;
        b=UNdXZ9tOPVr6MesZ1Wbg37BuvVo22L5AyxCxTxrtVY9PlNijBCtIhb3uLnD5GDuoaT
         ceBO6aAR1YYK8W91dkrQaHujxgNPoU6OuSQqLJ6Wd+cDn1476w+R+gYdKggu7YD+RYRp
         TGGpqmUuSo65MDwt5dc3XAy1P89PuEGukBzS8/SUQvkIUTwtbU1Ftl8R9rpjxIZGxqlZ
         C36bBXBFpWtebbZ62aFJcpE5LwsoKxt/lo5YHI/3fn3/1DDNQgY/p/hZ6Zd5th22BBb3
         PAPeRbjWqZyLdcfdTRUdmg1CrRKBK6NYwMLaTCya5zAGWrvLdyvLDDdnS2341/kuS1kW
         eoOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date;
        bh=q56Gqo+JNysl12QurIe93tg8d9bZvnw6fZYQbt5N8wA=;
        b=O4FUQz5pAahsjTYLX8R8d+IbptUV2uD58PV4cYNvz510rfyp3nvQzZjr1VlGz8ZP8s
         OeW+PxWyw/huKVJ1bS95lIJdKKn9Mxdvh5tVy1y/Y+tMxAIInOhEl7yF0Uh7J0Ud8IHE
         Vq+DAJFW8aUkxmBIFcyn5JrmE231MjxzNkw6dlMC7fuhiw38d+fwxb1iZ8hhkVKIKzk5
         Vz2bsTnpVmCBAV00kwcY0ilTEOdJQ0N+w1PQoYRpk76G+kqK+0iCs+scqWBWNSa7xk8i
         diD3MtQz37rjvWq6MMNShB74IaBKzsV+mL7xUrJxl184Se8VPrY8mrS7rYC0xg3I4pXF
         TA7Q==
X-Gm-Message-State: ACrzQf2xLJrodQiNaY80nOODFIYpkgKQEnaV1eX7vBNM48tPmqQIwZ+D
        Jnj2wU5BCWvCeJelS3j/ApnP7J+bNmU=
X-Google-Smtp-Source: AMsMyM5yX1SeZPjYoME1cDjIcUKQ8Jal3zGSIad2Uy+8r/3hiKUwYiNSRbxabrTHjG/A1DYVCv5aKg==
X-Received: by 2002:a1c:7213:0:b0:3b3:4065:66cc with SMTP id n19-20020a1c7213000000b003b3406566ccmr4584764wmc.184.1664322819915;
        Tue, 27 Sep 2022 16:53:39 -0700 (PDT)
Received: from 127.0.0.1localhost (94.196.228.157.threembb.co.uk. [94.196.228.157])
        by smtp.gmail.com with ESMTPSA id i11-20020a05600c354b00b003b4935f04a4sm243565wmq.5.2022.09.27.16.53.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Sep 2022 16:53:39 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        Stefan Metzmacher <metze@samba.org>
Subject: [PATCH for-6.1] io_uring/net: don't skip notifs for failed requests
Date:   Wed, 28 Sep 2022 00:51:49 +0100
Message-Id: <9c8bead87b2b980fcec441b8faef52188b4a6588.1664292100.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We currently only add a notification CQE when the send succeded, i.e.
cqe.res >= 0. However, it'd be more robust to do buffer notifications
for failed requests as well in case drivers decide do something fanky.

Always return a buffer notification after initial prep, don't hide it.
This behaviour is better aligned with documentation and the patch also
helps the userspace to respect it.

Cc: stable@vger.kernel.org # 6.0
Suggested-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

We need it as soon as possible, and it's likely almost time
for 6.1 rcs.

 io_uring/net.c | 29 ++++++++---------------------
 1 file changed, 8 insertions(+), 21 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 6b69eff6887e..5058a9fc9e9c 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -916,7 +916,6 @@ void io_send_zc_cleanup(struct io_kiocb *req)
 			kfree(io->free_iov);
 	}
 	if (zc->notif) {
-		zc->notif->flags |= REQ_F_CQE_SKIP;
 		io_notif_flush(zc->notif);
 		zc->notif = NULL;
 	}
@@ -1047,7 +1046,7 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
 	struct msghdr msg;
 	struct iovec iov;
 	struct socket *sock;
-	unsigned msg_flags, cflags;
+	unsigned msg_flags;
 	int ret, min_ret = 0;
 
 	sock = sock_from_file(req->file);
@@ -1115,8 +1114,6 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
 			req->flags |= REQ_F_PARTIAL_IO;
 			return io_setup_async_addr(req, &__address, issue_flags);
 		}
-		if (ret < 0 && !zc->done_io)
-			zc->notif->flags |= REQ_F_CQE_SKIP;
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
 		req_set_fail(req);
@@ -1129,8 +1126,7 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
 
 	io_notif_flush(zc->notif);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
-	cflags = ret >= 0 ? IORING_CQE_F_MORE : 0;
-	io_req_set_res(req, ret, cflags);
+	io_req_set_res(req, ret, IORING_CQE_F_MORE);
 	return IOU_OK;
 }
 
@@ -1139,7 +1135,7 @@ int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct io_async_msghdr iomsg, *kmsg;
 	struct socket *sock;
-	unsigned flags, cflags;
+	unsigned flags;
 	int ret, min_ret = 0;
 
 	sock = sock_from_file(req->file);
@@ -1178,8 +1174,6 @@ int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags)
 			req->flags |= REQ_F_PARTIAL_IO;
 			return io_setup_async_msg(req, kmsg, issue_flags);
 		}
-		if (ret < 0 && !sr->done_io)
-			sr->notif->flags |= REQ_F_CQE_SKIP;
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
 		req_set_fail(req);
@@ -1196,27 +1190,20 @@ int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags)
 
 	io_notif_flush(sr->notif);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
-	cflags = ret >= 0 ? IORING_CQE_F_MORE : 0;
-	io_req_set_res(req, ret, cflags);
+	io_req_set_res(req, ret, IORING_CQE_F_MORE);
 	return IOU_OK;
 }
 
 void io_sendrecv_fail(struct io_kiocb *req)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
-	int res = req->cqe.res;
 
 	if (req->flags & REQ_F_PARTIAL_IO)
-		res = sr->done_io;
+		req->cqe.res = sr->done_io;
+
 	if ((req->flags & REQ_F_NEED_CLEANUP) &&
-	    (req->opcode == IORING_OP_SEND_ZC || req->opcode == IORING_OP_SENDMSG_ZC)) {
-		/* preserve notification for partial I/O */
-		if (res < 0)
-			sr->notif->flags |= REQ_F_CQE_SKIP;
-		io_notif_flush(sr->notif);
-		sr->notif = NULL;
-	}
-	io_req_set_res(req, res, req->cqe.flags);
+	    (req->opcode == IORING_OP_SEND_ZC || req->opcode == IORING_OP_SENDMSG_ZC))
+		req->cqe.flags |= IORING_CQE_F_MORE;
 }
 
 int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
-- 
2.37.2

