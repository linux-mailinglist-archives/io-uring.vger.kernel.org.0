Return-Path: <io-uring+bounces-8097-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 55A7DAC2281
	for <lists+io-uring@lfdr.de>; Fri, 23 May 2025 14:18:04 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B63644A7966
	for <lists+io-uring@lfdr.de>; Fri, 23 May 2025 12:18:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D6EDB2356B2;
	Fri, 23 May 2025 12:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="jZC3Ughj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DB8322331E
	for <io-uring@vger.kernel.org>; Fri, 23 May 2025 12:17:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748002678; cv=none; b=egse3AnrN1xrCiMHwqR1SmRWQF+b6zmaLfy3UQ0n2OT+vd6E5TIh656m+FO4Fgf/BALiNF98bJACt8245VyyYDrzm275xSXZQn8UABNpMu4sXnom76Ed5P1kziW9+8BE+JSmmEaIUb0u9YO8NhmIp2hVQn/qjhPwvT+H6Wyg+/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748002678; c=relaxed/simple;
	bh=sC1Tp4TgSk4TtP9atV7od9uQ8LwN9VcClgDCeXPBwRs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IT4Kntrv5B4XMH0RhVcjPWsraiVlUDqik6pn3KflA3W/GQMK6VPG9jt+dC47uFLnRTcx5Ty8f8h8gaUbk235Zatk2nQuCEwGEpeYoNS5jl2rPs2bXZSiz9Jk+F6FN1BNtxSZgc69EegffYpJLc2ZVHYRV2ulXoAXbv5dIYZc2YU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=jZC3Ughj; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3dc8265b9b5so21827585ab.1
        for <io-uring@vger.kernel.org>; Fri, 23 May 2025 05:17:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1748002675; x=1748607475; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zh9I7mQSEhgr73IxxXNZQduJkGTOKX5t1+cipR+tvnY=;
        b=jZC3Ughj66Flu+m/SrgoGWTvFtW52OEVJS8sFeb8eEbnxV5goNwMjSBVvGrfxMWNmv
         +kqf5P1d+Kl7MWfzBlNbVgna2kq63Hq21Sl3+7moKBesoD3eE+UJHfomm/2RgmWghtP2
         y0Q3moeux4QQFHHN6rj8AYR4Bh3lM/QeECjpihfn8j2k4FElDwTM4gmnbePLABngpavT
         1J5YV8sCfizKZ1M1mCsGu8OenMTR+t/zQrJzRSLWfo4CFuhxZbLUuqYtBkBay2hFRnwz
         WfbaLL6H8y1ujMhCnanQ66TDksrlAdS3cXKQGnnLpoY4XskBQl3uuvbxmdIl2NSruw6+
         VJtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748002675; x=1748607475;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Zh9I7mQSEhgr73IxxXNZQduJkGTOKX5t1+cipR+tvnY=;
        b=KGN/9Q52tj6qI9ebO9PbpuTWxQ2lZTA5/ivKq5dEz4bamrdXwmIgZd4COT3ndbGNB9
         BkE4a1NMmGhfm+nw3XV7QWOwHuqu1y2GCiit+qRK12JGw8b/gFrtV/jU2TfwnPf6XFyB
         LzWApnLhlD1ACBbq9HnDh7x3oXzBKJ1r5AlJzfTQWGnXuaceRpPqQ6s0oh29jfo2/Q6L
         jlvhfMMgBMb77DGIt+wzoGpu3pzYGad8WDIBrlAyLq21mmv9vmPgDyuIsJe0dBn5nz9h
         NoZeEBRNPQUCqStT7/PNl/yIWxZR0d7Cm2A/lzUgMLB17Sv5vtz2bAHIfJf9C/U3RgJ7
         oLsA==
X-Gm-Message-State: AOJu0YyCcNozt1zD24PFs1gg9r7pC8G715Rodf91S0beTaHFtdeH3VgK
	dOzbwea1/Cx9y7ZKHlEnSSqiSG9CJ+pBjBMYb7fhexvjwug53Y3MIbrEARRvFwPTs2+vKruR1Z0
	HTN9J
X-Gm-Gg: ASbGncvqIdR7hZBbxnQT2f/GA14PZ4gCbHCDI52EAFq8d6lcAlPaF4uXXoAm8YXy47L
	19FTR/8H80plC0+EDiOGTMU3XuJiRYTHrsTz3et7foGMxxmcIKMnb/y6YsQZoT+zayMyDMuzu+7
	wBMFlUmjmKre9nqu+4rkDdAn4w7L5Bv9/8NcnvNoVEkee0tFpubmxGgaUqF4DiVvtBYtV5u25/T
	VPo60tbKXt0HHfcXgRvdt+6+xK5tWhw+Wong/3SFdIdQf62wQhQLh6oYbv8EUF0M6sYT0cw08qD
	dqchQW503L/Hl/G1bqgOdIym25vpwQU4RdUJJoKb3JtsNUM+GNGAuy2M
X-Google-Smtp-Source: AGHT+IHvhn9NveHbdlCSm0I5HJcoTbriI+Vc3gpqmpOVR+V1NCnSzfP18f3I8kJojGkY2PvO/o7EJg==
X-Received: by 2002:a05:6e02:1745:b0:3d9:36a8:3d98 with SMTP id e9e14a558f8ab-3db84296deemr339303775ab.2.1748002674952;
        Fri, 23 May 2025 05:17:54 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4fbcc3ddeafsm3617552173.71.2025.05.23.05.17.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 May 2025 05:17:54 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: changfengnan@bytedance.com,
	lidiangang@bytedance.com,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 2/3] io_uring/io-wq: ignore non-busy worker going to sleep
Date: Fri, 23 May 2025 06:15:14 -0600
Message-ID: <20250523121749.1252334-3-axboe@kernel.dk>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250523121749.1252334-1-axboe@kernel.dk>
References: <20250523121749.1252334-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

When an io-wq worker goes to sleep, it checks if there's work to do.
If there is, it'll create a new worker. But if this worker is currently
idle, it'll either get woken right back up immediately, or someone
else has already created the necessary worker to handle this work.

Only go through the worker creation logic if the current worker is
currently handling a work item. That means it's being scheduled out as
part of handling that work, not just going to sleep on its own.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io-wq.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/io-wq.c b/io_uring/io-wq.c
index d36d0bd9847d..c4af99460399 100644
--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -429,6 +429,8 @@ static void io_wq_dec_running(struct io_worker *worker)
 
 	if (!atomic_dec_and_test(&acct->nr_running))
 		return;
+	if (!worker->cur_work)
+		return;
 	if (!io_acct_run_queue(acct))
 		return;
 
-- 
2.49.0


