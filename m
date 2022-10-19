Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A114160512E
	for <lists+io-uring@lfdr.de>; Wed, 19 Oct 2022 22:19:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231143AbiJSUTT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 19 Oct 2022 16:19:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231209AbiJSUTR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 19 Oct 2022 16:19:17 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60A3A1A0C2F
        for <io-uring@vger.kernel.org>; Wed, 19 Oct 2022 13:19:14 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id ot12so42721462ejb.1
        for <io-uring@vger.kernel.org>; Wed, 19 Oct 2022 13:19:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RAbYkarBWW7YkEYSEEZmQe6eTUSuu/sD/n6pilJy0HU=;
        b=KgiBCHFplH+FRvgVsAxZc4lVCcZu/LloqXpiEgmbC8P+rUw/SIxDx70aj0R/87hUUk
         sgcSuyGiy4X2NA7hbHK5jyzNjQzH9CEtCvZhPb30PGDLxj5W9FVQbdYr4GojFwnJrLM0
         yFJ2uA72mG6/UdOR+28kQTzTKd4KATlqHpuyGUW6dZGPw5CvJGPYegxadY1f6YeKYgRJ
         Of00prWzI3JafBwTogM9ceE5gpwBYEK50B6hKVjpJX8YQp9oUBGwRpBxL67/UUkHgaj6
         CZFT8M8oAqgmAOcp2utP4bSlFcRIrYjTpyD21V651H+eXQvwmx6VlFxLe262zyUj0V3S
         yZug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RAbYkarBWW7YkEYSEEZmQe6eTUSuu/sD/n6pilJy0HU=;
        b=xxcvUU52pNtLCRXevi8dvYSSgj3xWTylZEaMD0whBqDnapdj9DtQde01bNdm4o0op9
         6zFrojUiE7GMBJtNR3xm1rDcDHyTtvih0hBlObBcR2RG4p9u2oqxLdAi2+stFactUUDv
         75EERrY0l3o5aLcWE3wN5EUQh1mU8Kd8oQylOq7YHI/rssMOPFN4PDKI8UQJOXjWWiE8
         21h6YLaKeWrHTNhOvZKVMoqOzaYjdNY7n8yXoY6Kc8m11OOjEYVFUEBiJzJR0jx7Xb12
         5STJjhvLpnlc3wFtGr4fNX0YaHEMw0ehm01TO7mvMJJIcyFwSpaXmit3AFsU3XXLvkI3
         ZziQ==
X-Gm-Message-State: ACrzQf05gycijWRg/GqzwmfMLOfzY3QdQF94XBDWkAl9dp3OEQCXggJK
        snLJFujQkGevZIn9kNuvwOx2Y7q1ovw=
X-Google-Smtp-Source: AMsMyM68pFXF9+5wd75CpCn+ZfdexhFZAf2l9hOav37dNnj0wWSQJaLuRHYgTWyWmsAJ2TGYszFN0w==
X-Received: by 2002:a17:906:30c8:b0:73c:81a9:f8e1 with SMTP id b8-20020a17090630c800b0073c81a9f8e1mr8198912ejb.649.1666210752291;
        Wed, 19 Oct 2022 13:19:12 -0700 (PDT)
Received: from 127.0.0.1localhost (94.197.72.2.threembb.co.uk. [94.197.72.2])
        by smtp.gmail.com with ESMTPSA id c1-20020a17090618a100b007877ad05b32sm9197557ejf.208.2022.10.19.13.19.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 13:19:11 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 1/1] tests: use only UDP/TCP for zc testing
Date:   Wed, 19 Oct 2022 21:17:51 +0100
Message-Id: <41f1cf670c1ac33adf263942b8ebc68f3b32001b.1666210567.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.0
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

The initial implementation only supports TCP and UDP, so use them for
testing.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/send-zerocopy.c | 57 ++++++++++++++++++++++++--------------------
 1 file changed, 31 insertions(+), 26 deletions(-)

diff --git a/test/send-zerocopy.c b/test/send-zerocopy.c
index c6279bc..4db102b 100644
--- a/test/send-zerocopy.c
+++ b/test/send-zerocopy.c
@@ -88,14 +88,17 @@ static int test_basic_send(struct io_uring *ring, int sock_tx, int sock_rx)
 
 	ret = io_uring_submit(ring);
 	assert(ret == 1);
+
 	ret = io_uring_wait_cqe(ring, &cqe);
-	assert(!ret);
-	assert(cqe->user_data == 1);
+	assert(!ret && cqe->user_data == 1);
 	if (cqe->res == -EINVAL) {
 		assert(!(cqe->flags & IORING_CQE_F_MORE));
 		return T_EXIT_SKIP;
+	} else if (cqe->res != payload_size) {
+		fprintf(stderr, "send failed %i\n", cqe->res);
+		return T_EXIT_FAIL;
 	}
-	assert(cqe->res == payload_size);
+
 	assert(cqe->flags & IORING_CQE_F_MORE);
 	io_uring_cqe_seen(ring, cqe);
 
