Return-Path: <io-uring+bounces-8437-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id CB1ACAE11F4
	for <lists+io-uring@lfdr.de>; Fri, 20 Jun 2025 05:53:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5CC6919E242A
	for <lists+io-uring@lfdr.de>; Fri, 20 Jun 2025 03:54:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DE5581E0E0B;
	Fri, 20 Jun 2025 03:53:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="cPeTsnJl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419BB322E
	for <io-uring@vger.kernel.org>; Fri, 20 Jun 2025 03:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750391631; cv=none; b=lRimqHKW3NhvspN/2Kf6ZmEVZ5ksVzabk4O83Mn4WZ70T3Kh+e7BwxOHI+xhhkggxMQr2qWrsBu57ENXoq/iYpHP7exs5Jr7RWnb+ZLfTBn/RUgIhFTV0+rgRXdkF2myzMK3/MkQC4KY+H68/0G2a0iLUsLU3aNjoNkDl/a/v1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750391631; c=relaxed/simple;
	bh=qyBOuLF+0qvgiZeqrtUHPnUQaRZRDEl1+QSam83SF/g=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=bL6BrNRZ6ZVjFR97xwYNPap6NmS1smhdAwjEXI/5Q7u5vRytyDL0zJkpAPDjt72eE7ZfMn11fKCJ+NAedRFfPE+6ZOXCuZI00gGR6u6FvkE771T1Se2htcbit3Otw+Aw/v741QyOUi4IpL3z2F8pv0ahNRISsZnhHNQ+JG9fOww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=cPeTsnJl; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-3138e64b3fcso938304a91.2
        for <io-uring@vger.kernel.org>; Thu, 19 Jun 2025 20:53:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1750391625; x=1750996425; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WxJXd2d0muTrAuZNkOCXlXP0kZSepUw7CeMuAxtmayA=;
        b=cPeTsnJldLkBak6KY1E07+qHr12OqYBMqCyPCZL4NMYtkxcx3fhKYvdv1rXUxg2oDf
         s+KPZHiYIIb5wGwsEEDX8VNrbV5TJFVAf+Q4b8is7WTXmKX59QfXlFrHS+AlGTfK/Xto
         bxkOoj3xjH6WpGzR/5sHyFkc/Aft7Ln3omMGr0prchTTuRzN9caxGs4fbIHdFWrgNgAt
         FmOWxmA9iS6j7pHFqvhcx9KiqnI3VOMSGAQRCBYDmCx84ee3UWK4IBY140CEm8hDL5FH
         kQyKfHVesHKifnZD47MQj7ttUpiWVdh4ZkyQgS0G5StD9ziPgNc6PlYIK6w/2NjdSBkQ
         iMQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750391625; x=1750996425;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=WxJXd2d0muTrAuZNkOCXlXP0kZSepUw7CeMuAxtmayA=;
        b=fqIo4jMDQavV6iYcdeFsVfNYl+QmoD9Cz2/rNDBvOJxQHI5OoppoUehKpoMDnvlbNE
         QLXSSqtONXBDAqlsKR7HnpQov+Z3i/F0Hy4yI10weCpS4Up0cJtRcuMG+qyTrHw97mYr
         jQLwjpTmysdTP7jZ2RT1ZZX80J3Njk+eJtdwaIP5Pt4RrLEPlHL2IS90S/eXvhMxV1uz
         NpZLK8hJJb/pPwJIvuNMQ8eHsziTGTZlGmHawj6SsKkXoiT8vZW3nFSF+9iVykOOCak/
         kC5Qqd3YhA78MxuA+3iNtnrecReFGhX5g3y+BXvx+WGPVX47YveoKMYAQo0kqDgA/Nfa
         mbfQ==
X-Gm-Message-State: AOJu0YzeanT+Gd0mqgu8Qvlz5QsA3vV0y2cIlTQCv+YW6T4F60Yf7vIQ
	7G0WvU+Hi3EwGbblojmQzSc3KRSymWMl2y5BQOybSUCWlyA4j/mkEbQx466LV+e7k5lOQRpCBsp
	lthmB
X-Gm-Gg: ASbGncsceVQJyNWdlVYWOxsL7Tutg+k57S1HfRbecaovTpK357sYIWJSuocOgY0e83J
	JRMlr7wEJ86182Dzliv3F0yAMiFao77xrmkeQKqXJnUT4vQQ5CHfEUvn8eoJ/ft6I8KX8qb7Pqd
	Ijz6VjWIKnWj7KdwB1I/XEGFVjcChVZ4UhZyAVR0Cx0ZXaZ21G327y0k419MVa2z+/3AlUpUvCN
	stbob83Sec0TnXioGRyAJBMEDLY/WORvparphJ9Dlc1IjsLPK7GlA8TSmOQsMR92e1DEIc5oLU9
	hT/bmvaYQhH3dSrWRSbMtCV8qb/8IsJRt1KW1hNLKED4HqzIu7hPymDR3RvvkXbXOtjvR+r+hqs
	vZ1caAJ1t+hh/lknGQGUqX3XgMFvI6jaEBhcYano=
X-Google-Smtp-Source: AGHT+IH2EmPeD32YA2cbTrLBGgR6OSBz/hMIUXaeyzVGu380NVvQTGF03hTRL5hVVqL4gT2oLz+mtg==
X-Received: by 2002:a17:90b:3cc5:b0:312:e9d:3ff2 with SMTP id 98e67ed59e1d1-3159d626574mr2660949a91.7.1750391625403;
        Thu, 19 Jun 2025 20:53:45 -0700 (PDT)
Received: from [192.168.11.150] (157-131-30-234.fiber.static.sonic.net. [157.131.30.234])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3158a335460sm3169993a91.49.2025.06.19.20.53.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 19 Jun 2025 20:53:44 -0700 (PDT)
Message-ID: <c636df10-8b3f-4ab9-8117-fe99c379660d@kernel.dk>
Date: Thu, 19 Jun 2025 21:53:43 -0600
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
Subject: [GIT PULL] io_uring fixes for 6.16-rc3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

Set of fixes for io_uring that should go into the 6.16-rc3 kernel
release. This pull request contains:

- Two fixes for error injection failures. One fixes a task leak issue
  introduced in this merge window, the other an older issue with
  handling allocation of a mapped buffer.

- Fix for a syzbot issue that triggers a kmalloc warning on attempting
  an allocation that's too large.

- Fix for an error injection failure causing a double put of a task,
  introduced in this merge window.

Please pull!


The following changes since commit b62e0efd8a8571460d05922862a451855ebdf3c6:

  io_uring: run local task_work from ring exit IOPOLL reaping (2025-06-13 15:26:17 -0600)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.16-20250619

for you to fetch changes up to e1c75831f682eef0f68b35723437146ed86070b1:

  io_uring: fix potential page leak in io_sqe_buffer_register() (2025-06-18 05:09:46 -0600)

----------------------------------------------------------------
io_uring-6.16-20250619

----------------------------------------------------------------
Jens Axboe (3):
      io_uring/rsrc: validate buffer count with offset for cloning
      io_uring: remove duplicate io_uring_alloc_task_context() definition
      io_uring/sqpoll: don't put task_struct on tctx setup failure

Penglei Jiang (2):
      io_uring: fix task leak issue in io_wq_create()
      io_uring: fix potential page leak in io_sqe_buffer_register()

 io_uring/io-wq.c    | 4 +++-
 io_uring/io_uring.h | 2 --
 io_uring/rsrc.c     | 8 +++++---
 io_uring/sqpoll.c   | 6 ++----
 4 files changed, 10 insertions(+), 10 deletions(-)

-- 
Jens Axboe


