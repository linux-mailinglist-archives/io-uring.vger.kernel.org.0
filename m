Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B222254B35A
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 16:37:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236679AbiFNOhW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 10:37:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231584AbiFNOhV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 10:37:21 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AE5712625
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 07:37:20 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id q15so11535329wrc.11
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 07:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=I/HN4gqc3ne5Wg/kirsMDgkzgQkt6tlEcJa4WcN66TU=;
        b=YDpvKfzk3DjJgnzscN6UpNvzkLSZRstZ9+qvgXxjb5W0+zcdYbb3axZUTngi6JKL0U
         L9nuD0mZqWwf6hFUyely+WT6dM/bi23Cn3Wcp/pl+tmPbH3s4tngxJuibmSi6NwGz2D9
         qSDc1l3c3aTa09EuP515DF5UiUgTAHDk/3ylFQiZQN+6VbcxkUwlBIyhOlKn+cMIIVvC
         Liw03ia6Sj71xjgu9562/XGyaCZ2KjU9LbGV3JfHofys7DRJ6vSJIIOMcHp/3kretgWp
         0dzNj9MAkPbuY+o/4/D6NDCoYMPzjLnm/kVvY5F32DxDOl2++ts5gg35wNIGKy5/Au09
         zlFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=I/HN4gqc3ne5Wg/kirsMDgkzgQkt6tlEcJa4WcN66TU=;
        b=zYCbRFfQzkSKtBEsM9xNe5sTH02AskNbpare5yHcALAmGkfhunwMS30Wb+DjRaAtYk
         fTCPthOy7+xstC/bJZZZfX31qXT+XeJpHhRlVisxRoHvgJzAHEzBZDBEHT/WY6ljLk/t
         qwYHu9A1NKYUK0F3QjxuKF3v7C4Y9akNIRLa2qRP5Jh/fY5HIB9FYxFSqaKPUpnrWFjf
         FllR2WU0yNEQNHYXyN42JQN+MfUxE/JsKSMHeJDbTWSiGadFDGmNlTTmIaZU8Y06XNyf
         efnhoZFo4/To5o1TTFfNqtbylWX/M6rWth4grOyWTjEij5oLSEKYcXjSmqTLUB26O8kT
         fpjA==
X-Gm-Message-State: AJIora99G9TmgCF4FEteTo9BUXWRdi6sgA8DVBoy18sOGCJ/KoHAgQQD
        qo9fAZDsybZCwWASq3TzwpVK5XAkbhcfmA==
X-Google-Smtp-Source: AGRyM1uobIULCYvD8qZ4jXGwTV7JxAsI3m5WVWKIgmOJ8QVXdHVxmIC0s4S/nXzIrlfzZOPTFOZOGA==
X-Received: by 2002:a05:6000:1acf:b0:218:5a30:9067 with SMTP id i15-20020a0560001acf00b002185a309067mr5372967wry.48.1655217438527;
        Tue, 14 Jun 2022 07:37:18 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id f14-20020a5d58ee000000b0020fc6590a12sm12169254wrd.41.2022.06.14.07.37.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 07:37:18 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing 3/3] tests: test IORING_SETUP_SINGLE_ISSUER
Date:   Tue, 14 Jun 2022 15:36:33 +0100
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

