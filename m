Return-Path: <io-uring+bounces-8105-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 9245BAC3AA9
	for <lists+io-uring@lfdr.de>; Mon, 26 May 2025 09:31:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 155C71894DAA
	for <lists+io-uring@lfdr.de>; Mon, 26 May 2025 07:31:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 645AA1DF990;
	Mon, 26 May 2025 07:31:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gcaAxGJY"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ADD61876
	for <io-uring@vger.kernel.org>; Mon, 26 May 2025 07:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748244687; cv=none; b=L0wdrt6l2oYPS/a2ZiUJGW98AB0XgifxvIySdXNyOYiZegQ9ATAtEatfyNFmE72mRMxc7dgHt+2pg4ox7JmhfLv78xhHeB1DTc9e1FnQyknoIiox/3Caf6uUcJjfreRt0PRx1ShP9Nre1PIR7nvlt8sTrcOHeTadnYNrnGQa7Do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748244687; c=relaxed/simple;
	bh=OsMrzxwrIa9RiA/xJDMU4JLeIaGeS3vdYPlJwbJDQm4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z4FidOM5wQIZN7UdlK9S39RMtLzSqd8NwzUe0PHJswRigIMSPnyvc+VXozVVPejStRjfjquO7UbsjZs2DmNjd7Viyci3y2huXVidR8vHfNOcaIdvi39ICPrmsN+01kXf2GWrL8oSWKGVZzaN/vcEv9RQytew3Cob8BWnbgfL1v8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gcaAxGJY; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-acacb8743a7so362871466b.1
        for <io-uring@vger.kernel.org>; Mon, 26 May 2025 00:31:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748244683; x=1748849483; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yJssw0pNnyo1E63xpgw3M3NlpEWxzrnqeMBA/eWMmLk=;
        b=gcaAxGJYvRr9EcaYwa7rCfr5wk4wcLRHIZ8c+rC37J5Tx6eJFUeYq7y3GHwfQQ9Eyn
         7FCSasZgVODoj5Nr7jrMwQgzD660FA+5E3IHKI6A+/IO3M2jlqJzN1z0tnL0M3Gul+QP
         +YZws8E5S8qua5e/6Epe6PkNQVdFUiaRvebk6+7xH4cBBmDunXhEEpQ6Ww2vgCozK7iM
         1Y36tSu8jwokmZ9TeD95Z3Y8tF68xZ8/Bekebkv727xp7wpvkQqjERZz6q3gUavBCUZS
         +0PYrKWmEmionxIOqvCuVVFacKfI/Ep7nB5xN1rnBopB61CpsrKL6iVZZcphItxZqfdU
         KnUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748244683; x=1748849483;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yJssw0pNnyo1E63xpgw3M3NlpEWxzrnqeMBA/eWMmLk=;
        b=WJAwVjeQghPFn8CxMxI+v+3f/xNlpsUP8V7D8h4EC2bP4/wjRMHsJ2YqIYbCJtokjz
         iZGhDX9OTtF6IWXCLaLcLU70vHjlbQGFciiKT4/qFiFnwuZA/0AgbJ3hJai0OCMTW6zi
         CfQrK/qsM+zFQrXmjlkGbwS/DMe318WBryXEJ1MF6wSjNY7vW2SSinLEpBeUbgsw623X
         DFbfkdTNwRnKJeBcgSohktLWun37TGuO+6x7NLSmSHtDYags11lgj9NsBKb4J+Jnq4Lq
         GxiCfT9N54YWtvLk0pXgHI2he4++Y6zdP2m6n9z/kE37yNWuwtIs4HajtWsIYv0N/MYU
         FDQg==
X-Gm-Message-State: AOJu0YxYFvdHRNXNlRKPITJK7DfY3tz2gIYb/zI4wX7a7aRd8miV7XCO
	Jc2tdB48b9l812wymt+jdIGSSByKam0gcl69OOGGqvu6YYI8DMQJaFo18fKo5g==
X-Gm-Gg: ASbGncvinCu1XBdz4RYC8nEix8nOU8ExcYDQxanSQegN5BMjQk/87QkEuQT31yuboDS
	eg9ih3KOzb5AeVNUgnLo1sAzSuXLL0JyBCc6eLWfXvMfACZIJgdHBJpLiBGWO6tE00Cuegdpfpc
	3+WOD4Mvn7Y0rIamOXMfK8UPpJMlbOvPchQ4c+U17MO9Dsh+nAc7Rtnt7jB2rIoyL6MtU0EpCUh
	EcBgJyzA7FeZSOjjpCabZentFN8fHQHiDldEHm8U0ImiuZEgYFEmsUSZVHlB/Ij9x++N5yp8QAR
	d1z5pabxXZ7m8fHxsYuJm9ylrbejVHpuElRsKFGw08viQ5W+Qdqi/GEv8RY4/jRw
X-Google-Smtp-Source: AGHT+IH/aEYHOwjA8VMlJqHLHVXEvcs+tERBpH+dR1RfnUtX+VE/yBpPWADPT++BZX3gmYgur/H2Qw==
X-Received: by 2002:a17:907:9412:b0:ad5:5086:c2c7 with SMTP id a640c23a62f3a-ad64dc76264mr1111478666b.15.1748244683085;
        Mon, 26 May 2025 00:31:23 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.132.24])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad8816eb7e3sm12395166b.50.2025.05.26.00.31.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 May 2025 00:31:22 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	chase xd <sl1589472800@gmail.com>
