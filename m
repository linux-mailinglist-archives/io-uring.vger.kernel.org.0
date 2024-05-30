Return-Path: <io-uring+bounces-2003-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C9B0A8D4F10
	for <lists+io-uring@lfdr.de>; Thu, 30 May 2024 17:28:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 04CC01C23817
	for <lists+io-uring@lfdr.de>; Thu, 30 May 2024 15:28:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF147187557;
	Thu, 30 May 2024 15:28:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="L0zc8PUj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE7192B9A7
	for <io-uring@vger.kernel.org>; Thu, 30 May 2024 15:28:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717082918; cv=none; b=RXv4DFcjiALUfMEpxRt3kp2c2bSfCW8eMSI+jnmQ41PK5pCUgCQMaKAlR068R9SoEKdmUwZ5qSFEclKdBu4HT/ANnn2pbDrGRC/k82KM+SQhD6a5i/gGPDG0KUwmmFnbu91cPELzQXmJo6J+ph8kb1PleTmrIpIPC2Ja+aEMiBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717082918; c=relaxed/simple;
	bh=2Q2dSGFIk6ae3C72JCPQextl1UuegmFJtlnZRGAs0og=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LpPOlJ4p2702IA/eWf4YHEeLcLwq5tIs9Q8Vayc0H3XPYbA2gH3tuHvoTdmpeKNvp28aug2OVEjtsE6Dahb5qOFfJoczjFEkZVTlABNg/POpUmxVEt9IH2CpNIsvYIoiwVDGv0Ap7DCmv2uGiTiJEAaxXwQaKPFoBl5eH5wbDIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=L0zc8PUj; arc=none smtp.client-ip=209.85.210.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-6f9090cb1ecso43416a34.2
        for <io-uring@vger.kernel.org>; Thu, 30 May 2024 08:28:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1717082915; x=1717687715; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lMmEpGb/x1O2qmozmgQz/bi6ttKpLfGRNHdQWDI27F0=;
        b=L0zc8PUjlSNB6+1ltl7fsnuXGSJYFR3brRzrXEaCcKRAEuoSlryYpR1uPQrPho/Iyq
         NnMECURKp4t1Xr17pJcj3ylhXsDynf0QXtF3K/0ckq143rW5BrYkCGHz+GliW7mnkSIT
         JLp3t2JqiuV/FVS1PmU8xv5tVPfC9nZPhp4Z2oRhdZwVRS4a4ynl7XhvKqJD2/gR0Wkw
         EhmVlVQX3X0tetwbjX/iQeMm421RO+a/JO3XWtIzM+QnM4B0eSYp/aF0j/Zp5cOjIecY
         M9lXFYE9sEj3ExMeNWLkME0xI6lkD8Or0u3NjWrbh3C6rq6Z/UqWjHgdhlrHswmY9u45
         lSOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717082915; x=1717687715;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lMmEpGb/x1O2qmozmgQz/bi6ttKpLfGRNHdQWDI27F0=;
        b=SsUoUxrbUnbZ6RYsqX6l0wQVoI1xkZYCNSMSGP9+AJ4UC58LOCvLisIilP7gX0w2Mr
         n2NzY8fwkIKRRwcQ22B+5SkTUxyRX69SLHvJzgWAKDOM70CHVYO19P2fhfYapEvLDbQP
         yLWimY1lXaTu2wZpbmmGUHHMpsXiwGrTNUpPAMBERJtcqgNUddNeBx5ANKMPSQbzfXdt
         9peoedgoZUEi+vDaCceYUsSB4gG836k3dMJDevhNhIMGlI525oI15dlWyZ/5yuiv9rTa
         chgmVKKVDxqh0Ev9h+eU32zNhn0esLjnI2uTlfL8IEfK1KZifh0ALrofnNxxuZRIWp1l
         YzDQ==
X-Gm-Message-State: AOJu0YydYGmEkpZDES4geDsTeh6ysRldlQOLsrPMe7HTkKKcy2Ev+8VI
	WcBkAJq40RI7f3UOj4iprGw1H+YL5wRnJx4/+DbdkxTx/lBf95U41Secr3GlLizN/z6vqPJBLnX
	l
X-Google-Smtp-Source: AGHT+IHUW3AQU+evhmzRWXhlMWUIKPoSC6G3aG/l6LUW2Z9JB0M2w+NEU9Hf+SxhIlykPApdacHYuQ==
X-Received: by 2002:a05:6808:1b13:b0:3c7:528b:12ce with SMTP id 5614622812f47-3d1dcd1807fmr2770538b6e.3.1717082915149;
        Thu, 30 May 2024 08:28:35 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3d1b3682381sm2008136b6e.2.2024.05.30.08.28.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 May 2024 08:28:33 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/7] io_uring/msg_ring: tighten requirement for remote posting
Date: Thu, 30 May 2024 09:23:39 -0600
Message-ID: <20240530152822.535791-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240530152822.535791-2-axboe@kernel.dk>
References: <20240530152822.535791-2-axboe@kernel.dk>
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
index feff2b0822cf..15e7bda77d0d 100644
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


