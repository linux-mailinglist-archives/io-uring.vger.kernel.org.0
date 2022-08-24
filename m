Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 917E459F919
	for <lists+io-uring@lfdr.de>; Wed, 24 Aug 2022 14:10:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237289AbiHXMKm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 24 Aug 2022 08:10:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237325AbiHXMKa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 24 Aug 2022 08:10:30 -0400
Received: from mail-ej1-x636.google.com (mail-ej1-x636.google.com [IPv6:2a00:1450:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC29A402CC
        for <io-uring@vger.kernel.org>; Wed, 24 Aug 2022 05:10:28 -0700 (PDT)
Received: by mail-ej1-x636.google.com with SMTP id w19so33141268ejc.7
        for <io-uring@vger.kernel.org>; Wed, 24 Aug 2022 05:10:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=OTyuNR9mG76hXCIvBRUfIr/jVV32q+g4El0FvvVYohU=;
        b=RbTPM2PJchJZ/g5k8ym3yrfgMKb8i5/gz6RvPRJEWOF3YyfHeX5cIXMeEqbnXTk8Ik
         UdySW7/GglDSZjacKflnIkYG1cEWe5Y9tyTuAzLJI6aaEwrGeLM16TMr0+EUKrttesxH
         v8zqKFXHoAbuAx7gGw/PqSJ2hyVLDYx1/USKuto7fEifjNP5OBHpsW5fb8jq69je6PEU
         1TGsOqhFmuqiKmagR0mXxzyivNiubiIhTl2aa/YO6HdJPR07MmNjuUFWjp+HXxA7CWtf
         GBwld94GYDVAD1Wtu00X6JjQRk+h9qaXSQJ5T0AWyhK7D7iKKPviAD1zDbcrg5f1Gl0t
         tReg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=OTyuNR9mG76hXCIvBRUfIr/jVV32q+g4El0FvvVYohU=;
        b=TcJMWiu9gxxajc+i7e1ywGZnY2X2THmOMHrh7EkDqmE80gImlKFql96Psh+x0O69WW
         o3A8qRndWP9sNzN/bH2WIDQEekO3qcx+QDmcCOKiTL40YdiPc5UeNbSMSl+HtQAYJjbm
         sMCZQTuNx8R+W//OAlS4e18/iAi5UqrWu5FzXYzxOEWlZMOWOYVgOqc5bpJ7WkpVIRBt
         viUiMSnKxjFzkkL7uPTA6pp1hHKl19vDhRLDPePKBCfxbjSNIAn5Zxmqg42+3bxGdqVo
         yt2/Rvo9YMlrkHQ0Jg9qDLqhOqNfKwMmIxsi15Q3uX5VWZ7YuRSWKWtyAzPE+I6bfeBm
         /QqA==
X-Gm-Message-State: ACgBeo0Tfi2d/xTVe6E5h+pgVQ83YxVsRL9Un1ejVqBD/VZdFY0UJdn/
        5DjcwxS0Q+3kUeDOLznrRfp93hyajvLGJw==
X-Google-Smtp-Source: AA6agR6x9JLPjnPBNm3ZyR8w9u2sTiN97L2vpWc4dQAesZRONGjlTkFLOCMSote+CsxnOtPbGzXurA==
X-Received: by 2002:a17:907:e8c:b0:73d:8146:9aa1 with SMTP id ho12-20020a1709070e8c00b0073d81469aa1mr2671746ejc.253.1661343026978;
        Wed, 24 Aug 2022 05:10:26 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:7067])
        by smtp.gmail.com with ESMTPSA id j2-20020a170906410200b007308bdef04bsm1094626ejk.103.2022.08.24.05.10.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 05:10:26 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com,
        Stefan Metzmacher <metze@samba.org>
Subject: [PATCH 6/6] io_uring/net: save address for sendzc async execution
Date:   Wed, 24 Aug 2022 13:07:43 +0100
Message-Id: <d7512d7aa9abcd36e9afe1a4d292a24cb2d157e5.1661342812.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1661342812.git.asml.silence@gmail.com>
References: <cover.1661342812.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We usually copy all bits that a request needs from the userspace for
async execution, so the userspace can keep them on the stack. However,
send zerocopy violates this pattern for addresses and may reloads it
e.g. from io-wq. Save the address if any in ->async_data as usual.

