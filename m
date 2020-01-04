Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3900113037A
	for <lists+io-uring@lfdr.de>; Sat,  4 Jan 2020 17:22:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726118AbgADQW1 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 4 Jan 2020 11:22:27 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:45677 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726083AbgADQW1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 4 Jan 2020 11:22:27 -0500
Received: by mail-wr1-f68.google.com with SMTP id j42so45089313wrj.12
        for <io-uring@vger.kernel.org>; Sat, 04 Jan 2020 08:22:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QfpQUK7Qthp1DWrjW/s9SmB4BU+OeNaJEtfAYh8Y/mk=;
        b=HwWYdfryE3fXi1queUW7cAYVl+lYZvgf3L259DxVZtOQvjZmU6t+/DDv5tJ4KhcDjq
         NIg5Li2enjQE6ZchrzyFBUxnJQFVL90jGZUBdLpP0WqhvKYBYXWNBUnX6PfDjicGX2Gv
         VeCxCkZJQT2jj7qBzRIuFjUDgV9rmDK6wKV1Yn7v7yLtyoaqfS4uZeFmH2iFL1/94Bj8
         mCdhP0O5qmm6DjufhH2WN3prv0dlLhaVbBh2+Qq0TGQCb9OH68zyVOcEpX6RHU9B/yaX
         Bu2VJDeNuX6xkHzkE0a2gkZt5MmjiojUoUQWuopHuLzA4K4MAIzNo55hHS6SzEyvdecf
         cKOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=QfpQUK7Qthp1DWrjW/s9SmB4BU+OeNaJEtfAYh8Y/mk=;
        b=e1zPaIFdOmyfAQEyVP2GDdjbc0ap4cOhCwxr2Jur0duQNT+Y0K3z6hJP0A5ETbNsag
         2zL18qzZbzjjUEU86pmzQjmowG73hP8bKKBr2WfED4cf+u3ZlLFgGjLo6B4ve94w7uLE
         2PAla9AjGPfS17cNWZFI6YEKG/9+jqfVQ8rZR/zH2U71i9pAQAFCTO0uca+dbMcVDo+F
         EVjGdcFNlNIRqIZx3QjOwl8z3IdgdT4SYPpXp+Jl3qErMbgAeE0NRqeTAvFhm01mAe4Y
         q1ccCTjnOHgOvpzjroFdIUR3Z7D30Y6g9zevjhk3UU8DH8O0dRAtpVlucWk1BD678XUk
         yzXA==
X-Gm-Message-State: APjAAAXZWDBiYbajLEAdowzgaHXCzj2IIsvIa0l4UEO7tylgb7MC1W3D
        VthWpk9adYijBYOTLxeAdTIBDlt0
X-Google-Smtp-Source: APXvYqyhpdyOK6I41tXw9FE9L1AHIUHEU9IYLoVsknF8nXJSUARCAsxAijmZOc1fdbn1BIWib/M9ag==
X-Received: by 2002:adf:ffc5:: with SMTP id x5mr94390479wrs.92.1578154945208;
        Sat, 04 Jan 2020 08:22:25 -0800 (PST)
Received: from localhost.localdomain ([2a01:e35:8bfa:cf10:b5ce:6139:354a:64e2])
        by smtp.gmail.com with ESMTPSA id u8sm16257386wmm.15.2020.01.04.08.22.24
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jan 2020 08:22:24 -0800 (PST)
From:   wdauchy@gmail.com
To:     io-uring@vger.kernel.org
Subject: SQPOLL behaviour with openat
Date:   Sat,  4 Jan 2020 17:22:11 +0100
Message-Id: <20200104162211.9008-1-wdauchy@gmail.com>
X-Mailer: git-send-email 2.24.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Hello,

I am trying to understand SQPOLL behaviour using liburing. I modified the
test in liburing (see below). The test is failing when we use `openat` 
with SQPOLL:

cqe res -9
test_io failed 0/0/1/0/0

Is `openat` supported with SQPOLL? If not I would expect -EINVAL as a
return value, but maybe I'm missing something.
note: I also tested without io_uring_register_files call.

-- 
William

---
 test/read-write.c | 47 ++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 44 insertions(+), 3 deletions(-)

diff --git a/test/read-write.c b/test/read-write.c
index d150f44..05baf0f 100644
--- a/test/read-write.c
+++ b/test/read-write.c
@@ -58,7 +58,7 @@ static int test_io(const char *file, int write, int buffered, int sqthread,
 	struct io_uring_cqe *cqe;
 	struct io_uring ring;
 	int open_flags, ring_flags;
-	int i, fd, ret;
+	int i, dirfd, fd, use_fd, ret;
 
 #ifdef VERBOSE
 	fprintf(stdout, "%s: start %d/%d/%d/%d/%d: ", __FUNCTION__, write,
@@ -79,7 +79,7 @@ static int test_io(const char *file, int write, int buffered, int sqthread,
 	if (!buffered)
 		open_flags |= O_DIRECT;
 
-	fd = open(file, open_flags);
+	dirfd = open(".", O_RDONLY);
 	if (fd < 0) {
 		perror("file open");
 		goto err;
@@ -95,6 +95,46 @@ static int test_io(const char *file, int write, int buffered, int sqthread,
 		goto err;
 	}
 
+	use_fd = dirfd;
+	if (sqthread) {
+		ret = io_uring_register_files(&ring, &dirfd, 1);
+		if (ret) {
+			fprintf(stderr, "file reg failed: %d\n", ret);
+			goto err;
+		}
+		use_fd = 0;
+	}
+	sqe = io_uring_get_sqe(&ring);
+	if (!sqe) {
+		fprintf(stderr, "sqe get failed\n");
+		goto err;
+	}
+	io_uring_prep_openat(sqe, use_fd, file, open_flags, 0);
+	ret = io_uring_submit(&ring);
+	if (ret != 1) {
+		fprintf(stderr, "submit got %d\n", ret);
+		goto err;
+	}
+	ret = io_uring_wait_cqe(&ring, &cqe);
+	if (ret) {
+		fprintf(stderr, "wait_cqe=%d\n", ret);
+		goto err;
+	}
+	if (cqe->res < 0) {
+		fprintf(stderr, "cqe res %d\n", cqe->res);
+		goto err;
+	}
+	fd = cqe->res;
+	io_uring_cqe_seen(&ring, cqe);
+
+	if (sqthread) {
+		ret = io_uring_unregister_files(&ring);
+		if (ret) {
+			fprintf(stderr, "file unreg failed: %d\n", ret);
+			goto err;
+		}
+	}
+
 	if (fixed) {
 		ret = io_uring_register_buffers(&ring, vecs, BUFFERS);
 		if (ret) {
@@ -121,7 +161,7 @@ static int test_io(const char *file, int write, int buffered, int sqthread,
 		offset = BS * (rand() % BUFFERS);
 		if (write) {
 			int do_fixed = fixed;
-			int use_fd = fd;
+			use_fd = fd;
 
 			if (sqthread)
 				use_fd = 0;
@@ -193,6 +233,7 @@ static int test_io(const char *file, int write, int buffered, int sqthread,
 
 	io_uring_queue_exit(&ring);
 	close(fd);
+	close(dirfd);
 #ifdef VERBOSE
 	printf("PASS\n");
 #endif
-- 
2.24.1

