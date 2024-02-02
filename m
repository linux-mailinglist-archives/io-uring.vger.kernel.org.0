Return-Path: <io-uring+bounces-515-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 198DE8472D5
	for <lists+io-uring@lfdr.de>; Fri,  2 Feb 2024 16:14:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id AD9AF1F2CF06
	for <lists+io-uring@lfdr.de>; Fri,  2 Feb 2024 15:14:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D9211474A9;
	Fri,  2 Feb 2024 15:13:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="PvKzQCY4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB906145B23
	for <io-uring@vger.kernel.org>; Fri,  2 Feb 2024 15:13:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706886826; cv=none; b=nlUjWP/cYO0xHyDn9nRfYM7l+o1FPb0tsbwSWEwY5AocZR8fiF8NFqPrzSWGZLwelZ8Oj89njuBQP4wI8hJLOjrBDNLP6BABVNJ7fiiqqFvbkbdgF1vtrLal9pm0cO+906nYBMaBG9ikhUO7a6vLTijg1E8F6Ttw1dBXltCuedY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706886826; c=relaxed/simple;
	bh=pxHskjfEEumtV/lUSeseT6myHcRPuw8/CU7T2UfrYh8=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=SujkPcg18SgBXp7YidngB0xUpR5MEsls06Kpo1fBa9hcD7StpvTs/iSOtGnJYb8P6jqDBVy4R6bGcMNIEEYb3KpnlNuGBTftIfCBLgORE2+qlCvpLCQZK7WdcbotdBKnsD51eBwx3NIGKsyBRgBo400yiz7bKEWNGFrtljd36Yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=PvKzQCY4; arc=none smtp.client-ip=209.85.166.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-7bff2f6080aso20680739f.1
        for <io-uring@vger.kernel.org>; Fri, 02 Feb 2024 07:13:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1706886820; x=1707491620; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fhVLkKT/RMNVdr7Qse18Vbg1LpZTKH/TSrUyUfKIQ8I=;
        b=PvKzQCY4r9rgXHepbu8cMPfCdHW04sOGWL5DVPrGgJJhTbOqmd/aGhymqI0u6U/5Xk
         g0i6Tusn1wq8JtMI/bh4rIbgalifzt+vqgb0M/raXvol/FBIm/dwhZCxuoAjZK1CGMEg
         wTa0XFH0d8pW26nE7uWHLro7NkHS9t0W/tdBcfXv7HB6VoowvPecllzYM7Ki8rChfbKg
         9yXirNYN+veNBhU/6iHcG19tyW61xxHNltc+8Wx052Oq4VEjt3p/H6pnHMw/Rm8U8jGB
         JcGlxfT+oTC851fQDvP9S372yTq+VxpCu0I6CMTE3wH0SD78ILgVb3ljZUejVJGEYtNd
         sTSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706886820; x=1707491620;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fhVLkKT/RMNVdr7Qse18Vbg1LpZTKH/TSrUyUfKIQ8I=;
        b=EYMSVhEHPRzTKBvi1RHvgWCEsDLtQ+Q2nWKSLYiNvXp+a8476SQPQEGVFJsUsF4+Ns
         iCVwY/QqHGrZRHqBuvft+Lb/e5Y/XbxfeyRalr4MnEr+iMpAu7ovZeI/LcNXchKF7kaZ
         m0uDQXjTWEFq+6retPcZjQU7XFNxsQavfq1Qpiay5Ttg53ID1ZM4NELTm0zdi4C5Iv/0
         EtY2Rg/BR2gudGCjT2Jm3vN6fTV6CXd7aRsVdvocP8LM+fqvfjG3TBBI5+1/n9zHcvBL
         sYLdZ4YbHY54AaTcxV5ajyOFSXOR5dwO0KzN4nNqFClpimIKOgLA2svfG4fLhZV7eyE9
         IWtw==
X-Gm-Message-State: AOJu0Yx++t9ItdmBvkfEQgibA23Yg3vMTKTApG/aoGs5mwDH1EpdLKgF
	an0hvGN6IQFAWYIYCmHVVCBFJqz8b7ereXPKsY2II4VSxu3fD+HMTgNy6NieXFGOc4iuq37Y40u
	gfOc=
X-Google-Smtp-Source: AGHT+IHCZunsMhP2KnPv8o9+1UlPzhgfDkgG1lS9e7IuUIPV92lIxe8Xb/zvz/l1TEBjb0GQoVfk5A==
X-Received: by 2002:a05:6602:886:b0:7bf:356b:7a96 with SMTP id f6-20020a056602088600b007bf356b7a96mr8194624ioz.2.1706886820433;
        Fri, 02 Feb 2024 07:13:40 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id j16-20020a02a690000000b0046eae1a6315sm504630jam.72.2024.02.02.07.13.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Feb 2024 07:13:39 -0800 (PST)
Message-ID: <fd1e8ec0-a2c1-4719-a493-479f1d695f66@kernel.dk>
Date: Fri, 2 Feb 2024 08:13:38 -0700
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
Subject: [GIT PULL] io_uring fixes for 6.8-rc3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Fixes that should go into the 6.8 kernel release, and targeted for
stable as well. There are three parts here:

- Fix for missing retry for read multishot. If we trigger the execution
  of it and there's more than one buffer to be read, then we don't
  always read more than the first one. As it's edge triggered, this can
  lead to stalls.

- Limit inline receive multishot retries for fairness reasons. If we
  have a very bursty socket receiving data, we still need to ensure we
  process other requests as well. This is really two minor cleanups,
  then adding a way for poll reissue to trigger a requeue, and then
  finally having multishot receive utilize that.

- Fix for a weird corner case for non-multishot receive with MSG_WAITALL,
  using provided buffers, and setting the length to zero (to let the
  buffer dictate the receive size).

Please pull!


The following changes since commit 16bae3e1377846734ec6b87eee459c0f3551692c:

  io_uring: enable audit and restrict cred override for IORING_OP_FIXED_FD_INSTALL (2024-01-23 15:25:14 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.8-2024-02-01

for you to fetch changes up to 72bd80252feeb3bef8724230ee15d9f7ab541c6e:

  io_uring/net: fix sr->len for IORING_OP_RECV with MSG_WAITALL and buffers (2024-02-01 06:42:36 -0700)

----------------------------------------------------------------
io_uring-6.8-2024-02-01

----------------------------------------------------------------
Jens Axboe (6):
      io_uring/rw: ensure poll based multishot read retries appropriately
      io_uring/poll: move poll execution helpers higher up
      io_uring/net: un-indent mshot retry path in io_recv_finish()
      io_uring/poll: add requeue return code from poll multishot handling
      io_uring/net: limit inline multishot retries
      io_uring/net: fix sr->len for IORING_OP_RECV with MSG_WAITALL and buffers

 io_uring/io_uring.h |  8 +++++++-
 io_uring/net.c      | 50 ++++++++++++++++++++++++++++++++++++--------------
 io_uring/poll.c     | 49 ++++++++++++++++++++++++++++---------------------
 io_uring/poll.h     |  9 +++++++++
 io_uring/rw.c       | 10 +++++++++-
 5 files changed, 89 insertions(+), 37 deletions(-)

-- 
Jens Axboe


