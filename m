Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3FD8354C56D
	for <lists+io-uring@lfdr.de>; Wed, 15 Jun 2022 12:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242154AbiFOKFs (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 15 Jun 2022 06:05:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238275AbiFOKFr (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 15 Jun 2022 06:05:47 -0400
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F7BB3BF8D
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 03:05:46 -0700 (PDT)
Received: by mail-wr1-x434.google.com with SMTP id o8so14673008wro.3
        for <io-uring@vger.kernel.org>; Wed, 15 Jun 2022 03:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=I/HN4gqc3ne5Wg/kirsMDgkzgQkt6tlEcJa4WcN66TU=;
        b=GOogrPWXBTvGOVo4ofqSM9Xu2rhQo1rZoJ04/IGZLrbXhxDhI8Z+VBUFuzxUCIaJkf
         k+HGr4q/A50Yks7xTprn8r8Y7YwJiMmn8BlxTV90c7ZyHQOcch8cpYk6hTbCfabIzVi6
         enkAfIIczWeH7xtSrX4o+pJ7GIlb8FwCMp2z4y1DwUDJJP/WSu+AZv7miO00ENS08Z//
         c9MjJWGEQKxxSoNyd3p3MY0rGMr1u9UpDerApi3tBW8aCgD6RoH7sUJbO3BlzKErTu02
         38gAraXQHbh9axUp//JwY08rckkJdo9x7tOrSI7tZNL1onSH29p8S+udIvF4YzKL1yIk
         O+gQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=I/HN4gqc3ne5Wg/kirsMDgkzgQkt6tlEcJa4WcN66TU=;
        b=0RnzX7cqy7RDGdWlbZe8yV7tiBzWcz4EEK4t8F0Ldc0WG71XWFOQ3eGrAPm49mCkUT
         9T+c/g6p0BccBEvZBE1B5ppaT4zCEUMRHAxtWFHSA59GkOSjCqyPUhhTlE7eqAtM5TyZ
         0PdHD67vZKJXvKv+XoBvof0stO/huetfL9kBzhIUWxSTEVSUvuHNYTPJECgtrNo19MdK
         xo3oHRGrkUX5t5/IFdp9Cr9wr7F2z5Ccv42fN1xzKd+1l+WHsUH44kQkyxtMvR1QVshm
         EL5IkSorPd6o2bOU4FYzr5YWUnzdivSTiKVMYQvXTIxyXXW7OEN8AffXDtQdD+Ftvxos
         dBaA==
X-Gm-Message-State: AJIora/xBI2PH8tMTj3by2auHTPptGMunf4dCrXcfX4qLPf3XQWAC7Sn
        GMmb9bkKjcK9Bgsk5gRHpevwR0ntH5n4Uw==
X-Google-Smtp-Source: AGRyM1sfM7x5LtF5LTPeyzqQ7ZkQKWSnAR3w7O2XF6Wt4/vHORGwtApCFVS77dNqXRA9GuHzFsHXwA==
X-Received: by 2002:adf:eac8:0:b0:21a:271e:3d97 with SMTP id o8-20020adfeac8000000b0021a271e3d97mr3468492wrn.450.1655287544672;
        Wed, 15 Jun 2022 03:05:44 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id w5-20020a5d6805000000b002119c1a03e4sm14074984wru.31.2022.06.15.03.05.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jun 2022 03:05:44 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 3/3] tests: test IORING_SETUP_SINGLE_ISSUER
Date:   Wed, 15 Jun 2022 11:05:12 +0100
Message-Id: <8d101e418097548d0d04de75c68996dfb6dabaa0.1655213733.git.asml.silence@gmail.com>
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
 test/Makefile        |   1 +
 test/single-issuer.c | 173 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 174 insertions(+)
 create mode 100644 test/single-issuer.c

diff --git a/test/Makefile b/test/Makefile
index ab031e0..0750996 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -169,6 +169,7 @@ test_srcs := \
 	wakeup-hang.c \
 	xattr.c \
 	skip-cqe.c \
+	single-issuer.c \
 	# EOL
 
 
diff --git a/test/single-issuer.c b/test/single-issuer.c
new file mode 100644
index 0000000..6d1b917
--- /dev/null
+++ b/test/single-issuer.c
@@ -0,0 +1,173 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Description: run various nop tests
+ *
+ */
+#include <errno.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <string.h>
+#include <fcntl.h>
+#include <error.h>
+#include <sys/types.h>
+#include <sys/wait.h>
+
+#include "liburing.h"
+#include "test.h"
+
+static pid_t pid;
+
+static pid_t fork_t(void)
+{
+	pid = fork();
+	if (pid == -1) {
+		fprintf(stderr, "fork failed\n");
+		exit(1);
+	}
+	return pid;
+}
+
+static int wait_child_t(void)
+{
+	int wstatus;
+
+	if (waitpid(pid, &wstatus, 0) == (pid_t)-1) {
+		perror("waitpid()");
+		exit(1);
+	}
+	if (!WIFEXITED(wstatus)) {
+		fprintf(stderr, "child failed %i\n", WEXITSTATUS(wstatus));
+		exit(1);
+	}
+
+	return WEXITSTATUS(wstatus);
+}
+
+static int try_submit(struct io_uring *ring)
+{
+	struct io_uring_cqe *cqe;
+	struct io_uring_sqe *sqe;
+	int ret;
+
+	sqe = io_uring_get_sqe(ring);
+	io_uring_prep_nop(sqe);
+	sqe->user_data = 42;
+
+	ret = io_uring_submit(ring);
+	if (ret < 0)
+		return ret;
+
+	if (ret != 1)
+		error(1, ret, "submit %i", ret);
+	ret = io_uring_wait_cqe(ring, &cqe);
+	if (ret)
+		error(1, ret, "wait fail %i", ret);
+
+	if (cqe->res || cqe->user_data != 42)
+		error(1, ret, "invalid cqe");
+
+	io_uring_cqe_seen(ring, cqe);
+	return 0;
+}
+
+int main(int argc, char *argv[])
+{
+	struct io_uring ring;
+	int ret;
+
+	if (argc > 1)
+		return 0;
+
+	ret = io_uring_queue_init(8, &ring, IORING_SETUP_SINGLE_ISSUER);
+	if (ret == -EINVAL) {
+		fprintf(stderr, "SETUP_SINGLE_ISSUER is not supported, skip\n");
+		return 0;
+	} else if (ret) {
+		error(1, ret, "ring init (1) %i", ret);
+	}
+
+	/* test that the creator iw allowed to submit */
+	ret = try_submit(&ring);
+	if (ret) {
+		fprintf(stderr, "the creater can't submit %i\n", ret);
+		return 1;
+	}
+
+	/* test that a second submitter doesn't succeed */
+	if (!fork_t()) {
+		ret = try_submit(&ring);
+		if (ret != -EEXIST) {
+			fprintf(stderr, "not owner child could submit %i\n", ret);
+			exit(1);
+		}
+		exit(0);
+	} else {
+		if (wait_child_t())
+			return 1;
+	}
+	io_uring_queue_exit(&ring);
+
+
+	/* test that the first submitter but not creator can submit */
+	ret = io_uring_queue_init(8, &ring, IORING_SETUP_SINGLE_ISSUER);
+	if (ret)
+		error(1, ret, "ring init (2) %i", ret);
+
+	if (!fork_t()) {
+		ret = try_submit(&ring);
+		if (ret) {
+			fprintf(stderr, "not owner child could submit %i\n", ret);
+			exit(1);
+		}
+		exit(0);
+	} else {
+		if (wait_child_t())
+			return 1;
+	}
+	io_uring_queue_exit(&ring);
+
+	/* test that anyone can submit to a SQPOLL|SINGLE_ISSUER ring */
+	ret = io_uring_queue_init(8, &ring, IORING_SETUP_SINGLE_ISSUER|IORING_SETUP_SQPOLL);
+	if (ret)
+		error(1, ret, "ring init (3) %i", ret);
+
+	ret = try_submit(&ring);
+	if (ret) {
+		fprintf(stderr, "SQPOLL submit failed (creator) %i\n", ret);
+		exit(1);
+	}
+
+	if (!fork_t()) {
+		ret = try_submit(&ring);
+		if (ret) {
+			fprintf(stderr, "SQPOLL submit failed (child) %i\n", ret);
+			exit(1);
+		}
+		exit(0);
+	} else {
+		if (wait_child_t())
+			return 1;
+	}
+	io_uring_queue_exit(&ring);
+
+	/* test that IORING_ENTER_REGISTERED_RING doesn't break anything */
+	ret = io_uring_queue_init(8, &ring, IORING_SETUP_SINGLE_ISSUER);
+	if (ret)
+		error(1, ret, "ring init (4) %i", ret);
+
+	if (!fork_t()) {
+		ret = try_submit(&ring);
+		if (ret) {
+			fprintf(stderr, "not owner child could submit %i\n", ret);
+			exit(1);
+		}
+		exit(0);
+	} else {
+		if (wait_child_t())
+			return 1;
+	}
+	io_uring_queue_exit(&ring);
+
+	return 0;
+}
-- 
2.36.1

