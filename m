Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 395C1589D64
	for <lists+io-uring@lfdr.de>; Thu,  4 Aug 2022 16:21:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239162AbiHDOVd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 Aug 2022 10:21:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39550 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232047AbiHDOVc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 Aug 2022 10:21:32 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7480733E27
        for <io-uring@vger.kernel.org>; Thu,  4 Aug 2022 07:21:31 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id a89so25561534edf.5
        for <io-uring@vger.kernel.org>; Thu, 04 Aug 2022 07:21:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=4fptWbivLL1R+OXMw15N9MuMx5z4TS9dJyEvA2bJdhU=;
        b=ZdZaFYHjisbQdTkDWSnAw4OcmUDBoO6M9V3wSeZMiMdIrpNsKPKv64oku6pHUyJu6t
         L5od8tdOkjtzartgGs8w9D04PwrFHYlY2JtX2idIB+Z/fVd73ONfQuJd60/EuVvB2nW8
         2BpAGL7np/nYTinczjM6QtvSeZ1GUwxcyJGYIcTlmeploFBzokvXpgo/Q1vtlvu7ZA+s
         GIrnElKZC2pIYFuX/R5LUONjlci81JCUl+w+iYT4ZDIMUTvJ3TYjjWS45tpz+WQipKFo
         LPYmzr9qcmfm0yT47B8E9JK7eS05j2Tboz+ONSesgdAvYBVNtTOTL6P84zVOYTWfsrP/
         HObg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=4fptWbivLL1R+OXMw15N9MuMx5z4TS9dJyEvA2bJdhU=;
        b=fmGOswfYKHNH3oWEH7h8iZ+nGInt2XFNItZPcMGiJKqFZ1CBTe46voPFhSvt58NsOW
         /paX5htR65QcbZZp2Bfq1Y551320zZFf3o0clEDP5xCq+E9Vv4Nb6OgVbrZfEF+PAi4I
         QLUJlussDjEAGlbd10yzBGF7LIP5aGYiddtyRAEv7YNU66MjpB9g5RgG5mT8h/oswkz9
         wY/apsSy0BPhz+84m5Z8dW5nR7k9WfwrwO4Ek+2LUaKVUGuApkQ8Qsg94WqzX9LWNrGc
         1oZR3RzraEB5QGKhF+wtnRvIJnW6cKj1dikljrFgg6YK738VsqLXKOuIBjkMFcaF8NnB
         OQtQ==
X-Gm-Message-State: ACgBeo0ttJEBI/ebhDecCYNWEry3aBnJJBt2l1ngi6EsPYCcoLlCmkt3
        TU2bG/msnVgU+SBrvx8XDlf9q3tv4E8=
X-Google-Smtp-Source: AA6agR7PEHng5IxxVd2HvqTdPhpw3zSANP2MZRuw+/HK0A2UUo5Nb7KhJ4evGDnG1bDs4nrEoSrlqQ==
X-Received: by 2002:a05:6402:5cb:b0:434:eb48:754f with SMTP id n11-20020a05640205cb00b00434eb48754fmr2324125edx.421.1659622889751;
        Thu, 04 Aug 2022 07:21:29 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.126.24.threembb.co.uk. [188.28.126.24])
        by smtp.gmail.com with ESMTPSA id r10-20020aa7c14a000000b0043bc33530ddsm727945edp.32.2022.08.04.07.21.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Aug 2022 07:21:29 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 2/6] tests/zc: test tcp
Date:   Thu,  4 Aug 2022 15:20:21 +0100
Message-Id: <29a52de00c6cc1bebc9d8fd70afd698746cc91c1.1659622771.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <cover.1659622771.git.asml.silence@gmail.com>
References: <cover.1659622771.git.asml.silence@gmail.com>
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

Add tests for TCP zerocopy send

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/send-zerocopy.c | 53 +++++++++++++++++++++++++++++++++++---------
 1 file changed, 42 insertions(+), 11 deletions(-)

