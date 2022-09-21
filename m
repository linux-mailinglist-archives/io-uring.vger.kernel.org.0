Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D72045BFCDB
	for <lists+io-uring@lfdr.de>; Wed, 21 Sep 2022 13:20:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbiIULUy (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 21 Sep 2022 07:20:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229891AbiIULUu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 21 Sep 2022 07:20:50 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7959070E44
        for <io-uring@vger.kernel.org>; Wed, 21 Sep 2022 04:20:49 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id o5so4218288wms.1
        for <io-uring@vger.kernel.org>; Wed, 21 Sep 2022 04:20:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=jh9KBFYcogDbm7aInFCEJSuzB6ztb3nRXiIBKpYh+zQ=;
        b=Bg3yQQuBc3eyPYB6EfY0oo91Nvg4KIA94XxCqnoKiqqZC7hZxcHvSlstcl2TycduC1
         avoCwczel4VkX94QiwR82VXAovj6vwwOX6Vs6qqKpue4uucEO5M3UEcZuxk5vF6RdU6p
         2m2/tbObmcHvfBVhNvMafumC+QIRRW6oLHXuMynBJjnBKCDMa0DJ2vh+IZLDs33w/twY
         mPyElDF5Y0kmAK4O1FFuyVo8M8kI/XKQFbBaIvCis96Fz+2tyiMatcpurrinlvr+Ih5S
         UJciZqvxRa7WSnndSaTXapgzpJyJ2KsU97AECGMeFPO2Ehgh+Kp3XNskt0ON6lWszMXD
         emQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=jh9KBFYcogDbm7aInFCEJSuzB6ztb3nRXiIBKpYh+zQ=;
        b=SjGoXkn97CzCIuuoxmwU6CEX1ZWBciyGDlPX+1PgFYxNa4uPELVRHoDG3hXeRhSCQ2
         7sx/EqkC3wwoGOK00pi9V05yvNgs0WGSi7qIolShLzYDfaaVj5OKaGZbKUUhJxWDd0h+
         lrfjpp+EcNJLboqWGD+ZZXpvbzyQVy/bJAWbfAYlqpcW/HtAl/iQb1mJBldgEoyKcSeF
         J8jNFv8AGqahIBK3VrJWYGnlTVi4juTAcHqx27NH6wYSyPG40Rksc8AWhx7+cEidmE37
         knt5A8DDYd/3lNJ1iJsXi62j8Dq2GuzS7OW492eRttxAKsET2FLijQqmuV+PC9hDcsfw
         M+8g==
X-Gm-Message-State: ACrzQf2SNOQvJVoQKj0EvX2XnYG5uuWafV/9jd44c+b1dB1og89FJNfe
        d1t+F4a+TCsi+VmhZsavuTyAkaTUKHg=
X-Google-Smtp-Source: AMsMyM72wskPqcwcQj3eAwJdVxzaZwuhDefVTq+7O3X3LzbBSa4z2L6wsJszP+plVQyX55HKtgWWjA==
X-Received: by 2002:a05:600c:4f07:b0:3b4:a5d1:1fea with SMTP id l7-20020a05600c4f0700b003b4a5d11feamr5637830wmq.103.1663759247633;
        Wed, 21 Sep 2022 04:20:47 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.205.62.threembb.co.uk. [188.28.205.62])
        by smtp.gmail.com with ESMTPSA id s17-20020a5d6a91000000b00228da845d4dsm2206732wru.94.2022.09.21.04.20.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 04:20:47 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 6/9] io_uring/net: support non-zerocopy sendto
Date:   Wed, 21 Sep 2022 12:17:51 +0100
Message-Id: <69fbd8b2cb830e57d1bf9ec351e9bf95c5b77e3f.1663668091.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1663668091.git.asml.silence@gmail.com>
References: <cover.1663668091.git.asml.silence@gmail.com>
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

We have normal sends, but what is missing is sendto-like requests. Add
sendto() capabilities to IORING_OP_SEND by passing in addr just as we do
for IORING_OP_SEND_ZC.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c   | 35 +++++++++++++++++++++++++++++------
 io_uring/net.h   |  3 ++-
 io_uring/opdef.c |  5 ++++-
 3 files changed, 35 insertions(+), 8 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index a190e022a9de..aa2c819cd85d 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -59,9 +59,10 @@ struct io_sr_msg {
 	unsigned			done_io;
 	unsigned			msg_flags;
 	u16				flags;
-	/* used only for sendzc */
+	/* initialised and used only by !msg send variants */
 	u16				addr_len;
 	void __user			*addr;
+	/* used only for send zerocopy */
 	struct io_kiocb 		*notif;
 };
 
