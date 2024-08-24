Return-Path: <io-uring+bounces-2946-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9122B95DEC0
	for <lists+io-uring@lfdr.de>; Sat, 24 Aug 2024 17:49:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 4EA6C282779
	for <lists+io-uring@lfdr.de>; Sat, 24 Aug 2024 15:49:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D15736124;
	Sat, 24 Aug 2024 15:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="Yp+EwLq4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA35329CEB
	for <io-uring@vger.kernel.org>; Sat, 24 Aug 2024 15:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724514576; cv=none; b=ZsC/Suvj9z/HbsiKbHdw/RIsTRnjrRbm572zGvA0RLCh5H+oGveSX4MEAFF1FszVWtRR4WNjcPDDE55zDOTShpf9YGl4dxkhXb/hMD241WCDRWSpbuAX5hsYatL9I0u6ac8aHZOh6Gj3fXBH95I5L9SisNAo9gtcmMqOQ2moVeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724514576; c=relaxed/simple;
	bh=wh1jEzXPfm0iuei0UWuNHfkN3+fMATH1KKsy4CZChpQ=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=Z+IZ1RZujz2VN/vW7WJLKDnV7dwG8VdT4WFkeaIKoji3Q717a8HfYHi1VLlC8ebdtQvMDvaP9F6WstV6ahBSK1nCIN8pcdHOJdMmI3qigXgxi8rWRD36WlpGht5qSKRDyf8PKSJaylKtcxjwtcy++KzX1zPEhsCN7sZnJlFW6ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=Yp+EwLq4; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-713edc53429so2318811b3a.2
        for <io-uring@vger.kernel.org>; Sat, 24 Aug 2024 08:49:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1724514573; x=1725119373; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=vExJ6yqx8gftEiKt+jPCxxJthpJjkkS1VaruwIWhdx8=;
        b=Yp+EwLq45c4YOhLEqZJxEcauqPnw6FA339/U1ebFBPThnm2LnLzb7BHUTBVTOhNFUg
         4z9xBCc1N+0kYMl+QKovZ5Rlzho0MJ8V+69+A8XDNlACf+FUHGfFV7KfZn8Ane+v/0v9
         3ZMkAWLeCBJan0X+rwayLAa6cPfS+MtwSyaL3ckfijOW1BqBcnZ5AxCpWIrZaI3D446d
         buTUW0F5MpWz/e1EjdSHzEqQIoprDxOtBE2uCpcxi8kIS9F8p8+LcqTjRzY3yzNbGy7A
         5RuYTG4wOW5RUhRi6yHoiXS+OSFx+x9Pb1vnmiVu6/dJWd+X2K7Hz8u7hfjywuM+WyN1
         5BTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1724514573; x=1725119373;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vExJ6yqx8gftEiKt+jPCxxJthpJjkkS1VaruwIWhdx8=;
        b=Q05vP1e5qkX1RP4v68J3FOiv0v1DAD03qkuJM0ZkILE1Zjl5j1pRZaeKVI6OjWNW9R
         haD1hRa13b4oLFvVpDqo/b0SD6fCp6PGUh/j5aXZq44l7tY0o1Xh/tT0B90aLd0ldSht
         kVFJpjD4gKNlT5+ZXReajyLkfY427jeSBEniDLSuU/g3JgXAgANqPgGg0r2TLlHpsnrg
         mDC0XM/NSeee8sytwksjAqFaSTajKwscP2KSJCHxDFscyye65cUkerPr212ES0n4ntBy
         UWFavFxigs9XCmvusfm5DFanATeen9vMNQEzwfPMJP1Zkx3s49DaxJOZycW7W2AtNJfU
         fcqA==
X-Gm-Message-State: AOJu0YwLS0oDQf9cTdSZ9oZnhZxHR8QR909jrUOJPAzEf7Un9JyOiU/Q
	4gXUtGJKNArH83CY6qu9h1ppPNuM0Lfkf7yllgBpTLmku2q3Cwe4CeqL5qUCj4zGhRyJFXGcLP0
	5
X-Google-Smtp-Source: AGHT+IGygNm9vIAjpECm+5/RImOQD9/xHwkSzFEuN3/vFmwgbqk5BqrwbNQpskjzI90OQeY0uTA3jQ==
X-Received: by 2002:a05:6a20:9e49:b0:1c2:8be2:1b48 with SMTP id adf61e73a8af0-1cc89d64d52mr6895196637.13.1724514572699;
        Sat, 24 Aug 2024 08:49:32 -0700 (PDT)
Received: from localhost.localdomain ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-714342e09c3sm4633925b3a.122.2024.08.24.08.49.31
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 24 Aug 2024 08:49:32 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET v2 0/3] Coalesce provided buffer segments
Date: Sat, 24 Aug 2024 09:46:57 -0600
Message-ID: <20240824154924.110619-1-axboe@kernel.dk>
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

Patch 1-2 are just basic prep patches, and patch 3 allows for actual
coalescing of segments. This is only enabled for bundles, as those are
the types of requests that process multiple buffers in a single
operation.

Patches are on top of current -git with the 6.12 changes pulled in, and
the partial buffer consumption patchset applied too.

 io_uring/kbuf.c | 71 ++++++++++++++++++++++++++++++++++++++++++-------
 io_uring/kbuf.h |  3 +++
 io_uring/net.c  | 55 +++++++++++++++++---------------------
 io_uring/net.h  |  1 +
 4 files changed, 89 insertions(+), 41 deletions(-)

Since v1:
- Rebase on current tree(s)

-- 
Jens Axboe


