Return-Path: <io-uring+bounces-10243-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id 2E58CC11B33
	for <lists+io-uring@lfdr.de>; Mon, 27 Oct 2025 23:30:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 0E1CE4E743F
	for <lists+io-uring@lfdr.de>; Mon, 27 Oct 2025 22:30:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9579F32D7D8;
	Mon, 27 Oct 2025 22:29:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CwHHEmgI"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11EE332C937
	for <io-uring@vger.kernel.org>; Mon, 27 Oct 2025 22:29:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761604184; cv=none; b=aVCu1vmUXiZvSErqYJVUT5Mf8LzY3P6GxwlLWRAPgSdoEl9qJnYqBXn5MpNmLJ6mDDTncAcqI9v5f8L1ncdN2fz0zQnxNjMDx3Uwlxmq+lJiQwWxTbTOo1Fb9WXLFm969OL9U32X7+ERD1VvqsS59XL/y+5Grol3eEIAMY7Tuxo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761604184; c=relaxed/simple;
	bh=q0CIG4sg3YcHVlE6O1hVSe7wVahN3MkLZ6EDbg4kQ6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pFZNnXaHMkx/utAGUJ7hMqOgd3aSw8w83DJJ31RZVYO9GyjW6PjxwaLzQ4aoRLXgrjLg6qdHFbQMKPaonP7rVPMIPPOVyw8kLXSoUX117nTPiuLC6NCCnT+qLrix/sLklZXGwIW+7Ss8S/Kdz5qXSIi1vxe2aCOvmg8LvgIqQrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CwHHEmgI; arc=none smtp.client-ip=209.85.210.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-781206cce18so5202027b3a.0
        for <io-uring@vger.kernel.org>; Mon, 27 Oct 2025 15:29:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761604182; x=1762208982; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UIIe7J+2Fjq2fETJFbES/k/BB7orrQTU6gidQxHEsTo=;
        b=CwHHEmgID7HCJgLs+JGaOZMHcCZQAI/v+cuXLbVMWk6DcSQ9xwyC+ToDuwRdbbAi4w
         g7ysQZj7nTHDkIqsBqKLC56j8/v5DS+oUtkFV9DGSBgbE9WqW90p5htS+JqINlDwFJUV
         Jfk8smgYiSYIB0TLwyppTQvRga6Lie6nG3gGmoy5e+Zv2xsXR2wmAbfsrqdqZjiqeD/s
         p1061+Qdff1W51xa5kKado81ljg9cXCNUEIPUKkQYczHDhZ74wBpN9bpp9N5r42t5Lpe
         RQ0GCZdEo/uKSjy7O4YB7s7dN7sYLnNnQHwR5jg+UgpO21bekRDtTwUo9HnfJqKikPj9
         Qhpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761604182; x=1762208982;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UIIe7J+2Fjq2fETJFbES/k/BB7orrQTU6gidQxHEsTo=;
        b=wGyDdtOhGX6FWJ6B7GCpExbIFkuh+r50Jznxks2QKHdGmeSW62+h6GYSlAeTH2o/5D
         OcFDOlxX8Kpi7/XWv8IOeRz53KMNfft8YTy4PdzEyp5IgO/gYTEO2C0N11t2H5YgomUx
         M8Ua1Qm3PiAf0Fgf0MGEaqmJ1AUvDMf5oeislDeDcI8SMpam3Cqyd1uvkZ38bok6h79+
         kjdX6PzIr6lJOoPxLKhnd+zzIFROfu3I9A9b35L/YJTVEdvbXQM+bV52YlMT7Fv0bBoK
         VxqG+uohRLhExD8radKTdPJXqyJaENOp4/pzM8MSKmwZNdEvW5sWVT4RUSGLDQZfm176
         XFfg==
X-Forwarded-Encrypted: i=1; AJvYcCWe9VRu+GiI8BM03sgI280ddqhLsu2A6rszZ/OKPG5Gf7NFxh9fbV1LGhS7e+1No+tv96a/2mgyBA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzokmQgeIlf+cac0n5wNP32eIu8oiW5m3hj9Q5OEjegdXIssofb
	TNsXwpGlKr4XxnYqARXaoX2+Y8koJwsQS+7WihClb87dyi4MDeeZFXyp
X-Gm-Gg: ASbGnct9fX4ongC5Axz6nbWf4sT4SMqRionKm1AAXnIXFjnBQuXzqMEjae7G+D0pFHW
	FZd/Fi0AkfSRf+vWRAVv8lLHQzn6dS4nsT5u5Ki1NHH65VXvVtZoqH7JtJBV41FkZ4wcVZaJ6n2
	m1Gagx36pDNouu+zJ5qNHpyo8Pj2Tw1kfk5OkH/IzV8hU/UheKzIDqR29ifAxE/U2rNtUcge1+F
	xva1rN/YguSDK6CKOYBUmlgf5EsFsqhBp20KCtgqCuHDYpoZzDEqHIYd7z3qdsKGu9SQPNEcmjR
	Ev+DkIciD+z9FG+LbXBY5mY5QZdRIajuYcorCT2DMjBX4wGsUO54yKKzrLWyCd9qsfxIQV7IKGo
	Dn0MPM+fJ/Yt+9hnHqVeL9DlFIMLGrjuRxdyaHiYzX7yNtqvGDCx3p5XBRH2ZFdYamS/uz3SPqY
	iI5DOX9o8rEuwWQS2G+DSNvq4CbDJ7G+uOD7QNnA==
