Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C36D65AA4EC
	for <lists+io-uring@lfdr.de>; Fri,  2 Sep 2022 03:19:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234732AbiIBBSI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Sep 2022 21:18:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235151AbiIBBSH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Sep 2022 21:18:07 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12FD278BC6
        for <io-uring@vger.kernel.org>; Thu,  1 Sep 2022 18:18:07 -0700 (PDT)
Received: from localhost.localdomain (unknown [182.2.38.99])
        by gnuweeb.org (Postfix) with ESMTPSA id A093080BC2;
        Fri,  2 Sep 2022 01:18:03 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1662081486;
        bh=NdcWOVgA/+JNXYgu2bfVYwufZVhddbidhJxVIINy8VA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MOoAWQ/s4hr7w1lMCyBqk76DoTgplDYi2jK/vrsDyoHGUMd4dh8DL/UWBeEy65olk
         MSAB3l6/uXTLAmfvQx4oXjooLTCbUUUV72umtBPSlOlK6dZ6dJX7RwAFCIA8MVArP2
         Ok6+YjPifItzDF4MvbNS5tm804MmSGhJgxifrWaz1L8M0JVJ7n5pIiosfgtLd3dF1f
         18fxgJ9Gb8WILuA5mikVey0ROhr4G5sRdbRavDVdfyrWiIWijBeApEPR4UogFHMjch
         XAnBRmax+Kqu2fkoI0On7E296sd/WWu+g2YAMzhZEDXcELbfQY9t9XcLWYCyTRXio6
         y93LjzShZPbzg==
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
Subject: [RESEND PATCH liburing v1 02/12] t/poll-link: Don't brute force the port number
Date:   Fri,  2 Sep 2022 08:17:42 +0700
Message-Id: <20220902011548.2506938-3-ammar.faizi@intel.com>
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
 test/poll-link.c | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/test/poll-link.c b/test/poll-link.c
index 197ad77..a6fe0de 100644
--- a/test/poll-link.c
+++ b/test/poll-link.c
@@ -4,24 +4,25 @@
 #include <unistd.h>
 #include <stdlib.h>
 #include <string.h>
 #include <fcntl.h>
 #include <assert.h>
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
 
 static void signal_var(int *var)
 {
         pthread_mutex_lock(&mutex);
         *var = 1;
@@ -80,45 +81,37 @@ void *recv_thread(void *arg)
 	ret = io_uring_queue_init(8, &ring, 0);
 	assert(ret == 0);
 
 	int s0 = socket(AF_INET, SOCK_STREAM, IPPROTO_TCP);
 	assert(s0 != -1);
 
 	int32_t val = 1;
 	ret = setsockopt(s0, SOL_SOCKET, SO_REUSEPORT, &val, sizeof(val));
 	assert(ret != -1);
 	ret = setsockopt(s0, SOL_SOCKET, SO_REUSEADDR, &val, sizeof(val));
 	assert(ret != -1);
 
-	struct sockaddr_in addr;
+	struct sockaddr_in addr = { };
 
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
 	assert(sqe != NULL);
 
 	io_uring_prep_poll_add(sqe, s0, POLLIN | POLLHUP | POLLERR);
 	sqe->flags |= IOSQE_IO_LINK;
 	sqe->user_data = 1;
@@ -149,25 +142,24 @@ void *recv_thread(void *arg)
 					(uint64_t) cqe->user_data, cqe->res,
 					data->expected[idx]);
 			goto err;
 		} else if (!data->is_mask[idx] && cqe->res != data->expected[idx]) {
 			fprintf(stderr, "cqe %" PRIu64 " got %d, wanted %d\n",
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
 	io_uring_queue_exit(&ring);
 	return (void *) 1;
 }
 
 static int test_poll_timeout(int do_connect, unsigned long timeout)
-- 
Ammar Faizi