@@ -180,7 +181,7 @@ static int io_sendmsg_copy_hdr(struct io_kiocb *req,
 					&iomsg->free_iov);
 }
 
-int io_sendzc_prep_async(struct io_kiocb *req)
+int io_send_prep_async(struct io_kiocb *req)
 {
 	struct io_sr_msg *zc = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct io_async_msghdr *io;
@@ -234,8 +235,14 @@ int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 
-	if (unlikely(sqe->file_index || sqe->addr2))
+	if (req->opcode == IORING_OP_SEND) {
+		if (READ_ONCE(sqe->__pad3[0]))
+			return -EINVAL;
+		sr->addr = u64_to_user_ptr(READ_ONCE(sqe->addr2));
+		sr->addr_len = READ_ONCE(sqe->addr_len);
+	} else if (sqe->addr2 || sqe->file_index) {
 		return -EINVAL;
+	}
 
 	sr->umsg = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	sr->len = READ_ONCE(sqe->len);
@@ -315,6 +322,7 @@ int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 
 int io_send(struct io_kiocb *req, unsigned int issue_flags)
 {
+	struct sockaddr_storage __address;
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct msghdr msg;
 	struct iovec iov;
@@ -323,9 +331,23 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 	int min_ret = 0;
 	int ret;
 
+	if (sr->addr) {
+		if (req_has_async_data(req)) {
+			struct io_async_msghdr *io = req->async_data;
+
+			msg.msg_name = &io->addr;
+		} else {
+			ret = move_addr_to_kernel(sr->addr, sr->addr_len, &__address);
+			if (unlikely(ret < 0))
+				return ret;
+			msg.msg_name = (struct sockaddr *)&__address;
+		}
+		msg.msg_namelen = sr->addr_len;
+	}
+
 	if (!(req->flags & REQ_F_POLLED) &&
 	    (sr->flags & IORING_RECVSEND_POLL_FIRST))
-		return -EAGAIN;
+		return io_setup_async_addr(req, &__address, issue_flags);
 
 	sock = sock_from_file(req->file);
 	if (unlikely(!sock))
@@ -351,13 +373,14 @@ int io_send(struct io_kiocb *req, unsigned int issue_flags)
 	ret = sock_sendmsg(sock, &msg);
 	if (ret < min_ret) {
 		if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK))
-			return -EAGAIN;
+			return io_setup_async_addr(req, &__address, issue_flags);
+
 		if (ret > 0 && io_net_retry(sock, flags)) {
 			sr->len -= ret;
 			sr->buf += ret;
 			sr->done_io += ret;
 			req->flags |= REQ_F_PARTIAL_IO;
-			return -EAGAIN;
+			return io_setup_async_addr(req, &__address, issue_flags);
 		}
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
diff --git a/io_uring/net.h b/io_uring/net.h
index e7366aac335c..488d4dc7eee2 100644
--- a/io_uring/net.h
+++ b/io_uring/net.h
@@ -31,12 +31,13 @@ struct io_async_connect {
 int io_shutdown_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_shutdown(struct io_kiocb *req, unsigned int issue_flags);
 
-int io_sendzc_prep_async(struct io_kiocb *req);
 int io_sendmsg_prep_async(struct io_kiocb *req);
 void io_sendmsg_recvmsg_cleanup(struct io_kiocb *req);
 int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags);
+
 int io_send(struct io_kiocb *req, unsigned int issue_flags);
+int io_send_prep_async(struct io_kiocb *req);
 
 int io_recvmsg_prep_async(struct io_kiocb *req);
 int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index f5e7a0e01729..8fb4d98c9f36 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -316,11 +316,14 @@ const struct io_op_def io_op_defs[] = {
 		.pollout		= 1,
 		.audit_skip		= 1,
 		.ioprio			= 1,
+		.manual_alloc		= 1,
 		.name			= "SEND",
 #if defined(CONFIG_NET)
+		.async_size		= sizeof(struct io_async_msghdr),
 		.prep			= io_sendmsg_prep,
 		.issue			= io_send,
 		.fail			= io_sendrecv_fail,
+		.prep_async		= io_send_prep_async,
 #else
 		.prep			= io_eopnotsupp_prep,
 #endif
@@ -495,7 +498,7 @@ const struct io_op_def io_op_defs[] = {
 		.async_size		= sizeof(struct io_async_msghdr),
 		.prep			= io_sendzc_prep,
 		.issue			= io_sendzc,
-		.prep_async		= io_sendzc_prep_async,
+		.prep_async		= io_send_prep_async,
 		.cleanup		= io_sendzc_cleanup,
 		.fail			= io_send_zc_fail,
 #else
-- 
2.37.2

