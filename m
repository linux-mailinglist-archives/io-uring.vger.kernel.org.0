Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF3DB62E486
	for <lists+io-uring@lfdr.de>; Thu, 17 Nov 2022 19:41:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240648AbiKQSlC (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 17 Nov 2022 13:41:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240577AbiKQSlB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 17 Nov 2022 13:41:01 -0500
Received: from mail-ej1-x62a.google.com (mail-ej1-x62a.google.com [IPv6:2a00:1450:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1AC27FF1B
        for <io-uring@vger.kernel.org>; Thu, 17 Nov 2022 10:40:58 -0800 (PST)
Received: by mail-ej1-x62a.google.com with SMTP id f18so7331844ejz.5
        for <io-uring@vger.kernel.org>; Thu, 17 Nov 2022 10:40:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QxPM/0lmBTQJa6FrJYMZxkoIJ/3XNWdBGRKDXQaCDaU=;
        b=BsanThgnaM9uPjyq9ZAkSYw/kosaYat9PokkJO+BHTzMbzG4j1bzzchwRL0Q85noOc
         75ryFmaaigSZXUoe1oa8HosyfC8JPnXyT1m5JwVW+A235npDw/8+zdCvFw3BQC/O2PKn
         MDysMarQPGWlwLcL7lLcujfF29Lguimie7JEC4JZAOAH5yOUgUSZH4TkWgY4XR2wrd6W
         gzasrNIL29sS/dTZkE0+MW4PmB0Q9H5orfHEkUXSVpE2ASo1EzKco9AvlqiDC9YG6B4D
         yaVnEDn6uN1cfhdgK40MMY+X5IpMzIrKg7PHPqsY/aRWCOe871B6Ys2gxjW+V6sod/Q+
         UNFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QxPM/0lmBTQJa6FrJYMZxkoIJ/3XNWdBGRKDXQaCDaU=;
        b=KM9vEqpYeHMhy4G+ux6/4cGtpjloqdrg/3hDYW2l0O6K3bw8qRYy+ptctLsgfYng1s
         C/JthwgUPPYo5vzRjRyNsX3NhNlEZi2Pc80WCWN6NTFRT43SFeO9EZ8k7oB8maxAGgNh
         vMAwDuUFNXdea/bq9RNMDdE6Zw+suWEudsZDyzJ5+37+rneibpimoA4t/mtFN6qSIgE1
         fbM3JjRkgemYEIWjKPfBRzwAUqCozzwkkV5Y17FtYd58G+crExH0tQETOWHoevu0dW+s
         n9eyaiEzAQguR3x5D8gs6sAUKP20JuqTjMYiHlbbJ+5k3iLedtaZRjjVrHoJ33tosgAB
         SA8w==
X-Gm-Message-State: ANoB5pmUY+C0Y7mUH09vtbjqTRn+N51M3z/iZeJ4sxybg6F3Nl5VP6C7
        hwEJMCxWtd9/J+THyxaZxjDOtTeJI40=
X-Google-Smtp-Source: AA0mqf4Re6+hvn8P42Dbjx7I9A8wXOgLTFSTw0ATNW/EtYIZleM3jserUv8j2DCaHw52sop381M6nA==
X-Received: by 2002:a17:906:8503:b0:7ad:8480:309d with SMTP id i3-20020a170906850300b007ad8480309dmr3195880ejx.156.1668710457184;
        Thu, 17 Nov 2022 10:40:57 -0800 (PST)
Received: from 127.0.0.1localhost (188.28.224.148.threembb.co.uk. [188.28.224.148])
        by smtp.gmail.com with ESMTPSA id kx4-20020a170907774400b007838e332d78sm685486ejc.128.2022.11.17.10.40.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Nov 2022 10:40:56 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH for-6.1 4/4] io_uring: fix multishot recv request leaks
Date:   Thu, 17 Nov 2022 18:40:17 +0000
Message-Id: <37762040ba9c52b81b92a2f5ebfd4ee484088951.1668710222.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <cover.1668710222.git.asml.silence@gmail.com>
References: <cover.1668710222.git.asml.silence@gmail.com>
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

Having REQ_F_POLLED set doesn't guarantee that the request is
executed as a multishot from the polling path. Fortunately for us, if
the code thinks it's multishot issue when it's not, it can only ask to
skip completion so leaking the request. Use issue_flags to mark
multipoll issues.

Cc: stable@vger.kernel.org
Fixes: 1300ebb20286b ("io_uring: multishot recv")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/net.c | 16 +++++++---------
 1 file changed, 7 insertions(+), 9 deletions(-)

diff --git a/io_uring/net.c b/io_uring/net.c
index a390d3ea486c..ab83da7e80f0 100644
--- a/io_uring/net.c
+++ b/io_uring/net.c
@@ -67,8 +67,6 @@ struct io_sr_msg {
 	struct io_kiocb 		*notif;
 };
 
-#define IO_APOLL_MULTI_POLLED (REQ_F_APOLL_MULTISHOT | REQ_F_POLLED)
-
 int io_shutdown_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_shutdown *shutdown = io_kiocb_to_cmd(req, struct io_shutdown);
@@ -591,7 +589,8 @@ static inline void io_recv_prep_retry(struct io_kiocb *req)
  * again (for multishot).
  */
 static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
-				  unsigned int cflags, bool mshot_finished)
+				  unsigned int cflags, bool mshot_finished,
+				  unsigned issue_flags)
 {
 	if (!(req->flags & REQ_F_APOLL_MULTISHOT)) {
 		io_req_set_res(req, *ret, cflags);
@@ -614,7 +613,7 @@ static inline bool io_recv_finish(struct io_kiocb *req, int *ret,
 
 	io_req_set_res(req, *ret, cflags);
 
-	if (req->flags & REQ_F_POLLED)
+	if (issue_flags & IO_URING_F_MULTISHOT)
 		*ret = IOU_STOP_MULTISHOT;
 	else
 		*ret = IOU_OK;
@@ -773,8 +772,7 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 	if (ret < min_ret) {
 		if (ret == -EAGAIN && force_nonblock) {
 			ret = io_setup_async_msg(req, kmsg, issue_flags);
-			if (ret == -EAGAIN && (req->flags & IO_APOLL_MULTI_POLLED) ==
-					       IO_APOLL_MULTI_POLLED) {
+			if (ret == -EAGAIN && (issue_flags & IO_URING_F_MULTISHOT)) {
 				io_kbuf_recycle(req, issue_flags);
 				return IOU_ISSUE_SKIP_COMPLETE;
 			}
@@ -803,7 +801,7 @@ int io_recvmsg(struct io_kiocb *req, unsigned int issue_flags)
 	if (kmsg->msg.msg_inq)
 		cflags |= IORING_CQE_F_SOCK_NONEMPTY;
 
-	if (!io_recv_finish(req, &ret, cflags, mshot_finished))
+	if (!io_recv_finish(req, &ret, cflags, mshot_finished, issue_flags))
 		goto retry_multishot;
 
 	if (mshot_finished) {
@@ -869,7 +867,7 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	ret = sock_recvmsg(sock, &msg, flags);
 	if (ret < min_ret) {
 		if (ret == -EAGAIN && force_nonblock) {
-			if ((req->flags & IO_APOLL_MULTI_POLLED) == IO_APOLL_MULTI_POLLED) {
+			if (issue_flags & IO_URING_F_MULTISHOT) {
 				io_kbuf_recycle(req, issue_flags);
 				return IOU_ISSUE_SKIP_COMPLETE;
 			}
@@ -902,7 +900,7 @@ int io_recv(struct io_kiocb *req, unsigned int issue_flags)
 	if (msg.msg_inq)
 		cflags |= IORING_CQE_F_SOCK_NONEMPTY;
 
-	if (!io_recv_finish(req, &ret, cflags, ret <= 0))
+	if (!io_recv_finish(req, &ret, cflags, ret <= 0, issue_flags))
 		goto retry_multishot;
 
 	return ret;
-- 
2.38.1

