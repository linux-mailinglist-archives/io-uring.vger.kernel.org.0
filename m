Return-Path: <io-uring+bounces-8540-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id ABB29AEE69A
	for <lists+io-uring@lfdr.de>; Mon, 30 Jun 2025 20:15:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EDC3217CEC6
	for <lists+io-uring@lfdr.de>; Mon, 30 Jun 2025 18:15:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2E0B61C84DD;
	Mon, 30 Jun 2025 18:15:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bwrH9YNB"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5861190462
	for <io-uring@vger.kernel.org>; Mon, 30 Jun 2025 18:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751307343; cv=none; b=asQsf4hGqspBo5j3x+cRjnp6zCOnwBH8sASfU/A6stj1elobkOY/IkUfygH7mBUZ629hrGxDD0AHDIHuS7KSUYFyFUuTgoNYhVLarFyFEdp/PgolZ7A41Mcu9pjZVA6EM26Ddk6qq2e/r1U/JL8Q19/X6fNNdex4dAeDsPu1rEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751307343; c=relaxed/simple;
	bh=nGfUB7hIqcI2eMg/6FfrKqb2Ycm38QVrRMMdgiElGmw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WqjFQrMyeLgUbgK40ebzi0N93/xpkTSQBU/WXCJUxdgGS+PbuzHKLjthz4AqEqzJS+KIb11LtI7aahqggwwibvI9HJ1/QO96h5aKIIMkDrM2wuSVFOCJHhR0zJPrDc/u+l2+t4Dy5KaTHhaUGjDvW8Wp4bWqFqQxIZeZbLQxC54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bwrH9YNB; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-7490702fc7cso3528189b3a.1
        for <io-uring@vger.kernel.org>; Mon, 30 Jun 2025 11:15:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1751307341; x=1751912141; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DyRycApwd+D/WC5uqGFnvzbEWSJYuB0vXDn8JzzmHls=;
        b=bwrH9YNBe5jFjNt4e7KVmE7fFkLlcVKouSWRQP0zbUwc0VD4VGeVYd7L5PI4G9+E3Z
         3ucxBaajuQhweilHTfwWpYHnBFNwrmkZ5F7gQkAnlf25assiIMbwQF8nycORRrOEK2a9
         /LrQPxD+mdvABq/C6BzebtMLa6Yz1vt1K5pyCa4eYDj2rZoH+ZS2D6z5aSn1CtLb3akl
         fJ1gnJ/R1iZ1zaYTE4KfG2itDcRifiuFPDIcvEmiNdLIwtX2Da6so4bxjt/CpYvTkIL+
         OYQl9gkzO68SpM0tXKX+UM+EcLbQM1JuvD1wsGtrE+0RGtRNixw2fJfFeYXZRx/V0O18
         Ksxw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751307341; x=1751912141;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DyRycApwd+D/WC5uqGFnvzbEWSJYuB0vXDn8JzzmHls=;
        b=Uz1GsFiD+XwvqODSNK9osEWFfiPeCL35QKOPVnH5GHycEND818LaznCRzywliXO5cI
         bYo4JqetCXWFHaYR6NfbNU/Mv7Lgid1b0xQQbXRTBBbj1h/9Rk70WQiyQZtqyRNET3i2
         ktp7HQw6qRcv/x1xT82qlYrgM0UkuKz0g3cBpJu4+gnH6XsTjrYHJ1V4hsBB6OHjhrkB
         rzhmQ0XYyo5W1njBO/Hs7FjGP3pghrhTZsfvitwY0Jtq/oFIx3W8U0eIsvWiU6lL9qhT
         DiKjxLKAlh8UzmwrN8gSF2tSWrX79hFTFVbSrUWPxrSzw4DvMDLwb4SVF0poqzjZJLhY
         1RAg==
X-Gm-Message-State: AOJu0YwxvIGweAfxWHYCzf0o0m04LjUdDsovCFp1yn8YR1/VbJ8lg3CX
	iWI6ATQSN5Hrm8k+QDl3dXaXc6gzz9ulUaCpDMv6E06PvKaDE09J1r7f1wr9uEjO
