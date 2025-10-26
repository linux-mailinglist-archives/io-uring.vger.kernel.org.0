Return-Path: <io-uring+bounces-10222-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id E4F4FC0AF02
	for <lists+io-uring@lfdr.de>; Sun, 26 Oct 2025 18:34:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 16791349AFC
	for <lists+io-uring@lfdr.de>; Sun, 26 Oct 2025 17:34:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 659812566D9;
	Sun, 26 Oct 2025 17:34:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b="TdJC7Dox"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E66982080C8
	for <io-uring@vger.kernel.org>; Sun, 26 Oct 2025 17:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761500080; cv=none; b=SOcuvY9Zpd0GcSriF1FsKZj085xk3RLNCXKXj30zfDVF0RxxCWgXfHvk50feaeDS86oPwokcSybUdkD1eLvcnrv3o3vBa+FtBPE6nMyOU2qhGA5Fku8scmH4Ht8cZy42N+FO59RxrmuLSJmODZ0Ddc2T0r8aZygoT4WyKj1OLOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761500080; c=relaxed/simple;
	bh=tPR5+uljr4VQorLeNjdheJazbAZiSckXeQawYdSazDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=duCO/dKxO/V3J+D6vkMp30eyaJaisLLx2oAzVUk4LWak8zt8DxvzPueYAPtly9WfuTDnZDbiwsQJEIcLUFT+hnriBd5+jvP3A3guS7KE164aOrtU4+FVYBcPg+pTAnKgWMZKeGU8fuT2iREv3qAQBJoM3Gydu5mOF16+MFF4KXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk; spf=none smtp.mailfrom=davidwei.uk; dkim=pass (2048-bit key) header.d=davidwei-uk.20230601.gappssmtp.com header.i=@davidwei-uk.20230601.gappssmtp.com header.b=TdJC7Dox; arc=none smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=davidwei.uk
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=davidwei.uk
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-7c52ce8cbe7so1546330a34.0
        for <io-uring@vger.kernel.org>; Sun, 26 Oct 2025 10:34:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=davidwei-uk.20230601.gappssmtp.com; s=20230601; t=1761500078; x=1762104878; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WdEwy5KYNaN7yyEan07C/ACdb/Xul1TuBxe0nEe3BME=;
        b=TdJC7DoxEIoBaUixNgwys9jT6gr860lhPIKin7Vw+VekqGcjcExrv8X/pSCxY7ujr5
         V1aef3g0HbxA0crWmGMobiCVSIY6vfDjHAPEriGoLYBhGXWvBFzMVpHI45pjzlt72wx4
         a+MjCYdDnKTWL3LkcZMqFJB2TtcfekCLHGn+b6OwmPa20M0XIzrhs5pWKkin74vUKXtM
         Nj+bJaRQgmjbM2vvMV1LFY+UaozRTXVbMBwLeMOeCSabqB2KXfU6G13xDMzhOe75lp+S
         sD4e1H2NGohxYBoQE8vMf2o7nRJtLnay4j6xbqo3xXbNLUBQeKXsmv1t77qGM82imtQN
         RUdA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761500078; x=1762104878;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WdEwy5KYNaN7yyEan07C/ACdb/Xul1TuBxe0nEe3BME=;
        b=QgEJn8fopQX7rkZvPd0tabAhhkXdIQEWdCZjx6ow3NnQTtimUkN92r0740lvx/jaN8
         JHhVCYKREFLou8uIb2uotXt39H/E4uz6Qn9lsF36NFqJvazIcjgxqjldZ9MAznJO+vJZ
         5a9PYLJ5ioomMcp6BihIvVw48SXZK64LF30dMiPayHa9d4v6YtxfzzazcHkr79j0sqfB
         LE9589UyK4swcaxNClHvZUVfG1Sz+oq9p1nmXBBdtZbmUcJwTl3lnpZFLTlejKbUBhNK
         k60WXYJCHFVJebuKrMzPrFl3Eu8iPg0HkXzck+Xj3R/tS+AgQTVUvdqyf4hMENRdlr3I
         ajFQ==
X-Gm-Message-State: AOJu0YzSgAUEpsfSz4Bm/8SiISMB6SAWe1l50pgmiitEcH+uIP4HerpY
	ni7HVy7qpdFQTW+ZQBHA+LJZu7LNPJZfr4feanjI3pXV6Lvh/Ng2nVRp6/a4kQXxA6i1S4xglOM
	Nt4mP
