Return-Path: <io-uring+bounces-10538-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id E2DA5C524EF
	for <lists+io-uring@lfdr.de>; Wed, 12 Nov 2025 13:46:24 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DE688189EC77
	for <lists+io-uring@lfdr.de>; Wed, 12 Nov 2025 12:46:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 32B2E335078;
	Wed, 12 Nov 2025 12:46:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gae5H7Yv"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6366231326C
	for <io-uring@vger.kernel.org>; Wed, 12 Nov 2025 12:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762951579; cv=none; b=HpRKL8Kz0rotFvYZLvOc7vMLxtnymxlAtd32+4NypqSYAeJRWFfEI7PGZIffgg7WULRz/+KF0qRsZdBoKwNmBiCjswdfMo4oa5GDewUsBe2fbS1h3fWIsgB7Yum5qf7eujMIQVIRUANjORc/U2QP5Km805WWA14Qu0Ar2U4b8Lw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762951579; c=relaxed/simple;
	bh=aIXkAb35TkTrh3w5l4gq36CrEw3dlt96tFecJcsysNE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eqThFtOnH8SuWavUVyNRyhrPjiNN8DtiUFtPdkEd3ZpabRSmRHgUm39NGRQhfthJWDD+zCgWYJDLT1IbY6Du6YUDCs7OcS13mgUhRDWr3JDhG7oFYGqnjNBk/ItzKYWY70MFegmcUlXVHW69o0Vf3tQ52znjTLCBC9PL51j+LP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Gae5H7Yv; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-47721743fd0so4446565e9.2
        for <io-uring@vger.kernel.org>; Wed, 12 Nov 2025 04:46:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762951575; x=1763556375; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t7rt0Svbn62cTgrsUxA6zmqdwrpScybagqQx4Rbnggw=;
        b=Gae5H7Yv5G207RHMhXKLNG+VMP+Td/z/hqgNZg9tgEkg4TQinLyFsUdtvPRI/Awozn
         Y+Rkc5IYDgwlaZbIvqEdlpisvIZ85ODz1rE7W/vDJGqYcHkoggzbibcHKWe/ePrCkUA4
         BwOqz2wZwWlOlbo7kkKhEoWqoI3B+Quojll+H2haEFTe8SiyacJxNoWgRY9p4Mzy9wcj
         BarBZP+5h37y0D0ULlH3GqWR5q2MB8ifgNhE5tDYHys42Im0xHRizGAtEkP6gOhIkYK1
         Mzlfq/Eul5mCwO8Q6YEEzRGZn7qUj7KKCaz3XnHpbW3TWqvDBXKTCoEjCC+ILeYjclZj
         WAGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762951575; x=1763556375;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=t7rt0Svbn62cTgrsUxA6zmqdwrpScybagqQx4Rbnggw=;
        b=IR87Dknpn82j12KGOLCSa9FD2GT53zy/fC7jPFZE35y1A/iCaWSLXCwMYHDzJNY3ff
         je4EKlybDc88c3tbu/OUQj4ibBdN1L4rtCMMAKfpuE8Vpa/TNGQ56QV49SQee3TUL/Fe
         U3DOVmMJkawmVO2Z4d8e7Lv0gg1rny8wWNQYidtH5k//R/wUt81MdxTHh8EhLg7nFDe5
         pyDpTy8R5lcBnOC7M3DtZQlDsq619mmAI6Hcn7+2Qy8fdFa8d0sxyk/8QZ/X9Lw4j+Bn
         dEgvaPd/AzMiPecKi3MkhrGhx73vYwyhk9h0V35CGE/DI33j0+mlrkY3sSlyZhsbGiUI
         MsRg==
X-Gm-Message-State: AOJu0Yyk+cvGRXhM3Zd0NYaPmvhamcbCYBZJxpS8YV8ndFXcDQN/zq+i
	3WkyJr1MBLO8re8ZAaqup/8ScDMpFVK6l5Lod6r0qG1vv9Y5+97wGBEiQV+85A==
