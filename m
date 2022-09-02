Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83D6B5AA4F9
	for <lists+io-uring@lfdr.de>; Fri,  2 Sep 2022 03:19:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235259AbiIBBSt (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Sep 2022 21:18:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235204AbiIBBSl (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Sep 2022 21:18:41 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEF62A6C21
        for <io-uring@vger.kernel.org>; Thu,  1 Sep 2022 18:18:31 -0700 (PDT)
Received: from localhost.localdomain (unknown [182.2.38.99])
        by gnuweeb.org (Postfix) with ESMTPSA id 4B70880927;
        Fri,  2 Sep 2022 01:18:27 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1662081510;
        bh=XQBr8PxJ0niB7G2n+280ojDnSSkFXiJIHzjXh7U4PII=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LQMUu2ERYSsCQLMdEFo042bGQMmxXYthZks/6UVw9Lc42VhcKrGiAMQ9fBdRjFEad
         choCBzLZWR7ZqBhMxqKxj0+M1yj9ZWNznKqzbYhKhi4rHEaNbygAa497iLjZJSUFdA
         s1jbyIudrOZgFcysJ8umUyfiybVrLud0UkxDwDxjrZEa6NTLLUpdKdtkLYms43AFIv
         ntMO7dLKzD8lboaaweixhDD5mpc95csF3/p6FfexR/1Bb7mSi43mMz9yfWsfBqAK/K
         tBlQdr23V/twhrS2xkcpxD0K5Bm0HAYTp0DzCyA87EVJmHV5rZ4dvC0SG4sdsZj6aH
         N0H53AZf1n+OQ==
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
Subject: [RESEND PATCH liburing v1 08/12] t/connect: Don't use a static port number
Date:   Fri,  2 Sep 2022 08:17:48 +0700
Message-Id: <20220902011548.2506938-9-ammar.faizi@intel.com>
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
 test/accept.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/test/accept.c b/test/accept.c
index b35ded4..1821faa 100644
--- a/test/accept.c
+++ b/test/accept.c
@@ -185,29 +185,26 @@ static int start_accept_listen(struct sockaddr_in *addr, int port_off,
 	int32_t val = 1;
 	ret = setsockopt(fd, SOL_SOCKET, SO_REUSEPORT, &val, sizeof(val));
 	assert(ret != -1);
 	ret = setsockopt(fd, SOL_SOCKET, SO_REUSEADDR, &val, sizeof(val));
 	assert(ret != -1);
 
 	struct sockaddr_in laddr;
 
 	if (!addr)
 		addr = &laddr;
 
 	addr->sin_family = AF_INET;
-	addr->sin_port = htons(0x1235 + port_off);
 	addr->sin_addr.s_addr = inet_addr("127.0.0.1");
-
-	ret = bind(fd, (struct sockaddr*)addr, sizeof(*addr));
-	assert(ret != -1);
+	assert(!t_bind_ephemeral_port(fd, addr));
 	ret = listen(fd, 128);
 	assert(ret != -1);
 
 	return fd;
 }
 
 static int set_client_fd(struct sockaddr_in *addr)
 {
 	int32_t val;
 	int fd, ret;
 
 	fd = socket(AF_INET, SOCK_STREAM | SOCK_CLOEXEC, IPPROTO_TCP);
-- 
Ammar Faizi