@@ -152,8 +155,10 @@ static int test_send_faults(struct io_uring *ring, int sock_tx, int sock_rx)
 	return T_EXIT_PASS;
 }
 
-static int prepare_ip(struct sockaddr_storage *addr, int *sock_client, int *sock_server,
-		      bool ipv6, bool client_connect, bool msg_zc, bool tcp)
+static int create_socketpair_ip(struct sockaddr_storage *addr,
+				int *sock_client, int *sock_server,
+				bool ipv6, bool client_connect,
+				bool msg_zc, bool tcp)
 {
 	int family, addr_size;
 	int ret, val;
@@ -396,7 +401,7 @@ static int test_inet_send(struct io_uring *ring)
 		if (tcp && !client_connect)
 			continue;
 
-		ret = prepare_ip(&addr, &sock_client, &sock_server, ipv6,
+		ret = create_socketpair_ip(&addr, &sock_client, &sock_server, ipv6,
 				 client_connect, msg_zc_set, tcp);
 		if (ret) {
 			fprintf(stderr, "sock prep failed %d\n", ret);
@@ -454,7 +459,7 @@ static int test_async_addr(struct io_uring *ring)
 
 	ts.tv_sec = 1;
 	ts.tv_nsec = 0;
-	ret = prepare_ip(&addr, &sock_tx, &sock_rx, true, false, false, false);
+	ret = create_socketpair_ip(&addr, &sock_tx, &sock_rx, true, false, false, false);
 	if (ret) {
 		fprintf(stderr, "sock prep failed %d\n", ret);
 		return 1;
@@ -531,10 +536,10 @@ static bool io_check_zc_sendmsg(struct io_uring *ring)
 }
 
 /* see also send_recv.c:test_invalid */
-static int test_invalid_zc(void)
+static int test_invalid_zc(int fds[2])
 {
 	struct io_uring ring;
-	int ret, fds[2];
+	int ret;
 	struct io_uring_cqe *cqe;
 	struct io_uring_sqe *sqe;
 	bool notif = false;
@@ -543,9 +548,6 @@ static int test_invalid_zc(void)
 		return 0;
 
 	ret = t_create_ring(8, &ring, 0);
-	if (ret)
-		return ret;
-	ret = t_create_socket_pair(fds, true);
 	if (ret)
 		return ret;
 
@@ -572,15 +574,13 @@ static int test_invalid_zc(void)
 			return 1;
 		io_uring_cqe_seen(&ring, cqe);
 	}
-
 	io_uring_queue_exit(&ring);
-	close(fds[0]);
-	close(fds[1]);
 	return 0;
 }
 
 int main(int argc, char *argv[])
 {
+	struct sockaddr_storage addr;
 	struct io_uring ring;
 	int i, ret, sp[2];
 	size_t len;
@@ -588,6 +588,13 @@ int main(int argc, char *argv[])
 	if (argc > 1)
 		return T_EXIT_SKIP;
 
+	/* create TCP IPv6 pair */
+	ret = create_socketpair_ip(&addr, &sp[0], &sp[1], true, true, false, true);
+	if (ret) {
+		fprintf(stderr, "sock prep failed %d\n", ret);
+		return T_EXIT_FAIL;
+	}
+
 	len = 1U << 25; /* 32MB, should be enough to trigger a short send */
 	tx_buffer = aligned_alloc(4096, len);
 	rx_buffer = aligned_alloc(4096, len);
@@ -624,11 +631,6 @@ int main(int argc, char *argv[])
 		tx_buffer[i] = i;
 	memset(rx_buffer, 0, len);
 
-	if (socketpair(AF_UNIX, SOCK_DGRAM, 0, sp) != 0) {
-		perror("Failed to create Unix-domain socket pair\n");
-		return T_EXIT_FAIL;
-	}
-
 	ret = test_basic_send(&ring, sp[0], sp[1]);
 	if (ret == T_EXIT_SKIP)
 		return ret;
@@ -645,6 +647,15 @@ int main(int argc, char *argv[])
 		return T_EXIT_FAIL;
 	}
 
+	ret = test_invalid_zc(sp);
+	if (ret) {
+		fprintf(stderr, "test_invalid_zc() failed\n");
+		return T_EXIT_FAIL;
+	}
+
+	close(sp[0]);
+	close(sp[1]);
+
 	ret = test_async_addr(&ring);
 	if (ret) {
 		fprintf(stderr, "test_async_addr() failed\n");
@@ -665,12 +676,6 @@ int main(int argc, char *argv[])
 		fprintf(stderr, "test_inet_send() failed\n");
 		return T_EXIT_FAIL;
 	}
-
-	ret = test_invalid_zc();
-	if (ret) {
-		fprintf(stderr, "test_invalid_zc() failed\n");
-		return T_EXIT_FAIL;
-	}
 out:
 	io_uring_queue_exit(&ring);
 	close(sp[0]);
-- 
2.38.0

