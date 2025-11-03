Return-Path: <io-uring+bounces-10333-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id B23E6C2DBC1
	for <lists+io-uring@lfdr.de>; Mon, 03 Nov 2025 19:51:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 5E8BA34BB7A
	for <lists+io-uring@lfdr.de>; Mon,  3 Nov 2025 18:51:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 238E7320397;
	Mon,  3 Nov 2025 18:49:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="3Z4y6v0Y"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEF013254BA
	for <io-uring@vger.kernel.org>; Mon,  3 Nov 2025 18:49:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762195789; cv=none; b=B65LYoswbTq1mRtNSK73+KEQPIV+scQynxYq9q9AW9hIMsJ/ZHDtPndjPmxXleB0NEZqcUCU3E9fVBk0oKlgb5c9CXfxydwH41ZIkPAxm/Y0PZ6mlPnRNVdnyEYKaOlykpdJgcwTQMJF5P3TDMnPTh7XUicZefDQOETvJHr2kak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762195789; c=relaxed/simple;
	bh=T0zY7jmf2xbqFlz4hpZtRW2U8hEu4zd9sULOxnqhamk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DAWMZ8zNlEfJTHMF2GqNgDYLjtr2sXtf36HYY8AYflhIccGzwWifZSC4+cSBnlogA/1+P6gjpk7x0QRxqkaSTbusMMjX21lpRsl+s+bmN2Bi4hk4pM1dspwcHAhlgZuoNlPqMNOCNC0czvqwcqa+tYpsPD3YS7MlhUeTvK4BPEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=3Z4y6v0Y; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-4332381ba9bso26357795ab.1
        for <io-uring@vger.kernel.org>; Mon, 03 Nov 2025 10:49:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1762195785; x=1762800585; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qadE+F4ryAC2VpbBnU6Dky70IOte0pAfwjWg7noRHR0=;
        b=3Z4y6v0Y/2WGDMxTM1hxeaF1PsnU5kZquvDD5rlqJiYzUTlIBSygbacZsUpWpIlZrW
         4hKCfyBwVLsL5TaWg1nG400M8oUSNQj83sHjz40kE97Gv/GWHXxIohdTTqlT45UnCD9N
         wH2I9/dKpCAwWqUA6/TMJjEWb9sEKuIBt2BoaUBPuBf0PShPx3rpXWDX7we8DpSgb1+b
         wgIbXPhX0Url4ujjHIUPXsGTLfFq3tNMldAz6b3TKZ+Cc8AVQ0KjmzvbFAlGVRMFRGHr
         OlgHNlKB5x/Xxa2aUVk6Lsje0VNV4db+vd/bcSURfQ7r0S8joxMQdESHTDgaxrt1M/Om
         2drw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762195785; x=1762800585;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qadE+F4ryAC2VpbBnU6Dky70IOte0pAfwjWg7noRHR0=;
        b=XQ0y8Rzo41qUCxrkEVq5r71sSa4+XjCi8eX1K97zGDRK8q1rwgiuFZguP0I+Q7ZulV
         ATk31GP5TpyxlHxF8RcTs3LGZncvTVB1nRagJYxg+qOx5nAufphqKDLxcWl8S7PPASkj
         /o/NDNqFI5V6BUUAcTQnSYqARPDetiB2k3uCXl06MJa3aVXYIxxuMnbLLSVE89E5c1e+
         Lm9kQk7ukzYP7K0T2V84QLn9XR6Vf9YghLW0MCpoY51+ZJWtTW2Xi79jRPx+QnR/i5oO
         DkHGwY+JpkS5G5z01X4CXbZARlDHwrZoeBFyCJLs2oXO5n4RDEduAKqtr1kvR53OR7yw
         4sQA==
X-Gm-Message-State: AOJu0Yz1TmfEs7WKBL2E/CTdyOWHooeGcNPYDTujOCt2QZ7kDJnMXixF
	CaR4NCz4VApwNZ3qxilMB/5J4Dd+U2CLaO78L9GFDw9zpAj5QbN+ayb9U3hhnLziVfsJn8JIJ7W
	LQ2XQ
X-Gm-Gg: ASbGnctZZ/M8jvwC5uWHK4ifqrfoU4+YOuebhO5+l/KUKxtZQq/S17/08KAuReh2+QH
	1g1Z0nwGcI5BC/HOpXLrARuYcJ0w0f6RniO1aYjFrs1en9sD65nxY/wg0EEj9ue8otzl1ch2/ib
	Raf8JptSl1SgiDMe7MphTKyHPuXlpMGSzzzFJqKtdNUgMPob27hkjhf5zyazPHQzy9t9VJ+/N+C
	lF3J/UHz0NvYvpz31gKcJhudmARJk0iDE4JlT2mTiN4e5Rj3PUKb4d5zTuedRy8NwsmD4QJkHRp
	MAoXqHdQQC6AXVSflSec9qZfzMQWwG9pd9R/kDOiiCUaMcMOn2LKpUlI11zHJg1+2eRTjS9ALkH
	7B37hWE/GpCAJDj9B/2Jn+4gBp1mav3mrDy8vcr4W9OzyknVgT0zeZRIQOGc=
X-Google-Smtp-Source: AGHT+IHpNgKODuDnGC4bcExW7YoCINOfpzHQ7HSYlRw5VRaNqQS8etlpxl2rpZMA4eMn4sRQSBnhgg==
X-Received: by 2002:a05:6e02:3802:b0:433:3487:ea1d with SMTP id e9e14a558f8ab-4333487eabamr25385655ab.7.1762195785573;
        Mon, 03 Nov 2025 10:49:45 -0800 (PST)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-43335a2224bsm4572985ab.0.2025.11.03.10.49.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Nov 2025 10:49:44 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4/6] io_uring/memmap: remove dead io_create_region_mmap_safe() declaration
Date: Mon,  3 Nov 2025 11:48:01 -0700
Message-ID: <20251103184937.61634-5-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251103184937.61634-1-axboe@kernel.dk>
References: <20251103184937.61634-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

No longer used and doesn't even exist, kill it from the memmap header
file.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/memmap.h | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/io_uring/memmap.h b/io_uring/memmap.h
index 58002976e0c3..f9e94458c01f 100644
--- a/io_uring/memmap.h
+++ b/io_uring/memmap.h
@@ -21,11 +21,6 @@ int io_create_region(struct io_ring_ctx *ctx, struct io_mapped_region *mr,
 		     struct io_uring_region_desc *reg,
 		     unsigned long mmap_offset);
 
-int io_create_region_mmap_safe(struct io_ring_ctx *ctx,
-				struct io_mapped_region *mr,
-				struct io_uring_region_desc *reg,
-				unsigned long mmap_offset);
-
 static inline void *io_region_get_ptr(struct io_mapped_region *mr)
 {
 	return mr->ptr;
-- 
2.51.0


