Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 302C25AA4F8
	for <lists+io-uring@lfdr.de>; Fri,  2 Sep 2022 03:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235293AbiIBBSv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Sep 2022 21:18:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235236AbiIBBSq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Sep 2022 21:18:46 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AB39A6AE9
        for <io-uring@vger.kernel.org>; Thu,  1 Sep 2022 18:18:35 -0700 (PDT)
Received: from localhost.localdomain (unknown [182.2.38.99])
        by gnuweeb.org (Postfix) with ESMTPSA id 1F5AC809E3;
        Fri,  2 Sep 2022 01:18:30 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1662081514;
        bh=t0FJhdPMM/bVFC7013MaDlZq+jm7QOzj7pap9eVHnmg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eVfJeYfRa0IV1879vF3OfxecAAwEyh+oJv5TZ1zKq54zkAHcIeTTNumTWRyhu+eGE
         PgmaWb43FWndGBny7R0pb128+ELk1RHaJxF7RS/GUf13yyK5lHTmB287nYoaEtdACs
         mp7SuCPU8P3AQfdnJs38NhzbEzaT0dKA5W36E+UyyJ7o+J+G/WuA3MumhdHyLM4bDR
         9IefAcutJ9m5jcPHO9Jc9pA9eCQqtgQgsM9nUhppt3lVv20RaeWzDTeUEWQKGYG+n5
         8wn0JE0awRtRti1W5HIo08VmIFIwt2mkmZwf/MHm4k3CZljcGlemSvHzybfQ9DSiOU
         kxhc45hGvDMww==
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
Subject: [RESEND PATCH liburing v1 09/12] t/shutdown: Don't use a static port number
Date:   Fri,  2 Sep 2022 08:17:49 +0700
Message-Id: <20220902011548.2506938-10-ammar.faizi@intel.com>
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
 test/shutdown.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/test/shutdown.c b/test/shutdown.c
index 14c7407..064ee36 100644
--- a/test/shutdown.c
+++ b/test/shutdown.c
@@ -10,54 +10,53 @@
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
 
 static void sig_pipe(int sig)
 {
 }
 
 int main(int argc, char *argv[])
 {
 	int p_fd[2], ret;
 	int32_t recv_s0;
 	int32_t val = 1;
-	struct sockaddr_in addr;
+	struct sockaddr_in addr = { };
 
 	if (argc > 1)
 		return 0;
 
 	srand(getpid());
 
 	recv_s0 = socket(AF_INET, SOCK_STREAM | SOCK_CLOEXEC, IPPROTO_TCP);
 
 	ret = setsockopt(recv_s0, SOL_SOCKET, SO_REUSEPORT, &val, sizeof(val));
 	assert(ret != -1);
 	ret = setsockopt(recv_s0, SOL_SOCKET, SO_REUSEADDR, &val, sizeof(val));
 	assert(ret != -1);
 
 	addr.sin_family = AF_INET;
-	addr.sin_port = htons((rand() % 61440) + 4096);
 	addr.sin_addr.s_addr = inet_addr("127.0.0.1");
 
-	ret = bind(recv_s0, (struct sockaddr*)&addr, sizeof(addr));
-	assert(ret != -1);
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

