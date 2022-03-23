Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70B764E5B68
	for <lists+io-uring@lfdr.de>; Wed, 23 Mar 2022 23:41:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345320AbiCWWnL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 23 Mar 2022 18:43:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345317AbiCWWnL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 23 Mar 2022 18:43:11 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B93C7CB23
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 15:41:41 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id p8so2526789pfh.8
        for <io-uring@vger.kernel.org>; Wed, 23 Mar 2022 15:41:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GyD1v7D79DKaDQXiOqe9cAvlgJX3WdNWjGRFUrkAIV0=;
        b=NqaTNl6E7+0nr7+CtMpgE/iceNOPlcjUuDgE8izKLSaGE75zHe7CTqi3aZrnH9Kwzq
         Zw40NJcuu9d4/jT6vMhupLgw/mHHemmX45sZibYy7pxRahT0VxAPZC3MkVjLoBTBQzrY
         YGTL99A4Azc5snhjVRYC2ZGOvGXIbK28mofasJO1Og2e68P2Jym/jiwA4UzlP4UveAMN
         AiDDb82CjYkApLcmRvDqNqgN+zVm47PogGXjJ1KWAkchTXxceX0v17m0hR7p3L+7deBG
         ibiV7rw5BWLh1ywkoHgfxVfW7I922U+q8+dNrbk5EOoIuaXGYB9aflUcNIIVFnef2gg7
         NDVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GyD1v7D79DKaDQXiOqe9cAvlgJX3WdNWjGRFUrkAIV0=;
        b=8E1BwZOikVI7Ql6kaPEN4AP7Bc6Kn1QAsQmUnmoLnYyMjhWoLrTV6OGQ5mlfIogO/n
         K7LlSX361hLp3PHOHiJaoZBhCjBLpbkRME9HZcu0dEVdh8oaWQcdKuKHXOjpj77X9vaV
         8LHPaJrelU2Tet+Ju72rq6cS98YZEPrz1smJTeqTk9Cv/NqQjtkODrDF/+LBxva3PMaI
         nOlQRuO3yQ3q8K1ohr4ggODbzPq6huylWTyUy9Kvv275YeVOmD4FDfi8poICDqUC1rMD
         sV2/60JPJL6qIGmJS1PY5ILXpxKkS66A89WnjRGCNZr54vZ3O0WVBTboY/MnGt/sTkkc
         LO9g==
X-Gm-Message-State: AOAM5301p61Y5wwuothJ4ptzMkmkZWYwX2LrFjhonFTNET/z6JUuK6D3
        vi7S7evlRx1dikRzSY/TC+/4l3rkqrsku089
X-Google-Smtp-Source: ABdhPJwSIq6zuKX2nX18dAkg6qUiZa7bKI1dWKb8CBLuIMzBY/jm2oD1JdoHzd/nBo4SSFo4aCHm7g==
X-Received: by 2002:a05:6a00:2484:b0:4fa:997e:3290 with SMTP id c4-20020a056a00248400b004fa997e3290mr1921385pfv.37.1648075300572;
        Wed, 23 Mar 2022 15:41:40 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id g5-20020a056a001a0500b004def10341e5sm867839pfv.22.2022.03.23.15.41.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 23 Mar 2022 15:41:40 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     constantine.gavrilov@gmail.com, Jens Axboe <axboe@kernel.dk>,
        stable@vger.kernel.org
Subject: [PATCH 1/2] io_uring: ensure recv and recvmsg handle MSG_WAITALL correctly
Date:   Wed, 23 Mar 2022 16:41:30 -0600
Message-Id: <20220323224131.370674-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220323224131.370674-1-axboe@kernel.dk>
References: <20220323224131.370674-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We currently don't attempt to get the full asked for length even if
MSG_WAITALL is set, if we get a partial receive. If we do see a partial
receive, then just note how many bytes we did and return -EAGAIN to
get it retried.

The iov is advanced appropriately for the vector based case, and we
manually bump the buffer and remainder for the non-vector case.

Cc: stable@vger.kernel.org
Reported-by: Constantine Gavrilov <constantine.gavrilov@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c | 28 ++++++++++++++++++++++++++++
 1 file changed, 28 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index f41d91ce1fd0..a70de170aea1 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -612,6 +612,7 @@ struct io_sr_msg {
 	int				msg_flags;
 	int				bgid;
 	size_t				len;
+	size_t				done_io;
 };
 
 struct io_open {
@@ -5417,12 +5418,21 @@ static int io_recvmsg_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (req->ctx->compat)
 		sr->msg_flags |= MSG_CMSG_COMPAT;
 #endif
+	sr->done_io = 0;
 	return 0;
 }
 
+static bool io_net_retry(struct socket *sock, int flags)
+{
+	if (!(flags & MSG_WAITALL))
+		return false;
+	return sock->type == SOCK_STREAM || sock->type == SOCK_SEQPACKET;
+}
+
 static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_async_msghdr iomsg, *kmsg;
+	struct io_sr_msg *sr = &req->sr_msg;
 	struct socket *sock;
 	struct io_buffer *kbuf;
 	unsigned flags;
@@ -5465,6 +5475,10 @@ static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 			return io_setup_async_msg(req, kmsg);
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
+		if (ret > 0 && io_net_retry(sock, flags)) {
+			sr->done_io += ret;
+			return io_setup_async_msg(req, kmsg);
+		}
 		req_set_fail(req);
 	} else if ((flags & MSG_WAITALL) && (kmsg->msg.msg_flags & (MSG_TRUNC | MSG_CTRUNC))) {
 		req_set_fail(req);
@@ -5474,6 +5488,10 @@ static int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 	if (kmsg->free_iov)
 		kfree(kmsg->free_iov);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
+	if (ret >= 0)
+		ret += sr->done_io;
+	else if (sr->done_io)
+		ret = sr->done_io;
 	__io_req_complete(req, issue_flags, ret, io_put_kbuf(req, issue_flags));
 	return 0;
 }
@@ -5524,12 +5542,22 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 			return -EAGAIN;
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
+		if (ret > 0 && io_net_retry(sock, flags)) {
+			sr->len -= ret;
+			sr->buf += ret;
+			sr->done_io += ret;
+			return -EAGAIN;
+		}
 		req_set_fail(req);
 	} else if ((flags & MSG_WAITALL) && (msg.msg_flags & (MSG_TRUNC | MSG_CTRUNC))) {
 out_free:
 		req_set_fail(req);
 	}
 
+	if (ret >= 0)
+		ret += sr->done_io;
+	else if (sr->done_io)
+		ret = sr->done_io;
 	__io_req_complete(req, issue_flags, ret, io_put_kbuf(req, issue_flags));
 	return 0;
 }
-- 
2.35.1

