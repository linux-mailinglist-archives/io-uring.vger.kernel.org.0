Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89EC65AAD48
	for <lists+io-uring@lfdr.de>; Fri,  2 Sep 2022 13:15:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232171AbiIBLO7 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Sep 2022 07:14:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232701AbiIBLO5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Sep 2022 07:14:57 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61ECC167F9
        for <io-uring@vger.kernel.org>; Fri,  2 Sep 2022 04:14:54 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id e13so1895603wrm.1
        for <io-uring@vger.kernel.org>; Fri, 02 Sep 2022 04:14:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date;
        bh=n/ep2tVyh0ibmO7Yma+OsUsgQqAGoiz9HFnun+tCOUg=;
        b=DZDHxIlHa5PL5ydhmmrK6gNM/WteZItotVG+obNQZUSE5WIQGGozSxlcqeExnYlj/o
         Y4CI9+Zs/sG3BPLh51YQNxPHRGQFIhoWUteFP4AuC98NxrfDpTiidyIxmcw17lBa9IGe
         kOUqDHEoXQcWB+/02GCsMsRlCiNXoZ7xwsBNn0sgRTtToQM1xPwQsMiMg6PDQl4XIzQo
         4ruW0agUrkeZ+edMhKhdphLtJ7dIHSxTyY3SY6mvZnSdvHsdZPqTV7D/atBBLkkdng6h
         /exPjnxkNEa/Rfv7WNBWoM8gaRiAFh6EWqoaYfEY0YwJMyTo5Kzb62e9rvVUkea1WkQU
         CgGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date;
        bh=n/ep2tVyh0ibmO7Yma+OsUsgQqAGoiz9HFnun+tCOUg=;
        b=aTHeLbBoSfn8Y4cT5X6Ak8YEjPYI5UDfwN8c2/dq3I7C1ZqCqHUU38txX3hRxegFIW
         Fgahrxf8pIT2Cu0HMhGVlTQQ8a3Ab6xu/o4Rbh8fgIC/iWs8EEAKPX5PZT7SLQa45pHx
         4X6uWlU88JJpsMXnEnWw3Zlro0IahZHOnBwgnCK1iJ0xQTW1xY6yBAf3Df/CwmodcrbD
         7CL13CyKw6Fgo5UZdL+THSBFgdwj/5nNjta0cyWmChehmefbHj9n/6iINpU7sjjpOcOJ
         q6blS7bdYXGMaUbfIG4zFM0PfizCdk+w/IsM5lFRUVJt164IWKIbW9e7Efhid7Ou6+Ns
         rXgQ==
X-Gm-Message-State: ACgBeo38q1q4+pJ1kFI0fB9cXhCcoAp3yfRwjFeZXWB1+RF+5Z6PwiZL
        DHzEj9XCFhBsoctDdKUBbKfrhUyv/00=
X-Google-Smtp-Source: AA6agR7/PCK/0Gv+ZMU8ikXWLbVW9g1P9Si74iK3IgsgUWW5IRULc5AgfUClExLD+SPU5YsjdyrfGw==
X-Received: by 2002:a5d:5989:0:b0:221:7c34:3943 with SMTP id n9-20020a5d5989000000b002217c343943mr16189103wri.441.1662117292496;
        Fri, 02 Sep 2022 04:14:52 -0700 (PDT)
Received: from 127.0.0.1localhost (82-132-230-225.dab.02.net. [82.132.230.225])
        by smtp.gmail.com with ESMTPSA id bg32-20020a05600c3ca000b003a536d5aa2esm2087379wmb.11.2022.09.02.04.14.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Sep 2022 04:14:52 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 4/4] examples: adjust zc bench to the new uapi
Date:   Fri,  2 Sep 2022 12:12:39 +0100
Message-Id: <4d08a85d62101e0137cf2bd3587c45bd14667655.1662116617.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <cover.1662116617.git.asml.silence@gmail.com>
References: <cover.1662116617.git.asml.silence@gmail.com>
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

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 examples/send-zerocopy.c | 72 +++++++++++++---------------------------
 1 file changed, 23 insertions(+), 49 deletions(-)

diff --git a/examples/send-zerocopy.c b/examples/send-zerocopy.c
index e42aa71..4ed0f67 100644
--- a/examples/send-zerocopy.c
+++ b/examples/send-zerocopy.c
@@ -44,7 +44,6 @@
 static bool cfg_reg_ringfd = true;
 static bool cfg_fixed_files = 1;
 static bool cfg_zc = 1;
-static bool cfg_flush = 0;
 static int  cfg_nr_reqs = 8;
 static bool cfg_fixed_buf = 1;
 
@@ -146,13 +145,6 @@ static void do_tx(int domain, int type, int protocol)
 	if (ret)
 		error(1, ret, "io_uring: queue init");
 
