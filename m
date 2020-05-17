Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D5581D67B6
	for <lists+io-uring@lfdr.de>; Sun, 17 May 2020 13:25:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728030AbgEQLZZ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 17 May 2020 07:25:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728025AbgEQLZY (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 17 May 2020 07:25:24 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0AEEC061A0C;
        Sun, 17 May 2020 04:25:23 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id x22so2595932lfd.4;
        Sun, 17 May 2020 04:25:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=06qjz4XTb9oP8noL+O6HNwACOf9M/01LAdmAn4R25NM=;
        b=LbJNgbK2xq+tD46CDMISeSEqtd2SjnCShz7WBJyJKHj6OyAfz1ZjwEmgU3GyGsTeJS
         OzrOtChAuYNsXr3ArKUIcrY7O7luK7ZO9d618NQe0wqf0e9FvpKsixzOk18eI7IMSz8e
         7rB9AdVEw2ow6tYBXmxW9bUp24j3I25FxX8Oa4sxKJpiKiBpExyy2GVD2GJ3/dHaPopr
         H78nXZaTt/cZ/7aNNeRGrW34CS/rnvwDFNydaXufim4zju4xHBJZaD/MGbnCJX3UGLYN
         vLfC/3TjHiiL3rKt4xRmpaPsLLG0ETzYxBC9OlsfySey0TTaUB06qNk9qanXJTYr3ELE
         1kEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=06qjz4XTb9oP8noL+O6HNwACOf9M/01LAdmAn4R25NM=;
        b=tHovmGZ2+YfzNnuMerHPZNkdgM2AQ1DITTNE6Y6zaEvX792K3MmkUJS9UxNe11RXLi
         1oRCebNJEyfszF4yD5qYoZTY3ynVOYkC+pa+OwogJNygduyEBl+94wuyL1I4E66IoXed
         +aUZmyDxMhVqZOmuLKk2eKqA2ODvWOxOV3M2bpyyIILdOLp31Sh5HgQ5433jwVM1KN6N
         laxZyHLj24Z3lTdf9LbNP89BOM8AxnkCFFrFrtLCDAwn4MGlNvUO8reNaLGCeDAgki/w
         gnqE0EVHL/zJQYYclgX3EmAFEbZehs7X0RBN9dlWi1YVq3jqKGOZxY1vY5FMbCI3DfX7
         TMsg==
X-Gm-Message-State: AOAM532by/nhZavG8LEgqqr++sH4k06N868tXBpegNeQb2qhfIN3dBgY
        pixVnEI9HdLYFI0V9eygGPs=
X-Google-Smtp-Source: ABdhPJy7EeEwHP+lGhoRaKAktDv1nEI5y+3Zd29itnwV2yHCnNbgTj2ayAWZCsxm/uF0cwyB9qr0bw==
X-Received: by 2002:a19:7104:: with SMTP id m4mr8246047lfc.75.1589714722375;
        Sun, 17 May 2020 04:25:22 -0700 (PDT)
Received: from localhost.localdomain ([82.209.196.123])
        by smtp.gmail.com with ESMTPSA id c78sm5639828lfd.63.2020.05.17.04.25.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 May 2020 04:25:21 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH liburing 4/4] splice/tee/tests: test len=0 splice/tee
Date:   Sun, 17 May 2020 14:23:47 +0300
Message-Id: <1c3b277135e8f98dacc2a6ce582a48ae4d64780f.1589714504.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1589714504.git.asml.silence@gmail.com>
References: <cover.1589714504.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Check zero-length splice() and tee().

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/splice.c | 38 ++++++++++++++++++++++++++++++++++++--
 1 file changed, 36 insertions(+), 2 deletions(-)

diff --git a/test/splice.c b/test/splice.c
index 119c493..b81aa4b 100644
--- a/test/splice.c
+++ b/test/splice.c
@@ -144,7 +144,7 @@ static int do_splice_op(struct io_uring *ring,
 	struct io_uring_sqe *sqe;
 	int ret = -1;
 
-	while (len) {
+	do {
 		sqe = io_uring_get_sqe(ring);
 		if (!sqe) {
 			fprintf(stderr, "get sqe failed\n");
@@ -179,7 +179,7 @@ static int do_splice_op(struct io_uring *ring,
 		if (off_out != -1)
 			off_out += cqe->res;
 		io_uring_cqe_seen(ring, cqe);
-	}
+	} while (len);
 
 	return 0;
 }
@@ -215,6 +215,21 @@ static void check_tee_support(struct io_uring *ring, struct test_ctx *ctx)
 	has_tee = (ret == -EBADF);
 }
 
+static int check_zero_splice(struct io_uring *ring, struct test_ctx *ctx)
+{
+	int ret;
+
+	ret = do_splice(ring, ctx->fd_in, -1, ctx->pipe1[1], -1, 0);
+	if (ret)
+		return ret;
+
+	ret = do_splice(ring, ctx->pipe2[0], -1, ctx->pipe1[1], -1, 0);
+	if (ret)
+		return ret;
+
+	return 0;
+}
+
 static int splice_to_pipe(struct io_uring *ring, struct test_ctx *ctx)
 {
 	int ret;
@@ -349,11 +364,23 @@ static int check_tee(struct io_uring *ring, struct test_ctx *ctx)
 	return 0;
 }
 
+static int check_zero_tee(struct io_uring *ring, struct test_ctx *ctx)
+{
+	return do_tee(ring, ctx->pipe2[0], ctx->pipe1[1], 0);
+}
+
 static int test_splice(struct io_uring *ring, struct test_ctx *ctx)
 {
 	int ret;
 
 	if (has_splice) {
+		ret = check_zero_splice(ring, ctx);
+		if (ret) {
+			fprintf(stderr, "check_zero_splice failed %i %i\n",
+				ret, errno);
+			return ret;
+		}
+
 		ret = splice_to_pipe(ring, ctx);
 		if (ret) {
 			fprintf(stderr, "splice_to_pipe failed %i %i\n",
@@ -384,6 +411,13 @@ static int test_splice(struct io_uring *ring, struct test_ctx *ctx)
 	}
 
 	if (has_tee) {
+		ret = check_zero_tee(ring, ctx);
+		if (ret) {
+			fprintf(stderr, "check_zero_tee() failed %i %i\n",
+				ret, errno);
+			return ret;
+		}
+
 		ret = fail_tee_nonpipe(ring, ctx);
 		if (ret) {
 			fprintf(stderr, "fail_tee_nonpipe() failed %i %i\n",
-- 
2.24.0

