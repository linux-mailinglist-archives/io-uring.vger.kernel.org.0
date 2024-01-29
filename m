Return-Path: <io-uring+bounces-494-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AA86C841457
	for <lists+io-uring@lfdr.de>; Mon, 29 Jan 2024 21:31:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id DD0D91C2410B
	for <lists+io-uring@lfdr.de>; Mon, 29 Jan 2024 20:31:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5780312E78;
	Mon, 29 Jan 2024 20:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="PFCkibL7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8D5D53AA
	for <io-uring@vger.kernel.org>; Mon, 29 Jan 2024 20:30:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706560234; cv=none; b=GuGHXS1CuhBpHwgIpaD0Fun1LEIFRKCjoY5DwLrmrj90OlBvrt8nk+tC9Kgx6xLsHXokDQoq6j0D3uUrYaq1EN1YW2O6hkmdTfg3HfanS1loioHRTqPLtnHALgrMlB6c4j8ADMCQM7fmFgDIcGAK3I+xMQnjUfiCQVuQL3TzVhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706560234; c=relaxed/simple;
	bh=rtna5W2mngQDMY5fUo1xg7OtRajWoiov2CUKWbT6QYI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jukPja86roOyLHR9rNrByfSrOpStvl8ykchbVrOpjcYYQj/OYBX4ItfcEVVxZRv7aXTd9kkTWdTOdajMTpb+Xl0GmN5qjtPx9R5FPy6X6r/9DM29KjJxpD9V4NDT+lhphioL9QHJ/Pphl9/gu2BhZjuqH2YKw2dHsbckccvQgIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=PFCkibL7; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-7beeeb1ba87so49127939f.0
        for <io-uring@vger.kernel.org>; Mon, 29 Jan 2024 12:30:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1706560229; x=1707165029; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=UbwMv5LPvIYdmT3qQloO+hwxsGlCpbQZEopYn0536Ww=;
        b=PFCkibL7+QjKesCKxxLa15gYnRSRv4cCu4LaiABHlaw1Dn50dds0O5BBgUa9sdCCfT
         4NihsmDzqksOfoFzHx3uy3NsP0Z8BIpM6B+iaQMOB9UKVgf44G53L7wrQxOSQ3WciI7l
         ob0Zv4XlOZNeKDdhFEOTBopARknT7hQJH1uhmVvfvuST2hagSnKwCs7v+K8nEcSTFxkG
         9ydu7exQf/vmqo0VFJjkdRVIQPPccZuxRvCV5vkbBZ0qYD1muq87B4krhBpc1k0LVfsQ
         XBIfGegnxIU9xOOoYXro1K1d1RsC63OUJV+/qNIU6NASDkmQtJwTKKR6fjg3ZXjGguWW
         m2LA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706560229; x=1707165029;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UbwMv5LPvIYdmT3qQloO+hwxsGlCpbQZEopYn0536Ww=;
        b=RqeUvEs43tOFBRud55oBFyJeZSsIme+qMYbAwCsnIpPoT/61chW64iYdMyd1B35FGQ
         5uF+WucyG8uoKrrczEa48afaXzGDSyHnfWRhTYDHxYK+6urMrmTgPhot203hrNZejv3b
         veoHKLpuypjt50lQfKOKUTlegwsXMtCBdfuKec/ELZilHCjInuzxzBaoxfSsM2az9Wf4
         8JUhg6agU4mKpuCBbyvsFLVtuoEdqZf+uj0RbdtVR70qHuXahjlzTl/6iKvjHZIsB0nX
         ebVsv1E/R2T12bXaCe0NY17rYeZZb8/puchqLIQWzgWI98G+s7m0WFgIGbtBNuEHdntE
         AcZw==
X-Gm-Message-State: AOJu0YwoaPNnwoEJJcmTJ/Qa8J41WZ0CAlAZzEDvEbdBsTySVF6xCwCp
	L7N6LkZoqmQ0NdMIsdWaEJD69qfhS/SFm22VB0NBeZ+B4UK27zULS0p+UXpUk3WJMMAcRHfOfT7
	yICU=
X-Google-Smtp-Source: AGHT+IHBpunw9VFXBPzKkoTiOy1o3WcIsxxFSqJJSyunPmJYLFxF1EJ1BLN8p2B1lieF+RWJj84SCA==
X-Received: by 2002:a6b:f814:0:b0:7bf:4758:2a12 with SMTP id o20-20020a6bf814000000b007bf47582a12mr7197960ioh.0.1706560228818;
        Mon, 29 Jan 2024 12:30:28 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id i8-20020a05663815c800b0046e6a6482d2sm1952510jat.97.2024.01.29.12.30.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 29 Jan 2024 12:30:28 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [PATCHSET 0/4] Limit multishot receive retries
Date: Mon, 29 Jan 2024 13:23:43 -0700
Message-ID: <20240129203025.3214152-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

If we have multiple receive multishots pending and one/several/all of
the clients are flooding us with traffic, then we can retry each
multishot receive many times as we keep having data available. Some
quick testing here with 8 clients over a 10gbit link, I saw one client
do more than 32K retries. This causes an imbalance in how we serve
traffic like that, with the result being that each client will see
different throughput.

1-2 are just prep patches, no functional changes. Patch 3 doesn't do
anything by itself, but it enables the fix that is in patch 4. That
patch limits retries to 32, which should be enough to not cause any
extra overhead, while still allowing other clients to be processed
fairly.

 io_uring/io_uring.h |  8 +++++++-
 io_uring/net.c      | 49 ++++++++++++++++++++++++++++++++-------------
 io_uring/poll.c     | 49 ++++++++++++++++++++++++++-------------------
 3 files changed, 70 insertions(+), 36 deletions(-)

-- 
Jens Axboe


