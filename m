Return-Path: <io-uring+bounces-179-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 13ADB7FFBC4
	for <lists+io-uring@lfdr.de>; Thu, 30 Nov 2023 20:47:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 35FDC1C20F5D
	for <lists+io-uring@lfdr.de>; Thu, 30 Nov 2023 19:47:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37CF953E02;
	Thu, 30 Nov 2023 19:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Rgv5DEgE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFD0910D9
	for <io-uring@vger.kernel.org>; Thu, 30 Nov 2023 11:46:51 -0800 (PST)
Received: by mail-io1-xd2c.google.com with SMTP id ca18e2360f4ac-7b37846373eso16356439f.0
        for <io-uring@vger.kernel.org>; Thu, 30 Nov 2023 11:46:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1701373611; x=1701978411; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WUfGQN4wOIiBxZTOLoqEzFe4YZPkK5hvpNxoZoJGul0=;
        b=Rgv5DEgE4cirFBIq2I8ngokFEAUA8IRoOmXMc+QODkzBdLEY7gXw8oQ19zHmm1XiQr
         Q8+Vj0bA/zrrdm4V8rZpddKck36SlUlT0VOH1i3Mz1ACOJOSzaGb9fj9pJcSn6Jazfb5
         SFMVV9c+vef+jrd4QbgOyyiwUTi5omPofmXMGRP/Fpkgxu6oGRXy8UdF6X5r1DsjF6zG
         Z3+pav+Omszr9OoU56Jh12qK8dE5UJqaAGqAiCvq+B+Am1GVjLaHyuHtyLtEd0ubJ0rD
         fsjjI7pTZWsjOpACarCP+8prPkPJvp2HS15FrkV0Hrry3n6gk26WRNmRFS0IjrEDZs9p
         DPJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701373611; x=1701978411;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WUfGQN4wOIiBxZTOLoqEzFe4YZPkK5hvpNxoZoJGul0=;
        b=tiRnV4biAie5U4twEzsoUX3qNECwB1rL1G4S0UTdpfHXt9HXYCdekrLD4lgrCpZmxd
         IwDMpNS9266NBfZjdBJfRZaWA0qOyqoIJgZXJP3XgHWTZslK6HqkW7kWzBOUsaAj9Xxt
         KiLvtBS5FNMCQvuRn/G/malGawGb7f2te0ozmIKiO4OVWy2atvKsbc+KaSf1s63aGWMO
         4C56vxo86cxwL9mKZ4dxe5WEDl1bChorZDRkJooSyL/2mQZ3Dw4WQ6OqL73lRVpx8uxr
         ngfDa+tsCSY10TnoBwO45aSPskWg6CmmSCOzq38JPmAevFVyPmOWLQr6rC7HQat9LXGM
         KXQA==
X-Gm-Message-State: AOJu0YzOHNAdzXjEpHsH1oHm5MwACcpsDtAC+vUhcpFIwBLTow0cOJwo
	lRT3yL7t762OFBrdFV5aIrTxrg+PVQ+5ltVp/4mqcg==
X-Google-Smtp-Source: AGHT+IFC9t1Qs639FdrLngne+Z4zbSeGX/021HZv7mHEsiD1J7zH3phrbfqqUCvu4+JGXA9vCB0gsw==
X-Received: by 2002:a5e:cb02:0:b0:7b0:acce:5535 with SMTP id p2-20020a5ecb02000000b007b0acce5535mr24376797iom.1.1701373610914;
        Thu, 30 Nov 2023 11:46:50 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id a18-20020a029f92000000b004667167d8cdsm461179jam.116.2023.11.30.11.46.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Nov 2023 11:46:49 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Jann Horn <jannh@google.com>
Subject: [PATCH 8/8] io_uring: use fget/fput consistently
Date: Thu, 30 Nov 2023 12:45:54 -0700
Message-ID: <20231130194633.649319-9-axboe@kernel.dk>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231130194633.649319-1-axboe@kernel.dk>
References: <20231130194633.649319-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Normally within a syscall it's fine to use fdget/fdput for grabbing a
file from the file table, and it's fine within io_uring as well. We do
that via io_uring_enter(2), io_uring_register(2), and then also for
cancel which is invoked from the latter. io_uring cannot close its own
file descriptors as that is explicitly rejected, and for the cancel
side of things, the file itself is just used as a lookup cookie.

However, it is more prudent to ensure that full references are always
grabbed. For anything threaded, either explicitly in the application
itself or through use of the io-wq worker threads, this is what happens
anyway. Generalize it and use fget/fput throughout.

Also see the below link for more details.

Link: https://lore.kernel.org/io-uring/CAG48ez1htVSO3TqmrF8QcX2WFuYTRM-VZ_N10i-VZgbtg=NNqw@mail.gmail.com/
Suggested-by: Jann Horn <jannh@google.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/cancel.c   | 11 ++++++-----
 io_uring/io_uring.c | 36 ++++++++++++++++++------------------
 2 files changed, 24 insertions(+), 23 deletions(-)

