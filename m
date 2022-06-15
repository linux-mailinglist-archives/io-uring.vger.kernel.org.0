Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4332C54C56C
	for <lists+io-uring@lfdr.de>; Wed, 15 Jun 2022 12:05:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239292AbiFOKFr (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jun 2022 06:05:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238275AbiFOKFq (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jun 2022 06:05:46 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4036A3BF8D
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 03:05:45 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id q15so14623703wrc.11
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 03:05:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ku1tarHdwofw/iVUd3UyBPtuw43QQo8nV6tDR7LPbyE=;
        b=APhTGfE16L9Bi0q3rAjpUslJMB23ydchSnY8/li+G6gEsIZpC6slvZppmxEzrGlNHI
         in6ne31sjE7QnrOQv02uiU0aWyJ5bTPNqDosoGpD0NP42/JAP7vLBUHDAPPB/H1MnrYH
         81e98dSRX4SEjXh0aW5o+A3R749V4F1IJj4QqOUe4lQDS3eAI4pyVVbvbQXJyhZqQdYF
         OH2KyFNoEStz3EKc8v9nYA+WpbTjMa1Ja0Q4Ni3KF87QAMDMzoXc8pUSDL8xn0g9n+me
         OAQbbZhxPt/qL6FotOl0voHArskkmrgw5KkI8ZlEcqnnPTc9NUcFEKLH5VwBbF2kGYV9
         YIsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ku1tarHdwofw/iVUd3UyBPtuw43QQo8nV6tDR7LPbyE=;
        b=ZD6pW50zOYV/XylB0LyxhFwsAGTBi3sjCNMcHpJ2M7CeweMF0lDLC00XW/+KBbDNMz
         9nJVTF8iz0PeJMyLXMDq682+L+ZfAkI6nHSZ/3mnKQZO0jtUQ3Twzq4TwQtyWNfCPGFB
         +OIx3RVweV5CfAkFkhXBaIdRwG3owHJpcHR019mECkCXxoJQG0++gyxWyEC2tbtw+OtF
         58JmCKZSL6tWW8/D2KjWpfdRmyrxKhv+SQaxp9MO6FwvzyhY8KK3fOfV8wbM9vNmisid
         F009AmcCAEth2xlw+y7cCIBeIEMQ17bYEBct8TGhEpqDNd7p8ajD1bH47pb65/8zZyav
         B8ew==
X-Gm-Message-State: AJIora9N3SOaS4WUJtyxWCf8JYQvf926N162JCM5k48jwZfGW9xGl9hG
        qn8guUOMn1PYLxD/YkEwIvYYByxuynLAoQ==
X-Google-Smtp-Source: AGRyM1stkTxeHYf8x6Jo0Q3USd4fBmLxKM9Q7Qpea9+IwuXtQNXvcJ4kNBAhU6MU9lQ97x+p21LUfQ==
X-Received: by 2002:a05:6000:226:b0:217:851a:4300 with SMTP id l6-20020a056000022600b00217851a4300mr9310048wrz.389.1655287543302;
        Wed, 15 Jun 2022 03:05:43 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id w5-20020a5d6805000000b002119c1a03e4sm14074984wru.31.2022.06.15.03.05.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 03:05:42 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 2/3] examples: add a simple single-shot poll benchmark
Date:   Wed, 15 Jun 2022 11:05:11 +0100
Message-Id: <c73aebd699e851a36a8a85e263bedc56aa57e505.1655213733.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655213733.git.asml.silence@gmail.com>
References: <cover.1655213733.git.asml.silence@gmail.com>
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
 examples/Makefile     |   3 +-
 examples/poll-bench.c | 108 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 110 insertions(+), 1 deletion(-)
 create mode 100644 examples/poll-bench.c

diff --git a/examples/Makefile b/examples/Makefile
index 95a45f9..8e7067f 100644
--- a/examples/Makefile
+++ b/examples/Makefile
@@ -13,7 +13,8 @@ endif
 example_srcs := \
 	io_uring-cp.c \
 	io_uring-test.c \
-	link-cp.c
+	link-cp.c \
+	poll-bench.c
 
 all_targets :=
 
diff --git a/examples/poll-bench.c b/examples/poll-bench.c
new file mode 100644
index 0000000..72ba8ef
--- /dev/null
+++ b/examples/poll-bench.c
@@ -0,0 +1,108 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Description: test io_uring poll handling
+ *
+ */
+#include <errno.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <string.h>
+#include <signal.h>
+#include <poll.h>
+#include <sys/time.h>
+#include <sys/wait.h>
+
+#include "liburing.h"
+
+static char buf[4096];
+static unsigned long runtime_ms = 30000;
+
+static unsigned long gettimeofday_ms(void)
+{
+	struct timeval tv;
+
+	gettimeofday(&tv, NULL);
+	return (tv.tv_sec * 1000) + (tv.tv_usec / 1000);
+}
+
+int main(void)
+{
+	unsigned long tstop;
+	unsigned long nr_reqs = 0;
+	struct io_uring_cqe *cqe;
+	struct io_uring_sqe *sqe;
+	struct io_uring ring;
+	int pipe1[2];
+	int ret, i, qd = 128;
+
+	if (argc > 1)
+		return 0;
+
+	if (pipe(pipe1) != 0) {
+		perror("pipe");
+		return 1;
+	}
+
+	ret = io_uring_queue_init(1024, &ring, IORING_SETUP_SINGLE_ISSUER);
+	if (ret == -EINVAL) {
+		fprintf(stderr, "can't single\n");
+		ret = io_uring_queue_init(1024, &ring, 0);
+	}
+	if (ret) {
+		fprintf(stderr, "child: ring setup failed: %d\n", ret);
+		return 1;
+	}
+
+	ret = io_uring_register_files(&ring, pipe1, 2);
+	if (ret < 0) {
+		fprintf(stderr, "io_uring_register_files failed\n");
+		return 1;
+	}
+
+	ret = io_uring_register_ring_fd(&ring);
+	if (ret < 0) {
+		fprintf(stderr, "io_uring_register_ring_fd failed\n");
+		return 1;
+	}
+
+	tstop = gettimeofday_ms() + runtime_ms;
+	do {
+		for (i = 0; i < qd; i++) {
+			sqe = io_uring_get_sqe(&ring);
+			io_uring_prep_poll_add(sqe, 0, POLLIN);
+			sqe->flags |= IOSQE_FIXED_FILE;
+			sqe->user_data = 1;
+		}
+
+		ret = io_uring_submit(&ring);
+		if (ret != qd) {
+			fprintf(stderr, "child: sqe submit failed: %d\n", ret);
+			return 1;
+		}
+
+		ret = write(pipe1[1], buf, 1);
+		if (ret != 1) {
+			fprintf(stderr, "write failed %i\n", errno);
+			return 1;
+		}
+		ret = read(pipe1[0], buf, 1);
+		if (ret != 1) {
+			fprintf(stderr, "read failed %i\n", errno);
+			return 1;
+		}
+
+		for (i = 0; i < qd; i++) {
+			ret = io_uring_wait_cqe(&ring, &cqe);
+			if (ret < 0) {
+				fprintf(stderr, "child: wait completion %d\n", ret);
+				break;
+			}
+			io_uring_cqe_seen(&ring, cqe);
+			nr_reqs++;
+		}
+	} while (gettimeofday_ms() < tstop);
+
+	fprintf(stderr, "requests/s: %lu\n", nr_reqs * 1000UL / runtime_ms);
+	return 0;
+}
-- 
2.36.1

