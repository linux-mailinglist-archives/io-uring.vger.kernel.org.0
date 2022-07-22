Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6522257E01E
	for <lists+io-uring@lfdr.de>; Fri, 22 Jul 2022 12:38:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229811AbiGVKiQ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 22 Jul 2022 06:38:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234249AbiGVKiP (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 22 Jul 2022 06:38:15 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ACC6BA24E
        for <io-uring@vger.kernel.org>; Fri, 22 Jul 2022 03:38:14 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id d16so5910062wrv.10
        for <io-uring@vger.kernel.org>; Fri, 22 Jul 2022 03:38:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=uL+YcL1uM1wr+XEYcgTjSTJRq0qdYlELKmNXfoDNo1Y=;
        b=ZN/xMS4QEFVQgYPoiPXRA8JBHyh4gCD9ikCmFzx4HKwlf0gtiSt5yQ2MB7EYgeivhn
         ZqSJ+IWeCNQrBEn6nTDEMDnEw1WDsr2w5TxPnqSIRPGoFjIsuGkyzSzAOUezVmY+mH9r
         oRuI8oFzgiTbYlWj2c4l3rY3z79iHl9ph5iRepJxIetMVor7yEbwPHRe6jxf7ia9BbCz
         FZIRSwEYb9zrEfQQbY3No96hx+xjvQ6nAfs7YFjL1QlbN4HYv1Q1mzUsddUddeYOweSe
         8y/+aXun4pECNI3rfjv597F5aB2HH1c5Th68jUeWGrYAnmKEW+p8jIM17N1Spn1j1qwX
         Wnew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=uL+YcL1uM1wr+XEYcgTjSTJRq0qdYlELKmNXfoDNo1Y=;
        b=Hr7m3qjHGzZZLMi1ihnKydYie8Q1Ox0rO8hiVZ9BqmNLMvqVmac4ApYtU1lgAL4Phj
         718ikm3CAsqDXfu6ML++U4MbII1ez3wu9yG8WBec7gtrCPvACH1BqYCyhWRKBjFjOFgQ
         AnvxqLCyA1AfG4OhtjsrAvfoFfO6qhdgidhIouDwUVG6WpRGHB0lx1nXuo0CDUVGzUT5
         abkG7UyHa1xD/uHU0gDW8JQ0mHliwxafLYVH/8DmG0k1MDfzc5orU++phScabadXUOhh
         bHfIWwBN+/SaNaVNR+WOuKtgqoiQrF13NrI2DQKUtgmMV7xUSH+c5BdDq5L6dQdpM+bP
         yjlg==
X-Gm-Message-State: AJIora8e5QdJD7PwK6TajZqkWtvLWJPPf0tEBLGJTix0Ouhlh/iQC8pB
        qLnpM75l437THRsx9TVzkpNF+Ic4cgc0Lg==
X-Google-Smtp-Source: AGRyM1uZM7R+Qgst6uFpakuTZNT38jtOp7hJwc/bNuRu+FpIomKlXa705M+IO9WPJogAegKum6BuCA==
X-Received: by 2002:a5d:5a98:0:b0:21e:203f:2897 with SMTP id bp24-20020a5d5a98000000b0021e203f2897mr2005398wrb.707.1658486292507;
        Fri, 22 Jul 2022 03:38:12 -0700 (PDT)
Received: from 127.0.0.1localhost.com ([2620:10d:c092:600::2:a3d])
        by smtp.gmail.com with ESMTPSA id p21-20020a05600c205500b003a2eacc8179sm4572832wmg.27.2022.07.22.03.38.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jul 2022 03:38:12 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing v2 2/2] tests: test IORING_SETUP_SINGLE_ISSUER
Date:   Fri, 22 Jul 2022 11:37:06 +0100
Message-Id: <54af31b0b34fea289dc82ac228ec0cabed408cb6.1658484803.git.asml.silence@gmail.com>
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
 test/Makefile        |   1 +
 test/single-issuer.c | 153 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 154 insertions(+)
 create mode 100644 test/single-issuer.c

