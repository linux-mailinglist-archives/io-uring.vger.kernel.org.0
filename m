Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4A62114D213
	for <lists+io-uring@lfdr.de>; Wed, 29 Jan 2020 21:49:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726259AbgA2Utf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 29 Jan 2020 15:49:35 -0500
Received: from mail-il1-f195.google.com ([209.85.166.195]:46323 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726672AbgA2Ute (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 29 Jan 2020 15:49:34 -0500
Received: by mail-il1-f195.google.com with SMTP id t17so1064261ilm.13
        for <io-uring@vger.kernel.org>; Wed, 29 Jan 2020 12:49:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=to:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=tgMQMLa5XrsWsADVKCNvfKB/cibsogOjZ6a6Ll2vx0Q=;
        b=LaU853kgkfU9/wxc+r62vMQAhkv9D8utlqX9oil60n9lvav031mboJ9JA1bFOkhe2U
         7k6wTVkFXdHOFjL0LQInHxSGHhClpPAez0Hi3tiAS3exrknJJ4hxJNSqr8h79msmjE04
         yPdivvJ21eddaWK3wDCV2VmYE15fWK9Mwdenk+44ILMqs74RoQ6P38NFSIR/9wkflFRp
         PVcZ8tu1Jon5keAoR4TuHkh/LNeD5H0ws5aupHUFvprUhTPwAHWbDUYoDQuuxCkIupKZ
         Wxn3uNfN1gUOBxRyVxxfmU8h9esp8ioWl3vAqE0QZ9/aZx0PUoTcmS+2DD6av6m3WlQv
         8/lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=tgMQMLa5XrsWsADVKCNvfKB/cibsogOjZ6a6Ll2vx0Q=;
        b=ogGzUtaN3xvvSsdpVp1pt+SM2lRjuE92Nj0DIH/OUw/XivzbzU5yZ6m3aalC2qCnht
         pDxQQkeOUrdapLJU5cjLKQXsf3y8uuBEX62kI8cLv2+TUEuU4b+tyDc6iREPx6H+ueSH
         gNUF0suK79SD0EUXkzl2uBoWfaJYkUWjFK3o8SI/Pu5/zyknXaSYjWGkn85u/8NheBKP
         LeAHfAt+ds0nI12aRgQNJF8ez3ulP1Gl4YFusi3P0DfLRbVotNeFb4mVibobq5NDuo15
         Ii6pVjS4yESX9Epq71MuYhcHJFy6Zv/M5yJWkgHtpoJuoH085dOx5RMkhaNWq/0aqV0U
         RJ5Q==
X-Gm-Message-State: APjAAAWQnStxX1zsrCHEkycCEIMqS7pNNdnFHO6RJMHa2wRSnyw6lIp3
        DegqFYPul5KWjCs2oTudk2I18B50mno=
X-Google-Smtp-Source: APXvYqyW32e5CsdpRGjM+uC0W0mwXOdLhN5UTj/t+dUDtfbUYTYwsMANnZtIKpEEcJZj86iDNPxZ0A==
X-Received: by 2002:a92:85d1:: with SMTP id f200mr1083261ilh.245.1580330973553;
        Wed, 29 Jan 2020 12:49:33 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id y11sm1076257ilm.22.2020.01.29.12.49.33
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jan 2020 12:49:33 -0800 (PST)
To:     io-uring <io-uring@vger.kernel.org>
From:   Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring: fix linked command file table usage
Message-ID: <c2d0d637-85db-3500-f1ae-335bc1fec6c8@kernel.dk>
Date:   Wed, 29 Jan 2020 13:49:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

We're not consistent in how the file table is grabbed and assigned if we
have a command linked that requires the use of it.

Add ->file_table to the io_op_defs[] array, and use that to determine
when to grab the table instead of having the handlers set it if they
need to defer. This also means we can kill the IO_WQ_WORK_NEEDS_FILES
flag. We always initialize work->files, so io-wq can just check for
that.

Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/fs/io-wq.c b/fs/io-wq.c
index f7eb577ccd2d..cb60a42b9fdf 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -476,8 +476,7 @@ static void io_worker_handle_work(struct io_worker *worker)
 		if (work->flags & IO_WQ_WORK_CB)
 			work->func(&work);
 
-		if ((work->flags & IO_WQ_WORK_NEEDS_FILES) &&
-		    current->files != work->files) {
+		if (work->files && current->files != work->files) {
 			task_lock(current);
 			current->files = work->files;
 			task_unlock(current);
diff --git a/fs/io-wq.h b/fs/io-wq.h
index c42602c58c56..50b3378febf2 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -7,7 +7,6 @@ enum {
 	IO_WQ_WORK_CANCEL	= 1,
 	IO_WQ_WORK_HAS_MM	= 2,
 	IO_WQ_WORK_HASHED	= 4,
-	IO_WQ_WORK_NEEDS_FILES	= 16,
 	IO_WQ_WORK_UNBOUND	= 32,
 	IO_WQ_WORK_INTERNAL	= 64,
 	IO_WQ_WORK_CB		= 128,
diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8bcf0538e2e1..0d8d0e217847 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -603,6 +603,8 @@ struct io_op_def {
 	unsigned		unbound_nonreg_file : 1;
 	/* opcode is not supported by this kernel */
 	unsigned		not_supported : 1;
+	/* needs file table */
+	unsigned		file_table : 1;
 };
 
 static const struct io_op_def io_op_defs[] = {
@@ -661,6 +663,7 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_mm		= 1,
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
+		.file_table		= 1,
 	},
 	[IORING_OP_ASYNC_CANCEL] = {},
 	[IORING_OP_LINK_TIMEOUT] = {
@@ -679,12 +682,15 @@ static const struct io_op_def io_op_defs[] = {
 	[IORING_OP_OPENAT] = {
 		.needs_file		= 1,
 		.fd_non_neg		= 1,
+		.file_table		= 1,
 	},
 	[IORING_OP_CLOSE] = {
 		.needs_file		= 1,
+		.file_table		= 1,
 	},
 	[IORING_OP_FILES_UPDATE] = {
 		.needs_mm		= 1,
+		.file_table		= 1,
 	},
 	[IORING_OP_STATX] = {
 		.needs_mm		= 1,
@@ -720,6 +726,7 @@ static const struct io_op_def io_op_defs[] = {
 	[IORING_OP_OPENAT2] = {
 		.needs_file		= 1,
 		.fd_non_neg		= 1,
+		.file_table		= 1,
 	},
 };
 
@@ -732,6 +739,7 @@ static void io_queue_linked_timeout(struct io_kiocb *req);
 static int __io_sqe_files_update(struct io_ring_ctx *ctx,
 				 struct io_uring_files_update *ip,
 				 unsigned nr_args);
+static int io_grab_files(struct io_kiocb *req);
 
 static struct kmem_cache *req_cachep;
 
@@ -2568,10 +2576,8 @@ static int io_openat2(struct io_kiocb *req, struct io_kiocb **nxt,
 	struct file *file;
 	int ret;
 
-	if (force_nonblock) {
-		req->work.flags |= IO_WQ_WORK_NEEDS_FILES;
+	if (force_nonblock)
 		return -EAGAIN;
-	}
 
 	ret = build_open_flags(&req->open.how, &op);
 	if (ret)
@@ -2797,10 +2803,8 @@ static int io_close(struct io_kiocb *req, struct io_kiocb **nxt,
 		return ret;
 
 	/* if the file has a flush method, be safe and punt to async */
-	if (req->close.put_file->f_op->flush && !io_wq_current_is_worker()) {
-		req->work.flags |= IO_WQ_WORK_NEEDS_FILES;
+	if (req->close.put_file->f_op->flush && !io_wq_current_is_worker())
 		goto eagain;
-	}
 
 	/*
 	 * No ->flush(), safely close from here and just punt the
@@ -3244,7 +3248,6 @@ static int io_accept(struct io_kiocb *req, struct io_kiocb **nxt,
 	ret = __io_accept(req, nxt, force_nonblock);
 	if (ret == -EAGAIN && force_nonblock) {
 		req->work.func = io_accept_finish;
-		req->work.flags |= IO_WQ_WORK_NEEDS_FILES;
 		io_put_req(req);
 		return -EAGAIN;
 	}
@@ -3967,10 +3970,8 @@ static int io_files_update(struct io_kiocb *req, bool force_nonblock)
 	struct io_uring_files_update up;
 	int ret;
 
-	if (force_nonblock) {
-		req->work.flags |= IO_WQ_WORK_NEEDS_FILES;
+	if (force_nonblock)
 		return -EAGAIN;
-	}
 
 	up.offset = req->files_update.offset;
 	up.fds = req->files_update.arg;
@@ -3991,6 +3992,12 @@ static int io_req_defer_prep(struct io_kiocb *req,
 {
 	ssize_t ret = 0;
 
+	if (io_op_defs[req->opcode].file_table) {
+		ret = io_grab_files(req);
+		if (unlikely(ret))
+			return ret;
+	}
+
 	io_req_work_grab_env(req, &io_op_defs[req->opcode]);
 
 	switch (req->opcode) {
@@ -4424,6 +4431,8 @@ static int io_grab_files(struct io_kiocb *req)
 	int ret = -EBADF;
 	struct io_ring_ctx *ctx = req->ctx;
 
+	if (req->work.files)
+		return 0;
 	if (!ctx->ring_file)
 		return -EBADF;
 
@@ -4542,7 +4551,7 @@ static void __io_queue_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe)
 	if (ret == -EAGAIN && (!(req->flags & REQ_F_NOWAIT) ||
 	    (req->flags & REQ_F_MUST_PUNT))) {
 punt:
-		if (req->work.flags & IO_WQ_WORK_NEEDS_FILES) {
+		if (io_op_defs[req->opcode].file_table) {
 			ret = io_grab_files(req);
 			if (ret)
 				goto err;

-- 
Jens Axboe

