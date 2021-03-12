Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41DC3339376
	for <lists+io-uring@lfdr.de>; Fri, 12 Mar 2021 17:33:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230443AbhCLQdB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Mar 2021 11:33:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232190AbhCLQcj (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Mar 2021 11:32:39 -0500
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 272F3C061574
        for <io-uring@vger.kernel.org>; Fri, 12 Mar 2021 08:32:39 -0800 (PST)
Received: by mail-wm1-x333.google.com with SMTP id m20-20020a7bcb940000b029010cab7e5a9fso16154507wmi.3
        for <io-uring@vger.kernel.org>; Fri, 12 Mar 2021 08:32:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=c0HENHUtx1O5kV+Dkm12o77nYeixq0pKlPSSwEx6HfI=;
        b=t8IjpZXUrUq+Jk+HRgVKYNuW8HYRLpRBwDvplSbV8f9jUsG9lWu2IeGJbRlX1JGbJF
         4iXJgOzq7slK6ZRgHU3s+gur6jP1MdnD4qBeRNPXJ88RowMB4Rt1uovLsdjExL4o23zY
         kxhi4uQ6ExJb4nglHfAfNBySpF0qqSCElyhfosSKOxeZVhJahh9S6OQeOPI8pm6V5NUN
         XvqHiskjVg/fjb4gv0Bs9PupoquuPPOTCDvl7bqqPYuiXwg2S7+6yVMcBi6dhEJ7FMO4
         F40wdHD+3Lx8bnjqXZTjLYPln26wk37lisAepigsnCit7iSG7iU/IiIzApniXDDijbbE
         nz0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c0HENHUtx1O5kV+Dkm12o77nYeixq0pKlPSSwEx6HfI=;
        b=Lmudb3oooxs6ENGTj3yAS2QnZ9Qhb39PFcrOsrinruPrZPuCVagp7oq1r5WODMC71h
         UMPNWAHaWxknFJO13ULsPNRpXsijhxLH071qgz256adTMrwMrnQO66K7taDkzmc9T6K8
         KvDonER7OO2q/qvy1DKEq1JywfBhc8cTz73mqtjrOrm7VYj/0O4aXnMm+PA6lV/d0EBy
         zdVE85jRuQ2iaXfym7LqcHSZsPL0dwObTFvveBmiv5GhPhtnyxccCak6yInPCiTM5vYh
         pXRmABkaYoALDS0WABAy0WWEd6zgBmxV4SKdi8T2TV/Btyhd0+sDtPx9plP1eA3csErR
         DXhQ==
X-Gm-Message-State: AOAM530yGgLi/b5lVr4FBzvvI6PleGnAXHXMemazdomrbOMwD1QXQu82
        4CAWxi7MdLQ/X8Rqv9no6NwtwOi7HcChoQ==
X-Google-Smtp-Source: ABdhPJwqOPan1PaOGNbMK/4g6OaESpdBgudeCjxvNAGFjOerwV/SQEc/a4KsC7r2J/NlrTgHSFiQKA==
X-Received: by 2002:a1c:2683:: with SMTP id m125mr13897817wmm.178.1615566757914;
        Fri, 12 Mar 2021 08:32:37 -0800 (PST)
Received: from localhost.localdomain ([185.69.144.203])
        by smtp.gmail.com with ESMTPSA id e8sm2631265wme.14.2021.03.12.08.32.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 08:32:37 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing 1/2] tests: add more IORING_OP_ASYNC_CANCEL tests
Date:   Fri, 12 Mar 2021 16:28:32 +0000
Message-Id: <d9a8d76d23690842f666c326631ecc2d85b6c1bc.1615566409.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1615566409.git.asml.silence@gmail.com>
References: <cover.1615566409.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

test_dont_cancel_another_ring() makes sure that it doesn't cancel
requests of an unrelated ring, that may happen because of io-wq sharing.
test_cancel_req_across_fork() verifies that IORING_OP_ASYNC_CANCEL io-wq
cancellation isn't limited only to current task.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/io-cancel.c | 179 +++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 179 insertions(+)

diff --git a/test/io-cancel.c b/test/io-cancel.c
index 72ac971..9b52c7b 100644
--- a/test/io-cancel.c
+++ b/test/io-cancel.c
@@ -10,6 +10,7 @@
 #include <fcntl.h>
 #include <sys/types.h>
 #include <sys/time.h>
+#include <sys/wait.h>
 
 #include "helpers.h"
 #include "liburing.h"
@@ -196,6 +197,174 @@ err:
 	return 1;
 }
 
