Return-Path: <io-uring+bounces-8126-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7BD11AC8A09
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 10:37:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 37DFF4A641A
	for <lists+io-uring@lfdr.de>; Fri, 30 May 2025 08:37:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1987321885A;
	Fri, 30 May 2025 08:37:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kzLbJC4T"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f42.google.com (mail-ej1-f42.google.com [209.85.218.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B05F38B
	for <io-uring@vger.kernel.org>; Fri, 30 May 2025 08:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748594233; cv=none; b=genRtmc59s1FYjcmfCNkzWBvkzJAajzkrLmN36PZTClma0nCiisx3uUMwk26zqu3J/+mcpy0ezZxpGGH/xOyWz2sCjDO2rtqBf7Z9KWMFYeMOcYADRac1ozk8XPwrFCdqiCTwvPvHvYBzgdLepqAtqxFY0hKhXCqNyMgxviA6VA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748594233; c=relaxed/simple;
	bh=eoUKQLfv6pNgvTP8gR0MEEJafwMfiXz05Q/ZbWjst1g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gevafIp8OqqCSvABRzKgqRgh7n9b3LOYtb/mEixXqo+p0qA7+79/30+QnSn2VcY+0swXFCbnjXcbNZILsj7nlBRp6G/IjuxCC+8zBsAZjpnhUVY+bCQMcBH42Nmzszg4693RZEZeOZtvqtgpk5bimaJDXn0HaahomIiOV8vVoNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kzLbJC4T; arc=none smtp.client-ip=209.85.218.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f42.google.com with SMTP id a640c23a62f3a-ad8a6c202ffso338082566b.3
        for <io-uring@vger.kernel.org>; Fri, 30 May 2025 01:37:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1748594229; x=1749199029; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FHAiGzcYVKduBAieVdqz6jl4x35p4OVaPrmqXxpDBIs=;
        b=kzLbJC4TLP0y96cVNQxcWMsamIOKd/DGM9tm/1UkhjSFC/lnKyYMR0xl1FrGXqSlXo
         JGjpk2DLj+Cfhl3Cncz9XO7FpSpByPIAxswWwdAWrmRMjbD2KkUsBEMqDcG09BUQuQT5
         vfF+3N//g5J1hOqLpdiZXf+lmuL0QZnexttwlPhYKCurci3sxSD4pbZQN2Yflter2KaB
         7wMKNgs2qcrYxJv/X6fY+7e+zAWc3CoioG/oUsXnxz9tsuX4KdkDjg0vMrGKbSzsZ+Xx
         uDBk6p7ZbcP1veyeKcOTTgVSdTg0czWS2Kg6yM7YK5SIY7WCZikAVGo68y771XMvkQ0I
         gw9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748594229; x=1749199029;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FHAiGzcYVKduBAieVdqz6jl4x35p4OVaPrmqXxpDBIs=;
        b=FHha09rwBv99fOMFL0GMV4F+X4gGZZ9Sr0qGYZZHcRUudWIkJ4qlZmD6uMjKlOeNcm
         zb7KK/4/M4Y+xkP14wHi2GUP1JPooPvZg9M6KTG0WXefJMShsW9Xz+xpbDd27d4rKfhy
         Rz3m0mZQGJX28v+T/0FZIYGW+wN8plcWAazN4Ub7NUnSaS94Yk5CWF1Qwy5VurWVz7iz
         h4zwJ5Cgg09L6OP/QeSRmSv7lLGi7pmZoimsQqSaDMyhvBWxdg8+/y0JfmfK4i1o6qwk
         1FKtS9461ZTJNQe74TDMzD3/kU39ok2KAO6JAKnd7vJH/6LxAerigzMSlJy0WOiSBMV5
         tniA==
X-Gm-Message-State: AOJu0Yx/V8GIgo1vZRGZPrIEMG+vBBGUmb3ZUhGTW+w/+9jUoCB4Zqyp
	UlpQykbHm+gwJwQGorkXagA4CZfwz1oSY9GaobsRR43LyqFMHxq1b+Bt02ev/Q==
X-Gm-Gg: ASbGnctJxKTHWCTqLezWu/IPqafxGdhEscA4T6uI9/cigj+bOq0bjbi/5kiM98L+m7V
	Wnzy3ediFvZRzT1YeAVASNOCKbGxinl9kEDbbFNWPBCIqDT7RhPVGWrm9ORsr72dBk6ai4y8hV4
	AxyKDVasefdKhMLOUsgGJtiozeDe+38g0oeq9N46ro4MTF/hHeZOMMgEeFH6g/Kr6OGZSkgnbM2
	j1defaqmhutkZ4BUC8h+jdRIQny+6wh6cD319gzAadeU9JpLvSbkXbaeIN983CANQHy1/1l3Ehy
	/8z0NHeNJBTWggeztXrOZvag6xla0pIRFbU=
X-Google-Smtp-Source: AGHT+IFTPNMsIU2Vm2ttwyuQRdaHOxTD9XcQWRxLz3Gi+S/8g0fuBmzE07qf1LrMib7RtfUl4h3M/A==
X-Received: by 2002:a17:906:c115:b0:ad8:a41a:3cba with SMTP id a640c23a62f3a-adb325839c4mr232768966b.43.1748594228876;
        Fri, 30 May 2025 01:37:08 -0700 (PDT)
Received: from 127.com ([2620:10d:c092:600::1:65cd])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ada6ad696d1sm288126566b.161.2025.05.30.01.37.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 May 2025 01:37:08 -0700 (PDT)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH v3 2/6] io_uring/mock: add cmd using vectored regbufs
Date: Fri, 30 May 2025 09:38:07 +0100
Message-ID: <4b13f45a0d08736fd03a3c3b0694c10987cb0b5e.1748594274.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1748594274.git.asml.silence@gmail.com>
References: <cover.1748594274.git.asml.silence@gmail.com>
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
index 8b00045480cd..8475dfd827e9 100644
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
-- 
2.49.0