X-Gm-Gg: ASbGncuVo2k4DDRrAcHWdmPPJuMcTIvXNZTbZ5WWK+sYU/FcZHwA5WP4rHtLONRWAJ4
	ankX1Vm8BJj3/tI9m6erlKKav5xe9QrjPqiJo1q2ep5Vf0QpKvQPXMX7d8E6JLDHF48RVlCpC9e
	/XuXEDW3onnYeyGQUsIrFPg8p9axXRJr02xEF6PA5YYsHVzhndC4Yn2KOKdwB21UlighPGCpd3j
	EVCgviz0oHLDQer1zmQcbdZHJqls6Uox7FyR/bQfwxHatV/PXANPPRnelMMtYTPjRN6pB2SVG/G
	Cma9ELrxn+vFRsSqN3NWa3ChHnqQ326TE50E/VpMIp0DAZJl5d6TeFJLUqctW5RUerdi0JCcPee
	nYquUlK6Pf1YEajkAzwD7PcLbXuJNqhFRFbZeMzDKjV64dR6OTgZTs9FXPsFlFUIBxa/YyONoDX
	Y55nEATXZJYMe4xphJ+37iPey8oa5CRw==
X-Google-Smtp-Source: AGHT+IH1axUm6Z2/ZNBxirFBe+PaQAks0UUC388GL6c4aKB6lOTJifX2ydDxol4b9r2kA24H/fQwPw==
X-Received: by 2002:a05:6830:2690:b0:7c5:3b0a:5eea with SMTP id 46e09a7af769-7c53b0a690fmr1056637a34.10.1761500078089;
        Sun, 26 Oct 2025 10:34:38 -0700 (PDT)
Received: from localhost ([2a03:2880:12ff:72::])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7c5301189c9sm1552881a34.7.2025.10.26.10.34.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Oct 2025 10:34:37 -0700 (PDT)
From: David Wei <dw@davidwei.uk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH v3 1/3] io_uring/rsrc: rename and export io_lock_two_rings()
Date: Sun, 26 Oct 2025 10:34:32 -0700
Message-ID: <20251026173434.3669748-2-dw@davidwei.uk>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251026173434.3669748-1-dw@davidwei.uk>
References: <20251026173434.3669748-1-dw@davidwei.uk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Rename lock_two_rings() to io_lock_two_rings() and export. This will be
used when sharing a src ifq owned by one ring with another ring. During
this process both rings need to be locked in a deterministic order,
similar to the current user io_clone_buffers().

Signed-off-by: David Wei <dw@davidwei.uk>
---
 io_uring/rsrc.c | 4 ++--
 io_uring/rsrc.h | 1 +
 2 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index d787c16dc1c3..d245b7592eee 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -1148,7 +1148,7 @@ int io_import_reg_buf(struct io_kiocb *req, struct iov_iter *iter,
 }
 
 /* Lock two rings at once. The rings must be different! */
-static void lock_two_rings(struct io_ring_ctx *ctx1, struct io_ring_ctx *ctx2)
+void io_lock_two_rings(struct io_ring_ctx *ctx1, struct io_ring_ctx *ctx2)
 {
 	if (ctx1 > ctx2)
 		swap(ctx1, ctx2);
@@ -1299,7 +1299,7 @@ int io_register_clone_buffers(struct io_ring_ctx *ctx, void __user *arg)
 	src_ctx = file->private_data;
 	if (src_ctx != ctx) {
 		mutex_unlock(&ctx->uring_lock);
-		lock_two_rings(ctx, src_ctx);
+		io_lock_two_rings(ctx, src_ctx);
 
 		if (src_ctx->submitter_task &&
 		    src_ctx->submitter_task != current) {
diff --git a/io_uring/rsrc.h b/io_uring/rsrc.h
index a3ca6ba66596..b002c4a5a8cd 100644
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -70,6 +70,7 @@ int io_import_reg_vec(int ddir, struct iov_iter *iter,
 int io_prep_reg_iovec(struct io_kiocb *req, struct iou_vec *iv,
 			const struct iovec __user *uvec, size_t uvec_segs);
 
+void io_lock_two_rings(struct io_ring_ctx *ctx1, struct io_ring_ctx *ctx2);
 int io_register_clone_buffers(struct io_ring_ctx *ctx, void __user *arg);
 int io_sqe_buffers_unregister(struct io_ring_ctx *ctx);
 int io_sqe_buffers_register(struct io_ring_ctx *ctx, void __user *arg,
-- 
2.47.3


