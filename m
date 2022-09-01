Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E981D5A9539
	for <lists+io-uring@lfdr.de>; Thu,  1 Sep 2022 12:59:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234322AbiIAK6v (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 1 Sep 2022 06:58:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234312AbiIAK6k (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 1 Sep 2022 06:58:40 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EF5412AF5
        for <io-uring@vger.kernel.org>; Thu,  1 Sep 2022 03:58:39 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id cu2so33941427ejb.0
        for <io-uring@vger.kernel.org>; Thu, 01 Sep 2022 03:58:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=Zb5ypFcKc6aO+28jhXvvQMpsztKeVNc6T7YSBFw79eI=;
        b=opOP+4aQyOw3f9EbhfV1rx6g/VKhcyomUoOIAJhaRd4fVtNfsCTGawWvLdfVKUV7kb
         MBMvRk3YR9+16mogqT4ZZDlSL4S8mYJkk5gqAS7q2Iyrt5vYObGWAs4rUHib88CCGwIW
         hxlmAQ6zYDNXFQlmA/NoM9OBebbPx93/M1k78truEdtWDPo9UJ+FlkXCukwQrfkPOuW8
         lXxBBuxEHmTT+v/ItDt6C7A39Us5KTG+UxYdJSa9LXlKxuncSBipWIfjqFR46/YIMYWf
         apPRlxAIo4AXmMlE57JWq35DwM/LkEA9gTXGt9xfa3AWKDJMqxzBvX+6U/vGhysvKyS6
         XTxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=Zb5ypFcKc6aO+28jhXvvQMpsztKeVNc6T7YSBFw79eI=;
        b=73GKg8TMrWU7ETbEujSnkVHvJzDJePj1x8Rk1bWCfSv+dy6ocAXywrhsmFUHTpQumD
         p0vkjnRLnERJKF4PX6sIqiPrOXTaiJ02Ws80lNTrtd486n34YFQvCe3aEvfznZAYsa0u
         JDO/CVe8NFsKyj+BOlvOjwOa3mCJ28ZSGvfZc8uLSgvi/jAV1GlyUCmRoZ1fvNejHqlt
         6TDqWmcUCg7SiyfrbQYTsWFtGVcISMm5EFM/z5I6JEo6qVLXhJFIYqik8imLO0vitis/
         KYezR0cvuKjH2qRj/MNlXEwXAcqh4bMIxrkiIn0dP+WLltUqCgyUK5ZkL156xma9VuBU
         GI4Q==
X-Gm-Message-State: ACgBeo0FX2uPOVGj7Y3JBPXitRBQxtKtu/m5NY9UTeimb2JZnXDDkUT5
        0Tdsx4Rbm6tEPlCsqzEMZXFnhjL9XwM=
X-Google-Smtp-Source: AA6agR5rXOW3jb6hb/9gHv6VrP4Fn5Lnd04alCsqWqzb0e02iiUdkU9hSYaX2ia1L0lNPDJFzMxAsg==
X-Received: by 2002:a17:907:2722:b0:731:2aeb:7942 with SMTP id d2-20020a170907272200b007312aeb7942mr23389941ejl.734.1662029917169;
        Thu, 01 Sep 2022 03:58:37 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:e81f])
        by smtp.gmail.com with ESMTPSA id z14-20020a1709060ace00b0073d6d6e698bsm8277762ejf.187.2022.09.01.03.58.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Sep 2022 03:58:36 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [RFC 6/6] selftests/net: return back io_uring zc send tests
Date:   Thu,  1 Sep 2022 11:54:05 +0100
Message-Id: <c8e5018c516093bdad0b6e19f2f9847dea17e4d2.1662027856.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1662027856.git.asml.silence@gmail.com>
References: <cover.1662027856.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Enable io_uring zerocopy send tests back and fix them up to follow the
new inteface.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 .../selftests/net/io_uring_zerocopy_tx.c      | 110 ++++++------------
 .../selftests/net/io_uring_zerocopy_tx.sh     |  10 +-
 2 files changed, 41 insertions(+), 79 deletions(-)

