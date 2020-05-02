Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 965021C251C
	for <lists+io-uring@lfdr.de>; Sat,  2 May 2020 14:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727823AbgEBMMu (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 2 May 2020 08:12:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726896AbgEBMMu (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 2 May 2020 08:12:50 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AC87C061A0C
        for <io-uring@vger.kernel.org>; Sat,  2 May 2020 05:12:48 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id e26so2918505wmk.5
        for <io-uring@vger.kernel.org>; Sat, 02 May 2020 05:12:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=vkTGmnS77WOpDqCqjT7y5xGF7VvidShq+WTd0Oar2O8=;
        b=Hr6HPN/oHioW3/EGySPxx2Mbl+HahKTa32ikvZIs0JKCYJa0GKnLzVvrSt5TlY7lsa
         3VSP4o+0mQhDlYBcQtxx0s7lkzB/BUbZwyf69wcQn2NmvvAxjNfKlYvYryqxku4DP7PW
         5Xx4f4etrpeZO//T/WmFwqkT71022gGNs1XYfVp7suRREzLOxo/snQMeEmYY13KbQShE
         S7sp07tYdG7Beg3lXf4i6Rds8mhFuQfrYS1apivv9ibAAPnIZTkvH2Lc1UCoUjfZC3Lc
         moklwZ6Bx5sEyOxFM0G5sd5U1PS13sGb+sGQBMfY4ETgHYSM9mP86i20RtU7sIikHAUE
         Cdgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=vkTGmnS77WOpDqCqjT7y5xGF7VvidShq+WTd0Oar2O8=;
        b=BL7M8vXuI3IbyoKm/ZCCQAF2voZOOGa0vJ3fQTvAnrwmlg0h8uxm5wnzJen2H5vJCF
         pqZwnjbkIz/LEIcyIhijMSORKYgji4BIAUReHboBrXhFhJBH03E0SZDPpNkNlxJR6TqH
         3AG+/WSgFgEngiX4OzbJhDg9BnM7Se/oPuWUNv/sb3XLgRMlq4p12MYoFNDybZ9TPHec
         9+VtyV9r0rwLKUtacPObKgxXopzjatmXHZHCZWEU/J9j06QrAwGq3sCrjbYcV8sYIVEN
         CiG9IWZtZxZPmmKTT0kkZv+TPJPq9bKzO+OMcHIlBmZuV7fgXvqkrAaW93sqhQWtKv7S
         25Xg==
X-Gm-Message-State: AGi0PubvPptRyExXdhClMyU00Z3BNKlmHtN6Ibo61oNCcjQ4Cg8w6Ah5
        ZGkERxvI8/RgatQnEZt7Hffek3un
X-Google-Smtp-Source: APiQypKPhjsfkmGfh6GGrAR+Cy3mB5vieIHWrgUsrWkmzG5EPhWr/wpqb4iHod/ElCQUzSi2cCUHzw==
X-Received: by 2002:a1c:c302:: with SMTP id t2mr4554818wmf.85.1588421567194;
        Sat, 02 May 2020 05:12:47 -0700 (PDT)
Received: from localhost.localdomain ([109.126.133.135])
        by smtp.gmail.com with ESMTPSA id m188sm3993913wme.47.2020.05.02.05.12.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 02 May 2020 05:12:46 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        Clay Harris <bugs@claycon.org>
Subject: [PATCH liburing 3/3] tee/test: add test for tee(2)
Date:   Sat,  2 May 2020 15:11:29 +0300
Message-Id: <0c63f91aa48ef8da42f995028c122445cf610c3c.1588421430.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1588421430.git.asml.silence@gmail.com>
References: <cover.1588421430.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add tee() tests with pipe data validation

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/splice.c | 184 ++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 157 insertions(+), 27 deletions(-)

diff --git a/test/splice.c b/test/splice.c
index 50a1feb..b084d04 100644
--- a/test/splice.c
+++ b/test/splice.c
@@ -29,6 +29,8 @@ struct test_ctx {
 static int splice_flags = 0;
 static int sqe_flags = 0;
 static int no_op = 0;
+static int has_splice = 0;
+static int has_tee = 0;
 
 static int read_buf(int fd, void *buf, int len)
 {
@@ -133,10 +135,11 @@ static int init_splice_ctx(struct test_ctx *ctx)
 	return 0;
 }
 
-static int do_splice(struct io_uring *ring,
-			   int fd_in, loff_t off_in,
-			   int fd_out, loff_t off_out,
-			   unsigned int len)
+static int do_splice_op(struct io_uring *ring,
+			int fd_in, loff_t off_in,
+			int fd_out, loff_t off_out,
+			unsigned int len,
+			__u8 opcode)
 {
 	struct io_uring_cqe *cqe;
 	struct io_uring_sqe *sqe;
@@ -152,6 +155,7 @@ static int do_splice(struct io_uring *ring,
 				     len, splice_flags);
 		sqe->flags |= sqe_flags;
 		sqe->user_data = 42;
+		sqe->opcode = opcode;
 
 		ret = io_uring_submit(ring);
 		if (ret != 1) {
@@ -183,18 +187,59 @@ static int do_splice(struct io_uring *ring,
 	return 0;
 }
 
-static int check_splice(struct io_uring *ring, struct test_ctx *ctx)
+static int do_splice(struct io_uring *ring,
+			int fd_in, loff_t off_in,
+			int fd_out, loff_t off_out,
+			unsigned int len)
+{
+	return do_splice_op(ring, fd_in, off_in, fd_out, off_out, len,
+			    IORING_OP_SPLICE);
+}
+
+static int do_tee(struct io_uring *ring,
+		  int fd_in, loff_t off_in,
+		  int fd_out, loff_t off_out,
+		  unsigned int len)
+{
+	if (off_in == -1)
+		off_in = 0;
+	if (off_out == -1)
+		off_out = 0;
+
+	return do_splice_op(ring, fd_in, off_in, fd_out, off_out, len,
+			    IORING_OP_TEE);
+}
+
+static void check_splice_support(struct io_uring *ring, struct test_ctx *ctx)
 {
 	int fds[2];
 
 	if (pipe(fds) < 0)
-		return -1;
+		return;
 
 	no_op = 0;
 	do_splice(ring, ctx->fd_in, 0, fds[1], -1, BUF_SIZE);
 	close(fds[0]);
 	close(fds[1]);
-	return no_op;
+	has_splice = !no_op;
+}
+
+static void check_tee_support(struct io_uring *ring, struct test_ctx *ctx)
+{
+	int pipe1[2], pipe2[2];
+
+	if (pipe(pipe1) < 0)
+		return;
+	if (pipe(pipe2) < 0)
+		return;
+
+	no_op = 0;
+	do_tee(ring, pipe1[0], -1, pipe2[1], -1, 0);
+	close(pipe1[0]);
+	close(pipe1[1]);
+	close(pipe2[0]);
+	close(pipe2[1]);
+	has_tee = !no_op;
 }
 
 static int splice_to_pipe(struct io_uring *ring, struct test_ctx *ctx)
@@ -275,37 +320,120 @@ static int fail_splice_pipe_offset(struct io_uring *ring, struct test_ctx *ctx)
 	return 0;
 }
 
-static int test_splice(struct io_uring *ring, struct test_ctx *ctx)
+static int fail_tee_with_file(struct io_uring *ring, struct test_ctx *ctx)
 {
 	int ret;
 
-	ret = splice_to_pipe(ring, ctx);
-	if (ret) {
-		fprintf(stderr, "splice_to_pipe failed %i %i\n",
-			ret, errno);
+	ret = do_tee(ring, ctx->fd_in, 0, ctx->pipe1[1], 0, BUF_SIZE);
+	if (ret != -ESPIPE && ret != -EINVAL)
 		return ret;
-	}
 
-	ret = splice_from_pipe(ring, ctx);
-	if (ret) {
-		fprintf(stderr, "splice_from_pipe failed %i %i\n",
-			ret, errno);
+	return 0;
+}
+
+static int fail_tee_offset(struct io_uring *ring, struct test_ctx *ctx)
+{
+	int ret;
+
+	ret = do_splice_op(ring, ctx->pipe2[0], -1, ctx->pipe1[1], 0,
+			   BUF_SIZE, IORING_OP_TEE);
+	if (ret != -ESPIPE && ret != -EINVAL)
 		return ret;
-	}
 
-	ret = splice_pipe_to_pipe(ring, ctx);
+	ret = do_splice_op(ring, ctx->pipe2[0], 0, ctx->pipe1[1], -1,
+			   BUF_SIZE, IORING_OP_TEE);
+	if (ret != -ESPIPE && ret != -EINVAL)
+		return ret;
+
+	return 0;
+}
+
+static int check_tee(struct io_uring *ring, struct test_ctx *ctx)
+{
+	int ret;
+
+	ret = write_buf(ctx->real_pipe1[1], ctx->buf_in, BUF_SIZE);
+	if (ret)
+		return ret;
+	ret = do_tee(ring, ctx->pipe1[0], -1, ctx->pipe2[1], -1, BUF_SIZE);
+	if (ret)
+		return ret;
+
+	ret = check_content(ctx->real_pipe1[0], ctx->buf_out, BUF_SIZE,
+				ctx->buf_in);
 	if (ret) {
-		fprintf(stderr, "splice_pipe_to_pipe failed %i %i\n",
-			ret, errno);
+		fprintf(stderr, "tee(), invalid src data\n");
 		return ret;
 	}
 
-	ret = fail_splice_pipe_offset(ring, ctx);
+	ret = check_content(ctx->real_pipe2[0], ctx->buf_out, BUF_SIZE,
+				ctx->buf_in);
 	if (ret) {
-		fprintf(stderr, "fail_splice_pipe_offset failed %i %i\n",
-			ret, errno);
+		fprintf(stderr, "tee(), invalid dst data\n");
 		return ret;
 	}
+
+	return 0;
+}
+
+
+static int test_splice(struct io_uring *ring, struct test_ctx *ctx)
+{
+	int ret;
+
+	if (has_splice) {
+		ret = splice_to_pipe(ring, ctx);
+		if (ret) {
+			fprintf(stderr, "splice_to_pipe failed %i %i\n",
+				ret, errno);
+			return ret;
+		}
+
+		ret = splice_from_pipe(ring, ctx);
+		if (ret) {
+			fprintf(stderr, "splice_from_pipe failed %i %i\n",
+				ret, errno);
+			return ret;
+		}
+
+		ret = splice_pipe_to_pipe(ring, ctx);
+		if (ret) {
+			fprintf(stderr, "splice_pipe_to_pipe failed %i %i\n",
+				ret, errno);
+			return ret;
+		}
+
+		ret = fail_splice_pipe_offset(ring, ctx);
+		if (ret) {
+			fprintf(stderr, "fail_splice_pipe_offset failed %i %i\n",
+				ret, errno);
+			return ret;
+		}
+	}
+
+	if (has_tee) {
+		ret = fail_tee_with_file(ring, ctx);
+		if (ret) {
+			fprintf(stderr, "fail_tee_with_file() failed %i %i\n",
+				ret, errno);
+			return ret;
+		}
+
+		ret = fail_tee_offset(ring, ctx);
+		if (ret) {
+			fprintf(stderr, "fail_tee_offset failed %i %i\n",
+				ret, errno);
+			return ret;
+		}
+
+		ret = check_tee(ring, ctx);
+		if (ret) {
+			fprintf(stderr, "check_tee() failed %i %i\n",
+				ret, errno);
+			return ret;
+		}
+	}
+
 	return 0;
 }
 
@@ -328,10 +456,12 @@ int main(int argc, char *argv[])
 		return 1;
 	}
 
-	if (check_splice(&ring, &ctx)) {
+	check_splice_support(&ring, &ctx);
+	if (!has_splice)
 		fprintf(stdout, "skip, doesn't support splice()\n");
-		return 0;
-	}
+	check_tee_support(&ring, &ctx);
+	if (!has_tee)
+		fprintf(stdout, "skip, doesn't support tee()\n");
 
 	ret = test_splice(&ring, &ctx);
 	if (ret) {
-- 
2.24.0

