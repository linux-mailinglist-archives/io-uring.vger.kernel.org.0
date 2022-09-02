Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D53C5AA896
	for <lists+io-uring@lfdr.de>; Fri,  2 Sep 2022 09:15:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231544AbiIBHPv (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Sep 2022 03:15:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234970AbiIBHPt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Sep 2022 03:15:49 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB67B3DF0D
        for <io-uring@vger.kernel.org>; Fri,  2 Sep 2022 00:15:48 -0700 (PDT)
Received: from localhost.localdomain (unknown [182.2.70.226])
        by gnuweeb.org (Postfix) with ESMTPSA id CE85C80C32;
        Fri,  2 Sep 2022 07:15:44 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1662102948;
        bh=XsgUeSNS8UzObKxwEKptqRvJ/bYG5SFx4pbeZrm0SsA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sdJtlp1AajNlP7uNPhM2v5tUVIQ8RxmjYfxoujfKTS3pEa8PudlyLr0z3FOGmypyM
         kjZKNikEyk2TTDEe+nvun5jKqShAyRGQdWL1p63JVx6dnIYVna163O8ztogpMeGkoe
         FR9ioxNmdpMvcLub7vK+LZOH91Tjm9DufEBpMjWUfp4b7SONkzp7d6oY+tmZfUdqh3
         phd0Zp4wUSy1T+CD2HOL6vCHGbsC6b50Z1iZuhtLRPxTBeq7aoZcZQvIareuZyTF4Z
         aZxz5Uehns2ikG3R8cOj/MCFgWeQ1rje1wxRm5bMJPGr3S2cI3b2imw1IIVG6BPISy
         toGSplNzcaLTw==
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
Subject: [PATCH liburing v2 05/12] t/socket-rw-offset: Don't brute force the port number
Date:   Fri,  2 Sep 2022 14:14:58 +0700
Message-Id: <20220902071153.3168814-6-ammar.faizi@intel.com>
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
 test/socket-rw-offset.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/test/socket-rw-offset.c b/test/socket-rw-offset.c
index 987b6c9..c422442 100644
--- a/test/socket-rw-offset.c
+++ b/test/socket-rw-offset.c
@@ -16,14 +16,15 @@
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
@@ -39,25 +40,15 @@ int main(int argc, char *argv[])
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
-- 
Ammar Faizi