X-Gm-Gg: ASbGncvXqYRK/U8DD+fTtFaQ5q0d8ju9bIAQq9Y7YBFVqmdYlqIwrTBPPiRCLUrbw6N
	95o4zxGa4x9Jm77M+VGQhhkD7kVXwBh/QNaclm9E4Msu9Imsxya/W9OJXGfP6P0ID4MgzdIgJ2c
	V2DTBkZ/NMe911x5AWALDIDevjGDIpKoq4Qh/YaPfjXvxe2APVfebwJmzy4v+pjvyheejXuwKx6
	SRRrY+d2cvMN1E4mz+stGP3CXhjMDqI3aC5BvPw+odemcrKjNw5Zz7cb8GvJ2nZfZC0CvL8MvmV
	noTaOtGVA6iGgdq9GdjPREKaj/MWN7audu5Zqu4AA4BlOw==
X-Google-Smtp-Source: AGHT+IGLVvfKfLZvWiGaikXZo5PaVg5jzyyWEz05XZ8i9gu5+uNv/u/BH1LzZVhsDpAdqvA58RlRRw==
X-Received: by 2002:a05:6a00:3c90:b0:742:a334:466a with SMTP id d2e1a72fcca58-74af6f43f06mr20394490b3a.12.1751307340682;
        Mon, 30 Jun 2025 11:15:40 -0700 (PDT)
Received: from 127.com ([2620:10d:c090:600::1:335c])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74af5421c59sm9505960b3a.48.2025.06.30.11.15.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Jun 2025 11:15:40 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v5 4/6] io_uring/mock: allow to choose FMODE_NOWAIT
Date: Mon, 30 Jun 2025 19:16:54 +0100
Message-ID: <1e532565b05a05b23589d237c24ee1a3d90c2fd9.1750599274.git.asml.silence@gmail.com>
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

Add an option to choose whether the file supports FMODE_NOWAIT, that
changes the execution path io_uring request takes.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 include/uapi/linux/io_uring/mock_file.h | 5 +++++
 io_uring/mock_file.c                    | 8 +++++++-
 2 files changed, 12 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/io_uring/mock_file.h b/include/uapi/linux/io_uring/mock_file.h
index de27295bb365..125949d2b5ce 100644
--- a/include/uapi/linux/io_uring/mock_file.h
+++ b/include/uapi/linux/io_uring/mock_file.h
@@ -6,6 +6,7 @@
 enum {
 	IORING_MOCK_FEAT_CMD_COPY,
 	IORING_MOCK_FEAT_RW_ZERO,
+	IORING_MOCK_FEAT_RW_NOWAIT,
 
 	IORING_MOCK_FEAT_END,
 };
@@ -15,6 +16,10 @@ struct io_uring_mock_probe {
 	__u64		__resv[9];
 };
 
+enum {
+	IORING_MOCK_CREATE_F_SUPPORT_NOWAIT			= 1,
+};
+
 struct io_uring_mock_create {
 	__u32		out_fd;
 	__u32		flags;
diff --git a/io_uring/mock_file.c b/io_uring/mock_file.c
index 90160ccb50f0..0eb1d3bd6368 100644
--- a/io_uring/mock_file.c
+++ b/io_uring/mock_file.c
@@ -131,6 +131,8 @@ static const struct file_operations io_mock_fops = {
 	.llseek		= io_mock_llseek,
 };
 
+#define IO_VALID_CREATE_FLAGS (IORING_MOCK_CREATE_F_SUPPORT_NOWAIT)
+
 static int io_create_mock_file(struct io_uring_cmd *cmd, unsigned int issue_flags)
 {
 	const struct io_uring_sqe *sqe = cmd->sqe;
@@ -157,7 +159,9 @@ static int io_create_mock_file(struct io_uring_cmd *cmd, unsigned int issue_flag
 	memset(&mc, 0, sizeof(mc));
 	if (copy_from_user(&mc, uarg, uarg_size))
 		return -EFAULT;
-	if (!mem_is_zero(mc.__resv, sizeof(mc.__resv)) || mc.flags)
+	if (!mem_is_zero(mc.__resv, sizeof(mc.__resv)))
+		return -EINVAL;
+	if (mc.flags & ~IO_VALID_CREATE_FLAGS)
 		return -EINVAL;
 	if (mc.file_size > SZ_1G)
 		return -EINVAL;
@@ -180,6 +184,8 @@ static int io_create_mock_file(struct io_uring_cmd *cmd, unsigned int issue_flag
 	file->f_mode |= FMODE_READ | FMODE_CAN_READ |
 			FMODE_WRITE | FMODE_CAN_WRITE |
 			FMODE_LSEEK;
+	if (mc.flags & IORING_MOCK_CREATE_F_SUPPORT_NOWAIT)
+		file->f_mode |= FMODE_NOWAIT;
 
 	mc.out_fd = fd;
 	if (copy_to_user(uarg, &mc, uarg_size)) {
-- 
2.49.0