diff --git a/test/send-zerocopy.c b/test/send-zerocopy.c
index c04e905..7999f46 100644
--- a/test/send-zerocopy.c
+++ b/test/send-zerocopy.c
@@ -550,10 +550,12 @@ static int test_registration(int sock_tx, int sock_rx)
 }
 
 static int prepare_ip(struct sockaddr_storage *addr, int *sock_client, int *sock_server,
-		      bool ipv6, bool client_connect, bool msg_zc)
+		      bool ipv6, bool client_connect, bool msg_zc, bool tcp)
 {
 	int family, addr_size;
 	int ret, val;
+	int listen_sock = -1;
+	int sock;
 
 	memset(addr, 0, sizeof(*addr));
 	if (ipv6) {
@@ -574,18 +576,29 @@ static int prepare_ip(struct sockaddr_storage *addr, int *sock_client, int *sock
 	}
 
 	/* server sock setup */
-	*sock_server = socket(family, SOCK_DGRAM, 0);
-	if (*sock_server < 0) {
+	if (tcp) {
+		sock = listen_sock = socket(family, SOCK_STREAM, IPPROTO_TCP);
+	} else {
+		sock = *sock_server = socket(family, SOCK_DGRAM, 0);
+	}
+	if (sock < 0) {
 		perror("socket");
 		return 1;
 	}
 	val = 1;
-	setsockopt(*sock_server, SOL_SOCKET, SO_REUSEADDR, &val, sizeof(val));
-	ret = bind(*sock_server, (struct sockaddr *)addr, addr_size);
+	setsockopt(sock, SOL_SOCKET, SO_REUSEADDR, &val, sizeof(val));
+	val = 1;
+	setsockopt(sock, SOL_SOCKET, SO_REUSEPORT, &val, sizeof(val));
+
+	ret = bind(sock, (struct sockaddr *)addr, addr_size);
 	if (ret < 0) {
 		perror("bind");
 		return 1;
 	}
+	if (tcp) {
+		ret = listen(sock, 128);
+		assert(ret != -1);
+	}
 
 	if (ipv6) {
 		struct sockaddr_in6 *saddr = (struct sockaddr_in6 *)addr;
@@ -598,7 +611,12 @@ static int prepare_ip(struct sockaddr_storage *addr, int *sock_client, int *sock
 	}
 
 	/* client sock setup */
-	*sock_client = socket(family, SOCK_DGRAM, 0);
+	if (tcp) {
+		*sock_client = socket(family, SOCK_STREAM, IPPROTO_TCP);
+		assert(client_connect);
+	} else {
+		*sock_client = socket(family, SOCK_DGRAM, 0);
+	}
 	if (*sock_client < 0) {
 		perror("socket");
 		return 1;
@@ -617,6 +635,14 @@ static int prepare_ip(struct sockaddr_storage *addr, int *sock_client, int *sock
 			return 1;
 		}
 	}
+	if (tcp) {
+		*sock_server = accept(listen_sock, NULL, NULL);
+		if (!*sock_server) {
+			fprintf(stderr, "can't accept\n");
+			return 1;
+		}
+		close(listen_sock);
+	}
 	return 0;
 }
 
@@ -721,17 +747,20 @@ static int do_test_inet_send(struct io_uring *ring, int sock_client, int sock_se
 static int test_inet_send(struct io_uring *ring)
 {
 	struct sockaddr_storage addr;
-	int sock_client, sock_server;
-	int ret, j;
-	__u64 i;
+	int sock_client = -1, sock_server = -1;
+	int ret, j, i;
 
-	for (j = 0; j < 8; j++) {
+	for (j = 0; j < 16; j++) {
 		bool ipv6 = j & 1;
 		bool client_connect = j & 2;
 		bool msg_zc_set = j & 4;
+		bool tcp = j & 8;
+
+		if (tcp && !client_connect)
+			continue;
 
 		ret = prepare_ip(&addr, &sock_client, &sock_server, ipv6,
-				 client_connect, msg_zc_set);
+				 client_connect, msg_zc_set, tcp);
 		if (ret) {
 			fprintf(stderr, "sock prep failed %d\n", ret);
 			return 1;
@@ -746,6 +775,8 @@ static int test_inet_send(struct io_uring *ring)
 			bool aligned = i & 32;
 			int buf_idx = aligned ? 0 : 1;
 
+			if (tcp && cork)
+				continue;
 			if (mix_register && (!cork || fixed_buf))
 				continue;
 			if (!client_connect && addr_arg == NULL)
-- 
2.37.0

