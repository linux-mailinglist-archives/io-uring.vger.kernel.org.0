Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0CAC605530
	for <lists+io-uring@lfdr.de>; Thu, 20 Oct 2022 03:51:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbiJTBvH (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Oct 2022 21:51:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229774AbiJTBvH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Oct 2022 21:51:07 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F367515DB1B
        for <io-uring@vger.kernel.org>; Wed, 19 Oct 2022 18:51:03 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id b12so27810280edd.6
        for <io-uring@vger.kernel.org>; Wed, 19 Oct 2022 18:51:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sOADn8KXXdxqhykTm0vT0ios/ldhkL7Pihf8mO8xsCI=;
        b=efKBk04+su1JZVBDHTBFE5+l6EZleILrsZJyDMTXba0JPz5ocuXLKSOh654o8LszfS
         iLjDuBsS6VMqq4kIgLP8k6eH4uPNzKZgweS1mbcx1WtAXmQmp3+QGHOTqEkXoKaE80Ap
         +xQWrI3auLyQzr25uCgU7HABX7MirkjL13nb7vx6L0IkydMRTe8aL5c2i235YhW0sd8f
         m/bHhl8QB4koXfegAxlGJHuMyBH76MMTLCi5qOzHmYl44yrHzcgLdVWPeovwCBeO6dKV
         pYdJxB0LUY2s8BUneAOPUwJbVhlPrYQjxl3NA11IJwwIWZgSQYhOyhv12xhOz7H/zJku
         KV/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sOADn8KXXdxqhykTm0vT0ios/ldhkL7Pihf8mO8xsCI=;
        b=fJwzHlkmhANJFjoX8wxgJTXS1qJi2cOdSwvhopKP83ZJwLwfs4p5X4ZHhz2CYCYs8u
         6wo6VZ5Vxh4/brp/WJoGy3ImxcEM4G8u8uG7Wl79rbJXFEQlqRP9yyAZ1iIH/xhoWfUN
         LwuBwzcpb5GKsbIlSaaCXqHTa0F3AVzCsXLuwKJXKLUkskmBTeMgacTe6j/8r2lhj2iR
         zqJKGct5826H4virYzB8OQ5GyxEtPj0dDuy9Zxc37F89XaGt9dqIMYvwyOfLgdwGxxQj
         IzC6E9PltJz2kXAT0CcFFAz89ABzABD8u39dJve0tODxWB9lFUQ36XRagTAtQA0q5i+B
         eo1w==
X-Gm-Message-State: ACrzQf0WQsydftu88rITgAkizyxvRILOTsxl1ZbLjogk2/Zdf3F+FO3p
        bESK4NDozRGzerrGN67O1r+/BQeXBM0=
X-Google-Smtp-Source: AMsMyM5bSmY8Ne7XAnAj9o28qoumiM0EiIpev1RckaHt3EA0TImOnTxREU17c7XuUYcsTIoNVaeVuQ==
X-Received: by 2002:a05:6402:f96:b0:459:4180:6cf4 with SMTP id eh22-20020a0564020f9600b0045941806cf4mr10075822edb.64.1666230662190;
        Wed, 19 Oct 2022 18:51:02 -0700 (PDT)
Received: from 127.0.0.1localhost (94.197.72.2.threembb.co.uk. [94.197.72.2])
        by smtp.gmail.com with ESMTPSA id a13-20020a50ff0d000000b00451319a43dasm11318420edu.2.2022.10.19.18.51.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 18:51:01 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing for-next 2/5] tests: pass params in a struct
Date:   Thu, 20 Oct 2022 02:49:52 +0100
Message-Id: <3bf40c6b184b49a9f7a6fe569a25932c209446f6.1666230529.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <cover.1666230529.git.asml.silence@gmail.com>
References: <cover.1666230529.git.asml.silence@gmail.com>
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

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/send-zerocopy.c | 81 ++++++++++++++++++++++++--------------------
 1 file changed, 45 insertions(+), 36 deletions(-)

diff --git a/test/send-zerocopy.c b/test/send-zerocopy.c
index 005220d..a69279a 100644
--- a/test/send-zerocopy.c
+++ b/test/send-zerocopy.c
@@ -254,25 +254,34 @@ static int create_socketpair_ip(struct sockaddr_storage *addr,
 	return 0;
 }
 
