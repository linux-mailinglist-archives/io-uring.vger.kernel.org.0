Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D05323D5EA1
	for <lists+io-uring@lfdr.de>; Mon, 26 Jul 2021 17:51:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236262AbhGZPLL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Jul 2021 11:11:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237362AbhGZPLB (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Jul 2021 11:11:01 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37EF9C061757
        for <io-uring@vger.kernel.org>; Mon, 26 Jul 2021 08:51:28 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id n12so8116419wrr.2
        for <io-uring@vger.kernel.org>; Mon, 26 Jul 2021 08:51:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xB26h1URKEmOKB1UhMMvFxZ497e9FSM3FZmr7Wu95fg=;
        b=Lknt96L7/uHxSEaW/LecIpRO3efkEjykK0LJg4mhpcMdi+o++kRnSeIzveMjM2UwoK
         D1cNFKCA91USnOxQBqJYgoxrlxH5r+vrr1aCPGzAaZ1atRjvp3ZXv29nx/TbKxbf0m7Q
         rugK9S0n/mXM/Rnn3DJ/Y9SPpq5Ychobge2opvrWt9yg4Inub5OdLYxx67ua8XtkS0nd
         TAdW9T1oFjOKFmp9BaektZ7SHKXrCt4fI8Ocbv+cZfuSiyh4UZhbanW05HwKjxiElceM
         0wttZvEddoAcX5ItjucJoEi1QQ2KKvGu0SPYpc8raMbpJLNsbkC+KZFR/q4obYjCGUOJ
         m1XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=xB26h1URKEmOKB1UhMMvFxZ497e9FSM3FZmr7Wu95fg=;
        b=X/Fh8kmaB9DBXHRXTATUQVvsluIhtVZBo/7AAPZOBxgDD5qKCD+j7ePY81u/ALKQl7
         WqPq/+NDtPU8OlvBAQvpeMuaM97em1ZegnxaR4Iyldr4ySKetpWxvYl7KaC0q8M8YKRd
         3PxaG/4eBvg8Z9qeESXdCVluOMlHYuzL7PokXkC77D6s/A3t8c/24QfeqUYL8dFG1JHz
         w5VPQMyE+xPDHSxF9JA2uUMC+81gbCXY+ZHGQzJeBQa9QBtmAnrV9JZAVlo+QogMe/VI
         uXUqS2k6KLk7o8O0o5s0yjNvvaHdWXHGj9p879eXzMx34kRTrabTluRLCyVQPX21bWXt
         CDvg==
X-Gm-Message-State: AOAM531uzBFmJPLWCvB7izUqFLj6/mMwQUa23T1Q4xRMJpqxWVFN3od8
        480yhwNKqMzKLOeJW7XEl58=
X-Google-Smtp-Source: ABdhPJxD3cNZuJrpCu7Gp9UEPZFJ3iK2/0ypVLBa0EqFnp4qtw8T4OGa0PFaMu0TTasB8HhwsNX0Jw==
X-Received: by 2002:adf:ee51:: with SMTP id w17mr5506631wro.279.1627314686819;
        Mon, 26 Jul 2021 08:51:26 -0700 (PDT)
Received: from localhost.localdomain ([148.252.133.244])
        by smtp.gmail.com with ESMTPSA id j14sm189725wru.58.2021.07.26.08.51.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Jul 2021 08:51:26 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing] tests: fix poll update compatibility check
Date:   Mon, 26 Jul 2021 16:50:55 +0100
Message-Id: <2a5f83d0cda642d97ea633b55ba0d53e82cbb064.1627314599.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Compatibility checks in poll-mshot-update doesn't always work well, and
so the test can fail even if poll updates are not supported. Do the
check separately and at the beginning.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/poll-mshot-update.c | 63 +++++++++++++++++++++++++---------------
 1 file changed, 40 insertions(+), 23 deletions(-)

diff --git a/test/poll-mshot-update.c b/test/poll-mshot-update.c
index 1a9ea0a..a3e4951 100644
--- a/test/poll-mshot-update.c
+++ b/test/poll-mshot-update.c
@@ -28,7 +28,37 @@ struct p {
 };
 
 static struct p p[NFILES];
-static int no_update;
+
+static int has_poll_update(void)
+{
+	struct io_uring ring;
+	struct io_uring_cqe *cqe;
+	struct io_uring_sqe *sqe;
+	bool has_update = false;
+	int ret;
+
+	ret = io_uring_queue_init(8, &ring, 0);
+	if (ret)
+		return -1;
+
+	sqe = io_uring_get_sqe(&ring);
+	io_uring_prep_poll_update(sqe, NULL, NULL, POLLIN, IORING_TIMEOUT_UPDATE);
+
+	ret = io_uring_submit(&ring);
+	if (ret != 1)
+		return -1;
+
+	ret = io_uring_wait_cqe(&ring, &cqe);
+	if (!ret) {
+		if (cqe->res == -ENOENT)
+			has_update = true;
+		else if (cqe->res != -EINVAL)
+			return -1;
+		io_uring_cqe_seen(&ring, cqe);
+	}
+	io_uring_queue_exit(&ring);
+	return has_update;
+}
 
 static int arm_poll(struct io_uring *ring, int off)
 {
@@ -128,19 +158,6 @@ static void *trigger_polls_fn(void *data)
 	return NULL;
 }
 
-static int check_no_update(struct io_uring *ring)
-{
-	struct io_uring_cqe *cqe;
-	int ret;
-
-	ret = io_uring_wait_cqe(ring, &cqe);
-	if (ret)
-		return 0;
-	ret = cqe->res;
-	io_uring_cqe_seen(ring, cqe);
-	return ret == -EINVAL;
-}
-
 static int arm_polls(struct io_uring *ring)
 {
 	int ret, to_arm = NFILES, i, off;
@@ -163,10 +180,6 @@ static int arm_polls(struct io_uring *ring)
 
 		ret = io_uring_submit(ring);
 		if (ret != this_arm) {
-			if (ret > 0 && check_no_update(ring)) {
-				no_update = 1;
-				return 0;
-			}
 			fprintf(stderr, "submitted %d, %d\n", ret, this_arm);
 			return 1;
 		}
@@ -187,6 +200,15 @@ int main(int argc, char *argv[])
 	if (argc > 1)
 		return 0;
 
+	ret = has_poll_update();
+	if (ret < 0) {
+		fprintf(stderr, "poll update check failed %i\n", ret);
+		return -1;
+	} else if (!ret) {
+		fprintf(stderr, "no poll update, skip\n");
+		return 0;
+	}
+
 	if (getrlimit(RLIMIT_NOFILE, &rlim) < 0) {
 		perror("getrlimit");
 		goto err_noring;
@@ -227,10 +249,6 @@ int main(int argc, char *argv[])
 
 	if (arm_polls(&ring))
 		goto err;
-	if (no_update) {
-		printf("No poll update support, skipping\n");
-		goto done;
-	}
 
 	for (i = 0; i < NLOOPS; i++) {
 		pthread_create(&thread, NULL, trigger_polls_fn, NULL);
@@ -240,7 +258,6 @@ int main(int argc, char *argv[])
 		pthread_join(thread, NULL);
 	}
 
-done:
 	io_uring_queue_exit(&ring);
 	return 0;
 err:
-- 
2.32.0

