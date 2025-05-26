Return-Path: <io-uring+bounces-8108-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 72507AC3AAC
	for <lists+io-uring@lfdr.de>; Mon, 26 May 2025 09:31:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B4A5F3A65EE
	for <lists+io-uring@lfdr.de>; Mon, 26 May 2025 07:31:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 39AEAEAE7;
	Mon, 26 May 2025 07:31:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h1yidmgv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52E1B156F3C
	for <io-uring@vger.kernel.org>; Mon, 26 May 2025 07:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748244692; cv=none; b=JDWqXkyXHFX9uGH/LRGdiabJaAlZmdN9vfsTOB+sie8xgaLqqIwVIrJ2JlKNcUC7YWfpq/83cvNeBf8wL2AAYA4rWvd+Ym+ESaeO/BdR7aCeUSJJ5lRLcH5FKiGHqUii3f/9iqi7RZKelPwhSRkpS2xEV6OBSJpd3ER0J5kPWFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748244692; c=relaxed/simple;
	bh=P5IocQVQl1KuwBFiHLiUvVZn6g/eduw0dzGbz5Ef2Xw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=psTtH1auPQrS7wKslz6UAqQIvZt6kxvTrn16h5anK3+mVCG641sY2L0RFPK7tFAYA/TOiY46b6c/5oSBNp8v+gDDD72rWVYLj3vhAhj9Kfu0gBxn3ZUB7ueJckieHRW1EkIhgBYMYDjI8fI8oJLdJAh0tMna+IiNMKB48HAvYu4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=h1yidmgv; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-ad5740dd20eso294386366b.0
        for <io-uring@vger.kernel.org>; Mon, 26 May 2025 00:31:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748244688; x=1748849488; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DlPtGlJ2fkUy7WU/ZzlitzbRhg/jE+/paOi3m677Huc=;
        b=h1yidmgvPhstAGoIJAXY7zdl+OmBKNryWgNIjQadnJ0AtcfQk8nkj6VDEJ0XFwAzXi
         xdybrk5TAAUwBw9hPFR/xPFaRmZF8dAhK4y4cUuoQD9vG/67somW6slJZBBZiNCWmsPf
         09iJKRanReW+kMNsh7/QmLo0nwkIhKsqHAIdc1RLlo9KU3QEAZNYeBHebVsM7EUj2vVV
         p7RFRhziulZKB/nparT9DDWweca2cODkccH7iYgvZgvwmr6sqy/XpIL/cHU4OfybQw+a
         skEkLTrtriEXf7gg50d7xlONw1zy37CMQHBSJ/z7OK2AliO5ebkE22S8Xmia5mfQaLf4
         /WFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748244688; x=1748849488;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DlPtGlJ2fkUy7WU/ZzlitzbRhg/jE+/paOi3m677Huc=;
        b=K4pqcOoI63Yx6QqtVzLolp0A3BoW2LKU0OUVAS1LEpSJ1weOSOXDH0h3U4xwdp8U98
         cdMpjAerKtB8poc1GnqRmApI1V9bbbO9Zg+CcZQhKYXmcsVo3Mms0dYVkk2gpppF7OUn
         5jxXiR+3VUX8xDhKB8SPzG0uHUQa7fMmfiM73EU7j1o3jFnUH7DWpodzHGPgjuQhxSfY
         uoRKCsW7tE7wKnlYCnkKZ1ZICclq6+AS5OYnVEWDhJEJY5sT+Qq6uANe1hHTUkXrldlw
         V7vO1/5A4YiLxL2o+CQbWtWfiIeWW2nlz57oDz9i2Ja2hdR2DKqYJk1pwMNVftY7HonU
         iEUQ==
X-Gm-Message-State: AOJu0YwHPUcLzlfwBylDxzVY8pLraihQTO1vTBM86hoeALz5oU9q9PnQ
	k+4tPhlXmz8QwVUApDTQfqp5oj728cWrYm+dAqOWOWi0YjfH1UBPSGyYGfUALA==
