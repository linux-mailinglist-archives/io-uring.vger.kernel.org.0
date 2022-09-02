Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28DFF5AA897
	for <lists+io-uring@lfdr.de>; Fri,  2 Sep 2022 09:15:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235034AbiIBHPz (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Sep 2022 03:15:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234970AbiIBHPy (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Sep 2022 03:15:54 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32743402DA
        for <io-uring@vger.kernel.org>; Fri,  2 Sep 2022 00:15:53 -0700 (PDT)
Received: from localhost.localdomain (unknown [182.2.70.226])
        by gnuweeb.org (Postfix) with ESMTPSA id 32CBD80C16;
        Fri,  2 Sep 2022 07:15:48 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1662102953;
        bh=R5rG7aU/B7wwAgf7ocUkSsJuoLBhyqFD2BPlWKzh60g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pMfMxVOQKhOrR+7aJ5U6mkxRyEbL5WKp42aj+D6mr7nXWm9aZozB7D2hWaFj/iQE0
         im0KWkIpQ0RZQLLMZ7/5FbXa6g9if0yZc7W0V7Y2//XTvYGordTvkj2niHzxro+zUH
         x7MV9+jaceVWO+lengrWakTQaNIbjauBYzlbtkZe5HkyXgouhQOtol2mb5NUjTHGwH
         69ItuPN5a42xaadsrkvDseIaAg4eeNQs4oJ/zSoK9lcQ0WSd1YStif0xGqV4d11+DZ
         DVeB3Y7EMVNzVmw0bW/x3nj+R84cXnR9H/2aiZSMCYvWFZ7jBX9udGQEubdTHh0scY
         W0vNLS7zNRcew==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Dylan Yudaken <dylany@fb.com>,
        Facebook Kernel Team <kernel-team@fb.com>,
        Pavel Begunkov <asml.silence@gmail.com>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        Kanna Scarlet <knscarlet@gnuweeb.org>,
        Muhammad Rizki <kiizuha@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Subject: [PATCH liburing v2 06/12] t/files-exit-hang-poll: Don't brute force the port number
Date:   Fri,  2 Sep 2022 14:14:59 +0700
Message-Id: <20220902071153.3168814-7-ammar.faizi@intel.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220902071153.3168814-1-ammar.faizi@intel.com>
References: <20220902071153.3168814-1-ammar.faizi@intel.com>
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

Don't brute force the port number, use `t_bind_ephemeral_port()`,
much simpler and reliable for choosing a port number that is not
in use.

Cc: Dylan Yudaken <dylany@fb.com>
Cc: Facebook Kernel Team <kernel-team@fb.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Reviewed-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Tested-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 test/files-exit-hang-poll.c | 23 +++--------------------
 1 file changed, 3 insertions(+), 20 deletions(-)

diff --git a/test/files-exit-hang-poll.c b/test/files-exit-hang-poll.c
index 0c609f1..04febc8 100644
--- a/test/files-exit-hang-poll.c
+++ b/test/files-exit-hang-poll.c
@@ -15,16 +15,14 @@
 #include <unistd.h>
 #include <poll.h>
 #include "liburing.h"
 #include "helpers.h"
 
 #define BACKLOG 512
 
-#define PORT 9100
-
 static struct io_uring ring;
 
 static void add_poll(struct io_uring *ring, int fd)
 {
 	struct io_uring_sqe *sqe;
 
 	sqe = io_uring_get_sqe(ring);
@@ -60,15 +58,14 @@ static void alarm_sig(int sig)
 
 int main(int argc, char *argv[])
 {
 	struct sockaddr_in serv_addr;
 	struct io_uring_cqe *cqe;
 	int ret, sock_listen_fd;
 	const int val = 1;
-	int i;
 
 	if (argc > 1)
 		return T_EXIT_SKIP;
 
 	sock_listen_fd = socket(AF_INET, SOCK_STREAM | SOCK_NONBLOCK, 0);
 	if (sock_listen_fd < 0) {
 		perror("socket");
@@ -77,28 +74,17 @@ int main(int argc, char *argv[])
 
 	setsockopt(sock_listen_fd, SOL_SOCKET, SO_REUSEADDR, &val, sizeof(val));
 
 	memset(&serv_addr, 0, sizeof(serv_addr));
 	serv_addr.sin_family = AF_INET;
 	serv_addr.sin_addr.s_addr = INADDR_ANY;
 
-	for (i = 0; i < 100; i++) {
-		serv_addr.sin_port = htons(PORT + i);
-
-		ret = bind(sock_listen_fd, (struct sockaddr *)&serv_addr, sizeof(serv_addr));
-		if (!ret)
-			break;
-		if (errno != EADDRINUSE) {
-			fprintf(stderr, "bind: %s\n", strerror(errno));
-			return T_EXIT_FAIL;
-		}
-		if (i == 99) {
-			printf("Gave up on finding a port, skipping\n");
-			goto skip;
-		}
+	if (t_bind_ephemeral_port(sock_listen_fd, &serv_addr)) {
+		perror("bind");
+		return T_EXIT_FAIL;
 	}
 
 	if (listen(sock_listen_fd, BACKLOG) < 0) {
 		perror("Error listening on socket\n");
 		return T_EXIT_FAIL;
 	}
 
@@ -121,11 +107,8 @@ int main(int argc, char *argv[])
 	if (ret) {
 		fprintf(stderr, "wait_cqe=%d\n", ret);
 		return T_EXIT_FAIL;
 	}
 
 	io_uring_queue_exit(&ring);
 	return T_EXIT_PASS;
-skip:
-	io_uring_queue_exit(&ring);
-	return T_EXIT_SKIP;
 }
-- 
Ammar Faizi