X-Google-Smtp-Source: AGHT+IH/BlVDqq1xxpbiFJEvAxmdcEjzo1ibdPGr2BOfyfg8AS3BRphzOlQdrvhB8RrWeSysDEW2BA==
X-Received: by 2002:a05:6a00:9505:b0:77e:d2f7:f307 with SMTP id d2e1a72fcca58-7a442e5a7f5mr1189940b3a.9.1761604182189;
        Mon, 27 Oct 2025 15:29:42 -0700 (PDT)
Received: from localhost ([2a03:2880:ff:72::])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7a4140301ecsm9448576b3a.24.2025.10.27.15.29.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Oct 2025 15:29:41 -0700 (PDT)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: linux-fsdevel@vger.kernel.org,
	bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	xiaobing.li@samsung.com,
	csander@purestorage.com,
	kernel-team@meta.com
Subject: [PATCH v2 1/8] io_uring/uring_cmd: add io_uring_cmd_import_fixed_full()
Date: Mon, 27 Oct 2025 15:28:00 -0700
Message-ID: <20251027222808.2332692-2-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251027222808.2332692-1-joannelkoong@gmail.com>
References: <20251027222808.2332692-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add an API for fetching the registered buffer associated with a
io_uring cmd. This is useful for callers who need access to the buffer
but do not have prior knowledge of the buffer's user address or length.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 include/linux/io_uring/cmd.h |  3 +++
 io_uring/rsrc.c              | 14 ++++++++++++++
 io_uring/rsrc.h              |  2 ++
 io_uring/uring_cmd.c         | 13 +++++++++++++
 4 files changed, 32 insertions(+)

diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
index 7509025b4071..8c11d9a92733 100644
--- a/include/linux/io_uring/cmd.h
+++ b/include/linux/io_uring/cmd.h
@@ -43,6 +43,9 @@ int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 			      struct iov_iter *iter,
 			      struct io_uring_cmd *ioucmd,
 			      unsigned int issue_flags);
+int io_uring_cmd_import_fixed_full(int rw, struct iov_iter *iter,
+				   struct io_uring_cmd *ioucmd,
+				   unsigned int issue_flags);
 int io_uring_cmd_import_fixed_vec(struct io_uring_cmd *ioucmd,
 				  const struct iovec __user *uvec,
 				  size_t uvec_segs,
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index d787c16dc1c3..2c3d8489ae52 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1147,6 +1147,20 @@ int io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
 	return io_import_fixed(ddir, iter, node->buf, buf_addr, len);
 }
 
+int io_import_reg_buf_full(struct io_kiocb *req, struct iov_iter *iter,
+			   int ddir, unsigned issue_flags)
+{
+	struct io_rsrc_node *node;
+	struct io_mapped_ubuf *imu;
+
+	node = io_find_buf_node(req, issue_flags);
+	if (!node)
+		return -EFAULT;
+
+	imu = node->buf;
+	return io_import_fixed(ddir, iter, imu, imu->ubuf, imu->len);
+}
+
 /* Lock two rings at once. The rings must be different! */
 static void lock_two_rings(struct io_ring_ctx *ctx1, struct io_ring_ctx *ctx2)
 {
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index a3ca6ba66596..4e01eb0f277e 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -64,6 +64,8 @@ struct io_rsrc_node *io_find_buf_node(struct io_kiocb *req,
 int io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
 			u64 buf_addr, size_t len, int ddir,
 			unsigned issue_flags);
+int io_import_reg_buf_full(struct io_kiocb *req, struct iov_iter *iter,
+			   int ddir, unsigned issue_flags);
 int io_import_reg_vec(int ddir, struct iov_iter *iter,
 			struct io_kiocb *req, struct iou_vec *vec,
 			unsigned nr_iovs, unsigned issue_flags);
diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
index d1e3ba62ee8e..07730ced9449 100644
--- a/io_uring/uring_cmd.c
+++ b/io_uring/uring_cmd.c
@@ -292,6 +292,19 @@ int io_uring_cmd_import_fixed(u64 ubuf, unsigned long len, int rw,
 }
 EXPORT_SYMBOL_GPL(io_uring_cmd_import_fixed);
 
+int io_uring_cmd_import_fixed_full(int rw, struct iov_iter *iter,
+				   struct io_uring_cmd *ioucmd,
+				   unsigned int issue_flags)
+{
+	struct io_kiocb *req = cmd_to_io_kiocb(ioucmd);
+
+	if (WARN_ON_ONCE(!(ioucmd->flags & IORING_URING_CMD_FIXED)))
+		return -EINVAL;
+
+	return io_import_reg_buf_full(req, iter, rw, issue_flags);
+}
+EXPORT_SYMBOL_GPL(io_uring_cmd_import_fixed_full);
+
 int io_uring_cmd_import_fixed_vec(struct io_uring_cmd *ioucmd,
 				  const struct iovec __user *uvec,
 				  size_t uvec_segs,
-- 
2.47.3


