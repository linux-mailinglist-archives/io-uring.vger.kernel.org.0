Return-Path: <io-uring+bounces-2710-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8CBC994F57D
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 19:00:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BF6911C210A3
	for <lists+io-uring@lfdr.de>; Mon, 12 Aug 2024 17:00:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D73CE1849CB;
	Mon, 12 Aug 2024 17:00:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="kJ0jj2Yq"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 445A71804F
	for <io-uring@vger.kernel.org>; Mon, 12 Aug 2024 17:00:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723482056; cv=none; b=Qpe7avHBl3wPDsn3GERyileNw3GBQqLofY6MdWCH6hj0SBMJOyRLIiOZTm21mPeNzc9sPvLSMfZGYkAX5zouXgStFxh6mwIpgOlbA9DUvbOGeaAcJd3dF++sYMxFb6+Jm+05MieFF9LxZgv/M+Eu9sKXSlwUsVst/7hZii+dp4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723482056; c=relaxed/simple;
	bh=na3FaLQLIsFkCR68QN/3DOFwPTygy3i0+LflvotQsO0=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=rRvlw9dSZHTPe85jw7Gyv9Pm0lHgkJgRNJXm2kEqyTEXL62AEI1q36hONHAOydXkAd6DDtI+DhpRa03cx2fBZc4ItB6NmeNJRgrOQMj5ylKgU58iIgMkC3sFzRDsjLcT6ZJTiWuZMNm4DmW8hcHAlqqagq0HhlrC8LrVLXPDvwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=kJ0jj2Yq; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-2cb4e1dca7aso914283a91.0
        for <io-uring@vger.kernel.org>; Mon, 12 Aug 2024 10:00:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1723482053; x=1724086853; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=CSABxR1m/3JJxYVrkGiHEYZZXl00OTbpg+I33Mqmn30=;
        b=kJ0jj2Yqt06XYRuxbUvlmQ8mKkFncKe5IZD8tnEN0hZ0OHtH7EjaAjhQZlETd3ts+E
         ZqcIMB1/Y1GZoA92Ui+G2pHtd6FhF709h+XCLxiRvNWSizf3QSSlEs2K8G0qbSgCHFxB
         7tCpf8YDQ5B7nP0lYPankQgZeK6kekSVnYZPuaRihhtEGd6LO2yfy70vZV6j5udVTSoh
         aWcc2zDp+l7kz92kf1FcgwYbNW3uCrVZ8yCZD/kgNIBEAs/lgZy5fRTKNn3KUbGDN+qj
         G4JaQDYV6bzK3hzWMK2GJSSvq+AV0VRs1EqFvy+OcjX80ZsPUtcCgqcsnOsath7XivMY
         n5AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723482053; x=1724086853;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CSABxR1m/3JJxYVrkGiHEYZZXl00OTbpg+I33Mqmn30=;
        b=jhNfxCQwvl+012h2q6kRr7UUOhgwVM0oxIMw5a7yDMBZjomiwVWOrolaFvuatdxx/c
         iqrlp96xwxs9GCzL2P2DW5b15+XTk1DD/hqV76bUCPQ9diDztdYfMuyl57LBJchyTh2z
         zw5s5usl5y78e7f9iNyaqV8tgglWYNiZHeHopFK4NiypgUBB9amTAWaztfRT/EMyopua
         oqsWQV2uXv8G1uSoLx6FCaQDmEMdKBQJ9eA8OjwXYC+qqWNzTnwEuNmXXRojOqDQNvz9
         /JRKy3LsDo2fXLRGAvFP935YVhI6GYe73d+Os47mNMy02+11EiYE9lJmdH7tMs607KUu
         FWFQ==
X-Gm-Message-State: AOJu0Yyr9cTslT9RHNHUdNwIxnQlX8hUq0KWvW47H21MtryKuJUFZKgu
	Hnz2crr5JrmDyMmeaJ7m+6i1aUw2bKHD/veR/EMupX7ceSivpj1PEadvQt3M2aCBcEVGVEcgw/b
	a
X-Google-Smtp-Source: AGHT+IGk+MbnN0qheDHwjxGYjE/h6jkgUM+mVrU7WcgYPgvt2Wc03F/Jzee+eV/+PXwifAfS9uPIhw==
X-Received: by 2002:a17:903:2451:b0:1fc:4377:afa5 with SMTP id d9443c01a7336-201ca1c6b1cmr6282495ad.9.1723482052337;
        Mon, 12 Aug 2024 10:00:52 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-200bb9feaa4sm40212725ad.213.2024.08.12.10.00.51
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Aug 2024 10:00:51 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET RFC 0/4] Coalesce provided buffer segments
Date: Mon, 12 Aug 2024 10:55:23 -0600
Message-ID: <20240812170044.93133-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

When selecting provided buffers for a send/recv for bundles, there's
no reason why the number of buffers selected is the same as the mapped
segments that will be passed to send/recv. If some (or all) of these
buffers are virtually contigious, then they can get collapsed into much
fewer segments. Sometimes even just a single segment. This avoids costly
iteration on the send/recv processing side.

The return value is the number of bytes sent/received, and the starting
buffer ID where the operation begun. This is again identical to how
bundles work, from the application point of view this doesn't change
anything in terms of how send/recv bundles are handled, hence this is
a transparent feature.

Patch 1-3 are just basic prep patches, and patch 4 allows for actual
coalescing of segments. This is only enabled for bundles, as those are
the types of requests that process multiple buffers in a single
operation.

Patches are on top of 6.11-rc3 with pending io_uring patches, as well
as the incremental buffer consumption patches [1] posted earlier today.

 io_uring/kbuf.c | 71 ++++++++++++++++++++++++++++++++++++++++++-------
 io_uring/kbuf.h |  7 +++--
 io_uring/net.c  | 55 +++++++++++++++++---------------------
 io_uring/net.h  |  1 +
 4 files changed, 91 insertions(+), 43 deletions(-)

-- 
Jens Axboe


