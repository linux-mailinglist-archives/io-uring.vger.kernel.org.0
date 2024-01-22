Return-Path: <io-uring+bounces-443-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 12F768372BA
	for <lists+io-uring@lfdr.de>; Mon, 22 Jan 2024 20:37:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B91C428A5E2
	for <lists+io-uring@lfdr.de>; Mon, 22 Jan 2024 19:37:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D40663F8C4;
	Mon, 22 Jan 2024 19:37:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="g5gsTaUC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D76E3F8D2
	for <io-uring@vger.kernel.org>; Mon, 22 Jan 2024 19:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705952266; cv=none; b=sEGF32aqdWQDC1MPSVs4bs1nyQLCYN0avEcFI3/XE7UBP46QJ7CPJIMx8IFbRrGPz+G5phYYwho5Dwm7b5ioDMgcakO7yVfQArLYuFjI4rA9XDgpj8gh/gXHqf2QgKLscKmWKN6UvQmKCzvTFG1Jnwp2q96WlltwFGqIctSksSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705952266; c=relaxed/simple;
	bh=xpXrrI5gjQwRb238G2EdmMwqGTvGZPTJaUoGQRxATHk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=FyM9K18D0+0w4xL6fYdzwUvdaI4Gx0HN7/ZdRL1Lz/gCI5kNpDB14gBRNtZIma4sucP5W6H3NBJSvnopHFhZHxme+O5qQ+9kuXyZFenrBiyn8PDpM0sjAmT6fB4d3Wnfo1yvknC5Qm20N7c3FmOMQxx/3oTKeXuXLQosRfQ0PHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=g5gsTaUC; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-40e800461baso42767365e9.3
        for <io-uring@vger.kernel.org>; Mon, 22 Jan 2024 11:37:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705952263; x=1706557063; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DOy8z03fHJRu4P7xsm57YKZAkwH619m6VruLB857coU=;
        b=g5gsTaUCfPOdYx/RgfEAXcstnoypd9MEqn7GOQSgUILjB6ohiFtDbphhcKNiSKrdbf
         JueS4daGkYv+PBF3WDuKaV99jcC5dohamfrSwCrmps0Nq9lytPgVV7iDOQKNxFB/K8Pl
         if1lvm0scG+Al5jcL40xxNiqOhIE0xIQ15Q3aBaRsu5QEH8HcxYTFXOE1uyyf4Gr29Wh
         Go7PtVMmQmTfuoEp27fJBshJ8I3eBTbHHSFEg+zxtORCX5OEBkYJg5Lu6A1cjF6SmfoD
         Hic9ykJgCfFMN/Ttc+9u/OGcCcD8Mge0Jo0rvA5/0TSOnIRwnzqaEt5FohNkluAPpLWk
         lstA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705952263; x=1706557063;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DOy8z03fHJRu4P7xsm57YKZAkwH619m6VruLB857coU=;
        b=lNWPFud5lS/EqXaEKVtop16508138teshCt43H9xGYSSXRp2EDqQLN1rpF+qXYqvmC
         RNXrpvAwG7+m6m6/WFdJfqEhfZZqfSmec2EQs0ZQ0ywUeqhx5j0XxxvBItTGx4rgvU4l
         B1FjSTrzLTmpYjViZwojmDo5X1Yh/vphOzyeMGzqFpt9NdTrXVLKhGEJ7cSASm5YX6yA
         9HXziN/mJOJ8cZZDNbt3cR7qU80pSCsS/P58R/Y+c+SwhXZyvlRJcOirvZIQnsSjgbVz
         GJYXWZ48LLl/NePvNVyGYmwIEvloaTmZhGHx37p6Ahf24h/RW9e5EAxFd4Vw3FhDoAuI
         Na0A==
X-Gm-Message-State: AOJu0YwTyLRF1zudDWQ6fGrKVN0DNd8s2PjCyfMGQcAZ8Vy98gnOn9Js
	3xVtLqEy61wxW8eNAOHYEzshAzaeBW+BhU0/smNbpH7We2jOsLUfXzsUyrCdNL2zJw==
X-Google-Smtp-Source: AGHT+IHIZK6QQqkaTM105ewc0KS7SLpHOR/YwSRqvpzu3mNU9oFzIU3sCCGuIlujrNzQv+10sB66Pw==
X-Received: by 2002:a05:600c:818:b0:40e:7efd:7f01 with SMTP id k24-20020a05600c081800b0040e7efd7f01mr1204573wmp.368.1705952262799;
        Mon, 22 Jan 2024 11:37:42 -0800 (PST)
Received: from localhost.localdomain ([147.235.201.119])
        by smtp.gmail.com with ESMTPSA id jb13-20020a05600c54ed00b0040e418494absm39138945wmb.46.2024.01.22.11.37.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Jan 2024 11:37:42 -0800 (PST)
