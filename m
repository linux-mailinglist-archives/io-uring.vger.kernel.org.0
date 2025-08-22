Return-Path: <io-uring+bounces-9255-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B4EBB3192B
	for <lists+io-uring@lfdr.de>; Fri, 22 Aug 2025 15:19:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4AB4A601E1A
	for <lists+io-uring@lfdr.de>; Fri, 22 Aug 2025 13:17:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31B7E3043D3;
	Fri, 22 Aug 2025 13:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="DhGNz4HU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f173.google.com (mail-il1-f173.google.com [209.85.166.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2ECA4303C80
	for <io-uring@vger.kernel.org>; Fri, 22 Aug 2025 13:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755868566; cv=none; b=hRB1MGRKSmL582BMe42tfOAhwaQUzcChSjWSZDN3RQfpszfHfoSrhhbp7T6OgnXnet8ns/x5pwOyxRFm3dnX4ELP8RlH4qr3ybJWjoKc+a2jRx4gmpXH6gQ1CJbABoKXqYvyo3nh4uqRu+zDnywD6tesjksEFOnpf+p0m+6NFqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755868566; c=relaxed/simple;
	bh=cPyI8nSQyovOpiAi2ESiDhZM1qMB0TUMPRmPyhUEh6s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VlolY06Ctcf9/Kyc1GYk0Msi3FEV4rblGZA3E6EZzjqsDswR4+HZiRkxGZ4iNBqA9GEUCqpApp55+kl+VIUTGhPEwTm2ziAJU347b6wlb979qbs4BLcjQDqaoivuNY6IH09Txcj9CZ90U3g40Z62P1+1RznR0ud6qN4Uin4X4N4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=DhGNz4HU; arc=none smtp.client-ip=209.85.166.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f173.google.com with SMTP id e9e14a558f8ab-3ea25a7ff7cso907485ab.2
        for <io-uring@vger.kernel.org>; Fri, 22 Aug 2025 06:16:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1755868562; x=1756473362; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ypDMIm38Aa2Zzpm14sNZ6IwGqy+EN6MRxoUZPaQoOj4=;
        b=DhGNz4HU0j43lwuHLGtbNOjXFvrvijfBeXbvDJaRPGnQUWpiINyQH13QdTT3M40K+A
         5zrjzXpE2IkAXfNTAIkuF4pYMJt3+c0JZn4rUZzUEnXaXz6p/ZbiunRFl9GiGv8eHypa
         GwyVE9Qfo2RbZN1MeCzbm+AxLIs/EuueUHcPvJsnZ/oeoPuG4b3pNrSuEcyrnetQ/TI5
         25vJFXp8pDApWks/to6ybJDe1md2ZkW/kUJ1tRSHKh1I92maRyutokFcikAM0xeidhIx
         uv5XyyQIQSFbBI8NJPSRd9aZRShcKAsucyQAfYK1cZn+1eqNvoghzGRUHSLUaLEDu2Z2
         E1MA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755868562; x=1756473362;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ypDMIm38Aa2Zzpm14sNZ6IwGqy+EN6MRxoUZPaQoOj4=;
        b=tywdR4s7DH3VlIiFNJFQ6b2gaQeKfruYM6mnIAkK+gyPS5me+9xQ7taPbm6uabiPXJ
         Pz4HAzZvHCEPbb72eE7WihWGKW9qhMzdiIkqWcAn4T8TwqtOB9z0dUhBfa5Ln5/LtSu2
         1/wgRYXJGiwAMABdjtd/b3/ZvUdODVNIcn6uIYLSTTFntMISh2pJKCfbKQY2W5aAwVgN
         v6h/uUR8IlEcfm47lnMbAfyotObdXHt7zkbHfZzU1E0svZTprQ/y5Nh7rJTLgq7Xki+f
         sSEDJioyLB9qpY1DFfnXtGaEctibgLyHoS6R6pXh4wxeo9orkiAIrOokCSEiRu5VIcWy
         blWQ==
X-Gm-Message-State: AOJu0Yz8rqztXPzrXHUBWrYFPcR2tTFw/n6i0146lhl+r9hxw3BJOiQF
	+uzHrfe6f71TJjyrGkvxP0Kbojj1jBhZ6moZ5c8nUp29BWuaUxej29PU+X3YDW0haXteRo7soZI
	UJ1pH
X-Gm-Gg: ASbGncupnlsKhvbdgSa5rxI6/MyBtShA5RG6jm/7eH9sq2aYStBsBiNyriHU0yn9D1m
	aYnx2ULj+Kqz5i5rvfZPWdMV/FNv6Usy8c3Y1IwtwUuYAHJcHxKDGZujb1CUvxvm2i9DWvEb0zJ
	h/9b4TGIHXO0EQXIDe9mzePqlAl5P2lfrHp2tUK4isq8yj1xv+50ZVey34DaKeGbvYvnI4qn/VY
	3Sq9roq3ZttNVXy7cORxBobE1ETFco2WsKs49jwwMyEU3VpEnhSR7uLqgVqX+99HuEAXxmHZ7HK
	T50Fkgoj42RwEx+HiXo6aLdPIiF3hNujVjuuJOA0Qc1Mt2NP7qDBFYWdhL/RFjHqASm3gIU5EcZ
	mNJPR4g==
X-Google-Smtp-Source: AGHT+IHdzjWR92aeCBfHyrQm6jq6+ppSeW99A9rs101EU3GAXd7QftYJWx2s+EmTNtirDuPAgbwU9Q==
X-Received: by 2002:a05:6e02:16ce:b0:3e5:5bc0:21d5 with SMTP id e9e14a558f8ab-3e9223163d8mr47392795ab.21.1755868562548;
        Fri, 22 Aug 2025 06:16:02 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3e57e679121sm89355595ab.30.2025.08.22.06.16.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Aug 2025 06:16:01 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/2] io_uring: clear ->async_data as part of normal init
Date: Fri, 22 Aug 2025 07:14:47 -0600
Message-ID: <20250822131557.891602-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250822131557.891602-1-axboe@kernel.dk>
References: <20250822131557.891602-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Opcode handlers like POLL_ADD will use ->async_data as the pointer for
double poll handling, which is a bit different than the usual case
where it's strictly gated by the REQ_F_ASYNC_DATA flag. Be a bit more
proactive in handling ->async_data, and clear it to NULL as part of
regular init. Init is touching that cacheline anyway, so might as well
clear it.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 4ef69dd58734..93633613a165 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2119,6 +2119,7 @@ static int io_init_req(struct io_ring_ctx *ctx, struct io_kiocb *req,
 	req->file = NULL;
 	req->tctx = current->io_uring;
 	req->cancel_seq_set = false;
+	req->async_data = NULL;
 
 	if (unlikely(opcode >= IORING_OP_LAST)) {
 		req->opcode = 0;
-- 
2.50.1