X-Gm-Gg: ASbGnctUHqRgTVCzEwkQT1hM2a10N4wQV2Oy/VK6NuXV1Q4iGjEsptdYYYxwOEEObCp
	oV7AcAzjJhF1C5uNdsp/e3NcDS70ty2fQlWN5nkXM+pvf34jBRPwf9g4XkOj6MxPGcNG6nj/KI4
	+7+MatwkFkPtie0zl7QX/JpWLneIFgRTvsNvTZNH7zGWr3y+W3dQfaipp7QJ5gm0mfFHI5xpQg6
	jjIEKWXBFEC+4iJTpNfu+a7v84RtVetK4ibyiriLoYIbFD5+jiEUb3GsrKGpaO745LeT1Jxcjtm
	QfsWJvd7zefRLFM/AYGbXJsXG3cRvUf2fhqX2LEnB8y2UtjoAgs39JeC1jGBOxry
X-Google-Smtp-Source: AGHT+IG9jNmhNsh3G5r4PiolPgAHyrAISuktA9uBoZjg1/2oUFLrY90iKqbssLcr/uSqyIAcsqvk+w==
X-Received: by 2002:a17:907:2cc6:b0:ad5:e0a:5891 with SMTP id a640c23a62f3a-ad85b0a7814mr726994666b.1.1748244687847;
        Mon, 26 May 2025 00:31:27 -0700 (PDT)
Received: from 127.0.0.1localhost ([148.252.132.24])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ad8816eb7e3sm12395166b.50.2025.05.26.00.31.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 May 2025 00:31:27 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	chase xd <sl1589472800@gmail.com>
Subject: [PATCH v2 5/6] io_uring/mock: support for async read/write
Date: Mon, 26 May 2025 08:32:27 +0100
Message-ID: <9ec9e765f3cdf2f168a605a539a75c3ecc36cdac.1748243323.git.asml.silence@gmail.com>
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

Let the user to specify a delay to read/write request. io_uring will
start a timer, return -EIOCBQUEUED and complete the request
asynchronously after the delay pass.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/mock_file.c | 59 +++++++++++++++++++++++++++++++++++++++++---
 io_uring/mock_file.h |  4 ++-
 2 files changed, 58 insertions(+), 5 deletions(-)

diff --git a/io_uring/mock_file.c b/io_uring/mock_file.c
index 6b9f1222397c..321d02f923af 100644
--- a/io_uring/mock_file.c
+++ b/io_uring/mock_file.c
@@ -4,13 +4,22 @@
 #include <linux/miscdevice.h>
 #include <linux/module.h>
 #include <linux/anon_inodes.h>
+#include <linux/ktime.h>
+#include <linux/hrtimer.h>
 
 #include <linux/io_uring/cmd.h>
 #include <linux/io_uring_types.h>
 #include "mock_file.h"
 
+struct io_mock_iocb {
+	struct kiocb		*iocb;
+	struct hrtimer		timer;
+	int			res;
+};
+
 struct io_mock_file {
-	size_t size;
+	size_t			size;
+	u64			rw_delay_ns;
 };
 
 #define IO_VALID_COPY_CMD_FLAGS		IORING_MOCK_COPY_FROM
@@ -86,14 +95,48 @@ static int io_mock_cmd(struct io_uring_cmd *cmd, unsigned int issue_flags)
 	return -ENOTSUPP;
 }
 
