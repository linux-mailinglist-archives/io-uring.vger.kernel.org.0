Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8354451D1CF
	for <lists+io-uring@lfdr.de>; Fri,  6 May 2022 09:01:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1387354AbiEFHFA (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 6 May 2022 03:05:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387408AbiEFHE7 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 6 May 2022 03:04:59 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1896C4BFF9;
        Fri,  6 May 2022 00:01:16 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id j8-20020a17090a060800b001cd4fb60dccso6121058pjj.2;
        Fri, 06 May 2022 00:01:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=adYCTp8/5p9sggDjQM6BWyPSAca7Ngfv3XcFgStxjkc=;
        b=IPmiae4btyDW39ftdngHSS1cT5GPzASdQcbJdcxTwWV2jDMoOmIZEpyDC2LMtoLgzF
         cFAfZ9Tut4+y3nhtZXgtYG6dOYZnSMXIbY4jtdpqRf4uEijMi2R99DJruMYx/ncGVCt6
         +3Fi2YGRqCETlYIEj/VlmMAz5Yw62SxIP40MhUxbp3wa80iUeJxgmN5M0l8rfG2wdkTY
         Wq6TKl4ynDUV3KB3/bCD3zspniDsTkicLV1GRhbioqscktKxU62QquZUVmXCXQKNHS1L
         qOnYo8B6mowU+jMdL7FncrumIYtrdPadVgInIBs2jTH1XZ1Q3Qzhhda9LJsruQAewARA
         EJhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=adYCTp8/5p9sggDjQM6BWyPSAca7Ngfv3XcFgStxjkc=;
        b=PerrAkghCzKietf8Q3y3uMOx+YFZj7k0wIrC+SUsq0nvka6K4kOWPnPQC2ZEhKSSl2
         d9630yEzlVPJdMO/3gk4Gy7x/EtoWpzCxJOhhQS/69KIdxbfRk/jKJiyRvg130yTDDMB
         wEppgkRZsN3t1o42FEKG0hEGrsHCrgmUByPldWKnIs8Mo382xB/0+c1JNnr7ApVAHYKY
         wkgABCEesniYajO5l+V2xLGWAlUUK5/GKGN/1mYJRaRH0Y3/YmaoninMnLlqxci7w9hr
         lcKhrhWmaY3rTbN+Unl9blb26Gd9sdnviBRnQSz98x2Oa07cQ+/CK1Tg31au7EKzO5e8
         4p9g==
X-Gm-Message-State: AOAM532UqYTnkLZJuLBHsyKylKRUA3BuqsO+NFGX4SRg/p2TUSXWLuU4
        8xyPBsCisy65P1W0pc5Gc4OPyb0hI+U=
X-Google-Smtp-Source: ABdhPJz0lFpQEH67zBMCtKGc7qra8QdAyFWqh2slDyV2wts8Q2oOcrNvsIbTJ13IwhXpKg1n+flkgg==
X-Received: by 2002:a17:903:244c:b0:15e:b3f7:950d with SMTP id l12-20020a170903244c00b0015eb3f7950dmr2067737pls.9.1651820475432;
        Fri, 06 May 2022 00:01:15 -0700 (PDT)
Received: from HOWEYXU-MB0.tencent.com ([106.53.4.151])
        by smtp.gmail.com with ESMTPSA id bh2-20020a170902a98200b0015e8d4eb2desm813112plb.296.2022.05.06.00.01.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 06 May 2022 00:01:15 -0700 (PDT)
From:   Hao Xu <haoxu.linux@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        Pavel Begunkov <asml.silence@gmail.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] io_uring: implement multishot mode for accept
Date:   Fri,  6 May 2022 15:01:02 +0800
Message-Id: <20220506070102.26032-6-haoxu.linux@gmail.com>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220506070102.26032-1-haoxu.linux@gmail.com>
References: <20220506070102.26032-1-haoxu.linux@gmail.com>
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
---
 fs/io_uring.c | 54 +++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 48 insertions(+), 6 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 0a83ecc457d1..9febe7774dc3 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -1254,6 +1254,7 @@ static int io_close_fixed(struct io_kiocb *req, unsigned int issue_flags);
 static enum hrtimer_restart io_link_timeout_fn(struct hrtimer *timer);
 static void io_eventfd_signal(struct io_ring_ctx *ctx);
 static void io_req_tw_post_queue(struct io_kiocb *req, s32 res, u32 cflags);
