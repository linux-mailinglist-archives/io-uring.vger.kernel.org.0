Return-Path: <io-uring+bounces-8384-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 07036ADCBE3
	for <lists+io-uring@lfdr.de>; Tue, 17 Jun 2025 14:49:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EAD4F3B3477
	for <lists+io-uring@lfdr.de>; Tue, 17 Jun 2025 12:49:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F07B028BABB;
	Tue, 17 Jun 2025 12:49:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="RP7WRx6f"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C12DA2DF3D1
	for <io-uring@vger.kernel.org>; Tue, 17 Jun 2025 12:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750164566; cv=none; b=M4N6bAWSMzro4E4R5qbkC502b7Ucn5UB7iYr/8zqBGStuP662A3AyagCba9bHR1OqP3u1voINeE+7xIPhiBEmgPLTGWfZlcwp82Bdnza5hQIHvMISvkLA+B2prQ0l6PLO0k1FQWMXt7FJSiqySzFSOrEmyYkpL4k2dIv07r2CpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750164566; c=relaxed/simple;
	bh=yYeLmN1AAcu7HLVPtIYkZaJupqv53gxMl3Zrk8WDO0U=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=KnDMOlwYrGckDzaJzFyQGJTFkQUj7lcd/oblLryek02tEWlEoF5tssuDRlu8o+0rRnY0kgIRiCTIIw/sTYOErLaXzflxMIXjhGZpxc7kVBGF7Q1v3wJA5gDlxQ3iJ2rn4yd44qQ4ni5tlOSKKmZ9CFxHgwtAZyWv0Mu+x9zsyvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=RP7WRx6f; arc=none smtp.client-ip=209.85.166.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f181.google.com with SMTP id e9e14a558f8ab-3dddbe5f8aaso19151595ab.0
        for <io-uring@vger.kernel.org>; Tue, 17 Jun 2025 05:49:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1750164563; x=1750769363; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZTUKU+gdyuck1LX3/3AfQOph8UH0D0nacN3dg+MhvH8=;
        b=RP7WRx6ffApkY3KoS5X+6maXlfGOGB7N1D/zLxz4MmFJHZcqZoAErzjPM1f/Hw14U/
         ZWYNWZ5Xvnnz5a3khoPtOY0uw4fi/SQ6+lIKyu5ARLx4OblDVR3R2MGgEG4WeHUyT+DR
         E/Vye42nYeS0i0bgp52tvDleWtq56xpTr/Y32DwpQv3gvIHQmNovbnhdzGqdA4jia0qj
         zWQdk6vEzYbyLtqlqzIgM5wlsg/cQYaNf/3VlhL0DHXq516U5OsiaPoWXPUFSPK+/y9y
         gKIeLL2l0RvK2RpiQZFLqTvMhiHNyDbySpMMUOJMhK3+2qbCkplnEGt3wnYcWnGW8aTU
         JWlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750164563; x=1750769363;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZTUKU+gdyuck1LX3/3AfQOph8UH0D0nacN3dg+MhvH8=;
        b=MQh0vGefVBlZ+4FY79DRgtG/Wz6vOfJC278VN0otlAaaZZYJcl8KtdWsYse/KgXus2
         9cDeov/zHJAQ+qGO70zkBkkHSHIlvuoKequKey4ObCYQ7xZgkqr7gyYUgi0vM31zNy6R
         720nbEwRPRusvXoF+FGNi5Hw1D7L+I2yo3JIa5hzE2RNOqteP9zXv2DT0ZgdG6nRxn87
         GE28BHlysJubEiMA+cFj7bHjjLdku4frtdHhHCcLJbnDhkuYP+d/5pZsaASQBuLx8Isw
         +WJWmAq0pG9WPbdbFj4SyM5fEymim0ABT30ok2tLMWQdLU/2qeZiOiVrW7D+LeniRu7o
         ivOw==
X-Gm-Message-State: AOJu0YyaQpqvpha+YH8TnOnxs877Klex05rFO6Dazbj/GMvr9ooayKH4
	QeS7lpROg5t6fFLTW6GhdoGJpYOZIFUt4ubIsklg1IfwKN/Q2ktyFj9tJg5KJwO9Ic7awGCMh2F
	r7XNg
X-Gm-Gg: ASbGnct/vULCd4P7Gu4rNOA4b10H/Jdpvv5/fqE+FumuDXbe1W7cfc01eGfzRPlG4Qp
	VKh2NIxbli7GDdGaiDBM86cMy7c7RBeEniknMDvfFr7n7DimSu1QxzYtR/GU28mn9gy+FpKO+qm
	2inbB/YRpbMbl6ob/v6ejuwFbnDy33l7Bo1l4/xswHeSLRx8Wt2Nn0mFE9wJJzqz2z9M7cLzdSh
	37+Up6AtxyzbJFk1PM9mkaxcuKedyBhuL40RpvsSGZokFP/ZWkzBFEFH55d3Eaft7oy3dYaGuAS
	BbcBXwDdiFw2k8WFX9HlpAIB6clISIu3Evow81SjekM19w==
X-Google-Smtp-Source: AGHT+IHiLbOtSYmpCGfgpMnD9Bc78BcW5VjXlCtyDTcG3b58H8AJQ8Do+WbY6oaIBa/eKMNEOAUxbw==
X-Received: by 2002:a05:6e02:1a03:b0:3dd:a0fc:1990 with SMTP id e9e14a558f8ab-3de22c2cc2amr29992315ab.3.1750164563439;
        Tue, 17 Jun 2025 05:49:23 -0700 (PDT)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50149c6c900sm2161057173.76.2025.06.17.05.49.22
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jun 2025 05:49:22 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET 0/2] Fix SQPOLL tctx allocation failure handling
Date: Tue, 17 Jun 2025 06:48:30 -0600
Message-ID: <20250617124920.1187544-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Just a basic prep patch cleaning up something I spotted while looking
at the report, and then patch 2 that fixes a recent regression due to
missing the sqpoll.c error handling.

-- 
Jens Axboe


