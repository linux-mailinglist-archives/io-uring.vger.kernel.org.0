Return-Path: <io-uring+bounces-7177-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EF87AA6C35E
	for <lists+io-uring@lfdr.de>; Fri, 21 Mar 2025 20:31:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4D9A9189B977
	for <lists+io-uring@lfdr.de>; Fri, 21 Mar 2025 19:32:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EA9D622FDE8;
	Fri, 21 Mar 2025 19:31:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Tj+mhNyc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7DB522FDF1
	for <io-uring@vger.kernel.org>; Fri, 21 Mar 2025 19:31:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742585508; cv=none; b=hny2Z+DFdIlyudHJ0IkgX3Iz7cw9iRkPmbYtu+SX/dYJt0qP1zQoR1ycUdEfIQb1bLt6M5DJthUjaJ2EI9+2puNSzsUjdv/vQbTbsBAhOyjghI7vdItGhJpMHAV9+Bqdj2qlq5+6DAy7CceezWf069p3hZWzzj/dzK0Og1120UU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742585508; c=relaxed/simple;
	bh=197zaw8aqPQrJc4ndS9SK/R7Fr/wKQkU/qb8sBNFCxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j3ptzkMVj7nMXVRUI1y2Jlrmcz11SLq4QEOpzXZYgtIokwAsgmmGz9ZmXiQLulufpkctxX47bZIZb4JZ9/SSrn/NhY9zmUj77ypcPbynKQVoxLG4YdNGT42Pafy8wfpL3vO6LsEMFzcpOv7r4btdzuK61DjZXmOM6aBNBNSKPnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Tj+mhNyc; arc=none smtp.client-ip=209.85.166.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-3cf82bd380bso23387105ab.0
        for <io-uring@vger.kernel.org>; Fri, 21 Mar 2025 12:31:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1742585505; x=1743190305; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Lyv0v+9t/Gd7eyMs0VD/TYXqCX5NM23FonCkFLeqK8k=;
        b=Tj+mhNycMOgxymJxplaPXzsJrrxDeJmike414+mbxVnI7d8LDjcTNcUhsJtHSZqMG5
         O+QMkXFaG5vvOrP67C/VBL8NCa4IlQDSzkt1Y5QorSNojqF+kmyCTOWuUnwatFnSVl9F
         PxvZqiq0CI5BWws3DVk/swFwMbNrg0UVYupukIK6kDhp8UHHn19AnsdDD6p6W0vBBBxm
         w+LBsbPAlgL+05ZqRgfKxGGnskkKVm+UsR7rbqi1wxfBCUf+YN3UlBrdHNUXLyK9ls6Z
         ymMq3DfeToVCYgKbW22Ln2cBJOfictCyBGJTy0YGnAUMSI+/q3nOC5WmV4dzzQuBNquN
         V/qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742585505; x=1743190305;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Lyv0v+9t/Gd7eyMs0VD/TYXqCX5NM23FonCkFLeqK8k=;
        b=DPFkQndKTK2np/8pGOS6sAtYkP8iFYpzxjO/I/9EgPPDYbxEpl2ZdPP6x7ooFIREDX
         wwgRcCImWrz63+QwzFPLoP0YG+SMqQCI/EI8j9z98gXGEiOtPbBYyrAZAn+WaG2dxZJj
         kdUGm6igZvZOtEal9PTUXDwAgdSqzBZYg9d2ueIsJJnkReVGIEhGus/sCmiNn8IacJxG
         0oHtmrXxSL/8s/i6uDh1Gm5m4fCyr4jV5BX4Y4ERwQklgkf0EcQ7Rv9ioPbLjEONZ+KY
         uLm2dWyLB7xFtyryF4imYvIcGZM+xUKo+l8LGXPEhuLX1B6XHSjGPkURUQMfm6eYVKok
         x7QQ==
X-Gm-Message-State: AOJu0YyGmvyG1EKQwpypKjhNpOzfL4yCcDFsV0/E7DTMEmIOOW62yPBP
	egX9JhAVTfeshPhr32IMgZPzbr4CGa2nawei8jS5UINzVTsLum6QtmsLyUouXkZnWijMF/YEyVI
	M
