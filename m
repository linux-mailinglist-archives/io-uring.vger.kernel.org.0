Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0A8F5AA4F4
	for <lists+io-uring@lfdr.de>; Fri,  2 Sep 2022 03:19:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235177AbiIBBSp (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Sep 2022 21:18:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235179AbiIBBS2 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Sep 2022 21:18:28 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87AE5A61C2
        for <io-uring@vger.kernel.org>; Thu,  1 Sep 2022 18:18:27 -0700 (PDT)
Received: from localhost.localdomain (unknown [182.2.38.99])
        by gnuweeb.org (Postfix) with ESMTPSA id 75AFC809E3;
        Fri,  2 Sep 2022 01:18:23 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1662081506;
        bh=Ii1/yIkdI8+/V8GiQ7qvrlnDqibwbsbmeRg5PHi8pwA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hKoFoRzkEgzDwkdQLFJrF96Oh4CJyeZ6gkThknDOzamUha9XeyejAac6+3+Rk+7dt
         iG+r/9PF55R8xFzmlhDsDnv/YIF73O97DibDE3uvhjpo3zex68DOqVjPyCgxd8DcIO
         kG2bTEx101p3OcllCYNIEMBs4V/Xsy5cqUvostIcrp38XJuaVqhDmpH8wO9v2bVLRR
         F5LU6Tj8lze0RQXnFEQCBbYPD9FvScS8isasVLD7XIilEzE58kK+5cE2NaWmC9lCUS
         00xcBjyzA6ALaVUlWKw2j09+PpQPuQSwp86widvVeVwRu2KWy+/jNK/XJI7FfQ8F1K
         hs+h3azFBlf9g==
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
Subject: [RESEND PATCH liburing v1 07/12] t/socket: Don't use a static port number
Date:   Fri,  2 Sep 2022 08:17:47 +0700
Message-Id: <20220902011548.2506938-8-ammar.faizi@intel.com>
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
 test/socket.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/test/socket.c b/test/socket.c
index 6a3ea09..94c8e9f 100644
--- a/test/socket.c
+++ b/test/socket.c
@@ -2,63 +2,63 @@
 /*
  * Simple test case using the socket op
  */
 #include <errno.h>
 #include <stdio.h>
 #include <stdlib.h>
 #include <string.h>
 #include <unistd.h>
 #include <arpa/inet.h>
 #include <sys/types.h>
 #include <sys/socket.h>
 #include <pthread.h>
+#include <assert.h>
 
 #include "liburing.h"
 #include "helpers.h"
 
 static char str[] = "This is a test of send and recv over io_uring!";
 
 #define MAX_MSG	128
 
-#define PORT	10202
 #define HOST	"127.0.0.1"
 
 static int no_socket;
+static __be32 g_port;
 
 static int recv_prep(struct io_uring *ring, struct iovec *iov, int *sock,
 		     int registerfiles)
 {
 	struct sockaddr_in saddr;
 	struct io_uring_sqe *sqe;
 	int sockfd, ret, val, use_fd;
 
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
+	g_port = saddr.sin_port;
 
 	if (registerfiles) {
 		ret = io_uring_register_files(ring, &sockfd, 1);
 		if (ret) {
 			fprintf(stderr, "file reg failed\n");
 			goto err;
 		}
 		use_fd = 0;
 	} else {
 		use_fd = sockfd;
 	}
 
@@ -235,27 +235,28 @@ static int do_send(int socket_direct, int alloc)
 		fprintf(stderr, "queue init failed: %d\n", ret);
 		return 1;
 	}
 
 	if (socket_direct) {
 		ret = io_uring_register_files(&ring, &fd, 1);
 		if (ret) {
 			fprintf(stderr, "file register %d\n", ret);
 			return 1;
 		}
 	}
 
+	assert(g_port != 0);
 	memset(&saddr, 0, sizeof(saddr));
 	saddr.sin_family = AF_INET;
-	saddr.sin_port = htons(PORT);
+	saddr.sin_port = g_port;
 	inet_pton(AF_INET, HOST, &saddr.sin_addr);
 
 	sqe = io_uring_get_sqe(&ring);
 	if (socket_direct) {
 		unsigned file_index = 0;
 		if (alloc)
 			file_index = IORING_FILE_INDEX_ALLOC - 1;
 		io_uring_prep_socket_direct(sqe, AF_INET, SOCK_DGRAM, 0,
 						file_index, 0);
 	} else {
 		io_uring_prep_socket(sqe, AF_INET, SOCK_DGRAM, 0, 0);
 	}
-- 
Ammar Faizi

