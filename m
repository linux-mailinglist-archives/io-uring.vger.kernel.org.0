Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2937C3FC7E3
	for <lists+io-uring@lfdr.de>; Tue, 31 Aug 2021 15:09:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233702AbhHaNKT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 Aug 2021 09:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232604AbhHaNKR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 Aug 2021 09:10:17 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ABEDC061764
        for <io-uring@vger.kernel.org>; Tue, 31 Aug 2021 06:09:22 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id i6so27676427wrv.2
        for <io-uring@vger.kernel.org>; Tue, 31 Aug 2021 06:09:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TtnS7y+aIOuVtGCDjJP5gLVDxMeAQixUAUpBu+mjmwE=;
        b=ZuLTqQwGrJxtzJCfdXIlSGWiS0XtiQ69zcnVT3uILkBQ16cS8KfgXBrNozykWE7YKS
         S/O36iROMQsi5rxEkODW8CTenC8ZlF1DAPQo9qaAXT4+T8V1nCkDWTAclqDl7716eYqQ
         VDiodq8jCiK8hnRh1We7FQetZmB7tTRWf0p8JEWO9U/Z/u4wvBLpAKECfdXQ1KL6LSjs
         u9zDvxxx/S7t8QKH6CkOtym0Kn1KimUsH435ubSFnzEeNB9S4v9dUntV/qfOifXLpkHz
         OPvWaLVTomKftQ0uRYumI0wiPZrlQe0pXWFtrFa6Y/JYQjmwSsV1cmWLSWchnWskv30x
         tkXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TtnS7y+aIOuVtGCDjJP5gLVDxMeAQixUAUpBu+mjmwE=;
        b=Cj0hD1M8fJ/PSqRjVQ02NbGl+vShXimIC+4DgnCTxd1lu9CuPlQYZU0Kui4v9besQq
         Jk6favWpHMcU7Mvrdmp2WPfNnsYOHeK8Mn9gGzDo7+XfIN66IhY4HE9E0Jx5geAOS0e8
         iYxXZJUxokFJS30Ymi9vMrVX+t+DsOfexPxlj6FAfpSxhtFVPrkQPaP0mZuYG2XU6cYt
         XeADhGQaFfnCEjTO1Msc8De9lIko1wl1nQ1eWcQ/XNhBFnFwK0f1E00+jJYZbkS3kiz/
         10my8CbNjzk2onK4VRLzsqiKlkFtwErT17DK0Ix2WsBb5iBd0nSVbBGcS8uRI9qrFOWh
         ky1Q==
X-Gm-Message-State: AOAM53198r2dQ3/ZTU58EyGXGEJGjRkcHTE9wu2WSTjJFCeKrnwAhtIQ
        jyVzelUtQZhp7R+cKrUNQvij0eIVICA=
X-Google-Smtp-Source: ABdhPJwj0IhdlXrjWYqGcMShbAsW50G5BfMOgXhXQwVJihQbTaiBIbn4PEsQBNFEeVVgAKpO0jb4aw==
X-Received: by 2002:adf:c405:: with SMTP id v5mr31222613wrf.183.1630415360573;
        Tue, 31 Aug 2021 06:09:20 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.138])
        by smtp.gmail.com with ESMTPSA id b4sm18006459wrp.33.2021.08.31.06.09.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 06:09:20 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing] tests: test under submit link fails
Date:   Tue, 31 Aug 2021 14:08:42 +0100
Message-Id: <6b4e331d025933b8f7725aa09b77f164f99df6e0.1630415314.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add a whole bunch of tests for when linked requests fail early during
submission.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 .gitignore              |   1 +
 test/Makefile           |   2 +
 test/submit-link-fail.c | 150 ++++++++++++++++++++++++++++++++++++++++
 3 files changed, 153 insertions(+)
 create mode 100644 test/submit-link-fail.c

diff --git a/.gitignore b/.gitignore
index 3d67ef9..df0f740 100644
--- a/.gitignore
+++ b/.gitignore
@@ -128,6 +128,7 @@
 /test/rw_merge_test
 /test/sqpoll-cancel-hang
 /test/testfile
