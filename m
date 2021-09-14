Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 573D540B2EE
	for <lists+io-uring@lfdr.de>; Tue, 14 Sep 2021 17:21:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234013AbhINPWc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 14 Sep 2021 11:22:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233987AbhINPWc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 14 Sep 2021 11:22:32 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4287C061574
        for <io-uring@vger.kernel.org>; Tue, 14 Sep 2021 08:21:14 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id n27so29786344eja.5
        for <io-uring@vger.kernel.org>; Tue, 14 Sep 2021 08:21:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mbo3lC/qag1NmdOqhE3rVtxIwQ/Vuz1lWeRNT4bf0j4=;
        b=j9xhnREQPcB/VPmlO7B8rhJzCBHMWcTAq+FVQHH4hGXNHfGifgIh4OV103fZQywMjH
         7L550MTPgw9ieoMR29ROEEtzGVsoDQAckQzCOg+rUNOlqqeRFNvraCncPt7hESQggErk
         r4AZS37951AARMPp5o02P4hIv6pHBw6sNCchSfqYoujapUOvh/kvTlsfAfcZ3z1uppOR
         dxseP/ah4I9/Sb25eCq0bsCCwRm41jzyRaRE26MHejElpehiOwvC7OJk1FmcpE/W/LzW
         Ir+cfVceHVuOQpfnfW95g8hETmW3asyHuztNUG4ags566m9WRMoAZaxANBp/NG7pBS6n
         F+nw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mbo3lC/qag1NmdOqhE3rVtxIwQ/Vuz1lWeRNT4bf0j4=;
        b=zWZbrvIZwU/v1uxoYyPzztqG3QuC3d0GCp7mcN8hUxSt2QNoFkj5VRyijgeKlDqfks
         JoDNlx58blEMOQf9UJ9midiuMzAvsYjoXe2Mg2e8YO6VQYSr2HcYgBX0hvhYIhnCYno9
         VHWc6Pnaxel+rfeGjwQCMFzFhqZvaB0Xam8hNOtdXbRROyEF1v9YdW/Dw6oenk5dlknR
         1WMbzWbRdDLxHH7x2E+VqyMGAjAXushAM79API8dwqG2SYZK+cSh3WQ3veheLHHA23TU
         S1MWNaaa5pLj63sJTLzsyRAGS+8pAPFD3XVyoxJQPgSoNtPcuK64gZG+p0C2PsKMwvf6
         5BQA==
X-Gm-Message-State: AOAM530hNsP/sM7duI5wk12hE8sovDnmZGYpl9rzTx9jFkM+rE1O3d+z
        GCM2L3/RuhF4XqtHDeLShKeEOZsqfbo=
X-Google-Smtp-Source: ABdhPJx192uufmfaEAG7KU3Nbzm9kT7RU6hyZ63mN4Y2nfD70nppVJpY65jP/eoKr3+oIdoHlB4dDA==
X-Received: by 2002:a17:907:33ce:: with SMTP id zk14mr5746048ejb.84.1631632873182;
        Tue, 14 Sep 2021 08:21:13 -0700 (PDT)
Received: from localhost.localdomain ([85.255.232.220])
        by smtp.gmail.com with ESMTPSA id by26sm3634958edb.69.2021.09.14.08.21.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 08:21:12 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing 1/1] tests: test open into taken fixed slot
Date:   Tue, 14 Sep 2021 16:20:31 +0100
Message-Id: <d87d67a95dc816556e3e38440bf34163fba3861f.1631632805.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add a test case verifying opening into an already teaken fixed file
slot.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/openat2.c | 84 +++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 76 insertions(+), 8 deletions(-)

diff --git a/test/openat2.c b/test/openat2.c
index 7838c05..379c61e 100644
--- a/test/openat2.c
+++ b/test/openat2.c
@@ -9,6 +9,7 @@
 #include <stdlib.h>
 #include <string.h>
 #include <fcntl.h>
+#include <sys/uio.h>
 
 #include "helpers.h"
 #include "liburing.h"
@@ -117,11 +118,6 @@ static int test_open_fixed(const char *path, int dfd)
 		return -1;
 	}
 
