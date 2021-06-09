Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98BBF3A1739
	for <lists+io-uring@lfdr.de>; Wed,  9 Jun 2021 16:27:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234534AbhFIO3g (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Jun 2021 10:29:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234131AbhFIO3g (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Jun 2021 10:29:36 -0400
Received: from mail-ed1-x534.google.com (mail-ed1-x534.google.com [IPv6:2a00:1450:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72271C061574
        for <io-uring@vger.kernel.org>; Wed,  9 Jun 2021 07:27:41 -0700 (PDT)
Received: by mail-ed1-x534.google.com with SMTP id i13so28881277edb.9
        for <io-uring@vger.kernel.org>; Wed, 09 Jun 2021 07:27:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G0LqTWiGltTaTkNvcf/0U9BFNhpW1YnYf1qCie/rITQ=;
        b=lzk4h5RKmjxVPstlNZ4OIr1CVobxSzoJTq+gds5nm/EDCff7B9GFqaTMIDCJLtzWJY
         w9SM7tFwXI66BcQcRWbbFB4sCt7pjLnI2KhdxLswwzTvtN+cwquHsBGjahYCb65RBEAi
         YOCZYUe17IA/g7QP95QPQ+5OPzq7VrlhNIxfLYjS4GC6/ZVDVnpdRsdvzdNsFTSYBbmW
         eouoxIdg4hgd07na7Kwa8NtADxnQg8KBm/EECqR8tvq8ofE398mPlN/rRE0OOThwi66W
         J97AA91JkYlGP4/aYhmBMcaQZjK7N9GQOa09uilmzl6gw/8gCSoBilxvKc7+RxU5/Qsf
         o6nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=G0LqTWiGltTaTkNvcf/0U9BFNhpW1YnYf1qCie/rITQ=;
        b=mNJlgUequ2tpGLZRCXeQXOCjMcyxGERzvsarTC7D/kb5U7McoC/Dzh4qIgHUNuZyfX
         0GHWz3SOkYcUVD1yQNltBUXWGLOxqcwBI/EEG75Jfpc31ZlIOU84tbrIRSRujJOy1efI
         w0DgJ4yGqgMACrEi8esHcTBpdBJsAKNA8hh5fi1+rORf1DvY2Iy4CxL8YxS6SPtXJPlb
         sEraP9u6L74z6m7sv/HtN7axVPoXMp662RKpGWLwg0GQmMUesOa1Zx5fC76VN176RHCc
         gZ+lhQnrM7YSBPDRIOH8wINreFmAO3jwHMh68PI17B2w8wXyjsPTfeKdxTrGAblmJhMz
         z/kQ==
X-Gm-Message-State: AOAM533XqvL1jJTPUDhqt2N1K0jXo/f1cJWIWaP95oGwKLamPWR5buUB
        6CSAtn/T3sjqsFS20YCzsu8=
X-Google-Smtp-Source: ABdhPJwJsHUH83KiXqAW7s7hBYdxFjsfZfUCXvN6P3sHzOmjFZ8jf5ZOpAfJ5vsz1XzLCASnmHz75A==
X-Received: by 2002:a50:fe86:: with SMTP id d6mr28272375edt.141.1623248860081;
        Wed, 09 Jun 2021 07:27:40 -0700 (PDT)
Received: from agony.thefacebook.com ([2620:10d:c092:600::2:44bc])
        by smtp.gmail.com with ESMTPSA id g23sm1201069ejh.116.2021.06.09.07.27.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Jun 2021 07:27:39 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing 1/1] tests: test shmem buffer registration
Date:   Wed,  9 Jun 2021 15:27:23 +0100
Message-Id: <c0bebfd100d860fb055af8edf7e56b8838e92719.1623245732.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add a simple test registering a chunk of memfd (shmem) memory and doing
some I/O with it.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/io_uring_register.c | 113 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 113 insertions(+)

diff --git a/test/io_uring_register.c b/test/io_uring_register.c
index 1d0981b..53e3987 100644
--- a/test/io_uring_register.c
+++ b/test/io_uring_register.c
@@ -485,6 +485,113 @@ test_poll_ringfd(void)
 	return status;
 }
 
+static int test_shmem(void)
+{
+	const char pattern = 0xEA;
+	const int len = 4096;
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	struct io_uring ring;
+	struct iovec iov;
+	int memfd, ret, i;
+	char *mem;
+	int pipefd[2] = {-1, -1};
+
+	ret = io_uring_queue_init(8, &ring, 0);
+	if (ret)
+		return 1;
+
+	if (pipe(pipefd)) {
+		perror("pipe");
+		return 1;
+	}
+	memfd = memfd_create("uring-shmem-test", 0);
+	if (memfd < 0) {
+		fprintf(stderr, "memfd_create() failed %i\n", -errno);
+		return 1;
+	}
+	if (ftruncate(memfd, len)) {
+		fprintf(stderr, "can't truncate memfd\n");
+		return 1;
+	}
+	mem = mmap(NULL, len, PROT_READ | PROT_WRITE, MAP_SHARED, memfd, 0);
+	if (!mem) {
+		fprintf(stderr, "mmap failed\n");
+		return 1;
+	}
+	for (i = 0; i < len; i++)
+		mem[i] = pattern;
+
+	iov.iov_base = mem;
+	iov.iov_len = len;
+	ret = io_uring_register_buffers(&ring, &iov, 1);
+	if (ret) {
+		if (ret == -EOPNOTSUPP) {
+			fprintf(stdout, "memfd registration isn't supported, "
+					"skip\n");
+			goto out;
+		}
+
+		fprintf(stderr, "buffer reg failed: %d\n", ret);
+		return 1;
+	}
+
+	/* check that we can read and write from/to shmem reg buffer */
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_write_fixed(sqe, pipefd[1], mem, 512, 0, 0);
+	sqe->user_data = 1;
+
+	ret = io_uring_submit(&ring);
+	if (ret != 1) {
+		fprintf(stderr, "submit write failed\n");
+		return 1;
+	}
+	ret = io_uring_wait_cqe(&ring, &cqe);
+	if (ret < 0 || cqe->user_data != 1 || cqe->res != 512) {
+		fprintf(stderr, "reading from shmem failed\n");
+		return 1;
+	}
+	io_uring_cqe_seen(&ring, cqe);
+
+	/* clean it, should be populated with the pattern back from the pipe */
+	memset(mem, 0, 512);
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_read_fixed(sqe, pipefd[0], mem, 512, 0, 0);
+	sqe->user_data = 2;
+
+	ret = io_uring_submit(&ring);
+	if (ret != 1) {
+		fprintf(stderr, "submit write failed\n");
+		return 1;
+	}
+	ret = io_uring_wait_cqe(&ring, &cqe);
+	if (ret < 0 || cqe->user_data != 2 || cqe->res != 512) {
+		fprintf(stderr, "reading from shmem failed\n");
+		return 1;
+	}
+	io_uring_cqe_seen(&ring, cqe);
+
+	for (i = 0; i < 512; i++) {
+		if (mem[i] != pattern) {
+			fprintf(stderr, "data integrity fail\n");
+			return 1;
+		}
+	}
+
+	ret = io_uring_unregister_buffers(&ring);
+	if (ret) {
+		fprintf(stderr, "buffer unreg failed: %d\n", ret);
+		return 1;
+	}
+out:
+	io_uring_queue_exit(&ring);
+	close(pipefd[0]);
+	close(pipefd[1]);
+	munmap(mem, len);
+	close(memfd);
+	return 0;
+}
+
 int
 main(int argc, char **argv)
 {
@@ -541,5 +648,11 @@ main(int argc, char **argv)
 	else
 		printf("FAIL\n");
 
+	ret = test_shmem();
+	if (ret) {
+		fprintf(stderr, "test_shmem() failed\n");
+		status |= 1;
+	}
+
 	return status;
 }
-- 
2.31.1

