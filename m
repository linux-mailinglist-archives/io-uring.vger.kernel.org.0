Return-Path: <io-uring+bounces-6061-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0E8B0A1A5B2
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 15:23:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4969F167D0D
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 14:23:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D9F892101B5;
	Thu, 23 Jan 2025 14:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="E4Mhlg9e"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9469720F979
	for <io-uring@vger.kernel.org>; Thu, 23 Jan 2025 14:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737642190; cv=none; b=KimNk0IdNenuOsEsEehG83iKahgmNChJeYqgi1K3hXTEd/gGKU7oUvsGcQrtOtVFyVaTDMctWO2FaAvYtbWW3pfIvbYU61uhSjf1NLIMMIZEJHQPD+rTGGp5jDpByzgEGJId9iBDgkSwxsUfTYoqXJ1Q1zzdq3e9nMHMcg1vGzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737642190; c=relaxed/simple;
	bh=KdHiBkXQ0aJI+OHLsQDMGSvwWrU+ELavPhvJ0NK/XSA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=J5MmaqM9kAmmZo4ZeLqTC+vsgppo1Skc80ArMq2Wp3s17uWk2mpfDBdRAbQNEPD2/7CYN/XqTX4p+CkB+q4UTrLEQT0kN9xypd812kG6XgJ4F72n6T5z/59C90vvfm5axf7MHHxgzwU3UL73fpIlT+fs7Q93LIjsR3nwt4WvGk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=E4Mhlg9e; arc=none smtp.client-ip=209.85.166.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f54.google.com with SMTP id ca18e2360f4ac-844d555491eso24801439f.0
        for <io-uring@vger.kernel.org>; Thu, 23 Jan 2025 06:23:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1737642186; x=1738246986; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=we+mqtBVmTfKv77+GPbkPKxCgBSUVZYj6eHLyOH/ZG0=;
        b=E4Mhlg9eIQKL3EGT6DmdhrcMfUW+llSoVqvvysJDQk9wBbViUuetf6+45A8ZLrOR/N
         H5A/v928bzU0ku3zmCKiKGcCvLvA/tbgRlbhNi/MObsUX9r4xDokpE8C/EkoPgFdyJNM
         gAon9Xm9XkajGKKz0gLnVKC7hOgX/15X1/vgzC3SlkxRfvFM/ouY14qfRlIq/v+eWYsh
         eTYOQ+SlJgBhKPZ7eOCSPsHMkPc5aSRMFtryN9Dm2K5lkwBekuovbaZIgVSB3WOnYiHP
         d8bjldQGZaNmc2NdK67lh96MEJLmP07doqQ1AdVDrFCfsh7M8/U/dxGzFVc9rR8ng+4/
         /WNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737642186; x=1738246986;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=we+mqtBVmTfKv77+GPbkPKxCgBSUVZYj6eHLyOH/ZG0=;
        b=NDiOzXfy+ZE1qiRQSAYa723AXSrk1bzBmBKndJU8wqzP1hcYjOcAizUWOGHTsSwnAw
         naE/sPhzXnSpAKhwAIIkJPmNRQO6ZMvc3/uupbH6roKLx8/5CsSGp9dsO7kESpBI8t2h
         p4I5cPw36YWh5+8+B5ceD13Ta6hwKkzDO9hOJM4gX4UzBAZi2doUfs+g30NQqwYGbJuS
         u4Ei2Mx5DO0LmooSqE7h53QZYiklYlIbN3Rrb5gZlDCLSLO2UfMq+sXHI0YQb5YxzdIt
         D4vCWQ3u7i6ooUyFF3vLTRNQDxdjCFYqEi14wqTh7ei8wfz28Pl7ZYqnbX8miuLcMHBi
         Q76A==
X-Gm-Message-State: AOJu0YxqMH4SLLK/n9ZzigWP3E7fzT7BmCZCuvfYdrR+iIhokdhJuWjy
	UL7ZIRRXC14UDg4gnZh9lGTEdet91bH13kUAo7ydm4C6kv9hD7rFpiszQiTbzD9xFMuU8NIPvtr
	4
X-Gm-Gg: ASbGncsRQTfvkG53IwvlPCTOXwA/4falGxt/dHxzi/WCSbzAfZ/P8R2eNxuyOjB5aNi
	Z/tbCduqGghliogo0W2I82QKUiyXKbt6ZUWo2W/obatixXfFpI7oCDgZxTRQfXTfjotU53qsoFU
	5tjZm9bqVcTZy/DcUGymCN03Vjm+0hGfHHiq6qbF1LSgTff5Sj36Cre+LOyTg4rZluIdJff6Lpk
	hYbrMvxPLuWSlybEpQa1xSiEMQQ7uRLEEbh9FBTpxAxnm/POk4OAUAnHt4Lj2IZBy86SW2W2Aip
	Yk0QPi8D
X-Google-Smtp-Source: AGHT+IHdBFzrkt2+suqprVFpLG70uIWCF4F6Qcit0s3B2v6Rvoik//gpnZRTy+qZWfrPiNYuyBNaPw==
X-Received: by 2002:a05:6602:26d2:b0:84a:7906:eeb7 with SMTP id ca18e2360f4ac-851b60094eamr2419207839f.0.1737642186125;
        Thu, 23 Jan 2025 06:23:06 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-851b01f2690sm446847339f.18.2025.01.23.06.23.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2025 06:23:05 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: krisman@suse.de
Subject: [PATCHSET 0/2] Cleanup alloc cache init_once handling
Date: Thu, 23 Jan 2025 07:21:10 -0700
Message-ID: <20250123142301.409846-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.47.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

A minor prep patch cleaning up some confusion on types for uring_cmd,
which don't matter now, but will after patch 2. Patch 2 gets rid of
the init_once, and has the cache init functions pass in the number of
bytes to clear for a fresh allocation.

 include/linux/io_uring/cmd.h   |  3 ++-
 include/linux/io_uring_types.h |  3 ++-
 io_uring/alloc_cache.h         | 30 +++++++++++++++++++++---------
 io_uring/futex.c               |  4 ++--
 io_uring/io_uring.c            | 13 ++++++++-----
 io_uring/io_uring.h            |  5 ++---
 io_uring/net.c                 | 11 +----------
 io_uring/net.h                 |  7 +++++--
 io_uring/poll.c                |  2 +-
 io_uring/rw.c                  | 10 +---------
 io_uring/rw.h                  |  5 ++++-
 io_uring/uring_cmd.c           | 16 ++++------------
 12 files changed, 53 insertions(+), 56 deletions(-)

-- 
Jens Axboe


