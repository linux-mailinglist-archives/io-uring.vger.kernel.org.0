Return-Path: <io-uring+bounces-9713-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A1BC5B523B4
	for <lists+io-uring@lfdr.de>; Wed, 10 Sep 2025 23:46:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7F6D617D39A
	for <lists+io-uring@lfdr.de>; Wed, 10 Sep 2025 21:46:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4E793285050;
	Wed, 10 Sep 2025 21:46:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z1jaPyBW"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B74A325A350;
	Wed, 10 Sep 2025 21:46:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757540803; cv=none; b=OPUg/G0+tW4y+jzroU8q2BbuhshziTwhYAyxR2V2IeGM5MBSI+TxzkDEk4/Dpk4UtDRxNlCWPD6dva6kKTosa/oOPd1FmOmnCRKGML7+NShxpROWAPj9ZCKypOwB3I9OEgC0qf0uT5H4bFPBNE0Ron5WQHjbZr3GORlphfoJ0SU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757540803; c=relaxed/simple;
	bh=gX9LM04WuGkmadDIeCCzsTULPHnflype1+UrWxWmNd4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jayzT+H0b50QFGtuyP+jUwY2hQFKmxDODP0I+tBK2lJoGMLbxWPgClruJFuu7bFdiP/aQeDYytCPXCpNoURu/TkUcLdfNliw89jDfN5RmQ/qf3XNx3Dk5qMG93ta5bKb0wy2zRwgP5viEc7ev8WAjye+IpaVT6aKujiCLwxWvZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z1jaPyBW; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-7726c7ff7e5so56684b3a.3;
        Wed, 10 Sep 2025 14:46:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757540801; x=1758145601; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PkS1HpoO21kqYsaFddGIvi50oyb/ms3N1SDnlykzSp4=;
        b=Z1jaPyBWAZlmSRjc1WZPyVj+p5A4Nzxnb/sH28lba8E9AQyB8scJU7OByRzdGzqVnL
         Q8qHtqARaNt7mQOcLPyu8PtLJo2SgLELJPRQYBROhurezD2FX7f5QGJLMlkQn5pbvdaM
         y0C/wdT06RS7lv0pIMrmJD8B2f+jPtZIYLSAh/f3IGf78u7ZjT9bGKPn5kZUdBiZ44k/
         xhLdvskN3Ii9rlaNdn8PWWrrui23RYKaUGnOn0Lz2rSdZCuAoVTAA1iiwAUuuHuOWdHU
         staeyaNWqkJMQ+DerJ3+H1LMufmmgMff1IIiY6MvQZWl6n7tuvpAPFTFdW7m/vUBz7Fo
         XXFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757540801; x=1758145601;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PkS1HpoO21kqYsaFddGIvi50oyb/ms3N1SDnlykzSp4=;
        b=qU4ac84RTEJQFscJcjC9PgOkduMGerYR1SPxiTHyq2kHwCinfLdH5FCY/3PtSzxlYa
         hkbV3np0cZECkh49ZBRifsURQYEn+6I+d6mogAEINQGCWPP28brBoqCuAsQOHt3RD+bh
         KweTtRwJI7Pgcri4LYJeR0CFKi+MTVtH+7JbVrE7VgFu3gmhtpCcpsSGUgRi5glMJkvp
         Yt2EWCNL0GGmgul3NyY3880z2NMHd3cHZpcx7CXUId/nxmVUb3Ckpe5HRMmYgAHqopcZ
         D1pLOmnlKL5Dl5+2uhUK745m2eFQMgXi7EDCcRlpjTqPO315KG2FtJq5Szd+gCsgiw/w
         la5A==
X-Forwarded-Encrypted: i=1; AJvYcCUHNozOLF8jauwW5kLiy+xV2pKIZ7VjYVfHTxU8FAnAdtGElfCW4e1bY+3cRVzXxs4HMnihL1ff4c86@vger.kernel.org, AJvYcCWVBr5BUZ5XdSjMfAiefj21ks4hIJqTp3mnR9jU7Kck7nRMv8kmmNQWU8ZMSHxk9BF5jd9qdL+HYTh/GreO@vger.kernel.org
X-Gm-Message-State: AOJu0YytTuZ4JHxs3tI5HyrVZPmSCZmxg6A/zIWHYER5K8WbDJZ4I6O7
	4A2yib3YkSe3MNMUMjs7L9HVH+YGuVoRIE9vKSnCDXLNr9VCwHx2SO5V5XpjdbIU
X-Gm-Gg: ASbGncu3Cgs13kzhRMFhyh2l1UEWFa8IFAUFrzeQ0ky/kT8l3UDhLBQXsWBXouR/9hx
	FDL098q5VUNyT+m/9AUyPuFOOLallz/MnP7RbQaUbfWo2D0DClSC9FKd5kWT+LYq92wdBWRVN1D
	JcXWUyjLeW5qK6/KQ9SRaVl5HnUWhKPDFjg6ldnMniL1P4e8yfNyRVeTN14E+c+tKEHKziypZ5u
	I//WtT9sWe26vw6xQRbjvUwmlaWSMsFOnNLg0jaADeLjhkROVWiOpW7xv8IlD9vItoaI7ra+6yx
	JnUNBLIwN0BiCq8qsW5LBwdBrAF2mR2iq3uiX1XcZMRcnjSiQRtzofACfTT5gqmc8TNVA1tFtaY
	875bn3Wjce6v0A2Ctvn+l8yu/VRS+JeXI9Umz
