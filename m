Return-Path: <io-uring+bounces-554-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 6E73084BB08
	for <lists+io-uring@lfdr.de>; Tue,  6 Feb 2024 17:34:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A17251C2400C
	for <lists+io-uring@lfdr.de>; Tue,  6 Feb 2024 16:34:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6778C523C;
	Tue,  6 Feb 2024 16:34:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Bj37fNCh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f49.google.com (mail-io1-f49.google.com [209.85.166.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0D9D4A34
	for <io-uring@vger.kernel.org>; Tue,  6 Feb 2024 16:34:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707237272; cv=none; b=ZnYUVDS+I2qLVRZ+hQkHC/DaFTAYfi3pY4ccSyP+zrMaeD5ymO+W5z8stQH2OLGJz7aC9rxajBs/ujNOI7p+IoENENPgmEdqMGnbh0IKTUMnj+CBMp6EQDdPCaryYO7eMagyAdlVjixqW+FV+IivoVKQwx1qnRqo2xNpLXfeIcc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707237272; c=relaxed/simple;
	bh=SuaQlgcVOVlC7zlMPU+x6rEsJ0Zjx6NMLKM8YlnWwBg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gdd9wKb8IGQh+CDx1vpdrKT0wLxd2xdIpFYOX9kSnGPspVfxslM/SG5Etbb7zjCDPMrsF3PrrBvGHMTbxBJRVpQFlXds2NZGmR4rinRmin83yspczAxlzZrP4q60i/cA9Lgm5PNrJMfFzM71Y8WzIdWvTq95Y0jR7hwhXdP7EjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Bj37fNCh; arc=none smtp.client-ip=209.85.166.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f49.google.com with SMTP id ca18e2360f4ac-7bff2f6080aso40928439f.1
        for <io-uring@vger.kernel.org>; Tue, 06 Feb 2024 08:34:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1707237269; x=1707842069; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8qELm2FpXv5k6BPFGObM3NIMiZQejvBKMhHMcJLLsQA=;
        b=Bj37fNChJoyhttk0r27Mmiotyd4c8iU0/qml6rgmt2csSQVev4PzvV32PyeIS+oPdo
         bPJVsHvclJP77BE7Qqip1YBjBO/WQjdVXLP7cAW9v2HO+dyco3DlRwFpfVnjdpv18oZL
         uWBhdPZ4UgkFz8ojtwitEVPyUOn5YEwRBIFS+vmr3+KNEVpb1oB6MEI9elSa35NbHGT2
         uoLHU0Pbc4Ha63wALonjbkiDQHTUDX8uZlmAbov2/Lg6ZQZnNKOI2zlXB410q99n//Lc
         UorsYYE5gK2wvr02398vswe73aZ1VIkeV4a4nq6VPIv8b6SlAdOWj1JPzUwVc08Ux9SY
         MfeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707237269; x=1707842069;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8qELm2FpXv5k6BPFGObM3NIMiZQejvBKMhHMcJLLsQA=;
        b=hAIsLopbTzV79DdA/3CCdLPC8Dnl6cI/QIcdUxksjV6Nx3yKxIJwyY1RrE1i4PhTpB
         kCLA2ESv2N1kMLj11/L5zXes9JhCN3baibYWNJFgIXnqns/ewY0dgYOGnpemmE2KJzTn
         HIqtl1Gg8nznQEUJPGjWVZdp9Oa+4G7dMgo52AEceYjUKj+WiLCURi2ul4RR2fET8wwH
         IwR/iD6TbSt3NnVfBu/oBAktg5rjnV9I6cNQH5bx/t63DkfifV/1ZgBM+XG/XhtUzBZV
         +ismnokn87o0fWiocZpRMpw6dVSjF5rai7NJbmdubS7mIUWjkAdN1QUO52Wx1Zzo9m19
         41uQ==
X-Gm-Message-State: AOJu0YzpKlnsCmmNT+trFcQ2bn34/uJlONw9gui4C7aS8QMceww9WQFb
	nwmbp7ripfzQG/0RaMuboDXhJ4JbDlISVrZiybbtVXI+BQ6u+nnOVlxSFugBamNJpawCcg2eVoI
	lARc=
X-Google-Smtp-Source: AGHT+IFw+i3L56sDBdDa7canvbqgNWiUREG82CvFI7cQ4FKKEQj1Wc7uJgRU4m/58cqRPC+ml+LhLQ==
X-Received: by 2002:a5d:938a:0:b0:7c3:f631:a18f with SMTP id c10-20020a5d938a000000b007c3f631a18fmr1226623iol.1.1707237269512;
        Tue, 06 Feb 2024 08:34:29 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCVeXh9bAilBBSoN28EwjapOXRkmP+0S2LSrQY35G8X3K9DLc+7enLS6UHcbEftaqmL4akS6hgNiJ9SuMQ3jRzRoRz9wNv39aV/xWOxWYq69FLq8lTdf84Zm+mizD5HEWmAoY+4vOPg081uuWkIxsSBZypW05txqeCgdKZcfeMOym/Q=
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id u8-20020a02aa88000000b00471337ff774sm573316jai.113.2024.02.06.08.34.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Feb 2024 08:34:27 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org,
	netdev@vger.kernel.org
Cc: kuba@kernel.org,
	olivier@trillion01.com,
	Stefan Roesch <shr@devkernel.io>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/7] net: add napi_busy_loop_rcu()
Date: Tue,  6 Feb 2024 09:30:04 -0700
Message-ID: <20240206163422.646218-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240206163422.646218-1-axboe@kernel.dk>
References: <20240206163422.646218-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Stefan Roesch <shr@devkernel.io>

This adds the napi_busy_loop_rcu() function. This function assumes that
the calling function is already holding the rcu read lock and
napi_busy_loop() does not need to take the rcu read lock. Add a
NAPI_F_NO_SCHED flag, which tells __napi_busy_loop() to abort if we
need to reschedule rather than drop the RCU read lock and reschedule.

Signed-off-by: Stefan Roesch <shr@devkernel.io>
Link: https://lore.kernel.org/r/20230608163839.2891748-3-shr@devkernel.io
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 include/net/busy_poll.h |  4 ++++
 net/core/dev.c          | 15 +++++++++++++++
 2 files changed, 19 insertions(+)

diff --git a/include/net/busy_poll.h b/include/net/busy_poll.h
index 4dabeb6c76d3..9b09acac538e 100644
--- a/include/net/busy_poll.h
+++ b/include/net/busy_poll.h
@@ -48,6 +48,10 @@ void napi_busy_loop(unsigned int napi_id,
 		    bool (*loop_end)(void *, unsigned long),
 		    void *loop_end_arg, bool prefer_busy_poll, u16 budget);
 
+void napi_busy_loop_rcu(unsigned int napi_id,
+			bool (*loop_end)(void *, unsigned long),
+			void *loop_end_arg, bool prefer_busy_poll, u16 budget);
+
 #else /* CONFIG_NET_RX_BUSY_POLL */
 static inline unsigned long net_busy_loop_on(void)
 {
diff --git a/net/core/dev.c b/net/core/dev.c
index 1eaed657f2c2..ffa394f3e796 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -6179,6 +6179,7 @@ static void __busy_poll_stop(struct napi_struct *napi, bool skip_schedule)
 
 enum {
 	NAPI_F_PREFER_BUSY_POLL	= 1,
+	NAPI_F_END_ON_RESCHED	= 2,
 };
 
 static void busy_poll_stop(struct napi_struct *napi, void *have_poll_lock,
@@ -6285,6 +6286,8 @@ static void __napi_busy_loop(unsigned int napi_id,
 			break;
 
 		if (unlikely(need_resched())) {
+			if (flags & NAPI_F_END_ON_RESCHED)
+				break;
 			if (napi_poll)
 				busy_poll_stop(napi, have_poll_lock, flags, budget);
 			if (!IS_ENABLED(CONFIG_PREEMPT_RT))
@@ -6304,6 +6307,18 @@ static void __napi_busy_loop(unsigned int napi_id,
 		preempt_enable();
 }
 
+void napi_busy_loop_rcu(unsigned int napi_id,
+			bool (*loop_end)(void *, unsigned long),
+			void *loop_end_arg, bool prefer_busy_poll, u16 budget)
+{
+	unsigned flags = NAPI_F_END_ON_RESCHED;
+
+	if (prefer_busy_poll)
+		flags |= NAPI_F_PREFER_BUSY_POLL;
+
+	__napi_busy_loop(napi_id, loop_end, loop_end_arg, flags, budget);
+}
+
 void napi_busy_loop(unsigned int napi_id,
 		    bool (*loop_end)(void *, unsigned long),
 		    void *loop_end_arg, bool prefer_busy_poll, u16 budget)
-- 
2.43.0


