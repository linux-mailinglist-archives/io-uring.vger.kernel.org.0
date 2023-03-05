Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB63A6AAE44
	for <lists+io-uring@lfdr.de>; Sun,  5 Mar 2023 06:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbjCEFOU (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 5 Mar 2023 00:14:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbjCEFOT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 5 Mar 2023 00:14:19 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72637C175
        for <io-uring@vger.kernel.org>; Sat,  4 Mar 2023 21:14:17 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id bx12so5759130wrb.11
        for <io-uring@vger.kernel.org>; Sat, 04 Mar 2023 21:14:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IPKU78BEH9btRUN+ftOf80HhUjKqgHsnteqpHUeZfQM=;
        b=JXl6zqhiQaL8w//s08ECTh7YXB5m8xhn1y3grYwvBAi9yPvDQzQ9MOa3+EJdGcF6af
         v4Sn1Ro4XGeHS9LNBkCgjb5Zz7so92W09SQ6iBAQb9d8c7J31VzFkvNmcpWXFjb/7p4f
         ZZcbxsBsSb6k9U/7ItlL82krfNV0LMwRHT/kADcfX6zCrigglw2oy2lbBIphdkbarJsI
         Cod8+QWNNnvk3cURNfqb6soDCHsk+vZXZoxBio+T64TnYYrGsbTjNb+g3XQpyUKw//HB
         NrGQVNO4anOx8SWu1GZhCwSznnXckbi/CScPL46jqrInYzVtUoJJx8/JIXkkdL2Mb9D1
         uX+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IPKU78BEH9btRUN+ftOf80HhUjKqgHsnteqpHUeZfQM=;
        b=KAxPMcJMvs/67LbnrfojjZV1R13TayqbCnekq5Fq2SiNGxJheWO/GwaIyQtnI8NfVT
         RIhZk0rfIhPxtgD0YpWmIQE23H9tah9jDJxgp+1gAMgclAFP5vIR/agyEj70S9Fz09eh
         922qQ1gSJ0+6U0t4vCNcjtMt84RkIeyboRSgTRla1X4eotqiMLCt7zHSBXFmfkh/vKes
         mPneI9cLAd9dgu9ctFGf2FbSKHI7QuUng96W8VX99+Gawc4s2DgI93qFTtcmhrEP7vEz
         dnxGFHVrWV3wUdfvkQYhOI1KSKRRYQDh16EwjrxhmhKcGAJ56HakcuO+fgx+BQQGfaFv
         oQGA==
X-Gm-Message-State: AO0yUKVNkcBAbx1pBsn+SXhRUB9ASjnze1/D0BaP8rI1ub9J3chl0n3L
        nWMS7n3v1cX+K6CffjvtG+3oIdqmIiY=
X-Google-Smtp-Source: AK7set85FBRV0Yt36KZOisIPBtj05doZxM4fw4JwcGmUhTdr6vrXVOakoT7WGEdWDcdvF7xmON4MOg==
X-Received: by 2002:adf:f78e:0:b0:2c8:bf89:39be with SMTP id q14-20020adff78e000000b002c8bf8939bemr5224040wrp.7.1677993255781;
        Sat, 04 Mar 2023 21:14:15 -0800 (PST)
Received: from 127.0.0.1localhost (94.196.92.184.threembb.co.uk. [94.196.92.184])
        by smtp.gmail.com with ESMTPSA id j4-20020adfff84000000b002cda9aa1dc1sm6524348wrr.111.2023.03.04.21.14.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Mar 2023 21:14:15 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing v2 4/5] examples/send-zc: add the receive part
Date:   Sun,  5 Mar 2023 05:13:07 +0000
Message-Id: <05beb317f14f7903f8edf7be981d17ad1dd46770.1677993039.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <cover.1677993039.git.asml.silence@gmail.com>
References: <cover.1677993039.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

'-R' will switch the benchmark into the server mode accepting data. For
TCP the number of threads should match the number of threads of the
client. For UDP just one thread/connection should be enough.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 examples/send-zerocopy.c | 148 +++++++++++++++++++++++++++++++++++++--
 1 file changed, 144 insertions(+), 4 deletions(-)