Reported-by: Stefan Metzmacher <metze@samba.org>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c   | 52 +++++++++++++++++++++++++++++++++++++++++-------
 io_uring/net.h   |  1 +
 io_uring/opdef.c |  4 +++-
 3 files changed, 49 insertions(+), 8 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 3adcb09ae264..4eaeb805e720 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -182,6 +182,37 @@ static int io_sendmsg_copy_hdr(struct io_kiocb *req,
 					&iomsg->free_iov);
 }
 
+int io_sendzc_prep_async(struct io_kiocb *req)
+{
+	struct io_sendzc *zc = io_kiocb_to_cmd(req, struct io_sendzc);
+	struct io_async_msghdr *io;
+	int ret;
+
+	if (!zc->addr || req_has_async_data(req))
+		return 0;
+	if (io_alloc_async_data(req))
+		return -ENOMEM;
+
+	io = req->async_data;
+	ret = move_addr_to_kernel(zc->addr, zc->addr_len, &io->addr);
+	return ret;
+}
+
+static int io_setup_async_addr(struct io_kiocb *req,
+			      struct sockaddr_storage *addr,
+			      unsigned int issue_flags)
+{
+	struct io_async_msghdr *io;
+
+	if (!addr || req_has_async_data(req))
+		return -EAGAIN;
+	if (io_alloc_async_data(req))
+		return -ENOMEM;
+	io = req->async_data;
+	memcpy(&io->addr, addr, sizeof(io->addr));
+	return -EAGAIN;
+}
+
 int io_sendmsg_prep_async(struct io_kiocb *req)
 {
 	int ret;
@@ -944,7 +975,7 @@ static int io_sg_from_iter(struct sock *sk, struct sk_buff *skb,
 
 int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
 {
-	struct sockaddr_storage address;
+	struct sockaddr_storage __address, *addr;
 	struct io_ring_ctx *ctx = req->ctx;
 	struct io_sendzc *zc = io_kiocb_to_cmd(req, struct io_sendzc);
 	struct io_notif_slot *notif_slot;
@@ -978,10 +1009,16 @@ int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
 	msg.msg_namelen = 0;
 
 	if (zc->addr) {
-		ret = move_addr_to_kernel(zc->addr, zc->addr_len, &address);
-		if (unlikely(ret < 0))
-			return ret;
-		msg.msg_name = (struct sockaddr *)&address;
+		if (req_has_async_data(req)) {
+			struct io_async_msghdr *io = req->async_data;
+
+			msg.msg_name = &io->addr;
+		} else {
+			ret = move_addr_to_kernel(zc->addr, zc->addr_len, &__address);
+			if (unlikely(ret < 0))
+				return ret;
+			msg.msg_name = (struct sockaddr *)&__address;
+		}
 		msg.msg_namelen = zc->addr_len;
 	}
 
@@ -1013,13 +1050,14 @@ int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
 
 	if (unlikely(ret < min_ret)) {
 		if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK))
-			return -EAGAIN;
+			return io_setup_async_addr(req, addr, issue_flags);
+
 		if (ret > 0 && io_net_retry(sock, msg.msg_flags)) {
 			zc->len -= ret;
 			zc->buf += ret;
 			zc->done_io += ret;
 			req->flags |= REQ_F_PARTIAL_IO;
-			return -EAGAIN;
+			return io_setup_async_addr(req, addr, issue_flags);
 		}
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
diff --git a/io_uring/net.h b/io_uring/net.h
index 7c438d39c089..f91f56c6eeac 100644
--- a/io_uring/net.h
+++ b/io_uring/net.h
@@ -31,6 +31,7 @@ struct io_async_connect {
 int io_shutdown_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_shutdown(struct io_kiocb *req, unsigned int issue_flags);
 
+int io_sendzc_prep_async(struct io_kiocb *req);
 int io_sendmsg_prep_async(struct io_kiocb *req);
 void io_sendmsg_recvmsg_cleanup(struct io_kiocb *req);
 int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 72dd2b2d8a9d..41410126c1c6 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -478,13 +478,15 @@ const struct io_op_def io_op_defs[] = {
 		.pollout		= 1,
 		.audit_skip		= 1,
 		.ioprio			= 1,
+		.manual_alloc		= 1,
 #if defined(CONFIG_NET)
+		.async_size		= sizeof(struct io_async_msghdr),
 		.prep			= io_sendzc_prep,
 		.issue			= io_sendzc,
+		.prep_async		= io_sendzc_prep_async,
 #else
 		.prep			= io_eopnotsupp_prep,
 #endif
-
 	},
 };
 
-- 
2.37.2

