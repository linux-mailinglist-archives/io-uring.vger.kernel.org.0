Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A7F61C17ED
	for <lists+io-uring@lfdr.de>; Fri,  1 May 2020 16:39:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729333AbgEAOjX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 1 May 2020 10:39:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33488 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729319AbgEAOjW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 1 May 2020 10:39:22 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 327DDC061A0C;
        Fri,  1 May 2020 07:39:22 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id x18so11766696wrq.2;
        Fri, 01 May 2020 07:39:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W39olwyD1ZhzcIxfsnVceKE9Xw0rG7gkUI5YYAf7G2U=;
        b=TuRWt3ltfoi+VgnoGf26Fj0cEAwnYiLpqvU2VDrM3zaI0Nwx5a/o7dqdcF9jBxKvnX
         N2DqG7tMBh1cqp5PYA0lsDmZG9aCRdXmq9GUtb7Ezrv7FeKUzUUKgohTF1atEO2pqCvR
         4oj05zpw+4cQncyMdrgbeD0OrqtbxD9oE7CjcbX/iDJaoxy3wEflO0Fpgi8IY1rznpjz
         roX0y12SSNR+KzYolIZrFcYcBqFbxmzrl8njZy8MCtyknaGOMvIFuaaY63Akw2w1DaPd
         NuaymtYAIxFyFVp21sNpPKKrwbjM41fr8Gu0PUaWwadkOcbLicg59xxgFRhaVwMPlgXi
         +BNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W39olwyD1ZhzcIxfsnVceKE9Xw0rG7gkUI5YYAf7G2U=;
        b=b405vDWt+b/LEVoq1OtbvXwqCLfC8421YtHbjVFvAphrtNRf71EjhFvlxxSCaOiSbh
         kYgEEPnXnwOvmAjLyzH3SeJFP2yCLDJrf4At50qkurJ3JsxxTExBm4luTocZSNyQnvTR
         23W5cfDQ0t5GExtQDrOj2evs9uicMoNNDIEZllYSDOHIo1K+aot1+dlaTqpop6S6dRTt
         PBjSu1UESCYOQD82g09gn9qUt6f50IBqIcDd7AzYF97qpiYwLUpqw6bx+2udrNIbE8TB
         FvDwEyzH6xQ+6+F46NGSYQOwkaGvHp2JqMs8HAvmmBhrIwEwPLnleIV8miHjBtI2EtcI
         twOw==
X-Gm-Message-State: AGi0PubmQoKb/rQruNvxd5wfsdr9EtzvM4JsNG1Tz35TyR3lKe+hIYNv
        /TRQuxB5u7JCe6qdP2gWXSU=
X-Google-Smtp-Source: APiQypK9mdZCXdIzpDfEjHs4j3UvzcmIDXn55ON1zdREUbbhw1jhML6XTzyH72SjApGOVBUCdNH5mQ==
X-Received: by 2002:a5d:420a:: with SMTP id n10mr4284992wrq.235.1588343960936;
        Fri, 01 May 2020 07:39:20 -0700 (PDT)
Received: from localhost.localdomain ([109.126.133.135])
        by smtp.gmail.com with ESMTPSA id k184sm4087673wmf.9.2020.05.01.07.39.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 May 2020 07:39:20 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH liburing] test/sfr: basic test for sync_file_range
Date:   Fri,  1 May 2020 17:38:11 +0300
Message-Id: <9a85a351b8a06108260fee1dfcbd901b8055b9a8.1588343872.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Just call it and check that it doesn't hang and returns success.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/fsync.c | 79 ++++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 79 insertions(+)

diff --git a/test/fsync.c b/test/fsync.c
index 839716a..ee60e0f 100644
--- a/test/fsync.c
+++ b/test/fsync.c
@@ -135,6 +135,79 @@ err:
 	return 1;
 }
 
+#define FILE_SIZE 1024
+
+static int create_file(const char *file)
+{
+	ssize_t ret;
+	char *buf;
+	int fd;
+
+	buf = malloc(FILE_SIZE);
+	memset(buf, 0xaa, FILE_SIZE);
+
+	fd = open(file, O_WRONLY | O_CREAT, 0644);
+	if (fd < 0) {
+		perror("open file");
+		return 1;
+	}
+	ret = write(fd, buf, FILE_SIZE);
+	close(fd);
+	return ret != FILE_SIZE;
+}
+
+static int test_sync_file_range(struct io_uring *ring)
+{
+	int ret, fd, save_errno;
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+
+	if (create_file(".sync_file_range")) {
+		fprintf(stderr, "file creation failed\n");
+		return 1;
+	}
+
+	fd = open(".sync_file_range", O_RDWR);
+	save_errno = errno;
+	unlink(".sync_file_range");
+	errno = save_errno;
+	if (fd < 0) {
+		perror("file open");
+		return 1;
+	}
+
+	sqe = io_uring_get_sqe(ring);
+	if (!sqe) {
+		fprintf(stderr, "sqe get failed\n");
+		return 1;
+	}
+	memset(sqe, 0, sizeof(*sqe));
+	sqe->opcode = IORING_OP_SYNC_FILE_RANGE;
+	sqe->off = 0;
+	sqe->len = 0;
+	sqe->sync_range_flags = 0;
+	sqe->user_data = 1;
+	sqe->fd = fd;
+
+	ret = io_uring_submit(ring);
+	if (ret != 1) {
+		fprintf(stderr, "submit failed: %d\n", ret);
+		return 1;
+	}
+	ret = io_uring_wait_cqe(ring, &cqe);
+	if (ret) {
+		fprintf(stderr, "wait_cqe failed: %d\n", ret);
+		return 1;
+	}
+	if (cqe->res) {
+		fprintf(stderr, "sfr failed: %d\n", cqe->res);
+		return 1;
+	}
+
+	io_uring_cqe_seen(ring, cqe);
+	return 0;
+}
+
 int main(int argc, char *argv[])
 {
 	struct io_uring ring;
@@ -159,5 +232,11 @@ int main(int argc, char *argv[])
 		return ret;
 	}
 
+	ret = test_sync_file_range(&ring);
+	if (ret) {
+		fprintf(stderr, "test_sync_file_range failed\n");
+		return ret;
+	}
+
 	return 0;
 }
-- 
2.24.0