diff --git a/examples/send-zerocopy.c b/examples/send-zerocopy.c
index 683a965..8e1242e 100644
--- a/examples/send-zerocopy.c
+++ b/examples/send-zerocopy.c
@@ -13,6 +13,7 @@
 #include <string.h>
 #include <pthread.h>
 
+#include <poll.h>
 #include <sched.h>
 #include <arpa/inet.h>
 #include <linux/if_packet.h>
@@ -52,6 +53,7 @@ struct thread_data {
 	unsigned long long packets;
 	unsigned long long bytes;
 	struct sockaddr_storage dst_addr;
+	int fd;
 };
 
 static bool cfg_reg_ringfd = true;
@@ -62,6 +64,7 @@ static bool cfg_fixed_buf = 1;
 static bool cfg_hugetlb = 0;
 static bool cfg_defer_taskrun = 0;
 static int  cfg_cpu = -1;
+static bool cfg_rx = 0;
 static unsigned  cfg_nr_threads = 1;
 
 static int  cfg_family		= PF_UNSPEC;
@@ -164,6 +167,135 @@ static void setup_sockaddr(int domain, const char *str_addr,
 	}
 }
 
+static int do_poll(int fd, int events)
+{
+	struct pollfd pfd;
+	int ret;
+
+	pfd.events = events;
+	pfd.revents = 0;
+	pfd.fd = fd;
+
+	ret = poll(&pfd, 1, -1);
+	if (ret == -1)
+		t_error(1, errno, "poll");
+
+	return ret && (pfd.revents & events);
+}
+
+/* Flush all outstanding bytes for the tcp receive queue */
+static int do_flush_tcp(struct thread_data *td, int fd)
+{
+	int ret;
+
+	/* MSG_TRUNC flushes up to len bytes */
+	ret = recv(fd, NULL, 1 << 21, MSG_TRUNC | MSG_DONTWAIT);
+	if (ret == -1 && errno == EAGAIN)
+		return 0;
+	if (ret == -1)
+		t_error(1, errno, "flush");
+	if (!ret)
+		return 1;
+
+	td->packets++;
+	td->bytes += ret;
+	return 0;
+}
+
+/* Flush all outstanding datagrams. Verify first few bytes of each. */
+static int do_flush_datagram(struct thread_data *td, int fd, int type)
+{
+	int ret, off = 0;
+	char buf[64];
+
+	/* MSG_TRUNC will return full datagram length */
+	ret = recv(fd, buf, sizeof(buf), MSG_DONTWAIT | MSG_TRUNC);
+	if (ret == -1 && errno == EAGAIN)
+		return 0;
+
+	if (ret == -1)
+		t_error(1, errno, "recv");
+	if (ret != cfg_payload_len)
+		t_error(1, 0, "recv: ret=%u != %u", ret, cfg_payload_len);
+	if (ret > sizeof(buf) - off)
+		ret = sizeof(buf) - off;
+	if (memcmp(buf + off, payload, ret))
+		t_error(1, 0, "recv: data mismatch");
+
+	td->packets++;
+	td->bytes += cfg_payload_len;
+	return 0;
+}
+
+static void do_setup_rx(int domain, int type, int protocol)
+{
+	struct sockaddr_storage addr = {};
+	struct thread_data *td;
+	int listen_fd, fd, i;
+
+	fd = socket(domain, type, protocol);
+	if (fd == -1)
+		t_error(1, errno, "socket r");
+
+	do_setsockopt(fd, SOL_SOCKET, SO_RCVBUF, 1 << 21);
+	do_setsockopt(fd, SOL_SOCKET, SO_RCVLOWAT, 1 << 16);
+	do_setsockopt(fd, SOL_SOCKET, SO_REUSEPORT, 1);
+
+	setup_sockaddr(cfg_family, str_addr, &addr);
+
+	if (bind(fd, (void *)&addr, cfg_alen))
+		t_error(1, errno, "bind");
+
+	if (type != SOCK_STREAM) {
+		if (cfg_nr_threads != 1)
+			t_error(1, 0, "udp rx cant multithread");
+		threads[0].fd = fd;
+		return;
+	}
+
+	listen_fd = fd;
+	if (listen(listen_fd, cfg_nr_threads))
+		t_error(1, errno, "listen");
+
+	for (i = 0; i < cfg_nr_threads; i++) {
+		td = &threads[i];
+
+		fd = accept(listen_fd, NULL, NULL);
+		if (fd == -1)
+			t_error(1, errno, "accept");
+		td->fd = fd;
+	}
+
+	if (close(listen_fd))
+		t_error(1, errno, "close listen sock");
+}
+
+static void *do_rx(void *arg)
+{
+	struct thread_data *td = arg;
+	const int cfg_receiver_wait_ms = 400;
+	uint64_t tstop;
+	int ret, fd = td->fd;
+
+	tstop = gettimeofday_ms() + cfg_runtime_ms + cfg_receiver_wait_ms;
+	do {
+		if (cfg_type == SOCK_STREAM)
+			ret = do_flush_tcp(td, fd);
+		else
+			ret = do_flush_datagram(td, fd, cfg_type);
+
+		if (ret)
+			break;
+
+		do_poll(fd, POLLIN);
+	} while (gettimeofday_ms() < tstop);
+
+	if (close(fd))
+		t_error(1, errno, "close");
+	pthread_exit(&td->ret);
+	return NULL;
+}
+
 static inline struct io_uring_cqe *wait_cqe_fast(struct io_uring *ring)
 {
 	struct io_uring_cqe *cqe;
@@ -283,7 +415,7 @@ static void do_tx(struct thread_data *td, int domain, int type, int protocol)
 				td->bytes += cqe->res;
 			} else if (cqe->res == -ECONNREFUSED || cqe->res == -EPIPE ||
 				   cqe->res == -ECONNRESET) {
-				fprintf(stderr, "Connection failure");
+				fprintf(stderr, "Connection failure\n");
 				goto out_fail;
 			} else if (cqe->res != -EAGAIN) {
 				t_error(1, cqe->res, "send failed");
@@ -316,6 +448,7 @@ static void *do_test(void *arg)
 
 	do_tx(td, cfg_family, cfg_type, protocol);
 	pthread_exit(&td->ret);
+	return NULL;
 }
 
 static void usage(const char *filepath)
