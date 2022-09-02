Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05ABF5AA4FA
	for <lists+io-uring@lfdr.de>; Fri,  2 Sep 2022 03:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234571AbiIBBTF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Sep 2022 21:19:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235278AbiIBBSv (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Sep 2022 21:18:51 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEA4BA6ADE
        for <io-uring@vger.kernel.org>; Thu,  1 Sep 2022 18:18:42 -0700 (PDT)
Received: from localhost.localdomain (unknown [182.2.38.99])
        by gnuweeb.org (Postfix) with ESMTPSA id 9845180C38;
        Fri,  2 Sep 2022 01:18:38 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1662081521;
        bh=t/yUsttRItt9nJsTr0VDOU9oV2/pORcRDTd/UkdXK9A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kgdaJl8nJKsOHeAosLmWiJ0jW0j6Rp+rplNHPKonbTVmaIejhTVQzqlzlcYpnKWzq
         Azyx086+VxseuQx2gVQIyzZCt+ssc6TTQ57E1d5kQiG3/KTkRa9DN5mJ8fGYeKWujn
         KBbxTjIQpvVUjP6ApRN3hffmM5IStYNcRnnXjzAqhrK21Ne287LvyeVnmFo97QioBE
         +OhmYWG1iYYBryUFE0bxkgD1P3PCrubEFn/hjDz0Ay+H9Ep0ECFLB8fsPdabtowK41
         /saiYsxEa3N+KRqnZWNrPwQO5LjZpG+UVujaJQNBYYiaacNaX69acILu+PSbjKgGpn
         +TxWg++PCTMNA==
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
Subject: [RESEND PATCH liburing v1 11/12] t/232c93d07b74: Don't use a static port number
Date:   Fri,  2 Sep 2022 08:17:51 +0700
Message-Id: <20220902011548.2506938-12-ammar.faizi@intel.com>
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
 test/232c93d07b74.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/test/232c93d07b74.c b/test/232c93d07b74.c
index c99491f..74cc063 100644
--- a/test/232c93d07b74.c
+++ b/test/232c93d07b74.c
@@ -18,29 +18,28 @@
 #include <sys/socket.h>
 #include <sys/un.h>
 #include <netinet/tcp.h>
 #include <netinet/in.h>
 #include <arpa/inet.h>
 
 #include "helpers.h"
 #include "liburing.h"
 
 #define RECV_BUFF_SIZE 2
 #define SEND_BUFF_SIZE 3
 
-#define PORT	0x1234
-
 struct params {
 	int tcp;
 	int non_blocking;
+	__be16 bind_port;
 };
 
 pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
 pthread_cond_t cond = PTHREAD_COND_INITIALIZER;
 int rcv_ready = 0;
 
 static void set_rcv_ready(void)
 {
 	pthread_mutex_lock(&mutex);
 
 	rcv_ready = 1;
 	pthread_cond_signal(&cond);
@@ -68,28 +67,27 @@ static void *rcv(void *arg)
 		int val = 1;
                 
 
 		s0 = socket(AF_INET, SOCK_STREAM | SOCK_CLOEXEC, IPPROTO_TCP);
 		res = setsockopt(s0, SOL_SOCKET, SO_REUSEPORT, &val, sizeof(val));
 		assert(res != -1);
 		res = setsockopt(s0, SOL_SOCKET, SO_REUSEADDR, &val, sizeof(val));
 		assert(res != -1);
 
 		struct sockaddr_in addr;
 
 		addr.sin_family = AF_INET;
-		addr.sin_port = htons(PORT);
 		addr.sin_addr.s_addr = inet_addr("127.0.0.1");
-		res = bind(s0, (struct sockaddr *) &addr, sizeof(addr));
-		assert(res != -1);
+		assert(t_bind_ephemeral_port(s0, &addr) == 0);
+		p->bind_port = addr.sin_port;
 	} else {
 		s0 = socket(AF_UNIX, SOCK_STREAM | SOCK_CLOEXEC, 0);
 		assert(s0 != -1);
 
 		struct sockaddr_un addr;
 		memset(&addr, 0, sizeof(addr));
 
 		addr.sun_family = AF_UNIX;
 		memcpy(addr.sun_path, "\0sock", 6);
 		res = bind(s0, (struct sockaddr *) &addr, sizeof(addr));
 		assert(res != -1);
 	}
@@ -183,25 +181,25 @@ static void *snd(void *arg)
 	wait_for_rcv_ready();
 
 	if (p->tcp) {
 		int val = 1;
 
 		s0 = socket(AF_INET, SOCK_STREAM | SOCK_CLOEXEC, IPPROTO_TCP);
 		ret = setsockopt(s0, IPPROTO_TCP, TCP_NODELAY, &val, sizeof(val));
 		assert(ret != -1);
 
 		struct sockaddr_in addr;
 
 		addr.sin_family = AF_INET;
-		addr.sin_port = htons(PORT);
+		addr.sin_port = p->bind_port;
 		addr.sin_addr.s_addr = inet_addr("127.0.0.1");
 		ret = connect(s0, (struct sockaddr*) &addr, sizeof(addr));
 		assert(ret != -1);
 	} else {
 		s0 = socket(AF_UNIX, SOCK_STREAM | SOCK_CLOEXEC, 0);
 		assert(s0 != -1);
 
 		struct sockaddr_un addr;
 		memset(&addr, 0, sizeof(addr));
 
 		addr.sun_family = AF_UNIX;
 		memcpy(addr.sun_path, "\0sock", 6);
-- 
Ammar Faizi

