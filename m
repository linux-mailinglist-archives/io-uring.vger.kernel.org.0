Return-Path: <io-uring+bounces-8966-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 756A8B27339
	for <lists+io-uring@lfdr.de>; Fri, 15 Aug 2025 01:52:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F253C5E83ED
	for <lists+io-uring@lfdr.de>; Thu, 14 Aug 2025 23:52:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1F63288510;
	Thu, 14 Aug 2025 23:51:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jum9qaPv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0E5A28937D;
	Thu, 14 Aug 2025 23:51:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755215514; cv=none; b=JZn1FSO2jZF4EFdz1nKFKsqlbnRrVssM9DGtoSOGrlvFWGO0BqDdV4rppPXS6DkW2E/paz85QGu9hShvAG4hPYAKgYQbM40/pUdk6+T6ILa2rK3o0zgopF4Bn4pKoCXG1KoVOytaq2yLBaMiqhGsoCZbmoSbGFR04HK6iK8/1vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755215514; c=relaxed/simple;
	bh=VZVKNFxEnLweOafgl0TbIkx6Kr3Ygs7abNi0A0rT6AA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s7686r5iFC7cy3SEbu9qSeXbJz0mj9fT9dDN+2tBO+xKOgt6vLPuHWhIBm7cstzKB7N8THfib0dljH7Zk5RGphPFdjHYY9QqfBYCxwAodgklpjyQKd+UYtQ6cNeXc3itDDmbMSXLfENvvijz7ZitGmlbbAUHPs8AZp7ZsY9sEdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jum9qaPv; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-32326e67c95so2019923a91.3;
        Thu, 14 Aug 2025 16:51:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755215512; x=1755820312; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nWEAphj4m/uzejg39gNHA2RWkzZcuFUCit1TiH9ELm0=;
        b=jum9qaPv0NmunVZJ+bKIn0fRJQLkpRxQ+imsb6W4ICCPuHsCjOCKdA7gm/Awexam+Q
         18PKLKeLZF5IFpSafsGDd/ln6IMpbt4jGg1BdT8T8Hd8IMpKzJB71mOYmYQE3PAMMhZu
         l3U3oatoTAncjqOwC5gyR0EJM+seQzRYoes3OzBkANd9lVmfYFKIGT0V187HktW5hZli
         bzRRagE/+mOWwDOtNmHzUesfL0dpkYUdcwNhNZ8dqRXwxKIrDBzamRnFfSwo7XLejHEF
         Q/NXkaIzwL8fiX8RBIPgia/5BbGN2VEOT1feJyhvtPOswPW9k4xW7/masalS8fHPcrpZ
         w+gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755215512; x=1755820312;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nWEAphj4m/uzejg39gNHA2RWkzZcuFUCit1TiH9ELm0=;
        b=lPrfSGFUAlElp77vJHBM+PyQd7Ng36FHw5XL+LgNDzsZ3brFs7gegHuA1SB2SDaAwZ
         ocPbe052tLZZ+zSgHfr5KdPg6917fohIH2CwC5/XNTZJ/7iBKkPWizbVlOSxOtzB0xLz
         9JfUn2zosedtBJmlTURl/aF8l0IICnvd4Ze9sH2dz8he8G8TsCA7wBhdrihI1JmzQQiG
         Pm2l7I5YzgNQfYMA/h2FyazlJETsvYJvURCflFMfhuJYHYG4lVwBu0YAwt4nioC2v79O
         HsaELcwgDfcDM3qRw68JQoLc24mygtdno9KTI8svaaJs+6IdQJfIWLo1JsIy0ahmEPGG
         ojRg==
X-Forwarded-Encrypted: i=1; AJvYcCVXnff0Yco0qtxudxjxnXSNirCIrZirvG6KquJ1TRirUJxLKabzsUhgDQjXI27ZyzntiObmGKR3UWkq@vger.kernel.org, AJvYcCXh4lidyQrNB2sd7jltlLfb3Xv3EJjkphyjU0qHYuvs9shVsk3hFHHNFT9QC9ae37juD/7IwtdWO5UdZN6Z@vger.kernel.org
X-Gm-Message-State: AOJu0Yx5BYsDEzDnQJMfdmJHcGOfe8B8wQDlDEZJW+oT08jzKULPA3Cu
	sPYv0+IbNg5rO9Bb5iJjrMntTLptZELlnBlaPWQsazhV5eEpzo7sHXfU2AhhFxtDe6o=
X-Gm-Gg: ASbGncstK7697mR4+i19hdZvSu/8UeEVYhYqsFahWrZDHj0Z+dQ15kYaW4yHlcGb9Fh
	PIIwZ6k1z+dn83L32sligdSOR6ujWm4AzxQ6DoatoD8Me1Hv0X/NoY6wnH84K1DNDtXCiEztmvl
	hQ6ZbiAOE9wGTI0q9KBEdyo9LQEWzmUCE2gNJzT/svVTnvrIldyCjtQE5Y8k6gC5BWfXmd6k4zG
	RJVXvpsTuaAEyo7IXxqwlb9WoUmU0HTi1ljQRbq6Npf87N/XXdlKsRNyWebsKdBsX434MysJNNY
	r8w8/C2JTme1b/r3IQ7eHw433sfON+L/iwqWjik0XB6lfWyl0YZ685YwIkap9B9OVU4wG5IMIVz
	CU3xXyggiavJdSwKj75Jyrd6M