-	if (cfg_zc) {
-		struct io_uring_notification_slot b[1] = {{.tag = ZC_TAG}};
-
-		ret = io_uring_register_notifications(&ring, 1, b);
-		if (ret)
-			error(1, ret, "io_uring: tx ctx registration");
-	}
 	if (cfg_fixed_files) {
 		ret = io_uring_register_files(&ring, &fd, 1);
 		if (ret < 0)
@@ -175,14 +167,8 @@ static void do_tx(int domain, int type, int protocol)
 	do {
 		struct io_uring_sqe *sqe;
 		struct io_uring_cqe *cqe;
-		unsigned zc_flags = 0;
 		unsigned buf_idx = 0;
-		unsigned slot_idx = 0;
-		unsigned msg_flags = 0;
-
-		compl_cqes += cfg_flush ? cfg_nr_reqs : 0;
-		if (cfg_flush)
-			zc_flags |= IORING_RECVSEND_NOTIF_FLUSH;
+		unsigned msg_flags = MSG_WAITALL;
 
 		for (i = 0; i < cfg_nr_reqs; i++) {
 			sqe = io_uring_get_sqe(&ring);
@@ -190,22 +176,22 @@ static void do_tx(int domain, int type, int protocol)
 			if (!cfg_zc)
 				io_uring_prep_send(sqe, fd, payload,
 						   cfg_payload_len, 0);
-			else if (cfg_fixed_buf)
-				io_uring_prep_sendzc_fixed(sqe, fd, payload,
-							   cfg_payload_len,
-							   msg_flags, slot_idx,
-							   zc_flags, buf_idx);
-			else
-				io_uring_prep_sendzc(sqe, fd, payload,
-						     cfg_payload_len, msg_flags,
-						     slot_idx, zc_flags);
-
+			else {
+				io_uring_prep_send_zc(sqe, fd, payload,
+						     cfg_payload_len, msg_flags, 0);
+				if (cfg_fixed_buf) {
+					sqe->ioprio |= IORING_RECVSEND_FIXED_BUF;
+					sqe->buf_index = buf_idx;
+				}
+			}
 			sqe->user_data = 1;
 			if (cfg_fixed_files) {
 				sqe->fd = 0;
 				sqe->flags |= IOSQE_FIXED_FILE;
 			}
 		}
+		if (cfg_zc)
+			compl_cqes += cfg_nr_reqs;
 
 		ret = io_uring_submit(&ring);
 		if (ret != cfg_nr_reqs)
@@ -214,27 +200,26 @@ static void do_tx(int domain, int type, int protocol)
 		for (i = 0; i < cfg_nr_reqs; i++) {
 			cqe = wait_cqe_fast(&ring);
 
-			if (cqe->user_data == ZC_TAG) {
+			if (cqe->flags & IORING_CQE_F_NOTIF) {
+				if (cqe->flags & IORING_CQE_F_MORE)
+					error(1, -EINVAL, "F_MORE notif");
 				compl_cqes--;
 				i--;
-			} else if (cqe->user_data != 1) {
-				error(1, cqe->user_data, "invalid user_data");
-			} else if (cqe->res > 0) {
+			} else if (cqe->res >= 0) {
+				if (!(cqe->flags & IORING_CQE_F_MORE) && cfg_zc)
+					error(1, -EINVAL, "no F_MORE");
 				packets++;
 				bytes += cqe->res;
 			} else if (cqe->res == -EAGAIN) {
-				/* request failed, don't flush */
-				if (cfg_flush)
+				if (cfg_zc)
 					compl_cqes--;
-			} else if (cqe->res == -ECONNREFUSED ||
-				   cqe->res == -ECONNRESET ||
-				   cqe->res == -EPIPE) {
-				fprintf(stderr, "Connection failure\n");
+			} else if (cqe->res == -ECONNREFUSED || cqe->res == -EPIPE ||
+				   cqe->res == -ECONNRESET) {
+				fprintf(stderr, "Connection failure");
 				goto out_fail;
 			} else {
 				error(1, cqe->res, "send failed");
 			}
-
 			io_uring_cqe_seen(&ring, cqe);
 		}
 	} while (gettimeofday_ms() < tstop);
@@ -255,12 +240,6 @@ out_fail:
 		io_uring_cqe_seen(&ring, cqe);
 		compl_cqes--;
 	}
-
-	if (cfg_zc) {
-		ret = io_uring_unregister_notifications(&ring);
-		if (ret)
-			error(1, ret, "io_uring: tx ctx unregistration");
-	}
 	io_uring_queue_exit(&ring);
 }
 
@@ -276,7 +255,7 @@ static void do_test(int domain, int type, int protocol)
 
 static void usage(const char *filepath)
 {
-	error(1, 0, "Usage: %s [-f] [-n<N>] [-z0] [-s<payload size>] "
+	error(1, 0, "Usage: %s [-n<N>] [-z<val>] [-s<payload size>] "
 		    "(-4|-6) [-t<time s>] -D<dst_ip> udp", filepath);
 }
 
@@ -294,7 +273,7 @@ static void parse_opts(int argc, char **argv)
 
 	cfg_payload_len = max_payload_len;
 
-	while ((c = getopt(argc, argv, "46D:p:s:t:n:fz:b:k")) != -1) {
+	while ((c = getopt(argc, argv, "46D:p:s:t:n:z:b:k")) != -1) {
 		switch (c) {
 		case '4':
 			if (cfg_family != PF_UNSPEC)
@@ -323,9 +302,6 @@ static void parse_opts(int argc, char **argv)
 		case 'n':
 			cfg_nr_reqs = strtoul(optarg, NULL, 0);
 			break;
-		case 'f':
-			cfg_flush = 1;
-			break;
 		case 'z':
 			cfg_zc = strtoul(optarg, NULL, 0);
 			break;
@@ -337,8 +313,6 @@ static void parse_opts(int argc, char **argv)
 
 	if (cfg_nr_reqs > MAX_SUBMIT_NR)
 		error(1, 0, "-n: submit batch nr exceeds max (%d)", MAX_SUBMIT_NR);
-	if (cfg_flush && !cfg_zc)
-		error(1, 0, "cfg_flush should be used with zc only");
 	if (cfg_payload_len > max_payload_len)
 		error(1, 0, "-s: payload exceeds max (%d)", max_payload_len);
 
-- 
2.37.2

