Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93B942EC854
	for <lists+io-uring@lfdr.de>; Thu,  7 Jan 2021 03:52:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726482AbhAGCvR (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 Jan 2021 21:51:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726507AbhAGCvR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 Jan 2021 21:51:17 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB368C0612F0
        for <io-uring@vger.kernel.org>; Wed,  6 Jan 2021 18:50:36 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id r3so4200046wrt.2
        for <io-uring@vger.kernel.org>; Wed, 06 Jan 2021 18:50:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1sSNwm6ikHynsh6/0P0YGUhYKKE/TWoJkElIB0hkNxQ=;
        b=pEdcEOlk0FPFvX51vjlQ7n0aOT1vETEcH51l/1z3Az3ZAhpb59hystsF3lkwWo0bAo
         J6ARykoqA2Y2uQT/GNSuFjZIudjcWIsBf106OeYE8KzvObHqn7zsYdz8c5/4HSzNxgq7
         A1ocZoVjXm+VUbFgCwswS2qEwO0Bdd4OU0PucdOJA41ze26hU7ZKZ1bBrgDQyU3xK5VG
         ejOsGjflDPrtwVWACWWyGbJj4oE+uv1V0Dkry4SHuALCaTVn9Dfzzl7JQBmLrMujU1AK
         mxcRE9GHDCUZnz33qHkV5xDNqarTh/G2lZbuSS0kJ6xzpQdzlX292RI+X9JfMbJmstq3
         UvzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=1sSNwm6ikHynsh6/0P0YGUhYKKE/TWoJkElIB0hkNxQ=;
        b=TOkNjglVwxN5BOyz8NrgEItI3AT9EzOtet441Iy2UN5qdWBjKELxWzzZ2pIfamzDvZ
         zUByhTZr1aVicefqYy8Hmj/z9yOP61OJESNwCcNYQrxeQQhPebecWLh3N1UfT5N8i2pF
         +vNcMqfSJWMJPt4Z3PUkdOaqtC1E9EBKEUqOp78JY9pDUqZQhQUWtlsnG7YmsvGAYJYO
         RpPQpC2xF0OryIA1vf+PreVI2I1sDXxAAm0dAm4b7VUAXzRZ2Z1mC5ypfwDcXr0VqA5l
         XWQT7gDIz60AzL0478NqINaKTE7XKmxvYiKQ6zbZ1l1zcMbeezCfQRKWSLPMFCgxwVfs
         HkBQ==
X-Gm-Message-State: AOAM532J1RjhnI2Eisq6fKVZ4TWb6CbpcfCO38P4SSzbfXirSLoDkrJ0
        Q8/wPj7r5gD1Ij1uQz9wfA6WCVk/hme3qA==
X-Google-Smtp-Source: ABdhPJxfKItAiNpPM330+oOMis2riw8+xu5ZXIHa2mqUiuZcr6hR4s83aSJmYhnTci2jcaBkm291AQ==
X-Received: by 2002:a5d:51d2:: with SMTP id n18mr6919966wrv.92.1609987835583;
        Wed, 06 Jan 2021 18:50:35 -0800 (PST)
Received: from localhost.localdomain ([185.69.144.125])
        by smtp.gmail.com with ESMTPSA id o83sm5319628wme.21.2021.01.06.18.50.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 18:50:35 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing] tests: test fixed file removal order
Date:   Thu,  7 Jan 2021 02:46:58 +0000
Message-Id: <31d6fcb0f328966c5f68c7629d123a5b0f783331.1609966277.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Do two file removals on a fixed file that used by an inflight request
and make sure it goes well.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/file-register.c | 89 ++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 89 insertions(+)

diff --git a/test/file-register.c b/test/file-register.c
index 55af9dc..fc8b887 100644
--- a/test/file-register.c
+++ b/test/file-register.c
@@ -604,6 +604,89 @@ static int test_sparse_updates(void)
 	return 0;
 }
 
+static int test_fixed_removal_ordering(void)
+{
+	char buffer[128];
+	struct io_uring ring;
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	struct __kernel_timespec ts;
+	int ret, fd, i, fds[2];
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
+	/* ring should have fds referenced, can close them */
+	close(fds[0]);
+	close(fds[1]);
+
+	sqe = io_uring_get_sqe(&ring);
+	if (!sqe) {
+		fprintf(stderr, "%s: get sqe failed\n", __FUNCTION__);
+		return 1;
+	}
+	/* outwait file recycling delay */
+	ts.tv_sec = 3;
+	ts.tv_nsec = 0;
+	io_uring_prep_timeout(sqe, &ts, 0, 0);
+	sqe->flags |= IOSQE_IO_LINK | IOSQE_IO_HARDLINK;
+	sqe->user_data = 1;
+
+	sqe = io_uring_get_sqe(&ring);
+	if (!sqe) {
+		printf("get sqe failed\n");
+		return -1;
+	}
+	io_uring_prep_write(sqe, 1, buffer, sizeof(buffer), 0);
+	sqe->flags |= IOSQE_FIXED_FILE;
+	sqe->user_data = 2;
+
+	ret = io_uring_submit(&ring);
+	if (ret != 2) {
+		fprintf(stderr, "%s: got %d, wanted 2\n", __FUNCTION__, ret);
+		return -1;
+	}
+
+	/* remove unused pipe end */
+	fd = -1;
+	ret = io_uring_register_files_update(&ring, 0, &fd, 1);
+	if (ret != 1) {
+		fprintf(stderr, "update off=0 failed\n");
+		return -1;
+	}
+
+	/* remove used pipe end */
+	fd = -1;
+	ret = io_uring_register_files_update(&ring, 1, &fd, 1);
+	if (ret != 1) {
+		fprintf(stderr, "update off=1 failed\n");
+		return -1;
+	}
+
+	for (i = 0; i < 2; ++i) {
+		ret = io_uring_wait_cqe(&ring, &cqe);
+		if (ret < 0) {
+			fprintf(stderr, "%s: io_uring_wait_cqe=%d\n", __FUNCTION__, ret);
+			return 1;
+		}
+		io_uring_cqe_seen(&ring, cqe);
+	}
+
+	io_uring_queue_exit(&ring);
+	return 0;
+}
+
 int main(int argc, char *argv[])
 {
 	struct io_uring ring;
@@ -699,5 +782,11 @@ int main(int argc, char *argv[])
 		return ret;
 	}
 
+	ret = test_fixed_removal_ordering();
+	if (ret) {
+		printf("test_fixed_removal_ordering failed\n");
+		return 1;
+	}
+
 	return 0;
 }
-- 
2.24.0

