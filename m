Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12DA457E01D
	for <lists+io-uring@lfdr.de>; Fri, 22 Jul 2022 12:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbiGVKiP (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Jul 2022 06:38:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbiGVKiO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Jul 2022 06:38:14 -0400
Received: from mail-wm1-x334.google.com (mail-wm1-x334.google.com [IPv6:2a00:1450:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EDE4BA251
        for <io-uring@vger.kernel.org>; Fri, 22 Jul 2022 03:38:13 -0700 (PDT)
Received: by mail-wm1-x334.google.com with SMTP id b21-20020a05600c4e1500b003a32bc8612fso2248210wmq.3
        for <io-uring@vger.kernel.org>; Fri, 22 Jul 2022 03:38:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Rvf+Q4PeWgNXaBLrQizpS669Y3a54Lxw5uCTpfz0k5o=;
        b=nXqO/I8IVkPkqLqa/Y8rl+OGVZDi54L++7GfWpI/Y8zPQN6EDjabUfxdqDZvDU9lFp
         vx9hK2vMnTjM0SXnAT7O7N9zmLNSHnCY9Dr6FxyQ4jAQ3xZv2nSs4gcnRen1Vc1bMTXo
         Y9V1+CS2L08C2OsWH2OZVykqmqEHXw+uSsVe9OSFZLzI01VXW+XtdIYDWjlJ7URQUnCX
         Rp904Gc9CcaNqDQ2BiM0js/lC6BdLzoA3A1S1ZCqTOQnZP1g68sWDRzjWRWzICHCmwLe
         7D57HRXeo57ERuOUBJo4m4angYPxW8xk+n3ullF6viyCALiZYh0PT00SaLwpbvzBHSiH
         RDFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Rvf+Q4PeWgNXaBLrQizpS669Y3a54Lxw5uCTpfz0k5o=;
        b=WoG+CyLdF8xP4eWba5jAozWwoChiLBysDpAPuVSYIVPDSO3sglGkWfc9ALhpUCXekm
         +fn0A7rKiEpVYhgikfqGWlkb3e37nC+JxuGbXv4D0BiBFAiAL1oRFMGrtVINYxAvd5il
         f77NXo0112j2KRLheLpU2TARfz0rqKwBjKeGF1YiK02xM1a7Ohje5FWN6aM/lxGqQRfi
         IckEmmo/gxj5eiQX7B5FpDI22FONRZC8rBtpVG3Y3jYiVPOugFyCbCBOECRbimcHbQID
         h79mPYllES6Ifah26I4V7PF/yiYMTnproPMKMDoRnDWmLWV6Z3eH/41Q76+gEEQS9mI9
         g4Vg==
X-Gm-Message-State: AJIora8OnaJi3EhrLM2fII64y1yOHuNV/gWIJF0ze93dqFR3amBH763x
        vTyQ4zS2A8th3RT4FLIggEGsugcojitdeg==
X-Google-Smtp-Source: AGRyM1uwEmzi2MbVJ1SJ5S4YGI3MJqCl7dJo/tPTgNrZFFWJx859bmKrRqi/SkgSsBgeCPHX1x2/4w==
X-Received: by 2002:a05:600c:4e01:b0:3a3:342:5f55 with SMTP id b1-20020a05600c4e0100b003a303425f55mr2141654wmq.150.1658486291518;
        Fri, 22 Jul 2022 03:38:11 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:a3d])
        by smtp.gmail.com with ESMTPSA id p21-20020a05600c205500b003a2eacc8179sm4572832wmg.27.2022.07.22.03.38.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jul 2022 03:38:10 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing v2 1/2] examples: add a simple single-shot poll benchmark
Date:   Fri, 22 Jul 2022 11:37:05 +0100
Message-Id: <20a5afbb4f8aeb586b6ce04a623264f18c4fe467.1658484803.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <cover.1658484803.git.asml.silence@gmail.com>
References: <cover.1658484803.git.asml.silence@gmail.com>
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

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 examples/Makefile     |   3 +-
 examples/poll-bench.c | 101 ++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 103 insertions(+), 1 deletion(-)
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
index 0000000..e3c0052
--- /dev/null
+++ b/examples/poll-bench.c
@@ -0,0 +1,101 @@
+/* SPDX-License-Identifier: MIT */
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
+static unsigned long runtime_ms = 10000;
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
+	int ret, i, qd = 32;
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
2.37.0

