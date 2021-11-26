Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04A1445F583
	for <lists+io-uring@lfdr.de>; Fri, 26 Nov 2021 20:50:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229953AbhKZTx6 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 26 Nov 2021 14:53:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239037AbhKZTv5 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 26 Nov 2021 14:51:57 -0500
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E403BC061A2D
        for <io-uring@vger.kernel.org>; Fri, 26 Nov 2021 11:34:11 -0800 (PST)
Received: by mail-ed1-x532.google.com with SMTP id y13so42714312edd.13
        for <io-uring@vger.kernel.org>; Fri, 26 Nov 2021 11:34:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J4xUZ3iCuoAY8wWhGyx78+8zdzd0frvLxAviqmIGYJM=;
        b=Dfbv5ZExhtMsPQY1MFrgxaI6hFt8GT1auRuyDj2UxoDMQgTHtd99rgZcyIiUWDqzAL
         FC9o1S5v8wGxapBMyKHOVP+oROm+iu6NXNtnHYavJq2KGK2WJERUs4xZncicnQNXpmbI
         bFffBdWX2lJSlnSF0I9PKd3lnFzOM0bH09NKVFGLEyQ6906IRllp4zunRTTfpSIFIkrl
         8PyV2YfpakEO5YyB4aHjCNrXvtOifzrSTv9NZChnOfJOg1aZRqTg8Plkmc6+vuZzAiOV
         tiE58YRmVdfzTzkYv7ohb1eKtij9OkaJiY4/wflNl2FUzEYcVofm1gFeey7f2TgoZTow
         PjeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=J4xUZ3iCuoAY8wWhGyx78+8zdzd0frvLxAviqmIGYJM=;
        b=DNdhmQ1O2N1uGr19KlIlaEK2h9FuboGtaeRNGs+mDCznjMJ6MgWLioj7lOc6w8Z4Re
         d4LsiW2JhWzyer7NoaH8Yw67eKhuV6RMbQcoImZa6TpX7WnESmaVPeE22UsZzsZA7DXf
         jfma9zo0USaE6lC0mJqVzyR/t9WXNtiVXCV+PZSNWh9H6a4V7OKepYjJbCGkc18WeumL
         0N92UILALlRz2kyCl5Hqn/h2y9tXDYRmH62IAWvZb34s4W5wVh2VACgscu+NA+kVOG9i
         iqaFEs6YUNjJZNqlGyL/T+Cma6a9qSMQk5cNup/xv023/ntYwKOf2Lm+YhtWuKN7+mBn
         NiOQ==
X-Gm-Message-State: AOAM531rVaAODmYmG2bjVZw0E/K+nBGVUrIFEeXK/KW+8EqLxnGl4IfX
        OypBGVFS3iUxjKKo6khJnzlu454/L8c=
X-Google-Smtp-Source: ABdhPJyOK/WjpOsf0Q26hM5IFKD4PxTqyyji0GYURe9lxJG5MnW+DkiNsDNlFoQBkySqL6dL9ggarg==
X-Received: by 2002:a17:907:3f04:: with SMTP id hq4mr39924029ejc.202.1637955250240;
        Fri, 26 Nov 2021 11:34:10 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.237.101])
        by smtp.gmail.com with ESMTPSA id y19sm4890179edc.17.2021.11.26.11.34.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 26 Nov 2021 11:34:09 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     io-uring@vger.kernel.org
Cc:     asml.silence@gmail.com
Subject: [PATCH] test: poll cancellation with offset timeouts
Date:   Fri, 26 Nov 2021 19:34:05 +0000
Message-Id: <21ed5cd19ba6cff23714dddb07358360a1ac6f91.1637955206.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.34.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Test for a recent locking problem during poll cancellation with
offset timeouts queued.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/poll-cancel.c | 101 +++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 97 insertions(+), 4 deletions(-)

diff --git a/test/poll-cancel.c b/test/poll-cancel.c
index a74e915..408159d 100644
--- a/test/poll-cancel.c
+++ b/test/poll-cancel.c
@@ -26,7 +26,7 @@ static void sig_alrm(int sig)
 	exit(1);
 }
 
-int main(int argc, char *argv[])
+static int test_poll_cancel(void)
 {
 	struct io_uring ring;
 	int pipe1[2];
@@ -36,9 +36,6 @@ int main(int argc, char *argv[])
 	struct sigaction act;
 	int ret;
 
-	if (argc > 1)
-		return 0;
-
 	if (pipe(pipe1) != 0) {
 		perror("pipe");
 		return 1;
@@ -130,6 +127,102 @@ int main(int argc, char *argv[])
 		return 1;
 	}
 
+	close(pipe1[0]);
+	close(pipe1[1]);
 	io_uring_cqe_seen(&ring, cqe);
+	io_uring_queue_exit(&ring);
+	return 0;
+}
+
+
+static int __test_poll_cancel_with_timeouts(void)
+{
+	struct __kernel_timespec ts = { .tv_sec = 10, };
+	struct io_uring ring, ring2;
+	struct io_uring_sqe *sqe;
+	int ret, off_nr = 1000;
+
+	ret = io_uring_queue_init(8, &ring, 0);
+	if (ret) {
+		fprintf(stderr, "ring setup failed: %d\n", ret);
+		return 1;
+	}
+
+	ret = io_uring_queue_init(1, &ring2, 0);
+	if (ret) {
+		fprintf(stderr, "ring setup failed: %d\n", ret);
+		return 1;
+	}
+
+	/* test timeout-offset triggering path during cancellation */
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_timeout(sqe, &ts, off_nr, 0);
+
+	/* poll ring2 to trigger cancellation on exit() */
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_poll_add(sqe, ring2.ring_fd, POLLIN);
+	sqe->flags |= IOSQE_IO_LINK;
+
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_link_timeout(sqe, &ts, 0);
+
+	ret = io_uring_submit(&ring);
+	if (ret != 3) {
+		fprintf(stderr, "sqe submit failed\n");
+		return 1;
+	}
+
+	/* just drop all rings/etc. intact, exit() will clean them up */
+	return 0;
+}
+
+static int test_poll_cancel_with_timeouts(void)
+{
+	int ret;
+	pid_t p;
+
+	p = fork();
+	if (p == -1) {
+		fprintf(stderr, "fork() failed\n");
+		return 1;
+	}
+
+	if (p == 0) {
+		ret = __test_poll_cancel_with_timeouts();
+		exit(ret);
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
+	return 0;
+}
+
+int main(int argc, char *argv[])
+{
+	int ret;
+
+	if (argc > 1)
+		return 0;
+
+	ret = test_poll_cancel();
+	if (ret) {
+		fprintf(stderr, "test_poll_cancel failed\n");
+		return -1;
+	}
+
+	ret = test_poll_cancel_with_timeouts();
+	if (ret) {
+		fprintf(stderr, "test_poll_cancel_with_timeouts failed\n");
+		return -1;
+	}
+
 	return 0;
 }
-- 
2.34.0

