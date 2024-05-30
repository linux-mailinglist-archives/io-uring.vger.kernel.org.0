Return-Path: <io-uring+bounces-1998-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 86D848D4DCB
	for <lists+io-uring@lfdr.de>; Thu, 30 May 2024 16:24:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 28F53284AF9
	for <lists+io-uring@lfdr.de>; Thu, 30 May 2024 14:24:14 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF26B17C22D;
	Thu, 30 May 2024 14:24:02 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D876A176245;
	Thu, 30 May 2024 14:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717079042; cv=none; b=PdctRi9BUxBL25m6yy4zVsl+wPAibNLwDS71pMj8UA2DAWDqUTvPgFg2l8GUBpLEBjCwNAl+W3w1dhFFoREGc2ZoporlGu9zUnvAASSPlyzSSIMPeg3uBum1i2bvn5NhvW7zzDPOhnHI67/L9UwkY38WLulmgYHJLDC7iYdRRD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717079042; c=relaxed/simple;
	bh=Xyc2rNGQkBIoytoNx9NltNfdasu9Z7LNs9pIWdvTaII=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=dZwo9LnklZYNBoYY3beUu8C7yUV4gVs4WIUUFg77200vnkDLSBAix5Kdc04IVxn/HTpbjoCd7+iZ4W0SoLmszI077plDufTBYR8qQ1I42Q1wuV9E3j9cFBqebXeIPNRCT+HIfLY9TzMElX0QS+GvruuE6JK+MtQO8yJlM4jbgXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.218.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-a6303e13ffeso104341366b.3;
        Thu, 30 May 2024 07:24:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717079039; x=1717683839;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=shat5omApnTzBZPJY3cC2DRYw1h9HRTYA0PI/kmlTfI=;
        b=Gvnp4dIIC9pfr9mF4dhxD1iFLu3kV2xv/2Rh2EG2p0IoosU1yYJvkJkuwUavvLRKYk
         IPcxbxGzDkcb71bfg9QSBPadJOxnsCIQ2x+Lg7s8+FcQmkqGvnTt9hqNaPxCtJYMTfPW
         PpLZJO7rBE5wHxLKFi5JL8mDHRNoRddmQ9oyxsDNyEqKav1lBsIAoqA3D8Qw8sjISYo9
         uP8o+TmxSaBekmr2nDkxsQDiKsfPCWKo0O9fQo+dpMemwA2hqxBHQlaBQRzNx+91rEc8
         Kk3shrLzVg8MOXFlGsdy/Cb5ii5eROq/M1PIVWdVuJMD9XXawRcSQEzyHD/rOl1IFgdG
         PI2Q==
X-Forwarded-Encrypted: i=1; AJvYcCWdh/Z1iEaI+YrpT8Y9vAyLkvm3PfCB0CXQb4zw7o2ABG0k1zA55cGgO3hbocGKA3K7Ho6DS2RBrT7rk2dFCCMO+lNvzjLGQ6IyEBiXgpfEQsO/cGxfBzrL8lulvF4zjUGPB4hXTd0=
X-Gm-Message-State: AOJu0YwYMtSBIh2A18Fz+dMJJxja6KF+lTau3Ng0S2IPpTWoJbdL+ISX
	AbrJr2IrmsvG+/7jjMvv5e+XrM0WENhX1oEiFKquWH+yEhph9BNG
X-Google-Smtp-Source: AGHT+IHOkFnlaA12dhEmT4K29ll4g3MGkOHbHoD/CJXHhaz5/8cLtCJKS2IxAs3HNrpK5QaVRhCugw==
X-Received: by 2002:a17:906:9e15:b0:a59:8786:3850 with SMTP id a640c23a62f3a-a65e923ee72mr119650366b.72.1717079038899;
        Thu, 30 May 2024 07:23:58 -0700 (PDT)
