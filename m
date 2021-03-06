Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85B5932F98D
	for <lists+io-uring@lfdr.de>; Sat,  6 Mar 2021 12:03:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbhCFLCf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 6 Mar 2021 06:02:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229881AbhCFLCM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 6 Mar 2021 06:02:12 -0500
Received: from mail-wm1-x32b.google.com (mail-wm1-x32b.google.com [IPv6:2a00:1450:4864:20::32b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79345C06175F
        for <io-uring@vger.kernel.org>; Sat,  6 Mar 2021 03:02:12 -0800 (PST)
Received: by mail-wm1-x32b.google.com with SMTP id r10-20020a05600c35cab029010c946c95easo825431wmq.4
        for <io-uring@vger.kernel.org>; Sat, 06 Mar 2021 03:02:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=p3KXIYiIDn94+UA5xB8Fh/6xoP0DJgNzkrTJiNmMhFA=;
        b=PSXkAxVUEv2P5KOPOr67dbcrZ12/1JTqjaPpXfyeGqDggi52F03bgzhcRb/PBk0/e0
         xxqnn63dr4Kx1p7RLC6ZsqPvCRVz6+9131Gg8eKK+nWim6BWUUSeyVjJ/Hk58Smd+JR6
         jrlNLm3HICE1dv3zyVDNyT/D2Pyd7tnXYjO38dEWfUIrLlult63YECrn9SNNc3x+/1Fg
         cP81jR1BtGPE+TQlsjxqQ+6k4KLOR0gabJcy6joyDOLD9QtJxjkrHBtZmA4PHi33Y0df
         FJfzWTGUE6cQ2kvWK5AId3vosivLu2G5BIKEJG7Zz6WXVXtXGveNGG7ij3Yf1tFWhcYw
         VVvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=p3KXIYiIDn94+UA5xB8Fh/6xoP0DJgNzkrTJiNmMhFA=;
        b=htmD/4F9awy6tmEqm5E4IGKmK0iTuixWkIW54B65N5k57Vaw39IvWlFdaPg/WsSGPd
         B7GnGGYeuiLtNcYWDv6lLSglHN6kWpPDd3QuAkpzytH4hS2eY9COwtvi3dCKMBeuijgj
         vX6iZ3035hbC6SxxQc4hVbZhXtNSS6OGU6Hg64EyogEnWpAy5kYFNDJNmO86Jk7lXJfu
         NmBX01UnGrldrqFJP2wIdxWC0S0uOqL1lOX4co25i47d76CyKxEqH+8ZntwOBgFDY1R5
         IQqU3bryceaAKiV3qTs2smENLRguF1eFFFFb8QaDgfuudqqH5hpySs/NucT28qpu4JOd
         vsag==
X-Gm-Message-State: AOAM530qWIwVOwsb+G7yRArKq9RKbsjxlivjVz9k7gRp/uP5NSbiQQOW
        GBJZZMZLIPm37sqWXyciviL2beLQs5jYpw==
X-Google-Smtp-Source: ABdhPJygaV3gxAaqtAUpvYSJ9MaZ3KEIO2BjD2YQmbCGomJbTrT34/iXbV/XDZtp+hbJhT24U9IZHw==
X-Received: by 2002:a05:600c:252:: with SMTP id 18mr12881445wmj.67.1615028531322;
        Sat, 06 Mar 2021 03:02:11 -0800 (PST)
Received: from localhost.localdomain ([148.252.133.8])
        by smtp.gmail.com with ESMTPSA id m14sm9187307wmi.27.2021.03.06.03.02.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Mar 2021 03:02:10 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing 1/1] tests: test that ring exit cancels io-wq
Date:   Sat,  6 Mar 2021 10:58:10 +0000
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

