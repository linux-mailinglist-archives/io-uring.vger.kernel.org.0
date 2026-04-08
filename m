Return-Path: <io-uring+bounces-13007-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 6HKJL9ys1mncHAgAu9opvQ
	(envelope-from <io-uring+bounces-13007-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 08 Apr 2026 21:30:36 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 36BF23C3184
	for <lists+io-uring@lfdr.de>; Wed, 08 Apr 2026 21:30:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 05CD63018C0D
	for <lists+io-uring@lfdr.de>; Wed,  8 Apr 2026 19:30:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 92785284896;
	Wed,  8 Apr 2026 19:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="KDqqloHx"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 123B337703A
	for <io-uring@vger.kernel.org>; Wed,  8 Apr 2026 19:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775676631; cv=none; b=Pu9jRgJP2yU7Ijvkp6q0hcM0aOo4xbsxY1kQOaOYOa4KPEApr6Bh7ytno6nAe/VVZ9B7uPWOtFEvYkYjzeTQzUXK+ODinFHpHPMe7XPHM3/JAkOxoVQcq0jiznwC5ajm3Lgq5Omq2lFQrZgHXulgnESgdXLY/r8f8Wgl77TUOXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775676631; c=relaxed/simple;
	bh=/zU87SmueOV7e8wW2X1w4N2M9wxJMu/WcsK1JqUeMU4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VTAmaWWsMlt2GtARkLiSeMwDuWw4HMx9PLU1wtvTPLsREnv8foFY7kxG+39Uon9hwdB6r0j7s9LzWVYLOkoT+5zXlbm+vZ0rt49YovknXBj6wQyKs6lk9K7M3k9MVs87k7Jyb+dpEZMo113YFJb2SSnV6ZOCX8H97B0D07u9lBo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=KDqqloHx; arc=none smtp.client-ip=209.85.160.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-40ee9b945d5so111962fac.0
        for <io-uring@vger.kernel.org>; Wed, 08 Apr 2026 12:30:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1775676629; x=1776281429; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zVayoFflYWWrwdAvYem19bk9GvNhhNEgAEE1tivgv6k=;
        b=KDqqloHxmLkKHVs1+8O/Elkv67BdDH05XxOgBN87fAzRGqAC/qRuSzoG2Npayta945
         RRNNr/nN1f0yVsS1E8ELbZBfysv4Uy+leZM9aV04elN9BmWJ4hZuoyZQq3pQYbXYRRYW
         pnS/uz9KGDmbMMGIZ5Qlkqf6GITZvJNpWb2BbEy4q/5o9esaQCDSqK2/w+gkFFfc0XMo
         8E3TyPltNKMrIsx8uuFnXb+m2ri/gCEY4qwsafmGKl5ZdNsYBdGlMiUKYkJ3oGv51pdY
         XJ/MRUgHlXeDPImQMxY+rsk5HsAWerryNrEryI8Abpuys4JGJpyRA5TNDp/OZBLy9u/T
         C3wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775676629; x=1776281429;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=zVayoFflYWWrwdAvYem19bk9GvNhhNEgAEE1tivgv6k=;
        b=ZwBqAzMo9rFkDJ/MDUpsWGFy+T7uencRTwxTjQzfGdhbasHxswd0AJbEQSNZf6SMOD
         CiZuPStbk5owxKUDSyWJmwWypQ1f38H+1KXKUMq0tEhS8EMjyMn1sS6phdgtOhMxBdJs
         asEbxwrL2njtX8tBOI6tkHsK21cFeuemMrVQr5FRLaSyOyR/pwF+00llLyy9F4v8U7El
         EvvfyRq1oa+pRIlF0zfSe8GHIooN0raCu7CgMJWrxkMYHFEYIwhBz9s78KByncgTH1sT
         VQZ8wz3QMS9zLBZXQBL3BufuImY+rvtVtzBDXyWLiJQVEQ/RMN9bZx6yrOc1AvxNMZ+Z
         WL+w==
X-Gm-Message-State: AOJu0YzPuPp+kvIRK17m6YGmpdmQDoq61WpxdF8uWQH/zWdkHmfGAxtL
	gdK849cpKUxygSEzvMwAnsYYDTVEYOb7XGAooUyw/jErCZ4oFlhVME0iQELn0Qmq16p6kf+ISNY
	go0gO
X-Gm-Gg: AeBDieug1KZGdn24csoFL5mBG/3ZIOyljmYgKD04+0Mz4/y0aZI0xYnlh97gl71jlQq
	tYwKgAd75d0Tud2+p8qJZdFJ2oqDYS5Uh1CZbk/drGl7imv2zl8MD2/mfIIOWZEiu/8HaA8FUYJ
	VKC8PnAZKNIt1w7P85hLyrLo7ZQjm+UQPlpK7biVIdmDeY/4b+DFAqYy8yUPtEG1rPdB/N4MiUX
	u0RL4Q5De9k9S+azPDYhZuefhxFDObdCdjn3vqEd9NAyxlVp79FD0jJ8HxLEiCJ0ijcMm2iH8Om
	iEQQP51u9vttmv0nwcYwJgReZOnmsJ0NqRFahD5C5iWznR+PUJmRoCADM2fHRPOx4jnNNiYvkPc
	wFqt9Ov25CIv3nB8bmIaItLWI3qpUYK14B7EC28RErpPDR74rXezogIxRto/PYNybZVYYZzBfHP
	1CjBOX5Sq8W9oJxYfSSMVcRaeWshAZM3saeFvD6mFjqBqxm/kgUaM/2bMIxNpCQVPkAF5oGDqIN
	NkpSw==
X-Received: by 2002:a05:6871:2315:b0:41c:6a4b:8dee with SMTP id 586e51a60fabf-4231007e373mr12964299fac.39.1775676628575;
        Wed, 08 Apr 2026 12:30:28 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-422eb25a55asm17486812fac.10.2026.04.08.12.30.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2026 12:30:27 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] io_uring: unify getting ctx from passed in file descriptor
