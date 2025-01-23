Return-Path: <io-uring+bounces-6099-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id C1BCAA1A9CD
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 19:48:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 10818162EA5
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 18:48:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1A807152166;
	Thu, 23 Jan 2025 18:48:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="KR1pgTkh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F21C14BF87
	for <io-uring@vger.kernel.org>; Thu, 23 Jan 2025 18:47:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737658081; cv=none; b=bp/1e/g5+dqRmuEotlagl6q3PK4UuNAseRrZobWChIwF1Cx9f5fFx2Djfhk/ZHGJjsOoBA4Lo6nxmGjFae6NhH6V7yMMWe65O0llbAmwxdt+y8KOvwb5ZU97lt1G55II+PSORpu2Z4bTPrzuBgT4YH7iH10YRVasHwODdLqybpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737658081; c=relaxed/simple;
	bh=NGgj3t6lcIqvoRV32cDCWcZO/0zJhrbIgOMfIUt7RCw=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Gn7na6tOgpjV2CYAsdYHAk8l4RX0V4RFquq96dDoHU08sNwZrp30A4wS+OmiBuc0oQCG+oOafPYiDsXJqwH+D6OAarnHh1bLdXnPs7sQlJ4sRjk2l/Ie/VeThsgxqHfkjbdvJhmJ70n2U5NCoKUJB7oiPG57Zdwdiz8ThTs5770=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=KR1pgTkh; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-84cdacbc3dbso95052239f.2
        for <io-uring@vger.kernel.org>; Thu, 23 Jan 2025 10:47:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1737658077; x=1738262877; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Ch3lTdn6m6eAdxtJFYoj4J7T6BVHksNJH/vICXauenQ=;
        b=KR1pgTkhmJM+gkBgQlcNsbO35i+l6ye4slKbpbKtZOoGEApFVgSDi3dIDwiVwxEJZa
         574jsf0ar31Vt3Sq/+pbJnpXFQEgdrx4cz3mOxhvgCJ7ClZK64wd+7diT44WQAeDVATl
         clXSFnMLaPlJZx5N1uUeoGyC4hfpEQMR8aXKf+wU791ciSyMwCKNBFd/7NZxHp5VKFwt
         26DbKsMRaRQ7uMQL+d46ecMWxTHU5cKoPHgql+fY31Y+ZhtIg8F4YgPZA292f3Q1oqpl
         azp6nY+DVrJpnPGE5stEUEuALR+YVzPuhtB+pyMVxvlgXgQ9uMALcNA+uC/B3vhWPkVG
         iSTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737658077; x=1738262877;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ch3lTdn6m6eAdxtJFYoj4J7T6BVHksNJH/vICXauenQ=;
        b=JgOMfsfHMHe1sYjI+vYdrWWMUYJXXdVZBP4NjGYO8Bo6B/oyKol+NzSDgkWBQ0WATV
         RtWaauQ7IvJ0ZRowVwe7avopmK8AG3++bWtTmV+f2CyBfTifahLT6l//kkz6CqKx6dzx
         JKPOb1mrFyekm1QlZNdSprXfGnpuSnDugxGVeCQEDr5k2gD9u0zHlNfHAg1m3EKO5jZO
         SswQU8OLizWEzDGIXb+rsu+mBYhhogQopRJA3xsvixBpoZwCl1tocX6S6iZFLVvuQO1x
         5AcFrKzDavYd7pgLz4HdeAgZd/9rkA3gcvAm3z2TmHwNVZ2Wxyb1oY1CBii/UN5+oS1a
         doVg==
X-Gm-Message-State: AOJu0YxA9gnWbuhGkOLT8EZ9cAEF6vOsOoxZXyZT4dX4etTY8V6xMhg0
	rAtymlYmWd32VUeFkIIxKVcANNZp5hesJ+P0H4OoWFpV9KyM0hvREJ2LZAhqgO9tTuiM/ATmtIX
	4
X-Gm-Gg: ASbGncvLMCHuFvIhO0PycImicqdZTczndGWJAqeJ23obHY9kW+65n5etfBFWWIc43d7
	HGY2bpsKIjdH3bzcf5DhY5hZQODRCuhGYgpeUEfiUozzWIu0PlN6Mxmkxbik1EsAziz+Ih06/bp
	CZXVHXv8sZfTl/OkqthFE62BI7WQXhwzEfYY5ww1mIpnlKIu6JpdQgKKXbkuacJTWeCvALvFx32
	Fs/LbMlNlfWJEYGcO9hqC9EcBrSOgvDEuI3p8MBqfxw6ZQXOR/91gEQzDkHeFh6wDPy65RzLCNu
	siOTS+ay
X-Google-Smtp-Source: AGHT+IHg+lAb2Hhtx36syv8q7QFQd768a/eOJNNSdTL5qp5wH1z3VHt2nXKi9SiRNRVP9r64Nz7/zQ==
X-Received: by 2002:a05:6602:134c:b0:835:3ffe:fe31 with SMTP id ca18e2360f4ac-851b61cad45mr2505225339f.8.1737658076769;
        Thu, 23 Jan 2025 10:47:56 -0800 (PST)
Received: from localhost.localdomain ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ec1db6c4b0sm53432173.89.2025.01.23.10.47.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jan 2025 10:47:55 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Cc: krisman@suse.de
Subject: [PATCHSET v2 0/3] Cleanup alloc cache init_once handling
Date: Thu, 23 Jan 2025 11:45:24 -0700
Message-ID: <20250123184754.555270-1-axboe@kernel.dk>
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

Since v1:
- Make the iovec caching play nice with KASAN. We just free it now,
  as even basic KASAN will stomp on this memory. This should also fix
  the reported issue with KASAN_EXTRA_INFO and msghdr on the net side
  without needing KASAN changes.
- Cleanup the uring_cmd bits, we don't need to retain anything there.
- Use struct_group() for the rw and net bits.
- Add patch killing the _nocache() helper, just allow passing in a
  NULL cache for those two cases.

 include/linux/io_uring/cmd.h   |  2 +-
 include/linux/io_uring_types.h |  3 ++-
 io_uring/alloc_cache.h         | 43 +++++++++++++++++++++++++++-------
 io_uring/futex.c               |  4 ++--
 io_uring/io_uring.c            | 12 ++++++----
 io_uring/io_uring.h            | 21 +++++++----------
 io_uring/net.c                 | 28 +++++-----------------
 io_uring/net.h                 | 20 +++++++++-------
 io_uring/poll.c                |  2 +-
 io_uring/rw.c                  | 27 +++++----------------
 io_uring/rw.h                  | 27 ++++++++++++---------
 io_uring/timeout.c             |  2 +-
 io_uring/uring_cmd.c           | 17 ++++----------
 io_uring/waitid.c              |  2 +-
 14 files changed, 102 insertions(+), 108 deletions(-)