+struct send_conf {
+	bool fixed_buf;
+	bool mix_register;
+	bool cork;
+	bool force_async;
+	bool use_sendmsg;
+	bool tcp;
+	int buf_index;
+	struct sockaddr_storage *addr;
+};
+
 static int do_test_inet_send(struct io_uring *ring, int sock_client, int sock_server,
-			     bool fixed_buf, struct sockaddr_storage *addr,
-			     bool cork, bool mix_register,
-			     int buf_idx, bool force_async, bool use_sendmsg)
+			     struct send_conf *conf)
 {
 	struct iovec iov[CORK_REQS];
 	struct msghdr msghdr[CORK_REQS];
 	const unsigned zc_flags = 0;
 	struct io_uring_sqe *sqe;
 	struct io_uring_cqe *cqe;
-	int nr_reqs = cork ? CORK_REQS : 1;
+	int nr_reqs = conf->cork ? CORK_REQS : 1;
 	int i, ret, nr_cqes, addr_len = 0;
-	size_t send_size = buffers_iov[buf_idx].iov_len;
+	size_t send_size = buffers_iov[conf->buf_index].iov_len;
 	size_t chunk_size = send_size / nr_reqs;
 	size_t chunk_size_last = send_size - chunk_size * (nr_reqs - 1);
-	char *buf = buffers_iov[buf_idx].iov_base;
+	char *buf = buffers_iov[conf->buf_index].iov_base;
 
-	if (addr) {
-		sa_family_t fam = ((struct sockaddr_in *)addr)->sin_family;
+	if (conf->addr) {
+		sa_family_t fam = ((struct sockaddr_in *)conf->addr)->sin_family;
 
 		addr_len = (fam == AF_INET) ? sizeof(struct sockaddr_in) :
 					      sizeof(struct sockaddr_in6);
@@ -281,11 +290,11 @@ static int do_test_inet_send(struct io_uring *ring, int sock_client, int sock_se
 	memset(rx_buffer, 0, send_size);
 
 	for (i = 0; i < nr_reqs; i++) {
-		bool real_fixed_buf = fixed_buf;
+		bool real_fixed_buf = conf->fixed_buf;
 		size_t cur_size = chunk_size;
 		int msg_flags = MSG_WAITALL;
 
-		if (mix_register)
+		if (conf->mix_register)
 			real_fixed_buf = rand() & 1;
 
 		if (i != nr_reqs - 1)
@@ -295,15 +304,15 @@ static int do_test_inet_send(struct io_uring *ring, int sock_client, int sock_se
 
 		sqe = io_uring_get_sqe(ring);
 
-		if (!use_sendmsg) {
+		if (!conf->use_sendmsg) {
 			io_uring_prep_send_zc(sqe, sock_client, buf + i * chunk_size,
 					      cur_size, msg_flags, zc_flags);
 			if (real_fixed_buf) {
 				sqe->ioprio |= IORING_RECVSEND_FIXED_BUF;
-				sqe->buf_index = buf_idx;
+				sqe->buf_index = conf->buf_index;
 			}
-			if (addr)
-				io_uring_prep_send_set_addr(sqe, (const struct sockaddr *)addr,
+			if (conf->addr)
+				io_uring_prep_send_set_addr(sqe, (const struct sockaddr *)conf->addr,
 							    addr_len);
 		} else {
 			io_uring_prep_sendmsg_zc(sqe, sock_client, &msghdr[i], msg_flags);
@@ -313,13 +322,13 @@ static int do_test_inet_send(struct io_uring *ring, int sock_client, int sock_se
 			iov[i].iov_base = buf + i * chunk_size;
 			msghdr[i].msg_iov = &iov[i];
 			msghdr[i].msg_iovlen = 1;
-			if (addr) {
-				msghdr[i].msg_name = addr;
+			if (conf->addr) {
+				msghdr[i].msg_name = conf->addr;
 				msghdr[i].msg_namelen = addr_len;
 			}
 		}
 		sqe->user_data = i;
-		if (force_async)
+		if (conf->force_async)
 			sqe->flags |= IOSQE_ASYNC;
 		if (i != nr_reqs - 1)
 			sqe->flags |= IOSQE_IO_LINK;
@@ -388,6 +397,7 @@ static int do_test_inet_send(struct io_uring *ring, int sock_client, int sock_se
 
 static int test_inet_send(struct io_uring *ring)
 {
+	struct send_conf conf;
 	struct sockaddr_storage addr;
 	int sock_client = -1, sock_server = -1;
 	int ret, j, i;
@@ -409,35 +419,34 @@ static int test_inet_send(struct io_uring *ring)
 		}
 
 		for (i = 0; i < 256; i++) {
-			int buf_flavour = i & 3;
-			bool fixed_buf = i & 4;
-			struct sockaddr_storage *addr_arg = (i & 8) ? &addr : NULL;
-			bool cork = i & 16;
-			bool mix_register = i & 32;
-			bool force_async = i & 64;
-			bool use_sendmsg = i & 128;
-
-			if (buf_flavour == BUF_T_LARGE && !tcp)
+			conf.buf_index = i & 3;
+			conf.fixed_buf = i & 4;
+			conf.addr = (i & 8) ? &addr : NULL;
+			conf.cork = i & 16;
+			conf.mix_register = i & 32;
+			conf.force_async = i & 64;
+			conf.use_sendmsg = i & 128;
+			conf.tcp = tcp;
+
+			if (conf.buf_index == BUF_T_LARGE && !tcp)
 				continue;
-			if (!buffers_iov[buf_flavour].iov_base)
+			if (!buffers_iov[conf.buf_index].iov_base)
 				continue;
-			if (tcp && (cork || addr_arg))
+			if (tcp && (conf.cork || conf.addr))
 				continue;
-			if (mix_register && (!cork || fixed_buf))
+			if (conf.mix_register && (!conf.cork || conf.fixed_buf))
 				continue;
-			if (!client_connect && addr_arg == NULL)
+			if (!client_connect && conf.addr == NULL)
 				continue;
-			if (use_sendmsg && (mix_register || fixed_buf || !has_sendmsg))
+			if (conf.use_sendmsg && (conf.mix_register || conf.fixed_buf || !has_sendmsg))
 				continue;
 
-			ret = do_test_inet_send(ring, sock_client, sock_server, fixed_buf,
-						addr_arg, cork, mix_register,
-						buf_flavour, force_async, use_sendmsg);
+			ret = do_test_inet_send(ring, sock_client, sock_server, &conf);
 			if (ret) {
 				fprintf(stderr, "send failed fixed buf %i, conn %i, addr %i, "
 					"cork %i\n",
-					fixed_buf, client_connect, !!addr_arg,
-					cork);
+					conf.fixed_buf, client_connect, !!conf.addr,
+					conf.cork);
 				return 1;
 			}
 		}
-- 
2.38.0