diff --git a/tools/testing/selftests/net/io_uring_zerocopy_tx.c b/tools/testing/selftests/net/io_uring_zerocopy_tx.c
index 7446ef364e9f..8ce48aca8321 100644
--- a/tools/testing/selftests/net/io_uring_zerocopy_tx.c
+++ b/tools/testing/selftests/net/io_uring_zerocopy_tx.c
@@ -36,8 +36,6 @@
 #include <sys/un.h>
 #include <sys/wait.h>
 
-#if 0
-
 #define NOTIF_TAG 0xfffffffULL
 #define NONZC_TAG 0
 #define ZC_TAG 1
@@ -49,7 +47,6 @@ enum {
 	MODE_MIXED	= 3,
 };
 
-static bool cfg_flush		= false;
 static bool cfg_cork		= false;
 static int  cfg_mode		= MODE_ZC_FIXED;
 static int  cfg_nr_reqs		= 8;
@@ -168,21 +165,6 @@ static int io_uring_register_buffers(struct io_uring *ring,
 	return (ret < 0) ? -errno : ret;
 }
 
-static int io_uring_register_notifications(struct io_uring *ring,
-					   unsigned nr,
-					   struct io_uring_notification_slot *slots)
-{
-	int ret;
-	struct io_uring_notification_register r = {
-		.nr_slots = nr,
-		.data = (unsigned long)slots,
-	};
-
-	ret = syscall(__NR_io_uring_register, ring->ring_fd,
-		      IORING_REGISTER_NOTIFIERS, &r, sizeof(r));
-	return (ret < 0) ? -errno : ret;
-}
-
 static int io_uring_mmap(int fd, struct io_uring_params *p,
 			 struct io_uring_sq *sq, struct io_uring_cq *cq)
 {
@@ -299,11 +281,10 @@ static inline void io_uring_prep_send(struct io_uring_sqe *sqe, int sockfd,
 
 static inline void io_uring_prep_sendzc(struct io_uring_sqe *sqe, int sockfd,
 				        const void *buf, size_t len, int flags,
-				        unsigned slot_idx, unsigned zc_flags)
+				        unsigned zc_flags)
 {
 	io_uring_prep_send(sqe, sockfd, buf, len, flags);
-	sqe->opcode = (__u8) IORING_OP_SENDZC_NOTIF;
-	sqe->notification_idx = slot_idx;
+	sqe->opcode = (__u8) IORING_OP_SEND_ZC;
 	sqe->ioprio = zc_flags;
 }
 
@@ -376,7 +357,6 @@ static int do_setup_tx(int domain, int type, int protocol)
 
 static void do_tx(int domain, int type, int protocol)
 {
-	struct io_uring_notification_slot b[1] = {{.tag = NOTIF_TAG}};
 	struct io_uring_sqe *sqe;
 	struct io_uring_cqe *cqe;
 	unsigned long packets = 0, bytes = 0;
@@ -392,10 +372,6 @@ static void do_tx(int domain, int type, int protocol)
 	if (ret)
 		error(1, ret, "io_uring: queue init");
 
-	ret = io_uring_register_notifications(&ring, 1, b);
-	if (ret)
-		error(1, ret, "io_uring: tx ctx registration");
-
 	iov.iov_base = payload;
 	iov.iov_len = cfg_payload_len;
 
@@ -411,9 +387,8 @@ static void do_tx(int domain, int type, int protocol)
 		for (i = 0; i < cfg_nr_reqs; i++) {
 			unsigned zc_flags = 0;
 			unsigned buf_idx = 0;
-			unsigned slot_idx = 0;
 			unsigned mode = cfg_mode;
-			unsigned msg_flags = 0;
+			unsigned msg_flags = MSG_WAITALL;
 
 			if (cfg_mode == MODE_MIXED)
 				mode = rand() % 3;
@@ -425,13 +400,10 @@ static void do_tx(int domain, int type, int protocol)
 						   cfg_payload_len, msg_flags);
 				sqe->user_data = NONZC_TAG;
 			} else {
-				if (cfg_flush) {
-					zc_flags |= IORING_RECVSEND_NOTIF_FLUSH;
-					compl_cqes++;
-				}
+				compl_cqes++;
 				io_uring_prep_sendzc(sqe, fd, payload,
 						     cfg_payload_len,
-						     msg_flags, slot_idx, zc_flags);
+						     msg_flags, zc_flags);
 				if (mode == MODE_ZC_FIXED) {
 					sqe->ioprio |= IORING_RECVSEND_FIXED_BUF;
 					sqe->buf_index = buf_idx;
@@ -444,51 +416,57 @@ static void do_tx(int domain, int type, int protocol)
 		if (ret != cfg_nr_reqs)
 			error(1, ret, "submit");
 
+		if (cfg_cork)
+			do_setsockopt(fd, IPPROTO_UDP, UDP_CORK, 0);
 		for (i = 0; i < cfg_nr_reqs; i++) {
 			ret = io_uring_wait_cqe(&ring, &cqe);
 			if (ret)
 				error(1, ret, "wait cqe");
 
-			if (cqe->user_data == NOTIF_TAG) {
+			if (cqe->user_data != NONZC_TAG &&
+			    cqe->user_data != ZC_TAG)
+				error(1, -EINVAL, "invalid cqe->user_data");
+
+			if (cqe->flags & IORING_CQE_F_NOTIF) {
+				if (cqe->flags & IORING_CQE_F_MORE)
+					error(1, -EINVAL, "invalid notif flags");
 				compl_cqes--;
 				i--;
-			} else if (cqe->user_data != NONZC_TAG &&
-				   cqe->user_data != ZC_TAG) {
-				error(1, cqe->res, "invalid user_data");
-			} else if (cqe->res <= 0 && cqe->res != -EAGAIN) {
+			} else if (cqe->res <= 0) {
+				if (cqe->flags & IORING_CQE_F_MORE)
+					error(1, cqe->res, "more with a failed send");
 				error(1, cqe->res, "send failed");
 			} else {
-				if (cqe->res > 0) {
-					packets++;
-					bytes += cqe->res;
-				}
-				/* failed requests don't flush */
-				if (cfg_flush &&
-				    cqe->res <= 0 &&
-				    cqe->user_data == ZC_TAG)
-					compl_cqes--;
+				if (cqe->user_data == ZC_TAG &&
+				    !(cqe->flags & IORING_CQE_F_MORE))
+					error(1, cqe->res, "missing more flag");
+				packets++;
+				bytes += cqe->res;
 			}
 			io_uring_cqe_seen(&ring);
 		}
-		if (cfg_cork)
-			do_setsockopt(fd, IPPROTO_UDP, UDP_CORK, 0);
 	} while (gettimeofday_ms() < tstop);
 
-	if (close(fd))
-		error(1, errno, "close");
-
-	fprintf(stderr, "tx=%lu (MB=%lu), tx/s=%lu (MB/s=%lu)\n",
-			packets, bytes >> 20,
-			packets / (cfg_runtime_ms / 1000),
-			(bytes >> 20) / (cfg_runtime_ms / 1000));
-
 	while (compl_cqes) {
 		ret = io_uring_wait_cqe(&ring, &cqe);
 		if (ret)
 			error(1, ret, "wait cqe");
+		if (cqe->flags & IORING_CQE_F_MORE)
+			error(1, -EINVAL, "invalid notif flags");
+		if (!(cqe->flags & IORING_CQE_F_NOTIF))
+			error(1, -EINVAL, "missing notif flag");
+
 		io_uring_cqe_seen(&ring);
 		compl_cqes--;
 	}
+
+	fprintf(stderr, "tx=%lu (MB=%lu), tx/s=%lu (MB/s=%lu)\n",
+			packets, bytes >> 20,
+			packets / (cfg_runtime_ms / 1000),
+			(bytes >> 20) / (cfg_runtime_ms / 1000));
+
+	if (close(fd))
+		error(1, errno, "close");
 }
 
 static void do_test(int domain, int type, int protocol)
@@ -502,8 +480,8 @@ static void do_test(int domain, int type, int protocol)
 
 static void usage(const char *filepath)
 {
-	error(1, 0, "Usage: %s [-f] [-n<N>] [-z0] [-s<payload size>] "
-		    "(-4|-6) [-t<time s>] -D<dst_ip> udp", filepath);
+	error(1, 0, "Usage: %s (-4|-6) (udp|tcp) -D<dst_ip> [-s<payload size>] "
+		    "[-t<time s>] [-n<batch>] [-p<port>] [-m<mode>]", filepath);
 }
 
 static void parse_opts(int argc, char **argv)
@@ -521,7 +499,7 @@ static void parse_opts(int argc, char **argv)
 		usage(argv[0]);
 	cfg_payload_len = max_payload_len;
 
-	while ((c = getopt(argc, argv, "46D:p:s:t:n:fc:m:")) != -1) {
+	while ((c = getopt(argc, argv, "46D:p:s:t:n:c:m:")) != -1) {
 		switch (c) {
 		case '4':
 			if (cfg_family != PF_UNSPEC)
@@ -550,9 +528,6 @@ static void parse_opts(int argc, char **argv)
 		case 'n':
 			cfg_nr_reqs = strtoul(optarg, NULL, 0);
 			break;
-		case 'f':
-			cfg_flush = 1;
-			break;
 		case 'c':
 			cfg_cork = strtol(optarg, NULL, 0);
 			break;
@@ -585,8 +560,6 @@ static void parse_opts(int argc, char **argv)
 
 	if (cfg_payload_len > max_payload_len)
 		error(1, 0, "-s: payload exceeds max (%d)", max_payload_len);
-	if (cfg_mode == MODE_NONZC && cfg_flush)
-		error(1, 0, "-f: only zerocopy modes support notifications");
 	if (optind != argc - 1)
 		usage(argv[0]);
 }
@@ -605,10 +578,3 @@ int main(int argc, char **argv)
 		error(1, 0, "unknown cfg_test %s", cfg_test);
 	return 0;
 }
-
-#else
-int main(int argc, char **argv)
-{
-	return 0;
-}
-#endif
diff --git a/tools/testing/selftests/net/io_uring_zerocopy_tx.sh b/tools/testing/selftests/net/io_uring_zerocopy_tx.sh
index 6a65e4437640..32aa6e9dacc2 100755
--- a/tools/testing/selftests/net/io_uring_zerocopy_tx.sh
+++ b/tools/testing/selftests/net/io_uring_zerocopy_tx.sh
@@ -25,15 +25,11 @@ readonly path_sysctl_mem="net.core.optmem_max"
 # No arguments: automated test
 if [[ "$#" -eq "0" ]]; then
 	IPs=( "4" "6" )
-	protocols=( "tcp" "udp" )
 
 	for IP in "${IPs[@]}"; do
-		for proto in "${protocols[@]}"; do
-			for mode in $(seq 1 3); do
-				$0 "$IP" "$proto" -m "$mode" -t 1 -n 32
-				$0 "$IP" "$proto" -m "$mode" -t 1 -n 32 -f
-				$0 "$IP" "$proto" -m "$mode" -t 1 -n 32 -c -f
-			done
+		for mode in $(seq 1 3); do
+			$0 "$IP" udp -m "$mode" -t 1 -n 32
+			$0 "$IP" tcp -m "$mode" -t 1 -n 32
 		done
 	done
 
-- 
2.37.2

