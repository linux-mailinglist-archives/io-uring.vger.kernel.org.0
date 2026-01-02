Return-Path: <io-uring+bounces-11355-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 513EECEEF1D
	for <lists+io-uring@lfdr.de>; Fri, 02 Jan 2026 17:09:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 84DF4300F315
	for <lists+io-uring@lfdr.de>; Fri,  2 Jan 2026 16:09:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0342429E0F6;
	Fri,  2 Jan 2026 16:09:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="mbF+nEOQ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FD7E2BCF7F
	for <io-uring@vger.kernel.org>; Fri,  2 Jan 2026 16:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767370141; cv=none; b=evs78ohnoK2r7LR/OeCmo+IbbWZ6islFGNWModoGGoDA4JsCIG6oP+CsbhFxmJR4aQihhM4Z8AlbaIDeuNK9pJtw7m+H5UXnerbucjKdu3z/uf/R7zU78e3vabWPOf4rYGU3SgtOLdCD8B5cMTGnuF06wqpZZtA6z4QWAAhgjqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767370141; c=relaxed/simple;
	bh=d4Vs6L9tPEkB8hNEGD1LkzUzUFbkDy2DW2k/W5A//Kc=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=s1ZhkqwNIsKuLOPTt2vVsa4+GqTwM/EzyQAMY8u+iL9hqBONRPOVsQFz9uNGfj0/u+EumGu5GtRIlLZI0hQ5BnUtxumks52oh/2EEc6fZZliHG1A/h0MCwtrKTlk/6L5tR+0l4+3jCy9/kidXfsnqZyvdsUgJ4Qh5m3BYjrnujU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=mbF+nEOQ; arc=none smtp.client-ip=209.85.210.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-7c6e815310aso10188984a34.0
        for <io-uring@vger.kernel.org>; Fri, 02 Jan 2026 08:08:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1767370136; x=1767974936; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tA89VQLMcB1XL+TyYzJPNzCYX3cg/SZ/zMn9TSGHSlE=;
        b=mbF+nEOQsPoSQ8wl+fMszqFnpS7cPt0y2dsbEKjFksRUKOhNYCTVdHN5DVy5souzqM
         bnbAnC1KyXCF6guTiONlkNT+A+PyLmFN0v2Eitm8hGZsVjJv5UC3sW5Cdel2v5GJ6mMK
         Vxv+R3BhYDQDIQtvv71cqoyduj7o/z25gsvi9nrWdlCTbb2ZSAsgEiJ6gfLcXfgnTwjG
         h8Lp6GcwwN4RSe6aZZ0eECcD7JXLo+POJXgEZee9Hfr64wov5Ru7cej6CHI2ZhL1inZ5
         yVh2wpujA84KSqCOO8DK/7GqrllP+jVASR/93gdbHA3CASVHt+p8GlaXyPHfoGCbBDOP
         j6lA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767370136; x=1767974936;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=tA89VQLMcB1XL+TyYzJPNzCYX3cg/SZ/zMn9TSGHSlE=;
        b=KRJQqfrN6rGAql7eR36wbWwmX8xwgWIg5ot9ZSGLX4pkF2jgtv4YNETe/q/ky56TgF
         Ho4Dy0EdAbnJS+vAT75gL/cQDYtMI0E3cof9t3DR3V2SK+IoEYjq9Rtae+eughNw6KFl
         Ks4QIN9HSKSjK0hkv2VhjNXG7ZP3GnoAiBNSIV+MkNoX6LUFpOxPMCxcyLjwCiWGm6Ff
         OFmtwQTLpZfkgghDHc3rciFGhChn46bnDYFhdDYS02NGzJPit/oq4PY71OqO5wq60okj
         QGDGSIFJkiZeRDoq6Skvoi99ehXrMkpLKOZcdl44C+3Itx1+HyfRGb3BD5Xd18hOVakr
         XfCw==
