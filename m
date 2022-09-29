Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22EF85EEA68
	for <lists+io-uring@lfdr.de>; Thu, 29 Sep 2022 02:05:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229508AbiI2AFB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 28 Sep 2022 20:05:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232298AbiI2AFA (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 28 Sep 2022 20:05:00 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34A755F20F
        for <io-uring@vger.kernel.org>; Wed, 28 Sep 2022 17:04:59 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id n10so22036462wrw.12
        for <io-uring@vger.kernel.org>; Wed, 28 Sep 2022 17:04:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=EAOWcQ+a3ESXBHnwbnSb5VdHpBVKg5utrvG78Chma6s=;
        b=Ui5/epuwy8P7nyhFlu6SUxVCfBkXy2+bL1n53bzETcq8I9ETvsNApM17fYFIQ0y8hc
         6HhgpTeLSdZp/xdybBmTl+iAscs8XjoOYEaoKBLQIw0GZtjHKi9YzZpMGMnIscqdyr4P
         fAFjGJz4+6joXGcdY+aQWTgD+P1LW4h06AWC3XCyU/GwyjW1oBU0NAgtIrE4vVGj5ZXj
         +uScFScwu3ROdZTS0FGyum2bUSdsO9iuz5LF7hhTs+84aQaukwCxkNKhpjv6rQnX1Z/B
         Dz0KqvZjUuYXAcJ/6QzH9RtxVSdB30dqt/xFjX//CDvSY7UAyBzIKKxfN2Cce7WDx6Fz
         t5Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=EAOWcQ+a3ESXBHnwbnSb5VdHpBVKg5utrvG78Chma6s=;
        b=Xxu9LLG9rJw46NyI5JMJ2OfetAREuXoab2ZtrflCAbyFZBQk2okY9Fv0Wf/xTmgGxk
         QXgY1ShzS92FiKbdVYqW9tTembvOyG83bGqfFeWa4JviHFRbqCwTZ6Ukb4UzUP9fm0Dw
         43XSSWJ/ab8+2TWR3zF1PuEnz1q7xPDOW3RfsNMneCsf37+TRPSVLAwOvPZiWkrHDZqX
         WbWzUIQfuyHp9wW6rVJDFFnrwPU8dU4MyHjBBXTQA15YAWKL+ZW7X9uUk4/tkDEAES0k
         ScEmREN7MB28YwGmEk2H2HQ2kCxyaEOD5BNLSaEbdXyqAoqvW98o4fCcK8aUWfuHW6n1
         Bq9Q==
X-Gm-Message-State: ACrzQf08oG0SZHjU+Yt6YBiuJyw/s/z+TFN4R4fVcFc34rw7Xy7LRQaE
        Ry/vKZoRIElmVsUJ5a8xWl6YBxZUifI=
X-Google-Smtp-Source: AMsMyM5PZLM316iZb15nALtj+9K6rvplcwfQ22NK60GeM23MmpUNWMydAAreR0xzPHU6t5srXJ+5qQ==
X-Received: by 2002:a05:6000:1085:b0:228:da84:5d31 with SMTP id y5-20020a056000108500b00228da845d31mr213700wrw.712.1664409897448;
        Wed, 28 Sep 2022 17:04:57 -0700 (PDT)
Received: from 127.0.0.1localhost (94.196.228.157.threembb.co.uk. [94.196.228.157])
        by smtp.gmail.com with ESMTPSA id f14-20020a05600c4e8e00b003b47e75b401sm3284705wmq.37.2022.09.28.17.04.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 28 Sep 2022 17:04:57 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 2/4] tests/zc: pass params in a struct
Date:   Thu, 29 Sep 2022 01:03:50 +0100
Message-Id: <169e6b83afa4e125fd85a84787fe59012a1b35ad.1664409593.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1664409593.git.asml.silence@gmail.com>
References: <cover.1664409593.git.asml.silence@gmail.com>
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
index e58b11c..cdf71ea 100644
--- a/test/send-zerocopy.c
+++ b/test/send-zerocopy.c
@@ -249,25 +249,34 @@ static int prepare_ip(struct sockaddr_storage *addr, int *sock_client, int *sock
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
@@ -276,11 +285,11 @@ static int do_test_inet_send(struct io_uring *ring, int sock_client, int sock_se
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
@@ -290,15 +299,15 @@ static int do_test_inet_send(struct io_uring *ring, int sock_client, int sock_se
 
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
@@ -308,13 +317,13 @@ static int do_test_inet_send(struct io_uring *ring, int sock_client, int sock_se
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
@@ -383,6 +392,7 @@ static int do_test_inet_send(struct io_uring *ring, int sock_client, int sock_se
 
 static int test_inet_send(struct io_uring *ring)
 {
+	struct send_conf conf;
 	struct sockaddr_storage addr;
 	int sock_client = -1, sock_server = -1;
 	int ret, j, i;
@@ -404,35 +414,34 @@ static int test_inet_send(struct io_uring *ring)
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
2.37.2

