Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3D35271E3
	for <lists+io-uring@lfdr.de>; Sat, 14 May 2022 16:20:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233121AbiENOUm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 14 May 2022 10:20:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233155AbiENOUk (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 14 May 2022 10:20:40 -0400
Received: from mail-pg1-x536.google.com (mail-pg1-x536.google.com [IPv6:2607:f8b0:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B0629FCB
        for <io-uring@vger.kernel.org>; Sat, 14 May 2022 07:20:38 -0700 (PDT)
Received: by mail-pg1-x536.google.com with SMTP id v10so10027190pgl.11
        for <io-uring@vger.kernel.org>; Sat, 14 May 2022 07:20:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=cg/ciI7F+YQchIATLN/F9rg5PShOW5D8D7HnDBc9m7g=;
        b=FZzggD67gCOocjHs6WVqYVLIqDZ2lVJwr4vkXrxIETzmGvcfI1AibRImJFTBAL2CeZ
         c5UA6+XemluRvAM/9GaOwYbxHEn+TCKUc1aV3rHVs7AvTmxxhb7tLekzawcGq0+NgwYb
         kXpl/QZBMs6vaxNs/GzHRRtyVTrLvC8qIqh7vWTBuAlo+1ZGzaG8TY9qiiukl3hosj9F
         6TXqC7bhLB0nKs3IOngTqMCFKGo3VbBg2Kq30nbmkk/NuW9Zal2RALYXW6ox6X2krpKO
         hbI/BTYHI4IN6KfmV1WiofQ8whamH+/F41QW52ZV5cABztKwxgpHi1mPmeJG3MkCO/bf
         yjSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=cg/ciI7F+YQchIATLN/F9rg5PShOW5D8D7HnDBc9m7g=;
        b=P6kE86nVeusBSyAwjf73RZR3oW5o6hnsRrB8xTJD93fUIIoUnQT9Nvo1trKnKfTaxl
         /6+hCM4BiYqgOgtCffee8yfvnVP0vyNpccmUb47ZTKfkHBqpJdxAZMkuHsVKMviRB82P
         JB+n9Kl2z5rvMINmuIfex/jwYH8kOfyyLBfPeMdUmLIKOqXKhsteXkET6pjpIe44QKIt
         rNdosyGStTSC8zxQkpi6wBMcuE8R+KWiYKzlOvJ2D75U19Jo0oPthyn5A3ySmrRC2GRt
         /+FBpYLMRlEXLBriJmcZZeXTw+Yd9hiSaLb6t/ni+ddmxvOB8w702KMzkRYkMCpGpH6l
         ce4g==
X-Gm-Message-State: AOAM533t88NpHUAr8TLQEeESrJiquJA3fCAvKWmqEYQknGBKKJ8kbcMB
        AH/kkPBGW89nqx9NpeYVk2I496MX6SEMJkxs
X-Google-Smtp-Source: ABdhPJwPL0kPkMC0DU3KyFiP7F7DPeNeeFMw7ofvP+cPDCI7itT9g6TySVsgUKoliE2dGWqpmR1dog==
X-Received: by 2002:a63:f1e:0:b0:3c1:d54f:fc47 with SMTP id e30-20020a630f1e000000b003c1d54ffc47mr8315403pgl.51.1652538037633;
        Sat, 14 May 2022 07:20:37 -0700 (PDT)
Received: from HOWEYXU-MB0.tencent.com ([203.205.141.27])
        by smtp.gmail.com with ESMTPSA id o15-20020a170902d4cf00b0015e8d4eb27csm3815968plg.198.2022.05.14.07.20.36
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 14 May 2022 07:20:37 -0700 (PDT)
From:   Hao Xu <haoxu.linux@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 4/4] io_uring: implement multishot mode for accept
Date:   Sat, 14 May 2022 22:20:46 +0800
Message-Id: <20220514142046.58072-5-haoxu.linux@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220514142046.58072-1-haoxu.linux@gmail.com>
References: <20220514142046.58072-1-haoxu.linux@gmail.com>
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

From: Hao Xu <howeyxu@tencent.com>

Refactor io_accept() to support multishot mode.

theoretical analysis:
  1) when connections come in fast
    - singleshot:
              add accept sqe(userspace) --> accept inline
                              ^                 |
                              |-----------------|
    - multishot:
             add accept sqe(userspace) --> accept inline
                                              ^     |
                                              |--*--|

    we do accept repeatedly in * place until get EAGAIN

  2) when connections come in at a low pressure
    similar thing like 1), we reduce a lot of userspace-kernel context
    switch and useless vfs_poll()

tests:
Did some tests, which goes in this way:

  server    client(multiple)
  accept    connect
  read      write
  write     read
  close     close