Received: from localhost (fwdproxy-lla-006.fbsv.net. [2a03:2880:30ff:6::face:b00c])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a647b827400sm176500666b.69.2024.05.30.07.23.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 May 2024 07:23:58 -0700 (PDT)
From: Breno Leitao <leitao@debian.org>
To: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Cc: leit@meta.com,
	io-uring@vger.kernel.org (open list:IO_URING),
	linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] io_uring/rw: Free iovec before cleaning async data
Date: Thu, 30 May 2024 07:23:39 -0700
Message-ID: <20240530142340.1248216-1-leitao@debian.org>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

kmemleak shows that there is a memory leak in io_uring read operation,
where a buffer is allocated at iovec import, but never de-allocated.

The memory is allocated at io_async_rw->free_iovec, but, then
io_async_rw is kfreed, taking the allocated memory with it. I saw this
happening when the read operation fails with -11 (EAGAIN).

This is the kmemleak splat.

    unreferenced object 0xffff8881da591c00 (size 256):
...
      backtrace (crc 7a15bdee):
	[<00000000256f2de4>] __kmalloc+0x2d6/0x410
	[<000000007a9f5fc7>] iovec_from_user.part.0+0xc6/0x160
	[<00000000cecdf83a>] __import_iovec+0x50/0x220
	[<00000000d1d586a2>] __io_import_iovec+0x13d/0x220
	[<0000000054ee9bd2>] io_prep_rw+0x186/0x340
	[<00000000a9c0372d>] io_prep_rwv+0x31/0x120
	[<000000001d1170b9>] io_prep_readv+0xe/0x30
	[<0000000070b8eb67>] io_submit_sqes+0x1bd/0x780
	[<00000000812496d4>] __do_sys_io_uring_enter+0x3ed/0x5b0
	[<0000000081499602>] do_syscall_64+0x5d/0x170
	[<00000000de1c5a4d>] entry_SYSCALL_64_after_hwframe+0x76/0x7e

This occurs because the async data cleanup functions are not set for
read/write operations. As a result, the potentially allocated iovec in
the rw async data is not freed before the async data is released,
leading to a memory leak.

With this following patch, kmemleak does not show the leaked memory
anymore, and all liburing tests pass.

Fixes: a9165b83c193 ("io_uring/rw: always setup io_async_rw for read/write requests")
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 io_uring/opdef.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/io_uring/opdef.c b/io_uring/opdef.c
index 2de5cca9504e..2e3b7b16effb 100644
--- a/io_uring/opdef.c
+++ b/io_uring/opdef.c
@@ -516,10 +516,12 @@ const struct io_cold_def io_cold_defs[] = {
 	},
 	[IORING_OP_READ_FIXED] = {
 		.name			= "READ_FIXED",
+		.cleanup		= io_readv_writev_cleanup,
 		.fail			= io_rw_fail,
 	},
 	[IORING_OP_WRITE_FIXED] = {
 		.name			= "WRITE_FIXED",
+		.cleanup		= io_readv_writev_cleanup,
 		.fail			= io_rw_fail,
 	},
 	[IORING_OP_POLL_ADD] = {
@@ -582,10 +584,12 @@ const struct io_cold_def io_cold_defs[] = {
 	},
 	[IORING_OP_READ] = {
 		.name			= "READ",
+		.cleanup		= io_readv_writev_cleanup,
 		.fail			= io_rw_fail,
 	},
 	[IORING_OP_WRITE] = {
 		.name			= "WRITE",
+		.cleanup		= io_readv_writev_cleanup,
 		.fail			= io_rw_fail,
 	},
 	[IORING_OP_FADVISE] = {
@@ -692,6 +696,7 @@ const struct io_cold_def io_cold_defs[] = {
 	},
 	[IORING_OP_READ_MULTISHOT] = {
 		.name			= "READ_MULTISHOT",
+		.cleanup		= io_readv_writev_cleanup,
 	},
 	[IORING_OP_WAITID] = {
 		.name			= "WAITID",
-- 
2.43.0


