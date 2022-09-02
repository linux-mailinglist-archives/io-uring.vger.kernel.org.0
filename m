Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48A0E5AA4F5
	for <lists+io-uring@lfdr.de>; Fri,  2 Sep 2022 03:19:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235151AbiIBBSP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Sep 2022 21:18:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235167AbiIBBSL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Sep 2022 21:18:11 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF2D1A3D5C
        for <io-uring@vger.kernel.org>; Thu,  1 Sep 2022 18:18:10 -0700 (PDT)
Received: from localhost.localdomain (unknown [182.2.38.99])
        by gnuweeb.org (Postfix) with ESMTPSA id 59E6E80C19;
        Fri,  2 Sep 2022 01:18:07 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1662081490;
        bh=KoJLZCOZpW4i2JyML4Rng3L4f+a0ef7DGJve5pJ48ik=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sV0Q/iPaUbqF85ibtGiT4jMfhAZaeBhSttSPCTuLM2oFjq2pO+nKDZanCh1l9Vetg
         AUNpwVgYIw9RNd1vmt9OPgeoMIPmTfcDyeWbfYhcSeKFrsAl7NCApnre50mVoijXEm
         pQzjdXIkizncM35xqzEIaOoPsOwdBBTBeoWFUzaGt+AqxINFYq6am0nIriy9OsySm2
         SjUx0aewOfqjQSHGY7PW15QSIH3UmrGCrSii+pnT7TOb5rsMMD5iSysjdaoHe+Maf3
         CywK91BsoSHfbTzWP2PQYPVV31f3QqT6/6Xok2JbfvYMPnJdUknhYUiB3SbVisgdgR
         sFgAQCVJ2etnQ==
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
Subject: [RESEND PATCH liburing v1 03/12] t/socket-rw: Don't brute force the port number
Date:   Fri,  2 Sep 2022 08:17:43 +0700
Message-Id: <20220902011548.2506938-4-ammar.faizi@intel.com>
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

Don't brute force the port number, use `t_bind_ephemeral_port()`,
much simpler and reliable for choosing a port number that is not
in use.

Cc: Dylan Yudaken <dylany@fb.com>
Cc: Facebook Kernel Team <kernel-team@fb.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 test/socket-rw.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/test/socket-rw.c b/test/socket-rw.c
index 4fbf032..6211b01 100644
--- a/test/socket-rw.c
+++ b/test/socket-rw.c
@@ -11,58 +11,49 @@
 #include <assert.h>
 
 #include <errno.h>
 #include <fcntl.h>
 #include <unistd.h>
 #include <sys/socket.h>
 #include <sys/un.h>
 #include <netinet/tcp.h>
 #include <netinet/in.h>
 #include <arpa/inet.h>
 
 #include "liburing.h"
+#include "helpers.h"
 
 int main(int argc, char *argv[])
 {
 	int p_fd[2], ret;
 	int32_t recv_s0;
 	int32_t val = 1;
 	struct sockaddr_in addr;
 	struct iovec iov_r[1], iov_w[1];
 
 	if (argc > 1)
 		return 0;
 
 	srand(getpid());
 
 	recv_s0 = socket(AF_INET, SOCK_STREAM | SOCK_CLOEXEC, IPPROTO_TCP);
 
 	ret = setsockopt(recv_s0, SOL_SOCKET, SO_REUSEPORT, &val, sizeof(val));
 	assert(ret != -1);
 	ret = setsockopt(recv_s0, SOL_SOCKET, SO_REUSEADDR, &val, sizeof(val));
 	assert(ret != -1);
 
 	addr.sin_family = AF_INET;
 	addr.sin_addr.s_addr = inet_addr("127.0.0.1");
-
-	do {
-		addr.sin_port = htons((rand() % 61440) + 4096);
-		ret = bind(recv_s0, (struct sockaddr*)&addr, sizeof(addr));
-		if (!ret)
-			break;
-		if (errno != EADDRINUSE) {
-			perror("bind");
-			exit(1);
-		}
-	} while (1);
+	assert(!t_bind_ephemeral_port(recv_s0, &addr));
 	ret = listen(recv_s0, 128);
 	assert(ret != -1);
 
 
 	p_fd[1] = socket(AF_INET, SOCK_STREAM | SOCK_CLOEXEC, IPPROTO_TCP);
 
 	val = 1;
 	ret = setsockopt(p_fd[1], IPPROTO_TCP, TCP_NODELAY, &val, sizeof(val));
 	assert(ret != -1);
 
 	int32_t flags = fcntl(p_fd[1], F_GETFL, 0);
 	assert(flags != -1);
-- 
Ammar Faizi

