Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E39D25EB10
	for <lists+io-uring@lfdr.de>; Sat,  5 Sep 2020 23:48:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728724AbgIEVsF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 5 Sep 2020 17:48:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728103AbgIEVsE (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 5 Sep 2020 17:48:04 -0400
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5C3EC061244
        for <io-uring@vger.kernel.org>; Sat,  5 Sep 2020 14:48:02 -0700 (PDT)
Received: by mail-ej1-x644.google.com with SMTP id i26so13015635ejb.12
        for <io-uring@vger.kernel.org>; Sat, 05 Sep 2020 14:48:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EBjS6odIt+w3JNliiM+5qGLyn4i8qdKj3gERqcDpUHE=;
        b=TkxunJ2KxlNL3mV8rJF0TWTZ9t4u+LES62mrq1t+98mhNbDNsvfRdrcFcK9IwmGEGJ
         AIEsu+V2h6sYUHcekaFLdtp36hTwEf4K6eDV6UCqtYc0x0AqtbkU4RkT/bdOMpolZSJR
         zes49Lpb4S1U9Q50vTGHd+1XMrO9fn7DDW4G+U0OcWtKCBDl6OJm5ZymVHPJCfI4xg/6
         5mDoPE6IVELDAr5fl8JiFun6TI/3iGITJRJsmPTuJwJeubyVAFLieVgFqMP7EgSks8XL
         MEu68gIw7GTbx1J1KSTNHXkdt427QvOyjHFVgmeMWvIHOdSVu7cS0IKm+xFq704/xeHW
         XoMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=EBjS6odIt+w3JNliiM+5qGLyn4i8qdKj3gERqcDpUHE=;
        b=HD+fJlBI1rDep+/w+nJ7p3njdHa1nOGq5l/E8N+w/mjlKqKeOt5P1Wi2EJKBI6iUai
         VtI7Jyr4ziWmZwDa5bedSUqRyPnmK9nP3cgppEpbKAXbBBjaRAalbrDJbNO/h1MOQWXw
         7gfWqIP4bg/Wzi4z7vkG0bU6RnUO14e55CD2L1Fu+wctQMEwX0pp432yUwTU3owQhYxJ
         9GVsSdOJgR6Ujfw1su83g4H/MvVNsn4d3ILLl32LsyNDb1OoShypQVCuuSKq+zhN52b5
         RwQtJEmQ9xM8HfAOBJcixklgROibKrr/GWpap16eWsRCi5tuh/aUgwlagH83tOc390IW
         1cUg==
X-Gm-Message-State: AOAM533OWtBU9KUDcBITTD5umerR7Sh0j52MpbI6gPMhzS1XLngZlZ27
        ZtI+sI8kz2w8e3yGhybz58E=
X-Google-Smtp-Source: ABdhPJyCxM5myYmoI02Gzn84u0rmhTmb4WoDlstNsZanlJLBdqCYCqpMnrY7nzI2zTeZBezZPFp4jg==
X-Received: by 2002:a17:907:72cc:: with SMTP id du12mr13693091ejc.150.1599342481442;
        Sat, 05 Sep 2020 14:48:01 -0700 (PDT)
Received: from localhost.localdomain ([5.100.192.56])
        by smtp.gmail.com with ESMTPSA id ot19sm9962739ejb.121.2020.09.05.14.48.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 05 Sep 2020 14:48:01 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing] test/cancel: test cancellation of deferred reqs
Date:   Sun,  6 Sep 2020 00:45:32 +0300
Message-Id: <dd1698c9dbf0455775aecbb6d0c7e05e444c8ec7.1599342239.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Test that while cancelling requests with ->files in flush() it also
finds deferred ones.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/lfs-openat.c | 106 ++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 106 insertions(+)