diff --git a/test/Makefile b/test/Makefile
index e958a35..8945368 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -174,6 +174,7 @@ test_srcs := \
 	wakeup-hang.c \
 	xattr.c \
 	skip-cqe.c \
+	single-issuer.c \
 	# EOL
 
 all_targets :=
diff --git a/test/single-issuer.c b/test/single-issuer.c
new file mode 100644
index 0000000..3bbc6c4
--- /dev/null
+++ b/test/single-issuer.c
@@ -0,0 +1,153 @@
+/* SPDX-License-Identifier: MIT */
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
+#include "helpers.h"
+
+static pid_t pid;
+
+static pid_t fork_t(void)
+{
+	pid = fork();
+	if (pid == -1) {
+		fprintf(stderr, "fork failed\n");
+		exit(T_EXIT_FAIL);
+	}
+	return pid;
+}
+
+static void wait_child_t(void)
+{
+	int wstatus;
+
+	if (waitpid(pid, &wstatus, 0) == (pid_t)-1) {
+		perror("waitpid()");
+		exit(T_EXIT_FAIL);
+	}
+	if (!WIFEXITED(wstatus)) {
+		fprintf(stderr, "child failed %i\n", WEXITSTATUS(wstatus));
+		exit(T_EXIT_FAIL);
+	}
+	if (WEXITSTATUS(wstatus))
+		exit(T_EXIT_FAIL);
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
+		return T_EXIT_SKIP;
+
+	ret = io_uring_queue_init(8, &ring, IORING_SETUP_SINGLE_ISSUER);
+	if (ret == -EINVAL) {
+		fprintf(stderr, "SETUP_SINGLE_ISSUER is not supported, skip\n");
+		return T_EXIT_SKIP;
+	} else if (ret) {
+		fprintf(stderr, "io_uring_queue_init() failed %i\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	/* test that the creator iw allowed to submit */
+	ret = try_submit(&ring);
+	if (ret) {
+		fprintf(stderr, "the creater can't submit %i\n", ret);
+		return T_EXIT_FAIL;
+	}
+
+	/* test that a second submitter doesn't succeed */
+	if (!fork_t()) {
+		ret = try_submit(&ring);
+		if (ret != -EEXIST)
+			fprintf(stderr, "not owner child could submit %i\n", ret);
+		return ret != -EEXIST;
+	}
+	wait_child_t();
+	io_uring_queue_exit(&ring);
+
+	/* test that the first submitter but not creator can submit */
+	ret = io_uring_queue_init(8, &ring, IORING_SETUP_SINGLE_ISSUER);
+	if (ret)
+		error(1, ret, "ring init (2) %i", ret);
+
+	if (!fork_t()) {
+		ret = try_submit(&ring);
+		if (ret)
+			fprintf(stderr, "not owner child could submit %i\n", ret);
+		return !!ret;
+	}
+	wait_child_t();
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
+		return T_EXIT_FAIL;
+	}
+
+	if (!fork_t()) {
+		ret = try_submit(&ring);
+		if (ret)
+			fprintf(stderr, "SQPOLL submit failed (child) %i\n", ret);
+		return !!ret;
+	}
+	wait_child_t();
+	io_uring_queue_exit(&ring);
+
+	/* test that IORING_ENTER_REGISTERED_RING doesn't break anything */
+	ret = io_uring_queue_init(8, &ring, IORING_SETUP_SINGLE_ISSUER);
+	if (ret)
+		error(1, ret, "ring init (4) %i", ret);
+
+	if (!fork_t()) {
+		ret = try_submit(&ring);
+		if (ret)
+			fprintf(stderr, "not owner child could submit %i\n", ret);
+		return !!ret;
+	}
+	wait_child_t();
+	io_uring_queue_exit(&ring);
+	return T_EXIT_PASS;
+}
-- 
2.37.0

