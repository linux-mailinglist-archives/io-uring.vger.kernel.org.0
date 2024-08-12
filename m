Return-Path: <io-uring+bounces-2713-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 844A294F580
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 19:01:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 2E5351F215DD
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 17:01:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 214EC1849CB;
	Mon, 12 Aug 2024 17:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="AMHt7BVC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15D2713AA47
	for <io-uring@vger.kernel.org>; Mon, 12 Aug 2024 17:00:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723482061; cv=none; b=ZOlMn4nZNtpEOZ04V9V0S99xX3XiCvb1Ti3zf4KynMRLEboF4vTB4JN40i/ZVVy8YYBeGYYvvea82eudBqpNrJuIegdE7+gx3xZXVJi4jIDbgZ9xSsVAlsPe4/bTiPLYg8E53LZ7Wjw1QMiUL0XsNz4heXB8OnthYYI1OHPRr2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723482061; c=relaxed/simple;
	bh=CEJQUJaNShFRAoYb7OXpHGCrl24JZf2hvGjozUcru2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YTkOGun1w0KagCS0qX018lwak8WltWlSIXYXHg7nPcGuXlRjgITggD8B4P/QuTiM1ptkGLJ7lcJSrscv1OT7A9XwP/6wH+THmerREKuX9Lt3ELHUIH/9qD21cuyjB6Ay8jPLND4twwZ8kANtJg7GYbhhu6b1g839g0aNvcOK1Ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=AMHt7BVC; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-1fc5a6147f3so1981935ad.2
        for <io-uring@vger.kernel.org>; Mon, 12 Aug 2024 10:00:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1723482058; x=1724086858; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wYiaDg8G3wV+GXOQbFZjaRsZK4kWIVmhgslAB3aLK3Y=;
        b=AMHt7BVC2cEhdmb6KDSEeDMTmo2uO2DvcVipJTmJ0EVj/jLjh+jz96jOejaBbmxOGA
         aAaBkxVia9r3TL7KWBqZKiE5UKtYJNva8VUn4Ihg1EioBZm9BKmJBb5m/NPglqobBWzl
         uc2emolC+gxxqQ2hSIyVdymeNIQytyC8rT1LoalrXkEnN9bvNga6Un02q0VbgnnrF7YH
         oGlDCQY3WBGjT+nmMsdWO7iylRUvMFx/wnzHguWpdVJSjXwn38UcbYQts+u0HoslLSGM
         kolRVa8/sgr7zWUbxSJzlA7yMr8OUFrPDrBOsgXoKeIIDS+Ll0LUpQrSXwsbmzjvpX0v
         u82w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723482058; x=1724086858;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wYiaDg8G3wV+GXOQbFZjaRsZK4kWIVmhgslAB3aLK3Y=;
        b=gH5esmkU8aV649UEf7TLCjDlDTNWu6vb4ORHydCZqriFztpQrvccuUj60qOnPnAz8v
         MUTTZdBOBHiAQmlffmfGNFKysrAnTBBWc2hmln3/suIkSjvoIoOJofhlKa6775iflz42
         acMB5UnIE46bCImdGVDVv+XlIrLeKb8R/XG8fk6PiPRNx+xdFBwo+elNtI7zIFSBv6HZ
         UfW/p40McImjUh+7im0BKpAGs0keOQrms/zicC9WinVdezbxlDDZhDLcRxagZWN9uYq3
         W0LdrsVeB4oLkAOVUWYyuAxzWzOlnuKiWgMXz/1FRnjNSvxDEExPqqN+xAqxay5iNVRG
         8Law==
X-Gm-Message-State: AOJu0Yxdl6PPJjOyFHk4RPQFZSnh33tSmah29W764nMzaVS6xKi9J65w
	3qmx3ElzIglHOILlv0uzE6Zll0cYH/D8GSXXClZS3GrDTY3cuxrFBXy/Av6kqqZyBgVHSc5+CSF
	r
X-Google-Smtp-Source: AGHT+IFGG9O47Xicpgk8ao1fk5Sn4Oak9q9cG0urqa70LijIy568merHJCATWHvPHpajQ2sPnY31jw==
X-Received: by 2002:a17:902:f20b:b0:1fc:5b41:bac9 with SMTP id d9443c01a7336-201ca1b1405mr6313885ad.7.1723482057826;
        Mon, 12 Aug 2024 10:00:57 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-200bb9feaa4sm40212725ad.213.2024.08.12.10.00.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Aug 2024 10:00:55 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 3/4] io_uring/kbuf: shrink nr_iovs/mode in struct buf_sel_arg
Date: Mon, 12 Aug 2024 10:55:26 -0600
Message-ID: <20240812170044.93133-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240812170044.93133-1-axboe@kernel.dk>
References: <20240812170044.93133-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

nr_iovs is capped at 1024, and mode only has a few low values. We can
safely make them u16, in preparation for adding a few more members.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/kbuf.h | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/io_uring/kbuf.h b/io_uring/kbuf.h
index 1d56092d9286..5625ff0e349d 100644
--- a/io_uring/kbuf.h
+++ b/io_uring/kbuf.h
@@ -59,8 +59,8 @@ struct buf_sel_arg {
 	struct iovec *iovs;
 	size_t out_len;
 	size_t max_len;
-	int nr_iovs;
-	int mode;
+	unsigned short nr_iovs;
+	unsigned short mode;
 };
 
 void __user *io_buffer_select(struct io_kiocb *req, size_t *len,
-- 
2.43.0


