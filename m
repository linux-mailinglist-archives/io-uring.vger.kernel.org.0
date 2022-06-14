Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD9BC54B4A7
	for <lists+io-uring@lfdr.de>; Tue, 14 Jun 2022 17:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238119AbiFNP2L (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Jun 2022 11:28:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343886AbiFNP2I (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Jun 2022 11:28:08 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DE065F7D
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 08:28:07 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id w17so4272084wrg.7
        for <io-uring@vger.kernel.org>; Tue, 14 Jun 2022 08:28:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=d7ne3EAgdkQwIczj3Nj+DYkC6JJy/tsTnIBTH4t39sI=;
        b=UkV39mamzx319GRPMEjAh65kdMk2k14wGtmQNlrSBNx2gblEx6M/gbFxrVb093FM+7
         CwZfKNr6/I/Qm3HYyxwl1vfCUbYRQlDD8PEaoz1uUY2ydsLtlhMuzEsRll1WxDwwDWlH
         u5y5II1xTtEFooO52aJVrXh0+E9kTOv5Oq0Xg+KgLEx0fmq7wzthAHxn060Z/5P0fC/Z
         q9gj5ASgW8B+ISkSLb8DyVl5wQQ4bcoPSIMVWEjS4FTUrsWufy5hb5kVqSQBwUADqSRr
         q8RIcUR6btfJmRTQblpSb5l+maQBzTVW6ZAWlcjakmf/dKskUFxshSN/3MP4zB1oL+8D
         /OJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=d7ne3EAgdkQwIczj3Nj+DYkC6JJy/tsTnIBTH4t39sI=;
        b=D/f3EbPWkP/Pcg+5X5AU1OrfJdu6np1fJpVsTWnDOXQCYEMMyhejlFYUBWgN/pCcNr
         fTHSCD+Zc6+N0kIjvnfWF+BUSPAZ/pGmWCaLNieohK2dNwn5PtQX3GGjCETPGttsOmCj
         x1u9fQf5UHFdjAg8g0AWKXq0V3NemUmrVV+MH5zc8yqicHAUwPz8zRFupoiRghCBebBq
         BEuCz8rWb0kPN4ivmAegbUzoCAxvOEY8XQ+7vLJtWftdinxjqf1kYlb7/EoWNeMOIzpS
         Y4hv4t7b4yPilxdm5VPgGxUv0N/35bdgX+QS+Xdl9kRTRpyGtHS8F403QvVs/TC47w+L
         /SkQ==
X-Gm-Message-State: AJIora/7u5MOtVnGHfE7oSQK1S+sG30qKf8muakyXRKp00rruhML8Mhk
        zSnOIPRIzs5GyS3YwTpld0HrQEsZI9fo+w==
X-Google-Smtp-Source: AGRyM1uoeiK6ceqvrynqYGBWB7SMJf3EJgZRis3La/Bo/3DUZaggBLV7aiA2CWBqJsxoCQ9LWXx9dQ==
X-Received: by 2002:a5d:504d:0:b0:210:24fd:add1 with SMTP id h13-20020a5d504d000000b0021024fdadd1mr5410113wrt.630.1655220485929;
        Tue, 14 Jun 2022 08:28:05 -0700 (PDT)
Received: from 127.0.0.1localhost (188.28.125.106.threembb.co.uk. [188.28.125.106])
        by smtp.gmail.com with ESMTPSA id v22-20020a7bcb56000000b0039482d95ab7sm13313529wmj.24.2022.06.14.08.28.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 08:28:05 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH liburing v2 3/3] tests: test IORING_SETUP_SINGLE_ISSUER
Date:   Tue, 14 Jun 2022 16:27:36 +0100
Message-Id: <dee062f4d2f7c811b9e22f599ae30cf72adb02a8.1655219150.git.asml.silence@gmail.com>
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
 test/Makefile        |   1 +
 test/single-issuer.c | 169 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 170 insertions(+)
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
index 0000000..a688626
--- /dev/null
+++ b/test/single-issuer.c
@@ -0,0 +1,169 @@
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

