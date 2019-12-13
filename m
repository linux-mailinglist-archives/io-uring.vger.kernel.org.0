Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE3F11E8FD
	for <lists+io-uring@lfdr.de>; Fri, 13 Dec 2019 18:13:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728402AbfLMRMD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 Dec 2019 12:12:03 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:36212 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728413AbfLMRMD (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 13 Dec 2019 12:12:03 -0500
Received: by mail-wm1-f68.google.com with SMTP id p17so361892wma.1;
        Fri, 13 Dec 2019 09:12:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=oONWFSnEmppU5WkvOUIZSunVfuRDSeXJRgxaN4+F1B8=;
        b=eOVvorSh6PzP1gVTIiv/kUdPIkLtH9Mg+PwB/vCkTQLl+XUrC/c3b/b5yx24S04wdH
         N1UFFXd30YQB55l6z4ZcO8iYInRIBStYQjNELP2n7MtwNM6ARQxWQdOzndUHuSOdxkJq
         p1Rus+TEaRt99hDwAzZxHX7M0dif0BeWLojqhnCguRYnSyzQ9NwxrLcBSKXZLQBrvuIb
         izUFmQFGv0sLs2DFyrgxbLoGg5Svd5QFPFT8jBNv5dPrSgqBTY++LlUksOUAC4SUqSo6
         M0dEaweI+5a2iUTpLeCUuimSebxjOzN1Cr5asIvX7UI9NqIDfHcET8IYOFxun3yvRUWG
         I76A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=oONWFSnEmppU5WkvOUIZSunVfuRDSeXJRgxaN4+F1B8=;
        b=brDWOGapuz9O958KwVqXoFkwkUODOZ0pSxn0fhwdVWvk50wir3kurc+kYFiUQkm/Bz
         RjZJ0ba5cJnm7xKZ+U7p34djtAiRVHQ15LuufARciCv958x8W0aR/lxbXg//BQrCV9MP
         /mQyjDLt4WbPQAnF2JiGtxFbOVu0dn4MgHQOhqdnn4Ph/yIta0Zx26lbxlQhb0NI0D1V
         wKwAeGgEyag7/Vo3wiwww/YYa5/IZ8/l3bGLYMpBh7SbR3JIZUYU9vlnERo7468/9XCB
         2IRH+gx3SwfOVr+SA0PBskMbVBhiIR/xfVQoYv1DuvnKuFN/oCqV58lO7FUmimsKEM/G
         b37g==
X-Gm-Message-State: APjAAAUQe1OHn4qE8rv797KxDidG/75TotzEY4qlxgTJ7QGxj0UeVYin
        NOUt7TBfGoJvEqKDH8/BIHbNtFDv
X-Google-Smtp-Source: APXvYqxRKKH8jyEOW8ZQENkfmTbVlbRk+C0royRPuGNGNKgEE+mAphI3RpeWCIQlfrK9hSWb8lMhXQ==
X-Received: by 2002:a1c:407:: with SMTP id 7mr14180821wme.29.1576257120865;
        Fri, 13 Dec 2019 09:12:00 -0800 (PST)
Received: from localhost.localdomain ([109.126.143.152])
        by smtp.gmail.com with ESMTPSA id v188sm10963924wma.10.2019.12.13.09.11.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Dec 2019 09:12:00 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 liburing] Test wait after under-consuming
Date:   Fri, 13 Dec 2019 20:11:22 +0300
Message-Id: <512741aa9160cc9648780a21a4bf4aa10a47193f.1576256964.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <e5579bbac4fcb4f0e9b6ba4fbf3a56bd9a925c6c.1576224356.git.asml.silence@gmail.com>
References: <e5579bbac4fcb4f0e9b6ba4fbf3a56bd9a925c6c.1576224356.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

In case of an error submission won't consume all sqes. This tests that
it will get back to the userspace even if (to_submit == to_wait)

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---

since v1: don't leave ring dirty, as it will fail following tests

 test/link.c | 51 ++++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 50 insertions(+), 1 deletion(-)

diff --git a/test/link.c b/test/link.c
index 8ec1649..6c8ae09 100644
--- a/test/link.c
+++ b/test/link.c
@@ -384,6 +384,50 @@ err:
 	return 1;
 }
 
+static int test_early_fail_and_wait(void)
+{
+	struct io_uring ring;
+	struct io_uring_sqe *sqe;
+	int ret, invalid_fd = 42;
+	struct iovec iov = { .iov_base = NULL, .iov_len = 0 };
+
+	/* create a new ring as it leaves it dirty */
+	ret = io_uring_queue_init(8, &ring, 0);
+	if (ret) {
+		printf("ring setup failed\n");
+		return 1;
+	}
+
+	sqe = io_uring_get_sqe(&ring);
+	if (!sqe) {
+		printf("get sqe failed\n");
+		goto err;
+	}
+
+	io_uring_prep_readv(sqe, invalid_fd, &iov, 1, 0);
+	sqe->flags |= IOSQE_IO_LINK;
+
+	sqe = io_uring_get_sqe(&ring);
+	if (!sqe) {
+		printf("get sqe failed\n");
+		goto err;
+	}
+
+	io_uring_prep_nop(sqe);
+
+	ret = io_uring_submit_and_wait(&ring, 2);
+	if (ret <= 0 && ret != -EAGAIN) {
+		printf("sqe submit failed: %d\n", ret);
+		goto err;
+	}
+
+	io_uring_queue_exit(&ring);
+	return 0;
+err:
+	io_uring_queue_exit(&ring);
+	return 1;
+}
+
 int main(int argc, char *argv[])
 {
 	struct io_uring ring, poll_ring;
@@ -400,7 +444,6 @@ int main(int argc, char *argv[])
 	if (ret) {
 		printf("poll_ring setup failed\n");
 		return 1;
-
 	}
 
 	ret = test_single_link(&ring);
@@ -439,5 +482,11 @@ int main(int argc, char *argv[])
 		return ret;
 	}
 
+	ret = test_early_fail_and_wait();
+	if (ret) {
+		fprintf(stderr, "test_early_fail_and_wait\n");
+		return ret;
+	}
+
 	return 0;
 }
-- 
2.24.0

