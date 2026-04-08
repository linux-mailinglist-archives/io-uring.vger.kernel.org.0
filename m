Return-Path: <io-uring+bounces-13002-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cPDeEBms1mmZHAgAu9opvQ
	(envelope-from <io-uring+bounces-13002-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 08 Apr 2026 21:27:21 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id B0CAA3C3017
	for <lists+io-uring@lfdr.de>; Wed, 08 Apr 2026 21:27:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 9D8BC30120D8
	for <lists+io-uring@lfdr.de>; Wed,  8 Apr 2026 19:27:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67BB63D9042;
	Wed,  8 Apr 2026 19:27:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="zgUJYNl3"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C85752652B0
	for <io-uring@vger.kernel.org>; Wed,  8 Apr 2026 19:27:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775676437; cv=none; b=tlaWVSPg2YcrrGzNN/MsEqvW/lZqSfcEfMdXIQLJE7hsmM+RsVQKM7SyYBdaLysSxBL6QfKQHfbqWpY1LNOCDS5csFFydlFvWyj7fx2x8Ldh2rOyoDEXJNWhRmoJlw+XgvuObj26mePtoCYuH52pxhHn3rnTUZE9zJnUvYAwWl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775676437; c=relaxed/simple;
	bh=kzbTZT4RWEgGOJozA7Eeh0AU3nOa1RoqmdLY69A8Abo=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=qetPBqfzcmDOx3aMMuFz/5KKrBvpx8p8EMM0gsMdPoHMScMd+00+nXS/uyi8x1ZkrM2b0AEYMq4R9ehn9r/s/nW/ciOgd7KXkjOhShzY11WLFHFGknSfZNXvgdXHfudOJSved3PCXVZR8YrW/Du9UpoNMUVwnFGFqt4G2j/7VYo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=zgUJYNl3; arc=none smtp.client-ip=209.85.210.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7d556c1a79eso157739a34.3
        for <io-uring@vger.kernel.org>; Wed, 08 Apr 2026 12:27:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1775676433; x=1776281233; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=67AAfsHiQbUbcThadP5OeelZ81z/JKgWwiz46f6Ael0=;
        b=zgUJYNl3WujuToHq+7g2P1pa90oodXBAo+IGURuBsS3wnj6N/gslOnbNscOWsohKh+
         byZuC/jGFYOgm7wFzb3Dt/40TVjmLJ2L+M/iBAhxXdFEcqrfG5ijQanRkAL0AP4pruPX
         ujEN19c9bTAJyOfPhMSUnOsZFI5uaCQPa5uaLWDhyw9XqXOECl9L3XbL4dgBOlF2gdTM
         xWaKxC2TYAQoBLw7K4H8JbNNnZ9tm2ZoXSwAypqUWzI3Rxo10VTGXMD5s5uSD4XfmgNk
         LaUv/dWSJ3VcyuGCh4fk5077zKa0ayZ2uSc5HUYPOaYjBG9FULzAFx/An1m9GQCgj8/N
         rbvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775676433; x=1776281233;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=67AAfsHiQbUbcThadP5OeelZ81z/JKgWwiz46f6Ael0=;
        b=TLEUN0bs6z+GZITMhBJlLoumMzGxxyEfrUbBGbicZKFy/6NFnywAaf+XVkdD2I23hR
         TbXsTg6wSu5NDMaLkuQnXOH7ja014m2e1+lvNREQVFZEtcqW5j3z7iss0WLZ62mtnwSY
         6oF+X6tKGP20iLdVq/1iAmflTQ7DUhsqh/Ua41UHzA53mj1d7p2M8Vysmxbm7gyx1bim
         H7z2GI94f5+VcVqwii2pWOk2vPzQhWBeS/YTxDUde8HauXNpivjOBRnmrxNynrGdBvRE
         4P2BkzhTPtvqX/6/RC0N9lxL7JGhHVDraybmBnMmsTAb8MuoEYEQM3OFpkhHs7Rtdryl
         8jKA==
X-Gm-Message-State: AOJu0YwUIeRtWSWgZKqpnWy87oQLSE7zKy75A/Jr86uFwtyrHDzbWlAP
	VeAgJJEaG0tXl0PWWvL3p2nfhFlEUCCC5AJjJLf7FsLE3Gb7pw4wA8+StJWElkJ4xlOVsmJRhr9
	kCBCv
X-Gm-Gg: AeBDiesHw4QjZeqLEcAiGSm0TYppoPJ2vFE98i3WrAlfJuyfG3PWk0n0nnVSbH4uQT7
	cebi/E2P5lNU7iKOMBL9HEgWGeZkKtmwPt7rovv9E9G58p5D2qlGJMM/gThDI5G+H62ZGkwR7S7
	6Fm3njg+ON2fgJUXAWniz5McJl3n3mW6udTHUQmelkWb+h68SBr/oUxKqYUi0mUGvy1hBQocdCt
	eKiLPzFuwP3BbDfMUjQW7i9dZu+b0+dETctS6+Sx1ebX2ZkLure6Zice8TtVHohJ8wWFaDMbW77
	pFbz96VlLMAZ/KIL4b+/VUbt7X1/1GI+KBITyDrSwfkobV7HiEdUT2TQw43P+zr2r1Invv4656Y
	hbUsMZ51Vmn+rMId5KSlv/9Ne3l8xu6jeloNk7Nf1lGib75kB5oo/4rhrt7BFK5Lb8lfNXDKiC2
	85KMXpS/vGDn39jr+BELnePQUkfboKW+Qv5cY3Lg+Nt+ia3aX6BkwY6RD4T4sOji51+XE=
X-Received: by 2002:a05:6830:4904:b0:7d7:ed69:81b2 with SMTP id 46e09a7af769-7dbb732e90dmr13882872a34.5.1775676433313;
        Wed, 08 Apr 2026 12:27:13 -0700 (PDT)
Received: from m2max ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7dbfc1cb79esm3359699a34.15.2026.04.08.12.27.12
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Apr 2026 12:27:12 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET for-next 0/2] tctx setup cleanups
Date: Wed,  8 Apr 2026 13:24:06 -0600
Message-ID: <20260408192711.396827-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [-0.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_ONE(0.00)[1];
	DMARC_NA(0.00)[kernel.dk];
	TAGGED_FROM(0.00)[bounces-13002-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-0.999];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[kernel.dk:mid,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: B0CAA3C3017
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hi,

It's a bit annoying how io_uring_alloc_task_context() automatically
assigns tsk->io_uring, when callers later may have paths that fail.
This is fine because task cleanup deals with whatever state that
->io_uring may be in, but it would be cleaner to have it either be
assigned if it's fully setup, or not assigned at all. These 2 patches
do that by having io_uring_alloc_task_context() return the context
rather than implicitly assigning it inside the task being passed. The
caller must instead assign it to the task, when any operation that can
fail has been completed.

No functional changes intended in this series, strictly a cleanup

 io_uring/sqpoll.c |  8 ++++-
 io_uring/tctx.c   | 77 +++++++++++++++++++++++++++++------------------
 io_uring/tctx.h   |  4 +--
 3 files changed, 57 insertions(+), 32 deletions(-)

-- 
Jens Axboe


