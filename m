Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C03A339377
	for <lists+io-uring@lfdr.de>; Fri, 12 Mar 2021 17:33:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231928AbhCLQdB (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Mar 2021 11:33:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232223AbhCLQck (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Mar 2021 11:32:40 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F98BC061574
        for <io-uring@vger.kernel.org>; Fri, 12 Mar 2021 08:32:40 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id j4-20020a05600c4104b029010c62bc1e20so15545697wmi.3
        for <io-uring@vger.kernel.org>; Fri, 12 Mar 2021 08:32:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=p3KXIYiIDn94+UA5xB8Fh/6xoP0DJgNzkrTJiNmMhFA=;
        b=dML5ZRjWyiIdXPEY4m4EcuIh43iC0VQVIGIvNEpZfm/V9P9hEqjswJCQZfvCiZS8U5
         wMounDeGmw4BbIdGaMWs9xBedKfPw4G1VUpFDsAs7eNWImLXkuSZ5T7YJi6Ikwh5sqBx
         Lx/44I6vdzZOI8MCbFi2liUBxMyboFhH3p2RCTbzHArntB4wlcgF2iWOIRpNedljW5XU
         ebwvUQnK3lk9E/Xfq1GRIYpr7OT040MHtL/4WRXEncKfNWc91oFwOrGEkMBODfQOm0h9
         40lkp1FFzIU7+HSfuEjbCjt6JDFShNfq3smaVZ6oRrH5isX5pKlfNTV4UV12X58X4gpL
         ONFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p3KXIYiIDn94+UA5xB8Fh/6xoP0DJgNzkrTJiNmMhFA=;
        b=fvsEmfNkk8g3Jsug3K4sV7sPWYyX38Nw3euhTMfdtPCZcyD1Z895QakXqTPE+NqUs0
         NZuezmnzaTeHza248tzmhmey93WS4mi6WtzFYqFrQvNTK314WX6ncGAL2AUQBqXyUbf6
         uWRGqs65IMaxGv6QW/oDj8U9WFE4TidDdomLTk2i6gv5MxVFxTViVr6sMK0xSDkEksax
         z50E3QxlXYzaKdl33tKxZVuY56IV4/XUA9NuVQWMGS/kJOGUg/L0uUtMK6z5sb0BzrWq
         /wPByXkszt9kW/n0v/Gkxbt7odHueTRR9gA4aO0zg4vICrlnpRoYYC+taMj6reAtHoZ8
         uCHA==
X-Gm-Message-State: AOAM533oBbFpW3zYSnr827Y/smBZkSptKj7nzK/YF9JB3FKVzUBBHAvn
        G9sO0bfac4lQFYLDsov3oS0=
X-Google-Smtp-Source: ABdhPJxvsFjBdZGhsDJhLCNRWkyKPisvBdLKiWw1PWn6ymTfNIxJGOgIxPsea74dfFGsKw56LoORtQ==
X-Received: by 2002:a7b:cc0c:: with SMTP id f12mr14006317wmh.111.1615566759096;
        Fri, 12 Mar 2021 08:32:39 -0800 (PST)
Received: from localhost.localdomain ([185.69.144.203])
        by smtp.gmail.com with ESMTPSA id e8sm2631265wme.14.2021.03.12.08.32.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 08:32:38 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing 2/2] tests: test that ring exit cancels io-wq
Date:   Fri, 12 Mar 2021 16:28:33 +0000
Message-Id: <2eee395a2cf1bea49036aa82b056ff7bfd2cda14.1615566409.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1615566409.git.asml.silence@gmail.com>
References: <cover.1615566409.git.asml.silence@gmail.com>
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

