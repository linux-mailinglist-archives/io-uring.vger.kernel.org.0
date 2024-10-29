Return-Path: <io-uring+bounces-4106-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5727E9B4DB5
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 16:23:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 88EB81C22537
	for <lists+io-uring@lfdr.de>; Tue, 29 Oct 2024 15:23:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68BA2194A51;
	Tue, 29 Oct 2024 15:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="iglaf5zK"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB8631946B9
	for <io-uring@vger.kernel.org>; Tue, 29 Oct 2024 15:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730215390; cv=none; b=cWxfgG6oG12nYrnWtwD3A1cxTrd9g3zbn3LbEM3vZhM/RH9q+0qC9rs6ZEp3FUizt0YvwS00sUV3R/z+R+CWgmcs+qhZi6hoYEErx2ROQylN8UaDC7frdqnA73vH5a04Pk6bAWg+aRDVkRCZapZRgAqs0X6ocHsWBhssEF3eEIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730215390; c=relaxed/simple;
	bh=SYpQSxC5Dp9fLpjQdEWdmbvundwGSG12kF2zAC1HBac=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=opFkUgoC3IiAM/Vw98OtBCURxurrf9FfuwNB/7R72OpPQsLg1IZHCHLqvCP2VfWeH1XseklKPpo9BUyd+1pU/I/pQLBDnrRt/EmQRYG8G26RLevpRmnz3XeMgGw2RRjlPAqTIiHVb/oGWIsz8WFQojl7XcCYKINMMMjr4og7+tY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=iglaf5zK; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-83a9be2c028so207842039f.1
        for <io-uring@vger.kernel.org>; Tue, 29 Oct 2024 08:23:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1730215386; x=1730820186; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yp+EnMS7ATl15usRfPUg+8nUDFsAhh02UXOXNhYJd0A=;
        b=iglaf5zKAAZXNL8/03dh0l2Lg9bHnTNxLtvizY5NU8BUqipjE9GhVslzYkA3ZNBKLW
         iIzvs/IFcXXNJQSYmq8CeTZklwzURkQ1VTUSuMbosZ3MO1CcXsIrPvDy8/MQfPlZiaEf
         4jBZ/t91OjxA7b4F04fdSnV8ZG7M/GrSSw34VtiWKbZ085elcK5b0gv8HnE4BL9P5MCj
         hdXQxuBwtDLSEUSBkmOQVxz7JMLAkXfJl1Jvqte9qNlsw2DQf7jM1TJUuaoGPuh/fIUV
         SyeDBriJhX7I7+qui5AgNDwVQfRbLWNHzCDolreisdZ9kSoIEhH+bsrGJr4ZZpbN6v4W
         bEKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730215386; x=1730820186;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yp+EnMS7ATl15usRfPUg+8nUDFsAhh02UXOXNhYJd0A=;
        b=Wx976K/B9jjTFfKcQbKG+WsZfADpb8fKiTcONuiC9PEjBLHM9ULnWt/4vWBKkyI4HL
         /SrDxL8bwdFSwRZjvig6HsI5qv9PvwMsL2GC0KQlO2ZWn6TmykpH3d9TpbBcEEjw6zhj
         z3+uWRPNDj9/T/a9khw7L9Ry/wRStF5HCNh8q2dPv/8tmQcNTI5YfOWkiQrO3chriu79
         TZOsd+6QqbUC7aE4GVsJL1Lu6pbtrVEYJU6QlCrjDqm8bLC3eWzZNT2Q9nKDhl3BCsYP
         IjoBCqKxU9VbFiWitp3gOl6mI5wFr3KlcoPEKvVI2/3AWfqHEsmgP53XaNndIxcNBZi4
         RYcQ==
X-Gm-Message-State: AOJu0YyyL6ourRPflcy7Eg+q0c5RSg2FVdlVu340/E90NMGhwFP+UXMC
	P9xpvsh6Ad0Rkbi35NNc3bnGQy0Qq8+suHcugX3FMOejMVBjgABq2HW4db7znggjYzpnL8VzmZB
	M
X-Google-Smtp-Source: AGHT+IEJbLL+ZwSlC6u3psE6EB7tU0uLx8tQYij3QYs9qbBKvXX6vrCJ8E6TNppb40gqX1f+s3csmA==
X-Received: by 2002:a05:6602:2b01:b0:83a:b7e8:a684 with SMTP id ca18e2360f4ac-83b1c60b7d9mr1460896739f.11.1730215386535;
        Tue, 29 Oct 2024 08:23:06 -0700 (PDT)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4dc725eb58esm2434160173.27.2024.10.29.08.23.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Oct 2024 08:23:05 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 03/14] io_uring: specify freeptr usage for SLAB_TYPESAFE_BY_RCU io_kiocb cache
Date: Tue, 29 Oct 2024 09:16:32 -0600
Message-ID: <20241029152249.667290-4-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20241029152249.667290-1-axboe@kernel.dk>
References: <20241029152249.667290-1-axboe@kernel.dk>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Doesn't matter right now as there's still some bytes left for it, but
let's prepare for the io_kiocb potentially growing and add a specific
freeptr offset for it.

Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 io_uring/io_uring.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 2863b957e373..a09c67b38c1b 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -3846,6 +3846,8 @@ static int __init io_uring_init(void)
 	struct kmem_cache_args kmem_args = {
 		.useroffset = offsetof(struct io_kiocb, cmd.data),
 		.usersize = sizeof_field(struct io_kiocb, cmd.data),
+		.freeptr_offset = offsetof(struct io_kiocb, work),
+		.use_freeptr_offset = true,
 	};
 
 #define __BUILD_BUG_VERIFY_OFFSET_SIZE(stype, eoffset, esize, ename) do { \
-- 
2.45.2


