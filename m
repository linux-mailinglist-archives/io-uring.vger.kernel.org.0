Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 933CD3223FC
	for <lists+io-uring@lfdr.de>; Tue, 23 Feb 2021 03:01:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231164AbhBWCBO (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 22 Feb 2021 21:01:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231211AbhBWCBM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 22 Feb 2021 21:01:12 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F33E0C0617AA
        for <io-uring@vger.kernel.org>; Mon, 22 Feb 2021 17:59:58 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id t15so20927584wrx.13
        for <io-uring@vger.kernel.org>; Mon, 22 Feb 2021 17:59:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:subject:date:message-id:in-reply-to:references:mime-version
         :content-transfer-encoding;
        bh=K8VkgwQoXsf14jLRCvXCaCqq39Z9NdN7MAZ5oKR0NOw=;
        b=e3lmrMkxkHdjvplMH6UJPzjq6UVL2JXcMQfZ3Unx1ExFhZPy0ZL/WtmswHcuX4lFVh
         KyJu+Ru5Nvgzx7THQzbIJtu/YLeEBBJRNf0BT2A8UgWTMjmDK3i4PdOf3fwR3iRL1Xaa
         8WqePsDaUafFdScEYSb2IsLgbLRoxFDl/QDFRytoQ9itt68Z5Qv3mln4h80jm5HV9eFc
         /4RvEqfxoDRXBJMw8caTU6SLEgRPNOS9+3amcCImMjLed3oynEGicKKVVAkjIn2YYvQI
         8Oz5U5xydNtsf9730YSRmlWCfJ0EdY4cuk/65RPvIH9ViQnqHyHFecA6/ZHG7vpCYSVb
         vqHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=K8VkgwQoXsf14jLRCvXCaCqq39Z9NdN7MAZ5oKR0NOw=;
        b=s+7XZWVaGN6UZyPwKDATc/mCGHlzgxQ10pj4QtjL+ZPfdHYPAKJYAGho9RITmPi0Z3
         tHdrct7IwmHnkXm+AiPkrrB83t7n3IuSaYoOdgr5YVi1QxV9dxPgy3J7KoANWaLyxyj4
         ytU8mvECZvShvz9Ude6tDeiN9UE/twUFsTgfsc7py7Sk6YUeLTmzmwcdht+/uQLRMkQq
         fHj14m7XK03jW/1W9JXyWU52ObWFrqxX7KUtxk47stROmeJUoLQKgLF+Hc+1Is7o97D/
         HDTSa/cFr3ViGyaz8UAaK8b7QbTcleNXSgoAdGxo8J2txxsLeTAktATk7ajO8KoSTBXk
         ODYQ==
X-Gm-Message-State: AOAM530YqE+fLpRQqtO5IulgukX+MrF4XY0GspsMtZX5gRg7MhybzaNb
        aIfWFjNVez1MJcSJK8IorGU=
X-Google-Smtp-Source: ABdhPJwaKTijxBR89lrv4lUXf5h7RNzMaOFBa65yE52pH5WnN015sDejj6MwEjyWTxy3le97E/wj5Q==
X-Received: by 2002:adf:b611:: with SMTP id f17mr23342179wre.8.1614045597833;
        Mon, 22 Feb 2021 17:59:57 -0800 (PST)
Received: from localhost.localdomain ([148.252.132.56])
        by smtp.gmail.com with ESMTPSA id 4sm32425501wrr.27.2021.02.22.17.59.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Feb 2021 17:59:57 -0800 (PST)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
Subject: [PATCH 11/13] io_uring: rethink def->needs_async_data
Date:   Tue, 23 Feb 2021 01:55:46 +0000
Message-Id: <9c89621c7951b99db6a449718e7627c1a4ee9891.1614045169.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <cover.1614045169.git.asml.silence@gmail.com>
References: <cover.1614045169.git.asml.silence@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

needs_async_data controls allocation of async_data, and used in two
cases. 1) when async setup requires it (by io_req_prep_async() or
handler themselves), and 2) when op always needs additional space to
operate, like timeouts do.

