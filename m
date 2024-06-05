Return-Path: <io-uring+bounces-2111-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A37D8FD0EF
	for <lists+io-uring@lfdr.de>; Wed,  5 Jun 2024 16:36:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1AAEBB2D396
	for <lists+io-uring@lfdr.de>; Wed,  5 Jun 2024 14:20:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 666931755A;
	Wed,  5 Jun 2024 14:19:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="B3BXqBWt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E8CE2770E
	for <io-uring@vger.kernel.org>; Wed,  5 Jun 2024 14:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717597186; cv=none; b=oaE0K2auBhK1/Q3RUpMRbsDRM2HMUJEJgxOCUGhW+FLfXyBwLtsd4pQXb8UyVDfV0M8loHWM0cFMgn7InPxDFYnVAOgLVvtb005UPkDjHyVel1vAEUy3gJ3qK4CAsm/oIASthnAuf1pfU/FUkVWLBeB+PD1RV+X5RRzbMMLi8SY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717597186; c=relaxed/simple;
	bh=Dg7eZOnIgLth5/bbTSu+ZhOWjL8S1TMLSv1i4QJE9bY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MbvyFnwHkoGQwBj/41+e7QwjSh1jcWDUgpYj3/hDTxQlgkLmGFIvnQ0dM0bW4vZiPUgWLO13W9oL2gv8KZAOHd8lyRrtgFFNov7WwrCPnlFRx/0KcVkOA3FJWmNXVEs6Q+yt7KaZNeXdVJC7J94zLDN1wsXTIQhyhJJ2BEkUMRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=B3BXqBWt; arc=none smtp.client-ip=209.85.167.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-3d1b8bacf67so685415b6e.2
        for <io-uring@vger.kernel.org>; Wed, 05 Jun 2024 07:19:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1717597181; x=1718201981; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T1EmDC2bGMmU0XeSvchLBl6+1crQIfO4g6MqrY1wcIM=;
        b=B3BXqBWtM5mcSYMWhIVcPloEK2EUxqw5THlfWUWQLCvKTaLgZH0s1/Bum/PWSF4TFt
         sU0ifRCZsUo6PqxlnAVZ95x0Bj8vKSf0I7UzsLekUISDoJ7fpeN70W5ucxPb6a+tqgAr
         1y7pr7+8Fkf+nJNWWnbVku8ISEZs9vxsMeyqB2ZLLaDKxmaKCx91d4fnnwFR/WGHr97P
         Qh8rA8EqQCivj7VRjPzm+NoqGVstqmee48P0rVXpAsK09Fa2CCulV4XU8eryqLp5AQJE
         jVUemBzko9nGjvn4T8SSpiztxatXPONhdoqZrE4gnhGx2eFbMJ8wuCKwwnUujgmPcZKw
         VNzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717597181; x=1718201981;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T1EmDC2bGMmU0XeSvchLBl6+1crQIfO4g6MqrY1wcIM=;
        b=QFFHeKjyeg+rW7PLkr8jwWPnVfv4ex6l/b+iROVpfAMesPibap+z2Ekm220w+queZ9
         Df5aeI8wljJiB0YBCiT2qFcaDBsbbEqxp1tCcpUzXWgYkWR+O8DfntVLHMnirlQALULS
         AfrPcFuE02xHAT3jyNeLtfkN40JCtIH4PrFy7CW65MhYzGiYsBZOOZmLH3EOldv+akhi
         SIuqcIn/4DCmWgJbpmSlhu4ijT5KCDI1Pij5qCj2Y1XDJD6VafKkbHnq/RtGV8uOC2aB
         GHurdNsWVmDPXhJNL063Ls/fWAtXj9yXQKCwd6i3pbWyCDuWkC8YKoCAHQXb4rEaYKs3
         tMCg==
X-Gm-Message-State: AOJu0Yx+1EuKWZZ4xxR8HvC0aUlt/BM2b1uhyaO5RbYqiWvVGdgQIkIa
	vLtD13kpWkNmewuzV0AnK0rd1XJULr7oGbIRTju0t1xpv2Op2dICatNsB5LxmoLJUXz/4QmgTpS
	5
X-Google-Smtp-Source: AGHT+IFfzknKUeqA2p6Cc3z31GXrzHks2X8zBt5i7RTXo1DvEKpPQWvvFdhtue3KNAa46L6r+VILzw==
X-Received: by 2002:a05:6870:4d18:b0:24c:b092:fd38 with SMTP id 586e51a60fabf-25121cf42eamr3315374fac.1.1717597180911;
        Wed, 05 Jun 2024 07:19:40 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-250853ca28esm4048918fac.55.2024.06.05.07.19.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jun 2024 07:19:39 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 1/9] io_uring/msg_ring: tighten requirement for remote posting
Date: Wed,  5 Jun 2024 07:51:09 -0600
Message-ID: <20240605141933.11975-2-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240605141933.11975-1-axboe@kernel.dk>
References: <20240605141933.11975-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Currently this is gated on whether or not the target ring needs a local
completion - and if so, whether or not we're running on the right task.
The use case for same thread cross posting is probably a lot less
relevant than remote posting. And since we're going to improve this
situation anyway, just gate it on local posting and ignore what task
we're currently running on.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/msg_ring.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/io_uring/msg_ring.c b/io_uring/msg_ring.c
index 81c4a9d43729..9fdb0cc19bfd 100644
--- a/io_uring/msg_ring.c
+++ b/io_uring/msg_ring.c
@@ -68,9 +68,7 @@ void io_msg_ring_cleanup(struct io_kiocb *req)
 
 static inline bool io_msg_need_remote(struct io_ring_ctx *target_ctx)
 {
-	if (!target_ctx->task_complete)
-		return false;
-	return current != target_ctx->submitter_task;
+	return target_ctx->task_complete;
 }
 
 static int io_msg_exec_remote(struct io_kiocb *req, task_work_func_t func)
-- 
2.43.0


