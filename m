Return-Path: <io-uring+bounces-8538-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 93B36AEE698
	for <lists+io-uring@lfdr.de>; Mon, 30 Jun 2025 20:15:47 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id CA47B17CEAF
	for <lists+io-uring@lfdr.de>; Mon, 30 Jun 2025 18:15:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3269C2F4A;
	Mon, 30 Jun 2025 18:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jeHZvYu6"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C620190462
	for <io-uring@vger.kernel.org>; Mon, 30 Jun 2025 18:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751307341; cv=none; b=oOQIV2n3dRJidBDcJwFLSN/jdj+g0R0shA8A5JAwkIuAE5IoZB9jFC5CEpzvIyXTjQ7aa1oc0fYgYkKGw+lf4LwLPIRRXD1JHAtjSmdwzTN0QsIw5LfYWpkaWywgjWiR+XFzJkbQgR7jaHYIeVU5mipZGrVBSiUuR9BnVX+PIuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751307341; c=relaxed/simple;
	bh=k4M4YypDDrgvQE0LPosViMqvUCEzPaO8Y/7HJgkaJ8g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E7U6qt3XydNk64MD1rJUh2ynBUX2iGpdR/yfk2pUmgdJDHzFAJWXpJ/KF40bPehLqcOXyJnEH2IlweF03Q/nPHdErWIBtExi15xqUX7EHofPX35GLpMyESfEdeNOzwPde9XZLjUkY1DgCqg6mrq4CahmmDmFBaC1JnwkMxuPus8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jeHZvYu6; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-742c7a52e97so4941114b3a.3
        for <io-uring@vger.kernel.org>; Mon, 30 Jun 2025 11:15:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751307339; x=1751912139; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AS/cmnQ5iLhMyfVjpuC9oaO2x1Z2tKkvk5UY60TNuPw=;
        b=jeHZvYu6bDgeH87zBtW4EXHNzptKUBRVdJIl/D2c1xh3FuCGtKxjUP8L729DobkIU/
         3GgTe/90hxTdf4x7uVQOU9YN8SLmVD6fp9TmEjTlM2cAMm4mPClCkYnF3idSp4MK67IN
         1++KMJf6RJNGiu+ucv1qW2bxxnM8c2ZtwRoVk0hb9dVQyb4JkAFo7sbZbvTmK1Tk5EFD
         gVqF9nhKLn3baBv+B6xHoeEmDEXXyLSkQtzWh97Tt3pYoJTc8qRYJfhjSvrcr4mktpUc
         QvhAHbD7x3jqqseym78cM/5TpZkhZYYqKtOW80WzWzOabv/fzvKbggs0kShTOSZpdtsh
         jajg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751307339; x=1751912139;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=AS/cmnQ5iLhMyfVjpuC9oaO2x1Z2tKkvk5UY60TNuPw=;
        b=CjRBHlK2rT8oGP6wXHCCkkmPupYP/Aw6VD+e5QgBIPnFltwW+PPznu2drlw3BMI9iX
         unaBlvtZxDzXFtQ4xkmTjMRV5nkj+pdUha5c3mnhMPpGYFUaoWoav5isFplCGmljXRbH
         MnkbA3oM7sL8DeWFFxQOABpXsx285sTQLBuJskD1D1Bd8zTF9ozFFxN0G07GlClVAr9x
         2Dsi9AYqUT/2Mtt3hTAB1YcNuv0/thMYx95FV1A/GMwRIJdWrP0idXgVxf3MMN3515KM
         U7Wma33BIsiMXDqKEbiZsmgVv93InhYSqt/tQZxHTQU6QSnPMyBpF/fCF/N5rzwYC42+
         EBrw==
X-Gm-Message-State: AOJu0YygwHcfo1f4DWh5OYj2gGEAEkaqPrYYLp/5N7BYI0SzXtprOm9s
	TUcVHDDrPfoWMHpbUUuty3Yn8dAfgYNX03wNdikVojvzUFdoeM0H1tZVBVkyYtkx
X-Gm-Gg: ASbGncsWUWQPwC5pxebVZmFHHCR5c/ykHKB4neeS3pqzQgLLRHjMcGCYJQWmAiqzJCF
	K6YO3/GiZK84MM+/WGO1qgvT3Wv9yo/66hz+GIJZS7ssB+Ujbd3UpXNM/WMc3e7j02LCCpcLEuy
	LHRccK32ua8NcK3NXFFFG3KocNkPWZFqjsBMN3ofOAPD8P/vuhNeEh/h/PLPGYnSSwFKrp3VQD3
	dtOR6M7tT61UBJQxrJYLCgayznZ0a46K4U6UqlFP5B46KzTdeVLinmCaDQekAaNlTzvU+4XaCTh
	xmqoIcsoD20u6rTDevqthWp8FeczzlELXJ1Uaau0B9R4bw==
X-Google-Smtp-Source: AGHT+IEYGGX4aJpo4MYA3mOCVGC5UWnGUsXHBGFB7DjQo+07vMiTaJbzxhOOqhrVi8JUZ5WNKkFgCA==
X-Received: by 2002:a05:6a00:1992:b0:748:fb2c:6b95 with SMTP id d2e1a72fcca58-74af6f2e8c1mr20825727b3a.18.1751307338330;
        Mon, 30 Jun 2025 11:15:38 -0700 (PDT)
Received: from 127.com ([2620:10d:c090:600::1:335c])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74af5421c59sm9505960b3a.48.2025.06.30.11.15.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jun 2025 11:15:37 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v5 2/6] io_uring/mock: add cmd using vectored regbufs
Date: Mon, 30 Jun 2025 19:16:52 +0100
Message-ID: <229a113fd7de6b27dbef9567f7c0bf4475c9017d.1750599274.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1750599274.git.asml.silence@gmail.com>
References: <cover.1750599274.git.asml.silence@gmail.com>
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
 include/uapi/linux/io_uring/mock_file.h | 14 +++++
 io_uring/mock_file.c                    | 70 ++++++++++++++++++++++++-
 2 files changed, 83 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/io_uring/mock_file.h b/include/uapi/linux/io_uring/mock_file.h
index a44273fd526d..73aca477d5c8 100644
--- a/include/uapi/linux/io_uring/mock_file.h
+++ b/include/uapi/linux/io_uring/mock_file.h
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
diff --git a/io_uring/mock_file.c b/io_uring/mock_file.c
index 3681d0b8d8de..8285393f4a5b 100644
--- a/io_uring/mock_file.c
+++ b/io_uring/mock_file.c
@@ -9,8 +9,76 @@
 #include <linux/io_uring_types.h>
 #include <uapi/linux/io_uring/mock_file.h>
 
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
 
@@ -91,7 +159,7 @@ static int io_probe_mock(struct io_uring_cmd *cmd)
 	if (!mem_is_zero(&mp, sizeof(mp)))
 		return -EINVAL;
 
-	mp.features = 0;
+	mp.features = IORING_MOCK_FEAT_END;
 
 	if (copy_to_user(uarg, &mp, uarg_size))
 		return -EFAULT;
-- 
2.49.0