X-Google-Smtp-Source: AGHT+IGAH2BfgBfw7vvtObihS4KTIKjz40J3ccIYBwu2pqgeegIP/7mgDHHjGJdmmuA4bGd2c1q2oQ==
X-Received: by 2002:a17:90a:c10e:b0:31f:485f:fab6 with SMTP id 98e67ed59e1d1-32341df8efamr245772a91.4.1755215512102;
        Thu, 14 Aug 2025 16:51:52 -0700 (PDT)
Received: from jicarita ([65.144.169.45])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3233100c1d0sm2974721a91.17.2025.08.14.16.51.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Aug 2025 16:51:51 -0700 (PDT)
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: io-uring@vger.kernel.org,
	axboe@kernel.dk,
	linux-fsdevel@vger.kernel.org,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	linux-nfs@vger.kernel.org
Cc: Thomas Bertschinger <tahbertschinger@gmail.com>
Subject: [PATCH 6/6] io_uring: add support for IORING_OP_OPEN_BY_HANDLE_AT
Date: Thu, 14 Aug 2025 17:54:31 -0600
Message-ID: <20250814235431.995876-7-tahbertschinger@gmail.com>
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

This adds support for open_by_handle_at(2) to io_uring.

Non-blocking open by handle is not yet supported, so this always runs in
async context.

Signed-off-by: Thomas Bertschinger <tahbertschinger@gmail.com>
---
 include/uapi/linux/io_uring.h |  1 +
 io_uring/opdef.c              |  7 ++++
 io_uring/openclose.c          | 64 ++++++++++++++++++++++++++++++++++-
 io_uring/openclose.h          |  2 ++
 4 files changed, 73 insertions(+), 1 deletion(-)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 596bae788b48..946da13e1454 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -290,6 +290,7 @@ enum io_uring_op {
 	IORING_OP_WRITEV_FIXED,
 	IORING_OP_PIPE,
 	IORING_OP_NAME_TO_HANDLE_AT,
+	IORING_OP_OPEN_BY_HANDLE_AT,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index ff2672bbd583..e2e0f4ed0d9d 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -578,6 +578,10 @@ const struct io_issue_def io_issue_defs[] = {
 		.prep			= io_name_to_handle_at_prep,
 		.issue			= io_name_to_handle_at,
 	},
+	[IORING_OP_OPEN_BY_HANDLE_AT] = {
+		.prep			= io_open_by_handle_at_prep,
+		.issue			= io_open_by_handle_at,
+	},
 };
 
 const struct io_cold_def io_cold_defs[] = {
@@ -831,6 +835,9 @@ const struct io_cold_def io_cold_defs[] = {
 	[IORING_OP_NAME_TO_HANDLE_AT] = {
 		.name			= "NAME_TO_HANDLE_AT",
 	},
+	[IORING_OP_OPEN_BY_HANDLE_AT] = {
+		.name			= "OPEN_BY_HANDLE_AT",
+	}
 };
 
 const char *io_uring_get_opcode(u8 opcode)
diff --git a/io_uring/openclose.c b/io_uring/openclose.c
index 8be061783207..5be17d7a46e0 100644
--- a/io_uring/openclose.c
+++ b/io_uring/openclose.c
@@ -22,7 +22,13 @@ struct io_open {
 	struct file			*file;
 	int				dfd;
 	u32				file_slot;
-	struct filename			*filename;
+	union {
+		/* For openat(), openat2() */
+		struct filename		*filename;
+
+		/* For open_by_handle_at() */
+		struct file_handle __user *ufh;
+	};
 	struct open_how			how;
 	unsigned long			nofile;
 };
@@ -244,6 +250,62 @@ int io_name_to_handle_at(struct io_kiocb *req, unsigned int issue_flags)
 	return IOU_COMPLETE;
 }
 
+int io_open_by_handle_at_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_open *open = io_kiocb_to_cmd(req, struct io_open);
+	u64 flags;
+
+	flags = READ_ONCE(sqe->open_flags);
+	open->how = build_open_how(flags, 0);
+	open->ufh = u64_to_user_ptr(READ_ONCE(sqe->addr));
+
+	__io_open_prep(req, sqe);
+
+	return 0;
+}
+
+int io_open_by_handle_at(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_open *open = io_kiocb_to_cmd(req, struct io_open);
+	struct file *file;
+	bool fixed = !!open->file_slot;
+	int ret;
+
+	/*
+	 * Always try again if we aren't supposed to block, because there is no
+	 * way of preventing the FS implementation from blocking.
+	 */
+	if (issue_flags & IO_URING_F_NONBLOCK)
+		return -EAGAIN;
+
+	if (!fixed) {
+		ret = __get_unused_fd_flags(open->how.flags, open->nofile);
+		if (ret < 0)
+			goto err;
+	}
+
+	file = __do_handle_open(open->dfd, open->ufh, open->how.flags);
+
+	if (IS_ERR(file)) {
+		if (!fixed)
+			put_unused_fd(ret);
+		ret = PTR_ERR(file);
+		goto err;
+	}
+
+	if (!fixed)
+		fd_install(ret, file);
+	else
+		ret = io_fixed_fd_install(req, issue_flags, file,
+					  open->file_slot);
+
+err:
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
index 3d1096abffac..a6304fa856bf 100644
--- a/io_uring/openclose.h
+++ b/io_uring/openclose.h
@@ -12,6 +12,8 @@ int io_openat2(struct io_kiocb *req, unsigned int issue_flags);
 
 int io_name_to_handle_at_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_name_to_handle_at(struct io_kiocb *req, unsigned int issue_flags);
+int io_open_by_handle_at_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+int io_open_by_handle_at(struct io_kiocb *req, unsigned int issue_flags);
 
 int io_close_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_close(struct io_kiocb *req, unsigned int issue_flags);
-- 
2.50.1


