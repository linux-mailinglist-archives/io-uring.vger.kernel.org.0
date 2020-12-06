Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA0F12D04F4
	for <lists+io-uring@lfdr.de>; Sun,  6 Dec 2020 13:55:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727913AbgLFMzb (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 6 Dec 2020 07:55:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727842AbgLFMzb (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 6 Dec 2020 07:55:31 -0500
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFF94C0613D2
        for <io-uring@vger.kernel.org>; Sun,  6 Dec 2020 04:54:50 -0800 (PST)
Received: by mail-wm1-x343.google.com with SMTP id v14so9187791wml.1
        for <io-uring@vger.kernel.org>; Sun, 06 Dec 2020 04:54:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=9Dn9fInW1VQlGPkDB3M7Gdu/+WCYhOZgBg2jBP8ezws=;
        b=eDUK0ziwHFpaet4XyaYHT8iAwewxgpv8iafqE54jQy8VBo78WRtNTrHh3IdmKEMJGH
         I38HlPHPY0naTOKFE8mwKXeziBKZSciwXnZPx+YV0b6SNuIF/nZ7emPHPFj6d8Ckce1N
         esR3gDbOo2cQD3CyabCzU1oQ1jA1BGrKoD1XwjWskHUSRoIRc+yZuUW79u6lmZ9ms+ok
         Oyo5rVha07LXBILM0YQOwb+WjqfGjjKKnmQB0iQwrS/qrPq2tRl6MUJiLxwVEzUNv7FU
         WUhDpLcHN6wyV5MijUm+ZeA6qhGu0Imf8plXd/2cSZ35MZ9MjMD2rsBoJ2be+0Jez8GR
         julQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=9Dn9fInW1VQlGPkDB3M7Gdu/+WCYhOZgBg2jBP8ezws=;
        b=aNCS4Jn7DtBLKMVCbzG3ae5N+rM+qT2b8B/FVWomHPvjHj+eMMBDoSX5X0NBd+9XBW
         pHoKQMn/kgTPXnXxfh5W1fcddUt+Pc8UFbgNwoCT1wpZW3ZLV2K/KFf7VETbrp1kCFm4
         wo43aigH6Mxq9XITaI6nligI5jvNkM+f6HfZbLxHQxWPF328iyLM2NNDLynWCGrMGh86
         wRIposig1TV62XPwaf9JORRWc1PK4WB192Gu83w6Pp3snF5GtLFPrywdjh59Uco+T+P6
         9PbnuwBPuV+4iKojSGPhfpl51jtXj7y+Rpdx6eO8HFqb9IeyCoXphYTIjUJiNx/tsOAs
         gB7A==
X-Gm-Message-State: AOAM5317IdWN9DrkIFs1mtdeSAZKuh12+1CYKcexfqnuLS/wHKKfC16A
        JLR8tzHhrL7hwq2XF/tx2jw=
X-Google-Smtp-Source: ABdhPJxED3Ad5nn1CueB76HR4cbCbJavdVt96DpE0f1o5cPkkzC2Yd2FSzCHQUbmEdGr/WnA8+5aog==
X-Received: by 2002:a1c:e084:: with SMTP id x126mr13558604wmg.109.1607259289554;
        Sun, 06 Dec 2020 04:54:49 -0800 (PST)
Received: from localhost.localdomain ([185.69.145.45])
        by smtp.gmail.com with ESMTPSA id j14sm10590632wrs.49.2020.12.06.04.54.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Dec 2020 04:54:49 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH liburing 2/3] test/rw: remove not used mixed_fixed flag
Date:   Sun,  6 Dec 2020 12:51:22 +0000
Message-Id: <6b50a177a1c89d1917a0dd857210cf28a441c1a2.1607258973.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1607258973.git.asml.silence@gmail.com>
References: <cover.1607258973.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

mixed_fixed is not used, kill it

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 test/read-write.c | 37 +++++++++++++++----------------------
 1 file changed, 15 insertions(+), 22 deletions(-)

diff --git a/test/read-write.c b/test/read-write.c
index d47bebb..2399c32 100644
--- a/test/read-write.c
+++ b/test/read-write.c
@@ -56,8 +56,8 @@ static int create_file(const char *file)
 	return ret != FILE_SIZE;
 }
 