+/test/submit-link-fail
 /test/*.dmesg
 
 config-host.h
diff --git a/test/Makefile b/test/Makefile
index d392b95..775e3bb 100644
--- a/test/Makefile
+++ b/test/Makefile
@@ -123,6 +123,7 @@ test_targets += \
 	sq-space_left \
 	stdout \
 	submit-reuse \
+	submit-link-fail \
 	symlink \
 	teardowns \
 	thread-exit \
@@ -264,6 +265,7 @@ test_srcs := \
 	statx.c \
 	stdout.c \
 	submit-reuse.c \
+	submit-link-fail.c \
 	symlink.c \
 	teardowns.c \
 	thread-exit.c \
diff --git a/test/submit-link-fail.c b/test/submit-link-fail.c
new file mode 100644
index 0000000..8a51222
--- /dev/null
+++ b/test/submit-link-fail.c
@@ -0,0 +1,150 @@
+/* SPDX-License-Identifier: MIT */
+/*
+ * Description: tests linked requests failing during submission
+ */
+#include <errno.h>
+#include <stdio.h>
+#include <unistd.h>
+#include <stdlib.h>
+#include <string.h>
+#include <fcntl.h>
+#include <assert.h>
+
+#include "liburing.h"
+
+#define DRAIN_USER_DATA 42
+
+static int test_underprep_fail(bool hardlink, bool drain, bool link_last,
+			       int link_size, int fail_idx)
+{
+	const int invalid_fd = 42;
+	int link_flags = IOSQE_IO_LINK;
+	int total_submit = link_size;
+	struct io_uring ring;
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	char buffer[1];
+	int i, ret, fds[2];
+
+	if (drain)
+		link_flags |= IOSQE_IO_DRAIN;
+	if (hardlink)
+		link_flags |= IOSQE_IO_HARDLINK;
+
+	assert(fail_idx < link_size);
+	assert(link_size < 40);
+
+	/* create a new ring as it leaves it dirty */
+	ret = io_uring_queue_init(8, &ring, 0);
+	if (ret) {
+		printf("ring setup failed\n");
+		return -1;
+	}
+	if (pipe(fds)) {
+		perror("pipe");
+		return -1;
+	}
+
+	if (drain) {
+		/* clog drain, so following reqs sent to draining */
+		sqe = io_uring_get_sqe(&ring);
+		io_uring_prep_read(sqe, fds[0], buffer, sizeof(buffer), 0);
+		sqe->user_data = DRAIN_USER_DATA;
+		sqe->flags |= IOSQE_IO_DRAIN;
+		total_submit++;
+	}
+
+	for (i = 0; i < link_size; i++) {
+		sqe = io_uring_get_sqe(&ring);
+		if (i == fail_idx)
+			io_uring_prep_read(sqe, invalid_fd, buffer, 1, 0);
+		else
+			io_uring_prep_nop(sqe);
+
+		if (i != link_size - 1 || !link_last)
+			sqe->flags |= link_flags;
+		sqe->user_data = i;
+	}
+
+	ret = io_uring_submit(&ring);
+	if (ret != total_submit) {
+		/* Old behaviour, failed early and under-submitted */
+		if (ret == fail_idx + 2)
+			goto out;
+		fprintf(stderr, "submit failed: %d\n", ret);
+		return -1;
+	}
+
+	if (drain) {
+		/* unclog drain */
+		write(fds[1], buffer, sizeof(buffer));
+	}
+
+	for (i = 0; i < total_submit; i++) {
+		ret = io_uring_wait_cqe(&ring, &cqe);
+		if (ret) {
+			fprintf(stderr, "wait_cqe=%d\n", ret);
+			return 1;
+		}
+
+		ret = cqe->res;
+		if (cqe->user_data == DRAIN_USER_DATA) {
+			if (ret != 1) {
+				fprintf(stderr, "drain failed %d\n", ret);
+				return 1;
+			}
+		} else if (cqe->user_data == fail_idx) {
+			if (ret == 0 || ret == -ECANCELED) {
+				fprintf(stderr, "half-prep req unexpected return %d\n", ret);
+				return 1;
+			}
+		} else {
+			if (ret != -ECANCELED) {
+				fprintf(stderr, "cancel failed %d, ud %d\n", ret, (int)cqe->user_data);
+				return 1;
+			}
+		}
+		io_uring_cqe_seen(&ring, cqe);
+	}
+out:
+	close(fds[0]);
+	close(fds[1]);
+	io_uring_queue_exit(&ring);
+	return 0;
+}
+
+int main(int argc, char *argv[])
+{
+	int ret, link_size, fail_idx, i;
+
+	if (argc > 1)
+		return 0;
+
+	/*
+	 * hardlink, size=3, fail_idx=1, drain=false -- kernel fault
+	 * link, size=3, fail_idx=0, drain=true -- kernel fault
+	 * link, size=3, fail_idx=1, drain=true -- invalid cqe->res
+	 */
+	for (link_size = 0; link_size < 3; link_size++) {
+		for (fail_idx = 0; fail_idx < link_size; fail_idx++) {
+			for (i = 0; i < 8; i++) {
+				bool hardlink = (i & 1) != 0;
+				bool drain = (i & 2) != 0;
+				bool link_last = (i & 4) != 0;
+
+				ret = test_underprep_fail(hardlink, drain, link_last,
+							  link_size, fail_idx);
+				if (!ret)
+					continue;
+
+				fprintf(stderr, "failed %d, hard %d, drain %d,"
+						"link_last %d, size %d, idx %d\n",
+						ret, hardlink, drain, link_last,
+						link_size, fail_idx);
+				return 1;
+			}
+		}
+	}
+
+	return 0;
+}
-- 
2.33.0