-	ret = test_openat2(&ring, path, dfd, true, 0);
-	if (ret != -EBADF) {
-		fprintf(stderr, "bogus double register %d\n", ret);
-		return -1;
-	}
 	io_uring_queue_exit(&ring);
 	return 0;
 }
@@ -152,25 +148,90 @@ static int test_open_fixed_fail(const char *path, int dfd)
 	ret = test_openat2(&ring, path, dfd, true, 1);
 	if (ret != -EINVAL) {
 		fprintf(stderr, "install out of bounds, %i\n", ret);
-		return 1;
+		return -1;
 	}
 
 	ret = test_openat2(&ring, path, dfd, true, (1u << 16));
 	if (ret != -EINVAL) {
 		fprintf(stderr, "install out of bounds or u16 overflow, %i\n", ret);
-		return 1;
+		return -1;
 	}
 
 	ret = test_openat2(&ring, path, dfd, true, (1u << 16) + 1);
 	if (ret != -EINVAL) {
 		fprintf(stderr, "install out of bounds or u16 overflow, %i\n", ret);
-		return 1;
+		return -1;
 	}
 
 	io_uring_queue_exit(&ring);
 	return 0;
 }
 
+static int test_direct_reinstall(const char *path, int dfd)
+{
+	struct io_uring_cqe *cqe;
+	struct io_uring_sqe *sqe;
+	char buf[1] = { 0xfa };
+	struct io_uring ring;
+	int ret, pipe_fds[2];
+	ssize_t ret2;
+
+	if (pipe2(pipe_fds, O_NONBLOCK)) {
+		fprintf(stderr, "pipe() failed\n");
+		return -1;
+	}
+	ret = io_uring_queue_init(8, &ring, 0);
+	if (ret) {
+		fprintf(stderr, "ring setup failed\n");
+		return -1;
+	}
+	ret = io_uring_register_files(&ring, pipe_fds, 2);
+	if (ret) {
+		fprintf(stderr, "%s: register ret=%d\n", __FUNCTION__, ret);
+		return -1;
+	}
+
+	/* reinstall into the second slot */
+	ret = test_openat2(&ring, path, dfd, true, 1);
+	if (ret != 0) {
+		fprintf(stderr, "reinstall failed, %i\n", ret);
+		return -1;
+	}
+
+	/* verify it's reinstalled, first write into the slot... */
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_write(sqe, 1, buf, sizeof(buf), 0);
+	sqe->flags |= IOSQE_FIXED_FILE;
+
+	ret = io_uring_submit(&ring);
+	if (ret != 1) {
+		fprintf(stderr, "sqe submit failed: %d\n", ret);
+		return -1;
+	}
+	ret = io_uring_wait_cqe(&ring, &cqe);
+	if (ret < 0) {
+		fprintf(stderr, "wait completion %d\n", ret);
+		return ret;
+	}
+	ret = cqe->res;
+	io_uring_cqe_seen(&ring, cqe);
+	if (ret != 1) {
+		fprintf(stderr, "invalid write %i\n", ret);
+		return -1;
+	}
+
+	/* ... and make sure nothing has been written to the pipe */
+	ret2 = read(pipe_fds[0], buf, 1);
+	if (ret2 != 0 && !(ret2 < 0 && errno == EAGAIN)) {
+		fprintf(stderr, "invalid pipe read, %d %d\n", errno, (int)ret2);
+		return -1;
+	}
+
+	close(pipe_fds[0]);
+	close(pipe_fds[1]);
+	io_uring_queue_exit(&ring);
+	return 0;
+}
 
 int main(int argc, char *argv[])
 {
@@ -227,6 +288,13 @@ int main(int argc, char *argv[])
 		fprintf(stderr, "test_open_fixed_fail failed\n");
 		goto err;
 	}
+
+	ret = test_direct_reinstall(path, -1);
+	if (ret) {
+		fprintf(stderr, "test_direct_reinstall failed\n");
+		goto err;
+	}
+
 done:
 	unlink(path);
 	if (do_unlink)
-- 
2.33.0

