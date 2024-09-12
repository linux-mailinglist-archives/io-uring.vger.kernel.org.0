Return-Path: <io-uring+bounces-3180-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E8B4976EE8
	for <lists+io-uring@lfdr.de>; Thu, 12 Sep 2024 18:40:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id F20A91F25FB2
	for <lists+io-uring@lfdr.de>; Thu, 12 Sep 2024 16:40:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A10AE1AB6CA;
	Thu, 12 Sep 2024 16:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="vVPEMRnV"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f171.google.com (mail-il1-f171.google.com [209.85.166.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DDD61B373C
	for <io-uring@vger.kernel.org>; Thu, 12 Sep 2024 16:40:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726159229; cv=none; b=I9MRi7Z/cC+EKQO1U9e6yhYxgHrsnEC2tkJQ9SQ2TNR0P5C4c3aQ78KlFIMlAjgIycFWlEcfLTJEnwvCLTo7uvsuNyVLqboeJycsMyTiARVs5SA1jr2z/S5370lV/7Ey7KAWIDwqE5l7KBj+mZnwnq6FJFv8GoHT3rUn8oQdufY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726159229; c=relaxed/simple;
	bh=ofcd9ZfwXZC926+j/ai6Tgwm6zx2Xxb8xIDZxdFekBU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AlsHr/E6Fwc1jfPs9NF5dYuzCRHvegagzwE8/4Y9iWYPMoNXSzcP9UBI3Tz3ZyOkocbZDHaPrW/VzHKsy4h6kcRUs37pB2jMmyyHkDgnqVOLWrjb5MVWAt9fTGWk+H03ZE0bQP2f+jmZ33B5C0XfVgOTLN4O32WJHuAIsDsrUbk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=vVPEMRnV; arc=none smtp.client-ip=209.85.166.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f171.google.com with SMTP id e9e14a558f8ab-3a07b73cf4eso163895ab.3
        for <io-uring@vger.kernel.org>; Thu, 12 Sep 2024 09:40:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1726159226; x=1726764026; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jZLxd3vq3MiYnms3SCnT2pvoOPN4l/5rBTAnIjuZGxU=;
        b=vVPEMRnVvoQkYXbTzVpw8QijewDruO2P25TSb9KNiAWiouJ9trGYxdsdb5oaFaP1Nl
         z5J6QYwMG+rjH7tDaqga2rzx4Tx2cub5znt5uwnxsDvrG74+bUHX4rjiYP3C2W0A9pQ3
         zHnKpBuXoHElfP/MqUlj3y/HcSDRE37QC39IdSd7ZkNnvP7DLnkW+EnuWcsx+a95mspE
         J5fyY25XE1LjJKTE8FV1TZFgkza/KQnCVhsDdtosYM7p9a4XCzekW1K21SubxU8KYiQq
         SWVti014CT4cLEZWC0j7so+ASk07cbLuNUanCC4iGDNFcZey2ph3GZ7H1FAWGQR5I6cE
         oQeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726159226; x=1726764026;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jZLxd3vq3MiYnms3SCnT2pvoOPN4l/5rBTAnIjuZGxU=;
        b=uIa/Xg0q9uTldK/cnyyWXInlbR3oyWV+smjkuiNXTMW7nDICbs9xb52PC/piYAV+s8
         a+ZMk45Nk7ImT/CXpUQEIfsEehLZwlUpGJYi+DfPMLN+TgDros/7GyFdnGK/col8LJAk
         DFdyY8TkpRbX+tvQBMs4SV1hz2iHjGpIl9VGVmoYIUuoyaiQa6dkkktDB+mfeKUjETuc
         yX2rKLJdLllXPWwOrWgWEsFoVueH3j4QUKn0ztznMXNNvpxD6Ea+uAiwAwIcXJBNjWyV
         Exw4zwWcxJJ1PfJPNleywOlt9ydB/HTLr+LCwKh+6VwK/jKOQF/Fs3zIbfTqiS8+eKlG
         yAxA==
X-Gm-Message-State: AOJu0YzxIRZcmlAgn9hjOl5elfHJCSRjvBe98ReiPeLySODKEE36XJzq
	U5pgcqUccMOND/1TkOW9kZGd03vYT/UyQK1UmF+l6C5370LWKbu1UFgQ9AqPRZWT+SiUXFqrNI4
	a
X-Google-Smtp-Source: AGHT+IHYs3LQhIVl5AvuIG6mfUvpDA4V5Ng1JBJ6bS5CkzxcpmKOZNqtvJ56eC1ZPpXzTnUYIz3y/Q==
X-Received: by 2002:a05:6e02:188c:b0:398:36c0:7968 with SMTP id e9e14a558f8ab-3a0848fae61mr41590125ab.6.1726159225829;
        Thu, 12 Sep 2024 09:40:25 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3a05901625esm32564985ab.85.2024.09.12.09.40.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Sep 2024 09:40:24 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/4] io_uring/register: provide helper to get io_ring_ctx from 'fd'
Date: Thu, 12 Sep 2024 10:38:22 -0600
Message-ID: <20240912164019.634560-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240912164019.634560-1-axboe@kernel.dk>
References: <20240912164019.634560-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Can be done in one of two ways:

1) Regular file descriptor, just fget()
2) Registered ring, index our own table for that

