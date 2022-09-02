Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AC96E5AA898
	for <lists+io-uring@lfdr.de>; Fri,  2 Sep 2022 09:16:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234723AbiIBHP7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Sep 2022 03:15:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235286AbiIBHP6 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Sep 2022 03:15:58 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 737DA4D83C
        for <io-uring@vger.kernel.org>; Fri,  2 Sep 2022 00:15:57 -0700 (PDT)
Received: from localhost.localdomain (unknown [182.2.70.226])
        by gnuweeb.org (Postfix) with ESMTPSA id 7F64980C52;
        Fri,  2 Sep 2022 07:15:53 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1662102957;
        bh=75xduiH5BRYatK1HW5Otf59KSLOr3on+y2lVgrCwD64=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T7goCI6SlBrm/d+n5cXS3khvSU/ClX9l8s8UvVrj49Yw1Y/bB9Sg1t7AUHfWeaVen
         JHhbEAZotzetmUTK0sBHBUZ/TIvoGcDMXi/AJGm1JppuxlgBUgwOhbRa1NxwZcsqQo
         6uQdL032ff0QyYBtGc1GGIetG8CQKtY4M9jg9JcegOCYz35KgqTbpJyEO25DkZS71b
         FnwD2fx7x/eaNXus2FRSR4PBcgqfmNQGHaHynoCPqfWX8L5R3qqxif0e5UmEp329ni
         5bgiYMMYWwa0xxECtYRE/3H2llHhfa43fCaNuu4hJPMIDM+KYsP5gz7quZKH3lCh0D
         fe8FFDIvQ351Q==
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
Subject: [PATCH liburing v2 07/12] t/socket: Don't use a static port number
Date:   Fri,  2 Sep 2022 14:15:00 +0700
Message-Id: <20220902071153.3168814-8-ammar.faizi@intel.com>
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

Don't use a static port number. It might already be in use, resulting
in a test failure. Use an ephemeral port to make this test reliable.

Cc: Dylan Yudaken <dylany@fb.com>
Cc: Facebook Kernel Team <kernel-team@fb.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Reviewed-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Tested-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 test/socket.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/test/socket.c b/test/socket.c
index 6a3ea09..94c8e9f 100644
--- a/test/socket.c
+++ b/test/socket.c
@@ -7,53 +7,53 @@
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
@@ -240,17 +240,18 @@ static int do_send(int socket_direct, int alloc)
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
-- 
Ammar Faizi

