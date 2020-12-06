Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 369292D04F5
	for <lists+io-uring@lfdr.de>; Sun,  6 Dec 2020 13:55:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727918AbgLFMzc (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 6 Dec 2020 07:55:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727842AbgLFMzc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 6 Dec 2020 07:55:32 -0500
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3809C0613D3
        for <io-uring@vger.kernel.org>; Sun,  6 Dec 2020 04:54:51 -0800 (PST)
Received: by mail-wm1-x341.google.com with SMTP id f190so11170464wme.1
        for <io-uring@vger.kernel.org>; Sun, 06 Dec 2020 04:54:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=25AL+BHbbCH+Nz3jtE7beBNzqs4Zi2nRZ2QgNxVz4wc=;
        b=NbRTPcbjuiTrKOLkY2CNkbmhbsw1J30TAhVdrrwsP43K5sdPp78JPKvP0z9LrbZZJo
         4nrEXuCIuzvxEvnKgh4Cvkq3sAIEjfq0ODpUj9OJsD34ffiZBATK9b2uI4EJQyF+gRc4
         pLToVvFWPqorKxQkwM932Cu2ulCD7e9wpL0GCs5WfYoPrOeyqqONs4vbXVyK8gGT+NYY
         h6+ZUOvW9lNH2UxCvAJNrXc7Pl/kunQwIXSuYMBlxUEQb7ljw0mGtlu0MXYcBCOwa+pa
         1DHe85YxwibAhNSmf+RcG5FGPX1A96drczaqfyg9AS/SG99a9agPh2yjGlyaFKFrnTPw
         vV6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=25AL+BHbbCH+Nz3jtE7beBNzqs4Zi2nRZ2QgNxVz4wc=;
        b=I6clGiQzdVSMhFoB2h+RPgiTxPyoGGYKZ+Wv6IN+Sr3Lx8OQas6EQNj6wcMqltKdEK
         o1c8/eF5hwWXvarpmchcc4PrbbVT7zqmc53uox8q2NhLlvjiQmtXgvoU0Z0Nus+gg7Ez
         p8KPf+0u8Ih7fbFmPHBkw59e/+QhaAkwsIFVAYMqBYrCqEKdvIFlIm5ZByTghGsWLYMo
         lzdZib6+pjOGzac9HflA+j1VLFajQPPXXHDNT/BPdiSJRMp7MdFQHRZFxXqfjHSODy0h
         B5osBvu3+aqU8MHhzSrtCyxuH3jqrDIljzKL+HoLT6WCto4t5A3UtCWellBRpl35z5B1
         W9ng==
X-Gm-Message-State: AOAM533ucBfpqlDaKB4EjG6sT/K/SiSECbxO6AfCiMP5+FHqyTIdHpDu
        XFtHwHSFlU59vZ1+GnifdPR76N/gNuGvHw==
X-Google-Smtp-Source: ABdhPJz7zoK9JnZhbg+Pb283LOgohKJpk7uFUMmNohRJZbHK46tP5WnOwQh13glD+el9JsBEgqxRwA==
X-Received: by 2002:a1c:3b85:: with SMTP id i127mr13982809wma.150.1607259290516;
        Sun, 06 Dec 2020 04:54:50 -0800 (PST)
Received: from localhost.localdomain ([185.69.145.45])
        by smtp.gmail.com with ESMTPSA id j14sm10590632wrs.49.2020.12.06.04.54.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Dec 2020 04:54:50 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing 3/3] test/rw: test reg bufs with non-align sizes/offset
Date:   Sun,  6 Dec 2020 12:51:23 +0000
Message-Id: <a3d2736e27a0762fbbdf64b46a296670e4b7c6bf.1607258973.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1607258973.git.asml.silence@gmail.com>
References: <cover.1607258973.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Broaden registered buffers coverage with registering buffers with
non-aligned random offsets and sizes. That in particular test how we're
setting and advancing in-kernel bvecs.

Pass exp_len==-1 for that, so it compares against iov_len with which it
was initialised. Also, direct IO requires alignment, so do it in
buffered mode.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/read-write.c | 71 +++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 65 insertions(+), 6 deletions(-)

diff --git a/test/read-write.c b/test/read-write.c
index 2399c32..84ea3a2 100644
--- a/test/read-write.c
+++ b/test/read-write.c
@@ -37,6 +37,23 @@ static int create_buffers(void)
 	return 0;
 }
 
+static int create_nonaligned_buffers(void)
+{
+	int i;
+
+	vecs = malloc(BUFFERS * sizeof(struct iovec));
+	for (i = 0; i < BUFFERS; i++) {
+		char *p = malloc(3 * BS);
+
+		if (!p)
+			return 1;
+		vecs[i].iov_base = p + (rand() % BS);
+		vecs[i].iov_len = 1 + (rand() % BS);
+	}
+
+	return 0;
+}
+
 static int create_file(const char *file)
 {
 	ssize_t ret;
@@ -155,6 +172,7 @@ static int __test_io(const char *file, struct io_uring *ring, int write,
 			}
 
 		}