In preparation for adding another register use of needing to get a ctx
from a file descriptor, abstract out this helper and use it in the main
register syscall as well.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/register.c | 54 +++++++++++++++++++++++++++------------------
 io_uring/register.h |  1 +
 2 files changed, 34 insertions(+), 21 deletions(-)

diff --git a/io_uring/register.c b/io_uring/register.c
index 57cb85c42526..d90159478045 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -550,21 +550,16 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 	return ret;
 }
 
-SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, unsigned int, opcode,
-		void __user *, arg, unsigned int, nr_args)
+/*
+ * Given an 'fd' value, return the ctx associated with if. If 'registered' is
+ * true, then the registered index is used. Otherwise, the normal fd table.
+ * Caller must call fput() on the returned file, unless it's an ERR_PTR.
+ */
+struct file *io_uring_register_get_file(int fd, bool registered)
 {
-	struct io_ring_ctx *ctx;
-	long ret = -EBADF;
 	struct file *file;
-	bool use_registered_ring;
 
-	use_registered_ring = !!(opcode & IORING_REGISTER_USE_REGISTERED_RING);
-	opcode &= ~IORING_REGISTER_USE_REGISTERED_RING;
-
-	if (opcode >= IORING_REGISTER_LAST)
-		return -EINVAL;
-
-	if (use_registered_ring) {
+	if (registered) {
 		/*
 		 * Ring fd has been registered via IORING_REGISTER_RING_FDS, we
 		 * need only dereference our task private array to find it.
@@ -572,27 +567,44 @@ SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, unsigned int, opcode,
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
-		if (!io_is_uring_fops(file))
-			goto out_fput;
 	}
 
+	if (unlikely(!file))
+		return ERR_PTR(-EBADF);
+	if (io_is_uring_fops(file))
+		return file;
+	fput(file);
+	return ERR_PTR(-EOPNOTSUPP);
+}
+
+SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, unsigned int, opcode,
+		void __user *, arg, unsigned int, nr_args)
+{
+	struct io_ring_ctx *ctx;
+	long ret = -EBADF;
+	struct file *file;
+	bool use_registered_ring;
+
+	use_registered_ring = !!(opcode & IORING_REGISTER_USE_REGISTERED_RING);
+	opcode &= ~IORING_REGISTER_USE_REGISTERED_RING;
+
+	if (opcode >= IORING_REGISTER_LAST)
+		return -EINVAL;
+
+	file = io_uring_register_get_file(fd, use_registered_ring);
+	if (IS_ERR(file))
+		return PTR_ERR(file);
 	ctx = file->private_data;
 
 	mutex_lock(&ctx->uring_lock);
 	ret = __io_uring_register(ctx, opcode, arg, nr_args);
 	mutex_unlock(&ctx->uring_lock);
 	trace_io_uring_register(ctx, opcode, ctx->nr_user_files, ctx->nr_user_bufs, ret);
-out_fput:
 	if (!use_registered_ring)
 		fput(file);
 	return ret;
diff --git a/io_uring/register.h b/io_uring/register.h
index c9da997d503c..cc69b88338fe 100644
--- a/io_uring/register.h
+++ b/io_uring/register.h
@@ -4,5 +4,6 @@
 
 int io_eventfd_unregister(struct io_ring_ctx *ctx);
 int io_unregister_personality(struct io_ring_ctx *ctx, unsigned id);
+struct file *io_uring_register_get_file(int fd, bool registered);
 
 #endif
-- 
2.45.2


