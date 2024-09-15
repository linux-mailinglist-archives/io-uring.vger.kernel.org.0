Return-Path: <io-uring+bounces-3190-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 7E4C797977C
	for <lists+io-uring@lfdr.de>; Sun, 15 Sep 2024 17:23:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B19B61C20C4F
	for <lists+io-uring@lfdr.de>; Sun, 15 Sep 2024 15:23:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 44DC41C8FA1;
	Sun, 15 Sep 2024 15:23:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="egTy+fCJ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE50C1BDCF
	for <io-uring@vger.kernel.org>; Sun, 15 Sep 2024 15:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726413803; cv=none; b=kgu+61fDPOY34iaC5H/syb/8MXXvOo2I2DdhM2abtSEVLfJN/KBqsJA4QwxcRhvGZvspP1t6gXBcHaYslKvSDgxT9rfgjmg7ne8LfyJzxK2DzR9cjcVhlc8YBMT9vM4sTmozt18J3WcPkK2PSUH0cA/zwtujkKGPJeMt6iLJSc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726413803; c=relaxed/simple;
	bh=cWyU2oCBINgeg/6z8gCusynHlQtji1xra/8B+1a6uWA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=rhhhVHxAoh0mN8o7mj5OZtOc1EyqMiRhkZnwLz9RcN7A1Y+daGD/Cl91vC7fHJXPCEAmu3X2tC6MbSjiOpUCrnCOR7zqvdhDNfim9ZyAbUVlJjyPZImaIovHj5jlenCTfrDXCb6K8SH8gIKXHCANIekzt3yoRbV6xY16QidxrEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=egTy+fCJ; arc=none smtp.client-ip=209.85.214.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2059112f0a7so21400835ad.3
        for <io-uring@vger.kernel.org>; Sun, 15 Sep 2024 08:23:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1726413799; x=1727018599; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=uhvaz0JLUiJoNY/KYzXAGWK5f7HAnmy5khsmGgx/aSw=;
        b=egTy+fCJmnpT2cyiZa/2RZP8ZPOVor1TA22umIQsKEK7SHALhPICP2LEgrZFIa+DCe
         s1BoRiE3YMkUiR9FTUe7YYdLcHRDq3/FhLYGWXqexqBaY2kDTmP8kxQFPJ46WpF2L05M
         rLL7/nqFSe+Pfc2r8eITOShJ2nDubYhDab5TGEb7ticovJK56V5lWmrTtmy3GuhsUl77
         ISRcLDlh4zTHtvaZloB//N0ZNwovDkQKaVZeqepQW7248e4AeKjWJAnVBllObmGmrSRa
         qFSU+vkVqv0ZrUyewYko9FRAJCHjhQzhhkBQMcr0aJzJRbGXVZVSpdMJslSlfejSIM7u
         uITA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726413799; x=1727018599;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uhvaz0JLUiJoNY/KYzXAGWK5f7HAnmy5khsmGgx/aSw=;
        b=ZwJdGRiZo3L6/pQiGWDrM2Y1kFDV+jbklPbvBn8whtqwBOEF2yZ/fx4uoWIJO9Pwuw
         6w3QsapwTZt+1ccXYJ9LltRxyE4bx8smv1ZkUqAZMlbY/QyX9lgAKprafjVPxUcivW81
         tWHsoUtWU3l78WkjrW+Lp83v3gORIvoSn68mTbD/IRWV9rC+twn65sru48OMFNfyYI0J
         GGfCHnhHOFqqaMFp/WUJUmc9m5qE49FrRO1xopgB4D3Zf0nXl2awBedV1fuqRTll25Ms
         96Rdwm2uJNCd5npBXspoOPSSS3P8uNTlniTV/+GeZrqT1VmbO/kmXTfHyBelx5ohTwwx
         qYVQ==
X-Gm-Message-State: AOJu0YyVUyV/NuCvK8zeZdZxgtK9pe00R5174j2Ss/pJComIUnVueE+1
	5mp2mbuQwzj8/JdTWasSrsSRk0dJCc5VT6gsRXLt5A0dNXo/ApI1wwD0t/Byz5UyUl8+iCS9vrn
	o
X-Google-Smtp-Source: AGHT+IHMFUo/rBJlR50UHaTUJooWDLsNALZGTBK5f8pHnTG6qfmlTpPuRFxv95g/mX9cInWpwq5i8w==
X-Received: by 2002:a17:903:444c:b0:206:8c18:a538 with SMTP id d9443c01a7336-20782a69a99mr112446865ad.32.1726413799211;
        Sun, 15 Sep 2024 08:23:19 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-207964a5ec4sm22083755ad.232.2024.09.15.08.23.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 15 Sep 2024 08:23:18 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: cliang01.li@samsung.com
Subject: [PATCHSET 0/2] Shrink io_mapped_ubuf size
Date: Sun, 15 Sep 2024 09:22:33 -0600
Message-ID: <20240915152315.821382-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

This shrinks it from (now) 48 bytes to 32 bytes. No ill effects observed
in terms of performance.

-- 
Jens Axboe


