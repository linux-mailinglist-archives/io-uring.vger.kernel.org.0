Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3F835BFCDE
	for <lists+io-uring@lfdr.de>; Wed, 21 Sep 2022 13:21:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbiIULVG (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 21 Sep 2022 07:21:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229959AbiIULU5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 21 Sep 2022 07:20:57 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E135677E80
        for <io-uring@vger.kernel.org>; Wed, 21 Sep 2022 04:20:52 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id t14so9308300wrx.8
        for <io-uring@vger.kernel.org>; Wed, 21 Sep 2022 04:20:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=AwX8MFPz2bqCMB9epVkoln+Im4EAODM6Z9xCifrQzUQ=;
        b=QgNJieqeMSf3rqhO5yXv5CBQNYFDKVh8mak1bUPEeAgZsCQlHnWVKYbgEIn7h/In4Z
         4qB/J7uw7rjnfRpMvyqulY99iaFJ6JvbSixhoJDWjL0xCli+Ff0t+FeMw7GGiSPCjzkN
         T0IxwYnUIFjypXUKZt39sVdfv88QW0h1brVOHb6AVFUC9m2e4+RUd32fLDwroHlGVdaz
         TP84cCZEoSxj4pY+M3GHsApjZm4iAQygW4AQZ3qKModpnWUy/Sgn5f/0ZyWYw71mZG4w
         TMlgSkt6qAd37bNE/mo+J9byqlnweT8GWNk+sdf9CPJRa37q/OZOU7X+sYhTJ9NrbrJS
         VdSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=AwX8MFPz2bqCMB9epVkoln+Im4EAODM6Z9xCifrQzUQ=;
        b=LT97F+Jd6NxxSnJvBfPvFLpVe5ucvotVnbllsjS8hB6IvanI4og16gO+8DryLtVSe6
         4/Swwltsu/vyMzViXrdvlE+4Zic2KA3c0PVKIpSRQ+oxzoLKZKthPzNZJKgtwS4ZTLgx
         2ov35YxkougJEiuUJWygXD2ubEJUwwdU933VLJtTlDqlo2Bx/cWRvBhyi7j5S9awL11S
         6Dyo8AuVyUoLMFSIkivQGb0caAVKf0ZLaBO6E3Z9yy7PcwLuyMQCQ+A3x/k9+++oFUAi
         30aCO+BsnHIS+UX+FZVXix9RM1DHmpxF753VnreSY+ZNn4J+VqgGheQFm930+OexUyMK
         l+Ng==
X-Gm-Message-State: ACrzQf1wiciDnTx5mzLHriQM+TxPTDbobllw8UnxRD/bcI3vI3TVwbik
        +ZFcQ5W/3wutr3S3puMpjsIPWmu+JHo=
X-Google-Smtp-Source: AMsMyM4tygO+Lz+NgtmuFZ0RItA3G1u3C1rdzW+jNgzIJhkr0rRPK+W3wuSpst5N0/vd2XVsyiJTyw==
X-Received: by 2002:a5d:6245:0:b0:225:41ae:a930 with SMTP id m5-20020a5d6245000000b0022541aea930mr17187819wrv.342.1663759251062;
        Wed, 21 Sep 2022 04:20:51 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.205.62.threembb.co.uk. [188.28.205.62])
        by smtp.gmail.com with ESMTPSA id s17-20020a5d6a91000000b00228da845d4dsm2206732wru.94.2022.09.21.04.20.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 21 Sep 2022 04:20:50 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH 9/9] io_uring/net: zerocopy sendmsg
Date:   Wed, 21 Sep 2022 12:17:54 +0100
Message-Id: <6aabc4bdfc0ec78df6ec9328137e394af9d4e7ef.1663668091.git.asml.silence@gmail.com>
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