Subject: [PATCH v2 2/6] io_uring/mock: add cmd using vectored regbufs
Date: Mon, 26 May 2025 08:32:24 +0100
Message-ID: <fcad3a40b1a2f6016a4abf60978297992036f857.1748243323.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1748243323.git.asml.silence@gmail.com>
References: <cover.1748243323.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

There is a command api allowing to import vectored registered buffers,
add a new mock command that uses the feature and simply copies the
specified registered buffer into user space or vice versa.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/mock_file.c | 70 +++++++++++++++++++++++++++++++++++++++++++-
 io_uring/mock_file.h | 14 +++++++++
 2 files changed, 83 insertions(+), 1 deletion(-)

diff --git a/io_uring/mock_file.c b/io_uring/mock_file.c
index e8ec0aeddbae..6d6100052a26 100644
--- a/io_uring/mock_file.c
+++ b/io_uring/mock_file.c
@@ -9,8 +9,76 @@
 #include <linux/io_uring_types.h>
 #include "mock_file.h"
 
+#define IO_VALID_COPY_CMD_FLAGS		IORING_MOCK_COPY_FROM
+
+static int io_copy_regbuf(struct iov_iter *reg_iter, void __user *ubuf)
+{
+	size_t ret, copied = 0;
+	size_t buflen = PAGE_SIZE;
+	void *tmp_buf;
+
+	tmp_buf = kzalloc(buflen, GFP_KERNEL);
+	if (!tmp_buf)
+		return -ENOMEM;
+
+	while (iov_iter_count(reg_iter)) {
+		size_t len = min(iov_iter_count(reg_iter), buflen);
+
+		if (iov_iter_rw(reg_iter) == ITER_SOURCE) {
+			ret = copy_from_iter(tmp_buf, len, reg_iter);
+			if (ret <= 0)
+				break;
+			if (copy_to_user(ubuf, tmp_buf, ret))
+				break;
+		} else {
+			if (copy_from_user(tmp_buf, ubuf, len))
+				break;
+			ret = copy_to_iter(tmp_buf, len, reg_iter);
+			if (ret <= 0)
+				break;
+		}
+		ubuf += ret;
+		copied += ret;
+	}
+
+	kfree(tmp_buf);
+	return copied;
+}
+
+static int io_cmd_copy_regbuf(struct io_uring_cmd *cmd, unsigned int issue_flags)
+{
+	const struct io_uring_sqe *sqe = cmd->sqe;
+	const struct iovec __user *iovec;
+	unsigned flags, iovec_len;
+	struct iov_iter iter;
+	void __user *ubuf;
+	int dir, ret;
+
+	ubuf = u64_to_user_ptr(READ_ONCE(sqe->addr3));
+	iovec = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	iovec_len = READ_ONCE(sqe->len);
+	flags = READ_ONCE(sqe->file_index);
+
+	if (unlikely(sqe->ioprio || sqe->__pad1))
+		return -EINVAL;
+	if (flags & ~IO_VALID_COPY_CMD_FLAGS)
+		return -EINVAL;
+
+	dir = (flags & IORING_MOCK_COPY_FROM) ? ITER_SOURCE : ITER_DEST;
+	ret = io_uring_cmd_import_fixed_vec(cmd, iovec, iovec_len, dir, &iter,
+					    issue_flags);
+	if (ret)
+		return ret;
+	ret = io_copy_regbuf(&iter, ubuf);
+	return ret ? ret : -EFAULT;
+}
+
 static int io_mock_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 {
+	switch (cmd->cmd_op) {
+	case IORING_MOCK_CMD_COPY_REGBUF:
+		return io_cmd_copy_regbuf(cmd, issue_flags);
+	}
 	return -ENOTSUPP;
 }
 
@@ -85,7 +153,7 @@ static int io_probe_mock(struct io_uring_cmd *cmd)
 	if (!mem_is_zero(&mp, sizeof(mp)))
 		return -EINVAL;
 
-	mp.features = 0;
+	mp.features = IORING_MOCK_FEAT_END;
 
 	if (copy_to_user(uarg, &mp, uarg_size))
 		return -EFAULT;
diff --git a/io_uring/mock_file.h b/io_uring/mock_file.h
index de7318a5b1f1..0833eb7af1ac 100644
--- a/io_uring/mock_file.h
+++ b/io_uring/mock_file.h
@@ -3,6 +3,12 @@
 
 #include <linux/types.h>
 
+enum {
+	IORING_MOCK_FEAT_CMD_COPY,
+
+	IORING_MOCK_FEAT_END,
+};
+
 struct io_uring_mock_probe {
 	__u64		features;
 	__u64		__resv[9];
@@ -19,4 +25,12 @@ enum {
 	IORING_MOCK_MGR_CMD_CREATE,
 };
 
+enum {
+	IORING_MOCK_CMD_COPY_REGBUF,
+};
+
+enum {
+	IORING_MOCK_COPY_FROM			= 1,
+};
+
 #endif
\ No newline at end of file
-- 
2.49.0


