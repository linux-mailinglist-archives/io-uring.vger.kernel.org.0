Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76ABA5AA4EE
	for <lists+io-uring@lfdr.de>; Fri,  2 Sep 2022 03:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234698AbiIBBSw (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Sep 2022 21:18:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234653AbiIBBSr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Sep 2022 21:18:47 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BBE96A6C5A
        for <io-uring@vger.kernel.org>; Thu,  1 Sep 2022 18:18:38 -0700 (PDT)
Received: from localhost.localdomain (unknown [182.2.38.99])
        by gnuweeb.org (Postfix) with ESMTPSA id CE87680927;
        Fri,  2 Sep 2022 01:18:34 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1662081518;
        bh=FTZsJHRV3bTx9ZGHHl2FYEIQgbCBQNbCFEtUUQKrhR8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ur0co2WK9mJVuS9XAlmsxn9khpvt9Z6W2OYpyUXIviWiHh12D3HjHWPyS999pL3sG
         e0vvFWQV9yXUqdZaxDMIOKcqEvfkAzt98G7aU8nkk9SRIWPG79JQyD4eyOh5Cey5WP
         pH8A2EtkNkcAtm8lPGvd0QNwu8pGLx13kI7cSoICKL5VHqyd98iK8b82xg6iOhPcI8
         /qOCY61LNfNmZgsuL0Y9Ppy8U26B3hsYrvi6ujYcLGoGPqS3ao0lx9+6ctWyVElBbI
         MrzcaG19Pe1z7X3jH8cqXUMyX7Y5QsO4HAo3HwskpDRpm/QH4GVNNA19S4NtOovLbE
         8XOyVQFxa8O4Q==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Dylan Yudaken <dylany@fb.com>,
        Facebook Kernel Team <kernel-team@fb.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Kanna Scarlet <knscarlet@gnuweeb.org>,
        Muhammad Rizki <kiizuha@gnuweeb.org>
Subject: [RESEND PATCH liburing v1 10/12] t/recv-msgall: Don't use a static port number
Date:   Fri,  2 Sep 2022 08:17:50 +0700
Message-Id: <20220902011548.2506938-11-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220902011548.2506938-1-ammar.faizi@intel.com>
References: <20220902011548.2506938-1-ammar.faizi@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

Don't use a static port number. It might already be in use, resulting
in a test failure. Use an ephemeral port to make this test reliable.

Cc: Dylan Yudaken <dylany@fb.com>
Cc: Facebook Kernel Team <kernel-team@fb.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 test/recv-msgall.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/test/recv-msgall.c b/test/recv-msgall.c
index a6f7cfc..ae123e4 100644
--- a/test/recv-msgall.c
+++ b/test/recv-msgall.c
@@ -7,55 +7,53 @@
 #include <stdlib.h>
 #include <string.h>
 #include <unistd.h>
 #include <arpa/inet.h>
 #include <sys/types.h>
 #include <sys/socket.h>
 #include <pthread.h>
 
 #include "liburing.h"
 #include "helpers.h"
 
 #define MAX_MSG	128
-
-#define PORT	10201
 #define HOST	"127.0.0.1"
+static __be16 bind_port;
 
 static int recv_prep(struct io_uring *ring, struct iovec *iov, int *sock,
 		     int use_recvmsg)
 {
 	struct sockaddr_in saddr;
 	struct io_uring_sqe *sqe;
 	int sockfd, ret, val;
 	struct msghdr msg = { };
 
 	memset(&saddr, 0, sizeof(saddr));
 	saddr.sin_family = AF_INET;
 	saddr.sin_addr.s_addr = htonl(INADDR_ANY);
-	saddr.sin_port = htons(PORT);
 
 	sockfd = socket(AF_INET, SOCK_DGRAM, 0);
 	if (sockfd < 0) {
 		perror("socket");
 		return 1;
 	}
 
 	val = 1;
 	setsockopt(sockfd, SOL_SOCKET, SO_REUSEADDR, &val, sizeof(val));
 
-	ret = bind(sockfd, (struct sockaddr *)&saddr, sizeof(saddr));
-	if (ret < 0) {
+	if (t_bind_ephemeral_port(sockfd, &saddr)) {
 		perror("bind");
 		goto err;
 	}
+	bind_port = saddr.sin_port;
 
 	sqe = io_uring_get_sqe(ring);
 	if (!use_recvmsg) {
 		io_uring_prep_recv(sqe, sockfd, iov->iov_base, iov->iov_len,
 					MSG_WAITALL);
 	} else {
 		msg.msg_namelen = sizeof(struct sockaddr_in);
 		msg.msg_iov = iov;
 		msg.msg_iovlen = 1;
 		io_uring_prep_recvmsg(sqe, sockfd, &msg, MSG_WAITALL);
 	}
 
@@ -156,25 +154,25 @@ static int do_send(void)
 	ret = io_uring_queue_init(2, &ring, 0);
 	if (ret) {
 		fprintf(stderr, "queue init failed: %d\n", ret);
 		return 1;
 	}
 
 	buf = malloc(MAX_MSG * sizeof(int));
 	for (i = 0; i < MAX_MSG; i++)
 		buf[i] = i;
 
 	memset(&saddr, 0, sizeof(saddr));
 	saddr.sin_family = AF_INET;
-	saddr.sin_port = htons(PORT);
+	saddr.sin_port = bind_port;
 	inet_pton(AF_INET, HOST, &saddr.sin_addr);
 
 	sockfd = socket(AF_INET, SOCK_DGRAM, 0);
 	if (sockfd < 0) {
 		perror("socket");
 		return 1;
 	}
 
 	ret = connect(sockfd, (struct sockaddr *)&saddr, sizeof(saddr));
 	if (ret < 0) {
 		perror("connect");
 		return 1;
-- 
Ammar Faizi