+static enum hrtimer_restart io_mock_rw_timer_expired(struct hrtimer *timer)
+{
+	struct io_mock_iocb *mio = container_of(timer, struct io_mock_iocb, timer);
+	struct kiocb *iocb = mio->iocb;
+
+	WRITE_ONCE(iocb->private, NULL);
+	iocb->ki_complete(iocb, mio->res);
+	kfree(mio);
+	return HRTIMER_NORESTART;
+}
+
+static ssize_t io_mock_delay_rw(struct kiocb *iocb, size_t len)
+{
+	struct io_mock_file *mf = iocb->ki_filp->private_data;
+	struct io_mock_iocb *mio;
+
+	mio = kzalloc(sizeof(*mio), GFP_KERNEL);
+	if (!mio)
+		return -ENOMEM;
+
+	mio->iocb = iocb;
+	mio->res = len;
+	hrtimer_setup(&mio->timer, io_mock_rw_timer_expired,
+		      CLOCK_MONOTONIC, HRTIMER_MODE_REL);
+	hrtimer_start(&mio->timer, ns_to_ktime(mf->rw_delay_ns),
+		      HRTIMER_MODE_REL);
+	return -EIOCBQUEUED;
+}
+
 static ssize_t io_mock_read_iter(struct kiocb *iocb, struct iov_iter *to)
 {
 	struct io_mock_file *mf = iocb->ki_filp->private_data;
 	size_t len = iov_iter_count(to);
+	size_t nr_zeroed;
 
 	if (iocb->ki_pos + len > mf->size)
 		return -EINVAL;
-	return iov_iter_zero(len, to);
+	nr_zeroed = iov_iter_zero(len, to);
+	if (!mf->rw_delay_ns || nr_zeroed != len)
+		return nr_zeroed;
+
+	return io_mock_delay_rw(iocb, len);
 }
 
 static ssize_t io_mock_write_iter(struct kiocb *iocb, struct iov_iter *from)
@@ -103,8 +146,12 @@ static ssize_t io_mock_write_iter(struct kiocb *iocb, struct iov_iter *from)
 
 	if (iocb->ki_pos + len > mf->size)
 		return -EINVAL;
-	iov_iter_advance(from, len);
-	return len;
+	if (!mf->rw_delay_ns) {
+		iov_iter_advance(from, len);
+		return len;
+	}
+
+	return io_mock_delay_rw(iocb, len);
 }
 
 static loff_t io_mock_llseek(struct file *file, loff_t offset, int whence)
@@ -150,6 +197,9 @@ static int io_create_mock_file(struct io_uring_cmd *cmd, unsigned int issue_flag
 		return -EINVAL;
 	if (mc.file_size > SZ_1G)
 		return -EINVAL;
+	if (mc.rw_delay_ns > NSEC_PER_SEC)
+		return -EINVAL;
+
 	mf = kzalloc(sizeof(*mf), GFP_KERNEL_ACCOUNT);
 	if (!mf)
 		return -ENOMEM;
@@ -159,6 +209,7 @@ static int io_create_mock_file(struct io_uring_cmd *cmd, unsigned int issue_flag
 		goto fail;
 
 	mf->size = mc.file_size;
+	mf->rw_delay_ns = mc.rw_delay_ns;
 	file = anon_inode_create_getfile("[io_uring_mock]", &io_mock_fops,
 					 mf, O_RDWR | O_CLOEXEC, NULL);
 	if (IS_ERR(file)) {
diff --git a/io_uring/mock_file.h b/io_uring/mock_file.h
index 224226abe23c..65ed71ca3a8f 100644
--- a/io_uring/mock_file.h
+++ b/io_uring/mock_file.h
@@ -7,6 +7,7 @@ enum {
 	IORING_MOCK_FEAT_CMD_COPY,
 	IORING_MOCK_FEAT_RW_ZERO,
 	IORING_MOCK_FEAT_RW_NOWAIT,
+	IORING_MOCK_FEAT_RW_ASYNC,
 
 	IORING_MOCK_FEAT_END,
 };
@@ -24,7 +25,8 @@ struct io_uring_mock_create {
 	__u32		out_fd;
 	__u32		flags;
 	__u64		file_size;
-	__u64		__resv[14];
+	__u64		rw_delay_ns;
+	__u64		__resv[13];
 };
 
 enum {
-- 
2.49.0