From: Tony Solomonik <tony.solomonik@gmail.com>
To: axboe@kernel.dk,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org
Cc: Tony Solomonik <tony.solomonik@gmail.com>
Subject: [PATCH 2/2] io_uring: add support for ftruncate
Date: Mon, 22 Jan 2024 21:37:32 +0200
Message-Id: <20240122193732.23217-2-tony.solomonik@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20240122193732.23217-1-tony.solomonik@gmail.com>
References: <20240122193732.23217-1-tony.solomonik@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Like truncate, ftruncate should also be supported in io_uring.
---
 include/uapi/linux/io_uring.h |  1 +
 io_uring/opdef.c              |  7 +++++++
 io_uring/truncate.c           | 37 +++++++++++++++++++++++++++++++++++
 io_uring/truncate.h           |  3 +++
 4 files changed, 48 insertions(+)

diff --git a/include/uapi/linux/io_uring.h b/include/uapi/linux/io_uring.h
index 513f31ee8ce9..8ebaf667c07d 100644
--- a/include/uapi/linux/io_uring.h
+++ b/include/uapi/linux/io_uring.h
@@ -254,6 +254,7 @@ enum io_uring_op {
 	IORING_OP_FUTEX_WAKE,
 	IORING_OP_FUTEX_WAITV,
 	IORING_OP_TRUNCATE,
+	IORING_OP_FTRUNCATE,
 
 	/* this goes last, obviously */
 	IORING_OP_LAST,
diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 60827099e244..88054f3df83c 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -474,6 +474,10 @@ const struct io_issue_def io_issue_defs[] = {
 		.prep			= io_truncate_prep,
 		.issue			= io_truncate,
 	},
+	[IORING_OP_FTRUNCATE] = {
+		.prep			= io_ftruncate_prep,
+		.issue			= io_ftruncate,
+	},
 };
 
 const struct io_cold_def io_cold_defs[] = {
@@ -712,6 +716,9 @@ const struct io_cold_def io_cold_defs[] = {
 	[IORING_OP_TRUNCATE] = {
 		.name			= "TRUNCATE",
 	},
+	[IORING_OP_FTRUNCATE] = {
+		.name			= "FTRUNCATE",
+	},
 };
 
 const char *io_uring_get_opcode(u8 opcode)
diff --git a/io_uring/truncate.c b/io_uring/truncate.c
index 82648b2fbc7e..e31d28a478d2 100644
--- a/io_uring/truncate.c
+++ b/io_uring/truncate.c
@@ -21,6 +21,12 @@ struct io_trunc {
 	loff_t				len;
 };
 
+struct io_ftrunc {
+	struct file			*file;
+	int				dfd;
+	loff_t				len;
+};
+
 int io_truncate_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 {
 	struct io_trunc *tr = io_kiocb_to_cmd(req, struct io_trunc);
@@ -51,3 +57,34 @@ int io_truncate(struct io_kiocb *req, unsigned int issue_flags)
 	io_req_set_res(req, ret, 0);
 	return IOU_OK;
 }
+
+int io_ftruncate_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
+{
+	struct io_ftrunc *ft = io_kiocb_to_cmd(req, struct io_ftrunc);
+
+	if (sqe->off || sqe->rw_flags || sqe->buf_index || sqe->splice_fd_in)
+		return -EINVAL;
+	if (unlikely(req->flags & REQ_F_FIXED_FILE))
+		return -EBADF;
+
+	ft->dfd = READ_ONCE(sqe->fd);
+	ft->len = READ_ONCE(sqe->len);
+
+	req->flags |= REQ_F_NEED_CLEANUP;
+	req->flags |= REQ_F_FORCE_ASYNC;
+	return 0;
+}
+
+int io_ftruncate(struct io_kiocb *req, unsigned int issue_flags)
+{
+	struct io_ftrunc *ft = io_kiocb_to_cmd(req, struct io_ftrunc);
+	int ret;
+
+	WARN_ON_ONCE(issue_flags & IO_URING_F_NONBLOCK);
+
+	ret = do_sys_ftruncate(ft->dfd, ft->len, 1);
+
+	req->flags &= ~REQ_F_NEED_CLEANUP;
+	io_req_set_res(req, ret, 0);
+	return IOU_OK;
+}
diff --git a/io_uring/truncate.h b/io_uring/truncate.h
index ab17cb9acc90..a9fc20b5f926 100644
--- a/io_uring/truncate.h
+++ b/io_uring/truncate.h
@@ -2,3 +2,6 @@
 
 int io_truncate_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
 int io_truncate(struct io_kiocb *req, unsigned int issue_flags);
+
+int io_ftruncate_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe);
+int io_ftruncate(struct io_kiocb *req, unsigned int issue_flags);
-- 
2.34.1


