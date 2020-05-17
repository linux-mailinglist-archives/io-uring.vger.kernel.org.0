Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 60E941D67B4
	for <lists+io-uring@lfdr.de>; Sun, 17 May 2020 13:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727858AbgEQLZX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 17 May 2020 07:25:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728017AbgEQLZW (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 17 May 2020 07:25:22 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B617AC061A0C;
        Sun, 17 May 2020 04:25:21 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id e25so6791603ljg.5;
        Sun, 17 May 2020 04:25:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=o+pYbkSn3ITUthgP/O/KucA2is0ByK/CaUJUxW9cNOA=;
        b=neWHPpbMKoRjDFp23DjqEa9L7JhFPy6+VKxiV4A/WGtaE4EIDT4GFK2Iy0KT/RzVK9
         NmEZH9n5vXBY6bvwnEg/554CnCZZlylID1f3jG71JjOXiBFm9dvZXIv+mx73/50DTXV9
         4SqHZhjwL6CuegBYAKuGm/MRfqhbtUfaW0pjqdtjtjfJaduKRWDqT+zK9xYK24qcKMqt
         2tDhOPQqe0t39qcaBOLs9yI1dGeY0WIYkG3Nr+j9KZQYzGX6g8qbsAoJV+CHcdHmSTys
         VZeAfu1sFD1UIHc6w4qxpnOBcKNORw/MlVHyESMWIRKaeYf7g+ymILtoebEpicApHfPJ
         xBDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=o+pYbkSn3ITUthgP/O/KucA2is0ByK/CaUJUxW9cNOA=;
        b=FjYJ6U/bGRTQUIFv+ZziPMYvErQXp2EosumTDtYH6yPhXM/vMk03ktPeQmMXG0PVHz
         dgw0KIjsETCIPdHKF5fUuILwoNBwQlT9SVei3z/FGxLKmD5hTk4MuUopfF45+0SznkeU
         fbZ8pd1GRKffRICjSe7nqtyBqwn9UXRTSZs4vmYqS34cRtXlEYEt8k522+jmTJtVvfW6
         FQg5DsM9JCzxjNywB5NFmEE9B2Mkxh/21eVB353CsbSWQFnjHjsdqFVWTh6nWyQA8i3s
         uIhwAcY4+o5nManKMs3ApXd4API404ZWsZv/6cOTZiE+65zuNcp0keCAgyJnOjNYkSAD
         7SRw==
X-Gm-Message-State: AOAM531VYL9cFfat+nmk76q1pT+ZuyFzrL8+4pMWKNPm1HHcaS2DlAPa
        rEK92w8z7Pn8F3FNRDmJIec=
X-Google-Smtp-Source: ABdhPJxfQ6+3bm+9B4o54aWodreBnrgnHny/xfFLCZ/woMKbSGL5YjwU3y2FqmcMey4wemmUk1gpuQ==
X-Received: by 2002:a2e:700b:: with SMTP id l11mr7580788ljc.255.1589714720157;
        Sun, 17 May 2020 04:25:20 -0700 (PDT)
Received: from localhost.localdomain ([82.209.196.123])
        by smtp.gmail.com with ESMTPSA id c78sm5639828lfd.63.2020.05.17.04.25.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 17 May 2020 04:25:19 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH liburing 3/4] tee/test: add test for tee(2)
Date:   Sun, 17 May 2020 14:23:46 +0300
Message-Id: <3e3470d8699fa9a3cab1983d4f88658cc8f8432a.1589714504.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1589714504.git.asml.silence@gmail.com>
References: <cover.1589714504.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

Add tee() tests with pipe data validation

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/splice.c | 157 ++++++++++++++++++++++++++++++++++++++++++--------
 1 file changed, 133 insertions(+), 24 deletions(-)

diff --git a/test/splice.c b/test/splice.c
index 1c27c8e..119c493 100644
--- a/test/splice.c
+++ b/test/splice.c
@@ -29,6 +29,7 @@ struct test_ctx {
 static unsigned int splice_flags = 0;
 static unsigned int sqe_flags = 0;
 static int has_splice = 0;
+static int has_tee = 0;
 
 static int read_buf(int fd, void *buf, int len)
 {
@@ -133,10 +134,11 @@ static int init_splice_ctx(struct test_ctx *ctx)
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
@@ -152,6 +154,7 @@ static int do_splice(struct io_uring *ring,
 				     len, splice_flags);
 		sqe->flags |= sqe_flags;
 		sqe->user_data = 42;
+		sqe->opcode = opcode;
 
 		ret = io_uring_submit(ring);
 		if (ret != 1) {
@@ -181,6 +184,21 @@ static int do_splice(struct io_uring *ring,
 	return 0;
 }
 
+static int do_splice(struct io_uring *ring,
+			int fd_in, loff_t off_in,
+			int fd_out, loff_t off_out,
+			unsigned int len)
+{
+	return do_splice_op(ring, fd_in, off_in, fd_out, off_out, len,
+			    IORING_OP_SPLICE);
+}
+
+static int do_tee(struct io_uring *ring, int fd_in, int fd_out, 
+		  unsigned int len)
+{
+	return do_splice_op(ring, fd_in, 0, fd_out, 0, len, IORING_OP_TEE);
+}
+
 static void check_splice_support(struct io_uring *ring, struct test_ctx *ctx)
 {
 	int ret;
@@ -189,6 +207,14 @@ static void check_splice_support(struct io_uring *ring, struct test_ctx *ctx)
 	has_splice = (ret == -EBADF);
 }
 
+static void check_tee_support(struct io_uring *ring, struct test_ctx *ctx)
+{
+	int ret;
+
+	ret = do_tee(ring, -1, -1, BUF_SIZE);
+	has_tee = (ret == -EBADF);
+}
+
 static int splice_to_pipe(struct io_uring *ring, struct test_ctx *ctx)
 {
 	int ret;
@@ -267,37 +293,119 @@ static int fail_splice_pipe_offset(struct io_uring *ring, struct test_ctx *ctx)
 	return 0;
 }
 
-static int test_splice(struct io_uring *ring, struct test_ctx *ctx)
+static int fail_tee_nonpipe(struct io_uring *ring, struct test_ctx *ctx)
 {
 	int ret;
 
-	ret = splice_to_pipe(ring, ctx);
-	if (ret) {
-		fprintf(stderr, "splice_to_pipe failed %i %i\n",
-			ret, errno);
+	ret = do_tee(ring, ctx->fd_in, ctx->pipe1[1], BUF_SIZE);
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
+		return ret;
+
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
+	ret = do_tee(ring, ctx->pipe1[0], ctx->pipe2[1], BUF_SIZE);
+	if (ret)
 		return ret;
-	}
 
-	ret = splice_pipe_to_pipe(ring, ctx);
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
+		ret = fail_tee_nonpipe(ring, ctx);
+		if (ret) {
+			fprintf(stderr, "fail_tee_nonpipe() failed %i %i\n",
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
 
@@ -321,10 +429,11 @@ int main(int argc, char *argv[])
 	}
 
 	check_splice_support(&ring, &ctx);
-	if (!has_splice) {
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