X-Gm-Gg: ASbGnctoW4w/kbPVr2cX0BDgng+cvX3EfQhG73/DmpMKuqf1Nc355lZI00V01sRi7i7
	Y9bM/9A1+4G+VIrmGyxNJhwdDwXn+bVToAUuODl1vhuZbXl2rwKP0nCyGNKmgzKzqcxfwOrJp+2
	gp32iUGna5g14lYwHXel+d6OzN4KwJ59lqSnRwPGaJptGg6fqXpcgRoMavWBLKchxMMIUz2jt2J
	wH3XcCy8H2BNS+lb0B2xAvVBFOMisxpQHM03MzH17JD9VPvVKn/ZofO1TCEFmGdQvfpg7oai3e1
	9UhrhlHZjq6QvT0RDy1LUhQeVEGUEf+hGQdqExaFwQsUE6yUkg==
X-Google-Smtp-Source: AGHT+IHDzZ9mnAh4G/k6cqLjL0gwmkvCkzcei4RqCvFryxR08cJUxR6laJCk6mpKm7TMJQEv95rPsA==
X-Received: by 2002:a05:6e02:1a2e:b0:3cf:fe21:af8 with SMTP id e9e14a558f8ab-3d59612bcd5mr47747575ab.4.1742585505040;
        Fri, 21 Mar 2025 12:31:45 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f2cbdeac82sm571268173.71.2025.03.21.12.31.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Mar 2025 12:31:43 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/5] io_uring: wait for cancelations on final ring put
Date: Fri, 21 Mar 2025 13:24:58 -0600
Message-ID: <20250321193134.738973-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250321193134.738973-1-axboe@kernel.dk>
References: <20250321193134.738973-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

We still offload the cancelation to a workqueue, as not to introduce
dependencies between the exiting task waiting on cleanup, and that
task needing to run task_work to complete the process.

This means that once the final ring put is done, any request that was
inflight and needed cancelation will be done as well. Notably requests
that hold references to files - once the ring fd close is done, we will
have dropped any of those references too.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/linux/io_uring_types.h |  2 ++
 io_uring/io_uring.c            | 17 +++++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/include/linux/io_uring_types.h b/include/linux/io_uring_types.h
index c17d2eedf478..79e223fd4733 100644
--- a/include/linux/io_uring_types.h
+++ b/include/linux/io_uring_types.h
@@ -450,6 +450,8 @@ struct io_ring_ctx {
 	struct io_mapped_region		param_region;
 	/* just one zcrx per ring for now, will move to io_zcrx_ifq eventually */
 	struct io_mapped_region		zcrx_region;
+
+	struct completion		*exit_comp;
 };
 
 /*
diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 984db01f5184..d9b65a322ae1 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2894,6 +2894,7 @@ static __cold void io_ring_exit_work(struct work_struct *work)
 	struct io_ring_ctx *ctx = container_of(work, struct io_ring_ctx, exit_work);
 	unsigned long timeout = jiffies + HZ * 60 * 5;
 	unsigned long interval = HZ / 20;
+	struct completion *exit_comp;
 	struct io_tctx_exit exit;
 	struct io_tctx_node *node;
 	int ret;
@@ -2958,6 +2959,10 @@ static __cold void io_ring_exit_work(struct work_struct *work)
 
 	io_kworker_tw_end();
 
+	exit_comp = READ_ONCE(ctx->exit_comp);
+	if (exit_comp)
+		complete(exit_comp);
+
 	init_completion(&exit.completion);
 	init_task_work(&exit.task_work, io_tctx_exit_cb);
 	exit.ctx = ctx;
@@ -3020,9 +3025,21 @@ static __cold void io_ring_ctx_wait_and_kill(struct io_ring_ctx *ctx)
 static int io_uring_release(struct inode *inode, struct file *file)
 {
 	struct io_ring_ctx *ctx = file->private_data;
+	DECLARE_COMPLETION_ONSTACK(exit_comp);
 
 	file->private_data = NULL;
+	WRITE_ONCE(ctx->exit_comp, &exit_comp);
 	io_ring_ctx_wait_and_kill(ctx);
+
+	/*
+	 * Wait for cancel to run before exiting task
+	 */
+	do {
+		if (current->io_uring)
+			io_fallback_tw(current->io_uring, false);
+		cond_resched();
+	} while (wait_for_completion_interruptible(&exit_comp));
+
 	return 0;
 }
 
-- 
2.49.0


