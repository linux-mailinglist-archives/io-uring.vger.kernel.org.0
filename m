Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B9513FCB0A
	for <lists+io-uring@lfdr.de>; Tue, 31 Aug 2021 17:50:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238853AbhHaPvW (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 31 Aug 2021 11:51:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232770AbhHaPvV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 31 Aug 2021 11:51:21 -0400
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5E9CC061575
        for <io-uring@vger.kernel.org>; Tue, 31 Aug 2021 08:50:25 -0700 (PDT)
Received: by mail-wm1-x336.google.com with SMTP id c129-20020a1c35870000b02902e6b6135279so2969704wma.0
        for <io-uring@vger.kernel.org>; Tue, 31 Aug 2021 08:50:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AGypVFFRxrSIAxIWonyDUOoulqUjEbXnkjTlBeFM1gg=;
        b=QonzukMALkTeZIM4ge3u+WfNF8svdgLPg5JOkoV7D3LJ7swR0iDTZ0AS+fuJ1jN3qX
         mIKtlghg/jq5aZmwyzopcydbt3y8plpgoGvdA4nIog2LfJG1nqWg1LbO3iCVSIzQ88jb
         6pN9buBDFyvQXTN37NRmN1lrEJ2DYO/U4xCffF/13JhODRPBXQnhvv5RD+M3cy68UHss
         AuLZb7sCXX/QRJ4XJV34nQBrR0Pvxi//k1q+i1Yn97KaqF4S+qUR0Zu16pkxjXaayo71
         0oqDyE35NKXf3A30+MNO2JeNs1lOk396CA5z6tkeAYPM0YM7PhX/t/bzAFuoHqLH1pWb
         3GdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=AGypVFFRxrSIAxIWonyDUOoulqUjEbXnkjTlBeFM1gg=;
        b=Tqs8tDEzipJ95bbkdjD4rBCSBBahXbgNIQpbJ2l2A/DEJqhp+wYVHpXlUX/irOLpA7
         7Dw53riIERiDb8JxjsUj9Iu0KbTWXAqz6ApMlM5zogO957lCUN+pDI/xHGdg94Tc2q+/
         CZsxgMWUMNa9b19gVYyQR81SLXrJDmkuCTAP8FLVKwaI3KWklbqz7bhGkaLD3OD1c+KK
         pm2WzvuFdqw2eXlNFgFcN7e/YVTjrebRHaZgRo+rKeRHLcgusjWYVnItmOs24+Rl5cMi
         WXuBD+AwO7+TkiaJVN+yqCCUk0xEFflPELGjWx8V1nzFPs5ZPq/6DMBjxd3uCOPIQWkX
         /AiA==
X-Gm-Message-State: AOAM533jadPvxHWL0QGivS0giRsVoVqXixCCnZF1eNmzj4/y+24VrX2j
        jR4RXGyEtfHmPz/aS9zxyFU=
X-Google-Smtp-Source: ABdhPJxNM3s4OvzxCZSoHMk3LO1CKZVChnvEZSVjScsYrJ2fgRYM8KJj2qJtGwUh45+Re80GCbzL7w==
X-Received: by 2002:a1c:7d06:: with SMTP id y6mr5016349wmc.7.1630425024483;
        Tue, 31 Aug 2021 08:50:24 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.138])
        by smtp.gmail.com with ESMTPSA id d145sm2751786wmd.3.2021.08.31.08.50.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Aug 2021 08:50:23 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Cc:     Hao Xu <haoxu@linux.alibaba.com>
Subject: [PATCH liburing v2] tests: test early-submit link fails
Date:   Tue, 31 Aug 2021 16:49:46 +0100
Message-Id: <3e02f382b64e7d09c8226ee02be130e4b75d890e.1630424932.git.asml.silence@gmail.com>
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

v2: correct io_uring_submit() ret checks with !drain

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
index 0000000..b79aa7c
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
+		if (ret == fail_idx + 1 + drain)
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

