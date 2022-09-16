Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 644AD5BB405
	for <lists+io-uring@lfdr.de>; Fri, 16 Sep 2022 23:39:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229642AbiIPVjz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 16 Sep 2022 17:39:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229735AbiIPVjy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 16 Sep 2022 17:39:54 -0400
Received: from hr2.samba.org (hr2.samba.org [IPv6:2a01:4f8:192:486::2:0])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AC35183A0
        for <io-uring@vger.kernel.org>; Fri, 16 Sep 2022 14:39:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=samba.org;
        s=42; h=Message-Id:Date:Cc:To:From;
        bh=7r/3CRTEJ4Ti2LV8Jee1aCkQwPQjB3aQ4I+qL2BWcc0=; b=EarU7R68DsdiHPZoM65ZA7RKV5
        XqZls+pW6u+xZuPwdmhjl8JwCwTlr/Kx8GYrW1S04fQxNlGvK5881zSC4p4TRHRAUWzumkPMrl3w9
        1IsTuSscl3K9ICwjXN0HOVq8KUzwDyhrpsjuXFX/FyPD26S/FU67Q5re8fnowDZin438G3AOkQDDg
        0lzq8TifPd9H5YipX6tkOZVxWyTN0sSUrAayvjgbRUp7RZUYkUWrlRClNJrb+JoKNfdeDjnd+JWis
        YOZ4g76LrNnq4hXuP/AaNKpGV5XQ2AKl/ilc2mFqh2IEW0Ex91lhW4Zh39Ce/JB7bADjwBH0PYHA6
        8MKnxRw7OlgkPUCqQI3Ffx4wandrWUfGc4eA7YZ4KqQVkXEEPJ0OrpPx3ffb7I2uObDqZ5457dW5h
        1GRVpKBI+Pd8X/vMz414/Z2QKlNlCXTWKz+ho/YH0SpPvbIKl+k1ou9OGURx0wda97YjV6yC8Q6vc
        wyOVzG659kNXxOaENf/eWGez;
Received: from [127.0.0.2] (localhost [127.0.0.1])
        by hr2.samba.org with esmtpsa (TLS1.3:ECDHE_SECP256R1__ECDSA_SECP256R1_SHA256__CHACHA20_POLY1305:256)
        (Exim)
        id 1oZJ3u-000j7V-QP; Fri, 16 Sep 2022 21:39:51 +0000
From:   Stefan Metzmacher <metze@samba.org>
To:     io-uring@vger.kernel.org, axboe@kernel.dk, asml.silence@gmail.com
Cc:     Stefan Metzmacher <metze@samba.org>
Subject: [PATCH 4/5] io_uring/net: let io_sendzc set IORING_CQE_F_MORE before sock_sendmsg()
Date:   Fri, 16 Sep 2022 23:36:28 +0200
Message-Id: <88c6e27ee0b4a945ccbf347d354cccf862936f55.1663363798.git.metze@samba.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cover.1663363798.git.metze@samba.org>
References: <cover.1663363798.git.metze@samba.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

sock_sendmsg() can take references to the passed buffers even on
failure!

So we need to make sure we'll set IORING_CQE_F_MORE before
calling sock_sendmsg().

As REQ_F_CQE_SKIP for notif and IORING_CQE_F_MORE for the main request
go hand in hand, lets simplify the REQ_F_CQE_SKIP logic too.

We just start with REQ_F_CQE_SKIP set and reset it when we
set IORING_CQE_F_MORE on the main request in order to have
the transition in one isolated place.

In future we might be able to revert IORING_CQE_F_MORE and
!REQ_F_CQE_SKIP again if we find out that no reference was
taken by the network layer. But that's a change for another day.
The important thing would just be that the documentation for
IORING_OP_SEND_ZC would indicate that the kernel may decide
to return just a single cqe without IORING_CQE_F_MORE, even
in the success case, so that userspace would not break when
we add such an optimization at a layer point.

Fixes: b48c312be05e8 ("io_uring/net: simplify zerocopy send user API")
Signed-off-by: Stefan Metzmacher <metze@samba.org>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: io-uring@vger.kernel.org
---
 io_uring/net.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index e9efed40cf3d..61e6194b01b7 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -883,7 +883,6 @@ void io_sendzc_cleanup(struct io_kiocb *req)
 {
 	struct io_sendzc *zc = io_kiocb_to_cmd(req, struct io_sendzc);
 
-	zc->notif->flags |= REQ_F_CQE_SKIP;
 	io_notif_flush(zc->notif);
 	zc->notif = NULL;
 }
@@ -920,6 +919,8 @@ int io_sendzc_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	notif->cqe.user_data = req->cqe.user_data;
 	notif->cqe.res = 0;
 	notif->cqe.flags = IORING_CQE_F_NOTIF;
+	/* skip the notif cqe until we call sock_sendmsg() */
+	notif->flags |= REQ_F_CQE_SKIP;
 	req->flags |= REQ_F_NEED_CLEANUP;
 
 	zc->buf = u64_to_user_ptr(READ_ONCE(sqe->addr));
@@ -1000,7 +1001,7 @@ int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
 	struct msghdr msg;
 	struct iovec iov;
 	struct socket *sock;
-	unsigned msg_flags, cflags;
+	unsigned msg_flags;
 	int ret, min_ret = 0;
 
 	sock = sock_from_file(req->file);
@@ -1055,6 +1056,15 @@ int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
 	msg.msg_flags = msg_flags;
 	msg.msg_ubuf = &io_notif_to_data(zc->notif)->uarg;
 	msg.sg_from_iter = io_sg_from_iter;
+
+	/*
+	 * Now that we call sock_sendmsg,
+	 * we need to assume that the data is referenced
+	 * even on failure!
+	 * So we need to force a NOTIF cqe
+	 */
+	zc->notif->flags &= ~REQ_F_CQE_SKIP;
+	req->cqe.flags |= IORING_CQE_F_MORE;
 	ret = sock_sendmsg(sock, &msg);
 
 	if (unlikely(ret < min_ret)) {
@@ -1068,8 +1078,6 @@ int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
 			req->flags |= REQ_F_PARTIAL_IO;
 			return io_setup_async_addr(req, addr, issue_flags);
 		}
-		if (ret < 0 && !zc->done_io)
-			zc->notif->flags |= REQ_F_CQE_SKIP;
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
 		req_set_fail(req);
@@ -1082,8 +1090,7 @@ int io_sendzc(struct io_kiocb *req, unsigned int issue_flags)
 
 	io_notif_flush(zc->notif);
 	req->flags &= ~REQ_F_NEED_CLEANUP;
-	cflags = ret >= 0 ? IORING_CQE_F_MORE : 0;
-	io_req_set_res(req, ret, cflags);
+	io_req_set_res(req, ret, req->cqe.flags);
 	return IOU_OK;
 }
 
-- 
2.34.1