+		sqe->user_data = i;
 		if (sqthread)
 			sqe->flags |= IOSQE_FIXED_FILE;
 		if (buf_select) {
@@ -162,7 +180,6 @@ static int __test_io(const char *file, struct io_uring *ring, int write,
 				sqe->addr = 0;
 			sqe->flags |= IOSQE_BUFFER_SELECT;
 			sqe->buf_group = buf_select;
-			sqe->user_data = i;
 		}
 		if (seq)
 			offset += BS;
@@ -187,6 +204,14 @@ static int __test_io(const char *file, struct io_uring *ring, int write,
 				warned = 1;
 				no_read = 1;
 			}
+		} else if (exp_len == -1) {
+			int iov_len = vecs[cqe->user_data].iov_len;
+
+			if (cqe->res != iov_len) {
+				fprintf(stderr, "cqe res %d, wanted %d\n",
+					cqe->res, iov_len);
+				goto err;
+			}
 		} else if (cqe->res != exp_len) {
 			fprintf(stderr, "cqe res %d, wanted %d\n", cqe->res, exp_len);
 			goto err;
@@ -238,7 +263,7 @@ err:
 	return 1;
 }
 static int test_io(const char *file, int write, int buffered, int sqthread,
-		   int fixed, int nonvec)
+		   int fixed, int nonvec, int exp_len)
 {
 	struct io_uring ring;
 	int ret, ring_flags;
@@ -263,7 +288,7 @@ static int test_io(const char *file, int write, int buffered, int sqthread,
 	}
 
 	ret = __test_io(file, &ring, write, buffered, sqthread, fixed, nonvec,
-			0, 0, BS);
+			0, 0, exp_len);
 
 	io_uring_queue_exit(&ring);
 	return ret;
@@ -593,14 +618,15 @@ static int test_write_efbig(void)
 	struct io_uring_sqe *sqe;
 	struct io_uring_cqe *cqe;
 	struct io_uring ring;
-	struct rlimit rlim;
+	struct rlimit rlim, old_rlim;
 	int i, fd, ret;
 	loff_t off;
 
-	if (getrlimit(RLIMIT_FSIZE, &rlim) < 0) {
+	if (getrlimit(RLIMIT_FSIZE, &old_rlim) < 0) {
 		perror("getrlimit");
 		return 1;
 	}
+	rlim = old_rlim;
 	rlim.rlim_cur = 64 * 1024;
 	rlim.rlim_max = 64 * 1024;
 	if (setrlimit(RLIMIT_FSIZE, &rlim) < 0) {
@@ -660,6 +686,11 @@ static int test_write_efbig(void)
 	io_uring_queue_exit(&ring);
 	close(fd);
 	unlink(".efbig");
+
+	if (setrlimit(RLIMIT_FSIZE, &old_rlim) < 0) {
+		perror("setrlimit");
+		return 1;
+	}
 	return 0;
 err:
 	if (fd != -1)
@@ -698,7 +729,8 @@ int main(int argc, char *argv[])
 		int fixed = (i & 8) != 0;
 		int nonvec = (i & 16) != 0;
 
-		ret = test_io(fname, write, buffered, sqthread, fixed, nonvec);
+		ret = test_io(fname, write, buffered, sqthread, fixed, nonvec,
+			      BS);
 		if (ret) {
 			fprintf(stderr, "test_io failed %d/%d/%d/%d/%d\n",
 				write, buffered, sqthread, fixed, nonvec);
@@ -754,6 +786,33 @@ int main(int argc, char *argv[])
 		goto err;
 	}
 
+	srand((unsigned)time(NULL));
+	if (create_nonaligned_buffers()) {
+		fprintf(stderr, "file creation failed\n");
+		goto err;
+	}
+
+	/* test fixed bufs with non-aligned len/offset */
+	for (i = 0; i < nr; i++) {
+		int write = (i & 1) != 0;
+		int buffered = (i & 2) != 0;
+		int sqthread = (i & 4) != 0;
+		int fixed = (i & 8) != 0;
+		int nonvec = (i & 16) != 0;
+
+		/* direct IO requires alignment, skip it */
+		if (!buffered || !fixed || nonvec)
+			continue;
+
+		ret = test_io(fname, write, buffered, sqthread, fixed, nonvec,
+			      -1);
+		if (ret) {
+			fprintf(stderr, "test_io failed %d/%d/%d/%d/%d\n",
+				write, buffered, sqthread, fixed, nonvec);
+			goto err;
+		}
+	}
+
 	if (fname != argv[1])
 		unlink(fname);
 	return 0;
-- 
2.24.0