Add a zerocopy version of sendmsg.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring.h |  1 +
 io_uring/net.c                | 92 +++++++++++++++++++++++++++++++++--
 io_uring/net.h                |  1 +
 io_uring/opdef.c              | 19 ++++++++
 4 files changed, 108 insertions(+), 5 deletions(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 972b179bc07a..92f29d9505a6 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -213,6 +213,7 @@ enum io_uring_op {
 	IORING_OP_SOCKET,
 	IORING_OP_URING_CMD,
 	IORING_OP_SEND_ZC,
+	IORING_OP_SENDMSG_ZC,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
diff --git a/io_uring/net.c b/io_uring/net.c
index 4bcc2675001f..d086f397d4d0 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -909,7 +909,12 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 void io_send_zc_cleanup(struct io_kiocb *req)
 {
 	struct io_sr_msg *zc = io_kiocb_to_cmd(req, struct io_sr_msg);
+	struct io_async_msghdr *io;
 
+	if (req_has_async_data(req)) {
+		io = req->async_data;
+		kfree(io->free_iov);
+	}
 	zc->notif->flags |= REQ_F_CQE_SKIP;
 	io_notif_flush(zc->notif);
 	zc->notif = NULL;
@@ -921,8 +926,7 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_kiocb *notif;
 
-	if (READ_ONCE(sqe->__pad2[0]) || READ_ONCE(sqe->addr3) ||
-	    READ_ONCE(sqe->__pad3[0]))
+	if (unlikely(READ_ONCE(sqe->__pad2[0]) || READ_ONCE(sqe->addr3)))
 		return -EINVAL;
 	/* we don't support IOSQE_CQE_SKIP_SUCCESS just yet */
 	if (req->flags & REQ_F_CQE_SKIP)
@@ -941,6 +945,19 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 		req->imu = READ_ONCE(ctx->user_bufs[idx]);
 		io_req_set_rsrc_node(req, ctx, 0);
 	}
+
+	if (req->opcode == IORING_OP_SEND_ZC) {
+		if (READ_ONCE(sqe->__pad3[0]))
+			return -EINVAL;
+		zc->addr = u64_to_user_ptr(READ_ONCE(sqe->addr2));
+		zc->addr_len = READ_ONCE(sqe->addr_len);
+	} else {
+		if (unlikely(sqe->addr2 || sqe->file_index))
+			return -EINVAL;
+		if (unlikely(zc->flags & IORING_RECVSEND_FIXED_BUF))
+			return -EINVAL;
+	}
+
 	notif = zc->notif = io_alloc_notif(ctx);
 	if (!notif)
 		return -ENOMEM;
@@ -955,8 +972,6 @@ int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (zc->msg_flags & MSG_DONTWAIT)
 		req->flags |= REQ_F_NOWAIT;
 
-	zc->addr = u64_to_user_ptr(READ_ONCE(sqe->addr2));
-	zc->addr_len = READ_ONCE(sqe->addr_len);
 	zc->done_io = 0;
 
 #ifdef CONFIG_COMPAT
@@ -1118,6 +1133,73 @@ int io_send_zc(struct io_kiocb *req, unsigned int issue_flags)
 	return IOU_OK;
 }
 
+int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
+	struct io_async_msghdr iomsg, *kmsg;
+	struct socket *sock;
+	unsigned flags, cflags;
+	int ret, min_ret = 0;
+
+	sock = sock_from_file(req->file);
+	if (unlikely(!sock))
+		return -ENOTSOCK;
+
+	if (req_has_async_data(req)) {
+		kmsg = req->async_data;
+	} else {
+		ret = io_sendmsg_copy_hdr(req, &iomsg);
+		if (ret)
+			return ret;
+		kmsg = &iomsg;
+	}
+
+	if (!(req->flags & REQ_F_POLLED) &&
+	    (sr->flags & IORING_RECVSEND_POLL_FIRST))
+		return io_setup_async_msg(req, kmsg, issue_flags);
+
+	flags = sr->msg_flags | MSG_ZEROCOPY;
+	if (issue_flags & IO_URING_F_NONBLOCK)
+		flags |= MSG_DONTWAIT;
+	if (flags & MSG_WAITALL)
+		min_ret = iov_iter_count(&kmsg->msg.msg_iter);
+
+	kmsg->msg.msg_ubuf = &io_notif_to_data(sr->notif)->uarg;
+	kmsg->msg.sg_from_iter = io_sg_from_iter_iovec;
+	ret = __sys_sendmsg_sock(sock, &kmsg->msg, flags);
+
+	if (unlikely(ret < min_ret)) {
+		if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK))
+			return io_setup_async_msg(req, kmsg, issue_flags);
+
+		if (ret > 0 && io_net_retry(sock, flags)) {
+			sr->done_io += ret;
+			req->flags |= REQ_F_PARTIAL_IO;
+			return io_setup_async_msg(req, kmsg, issue_flags);
+		}
+		if (ret < 0 && !sr->done_io)
+			sr->notif->flags |= REQ_F_CQE_SKIP;
+		if (ret == -ERESTARTSYS)
+			ret = -EINTR;
+		req_set_fail(req);
+	}
+	/* fast path, check for non-NULL to avoid function call */
+	if (kmsg->free_iov)
+		kfree(kmsg->free_iov);
+
+	io_netmsg_recycle(req, issue_flags);
+	if (ret >= 0)
+		ret += sr->done_io;
+	else if (sr->done_io)
+		ret = sr->done_io;
+
+	io_notif_flush(sr->notif);
+	req->flags &= ~REQ_F_NEED_CLEANUP;
+	cflags = ret >= 0 ? IORING_CQE_F_MORE : 0;
+	io_req_set_res(req, ret, cflags);
+	return IOU_OK;
+}
+
 void io_sendrecv_fail(struct io_kiocb *req)
 {
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
@@ -1127,7 +1209,7 @@ void io_sendrecv_fail(struct io_kiocb *req)
 	if (req->flags & REQ_F_PARTIAL_IO)
 		res = sr->done_io;
 	if ((req->flags & REQ_F_NEED_CLEANUP) &&
-	    req->opcode == IORING_OP_SEND_ZC) {
+	    (req->opcode == IORING_OP_SEND_ZC || req->opcode == IORING_OP_SENDMSG_ZC)) {
 		/* preserve notification for partial I/O */
 		if (res < 0)
 			sr->notif->flags |= REQ_F_CQE_SKIP;
diff --git a/io_uring/net.h b/io_uring/net.h
index 45558e2b0a83..5ffa11bf5d2e 100644
--- a/io_uring/net.h
+++ b/io_uring/net.h
@@ -57,6 +57,7 @@ int io_connect_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_connect(struct io_kiocb *req, unsigned int issue_flags);
 
 int io_send_zc(struct io_kiocb *req, unsigned int issue_flags);
+int io_sendmsg_zc(struct io_kiocb *req, unsigned int issue_flags);
 int io_send_zc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 void io_send_zc_cleanup(struct io_kiocb *req);
 
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index e9fd940c2ee1..3c930fef255b 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -503,6 +503,25 @@ const struct io_op_def io_op_defs[] = {
 		.fail			= io_sendrecv_fail,
 #else
 		.prep			= io_eopnotsupp_prep,
+#endif
+	},
+	[IORING_OP_SENDMSG_ZC] = {
+		.name			= "SENDMSG_ZC",
+		.needs_file		= 1,
+		.unbound_nonreg_file	= 1,
+		.pollout		= 1,
+		.audit_skip		= 1,
+		.ioprio			= 1,
+		.manual_alloc		= 1,
+#if defined(CONFIG_NET)
+		.async_size		= sizeof(struct io_async_msghdr),
+		.prep			= io_send_zc_prep,
+		.issue			= io_sendmsg_zc,
+		.prep_async		= io_sendmsg_prep_async,
+		.cleanup		= io_send_zc_cleanup,
+		.fail			= io_sendrecv_fail,
+#else
+		.prep			= io_eopnotsupp_prep,
 #endif
 	},
 };
-- 
2.37.2

