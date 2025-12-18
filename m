Return-Path: <io-uring+bounces-11182-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B2B01CCAE72
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 09:34:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id DF618301D9E0
	for <lists+io-uring@lfdr.de>; Thu, 18 Dec 2025 08:34:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FD372F12BF;
	Thu, 18 Dec 2025 08:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="C3xotcB2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F5682737F8
	for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 08:34:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766046879; cv=none; b=Lz5+vo3zGmZN0wPuT32pjGjk9NI8K1xcZPMbvsDQ+oRBixbhVXUC9M4oIfNJE0b1ael0j2tdp8XGpSBq+JT2UOhsGCL+tuWvnvwxOFKhNRgB7//jwDup8XMYkFbZBA/V8O8zahx0/dMzvEQpE5+BaJONOsAhW/hlXuqBYqOt4Gc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766046879; c=relaxed/simple;
	bh=4BAaGievTtvkLoNgL0ZTdQZ2RPDEbM53T+cmtPTo8so=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=td+HJjAUEJmBsIDIbGG+VZv+IjBwAecC63xWOyoUhZV5x++QhHOST2xf914e7krOt7IwYdbn6mARcKq5aWBskoGgRiiCzLMtnn2v9v896anEhQE6mRVNqBr74C5rVfK5S1rC02z3inWGhAJSMx9kFgweUYAfGQA0sf5ecj3VdME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=C3xotcB2; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2a0eaf55d58so9278305ad.1
        for <io-uring@vger.kernel.org>; Thu, 18 Dec 2025 00:34:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766046877; x=1766651677; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=o+ENtiB+VRiuAX55mhgrey4moIu9hfBSn8/uNmk3lgI=;
        b=C3xotcB2/68BjXbdbsc1mNhpl8W0HqARTGaMa6mP/++RUHoHm1mvvO8uHm3NMxhPVZ
         qn71iLMw+/c1qp3HGg0mSUkQBUXvaGAUNbWgmNRHh0jQEU9ynwQIRXdTFPoxlA1GbOZ4
         GFycKuTGigfkIgab8vIHCC9cai9pZRsPbvrmJsdGRNu/kiw7doMa+sCCvNG8KUaF15KB
         PX27yle77R83kuIzeOdSdSaJX3tcdkFKy//To6p5VJWqFWFZeKxGKW7ZOBo917URKjRY
         6wiM3MzQtNVYC9QEUNdELl4r5CiuT2nm/hoi2fGQrWAGP1ckDMqdRk0PeTbH7MNZqeNx
         qmnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766046877; x=1766651677;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=o+ENtiB+VRiuAX55mhgrey4moIu9hfBSn8/uNmk3lgI=;
        b=X9qt/3gkQgs/7JGcR6LUIbrA7QH4559zWvss/UjjOB0WlXM/3hxnwUa3Em39iSVyy0
         UTzu0xh4tbFsEGHhVHQD4+Ht9zgX8UNiS3KYWNxfHt3DcanF94EEYhCQ2zH4q7b8ZTh9
         GhHGPxk38plC2I3JDbqvZTZYMyrNIe/bt+kpZaXLfB5RulkmRFWxIZMZOJovjw4qZ1g+
         eKz/d2umPIT2AlrTrq/NKL/bEc1rLHPr82oAXBcCBRkTwCh5EPjs7e7ia9GzftyY2YW5
         yly5De1zGvyBykPYFRwJNPkRptt/Gs6z1ysbNT3+iMu27wYFZfY/+G0rVcOKO9MnxNCx
         ECfw==
X-Forwarded-Encrypted: i=1; AJvYcCV3Eajlo/I7kai6sxBJFIC6F+qOu3pdyGulZ3WdGDjUDXTaHY1+7UI07zV6KZ/nnWJ/IfLRCMNMyA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yyg9kYCBs4zhPmBuscDd2Om+4KgntcsQfG9M7n/LBKlCwX5PHIu
	8K46sjStBclUo8FKEmooLcLK2OsINNSMGoK6QTSbk//y0rq8rXwf7d6k