X-Gm-Gg: ASbGncvP+7dOMyUPK70R+eF2Ke3iZdUNGWc2bQR6L7+CeATeRE7lePbK6tsvAa6F3is
	CgEMTX9bp88EPk+9CEsygBblQigcp4Ito02PkJGoqj12tp9r08sfMFBo80uwz2eDCCQLRaeCvwJ
	TJZjpmM0ppailsMEbC8womrYefVMgzq49EW6VNkELUuEzqCV7nTJbrZ2tSeSX6Z6HhVrGvEHmm9
	kJTATJhWU4lgkO+22s3+olWZX0cf6eZBWrCSC7yZQTH7+RqWg9w0lJ2Phs1wMOhoJi+W95iFpqy
	UNxAQMEUxXiQyDSGkpCssEO+vt5Zxn4AEnlK3WxWv+QwbD6WaorIr+CRhdQad9NRqB19AKily5H
	Znl612ypCYpc2FAut5sIArTsfOkbFA+EHlqmKS5EBst7232xlIkoDeDtN540=
X-Google-Smtp-Source: AGHT+IFkmIQODRKUsG2jAEiID6auYxoF+/gGd67iZwP+6vqpV7IZI1afgFEP6WHsa2+QzYTFMzl0Ww==
X-Received: by 2002:a05:600c:1c02:b0:46e:4e6d:79f4 with SMTP id 5b1f17b1804b1-47787085b43mr30335615e9.15.1762951575305;
        Wed, 12 Nov 2025 04:46:15 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:2601])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47787e58501sm33846795e9.10.2025.11.12.04.46.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Nov 2025 04:46:14 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCH 2/7] io_uring: use size_add helpers for ring offsets
Date: Wed, 12 Nov 2025 12:45:54 +0000
Message-ID: <fb0ed7f3a2fea660a69b5d0ff26b3b089e20f7e6.1762947814.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <cover.1762947814.git.asml.silence@gmail.com>
References: <cover.1762947814.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Use size_add / size_mul set of functions for rings_size() calculations.
It's more consistent with struct_size(), and errors are preserved across
a series of calculations, so intermediate result checks can be omitted.

Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
---
 io_uring/io_uring.c | 18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index b37beb1cfefe..57ebba8ba46c 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2765,13 +2765,6 @@ unsigned long rings_size(unsigned int flags, unsigned int sq_entries,
 
 	*sq_offset = SIZE_MAX;
 
-	off = struct_size(rings, cqes, cq_entries);
-	if (off == SIZE_MAX)
-		return SIZE_MAX;
-	if (flags & IORING_SETUP_CQE32) {
-		if (check_shl_overflow(off, 1, &off))
-			return SIZE_MAX;
-	}
 	if (flags & IORING_SETUP_CQE_MIXED) {
 		if (cq_entries < 2)
 			return SIZE_MAX;
@@ -2781,6 +2774,12 @@ unsigned long rings_size(unsigned int flags, unsigned int sq_entries,
 			return SIZE_MAX;
 	}
 
+	off = struct_size(rings, cqes, cq_entries);
+	if (flags & IORING_SETUP_CQE32)
+		off = size_mul(off, 2);
+	if (off == SIZE_MAX)
+		return SIZE_MAX;
+
 #ifdef CONFIG_SMP
 	off = ALIGN(off, SMP_CACHE_BYTES);
 	if (off == 0)
@@ -2793,9 +2792,8 @@ unsigned long rings_size(unsigned int flags, unsigned int sq_entries,
 		*sq_offset = off;
 
 		sq_array_size = array_size(sizeof(u32), sq_entries);
-		if (sq_array_size == SIZE_MAX)
-			return SIZE_MAX;
-		if (check_add_overflow(off, sq_array_size, &off))
+		off = size_add(off, sq_array_size);
+		if (off == SIZE_MAX)
 			return SIZE_MAX;
 	}
 
-- 
2.49.0


