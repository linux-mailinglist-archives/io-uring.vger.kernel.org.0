Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AADB051E81A
	for <lists+io-uring@lfdr.de>; Sat,  7 May 2022 17:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239197AbiEGPYJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 7 May 2022 11:24:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229983AbiEGPXs (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 7 May 2022 11:23:48 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9844A403E7;
        Sat,  7 May 2022 08:19:59 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id g3so8467061pgg.3;
        Sat, 07 May 2022 08:19:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oPC57eGRzrZao/L+XK5ONaCj2oS1ex/u9qNmJAXq7uE=;
        b=iYcNJHCZaR59bK/QD2LgguVmlVGzroWoLii7IIkIRHLdCBcES3ietCiBsJCgUSKZyi
         a9moUpAHWdXkYoQKDXMkYHD4+yaWFyWvBxIKttB397zx6sEpuec87qcOjoLNQMyGObjg
         1FthxKu0o2pf2vkgjtCbwL4DNBMOKtCECA6HDSJ1PTkyvlRbDorywNFXMOPn32lVc5a4
         fZaMln/CaIRbVgt6x2fUBCgN3R/cVPwks7XzIq9+7GZ/OhDaGmJ2w8iTGxxREQExEvLI
         Ew1uGE+wLgM9SZBPlJXUwhphoQrfNjPvXPhU1SWPbEfb4ryFyljj/ia/JuuS3wW6DP5C
         hauw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=oPC57eGRzrZao/L+XK5ONaCj2oS1ex/u9qNmJAXq7uE=;
        b=P4Xn9DrNhTQBv2jRRh7gqRlVTVWH4P3ldFWW8wP/IIkoCIHigTcp+RelHjBM+hTCR7
         7ilCxzRnuwHx+1//KI5XC6rdYqeqbx2Vl4Qakp0pmCO/kU4Q6TXyrJA6ztyW+oMbAdPT
         mpz5jKqTkA4QI6vkR0/T3VByX5KLvPlF/GBn/woVXog8/plXdR12EcBI3sgewqiPRmFM
         ERC4StlRbjiciDBTM2bIGIUQ4dugCypdayHET/L01c/c8oJc+1Ej1msN6dL8SQM451Vz
         1MATPaRUtj5ttUnViR7+6UJ/Jk7tK82vFNnrvnxqiiknax2Wd9kNomSu1ytv0XrUxn0C
         HTsw==
X-Gm-Message-State: AOAM533Gkr3Hu3m4QFpzUhiRS1LoWcSuLzoE97SIj1+5qmgpHmAXJIfl
        CHfy2WzgT5lnv2VXolFAgfkXV0lNXjvnrmuoXjY=
X-Google-Smtp-Source: ABdhPJw38GW7Jd9/T5ZKyY83NXcHUHvsQXKyX+wEJH7Xs4drgImtlSnXhRKnwAo8SfVTi2iPYpuSDA==
X-Received: by 2002:aa7:9d0d:0:b0:50d:4fcc:7cb1 with SMTP id k13-20020aa79d0d000000b0050d4fcc7cb1mr8228419pfp.41.1651936798805;
        Sat, 07 May 2022 08:19:58 -0700 (PDT)
Received: from HOWEYXU-MB0.tencent.com ([203.205.141.111])
        by smtp.gmail.com with ESMTPSA id p3-20020a622903000000b0050dc76281edsm5381003pfp.199.2022.05.07.08.19.57
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 07 May 2022 08:19:58 -0700 (PDT)
From:   Hao Xu <haoxu.linux@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 4/4] io_uring: implement multishot mode for accept
Date:   Sat,  7 May 2022 23:20:09 +0800
Message-Id: <20220507152009.87367-1-haoxu.linux@gmail.com>
X-Mailer: git-send-email 2.36.0
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
              add accept sqe(userpsace) --> accept inline
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
[fold in setting io_op_def->ioprio for accept and other cleaning up]
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 fs/io_uring.c                 | 42 ++++++++++++++++++++++++++++++-----
 include/uapi/linux/io_uring.h |  4 ++--
 2 files changed, 39 insertions(+), 7 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index e0d12af04cd1..f21172913336 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1146,6 +1146,7 @@ static const struct io_op_def io_op_defs[] = {
 		.unbound_nonreg_file	= 1,
 		.pollin			= 1,
 		.poll_exclusive		= 1,
+		.ioprio			= 1,	/* used for flags */
 	},
 	[IORING_OP_ASYNC_CANCEL] = {
 		.audit_skip		= 1,
@@ -5706,6 +5707,7 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_accept *accept = &req->accept;
+	unsigned flags;
 
 	if (sqe->len || sqe->buf_index)
 		return -EINVAL;
@@ -5714,19 +5716,26 @@ static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	accept->addr_len = u64_to_user_ptr(READ_ONCE(sqe->addr2));
 	accept->flags = READ_ONCE(sqe->accept_flags);
 	accept->nofile = rlimit(RLIMIT_NOFILE);
+	flags = READ_ONCE(sqe->ioprio);
+	if (flags & ~IORING_ACCEPT_MULTISHOT)
+		return -EINVAL;
 
 	accept->file_slot = READ_ONCE(sqe->file_index);
-	if (accept->file_slot && (accept->flags & SOCK_CLOEXEC))
+	if (accept->file_slot && ((accept->flags & SOCK_CLOEXEC) ||
+	   flags & IORING_ACCEPT_MULTISHOT))
 		return -EINVAL;
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
@@ -5734,6 +5743,7 @@ static int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 	struct file *file;
 	int ret, fd;
 
+retry:
 	if (!fixed) {
 		fd = __get_unused_fd_flags(accept->flags, accept->nofile);
 		if (unlikely(fd < 0))
@@ -5745,8 +5755,12 @@ static int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 		if (!fixed)
 			put_unused_fd(fd);
 		ret = PTR_ERR(file);
-		if (ret == -EAGAIN && force_nonblock)
-			return -EAGAIN;
+		if (ret == -EAGAIN && force_nonblock) {
+			if ((req->flags & IO_APOLL_MULTI_POLLED) ==
+			    IO_APOLL_MULTI_POLLED)
+				ret = 0;
+			return ret;
+		}
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
 		req_set_fail(req);
@@ -5757,8 +5771,26 @@ static int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 		ret = io_install_fixed_file(req, file, issue_flags,
 					    accept->file_slot - 1);
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
+		if (!filled)
+			return -ECANCELED;
+		io_cqring_ev_posted(ctx);
+		goto retry;
+	}
+
+	return ret;
 }
 
 static int io_connect_prep_async(struct io_kiocb *req)
diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index f4d9ca62a5a6..7c3d70d12428 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -224,9 +224,9 @@ enum {
 #define IORING_RECVSEND_POLL_FIRST	(1U << 0)
 
 /*
- * accept flags stored in accept_flags
+ * accept flags stored in sqe->ioprio
  */
-#define IORING_ACCEPT_MULTISHOT	(1U << 15)
+#define IORING_ACCEPT_MULTISHOT	(1U << 0)
 
 /*
  * IO completion data structure (Completion Queue Entry)
-- 
2.36.0