-static int __test_io(const char *file, struct io_uring *ring, int write, int buffered,
-		     int sqthread, int fixed, int mixed_fixed, int nonvec,
+static int __test_io(const char *file, struct io_uring *ring, int write,
+		     int buffered, int sqthread, int fixed, int nonvec,
 		     int buf_select, int seq, int exp_len)
 {
 	struct io_uring_sqe *sqe;
@@ -67,10 +67,9 @@ static int __test_io(const char *file, struct io_uring *ring, int write, int buf
 	off_t offset;
 
 #ifdef VERBOSE
-	fprintf(stdout, "%s: start %d/%d/%d/%d/%d/%d: ", __FUNCTION__, write,
+	fprintf(stdout, "%s: start %d/%d/%d/%d/%d: ", __FUNCTION__, write,
 							buffered, sqthread,
-							fixed, mixed_fixed,
-							nonvec);
+							fixed, nonvec);
 #endif
 	if (sqthread && geteuid()) {
 #ifdef VERBOSE
@@ -239,7 +238,7 @@ err:
 	return 1;
 }
 static int test_io(const char *file, int write, int buffered, int sqthread,
-		   int fixed, int mixed_fixed, int nonvec)
+		   int fixed, int nonvec)
 {
 	struct io_uring ring;
 	int ret, ring_flags;
@@ -263,8 +262,8 @@ static int test_io(const char *file, int write, int buffered, int sqthread,
 		return 1;
 	}
 
-	ret = __test_io(file, &ring, write, buffered, sqthread, fixed,
-			mixed_fixed, nonvec, 0, 0, BS);
+	ret = __test_io(file, &ring, write, buffered, sqthread, fixed, nonvec,
+			0, 0, BS);
 
 	io_uring_queue_exit(&ring);
 	return ret;
@@ -442,7 +441,7 @@ static int test_buf_select_short(const char *filename, int nonvec)
 		io_uring_cqe_seen(&ring, cqe);
 	}
 
-	ret = __test_io(filename, &ring, 0, 0, 0, 0, 0, nonvec, 1, 1, exp_len);
+	ret = __test_io(filename, &ring, 0, 0, 0, 0, nonvec, 1, 1, exp_len);
 
 	io_uring_queue_exit(&ring);
 	return ret;
@@ -476,7 +475,7 @@ static int test_buf_select(const char *filename, int nonvec)
 	for (i = 0; i < BUFFERS; i++)
 		memset(vecs[i].iov_base, i, vecs[i].iov_len);
 
-	ret = __test_io(filename, &ring, 1, 0, 0, 0, 0, 0, 0, 1, BS);
+	ret = __test_io(filename, &ring, 1, 0, 0, 0, 0, 0, 1, BS);
 	if (ret) {
 		fprintf(stderr, "failed writing data\n");
 		return 1;
@@ -506,7 +505,7 @@ static int test_buf_select(const char *filename, int nonvec)
 		io_uring_cqe_seen(&ring, cqe);
 	}
 
-	ret = __test_io(filename, &ring, 0, 0, 0, 0, 0, nonvec, 1, 1, BS);
+	ret = __test_io(filename, &ring, 0, 0, 0, 0, nonvec, 1, 1, BS);
 
 	io_uring_queue_exit(&ring);
 	return ret;
@@ -690,25 +689,19 @@ int main(int argc, char *argv[])
 	}
 
 	/* if we don't have nonvec read, skip testing that */
-	if (has_nonvec_read())
-		nr = 64;
-	else
-		nr = 32;
+	nr = has_nonvec_read() ? 32 : 16;
 
 	for (i = 0; i < nr; i++) {
 		int write = (i & 1) != 0;
 		int buffered = (i & 2) != 0;
 		int sqthread = (i & 4) != 0;
 		int fixed = (i & 8) != 0;
-		int mixed_fixed = (i & 16) != 0;
-		int nonvec = (i & 32) != 0;
+		int nonvec = (i & 16) != 0;
 
-		ret = test_io(fname, write, buffered, sqthread, fixed,
-			      mixed_fixed, nonvec);
+		ret = test_io(fname, write, buffered, sqthread, fixed, nonvec);
 		if (ret) {
-			fprintf(stderr, "test_io failed %d/%d/%d/%d/%d/%d\n",
-					write, buffered, sqthread, fixed,
-					mixed_fixed, nonvec);
+			fprintf(stderr, "test_io failed %d/%d/%d/%d/%d\n",
+				write, buffered, sqthread, fixed, nonvec);
 			goto err;
 		}
 	}
-- 
2.24.0

