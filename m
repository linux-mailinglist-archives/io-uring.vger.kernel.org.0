Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3A4D954B354
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 16:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236030AbiFNOhV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 10:37:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238290AbiFNOhU (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 10:37:20 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08CF63BFA3
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 07:37:19 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id a15so11585838wrh.2
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 07:37:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Ku1tarHdwofw/iVUd3UyBPtuw43QQo8nV6tDR7LPbyE=;
        b=QKBPRWiwD/39llEnZbjzpe1D7TR3Ok14xD71H39dP26OqyeDNouAcoBpT3zcRPlX8k
         j2Bel7m138sL9fjNXIydnucNF4q7V9Of9lSPXk21CeOU1isHYgoZqJ9bSpuDx5AgGftD
         PgmAbf69d4AIiXGBybirYbHESU3c0C+YVStTsnyC0PoMZ69UtVKvB+l2U3AWqnEIl/0J
         JuowXcR9xebCxcelApberSHwEi3ZSVY3keE2qadXn+sEa/WLOYvbkbFut9z/6SmtVJ6d
         NsxXvRx4OanBUuHCYy99cLa5va7kiwrHD037EgDEkFvAIqiQHW2eofFCTz3nRkSwg0jl
         CTvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Ku1tarHdwofw/iVUd3UyBPtuw43QQo8nV6tDR7LPbyE=;
        b=QhoHXUm8Yjyvda+T0z8vzwTPjRdRsomhzEmEct+lbbnpLUrFBr3eUTima2AtBLdKtF
         YvZBY2oWodh7m3cIv2ogAd29qSct1AcyL+YjMqW2I6BbaAJbV1kqJHfhdv0pdJ8QknL3
         cQKdJ21U7EJvmKzHeMB5evsecDpItbCAB13UkxD5C2uQafnr78mwZtTAqz/rjkHiLp+q
         8V8AcWOAL38Py6SZWv6WI4jOV+dm4lbPbN3lTad1qVFSJRUxEYnrGLSCtd2o73TfUYpQ
         bWyXCn2nIH5lWHHJjtk1FfL+YzGeE6qYh3gq6HqEbm0p+4sKXmefvdXz4emLdj7tsgkt
         GZcA==
X-Gm-Message-State: AJIora9bIqbyWVVfFBrFH8T8sNjxu0y1jlNrYwcGhrQrYepnzUIgG94z
        XUonKqDZNWK1eWvPgcGKwHPaVzweRjxf9w==
X-Google-Smtp-Source: AGRyM1uykGDpEKU93TEnbm616luX4IgJZfAv58OQ7QWsf2OtJF0UQfihswMOV5GKOhRRnPknqNTWVg==
X-Received: by 2002:a5d:4389:0:b0:213:1d58:1666 with SMTP id i9-20020a5d4389000000b002131d581666mr5152293wrq.294.1655217437249;
        Tue, 14 Jun 2022 07:37:17 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id f14-20020a5d58ee000000b0020fc6590a12sm12169254wrd.41.2022.06.14.07.37.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 07:37:16 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 2/3] examples: add a simple single-shot poll benchmark
Date:   Tue, 14 Jun 2022 15:36:32 +0100
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

