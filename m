Return-Path: <io-uring+bounces-5882-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4B597A12839
	for <lists+io-uring@lfdr.de>; Wed, 15 Jan 2025 17:08:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 81AFB3A8D18
	for <lists+io-uring@lfdr.de>; Wed, 15 Jan 2025 16:08:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37BA3158A1F;
	Wed, 15 Jan 2025 16:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="IsI+f8Xt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B69818B46A
	for <io-uring@vger.kernel.org>; Wed, 15 Jan 2025 16:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736957289; cv=none; b=GkVszr/oXoKNmuXOZSwlVhJ2jzMLOgij5rDTLza5p8WYJ7M7CxkBu4fc0VjzoMo5zpgp7kUXT+vzFP7xB9orqMfihv5hcInEEibMvZcpu92MjToHocfZ7f+pdC2U0cULbow1lieYcJ5JjA0o1qL4DgcLGzPXrVd5YARY0xEMwBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736957289; c=relaxed/simple;
	bh=UpY1bMUoBsijPrZfbM4e6EmD1CtD0aioocbGX9HqptQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=HG0CdvWM4FXdl9pJXddo6ngCTbaoKIJ+RRKdQXGtYr4HFuWNwEFEz5V7VZmxQDQTeO0ogxsLTrqhIU0RUw9uzYl7in/0uzKOW+5Ssu0rV1vSHWxRhGCZTy3LMWi5ewZWq/715oBFAyDmcaiUdKnTtDzrMUHmIt4jj4sGXfNOcLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=IsI+f8Xt; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-3a8f1c97ef1so20085265ab.2
        for <io-uring@vger.kernel.org>; Wed, 15 Jan 2025 08:08:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1736957286; x=1737562086; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hEkTgWz5L5HVhG/P1hVY8cXfXoWzs6EcAIg/bEFDvls=;
        b=IsI+f8Xtq1bt7908HpniO2VbwFUyqIsLuv671VGO7Uyk2HcqXOFmTX2wWNst5E7pAa
         ef571n8g5PgG5o1XnkUcut6hRMw4QCp4aqL1YD10aolECCVo7DZkGpUGoJmIvoGQJyPB
         1Y7Wq/xegD0R8rVN5noRQ+P+gbSe7PjSMBJL1ZQ3Z2a7qGnvnlJKWPvrzeZ/uR0x6G4C
         SGWWJZKB0F+bX29lnj9JrQ4MJwBTJlmFBLbnzrCntyINWCxx2XxisKAAdDuiX5k/eRYz
         uVVqaYlpKvhamp0PAx1fFfoenIi9M+6A90XxL7UpQQMmjmL7SDtM7BkvN7CtAMn+9DCw
         cXQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736957286; x=1737562086;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hEkTgWz5L5HVhG/P1hVY8cXfXoWzs6EcAIg/bEFDvls=;
        b=B1IW9Nlc7pX7ro8Je6JEJgkLl4RydAxtusteUTzZbuGW6WRsOV/4tgHkHgSEXWRCkK
         kgQGlc0Pr4MeAV36b69sVjqCbjCrt4dn8dkRLsnNTJO3TqarVpUePSFtHhArHkNKHcCI
         +2T59mFG37M/ZulFc7IorchSIgGZr+njNa7/MxdfRIzHBETRwO0XjsL/g0wMd73MUrQ6
         ZHweEsf/cYg2+O0oi6WtaNhKptsiCtTA/fDs3vV10PB/0HOA5TFnqoL+3fNLockvGjvK
         bqWlgSMTvGLqSexyoEvYtpyLVDAYLUQKpEg4g83VA/F+rG0y282AndUSFADFS5/UIG/w
         tc4Q==
X-Gm-Message-State: AOJu0YzhX6yK9YmHjaIP8mP26qDczGK6hLN5dzTIwrKDK4rtpi/26d08
	C8Y13lNnP9bHG/QHTjSLCN8GqFUtdXwhxpZmmOrq2XtP23MyQO0Y6GpojPq+gz/efeMBy6SxB1T
	N
X-Gm-Gg: ASbGncvdTxZfGKiesjhaHqJzL4FGc/J4XJTCVINMQ0vMu9eaAu9mp36yemReNu8LMl9
	nthD30UZcMVIJlta4A9toMvW90kZdN0+Z2cLA+aEKz27+WW9L2Wbau4R03PHkT1ljfh2GaFHcip
	N7nfafCnggRcxQLH9hDBCmlzKsyAf4uvGx4EAwhOW0pImp/9B1HjtiBUpOHNdSWKKklyr9uxQEW
	/ioqbZNZHlIx1+ocWTi7rJItaV/3O7iNcsFl313vVkOZOzF58ekSfcMGtgT
X-Google-Smtp-Source: AGHT+IHrDulgfPDmR61/fOP3YU2im2dyBD0MIr3i4FPRWqTpoOS0Y5qmaMuGYDdKakCva2rvtvHSDg==
X-Received: by 2002:a05:6e02:3a09:b0:3ce:78e5:d36d with SMTP id e9e14a558f8ab-3ce78e5d564mr83314735ab.12.1736957286194;
        Wed, 15 Jan 2025 08:08:06 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3ce860d324asm4548715ab.34.2025.01.15.08.08.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jan 2025 08:08:05 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: jannh@google.com
Subject: [PATCHSET 0/3] Ring resizing fixes
Date: Wed, 15 Jan 2025 09:06:00 -0700
Message-ID: <20250115160801.43369-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.47.1
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

A few fixes for the ring resizing that should go into 6.13. Note that
this doesn't impact other kernels, as the ring resizing was added in
this release.

Patch 1 fixes an issue with malicious userspace modifying the ring
memory while a resize operation is in progress. Patch 2 modifies the
shared memory reading to use read/write once, as is appropriate, and
finally patch 3 ensures the CQ/SQ ring heads are only read once and
that the validated value is used for the copies.

 io_uring/register.c | 52 +++++++++++++++++++++++++++------------------
 1 file changed, 31 insertions(+), 21 deletions(-)

-- 
Jens Axboe


