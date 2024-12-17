Return-Path: <io-uring+bounces-5528-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id AC9929F5731
	for <lists+io-uring@lfdr.de>; Tue, 17 Dec 2024 20:52:50 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 160C1189526C
	for <lists+io-uring@lfdr.de>; Tue, 17 Dec 2024 19:47:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 788E01F9EB3;
	Tue, 17 Dec 2024 19:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Oh1clw47"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC4D342A9B
	for <io-uring@vger.kernel.org>; Tue, 17 Dec 2024 19:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734464738; cv=none; b=YX0E6V6H203wkuo6xLoNHLm8r/NRsidOIPyCgRdv2ENxQ7nVZxOg5PNk0gjvdhsESLV/IUFJVtJfB5em/R19ATC3ptd/BzRTet7QhN0ALObcoRxL+EmKWUP1YR16xs/E03KZggujZBNfxdXor1dsDSlIcj38tczS/8nB43J0W5Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734464738; c=relaxed/simple;
	bh=6K4U6l8/fj/4AXVCwFLrges1RyYyNn/Ut9dMR7I9bWA=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=jMucxzqjxdAL/rRZpIxfCxN8mGZXbWEQhQ3pTQmA1cMRXxDIchvMVYO6v3JuK67Rl1yYE3W/S8pCj7GrfS/xfJ4QItRLndSp7YfgjWNdhhjj7b3amwgLpdHlEXpnX4rrcC7/pmr/vgLGL8qHUsnd/NTq258gJgWSgvH0N8YS/5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Oh1clw47; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-844e7bc6d84so2238239f.0
        for <io-uring@vger.kernel.org>; Tue, 17 Dec 2024 11:45:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1734464735; x=1735069535; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jCN4B3w2mKEhCqLXRtvXS/XvjuV5n0c30iYYiulYORE=;
        b=Oh1clw47kbKTJgwx9jtcsR53NcmMwxXR5CQ7Im2phoKD3xImukG6XJ7fexLfZ6UNG0
         qDeUvll0FSOvzoyT7j0wctY6GDvn3XcD6BCqDp2lfjnaRpq1f/4imf5msRIq1V9Hw9A2
         lk8yJRzZdD+ugh0Z6gkQbjzTqLM0TYagDVpH2ewD5q424YgZ07MmnTL5MmtBOcK9XuMv
         q5t1yziNf79DZ6b0POf/f80UiyNutGIrk2vx11/H9Mtkxv3FXxUxNW+i/lmFVbedIoo8
         aGOU0Pwd+HwNMm6+vzBYGOYCDEA5u01aFnTH2mMHblUSTl4K+A2Wtz+OLsPcl95e5SLb
         2l8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734464735; x=1735069535;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=jCN4B3w2mKEhCqLXRtvXS/XvjuV5n0c30iYYiulYORE=;
        b=XCT4Z/J0JCl58esCMrsSHugu9nv/Guv3muhwWChZtmpTzNwodih9wBH41QjNEt0OWf
         /d5M/D1F1V0uNBFoC+w511hO8NgYCSXqo88ekzHtagyAjOt2Fo8PeOcMHJEcDHpCV7ut
         15YnzP/eicK5MR1prKwk02CVJ0kR1NKVqavuHCJMz/vVMy+e9t19u8GZleXSDOiZkoIX
         /cmYDQmwGQ0TJJNe1CDZX5U1pdzLWp4oC5X1Qc2ElKyq8pzzuSwD1ADh/A4n6Yz7uW8X
         nwRgHhhZri2Ze0kvC8A8B7fNtYC2Bi1QnmQuese0f53Gud2EN4egrv0/GWHyF/vvcf3F
         LmJw==
X-Gm-Message-State: AOJu0Yyva/uD5HfKQDoyProwaLvBdjtRSTAljBslQ0W25jPeEZHQBVle
	hcrwm38bVvHYSgLH5KxvEfG90pD2GKhqUcMahmgG/ea91/DP1HXLED8NgKyES5IFb+w/9Ir4lYU
	h
X-Gm-Gg: ASbGncvMuR9X546BaEMoaPlI7OzzoEhCJQGHzW6IA0ftS4qKW6T+gKIaVZPJfbISMpE
	KHeRLoNzrX3xiPiwzfKIAsBUrMrx0SPil6CFweWg/A80Hbo1ud0qKkQW01HRDpJ+diBydppBKr9
	rxbHKHEjhEgWenPFlleVyB+LZiIg4VwU/14UISlwAe7DWBYqUBSC2XWvE6u4lq9YeGkapPvPbP2
	REAHKFBgLXiX1tIZ0jD33drm9w0pdyeh4A1R+oDFozeEKRVkefX
X-Google-Smtp-Source: AGHT+IE4oKNfpSQqa0sQ+Z4p/JG0qT+mf08KGHUA2MHLXQFwwmTGC5iXrNOE7GGbiaVAnD8vQmpH/A==
X-Received: by 2002:a05:6602:1413:b0:844:7896:8cb4 with SMTP id ca18e2360f4ac-847589ea367mr4497139f.1.1734464735310;
        Tue, 17 Dec 2024 11:45:35 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4e5e378c1f9sm1801850173.134.2024.12.17.11.45.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Dec 2024 11:45:34 -0800 (PST)
Message-ID: <987219ec-d6ba-427e-a9fa-9ac63660bb72@kernel.dk>
Date: Tue, 17 Dec 2024 12:45:34 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: io-uring <io-uring@vger.kernel.org>
Cc: Gabriel Krisman Bertazi <krisman@suse.de>
From: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH] io_uring/rw: use NULL for rw->free_iovec assigment
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

It's a pointer, don't use 0 for that. sparse throws a warning for that,
as the kernel test robot noticed.

Fixes: 8cf0c459993e ("io_uring/rw: Allocate async data through helper")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202412180253.YML3qN4d-lkp@intel.com/
Signed-off-by: Jens Axboe <axboe@kernel.dk>

---

diff --git a/io_uring/rw.c b/io_uring/rw.c
index d0ac4a51420e..75f70935ccf4 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -212,7 +212,7 @@ static void io_rw_async_data_init(void *obj)
 {
 	struct io_async_rw *rw = (struct io_async_rw *)obj;
 
-	rw->free_iovec = 0;
+	rw->free_iovec = NULL;
 	rw->bytes_done = 0;
 }
 
-- 
Jens Axboe