X-Gm-Gg: AY/fxX4Ba0V+g1afJ5jSVW02dlqTL7CD0jw0B/gk+5CyQDvLXXMvb6LUyyx6mHuotRL
	WOnbC0jyVTY9Sg/I7C6wxubialryIrCVlpx+gpfCv5Sbs8UJ5lAaImNDjvfpQ7JA9gVUkBSB0hZ
	3AwhWExyNNuSRY8NL/UIwnR37nxtTBDAIlelLUsoiHiOPr917S71mDaGZVtlbJK8HFahrLb1cLg
	EcMobOw6BkGEmZZTQEshuUATTLM6H/DSLAsC8MqdQ8QB5HKfhaz8eYI9roKvtqfH7LS6AsUmhmv
	so2L5bTj83I8e1PdDXGic1IGn8Cce09kg4tICUV6P+vKSPm6bQKfukXZBy6WekpIgaE5hVfiPtH
	2euGDv4It44GWT/lTjPOc96Dn9q+q5QFdoDJy0dATY0jvaB8DFPRc/1yypOBLxVJgZKCmzmuXdF
	6sdlcTseMer39JE7yACw==
X-Google-Smtp-Source: AGHT+IGIMnueevVEe0Sfng0TiV5lOL4sJsWbmM8PI8IW/GHPSQrN8NM+DJrnXApFmTaC3/vPT406jw==
X-Received: by 2002:a17:903:3508:b0:2a0:9047:a738 with SMTP id d9443c01a7336-2a2cab1635dmr19140775ad.19.1766046876986;
        Thu, 18 Dec 2025 00:34:36 -0800 (PST)
Received: from localhost ([2a03:2880:ff:43::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a2d193cf52sm17444155ad.99.2025.12.18.00.34.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Dec 2025 00:34:36 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: miklos@szeredi.hu,
	axboe@kernel.dk
Cc: bschubert@ddn.com,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	csander@purestorage.com,
	xiaobing.li@samsung.com,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH v2 02/25] io_uring/kbuf: rename io_unregister_pbuf_ring() to io_unregister_buf_ring()
Date: Thu, 18 Dec 2025 00:32:56 -0800
Message-ID: <20251218083319.3485503-3-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251218083319.3485503-1-joannelkoong@gmail.com>
References: <20251218083319.3485503-1-joannelkoong@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use the more generic name io_unregister_buf_ring() as this function will
be used for unregistering both provided buffer rings and kernel-managed
buffer rings.

This is a preparatory change for upcoming kernel-managed buffer ring
support.

Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 io_uring/kbuf.c     | 2 +-
 io_uring/kbuf.h     | 2 +-
 io_uring/register.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/io_uring/kbuf.c b/io_uring/kbuf.c
index 100367bb510b..cbe477db7b86 100644
--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -718,7 +718,7 @@ int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
 	return 0;
 }
 
-int io_unregister_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg)
+int io_unregister_buf_ring(struct io_ring_ctx *ctx, void __user *arg)
 {
 	struct io_uring_buf_reg reg;
 	struct io_buffer_list *bl;
diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index bf15e26520d3..40b44f4fdb15 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -74,7 +74,7 @@ int io_provide_buffers_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe
 int io_manage_buffers_legacy(struct io_kiocb *req, unsigned int issue_flags);
 
 int io_register_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg);
-int io_unregister_pbuf_ring(struct io_ring_ctx *ctx, void __user *arg);
+int io_unregister_buf_ring(struct io_ring_ctx *ctx, void __user *arg);
 int io_register_pbuf_status(struct io_ring_ctx *ctx, void __user *arg);
 
 bool io_kbuf_recycle_legacy(struct io_kiocb *req, unsigned issue_flags);
diff --git a/io_uring/register.c b/io_uring/register.c
index 62d39b3ff317..4c6879698844 100644
--- a/io_uring/register.c
+++ b/io_uring/register.c
@@ -750,7 +750,7 @@ static int __io_uring_register(struct io_ring_ctx *ctx, unsigned opcode,
 		ret = -EINVAL;
 		if (!arg || nr_args != 1)
 			break;
-		ret = io_unregister_pbuf_ring(ctx, arg);
+		ret = io_unregister_buf_ring(ctx, arg);
 		break;
 	case IORING_REGISTER_SYNC_CANCEL:
 		ret = -EINVAL;
-- 
2.47.3