@@ -338,7 +471,7 @@ static void parse_opts(int argc, char **argv)
 
 	cfg_payload_len = max_payload_len;
 
-	while ((c = getopt(argc, argv, "46D:p:s:t:n:z:b:l:dC:T:")) != -1) {
+	while ((c = getopt(argc, argv, "46D:p:s:t:n:z:b:l:dC:T:R")) != -1) {
 		switch (c) {
 		case '4':
 			if (cfg_family != PF_UNSPEC)
@@ -387,6 +520,9 @@ static void parse_opts(int argc, char **argv)
 			if (cfg_nr_threads > MAX_THREADS)
 				t_error(1, 0, "too many threads\n");
 			break;
+		case 'R':
+			cfg_rx = 1;
+			break;
 		}
 	}
 
@@ -441,8 +577,12 @@ int main(int argc, char **argv)
 		td->idx = i;
 	}
 
+	if (cfg_rx)
+		do_setup_rx(cfg_family, cfg_type, 0);
+
 	for (i = 0; i < cfg_nr_threads; i++)
-		pthread_create(&threads[i].thread, NULL, do_test, td);
+		pthread_create(&threads[i].thread, NULL,
+				!cfg_rx ? do_test : do_rx, &threads[i]);
 
 	for (i = 0; i < cfg_nr_threads; i++) {
 		td = &threads[i];
@@ -451,7 +591,7 @@ int main(int argc, char **argv)
 		bytes += td->bytes;
 	}
 
-	fprintf(stderr, "tx=%llu (MB=%llu), tx/s=%llu (MB/s=%llu)\n",
+	fprintf(stderr, "packets=%llu (MB=%llu), rps=%llu (MB/s=%llu)\n",
 		packets, bytes >> 20,
 		packets / (cfg_runtime_ms / 1000),
 		(bytes >> 20) / (cfg_runtime_ms / 1000));
-- 
2.39.1