diff --git a/test/lfs-openat.c b/test/lfs-openat.c
index 4f1b3c4..468901c 100644
--- a/test/lfs-openat.c
+++ b/test/lfs-openat.c
@@ -129,6 +129,95 @@ static int test_linked_files(int dfd, const char *fn, bool async)
 	return 0;
 }
 
+static int test_drained_files(int dfd, const char *fn, bool linked, bool prepend)
+{
+	struct io_uring ring;
+	struct io_uring_sqe *sqe;
+	struct io_uring_cqe *cqe;
+	char buffer[128];
+	struct iovec iov = {.iov_base = buffer, .iov_len = sizeof(buffer), };
+	int i, ret, fd, fds[2], to_cancel = 0;
+
+	ret = io_uring_queue_init(10, &ring, 0);
+	if (ret < 0)
+		DIE("failed to init io_uring: %s\n", strerror(-ret));
+
+	if (pipe(fds)) {
+		perror("pipe");
+		return 1;
+	}
+
+	sqe = io_uring_get_sqe(&ring);
+	if (!sqe) {
+		printf("get sqe failed\n");
+		return -1;
+	}
+	io_uring_prep_readv(sqe, fds[0], &iov, 1, 0);
+	sqe->user_data = 0;
+
+	if (prepend) {
+		sqe = io_uring_get_sqe(&ring);
+		if (!sqe) {
+			fprintf(stderr, "failed to get sqe\n");
+			return 1;
+		}
+		io_uring_prep_nop(sqe);
+		sqe->flags |= IOSQE_IO_DRAIN;
+		to_cancel++;
+		sqe->user_data = to_cancel;
+	}
+
+	if (linked) {
+		sqe = io_uring_get_sqe(&ring);
+		if (!sqe) {
+			fprintf(stderr, "failed to get sqe\n");
+			return 1;
+		}
+		io_uring_prep_nop(sqe);
+		sqe->flags |= IOSQE_IO_DRAIN | IOSQE_IO_LINK;
+		to_cancel++;
+		sqe->user_data = to_cancel;
+	}
+
+	sqe = io_uring_get_sqe(&ring);
+	if (!sqe) {
+		fprintf(stderr, "failed to get sqe\n");
+		return 1;
+	}
+	io_uring_prep_openat(sqe, dfd, fn, OPEN_FLAGS, OPEN_MODE);
+	sqe->flags |= IOSQE_IO_DRAIN;
+	to_cancel++;
+	sqe->user_data = to_cancel;
+
+
+	ret = io_uring_submit(&ring);
+	if (ret != 1 + to_cancel) {
+		fprintf(stderr, "failed to submit openat: %s\n", strerror(-ret));
+		return 1;
+	}
+
+	fd = dup(ring.ring_fd);
+	if (fd < 0) {
+		fprintf(stderr, "dup() failed: %s\n", strerror(-fd));
+		return 1;
+	}
+
+	/* io_uring->flush() */
+	close(fd);
+
+	for (i = 0; i < to_cancel; i++) {
+		ret = io_uring_wait_cqe(&ring, &cqe);
+		if (cqe->res != -ECANCELED) {
+			fprintf(stderr, "fail cqe->res=%d\n", cqe->res);
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
 	const char *fn = "io_uring_openat_test";
@@ -167,6 +256,23 @@ int main(int argc, char *argv[])
 		goto out;
 	}
 
+	ret = test_drained_files(dfd, fn, false, false);
+	if (ret) {
+		fprintf(stderr, "test_drained_files() failed\n");
+		goto out;
+	}
+
+	ret = test_drained_files(dfd, fn, false, true);
+	if (ret) {
+		fprintf(stderr, "test_drained_files() middle failed\n");
+		goto out;
+	}
+
+	ret = test_drained_files(dfd, fn, true, false);
+	if (ret) {
+		fprintf(stderr, "test_drained_files() linked failed\n");
+		goto out;
+	}
 out:
 	io_uring_queue_exit(&ring);
 	close(dfd);
-- 
2.24.0