X-Google-Smtp-Source: AGHT+IH5ktDwuTmnkch6i7h+A0jQcHgCAyrrsdLod3ijbD7L8+zlT77gB9sP+OwQExloter2dqmF2g==
X-Received: by 2002:a05:6a00:c94:b0:772:332c:7976 with SMTP id d2e1a72fcca58-7742db6308dmr19883386b3a.0.1757540800851;
        Wed, 10 Sep 2025 14:46:40 -0700 (PDT)
Received: from jicarita ([65.144.169.45])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-775fbbc3251sm2422516b3a.103.2025.09.10.14.46.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Sep 2025 14:46:40 -0700 (PDT)
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: io-uring@vger.kernel.org,
	axboe@kernel.dk,
	linux-fsdevel@vger.kernel.org,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	linux-nfs@vger.kernel.org
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>
Subject: [PATCH 02/10] io_uring: add support for IORING_OP_NAME_TO_HANDLE_AT
Date: Wed, 10 Sep 2025 15:49:19 -0600
Message-ID: <20250910214927.480316-3-tahbertschinger@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250910214927.480316-1-tahbertschinger@gmail.com>
References: <20250910214927.480316-1-tahbertschinger@gmail.com>
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
 include/uapi/linux/io_uring.h |  2 ++
 io_uring/opdef.c              | 11 +++++++++
 io_uring/openclose.c          | 45 +++++++++++++++++++++++++++++++++++
 io_uring/openclose.h          |  5 ++++
 4 files changed, 63 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 6957dc539d83..a4aa83ad9527 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -74,6 +74,7 @@ struct io_uring_sqe {
 		__u32		install_fd_flags;
 		__u32		nop_flags;
 		__u32		pipe_flags;
+		__u32		name_to_handle_flags;
 	};
 	__u64	user_data;	/* data to be passed back at completion time */
 	/* pack this to avoid bogus arm OABI complaints */
@@ -289,6 +290,7 @@ enum io_uring_op {
 	IORING_OP_READV_FIXED,
 	IORING_OP_WRITEV_FIXED,
 	IORING_OP_PIPE,
+	IORING_OP_NAME_TO_HANDLE_AT,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 9568785810d9..76306c9e0ecd 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -574,6 +574,14 @@ const struct io_issue_def io_issue_defs[] = {
 		.prep			= io_pipe_prep,
 		.issue			= io_pipe,
 	},
+	[IORING_OP_NAME_TO_HANDLE_AT] = {
+#if defined(CONFIG_FHANDLE)
+		.prep			= io_name_to_handle_at_prep,
+		.issue			= io_name_to_handle_at,
+#else
+		.prep			= io_eopnotsupp_prep,
+#endif
+	},
 };
 
 const struct io_cold_def io_cold_defs[] = {
@@ -824,6 +832,9 @@ const struct io_cold_def io_cold_defs[] = {
 	[IORING_OP_PIPE] = {
 		.name			= "PIPE",
 	},
+	[IORING_OP_NAME_TO_HANDLE_AT] = {
+		.name			= "NAME_TO_HANDLE_AT",
+	},
 };
 
 const char *io_uring_get_opcode(u8 opcode)
diff --git a/io_uring/openclose.c b/io_uring/openclose.c
index d70700e5cef8..884a66e56643 100644
--- a/io_uring/openclose.c
+++ b/io_uring/openclose.c
@@ -27,6 +27,15 @@ struct io_open {
 	unsigned long			nofile;
 };
 
+struct io_name_to_handle {
+	struct file			*file;
+	int				dfd;
+	int				flags;
+	struct file_handle __user	*ufh;
+	char __user			*path;
+	void __user			*mount_id;
+};
+
 struct io_close {
 	struct file			*file;
 	int				fd;
@@ -187,6 +196,42 @@ void io_open_cleanup(struct io_kiocb *req)
 		putname(open->filename);
 }
 
+#if defined(CONFIG_FHANDLE)
+int io_name_to_handle_at_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_name_to_handle *nh = io_kiocb_to_cmd(req, struct io_name_to_handle);
+
+	nh->dfd = READ_ONCE(sqe->fd);
+	nh->flags = READ_ONCE(sqe->name_to_handle_flags);
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
+	ret = do_sys_name_to_handle_at(nh->dfd, nh->path, nh->ufh, nh->mount_id,
+				       nh->flags, lookup_flags);
+
+	if (ret == -EAGAIN && (issue_flags & IO_URING_F_NONBLOCK))
+		return -EAGAIN;
+
+	if (ret < 0)
+		req_set_fail(req);
+	io_req_set_res(req, ret, 0);
+	return IOU_COMPLETE;
+}
+#endif /* CONFIG_FHANDLE */
+
 int __io_close_fixed(struct io_ring_ctx *ctx, unsigned int issue_flags,
 		     unsigned int offset)
 {
diff --git a/io_uring/openclose.h b/io_uring/openclose.h
index 4ca2a9935abc..2fc1c8d35d0b 100644
--- a/io_uring/openclose.h
+++ b/io_uring/openclose.h
@@ -10,6 +10,11 @@ void io_open_cleanup(struct io_kiocb *req);
 int io_openat2_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_openat2(struct io_kiocb *req, unsigned int issue_flags);
 
+#if defined(CONFIG_FHANDLE)
+int io_name_to_handle_at_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+int io_name_to_handle_at(struct io_kiocb *req, unsigned int issue_flags);
+#endif /* CONFIG_FHANDLE */
+
 int io_close_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_close(struct io_kiocb *req, unsigned int issue_flags);
 
-- 
2.51.0


