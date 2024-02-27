Return-Path: <io-uring+bounces-782-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 440F5869F64
	for <lists+io-uring@lfdr.de>; Tue, 27 Feb 2024 19:48:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id EA90E1F224A2
	for <lists+io-uring@lfdr.de>; Tue, 27 Feb 2024 18:48:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C24E54F8AB;
	Tue, 27 Feb 2024 18:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="fzsAJoz8"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E733550271
	for <io-uring@vger.kernel.org>; Tue, 27 Feb 2024 18:48:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709059733; cv=none; b=SnoPJK8KMCXXInWx38WIKjJQH977Sj4Va5jwDwv2dGxsDtrJmrcvlh/ocnvrKVOeFsLGogGOy9jkoT50Du2NT17KcZiKhexaYAfJYhJGLSrQoB/my63YOOTwvCPvjHWRwu2xKQYCxHG14OGRg9SyqSQxh9A8uwj3v3W7EmUJmv8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709059733; c=relaxed/simple;
	bh=q5iSyfpvhagPaEMGbvX1fbmGjLfuFszjE3dWu3zJHqo=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=MfkKqjQevjEJAe0tq4G4ddLYrQc1M/hKsI5x6nUimt745NxWazUoN4ata++o4tKyD9UwOa9Ef/y4tlZRPLLaztpgUxawF+t2E8t0M7Sc2BPO+qcIRKZrW2KypiNp16hq/YenjQsZ33SHZnm4i7+pSn3YwG/HkMr14Nz1esNp3tU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=fzsAJoz8; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-7c787eee137so53037539f.0
        for <io-uring@vger.kernel.org>; Tue, 27 Feb 2024 10:48:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1709059728; x=1709664528; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=3G8JI8S4dqusmXW5wsq5E/B9ww1UBnzEn038JZyKDek=;
        b=fzsAJoz8G1woOPizwvaHicAQ8M9eBqCeLHOvX8bgeeQyG3bkGlYXY0zSSpog3c+Mt8
         /wHapN5+UWhX5hjQMcTeusRLX6vvz/rpzyFTvMO5M+2qkXtcAhX5FA3Fec2qfhvbxeFZ
         NdLcFTXC2M1/p0lDQsxxo4HmpoLGfjcZtHqMPKwRuMWCckCS0Oj39HBgxU19KHVMX9Wf
         UZWrCzM1WpFiL5h01vrvbdmXOwPJAZvLAehxfcsz0nf19Zmy5pHN8M8ZPu+/Qzsabire
         7DtWWBanOJbBsdGAu7oHMi1AtXSZcCRMDFBswhRuLZSy/o94i23pNpHZh18XBUjw1fcz
         IGFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709059728; x=1709664528;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3G8JI8S4dqusmXW5wsq5E/B9ww1UBnzEn038JZyKDek=;
        b=IIuQeHedJfTDvEcmOddTfUM83ztznPkfLXXL7fsGoFnQdyXfzPqFKfiBmJIhGWugr6
         bCJtvmIeloRXrK7pgf0+OFtPzGZetJUADEdmgOZqEHlk2PC4QAw8hIeyOwylZgQRxXIB
         8V7BBeV5OyVK2AS5ECxRzmq3aEKDTaShJQ/vHtZSicgMpWE7RHQTElVfR9LKLuWRgF0U
         tdVHY1wvGX8RFfnbm8nSkZFhcdrJxRqKiaFQGk2dH4zB5AvF+yIonxGr72DZ4UvPnpGM
         XiCotqCRdYlQp2nqyVPULk33xQFrjKRIsM4LrezmTvupTBoj0C5jq6dHBQLkSAQOxx73
         65Kw==
X-Gm-Message-State: AOJu0YwlT8wmCZ6/Y30/s+YL37TrEn/ly7ZNJx7fEEeTyODKYhxfZDmv
	yA0NSayuHrFz8Ks/mWnj2YzjSKrFhbLYQZY2fmqWYGggqTQew7Tuje3JUpF6LayZUIRUftPJahh
	N
X-Google-Smtp-Source: AGHT+IHtMkNn7pS0b1xKFbs5yGLO+jjrwJHVyU/9WSBQgcwa1Uslnm64KtU79q6GkNaSleT99t/rjg==
X-Received: by 2002:a05:6e02:1d86:b0:363:b545:3a97 with SMTP id h6-20020a056e021d8600b00363b5453a97mr10288217ila.0.1709059728641;
        Tue, 27 Feb 2024 10:48:48 -0800 (PST)
Received: from localhost.localdomain ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id it2-20020a056a00458200b006e543b59587sm2282119pfb.126.2024.02.27.10.48.47
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Feb 2024 10:48:47 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET 0/3] Cleanup and improve sendmsg/recvmsg header handling
Date: Tue, 27 Feb 2024 11:46:29 -0700
Message-ID: <20240227184845.985268-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Been bugging me that I didn't like the v2 of the "improve the usercopy
for sendmsg/recvmsg" patch, so I re-did patch 1 here so that I could
do a prep patch (patch 2), and finally re-do the usercopy improvement
on top of that. Passes my testing, win is actually slightly larger
with this change (closer to 10%, so at least it didn't regress.

-- 
Jens Axboe


