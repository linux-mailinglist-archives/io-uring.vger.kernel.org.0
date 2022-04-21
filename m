Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C58925094AD
	for <lists+io-uring@lfdr.de>; Thu, 21 Apr 2022 03:39:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383653AbiDUBmh (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 20 Apr 2022 21:42:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383655AbiDUBm3 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 20 Apr 2022 21:42:29 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 318E015803
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 18:39:42 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id m14-20020a17090a34ce00b001d5fe250e23so423917pjf.3
        for <io-uring@vger.kernel.org>; Wed, 20 Apr 2022 18:39:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=wS4trcaEUQWL3t8wO2Pnm8spD5DYBeNtEulm2wwW7zw=;
        b=wIzvKvWq/P7XzIRsyF21Y1BnWgW1BGo8cK/UQJSyUxF2K+icxBy6uS/VoEOrPgeWZo
         0JcCtKN2jeoCESgyTqUWpLpKkcrW4fHR0+6YdOvPckciyTNCBrEXVjU2Vl0bff0cwWDc
         ZCEamNX+Kcum88XdjRAMUHqonswLOyteLFAwS8t8NMCnNYNnrWhJ5PWlIei6ld4EOsmL
         PS8OpRANsATwsj+2mOZBFpqnNpDTzumQFRGMMM3jcQNrNXYnLt9RtYH8w3BqJLKem07U
         VHwvZID09hluriM1C1m2Mr//nsoYnobb/w+pya9qKErZsSLkkFYOPQ8qQdKfcAU946Ri
         LeUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wS4trcaEUQWL3t8wO2Pnm8spD5DYBeNtEulm2wwW7zw=;
        b=L0lIFqg1Gbl/53LZoTIN28+2aG+SUA09TW4ViE+oOo15imwFk05YY/oAKkMj4QKrkr
         GXXusStJVJSv3at9oTGi4SgBYdMq9S4NBmMbVja8j/mastxasoJ9iJzKrT0OHBortdeN
         9P/50z3Dbu0BQtBrzoJrLrFqwY1+yZRtIwFTnBR8q0CxusuQEy4WfeLmIgupt5wuL+Fo
         mAOeLiKYeWd4hQBxciqJ5FYnjK/62f9nijr507vRRBuH8P9R8yOjQX4FgytRHUz4ByVK
         hOezJPTQNpzZuJcWF5I5uf6Aug3X24K+b7I9Vjl/kv1mdJ9H2eRtFg2gjJ9kFkXdNF/K
         Yn+A==
X-Gm-Message-State: AOAM533WwEqNEOT6pSfbRVwZyk4oSQY3T92xiXdFY3NM6ff/Kcu1sOcX
        FaoyBr0NSnGP5qRXhXuDsToeUVwVsCDjSM/2
X-Google-Smtp-Source: ABdhPJyRdyFi+15H5UPk+Y8utNQo/Wbrtd9r40pEsckfNwLmFFjSq47UHtAnCKxdvo8nh21pghgr7w==
X-Received: by 2002:a17:90a:ec09:b0:1d5:dd77:d050 with SMTP id l9-20020a17090aec0900b001d5dd77d050mr1144131pjy.53.1650505181475;
        Wed, 20 Apr 2022 18:39:41 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id x16-20020a17090ab01000b001cd4989ff4bsm460115pjq.18.2022.04.20.18.39.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 18:39:40 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/2] io_uring: support MSG_WAITALL for IORING_OP_SEND(MSG)
Date:   Wed, 20 Apr 2022 19:39:36 -0600
Message-Id: <20220421013937.697501-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220421013937.697501-1-axboe@kernel.dk>
References: <20220421013937.697501-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Like commit 7ba89d2af17a for recv/recvmsg, support MSG_WAITALL for the
send side. If this flag is set and we do a short send, retry for a
stream of seqpacket socket.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 36 +++++++++++++++++++++++++++++-------
 1 file changed, 29 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 7e1d5243bbbc..f06c6fed540b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -5232,6 +5232,13 @@ static int io_sync_file_range(struct io_kiocb *req, unsigned int issue_flags)
 }
 
 #if defined(CONFIG_NET)
+static bool io_net_retry(struct socket *sock, int flags)
+{
+	if (!(flags & MSG_WAITALL))
+		return false;
+	return sock->type == SOCK_STREAM || sock->type == SOCK_SEQPACKET;
+}
+
 static int io_setup_async_msg(struct io_kiocb *req,
 			      struct io_async_msghdr *kmsg)
 {
@@ -5290,12 +5297,14 @@ static int io_sendmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (req->ctx->compat)
 		sr->msg_flags |= MSG_CMSG_COMPAT;
 #endif
+	sr->done_io = 0;
 	return 0;
 }
 
 static int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_async_msghdr iomsg, *kmsg;
+	struct io_sr_msg *sr = &req->sr_msg;
 	struct socket *sock;
 	unsigned flags;
 	int min_ret = 0;
@@ -5327,12 +5336,21 @@ static int io_sendmsg(struct io_kiocb *req, unsigned int issue_flags)
 			return io_setup_async_msg(req, kmsg);
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
+		if (ret > 0 && io_net_retry(sock, flags)) {
+			sr->done_io += ret;
+			req->flags |= REQ_F_PARTIAL_IO;
+			return io_setup_async_msg(req, kmsg);
+		}
 		req_set_fail(req);
 	}
 	/* fast path, check for non-NULL to avoid function call */
 	if (kmsg->free_iov)
 		kfree(kmsg->free_iov);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
+	if (ret >= 0)
+		ret += sr->done_io;
+	else if (sr->done_io)
+		ret = sr->done_io;
 	__io_req_complete(req, issue_flags, ret, 0);
 	return 0;
 }
@@ -5373,8 +5391,19 @@ static int io_send(struct io_kiocb *req, unsigned int issue_flags)
 			return -EAGAIN;
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
+		if (ret > 0 && io_net_retry(sock, flags)) {
+			sr->len -= ret;
+			sr->buf += ret;
+			sr->done_io += ret;
+			req->flags |= REQ_F_PARTIAL_IO;
+			return -EAGAIN;
+		}
 		req_set_fail(req);
 	}
+	if (ret >= 0)
+		ret += sr->done_io;
+	else if (sr->done_io)
+		ret = sr->done_io;
 	__io_req_complete(req, issue_flags, ret, 0);
 	return 0;
 }
@@ -5506,13 +5535,6 @@ static int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	return 0;
 }
 
-static bool io_net_retry(struct socket *sock, int flags)
-{
-	if (!(flags & MSG_WAITALL))
-		return false;
-	return sock->type == SOCK_STREAM || sock->type == SOCK_SEQPACKET;
-}
-
 static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_async_msghdr iomsg, *kmsg;
-- 
2.35.1

