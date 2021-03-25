Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3655A34998B
	for <lists+io-uring@lfdr.de>; Thu, 25 Mar 2021 19:33:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230104AbhCYScm (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 25 Mar 2021 14:32:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbhCYScf (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 25 Mar 2021 14:32:35 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56B9AC06174A
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 11:32:35 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id c8so3267268wrq.11
        for <io-uring@vger.kernel.org>; Thu, 25 Mar 2021 11:32:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pNgKQpSK4bF6Z1YA+z84szyBfUYAkJcRRcc84b0cgH4=;
        b=skkJtoalQsfvTdTj1wyvIHpq3cRk8DQOpYJS5CNFOaC1sFvbh4EYEL3DYWsYAhn/PB
         oHL+Fx4sk7iL7WuxXTdqwMzBbMnWim+0mEt7tj21jMw7MrdBw7+MFUhYebalorwq8QVY
         OMYGy/D2pw2fJEGSKkyIWZPEdvrEj9Vu5NLVAgIZ1WMmg7fediDmOmDVOb414SIChk8K
         ljBRLZJvs/v1CG2Dawq/HDZ3w7yReL6tH56JIppF9UOF4zsYItJoT9WUcDBtHRmVQIng
         sGAKOfzbV3Fe/C8q0S9e1roDmQhIWhTK4WE6zaiYppzadCtRjYI3fPC7ORBawZCux7J+
         a8Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pNgKQpSK4bF6Z1YA+z84szyBfUYAkJcRRcc84b0cgH4=;
        b=LGo6JJcpvs045BL+U0+De37GXVFAj2Fs7P5cp+k3fMiFB4UJ9YSwLkq9ZhlGx7KJCO
         nOYQEhg2Ld+w1/mmOwhGH2HxLixp3H/SKjInpVc9zWpCQJqX3RslGJ7DeFiHpkOW1ExU
         ZX8SH19s4r2z/5T6Pw10gmvQOop2K0xsSaLfM9rdgeTgflYv0XX9+KOG3Xr56DJ8Mbvp
         PIjmZJVU5Aqy5iD8GIHPIPqZz2e3sBzBgxAMMCRrVwpcYHoTZzEInHqTn3/MT2iPOcJt
         sZDUwQPf4Ma09g0D0wjaN+GS73fLw3fIJD+1NHb7cAAkX+yruKO6T3SZdIsRUNYaauY7
         VFCw==
X-Gm-Message-State: AOAM531GI5qBcTdHww8nTbPutyn8+mdnyc638dNG1qwoZTeSQYpJHjvV
        GTu6Mknrt6HAoDIxOtvz59sqdXCeA+FN/w==
X-Google-Smtp-Source: ABdhPJwKAPU1i2cRdcU6DnOGsPinv+bI1yj0DnFklCzjvbYKZQw6oXCGQVkWuOJI+t+S+veIGPzOMA==
X-Received: by 2002:adf:e411:: with SMTP id g17mr10473738wrm.225.1616697154018;
        Thu, 25 Mar 2021 11:32:34 -0700 (PDT)
Received: from localhost.localdomain ([148.252.129.162])
        by smtp.gmail.com with ESMTPSA id y8sm7338923wmi.46.2021.03.25.11.32.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Mar 2021 11:32:33 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 1/1] tests: more cancellation tests
Date:   Thu, 25 Mar 2021 18:28:24 +0000
Message-Id: <914c86e2d94aafe7e623c07f4e39c7eba0c04228.1616696841.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add a test checking we don't cancel extra on exit() cancellation.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/io-cancel.c | 79 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 79 insertions(+)

diff --git a/test/io-cancel.c b/test/io-cancel.c
index 9b52c7b..c08b7e5 100644
--- a/test/io-cancel.c
+++ b/test/io-cancel.c
@@ -11,6 +11,7 @@
 #include <sys/types.h>
 #include <sys/time.h>
 #include <sys/wait.h>
+#include <sys/poll.h>
 
 #include "helpers.h"
 #include "liburing.h"
@@ -365,6 +366,79 @@ static int test_cancel_req_across_fork(void)
 	return 0;
 }
 
+static int test_cancel_inflight_exit(void)
+{
+	struct __kernel_timespec ts = { .tv_sec = 1, .tv_nsec = 0, };
+	struct io_uring ring;
+	struct io_uring_cqe *cqe;
+	struct io_uring_sqe *sqe;
+	int ret, i;
+	pid_t p;
+
+	ret = io_uring_queue_init(8, &ring, 0);
+	if (ret) {
+		fprintf(stderr, "ring create failed: %d\n", ret);
+		return 1;
+	}
+	p = fork();
+	if (p == -1) {
+		fprintf(stderr, "fork() failed\n");
+		return 1;
+	}
+
+	if (p == 0) {
+		sqe = io_uring_get_sqe(&ring);
+		io_uring_prep_poll_add(sqe, ring.ring_fd, POLLIN);
+		sqe->user_data = 1;
+		sqe->flags |= IOSQE_IO_LINK;
+
+		sqe = io_uring_get_sqe(&ring);
+		io_uring_prep_timeout(sqe, &ts, 0, 0);
+		sqe->user_data = 2;
+
+		sqe = io_uring_get_sqe(&ring);
+		io_uring_prep_timeout(sqe, &ts, 0, 0);
+		sqe->user_data = 3;
+
+		ret = io_uring_submit(&ring);
+		if (ret != 3) {
+			fprintf(stderr, "io_uring_submit() failed %s, ret %i\n", __FUNCTION__, ret);
+			exit(1);
+		}
+		exit(0);
+	} else {
+		int wstatus;
+
+		if (waitpid(p, &wstatus, 0) == (pid_t)-1) {
+			perror("waitpid()");
+			return 1;
+		}
+		if (!WIFEXITED(wstatus) || WEXITSTATUS(wstatus)) {
+			fprintf(stderr, "child failed %i\n", WEXITSTATUS(wstatus));
+			return 1;
+		}
+	}
+
+	for (i = 0; i < 3; ++i) {
+		ret = io_uring_wait_cqe(&ring, &cqe);
+		if (ret) {
+			fprintf(stderr, "wait_cqe=%d\n", ret);
+			return 1;
+		}
+		if ((cqe->user_data == 1 && cqe->res != -ECANCELED) ||
+		    (cqe->user_data == 2 && cqe->res != -ECANCELED) ||
+		    (cqe->user_data == 3 && cqe->res != -ETIME)) {
+			fprintf(stderr, "%i %i\n", (int)cqe->user_data, cqe->res);
+			return 1;
+		}
+		io_uring_cqe_seen(&ring, cqe);
+	}
+
+	io_uring_queue_exit(&ring);
+	return 0;
+}
+
+
 int main(int argc, char *argv[])
 {
 	int i, ret;
@@ -382,6 +456,11 @@ int main(int argc, char *argv[])
 		return 1;
 	}
 
+	if (test_cancel_inflight_exit()) {
+		fprintf(stderr, "test_cancel_inflight_exit() failed\n");
+		return 1;
+	}
+
 	t_create_file(".basic-rw", FILE_SIZE);
 
 	vecs = t_create_buffers(BUFFERS, BS);
-- 
2.24.0

