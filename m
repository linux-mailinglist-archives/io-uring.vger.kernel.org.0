Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5331132F98C
	for <lists+io-uring@lfdr.de>; Sat,  6 Mar 2021 12:01:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbhCFLBV (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 6 Mar 2021 06:01:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbhCFLBV (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 6 Mar 2021 06:01:21 -0500
Received: from mail-wm1-x336.google.com (mail-wm1-x336.google.com [IPv6:2a00:1450:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C67FFC06175F
        for <io-uring@vger.kernel.org>; Sat,  6 Mar 2021 03:01:20 -0800 (PST)
Received: by mail-wm1-x336.google.com with SMTP id w203-20020a1c49d40000b029010c706d0642so6812569wma.0
        for <io-uring@vger.kernel.org>; Sat, 06 Mar 2021 03:01:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=p3KXIYiIDn94+UA5xB8Fh/6xoP0DJgNzkrTJiNmMhFA=;
        b=BMpEEam/ZR9PEENGCPjJgFV84ArvKVcCfNWZ6g508UM7Ec3HO6zH76+unBPhOpVpLE
         phapOxR+BqK5apRowLhN+GKeM8RHNnpYNBUXnv/znZEzUAXqBZ9rCNOYjpA8M5ce2o4Q
         TutZ9LXSgbj561pZ03lw35da2jPZWaL7BGTToRicem13seg17NkB5ephv/5yUOOKufL1
         wAtBfLYNhFom0FzqTpkTZqCYLu+zu1Ls8Fd0f9wWn341/gkoN8ObBtucpknTfKvAK3RF
         l+QWRjpKLiNoY6c+nQG+VcCYUcFusA6TA4gXiAerumRQB+MGtNbDMPBae70UWU53B6dd
         Ja7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=p3KXIYiIDn94+UA5xB8Fh/6xoP0DJgNzkrTJiNmMhFA=;
        b=nqKjymcGOa+kTDCcvQACWMqp2pZLfloKVsDjbxzia1RvfOk7ZC2mmZbYQflRlq8qqa
         Qoxb/Vwb/mkArRB5ALZztWYGNXfNP5SJtePGNQJi4Zj81mAVSmxf5jUgderTOuqZRdK4
         NGk1yE6rEV+GmWWus2Ql75iiuEJnJE6GYIAGFukHLrctpT0vK/CmkcqPQo1h5mxtrdG8
         Ish1P7QWWfznpVRi7MjKuZbBbgBZ0KZ2MARTKUat51I2tPYeYHZIzFxR/Lu/Ry6ufD4/
         jv4z2fPG/vbu4Jc8e/C64Po5Ex04RXJqj+7Fbxqik9cvLvV27ICcPo0KCHp/To1N1i0o
         qXXw==
X-Gm-Message-State: AOAM530B73AQSwj0JJujyDjsxnE67y3U+YUzL5vGDe4Yp571XuzgwzOz
        P4z6bAKdjzX6yq7PWgMqxrvZ5bjN2Gm6Gg==
X-Google-Smtp-Source: ABdhPJwBcDOsgaad/giP+NtuRmyPEc7FHdhVWFsM+GYM4KyTKjFdKWl2W2UxO4fKThknRsqAi4Omig==
X-Received: by 2002:a1c:a504:: with SMTP id o4mr12998910wme.174.1615028479542;
        Sat, 06 Mar 2021 03:01:19 -0800 (PST)
Received: from localhost.localdomain ([148.252.129.216])
        by smtp.gmail.com with ESMTPSA id n186sm8266454wmn.22.2021.03.06.03.01.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Mar 2021 03:01:18 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing 1/1] tests: test that ring exit cancels io-wq
Date:   Sat,  6 Mar 2021 10:57:16 +0000
Message-Id: <25463f90290f69c08ba38edf0c40aafd5df50114.1615028231.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Test that io_uring_queue_exit() does proper cancellation of io-wq.
Note that there are worse cases with multiple tasks that can hang
in the kernel due to failing to do io-wq cancellations properly.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/ring-leak.c | 65 ++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 65 insertions(+)

diff --git a/test/ring-leak.c b/test/ring-leak.c
index 4ddc8ff..7ff1d87 100644
--- a/test/ring-leak.c
+++ b/test/ring-leak.c
@@ -73,6 +73,65 @@ static void send_fd(int socket, int fd)
 		perror("sendmsg");
 }
 
+static int test_iowq_request_cancel(void)
+{
+	char buffer[128];
+	struct io_uring ring;
+	struct io_uring_sqe *sqe;
+	int ret, fds[2];
+
+	ret = io_uring_queue_init(8, &ring, 0);
+	if (ret < 0) {
+		fprintf(stderr, "failed to init io_uring: %s\n", strerror(-ret));
+		return ret;
+	}
+	if (pipe(fds)) {
+		perror("pipe");
+		return -1;
+	}
+	ret = io_uring_register_files(&ring, fds, 2);
+	if (ret) {
+		fprintf(stderr, "file_register: %d\n", ret);
+		return ret;
+	}
+	close(fds[1]);
+
+	sqe = io_uring_get_sqe(&ring);
+	if (!sqe) {
+		fprintf(stderr, "%s: failed to get sqe\n", __FUNCTION__);
+		return 1;
+	}
+	/* potentially sitting in internal polling */
+	io_uring_prep_read(sqe, 0, buffer, 10, 0);
+	sqe->flags |= IOSQE_FIXED_FILE;
+
+	sqe = io_uring_get_sqe(&ring);
+	if (!sqe) {
+		fprintf(stderr, "%s: failed to get sqe\n", __FUNCTION__);
+		return 1;
+	}
+	/* staying in io-wq */
+	io_uring_prep_read(sqe, 0, buffer, 10, 0);
+	sqe->flags |= IOSQE_FIXED_FILE | IOSQE_ASYNC;
+
+	ret = io_uring_submit(&ring);
+	if (ret != 2) {
+		fprintf(stderr, "%s: got %d, wanted 1\n", __FUNCTION__, ret);
+		return 1;
+	}
+
+	/* should unregister files and close the write fd */
+	io_uring_queue_exit(&ring);
+
+	/*
+	 * We're trying to wait for the ring to "really" exit, that will be
+	 * done async. For that rely on the registered write end to be closed
+	 * after ring quiesce, so failing read from the other pipe end.
+	 */
+	read(fds[0], buffer, 10);
+	return 0;
+}
+
 int main(int argc, char *argv[])
 {
 	int sp[2], pid, ring_fd, ret;
@@ -80,6 +139,12 @@ int main(int argc, char *argv[])
 	if (argc > 1)
 		return 0;
 
+	ret = test_iowq_request_cancel();
+	if (ret) {
+		fprintf(stderr, "test_iowq_request_cancel() failed\n");
+		return 1;
+	}
+
 	if (socketpair(AF_UNIX, SOCK_DGRAM, 0, sp) != 0) {
 		perror("Failed to create Unix-domain socket pair\n");
 		return 1;
-- 
2.24.0

