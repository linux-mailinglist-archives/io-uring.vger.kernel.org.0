Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4BB9E7071A4
	for <lists+io-uring@lfdr.de>; Wed, 17 May 2023 21:12:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbjEQTMm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 17 May 2023 15:12:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbjEQTMg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 17 May 2023 15:12:36 -0400
Received: from mail-il1-x12e.google.com (mail-il1-x12e.google.com [IPv6:2607:f8b0:4864:20::12e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99B7CD056
        for <io-uring@vger.kernel.org>; Wed, 17 May 2023 12:12:20 -0700 (PDT)
Received: by mail-il1-x12e.google.com with SMTP id e9e14a558f8ab-334d0f0d537so556665ab.0
        for <io-uring@vger.kernel.org>; Wed, 17 May 2023 12:12:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1684350739; x=1686942739;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tg7+MaJ3NXxHlUMUvA6Q1ZlXCnsNrLvuDCIr3Vu4cXA=;
        b=VV4RAx1jp1Pa3CEtIa7z4N6VATlDcNggv45q3/FNLoc4qLN3gvfEkNaBi0KBhQCrQr
         nAjIFbaF4lwBtNGu/q70OJMCF2qB8+V8WqE4reYoWZobXS1ZX6fQkWTLW/Y05w5uL5JB
         +bbbnyER3n+LCl/5uQRqbUJA/cP4j3Td/URet4vlHNsAi0esNLWLXpsk283lJEJDDIdA
         GME0j4lmjmp6Gz+9kmEjM1gNP+cgypY+k0L2o1dJlsYl8ZzNy+tGDCj5sc659JHmsx8W
         OI81yboof2hEaGv/LVTL9Pi4uDZMdMJ/x3fPVVFbpuNLDGtjk8/v1E8jrfiR/uv0lGhc
         GFvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684350739; x=1686942739;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tg7+MaJ3NXxHlUMUvA6Q1ZlXCnsNrLvuDCIr3Vu4cXA=;
        b=ZOJzUio4lc06FRPz1eSaM8rymWGjbhjp1QYUZZ8ekvLXd0/fKL+W5YKHLa1SdSXNaT
         gvF0qOBs3eERK9ZUPGdHcuD/NDn50A6uiba0tfkpTzQar/fwHy+agp2X0pClmbVDHca2
         R0Mq4Z1VbYSARXWpT35FxmlfnL/XtuJ3FiGLrbZxGDBZMUrCf2o0sZhHk+H4Cf6b3qr7
         Zwj5RAHrQrUoLMGRxwL2CFT16pO8e8gGj+ipCBx0YZZE65k2OBgBSdqKGi6uzJgJI4Hq
         mYXUpYqa5CYtGkvcV3L4kPnTj7miwVdL972DBe0HplNQYN56jcrXKPiSAw7pDwt6QcTI
         8nEA==
X-Gm-Message-State: AC+VfDy91sMwgl4uHt7Wo3KnwarsKuShxsc/NqQRn2jUwJVGj8w5TLuB
        SBbTrXOcR8dp6M14dfo859nzaaSdYYV8r9cd9Rk=
X-Google-Smtp-Source: ACHHUZ7ryTY2lXLnU9SThKhbjdZK1fBzntGkDAnaqFJxJGvs6eNYZjgcHhyxJ6ngX19HI/apuW2Khg==
X-Received: by 2002:a92:7604:0:b0:32a:8792:7248 with SMTP id r4-20020a927604000000b0032a87927248mr2171990ilc.2.1684350738813;
        Wed, 17 May 2023 12:12:18 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id b16-20020a92db10000000b0033827a77e24sm628996iln.50.2023.05.17.12.12.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 May 2023 12:12:17 -0700 (PDT)
From:   Jens Axboe <axboe@kernel.dk>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/4] io_uring/net: push IORING_CQE_F_SOCK_NONEMPTY into io_recv_finish()
Date:   Wed, 17 May 2023 13:12:02 -0600
Message-Id: <20230517191203.2077682-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230517191203.2077682-1-axboe@kernel.dk>
References: <20230517191203.2077682-1-axboe@kernel.dk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Rather than have this logic in both io_recv() and io_recvmsg_multishot(),
push it into the handler they both call when finishing a receive
operation.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/net.c | 22 +++++++++-------------
 1 file changed, 9 insertions(+), 13 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index 45f9c3046d67..9e0034771dbb 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -616,9 +616,15 @@ static inline void io_recv_prep_retry(struct io_kiocb *req)
  * again (for multishot).
  */
 static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
-				  unsigned int cflags, bool mshot_finished,
+				  struct msghdr *msg, bool mshot_finished,
 				  unsigned issue_flags)
 {
+	unsigned int cflags;
+
+	cflags = io_put_kbuf(req, issue_flags);
+	if (msg->msg_inq && msg->msg_inq != -1U)
+		cflags |= IORING_CQE_F_SOCK_NONEMPTY;
+
 	if (!(req->flags & REQ_F_APOLL_MULTISHOT)) {
 		io_req_set_res(req, *ret, cflags);
 		*ret = IOU_OK;
@@ -732,7 +738,6 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct io_async_msghdr iomsg, *kmsg;
 	struct socket *sock;
-	unsigned int cflags;
 	unsigned flags;
 	int ret, min_ret = 0;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
@@ -821,11 +826,7 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 	else
 		io_kbuf_recycle(req, issue_flags);
 
-	cflags = io_put_kbuf(req, issue_flags);
-	if (kmsg->msg.msg_inq && kmsg->msg.msg_inq != -1U)
-		cflags |= IORING_CQE_F_SOCK_NONEMPTY;
-
-	if (!io_recv_finish(req, &ret, cflags, mshot_finished, issue_flags))
+	if (!io_recv_finish(req, &ret, &kmsg->msg, mshot_finished, issue_flags))
 		goto retry_multishot;
 
 	if (mshot_finished) {
@@ -844,7 +845,6 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	struct io_sr_msg *sr = io_kiocb_to_cmd(req, struct io_sr_msg);
 	struct msghdr msg;
 	struct socket *sock;
-	unsigned int cflags;
 	unsigned flags;
 	int ret, min_ret = 0;
 	bool force_nonblock = issue_flags & IO_URING_F_NONBLOCK;
@@ -924,11 +924,7 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	else
 		io_kbuf_recycle(req, issue_flags);
 
-	cflags = io_put_kbuf(req, issue_flags);
-	if (msg.msg_inq && msg.msg_inq != -1U)
-		cflags |= IORING_CQE_F_SOCK_NONEMPTY;
-
-	if (!io_recv_finish(req, &ret, cflags, ret <= 0, issue_flags))
+	if (!io_recv_finish(req, &ret, &msg, ret <= 0, issue_flags))
 		goto retry_multishot;
 
 	return ret;
-- 
2.39.2