Date: Wed,  8 Apr 2026 13:27:41 -0600
Message-ID: <20260408193023.397746-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408193023.397746-1-axboe@kernel.dk>
References: <20260408193023.397746-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_LAST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13007-lists,io-uring=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[5];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel-dk.20251104.gappssmtp.com:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,kernel.dk:email,kernel.dk:mid]
X-Rspamd-Queue-Id: 36BF23C3184
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

io_uring_enter() and io_uring_register() end up having duplicated code
for getting a ctx from a passed in file descriptor, for either a
registered ring descriptor or a normal file descriptor. Move the
io_uring_register_get_file() into io_uring.c and name it a bit more
generically, and use it from both callsites rather than have that logic
and handling duplicated.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/bpf-ops.c  |  2 +-
 io_uring/io_uring.c | 57 ++++++++++++++++++++++++++++-----------------
 io_uring/io_uring.h |  1 +
 io_uring/register.c | 35 +---------------------------
 io_uring/register.h |  1 -
 io_uring/rsrc.c     |  2 +-
 6 files changed, 40 insertions(+), 58 deletions(-)

diff --git a/io_uring/bpf-ops.c b/io_uring/bpf-ops.c
index e4b244337aa9..937e48bef40b 100644
--- a/io_uring/bpf-ops.c
+++ b/io_uring/bpf-ops.c
@@ -181,7 +181,7 @@ static int bpf_io_reg(void *kdata, struct bpf_link *link)
 	struct file *file;
 	int ret = -EBUSY;
 
-	file = io_uring_register_get_file(ops->ring_fd, false);
+	file = io_uring_ctx_get_file(ops->ring_fd, false);
 	if (IS_ERR(file))
 		return PTR_ERR(file);
 	ctx = file->private_data;
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 16122f877aed..003f0e081d92 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2543,39 +2543,54 @@ static int io_get_ext_arg(struct io_ring_ctx *ctx, unsigned flags,
 #endif
 }
 
-SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
-		u32, min_complete, u32, flags, const void __user *, argp,
-		size_t, argsz)
+/*
+ * Given an 'fd' value, return the ctx associated with if. If 'registered' is
+ * true, then the registered index is used. Otherwise, the normal fd table.
+ * Caller must call fput() on the returned file if it isn't a registered file,
+ * unless it's an ERR_PTR.
+ */
+struct file *io_uring_ctx_get_file(unsigned int fd, bool registered)
 {
-	struct io_ring_ctx *ctx;
 	struct file *file;
-	long ret;
-
-	if (unlikely(flags & ~IORING_ENTER_FLAGS))
-		return -EINVAL;
 
-	/*
-	 * Ring fd has been registered via IORING_REGISTER_RING_FDS, we
-	 * need only dereference our task private array to find it.
-	 */
-	if (flags & IORING_ENTER_REGISTERED_RING) {
+	if (registered) {
+		/*
+		 * Ring fd has been registered via IORING_REGISTER_RING_FDS, we
+		 * need only dereference our task private array to find it.
+		 */
 		struct io_uring_task *tctx = current->io_uring;
 
 		if (unlikely(!tctx || fd >= IO_RINGFD_REG_MAX))
-			return -EINVAL;
+			return ERR_PTR(-EINVAL);
 		fd = array_index_nospec(fd, IO_RINGFD_REG_MAX);
 		file = tctx->registered_rings[fd];
-		if (unlikely(!file))
-			return -EBADF;
 	} else {
 		file = fget(fd);
-		if (unlikely(!file))
-			return -EBADF;
-		ret = -EOPNOTSUPP;
-		if (unlikely(!io_is_uring_fops(file)))
-			goto out;
 	}
 
+	if (unlikely(!file))
+		return ERR_PTR(-EBADF);
+	if (io_is_uring_fops(file))
+		return file;
+	fput(file);
+	return ERR_PTR(-EOPNOTSUPP);
+}
+
+
+SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
+		u32, min_complete, u32, flags, const void __user *, argp,
+		size_t, argsz)
+{
+	struct io_ring_ctx *ctx;
+	struct file *file;
+	long ret;
+
+	if (unlikely(flags & ~IORING_ENTER_FLAGS))
+		return -EINVAL;
+
+	file = io_uring_ctx_get_file(fd, flags & IORING_ENTER_REGISTERED_RING);
+	if (IS_ERR(file))
+		return PTR_ERR(file);
 	ctx = file->private_data;
 	ret = -EBADFD;
 	/*
diff --git a/io_uring/io_uring.h b/io_uring/io_uring.h
index 91cf67b5d85b..e43995682c8b 100644
--- a/io_uring/io_uring.h
+++ b/io_uring/io_uring.h
@@ -173,6 +173,7 @@ void io_req_track_inflight(struct io_kiocb *req);
 struct file *io_file_get_normal(struct io_kiocb *req, int fd);
 struct file *io_file_get_fixed(struct io_kiocb *req, int fd,
 			       unsigned issue_flags);
+struct file *io_uring_ctx_get_file(unsigned int fd, bool registered);
 
 void io_req_task_queue(struct io_kiocb *req);
 void io_req_task_complete(struct io_tw_req tw_req, io_tw_token_t tw);
diff --git a/io_uring/register.c b/io_uring/register.c
index 95cfa88dc621..6260196929a7 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -938,39 +938,6 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 	return ret;
 }
 
-/*
- * Given an 'fd' value, return the ctx associated with if. If 'registered' is
- * true, then the registered index is used. Otherwise, the normal fd table.
- * Caller must call fput() on the returned file if it isn't a registered file,
- * unless it's an ERR_PTR.
- */
-struct file *io_uring_register_get_file(unsigned int fd, bool registered)
-{
-	struct file *file;
-
-	if (registered) {
-		/*
-		 * Ring fd has been registered via IORING_REGISTER_RING_FDS, we
-		 * need only dereference our task private array to find it.
-		 */
-		struct io_uring_task *tctx = current->io_uring;
-
-		if (unlikely(!tctx || fd >= IO_RINGFD_REG_MAX))
-			return ERR_PTR(-EINVAL);
-		fd = array_index_nospec(fd, IO_RINGFD_REG_MAX);
-		file = tctx->registered_rings[fd];
-	} else {
-		file = fget(fd);
-	}
-
-	if (unlikely(!file))
-		return ERR_PTR(-EBADF);
-	if (io_is_uring_fops(file))
-		return file;
-	fput(file);
-	return ERR_PTR(-EOPNOTSUPP);
-}
-
 static int io_uring_register_send_msg_ring(void __user *arg, unsigned int nr_args)
 {
 	struct io_uring_sqe sqe;
@@ -1025,7 +992,7 @@ SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, unsigned int, opcode,
 	if (fd == -1)
 		return io_uring_register_blind(opcode, arg, nr_args);
 
-	file = io_uring_register_get_file(fd, use_registered_ring);
+	file = io_uring_ctx_get_file(fd, use_registered_ring);
 	if (IS_ERR(file))
 		return PTR_ERR(file);
 	ctx = file->private_data;
diff --git a/io_uring/register.h b/io_uring/register.h
index a5f39d5ef9e0..c9da997d503c 100644
--- a/io_uring/register.h
+++ b/io_uring/register.h
@@ -4,6 +4,5 @@
 
 int io_eventfd_unregister(struct io_ring_ctx *ctx);
 int io_unregister_personality(struct io_ring_ctx *ctx, unsigned id);
-struct file *io_uring_register_get_file(unsigned int fd, bool registered);
 
 #endif
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index cb12194b35e8..57151c01da0f 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1269,7 +1269,7 @@ int io_register_clone_buffers(struct io_ring_ctx *ctx, void __user *arg)
 		return -EINVAL;
 
 	registered_src = (buf.flags & IORING_REGISTER_SRC_REGISTERED) != 0;
-	file = io_uring_register_get_file(buf.src_fd, registered_src);
+	file = io_uring_ctx_get_file(buf.src_fd, registered_src);
 	if (IS_ERR(file))
 		return PTR_ERR(file);
 
-- 
2.53.0


