Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 528BD5AA893
	for <lists+io-uring@lfdr.de>; Fri,  2 Sep 2022 09:15:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234195AbiIBHPj (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Sep 2022 03:15:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235446AbiIBHPi (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Sep 2022 03:15:38 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AF122BB2A
        for <io-uring@vger.kernel.org>; Fri,  2 Sep 2022 00:15:35 -0700 (PDT)
Received: from localhost.localdomain (unknown [182.2.70.226])
        by gnuweeb.org (Postfix) with ESMTPSA id CB2DD80C38;
        Fri,  2 Sep 2022 07:15:31 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1662102935;
        bh=tWfvU6nGOwRgpO1E4lOI3rFftClQKt3nqBwHF9ncPfk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mBoR9nBt+OjwsAh9U+XqX3Dg0nlnHcWGaEscVB6/hGW2VWGdUuT2U0LDrgpHvLOlg
         d0E08KVyAYw8oZ7R4DUX/whctCnkSFHhR9t4gZyw0sWpb0mKN+Ac18JZNqY4kuKGgb
         ywL6mNxpvPy+N8WW+Mu6yx1satGQpvWwc4SEfkafnDQlAvXS5jFvaY5DgV75IOVmFr
         qvRWCAudRnMaYuWbBLT9crMIEQxSgfUPAA1laUW4vrmPyLMbP6ks3WbUodS1+lDuVn
         IdkFarB75Vaj60E20LsFYaTko6AMX7dPPbZZzUsy8dGoj3EWHNsICZoQCMuTz9hoGE
         OjE5Lh4xHM5/w==
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
Subject: [PATCH liburing v2 02/12] t/poll-link: Don't brute force the port number
Date:   Fri,  2 Sep 2022 14:14:55 +0700
Message-Id: <20220902071153.3168814-3-ammar.faizi@intel.com>
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

v2:
  - While in there, fix variable placements (put them at the top).

Cc: Dylan Yudaken <dylany@fb.com>
Cc: Facebook Kernel Team <kernel-team@fb.com>
Cc: Pavel Begunkov <asml.silence@gmail.com>
Reviewed-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Tested-by: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 test/poll-link.c | 27 +++++++++------------------
 1 file changed, 9 insertions(+), 18 deletions(-)

diff --git a/test/poll-link.c b/test/poll-link.c
index 197ad77..39b48f5 100644
--- a/test/poll-link.c
+++ b/test/poll-link.c
@@ -9,14 +9,15 @@
 #include <pthread.h>
 #include <sys/socket.h>
 #include <netinet/tcp.h>
 #include <netinet/in.h>
 #include <poll.h>
 #include <arpa/inet.h>
 
+#include "helpers.h"
 #include "liburing.h"
 
 pthread_mutex_t mutex = PTHREAD_MUTEX_INITIALIZER;
 pthread_cond_t cond = PTHREAD_COND_INITIALIZER;
 
 static int recv_thread_ready = 0;
 static int recv_thread_done = 0;
@@ -46,36 +47,37 @@ struct data {
 	unsigned short port;
 	unsigned int addr;
 	int stop;
 };
 
 static void *send_thread(void *arg)
 {
+	struct sockaddr_in addr;
 	struct data *data = arg;
+	int s0;
 
 	wait_for_var(&recv_thread_ready);
 
-	int s0 = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
+	s0 = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
 	assert(s0 != -1);
 
-	struct sockaddr_in addr;
-
 	addr.sin_family = AF_INET;
 	addr.sin_port = data->port;
 	addr.sin_addr.s_addr = data->addr;
 
 	if (connect(s0, (struct sockaddr*)&addr, sizeof(addr)) != -1)
 		wait_for_var(&recv_thread_done);
 
 	close(s0);
 	return 0;
 }
 
 void *recv_thread(void *arg)
 {
+	struct sockaddr_in addr = { };
 	struct data *data = arg;
 	struct io_uring_sqe *sqe;
 	struct io_uring ring;
 	int i, ret;
 
 	ret = io_uring_queue_init(8, &ring, 0);
 	assert(ret == 0);
@@ -85,35 +87,25 @@ void *recv_thread(void *arg)
 
 	int32_t val = 1;
 	ret = setsockopt(s0, SOL_SOCKET, SO_REUSEPORT, &val, sizeof(val));
 	assert(ret != -1);
 	ret = setsockopt(s0, SOL_SOCKET, SO_REUSEADDR, &val, sizeof(val));
 	assert(ret != -1);
 
-	struct sockaddr_in addr;
-
 	addr.sin_family = AF_INET;
 	data->addr = inet_addr("127.0.0.1");
 	addr.sin_addr.s_addr = data->addr;
 
-	i = 0;
-	do {
-		data->port = htons(1025 + (rand() % 64510));
-		addr.sin_port = data->port;
-
-		if (bind(s0, (struct sockaddr*)&addr, sizeof(addr)) != -1)
-			break;
-	} while (++i < 100);
-
-	if (i >= 100) {
-		fprintf(stderr, "Can't find good port, skipped\n");
+	if (t_bind_ephemeral_port(s0, &addr)) {
+		perror("bind");
 		data->stop = 1;
 		signal_var(&recv_thread_ready);
-		goto out;
+		goto err;
 	}
+	data->port = addr.sin_port;
 
 	ret = listen(s0, 128);
 	assert(ret != -1);
 
 	signal_var(&recv_thread_ready);
 
 	sqe = io_uring_get_sqe(&ring);
@@ -154,15 +146,14 @@ void *recv_thread(void *arg)
 					(uint64_t) cqe->user_data, cqe->res,
 					data->expected[idx]);
 			goto err;
 		}
 		io_uring_cqe_seen(&ring, cqe);
 	}
 
-out:
 	signal_var(&recv_thread_done);
 	close(s0);
 	io_uring_queue_exit(&ring);
 	return NULL;
 err:
 	signal_var(&recv_thread_done);
 	close(s0);
-- 
Ammar Faizi

