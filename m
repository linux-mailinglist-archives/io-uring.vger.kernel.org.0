Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D17C6FE089
	for <lists+io-uring@lfdr.de>; Wed, 10 May 2023 16:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237518AbjEJOk1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 10 May 2023 10:40:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237111AbjEJOkW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 10 May 2023 10:40:22 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 552A86EB5;
        Wed, 10 May 2023 07:40:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1683729615;
        bh=SKIms/x8UkuCSr7MMpMwCUwu5UFRx/RZRLA+rEglAko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=jZseRr+FoEyBwmEDpOSOuV1XqLGTpFkp1YdWeGNopmPeGlzWr+noMhhYkVGLQNh3t
         4UsvxDcUNQ5HXZZ7Sy/uoPqRg0fLJuIHMmL0UU/3CAYhAwyohY6O/b/5qNVLaOsuZY
         wjhMsT8NASw5rWXUj6PPGo9iS0Va3Vi2NusYDoOEFIGi1J0RXwxDFO6SH5Cqr6llv2
         yRXVxl59iYbuDsvrxKCnqAKB81J6o0cmRUQo0fKBaVN8xTZeXQZF5Yj2Co+tkCFI7M
         +ifDSBzTkmRGiRBL6QdyHiSWyfjL29BjyFJw+ypvllEQv/nsEjshIN0PZGK3g30KEx
         kGzk4Cd/aI+DA==
Received: from integral2.. (unknown [101.128.114.135])
        by gnuweeb.org (Postfix) with ESMTPSA id B13FE245CF1;
        Wed, 10 May 2023 21:40:13 +0700 (WIB)
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        =?UTF-8?q?Barnab=C3=A1s=20P=C5=91cze?= <pobrn@protonmail.com>,
        Michael William Jonathan <moe@gnuweeb.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        io-uring Mailing List <io-uring@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>
Subject: [PATCH liburing v1 2/2] recv-msgall: Fix invalid mutex usage
Date:   Wed, 10 May 2023 21:39:27 +0700
Message-Id: <20230510143927.123170-3-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20230510143927.123170-1-ammarfaizi2@gnuweeb.org>
References: <20230510143927.123170-1-ammarfaizi2@gnuweeb.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Calling pthread_mutex_lock() twice with the same mutex in the same
thread without unlocking it first is invalid. The intention behind this
pattern was to wait for the recv_fn() thread to be ready.

Use the pthread barrier instead. It is more straightforward and correct.

Fixes: https://github.com/axboe/liburing/issues/855
Reported-by: Barnabás Pőcze <pobrn@protonmail.com>
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---
 test/recv-msgall.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/test/recv-msgall.c b/test/recv-msgall.c
index f809834b2e427fc5..d1fcdb0d510423e7 100644
--- a/test/recv-msgall.c
+++ b/test/recv-msgall.c
@@ -19,7 +19,7 @@
 #define HOST	"127.0.0.1"
 static __be16 bind_port;
 struct recv_data {
-	pthread_mutex_t mutex;
+	pthread_barrier_t barrier;
 	int use_recvmsg;
 	struct msghdr msg;
 };
@@ -122,11 +122,11 @@ static void *recv_fn(void *data)
 
 	ret = t_create_ring_params(1, &ring, &p);
 	if (ret == T_SETUP_SKIP) {
-		pthread_mutex_unlock(&rd->mutex);
+		pthread_barrier_wait(&rd->barrier);
 		ret = 0;
 		goto err;
 	} else if (ret < 0) {
-		pthread_mutex_unlock(&rd->mutex);
+		pthread_barrier_wait(&rd->barrier);
 		goto err;
 	}
 
@@ -135,7 +135,7 @@ static void *recv_fn(void *data)
 		fprintf(stderr, "recv_prep failed: %d\n", ret);
 		goto err;
 	}
-	pthread_mutex_unlock(&rd->mutex);
+	pthread_barrier_wait(&rd->barrier);
 	ret = do_recv(&ring);
 	close(sock);
 	io_uring_queue_exit(&ring);
@@ -219,28 +219,24 @@ err:
 
 static int test(int use_recvmsg)
 {
-	pthread_mutexattr_t attr;
 	pthread_t recv_thread;
 	struct recv_data rd;
 	int ret;
 	void *retval;
 
-	pthread_mutexattr_init(&attr);
-	pthread_mutexattr_setpshared(&attr, 1);
-	pthread_mutex_init(&rd.mutex, &attr);
-	pthread_mutex_lock(&rd.mutex);
+	pthread_barrier_init(&rd.barrier, NULL, 2);
 	rd.use_recvmsg = use_recvmsg;
 
 	ret = pthread_create(&recv_thread, NULL, recv_fn, &rd);
 	if (ret) {
 		fprintf(stderr, "Thread create failed: %d\n", ret);
-		pthread_mutex_unlock(&rd.mutex);
 		return 1;
 	}
 
-	pthread_mutex_lock(&rd.mutex);
+	pthread_barrier_wait(&rd.barrier);
 	do_send();
 	pthread_join(recv_thread, &retval);
+	pthread_barrier_destroy(&rd.barrier);
 	return (intptr_t)retval;
 }
 
-- 
Ammar Faizi