Opcode preps already don't bother about the second case and do
allocation unconditionally, restrict needs_async_data to the first case
only and rename it into needs_async_setup.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 fs/io_uring.c | 29 +++++++++++------------------
 1 file changed, 11 insertions(+), 18 deletions(-)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 8f25371ae904..5647bc73969b 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -833,8 +833,8 @@ struct io_op_def {
 	unsigned		pollout : 1;
 	/* op supports buffer selection */
 	unsigned		buffer_select : 1;
-	/* must always have async data allocated */
-	unsigned		needs_async_data : 1;
+	/* do prep async if is going to be punted */
+	unsigned		needs_async_setup : 1;
 	/* should block plug */
 	unsigned		plug : 1;
 	/* size of async data needed, if any */
@@ -848,7 +848,7 @@ static const struct io_op_def io_op_defs[] = {
 		.unbound_nonreg_file	= 1,
 		.pollin			= 1,
 		.buffer_select		= 1,
-		.needs_async_data	= 1,
+		.needs_async_setup	= 1,
 		.plug			= 1,
 		.async_size		= sizeof(struct io_async_rw),
 	},
@@ -857,7 +857,7 @@ static const struct io_op_def io_op_defs[] = {
 		.hash_reg_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.pollout		= 1,
-		.needs_async_data	= 1,
+		.needs_async_setup	= 1,
 		.plug			= 1,
 		.async_size		= sizeof(struct io_async_rw),
 	},
@@ -891,7 +891,7 @@ static const struct io_op_def io_op_defs[] = {
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.pollout		= 1,
-		.needs_async_data	= 1,
+		.needs_async_setup	= 1,
 		.async_size		= sizeof(struct io_async_msghdr),
 	},
 	[IORING_OP_RECVMSG] = {
@@ -899,11 +899,10 @@ static const struct io_op_def io_op_defs[] = {
 		.unbound_nonreg_file	= 1,
 		.pollin			= 1,
 		.buffer_select		= 1,
-		.needs_async_data	= 1,
+		.needs_async_setup	= 1,
 		.async_size		= sizeof(struct io_async_msghdr),
 	},
 	[IORING_OP_TIMEOUT] = {
-		.needs_async_data	= 1,
 		.async_size		= sizeof(struct io_timeout_data),
 	},
 	[IORING_OP_TIMEOUT_REMOVE] = {
@@ -916,14 +915,13 @@ static const struct io_op_def io_op_defs[] = {
 	},
 	[IORING_OP_ASYNC_CANCEL] = {},
 	[IORING_OP_LINK_TIMEOUT] = {
-		.needs_async_data	= 1,
 		.async_size		= sizeof(struct io_timeout_data),
 	},
 	[IORING_OP_CONNECT] = {
 		.needs_file		= 1,
 		.unbound_nonreg_file	= 1,
 		.pollout		= 1,
-		.needs_async_data	= 1,
+		.needs_async_setup	= 1,
 		.async_size		= sizeof(struct io_async_connect),
 	},
 	[IORING_OP_FALLOCATE] = {
@@ -3116,7 +3114,7 @@ static int io_setup_async_rw(struct io_kiocb *req, const struct iovec *iovec,
 			     const struct iovec *fast_iov,
 			     struct iov_iter *iter, bool force)
 {
-	if (!force && !io_op_defs[req->opcode].needs_async_data)
+	if (!force && !io_op_defs[req->opcode].needs_async_setup)
 		return 0;
 	if (!req->async_data) {
 		if (io_alloc_async_data(req)) {
@@ -5782,12 +5780,8 @@ static int io_req_prep_async(struct io_kiocb *req)
 {
 	switch (req->opcode) {
 	case IORING_OP_READV:
-	case IORING_OP_READ_FIXED:
-	case IORING_OP_READ:
 		return io_rw_prep_async(req, READ);
 	case IORING_OP_WRITEV:
-	case IORING_OP_WRITE_FIXED:
-	case IORING_OP_WRITE:
 		return io_rw_prep_async(req, WRITE);
 	case IORING_OP_SENDMSG:
 		return io_sendmsg_prep_async(req);
@@ -5801,11 +5795,10 @@ static int io_req_prep_async(struct io_kiocb *req)
 
 static int io_req_defer_prep(struct io_kiocb *req)
 {
-	if (!io_op_defs[req->opcode].needs_async_data)
-		return 0;
-	/* some opcodes init it during the inital prep */
-	if (req->async_data)
+	if (!io_op_defs[req->opcode].needs_async_setup)
 		return 0;
+	if (WARN_ON_ONCE(req->async_data))
+		return -EFAULT;
 	if (io_alloc_async_data(req))
 		return -EAGAIN;
 	return io_req_prep_async(req);
-- 
2.24.0

