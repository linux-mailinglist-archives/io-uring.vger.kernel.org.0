Return-Path: <io-uring+bounces-8962-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0DDE9B27329
	for <lists+io-uring@lfdr.de>; Fri, 15 Aug 2025 01:51:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id ACFF7A2020C
	for <lists+io-uring@lfdr.de>; Thu, 14 Aug 2025 23:51:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0FF3228850E;
	Thu, 14 Aug 2025 23:51:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EI1rBcCH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D12F1F582E;
	Thu, 14 Aug 2025 23:51:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755215505; cv=none; b=EAcsOl04EAQMw4Pmio8WXk/7PtGl6KYMfEatGw4HmRDKEGacrQZMRxvwKdzlftt52rjrGh5AG74G8XaRZDoHJyoarptDCYH/rUWH/eJ7ZQDtFxpTaFKBx1D1qqWVyQT/HzqofnJREgY1Fl688DZR9JDbraJlUSRmVSADIvpO94s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755215505; c=relaxed/simple;
	bh=asOTpRAypgyLlYTi0bpBylaBLW3+utCQmQ99IwkscyA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nHdSTys/SuBMRYLJIG84Z4dK7Dzr5piY3tjIM1Yrr2wHErkjLb22hkr5tiHtf60g2QrPk7rO3LVF06lGwnSTPNgbxg97xwOxpiz4wUwbg/eav+LnsfF0aRLQv8OaqjvccjrZKOuKtyzE0YOKzrLQHBbvW/wbR6J5iHxr6brR5B0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EI1rBcCH; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-b471738daabso1262751a12.1;
        Thu, 14 Aug 2025 16:51:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755215503; x=1755820303; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jxup66pfr8/p9NkkM91B1cTk1IwvSqJa2cpo7xSf9BM=;
        b=EI1rBcCHxJS/n7Pj5H/6siatMvrJ3PqO9G0RnEAo8/INkWbmavvphK36poxH/yKD4V
         ORgelx6NAyqnDVzmMtc2moiD8rfIaLvTEAAzvgeJb1X+WG6Oq91KH2xU0hxM1TRrEtRn
         ZN2k9fF8V9tdgpymUe/x7Jx4fARp17UopHg63EgERbYIJOPWfT7Q5h+21Jo2XL307ZPz
         WHjfRYfn8KANlhUj0so/t2+MD96AIcL1gsfa1rX+tCjI8CCZFTqByEyhpUvr3Ss+Vmy8
         SKqfUQM8npwTO5AghSDg8G8I6k8YyP07kvIyB3eto5uYBUcPLMe24AImAX6U/PA1nc4e
         ZbAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755215503; x=1755820303;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Jxup66pfr8/p9NkkM91B1cTk1IwvSqJa2cpo7xSf9BM=;
        b=PTK8tN2ZUcwJAvcBeZBwEoIg4ztA/w+3fa3QKx759xNmneT2ibasiN6QkfFQkZjtY1
         XStNjFzdYAQBIX7/9vhEt+WqWYRoZ8Sqosjouv4tXUjWBw6FHfDCtF2U6ExI6CBLN2F2
         tlrQxCUNgHBCLoDdA2FaR5jkRg0pHwYmbwnWFjYfSob4qZqpeG7fUr/c83b8cZYN7KNw
         80OlxDA4obzqyWmbxF3t5l8fkN6n0iBojvailpKpvVhy2/V5V+1bt0z6wYS1x88ToVkZ
         PhsIeS2CLds1DiHGSx4/0PMjEdW2ljB2QUXPSxnN0PeU7Pk/OzQFvsJt+tkRmaBRV62V
         3xwQ==
X-Forwarded-Encrypted: i=1; AJvYcCVLdgKyzXfCNgYYHQBEKEZIEDARYYiMgZX+Fs7NX9Vli3H8RM5jznzufmqVzZVsmdfik22rzUsC4I9U@vger.kernel.org, AJvYcCXhf+g1P1ZiBcOpJLpVC3DW3xFuetXMdZcDtjVCASodIrVxqufKD7AbqX5M68aXRsEE0bmYpI8MZdvzsk8u@vger.kernel.org
X-Gm-Message-State: AOJu0YyTkd58U8meOkpxD0GKB9E1afdirtNMmTI2LQYA4TiNcgM8qvu2
	ahmcLoqLB1hqTY2hReVRfSDS4iIX8NI+Zhsten4Yy/dRJKB8q5Jf2edrsnp817ad3Tw=
X-Gm-Gg: ASbGnct45Vy7cw7FDG3J0D3XUwYXuO+ol7ulEIEC5tOKUeYlzRA6bX1AWskDRKGYF8R
	61ZesjgwiYm/KVEFEZXp8MD4FAgR60rHRi2GKvMi8mx4rB6xfjhRbJ35uF1V7segw1/TyIA455s
	2f8wVLXOudw4JLmR9V5uT586LGq1Esg6MRuiM4wuGy8XFltOVh9qd9+BWRjAGE2suisikEQBVNB
	/NSGHEZGVbURTtZo3PUhVZVyabwLQ8igEMxCVTYJx8VpDaEj3Bhig/BcZB/WaWoG7IjtkqOdW/H
	MtJzy1njTRenbpLKEAbghpvoZ119FkhF/5qxX4aesWS8UpGlmlHyDQd0cumcHsCtQg6RejvnV8a
	B1kenCnFd2WKWjKddhIXiulFk4zVkeJRn24I=
