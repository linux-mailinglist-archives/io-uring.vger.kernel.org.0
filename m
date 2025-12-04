Return-Path: <io-uring+bounces-10968-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D4F99CA5945
	for <lists+io-uring@lfdr.de>; Thu, 04 Dec 2025 22:59:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 4E7963031E11
	for <lists+io-uring@lfdr.de>; Thu,  4 Dec 2025 21:59:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 237942D97AF;
	Thu,  4 Dec 2025 21:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="erRAX2Gr"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABC1D2D879F
	for <io-uring@vger.kernel.org>; Thu,  4 Dec 2025 21:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764885586; cv=none; b=PwTbr4VOwHkVq6MZRi6de61ZET58G7uySwogkAI82PdQ10/YBu3dz5cI23W9VF4zfjAq8nGMwEBunasHNeAssVnIqB0cEw08E3TtuXqzroK5F/lLsGtCSlpMc4PfNmT37MKs+iKN9xhkt3mWqwzSCJtV8ZaBaRG0zZdOPXzohw8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764885586; c=relaxed/simple;
	bh=pgMKPuh4PiBgD9NjJxaYFwbrDVFvBwZLYdTaKC9SfhA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=odKdSsZh39DXX0yPjbWi/v5sgNJL5z206fCXtwJqd4PF3bYpJk/03S7oC6RDmUuqpS1TbdokLK03XqufGx4zugMDsVuPWejcMbjXvJuMyC2TSIrN0HkC2gfA1PU51VfxrTJs9rOj5BNuRl/vV7ChpSulpu5CwVWmptlkt5Rv/Ew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=erRAX2Gr; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-29812589890so20376115ad.3
        for <io-uring@vger.kernel.org>; Thu, 04 Dec 2025 13:59:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764885584; x=1765490384; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=kqmAVcFv+UF6BfKOLJEBV0WQXJmHbcF07uzJ8zQGf9I=;
        b=erRAX2GrE+Nd/eTngvVLmlAa/CTSHivPdoubzM6a73WZVdN45ECoZdtovHfA5TLvGk
         JM471y1N5IjkMZOnjfTxTmb+WkabQ7m7Aw8ZuQgnVy8rhGMSPT/fSlVNL3zArNmyvlYl
         VBEBv6XLkwmwgFauAerDNz++cORGHmQjdYA+x+huy90tM09nlIqreJ8mH/Xz76ga4pV+
         0a7Nl+gpEzNSnxIdZ0iXzW3YQP9mOuGEKB3dIGm1l98ylsWytNA9X0VW+KQLGr3WmU3/
         SNKl4Ca6nFqTCGeIOZ1zDVd66hLtd5N7OZ4EMJsY7DJPgaHgJ3i34yDuwLqlB5855Fvh
         wXww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764885584; x=1765490384;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kqmAVcFv+UF6BfKOLJEBV0WQXJmHbcF07uzJ8zQGf9I=;
        b=V4fIWE+vq8nMJN/3Rg5KFwgMs74B/oT69UTMFdboY7s3TbkUC+1mxmqgxR+AyuMqg9
         a2b7vCus422dEENZLCu1fK0yOAZEM5uYTYg1IPsJbEMgZgoQWLiFPpkAcYHswtleEL0E
         v3uyWP2a9v5iLHkL6GQGveaFPg7KVKjDpLYv2f8ILQajyTvMrhgGiVSqJHl93uTDXH6l
         sE2LEAc+ayLROeOssBxF0WXw/EPdiiJFx0+AprtnVVj4aWvCCqerSrCyDC8ShNnVDMjh
         JiLkoNqqGTCmdMuEwyvmCk9inmfmwQanM7h7pHsN1k5uIavvchYNecy15kzc+YEXFJYo
         eEwA==
X-Gm-Message-State: AOJu0YxkFcz5OUS14ZMea5APowreKNv5XkbVNspT4fFsHcLyze96MIZX
	Jw9ZQ29p8au2D0puY0VzRfZbw1jXcJg12bjA+3DxFPp0+tnuat8fonFJBDbO2A==
X-Gm-Gg: ASbGnct616PmwHPGnzL3Zs4oup0AJIJBf7RNZOiS9g1Z4/V34kqNdZUV3JqddBm5GWU
	uvdh/vHXHnVKaInmTZyY5gOfaKdb/FIPSlhiPFaMLcxONMeWajSVREXiDfw+7gjBLFECBMG1a58
	V3Q+/i5stIDrexj7cxeDXHCNxU85HWFrt5wC/hTpe8ggkQN/rFni3n8Vh9EigzUVh3SY2lzSCBG
	ka4J3gOIc1wq/HK3wYTzh58j3NZV+nyfLcfclmwynzujEKGpV9mYg2MQG1qYKoYZ6K/nWCInWZx
	Hmt7MtCvRL2LI3MIMItExCixtONN9ROgPcywL6Sr6oKoLqywAHl2tFr6wyAZnaYNdVtYSVvpVpb
	Bb3rM7gKxtEKa/xJVb0RvK1lElRWZKWQpVeRLWpYaYElIXos/bj4PV3qQlp9rEcaAt0bzE4Rp+h
	82fI9XFoI327/bOxqI
X-Google-Smtp-Source: AGHT+IG2lKsXBlg+JVdGLgH0vOAzSidcC4FUdCEOuvkZ0uXNwMJXamu4LpmGW2qYPIG6n2uRLe5Pdg==
X-Received: by 2002:a17:903:2344:b0:297:f7fb:7b66 with SMTP id d9443c01a7336-29d684a9f44mr97912015ad.57.1764885584003;
        Thu, 04 Dec 2025 13:59:44 -0800 (PST)
Received: from localhost ([2a03:2880:ff:a::])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29daeaabf6asm28299925ad.84.2025.12.04.13.59.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 04 Dec 2025 13:59:43 -0800 (PST)
From: Joanne Koong <joannelkoong@gmail.com>
To: axboe@kernel.dk
Cc: io-uring@vger.kernel.org
Subject: [PATCH liburing v1] man/io_uring_clone_buffers.3: remove duplicate IORING_REGISTER_DST_REPLACE text
Date: Thu,  4 Dec 2025 13:59:31 -0800
Message-ID: <20251204215931.2825510-1-joannelkoong@gmail.com>
X-Mailer: git-send-email 2.47.3
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Remove accidentally duplicated IORING_REGISTER_DST_REPLACE description.

Fixes: 4c2dd9c29010 ("Add man page for io_uring_clone_buffers_offset()")
Signed-off-by: Joanne Koong <joannelkoong@gmail.com>
---
 man/io_uring_clone_buffers.3 | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/man/io_uring_clone_buffers.3 b/man/io_uring_clone_buffers.3
index 3f0a881b..4fd9c241 100644
--- a/man/io_uring_clone_buffers.3
+++ b/man/io_uring_clone_buffers.3
@@ -129,9 +129,6 @@ this flag.
 .B IORING_REGISTER_DST_REPLACE
 If set, cloning may happen for a destination ring that already has a buffer
 table assigned. In that case, existing nodes that overlap with the specified
-range will be released and replaced.IORING_REGISTER_DST_REPLACE
-If set, cloning may happen for a destination ring that already has a buffer
-table assigned. In that case, existing nodes that overlap with the specified
 range will be released and replaced.
 .PP
 
-- 
2.47.3


