Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93E9F54B4AD
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 17:30:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356817AbiFNP2K (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 11:28:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356877AbiFNP2I (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 11:28:08 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE58BE0B0
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 08:28:06 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id x17so11776608wrg.6
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 08:28:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=akrZeuaOrBnQ/mu5huCLm/5pstUHaMxePvISJ2J0CQI=;
        b=BTM0uhYUP4jRytg9mCnVSqGVrNOP4nvWLA/FErE5tcVm/99gVY+Df4zr8ngzllazAG
         BlZnUsmN1awlIp0j0bpWGrnchDUPXEPn16pRklFDOWBCFRbN+RlpYHvtsO41m1S654wy
         xNXBw1AMnLxTMYA1o0QWeFvIC9ieSFcQtDfUZSA7n17Rm/oyuoL5ZWBfcG3H3CcIqyHw
         KKCqOLzyAJESTp1VprzLcN3nvYxikCgjenSU5925J3rfMDD/soF22H/7EfrAeLGWWEfr
         Z2p8xekM0mU9hJ61UQn1N5KZGlySgIC9COOlTKOQun7eqmL6NNSeDXf47N44ALT2NbkY
         gK+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=akrZeuaOrBnQ/mu5huCLm/5pstUHaMxePvISJ2J0CQI=;
        b=IB/GLj4pY8AiHeH4wYucb5JwUrwn7mtog6yx7xwcrRBz+vM4QlIy5otkm/KCzNM7Al
         mxHNfUPSu9xNnhOjQbXfflDXKqxPs4Kc1XE4QOrDdtzUeY7NJ6Uz74qSLVCUWC2NSf9S
         pgnRs6IHBHBqLM8saDlez5BzyYBT8Vl4HjYATrncAvxAfk3NzbExQU5BH6KrZjlg+JuP
         RL67HA4KoxMTghpQqVcSwZzCvJtaIT3u2AkIn9xFuBZR/VeIbJ6edRMqv9OfRjIOeg7+
         1T797TgrP5SzWx/QsaHnePT++eV8KfUIE1l90MY55MFTSHzZU7r6ifIDNWKOH2Ynryx9
         KFIg==
X-Gm-Message-State: AJIora+G81N5VWgStXqRUyzGaa4Yx0vphbIUL11KbPa1z1gkAKnBodd/
        jaPZU14sJjBzqbjIKiBhAERV9geI9ers5w==
X-Google-Smtp-Source: AGRyM1ugoQPGqbGGVBBMHLr4xnaHuc6LMU1EYpAzlWjwpBPQcR6uIDYX/0wxUYdIuJc1qqXPhYotXA==
X-Received: by 2002:a05:6000:1b03:b0:216:43b4:82f1 with SMTP id f3-20020a0560001b0300b0021643b482f1mr5424732wrz.232.1655220484776;
        Tue, 14 Jun 2022 08:28:04 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id v22-20020a7bcb56000000b0039482d95ab7sm13313529wmj.24.2022.06.14.08.28.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 08:28:04 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing v2 2/3] examples: add a simple single-shot poll benchmark
Date:   Tue, 14 Jun 2022 16:27:35 +0100
Message-Id: <4125f93afbaa8125190ebf5d0afad6aba008f542.1655219150.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <cover.1655219150.git.asml.silence@gmail.com>
References: <cover.1655219150.git.asml.silence@gmail.com>
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
index 0000000..66fd9e3
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
2.36.1