diff --git a/io_uring/cancel.c b/io_uring/cancel.c
index 3c19cccb1aec..8a8b07dfc444 100644
--- a/io_uring/cancel.c
+++ b/io_uring/cancel.c
@@ -273,7 +273,7 @@ int io_sync_cancel(struct io_ring_ctx *ctx, void __user *arg)
 	};
 	ktime_t timeout = KTIME_MAX;
 	struct io_uring_sync_cancel_reg sc;
-	struct fd f = { };
+	struct file *file = NULL;
 	DEFINE_WAIT(wait);
 	int ret, i;
 
@@ -295,10 +295,10 @@ int io_sync_cancel(struct io_ring_ctx *ctx, void __user *arg)
 	/* we can grab a normal file descriptor upfront */
 	if ((cd.flags & IORING_ASYNC_CANCEL_FD) &&
 	   !(cd.flags & IORING_ASYNC_CANCEL_FD_FIXED)) {
-		f = fdget(sc.fd);
-		if (!f.file)
+		file = fget(sc.fd);
+		if (!file)
 			return -EBADF;
-		cd.file = f.file;
+		cd.file = file;
 	}
 
 	ret = __io_sync_cancel(current->io_uring, &cd, sc.fd);
@@ -348,6 +348,7 @@ int io_sync_cancel(struct io_ring_ctx *ctx, void __user *arg)
 	if (ret == -ENOENT || ret > 0)
 		ret = 0;
 out:
-	fdput(f);
+	if (file)
+		fput(file);
 	return ret;
 }
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 05f933dddfde..aba5657d287e 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3652,7 +3652,7 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 		size_t, argsz)
 {
 	struct io_ring_ctx *ctx;
-	struct fd f;
+	struct file *file;
 	long ret;
 
 	if (unlikely(flags & ~(IORING_ENTER_GETEVENTS | IORING_ENTER_SQ_WAKEUP |
@@ -3670,20 +3670,19 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 		if (unlikely(!tctx || fd >= IO_RINGFD_REG_MAX))
 			return -EINVAL;
 		fd = array_index_nospec(fd, IO_RINGFD_REG_MAX);
-		f.file = tctx->registered_rings[fd];
-		f.flags = 0;
-		if (unlikely(!f.file))
+		file = tctx->registered_rings[fd];
+		if (unlikely(!file))
 			return -EBADF;
 	} else {
-		f = fdget(fd);
-		if (unlikely(!f.file))
+		file = fget(fd);
+		if (unlikely(!file))
 			return -EBADF;
 		ret = -EOPNOTSUPP;
-		if (unlikely(!io_is_uring_fops(f.file)))
+		if (unlikely(!io_is_uring_fops(file)))
 			goto out;
 	}
 
-	ctx = f.file->private_data;
+	ctx = file->private_data;
 	ret = -EBADFD;
 	if (unlikely(ctx->flags & IORING_SETUP_R_DISABLED))
 		goto out;
@@ -3777,7 +3776,8 @@ SYSCALL_DEFINE6(io_uring_enter, unsigned int, fd, u32, to_submit,
 		}
 	}
 out:
-	fdput(f);
+	if (!(flags & IORING_ENTER_REGISTERED_RING))
+		fput(file);
 	return ret;
 }
 
@@ -4618,7 +4618,7 @@ SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, unsigned int, opcode,
 {
 	struct io_ring_ctx *ctx;
 	long ret = -EBADF;
-	struct fd f;
+	struct file *file;
 	bool use_registered_ring;
 
 	use_registered_ring = !!(opcode & IORING_REGISTER_USE_REGISTERED_RING);
@@ -4637,27 +4637,27 @@ SYSCALL_DEFINE4(io_uring_register, unsigned int, fd, unsigned int, opcode,
 		if (unlikely(!tctx || fd >= IO_RINGFD_REG_MAX))
 			return -EINVAL;
 		fd = array_index_nospec(fd, IO_RINGFD_REG_MAX);
-		f.file = tctx->registered_rings[fd];
-		f.flags = 0;
-		if (unlikely(!f.file))
+		file = tctx->registered_rings[fd];
+		if (unlikely(!file))
 			return -EBADF;
 	} else {
-		f = fdget(fd);
-		if (unlikely(!f.file))
+		file = fget(fd);
+		if (unlikely(!file))
 			return -EBADF;
 		ret = -EOPNOTSUPP;
-		if (!io_is_uring_fops(f.file))
+		if (!io_is_uring_fops(file))
 			goto out_fput;
 	}
 
-	ctx = f.file->private_data;
+	ctx = file->private_data;
 
 	mutex_lock(&ctx->uring_lock);
 	ret = __io_uring_register(ctx, opcode, arg, nr_args);
 	mutex_unlock(&ctx->uring_lock);
 	trace_io_uring_register(ctx, opcode, ctx->nr_user_files, ctx->nr_user_bufs, ret);
 out_fput:
-	fdput(f);
+	if (!use_registered_ring)
+		fput(file);
 	return ret;
 }
 
-- 
2.42.0