+static int test_dont_cancel_another_ring(void)
+{
+	struct io_uring ring1, ring2;
+	struct io_uring_cqe *cqe;
+	struct io_uring_sqe *sqe;
+	char buffer[128];
+	int ret, fds[2];
+	struct __kernel_timespec ts = { .tv_sec = 0, .tv_nsec = 100000000, };
+
+	ret = io_uring_queue_init(8, &ring1, 0);
+	if (ret) {
+		fprintf(stderr, "ring create failed: %d\n", ret);
+		return 1;
+	}
+	ret = io_uring_queue_init(8, &ring2, 0);
+	if (ret) {
+		fprintf(stderr, "ring create failed: %d\n", ret);
+		return 1;
+	}
+	if (pipe(fds)) {
+		perror("pipe");
+		return 1;
+	}
+
+	sqe = io_uring_get_sqe(&ring1);
+	if (!sqe) {
+		fprintf(stderr, "%s: failed to get sqe\n", __FUNCTION__);
+		return 1;
+	}
+	io_uring_prep_read(sqe, fds[0], buffer, 10, 0);
+	sqe->flags |= IOSQE_ASYNC;
+	sqe->user_data = 1;
+
+	ret = io_uring_submit(&ring1);
+	if (ret != 1) {
+		fprintf(stderr, "%s: got %d, wanted 1\n", __FUNCTION__, ret);
+		return 1;
+	}
+
+	/* make sure it doesn't cancel requests of the other ctx */
+	sqe = io_uring_get_sqe(&ring2);
+	if (!sqe) {
+		fprintf(stderr, "%s: failed to get sqe\n", __FUNCTION__);
+		return 1;
+	}
+	io_uring_prep_cancel(sqe, (void *) (unsigned long)1, 0);
+	sqe->user_data = 2;
+
+	ret = io_uring_submit(&ring2);
+	if (ret != 1) {
+		fprintf(stderr, "%s: got %d, wanted 1\n", __FUNCTION__, ret);
+		return 1;
+	}
+
+	ret = io_uring_wait_cqe(&ring2, &cqe);
+	if (ret) {
+		fprintf(stderr, "wait_cqe=%d\n", ret);
+		return 1;
+	}
+	if (cqe->user_data != 2 || cqe->res != -ENOENT) {
+		fprintf(stderr, "error: cqe %i: res=%i, but expected -ENOENT\n",
+			(int)cqe->user_data, (int)cqe->res);
+		return 1;
+	}
+	io_uring_cqe_seen(&ring2, cqe);
+
+	ret = io_uring_wait_cqe_timeout(&ring1, &cqe, &ts);
+	if (ret != -ETIME) {
+		fprintf(stderr, "read got cancelled or wait failed\n");
+		return 1;
+	}
+	io_uring_cqe_seen(&ring1, cqe);
+
+	close(fds[0]);
+	close(fds[1]);
+	io_uring_queue_exit(&ring1);
+	io_uring_queue_exit(&ring2);
+	return 0;
+}
+
+static int test_cancel_req_across_fork(void)
+{
+	struct io_uring ring;
+	struct io_uring_cqe *cqe;
+	struct io_uring_sqe *sqe;
+	char buffer[128];
+	int ret, i, fds[2];
+	pid_t p;
+
+	ret = io_uring_queue_init(8, &ring, 0);
+	if (ret) {
+		fprintf(stderr, "ring create failed: %d\n", ret);
+		return 1;
+	}
+	if (pipe(fds)) {
+		perror("pipe");
+		return 1;
+	}
+	sqe = io_uring_get_sqe(&ring);
+	if (!sqe) {
+		fprintf(stderr, "%s: failed to get sqe\n", __FUNCTION__);
+		return 1;
+	}
+	io_uring_prep_read(sqe, fds[0], buffer, 10, 0);
+	sqe->flags |= IOSQE_ASYNC;
+	sqe->user_data = 1;
+
+	ret = io_uring_submit(&ring);
+	if (ret != 1) {
+		fprintf(stderr, "%s: got %d, wanted 1\n", __FUNCTION__, ret);
+		return 1;
+	}
+
+	p = fork();
+	if (p == -1) {
+		fprintf(stderr, "fork() failed\n");
+		return 1;
+	}
+
+	if (p == 0) {
+		sqe = io_uring_get_sqe(&ring);
+		if (!sqe) {
+			fprintf(stderr, "%s: failed to get sqe\n", __FUNCTION__);
+			return 1;
+		}
+		io_uring_prep_cancel(sqe, (void *) (unsigned long)1, 0);
+		sqe->user_data = 2;
+
+		ret = io_uring_submit(&ring);
+		if (ret != 1) {
+			fprintf(stderr, "%s: got %d, wanted 1\n", __FUNCTION__, ret);
+			return 1;
+		}
+
+		for (i = 0; i < 2; ++i) {
+			ret = io_uring_wait_cqe(&ring, &cqe);
+			if (ret) {
+				fprintf(stderr, "wait_cqe=%d\n", ret);
+				return 1;
+			}
+			if ((cqe->user_data == 1 && cqe->res != -EINTR) ||
+			    (cqe->user_data == 2 && cqe->res != -EALREADY)) {
+				fprintf(stderr, "%i %i\n", (int)cqe->user_data, cqe->res);
+				exit(1);
+			}
+
+			io_uring_cqe_seen(&ring, cqe);
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
+	close(fds[0]);
+	close(fds[1]);
+	io_uring_queue_exit(&ring);
+	return 0;
+}
+
 int main(int argc, char *argv[])
 {
 	int i, ret;
@@ -203,6 +372,16 @@ int main(int argc, char *argv[])
 	if (argc > 1)
 		return 0;
 
+	if (test_dont_cancel_another_ring()) {
+		fprintf(stderr, "test_dont_cancel_another_ring() failed\n");
+		return 1;
+	}
+
+	if (test_cancel_req_across_fork()) {
+		fprintf(stderr, "test_cancel_req_across_fork() failed\n");
+		return 1;
+	}
+
 	t_create_file(".basic-rw", FILE_SIZE);
 
 	vecs = t_create_buffers(BUFFERS, BS);
-- 
2.24.0