+static void io_poll_remove_entries(struct io_kiocb *req);
 
 static struct kmem_cache *req_cachep;
 
@@ -5690,24 +5691,29 @@ static int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 static int io_accept_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_accept *accept = &req->accept;
+	bool multishot;
 
 	if (unlikely(req->ctx->flags & IORING_SETUP_IOPOLL))
 		return -EINVAL;
-	if (sqe->ioprio || sqe->len || sqe->buf_index)
+	if (sqe->len || sqe->buf_index)
 		return -EINVAL;
 
 	accept->addr = u64_to_user_ptr(READ_ONCE(sqe->addr));
 	accept->addr_len = u64_to_user_ptr(READ_ONCE(sqe->addr2));
 	accept->flags = READ_ONCE(sqe->accept_flags);
 	accept->nofile = rlimit(RLIMIT_NOFILE);
+	multishot = !!(READ_ONCE(sqe->ioprio) & IORING_ACCEPT_MULTISHOT);
 
 	accept->file_slot = READ_ONCE(sqe->file_index);
-	if (accept->file_slot && (accept->flags & SOCK_CLOEXEC))
+	if (accept->file_slot && ((accept->flags & SOCK_CLOEXEC) || multishot))
 		return -EINVAL;
 	if (accept->flags & ~(SOCK_CLOEXEC | SOCK_NONBLOCK))
 		return -EINVAL;
 	if (SOCK_NONBLOCK != O_NONBLOCK && (accept->flags & SOCK_NONBLOCK))
 		accept->flags = (accept->flags & ~SOCK_NONBLOCK) | O_NONBLOCK;
+	if (multishot)
+		req->flags |= REQ_F_APOLL_MULTISHOT;
+
 	return 0;
 }
 
@@ -5730,6 +5736,7 @@ static inline void io_poll_clean(struct io_kiocb *req)
 
 static int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 {
+	struct io_ring_ctx *ctx = req->ctx;
 	struct io_accept *accept = &req->accept;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
 	unsigned int file_flags = force_nonblock ? O_NONBLOCK : 0;
@@ -5737,10 +5744,13 @@ static int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 	struct file *file;
 	int ret, fd;
 
+retry:
 	if (!fixed) {
 		fd = __get_unused_fd_flags(accept->flags, accept->nofile);
-		if (unlikely(fd < 0))
+		if (unlikely(fd < 0)) {
+			io_poll_clean(req);
 			return fd;
+		}
 	}
 	file = do_accept(req->file, file_flags, accept->addr, accept->addr_len,
 			 accept->flags);
@@ -5748,8 +5758,12 @@ static int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 		if (!fixed)
 			put_unused_fd(fd);
 		ret = PTR_ERR(file);
-		if (ret == -EAGAIN && force_nonblock)
-			return -EAGAIN;
+		if (ret == -EAGAIN && force_nonblock) {
+			if ((req->flags & REQ_F_APOLL_MULTI_POLLED) ==
+			    REQ_F_APOLL_MULTI_POLLED)
+				ret = 0;
+			return ret;
+		}
 		if (ret == -ERESTARTSYS)
 			ret = -EINTR;
 		req_set_fail(req);
@@ -5760,7 +5774,35 @@ static int io_accept(struct io_kiocb *req, unsigned int issue_flags)
 		ret = io_install_fixed_file(req, file, issue_flags,
 					    accept->file_slot - 1);
 	}
-	__io_req_complete(req, issue_flags, ret, 0);
+
+	if (req->flags & REQ_F_APOLL_MULTISHOT) {
+		if (ret >= 0) {
+			bool filled;
+
+			spin_lock(&ctx->completion_lock);
+			filled = io_fill_cqe_aux(ctx, req->cqe.user_data, ret,
+						 IORING_CQE_F_MORE);
+			io_commit_cqring(ctx);
+			spin_unlock(&ctx->completion_lock);
+			if (unlikely(!filled)) {
+				io_poll_clean(req);
+				return -ECANCELED;
+			}
+			io_cqring_ev_posted(ctx);
+			goto retry;
+		} else {
+			/*
+			 * the apoll multishot req should handle poll
+			 * cancellation by itself since the upper layer
+			 * who called io_queue_sqe() cannot get errors
+			 * happened here.
+			 */
+			io_poll_clean(req);
+			return ret;
+		}
+	} else {
+		__io_req_complete(req, issue_flags, ret, 0);
+	}
 	return 0;
 }
 
-- 
2.36.0