X-Google-Smtp-Source: AGHT+IER5rL07BFeC/d7WXNfT5fr0k1TplZfTVlqw9vyPXSi3WMCYFQVTQVfje5UA0lzxjhVgbw/7Q==
X-Received: by 2002:a17:90b:2683:b0:31f:59d1:85be with SMTP id 98e67ed59e1d1-3234215846bmr187614a91.24.1755215502635;
        Thu, 14 Aug 2025 16:51:42 -0700 (PDT)
Received: from jicarita ([65.144.169.45])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3233100c1d0sm2974721a91.17.2025.08.14.16.51.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Aug 2025 16:51:42 -0700 (PDT)
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: io-uring@vger.kernel.org,
	axboe@kernel.dk,
	linux-fsdevel@vger.kernel.org,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	linux-nfs@vger.kernel.org
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>
Subject: [PATCH 2/6] io_uring: add support for IORING_OP_NAME_TO_HANDLE_AT
Date: Thu, 14 Aug 2025 17:54:27 -0600
Message-ID: <20250814235431.995876-3-tahbertschinger@gmail.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250814235431.995876-1-tahbertschinger@gmail.com>
References: <20250814235431.995876-1-tahbertschinger@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add support for name_to_handle_at(2) to io_uring.

Like openat*(), this tries to do a non-blocking lookup first and resorts
to async lookup when that fails.

This uses sqe->addr for the path, ->addr2 for the file handle which is
filled in by the kernel, and ->addr3 for the mouint_id which is filled
in by the kernel.

Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
---
 include/uapi/linux/io_uring.h |  1 +
 io_uring/opdef.c              |  7 ++++++
 io_uring/openclose.c          | 43 +++++++++++++++++++++++++++++++++++
 io_uring/openclose.h          |  3 +++
 4 files changed, 54 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 6957dc539d83..596bae788b48 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -289,6 +289,7 @@ enum io_uring_op {
 	IORING_OP_READV_FIXED,
 	IORING_OP_WRITEV_FIXED,
 	IORING_OP_PIPE,
+	IORING_OP_NAME_TO_HANDLE_AT,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 9568785810d9..ff2672bbd583 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -574,6 +574,10 @@ const struct io_issue_def io_issue_defs[] = {
 		.prep			= io_pipe_prep,
 		.issue			= io_pipe,
 	},
+	[IORING_OP_NAME_TO_HANDLE_AT] = {
+		.prep			= io_name_to_handle_at_prep,
+		.issue			= io_name_to_handle_at,
+	},
 };
 
 const struct io_cold_def io_cold_defs[] = {
@@ -824,6 +828,9 @@ const struct io_cold_def io_cold_defs[] = {
 	[IORING_OP_PIPE] = {
 		.name			= "PIPE",
 	},
+	[IORING_OP_NAME_TO_HANDLE_AT] = {
+		.name			= "NAME_TO_HANDLE_AT",
+	},
 };
 
 const char *io_uring_get_opcode(u8 opcode)
diff --git a/io_uring/openclose.c b/io_uring/openclose.c
index d70700e5cef8..f15a9307f811 100644
--- a/io_uring/openclose.c
+++ b/io_uring/openclose.c
@@ -27,6 +27,15 @@ struct io_open {
 	unsigned long			nofile;
 };
 
+struct io_name_to_handle {
+	struct file			*file;
+	int				dfd;
+	int				open_flag;
+	struct file_handle __user	*ufh;
+	char __user			*path;
+	void __user			*mount_id;
+};
+
 struct io_close {
 	struct file			*file;
 	int				fd;
@@ -187,6 +196,40 @@ void io_open_cleanup(struct io_kiocb *req)
 		putname(open->filename);
 }
 
+int io_name_to_handle_at_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_name_to_handle *nh = io_kiocb_to_cmd(req, struct io_name_to_handle);
+
+	nh->dfd = READ_ONCE(sqe->fd);
+	nh->open_flag = READ_ONCE(sqe->open_flags);
+	nh->path = u64_to_user_ptr(READ_ONCE(sqe->addr));
+	nh->ufh = u64_to_user_ptr(READ_ONCE(sqe->addr2));
+	nh->mount_id = u64_to_user_ptr(READ_ONCE(sqe->addr3));
+
+	return 0;
+}
+
+int io_name_to_handle_at(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_name_to_handle *nh = io_kiocb_to_cmd(req, struct io_name_to_handle);
+	int lookup_flags = 0;
+	long ret;
+
+	if (issue_flags & IO_URING_F_NONBLOCK)
+		lookup_flags = LOOKUP_CACHED;
+
+	ret = do_name_to_handle_at(nh->dfd, nh->path, nh->ufh, nh->mount_id,
+				   nh->open_flag, lookup_flags);
+
+	if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK))
+		return -EAGAIN;
+
+	if (ret < 0)
+		req_set_fail(req);
+	io_req_set_res(req, ret, 0);
+	return IOU_COMPLETE;
+}
+
 int __io_close_fixed(struct io_ring_ctx *ctx, unsigned int issue_flags,
 		     unsigned int offset)
 {
diff --git a/io_uring/openclose.h b/io_uring/openclose.h
index 4ca2a9935abc..3d1096abffac 100644
--- a/io_uring/openclose.h
+++ b/io_uring/openclose.h
@@ -10,6 +10,9 @@ void io_open_cleanup(struct io_kiocb *req);
 int io_openat2_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_openat2(struct io_kiocb *req, unsigned int issue_flags);
 
+int io_name_to_handle_at_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+int io_name_to_handle_at(struct io_kiocb *req, unsigned int issue_flags);
+
 int io_close_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_close(struct io_kiocb *req, unsigned int issue_flags);
 
-- 
2.50.1