Basically, raise up a number of clients(on same machine with server) to
connect to the server, and then write some data to it, the server will
write those data back to the client after it receives them, and then
close the connection after write return. Then the client will read the
data and then close the connection. Here I test 10000 clients connect
one server, data size 128 bytes. And each client has a go routine for
it, so they come to the server in short time.
test 20 times before/after this patchset, time spent:(unit cycle, which
is the return value of clock())
before:
  1930136+1940725+1907981+1947601+1923812+1928226+1911087+1905897+1941075
  +1934374+1906614+1912504+1949110+1908790+1909951+1941672+1969525+1934984
  +1934226+1914385)/20.0 = 1927633.75
after:
  1858905+1917104+1895455+1963963+1892706+1889208+1874175+1904753+1874112
  +1874985+1882706+1884642+1864694+1906508+1916150+1924250+1869060+1889506
  +1871324+1940803)/20.0 = 1894750.45

(1927633.75 - 1894750.45) / 1927633.75 = 1.65%

Signed-off-by: Hao Xu <howeyxu@tencent.com>
---
 fs/io_uring.c | 54 +++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 48 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index a83405f657e0..d4752e192ef9 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1148,6 +1148,7 @@ static const struct io_op_def io_op_defs[] = {
 		.unbound_nonreg_file	= 1,
 		.pollin			= 1,
 		.poll_exclusive		= 1,
+		.ioprio			= 1,	/* used for flags */
 	},
 	[IORING_OP_ASYNC_CANCEL] = {
 		.audit_skip		= 1,
@@ -5762,6 +5763,7 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_accept *accept = &req->accept;
+	unsigned flags;
 
 	if (sqe->len || sqe->buf_index)
 		return -EINVAL;
@@ -5770,19 +5772,30 @@ static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	accept->addr_len = u64_to_user_ptr(READ_ONCE(sqe->addr2));
 	accept->flags = READ_ONCE(sqe->accept_flags);
 	accept->nofile = rlimit(RLIMIT_NOFILE);
+	flags = READ_ONCE(sqe->ioprio);
+	if (flags & ~IORING_ACCEPT_MULTISHOT)
+		return -EINVAL;
 
 	accept->file_slot = READ_ONCE(sqe->file_index);
-	if (accept->file_slot && (accept->flags & SOCK_CLOEXEC))
-		return -EINVAL;
+	if (accept->file_slot) {
+		if (accept->flags & SOCK_CLOEXEC)
+			return -EINVAL;
+		if (flags & IORING_ACCEPT_MULTISHOT &&
+		    accept->file_slot != IORING_FILE_INDEX_ALLOC)
+			return -EINVAL;
+	}
 	if (accept->flags & ~(SOCK_CLOEXEC | SOCK_NONBLOCK))
 		return -EINVAL;
 	if (SOCK_NONBLOCK != O_NONBLOCK && (accept->flags & SOCK_NONBLOCK))
 		accept->flags = (accept->flags & ~SOCK_NONBLOCK) | O_NONBLOCK;
+	if (flags & IORING_ACCEPT_MULTISHOT)
+		req->flags |= REQ_F_APOLL_MULTISHOT;
 	return 0;
 }
 
 static int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 {
+	struct io_ring_ctx *ctx = req->ctx;
 	struct io_accept *accept = &req->accept;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 	unsigned int file_flags = force_nonblock ? O_NONBLOCK : 0;
@@ -5790,6 +5803,7 @@ static int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 	struct file *file;
 	int ret, fd;
 
+retry:
 	if (!fixed) {
 		fd = __get_unused_fd_flags(accept->flags, accept->nofile);
 		if (unlikely(fd < 0))
@@ -5801,8 +5815,17 @@ static int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 		if (!fixed)
 			put_unused_fd(fd);
 		ret = PTR_ERR(file);
-		if (ret == -EAGAIN && force_nonblock)
-			return -EAGAIN;
+		if (ret == -EAGAIN && force_nonblock) {
+			/*
+			 * if it's multishot and polled, we don't need to
+			 * return EAGAIN to arm the poll infra since it
+			 * has already been done
+			 */
+			if ((req->flags & IO_APOLL_MULTI_POLLED) ==
+			    IO_APOLL_MULTI_POLLED)
+				ret = 0;
+			return ret;
+		}
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
 		req_set_fail(req);
@@ -5813,8 +5836,27 @@ static int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 		ret = io_fixed_fd_install(req, issue_flags, file,
 						accept->file_slot);
 	}
-	__io_req_complete(req, issue_flags, ret, 0);
-	return 0;
+
+	if (!(req->flags & REQ_F_APOLL_MULTISHOT)) {
+		__io_req_complete(req, issue_flags, ret, 0);
+		return 0;
+	}
+	if (ret >= 0) {
+		bool filled;
+
+		spin_lock(&ctx->completion_lock);
+		filled = io_fill_cqe_aux(ctx, req->cqe.user_data, ret,
+					 IORING_CQE_F_MORE);
+		io_commit_cqring(ctx);
+		spin_unlock(&ctx->completion_lock);
+		if (filled) {
+			io_cqring_ev_posted(ctx);
+			goto retry;
+		}
+		ret = -ECANCELED;
+	}
+
+	return ret;
 }
 
 static int io_connect_prep_async(struct io_kiocb *req)
-- 
2.36.0