X-Gm-Message-State: AOJu0YwM9oHxOsvXAkqjsutCPOK2/LGdKJ3FT5mBFEWcwfkd3ICBkNnY
	BpyZvIQn5abXapws0tdL3kKxQhkavPPLaFJeyNHo491jXHwdzx6H6FDzuP7lbbYLQ2XkZTbI+w6
	G5wX2
X-Gm-Gg: AY/fxX5cx+shNgaPIPejzXAD4CuLkAstp4O2q/GfkDeypz/ny+fJnaCEU7QHBdxoHeB
	6el2R8qr+K/Efcr8cKKs5zBt5xYUVeqELFGzKVoa6uosz5zkC8CgXRBdSIRU9FPzQse0vYjV5FF
	f9vyUkG0gg7DScVyGxGknBIZhJgEV0/jTKV3Dbv88J8MHzpg9k/JB3lGv5bzZWsEZYp4A1wPnUn
	xisS9qPYm8IJfKekbM+1SOeHYHFZRVhU/O34UJoxhS+IDanY2A77ggqLl4cl8RlvoqV2hfLPt9k
	cpMSkC3hV7MaD2UIYMZZ57NrNV+0S1mWMmPw0jpgifOo+B56etuiS3hA949iIWguOM2Fxw5/n04
	LNGxOWhaMGkywdsWSPQWE0xUFUH+FLR221Hy9D2NvOUCMpv6pRE6EqhaY7M5VgdHEapOjQGKXg9
	1fBNChsm+J
X-Google-Smtp-Source: AGHT+IElW4QvhKu4NjdT1lo2rCVr4faqrKZaFzW1qDds1us4dEtiQpGfdg1GyVTzIGSfIieU9vuOmA==
X-Received: by 2002:a05:6820:1517:b0:65f:1038:130a with SMTP id 006d021491bc7-65f10381463mr3312877eaf.69.1767370135948;
        Fri, 02 Jan 2026 08:08:55 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-65d0f723ab6sm25882099eaf.17.2026.01.02.08.08.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Jan 2026 08:08:55 -0800 (PST)
Message-ID: <787b104b-ffe0-47c7-9f8d-513847bcf6d3@kernel.dk>
Date: Fri, 2 Jan 2026 09:08:54 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: io-uring <io-uring@vger.kernel.org>
From: Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 6.19-rc4
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Happy New Year! Here are a few fixes for io_uring that should go into
the 6.19 kernel release. This pull request contains:

- Removed dead argument length for io_uring_validate_mmap_request()

- Use GFP_NOWAIT for overflow CQEs on legacy ring setups rather than
  GFP_ATOMIC, which makes it play nicer with memcg limits.

- Fix a potential circular locking issue with tctx node removal and
  exec based cancelations.

Please pull!


The following changes since commit b14fad555302a2104948feaff70503b64c80ac01:

  io_uring: fix filename leak in __io_openat_prep() (2025-12-25 07:58:33 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-6.19-20260102

for you to fetch changes up to 70eafc743016b1df73e00fd726ffedd44ce1bdd3:

  io_uring/memmap: drop unused sz param in io_uring_validate_mmap_request() (2026-01-01 08:16:48 -0700)

----------------------------------------------------------------
io_uring-6.19-20260102

----------------------------------------------------------------
Alexandre Negrel (1):
      io_uring: use GFP_NOWAIT for overflow CQEs on legacy rings

Caleb Sander Mateos (1):
      io_uring/memmap: drop unused sz param in io_uring_validate_mmap_request()

Jens Axboe (1):
      io_uring/tctx: add separate lock for list of tctx's in ctx

 include/linux/io_uring_types.h | 8 +++++++-
 io_uring/cancel.c              | 5 +++++
 io_uring/io_uring.c            | 7 ++++++-
 io_uring/memmap.c              | 9 ++++-----
 io_uring/register.c            | 2 ++
 io_uring/tctx.c                | 8 ++++----
 6 files changed, 28 insertions(+), 11 deletions(-)

-- 
Jens Axboe


