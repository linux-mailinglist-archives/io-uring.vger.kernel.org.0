Return-Path: <io-uring+bounces-5667-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DD03CA00EC6
	for <lists+io-uring@lfdr.de>; Fri,  3 Jan 2025 21:03:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 356C51881D8B
	for <lists+io-uring@lfdr.de>; Fri,  3 Jan 2025 20:03:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4294C185935;
	Fri,  3 Jan 2025 20:03:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="2MaVCNu5"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A53115573A
	for <io-uring@vger.kernel.org>; Fri,  3 Jan 2025 20:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735934620; cv=none; b=frj5ghKze2xgEkiyDXMq6Fyy2b0RY9uCEqj+vuG6PdZYAdIhyQ/TftcYkZQQ8G7wArNkA50ixSor0FUUhv1UeUlDxk+C3CpQwqfrEfoRfdENQmbq8hzChEPoRp3VbjyysbxN/2Xd0+qLsSIdhyxKYBLhLUG8F971tlTbO2zWiXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735934620; c=relaxed/simple;
	bh=/9U4/6Xb0pKD87QqfwjFaZ5CIVDpc9a5p20GqnH9oow=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=FJhK7WQWC03TgKa96ny/ry/ps6xego3d91uV0ot6T0ivoVakN3nGKHBbjQrcVZxCGZJaa1Eu/371NxTLMCP1pw4oRsUMs0gMXSoFU93F/nemhNSwjiiSMthB0kNweqRpxJu5XldHUc5SUTtzol8mDNHm0omAKkUA5IzH6TRsFLc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=2MaVCNu5; arc=none smtp.client-ip=209.85.214.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2166360285dso177298315ad.1
        for <io-uring@vger.kernel.org>; Fri, 03 Jan 2025 12:03:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1735934614; x=1736539414; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fz/eTbvMlzd3rn9m3wwEYE/i2JKGTiOnoPR4X/WWGok=;
        b=2MaVCNu5ll3/M66n2ytRuKPYW4s8YJIMt/8N+tIwLEFLWE9yCihoV40xtbCXTMy/3Q
         WUn5N/EhjqQkb9RaXk17JbsbtP/lHu51DYkwNy0YSVdeBGlxeHWrPEw9F8MzTWjX+08C
         BEdBW1HBOaWgpWyENfob0yq/EO+qQR4VSCIF/Su0T1uD1GrTvZ5M47UvnFbNwU8VLSza
         38p0kO7FpRiJDGOKRG+pSQHDUTCueEVgABtWMXMNEdlWZncR2wOc33bz3nXmcLMRxV8M
         symbD0KshNOla/eNypM0Xssl+MHytDBYPkrrNmBLM9cCSwhamoI3uoyM3BRYDkF23BOw
         8f8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735934614; x=1736539414;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=fz/eTbvMlzd3rn9m3wwEYE/i2JKGTiOnoPR4X/WWGok=;
        b=hWcNc1Rre1lgaFyGeL86OljvabP2fzFHA5/QMGnBaImPSuU0YJbgfS8l3eXU6Rpxkf
         iNvMTcpzoQ5tD6ilK+5XlLZtTeeqPhCVeedKidPN6eqhPdEmd9wdDC4SoJhpixEuN+U1
         ehRB2S6MziPxbk+QVKt5iLotLMnVEY6Zv/BqdzpHurDPS8dEWQAxPYDS2s/zrkON04la
         MhwX0FZPpeqSjCBoAYYU+8xCxp0rXMNlqxAKhnawSRf0D+I2SEft7Xc02ZnXKmg6XMbA
         z/bByyE+h8f3EzHLZXfZM2aCOKNOrt1//VwSM4pRcKKFaIpYWZRj8IDVqaaQxCLHwGOy
         4wgQ==
X-Gm-Message-State: AOJu0YzcyyMW79I0d2kdE6mrtvrluO645LtirHdFqSh9hkZL/URIUAsm
	Klpb0AgpfpIomkFiQ4jHEWhp4GqsE9CuDv/aBaRj4LbKJEnolP4kHx+eN/ovJzblLzmDz/4QEED
	R
X-Gm-Gg: ASbGncsKUp9DIySrq+wJqdb3QJz0WdpuxjdbR9dz1290akrNjzUUE8DzNXmBqwrG1y0
	xLIP22gnimnDv14Wy2Gr+2fYCae6uoiX49Aw2bUK0zvg6GBpF/Sse9b6aHG+oWv4+GE+/e3oiFE
	0XZnJM8NCeRa5MKYGkWRIrDseVSz8GF2uovu3UnqHvJFIgqJHUcDzqDD0zmVAI4Zo9m8HwWHg2r
	KpLNu2P4S0mJcJDE3Ew7UDZOzB7UuU8Pl3tMNlqgE83XYtDwsO2qA==
X-Google-Smtp-Source: AGHT+IHRgIha/bJYjFbl4qS647CbQwIby/dMfD4510wnZSGCRPnl1cf8qHhI4CT8Q6aQRFk2CPZmzw==
X-Received: by 2002:a05:6a20:431d:b0:1e1:bf3d:a190 with SMTP id adf61e73a8af0-1e5e080c83fmr75421208637.30.1735934614566;
        Fri, 03 Jan 2025 12:03:34 -0800 (PST)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72aad8309acsm26547659b3a.45.2025.01.03.12.03.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jan 2025 12:03:33 -0800 (PST)
Message-ID: <af2442f7-b26c-4584-a267-d0ca85580a92@kernel.dk>
Date: Fri, 3 Jan 2025 13:03:32 -0700
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
Subject: [GIT PULL] io_uring fixes for 6.13-rc6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi Linus,

A few fixes that should go into the 6.13-rc6 release, either fixing
regressions in this cycle, or headed to stable. This pull request
contains:

- Fix an issue with the read multishot support and posting of CQEs from
  io-wq context.

- Fix a regression introduced in this cycle, where making the timeout
  lock a raw one uncovered another locking dependency. As a result, move
  the timeout flushing outside of the timeout lock, punting them to a
  local list first.

- Fix use of an uninitialized variable in io_async_msghdr. Doesn't
  really matter functionally, but silences a valid KMSAN complaint that
  it's not always initialized.

- Fix use of incrementally provided buffers for read on non-pollable
  files, where the buffer always gets committed upfront. Unfortunately
  the buffer address isn't resolved first, so the read ends up using the
  updated rather than the current value.

Please pull!


The following changes since commit e33ac68e5e21ec1292490dfe061e75c0dbdd3bd4:

  io_uring/sqpoll: fix sqpoll error handling races (2024-12-26 10:02:40 -0700)

are available in the Git repository at:

  git://git.kernel.dk/linux.git tags/io_uring-6.13-20250103

for you to fetch changes up to ed123c948d06688d10f3b10a7bce1d6fbfd1ed07:

  io_uring/kbuf: use pre-committed buffer address for non-pollable file (2025-01-03 09:38:37 -0700)

----------------------------------------------------------------
io_uring-6.13-20250103

----------------------------------------------------------------
Jens Axboe (3):
      io_uring/timeout: flush timeouts outside of the timeout lock
      io_uring/net: always initialize kmsg->msg.msg_inq upfront
      io_uring/kbuf: use pre-committed buffer address for non-pollable file

Pavel Begunkov (1):
      io_uring/rw: fix downgraded mshot read

 io_uring/kbuf.c    |  4 +++-
 io_uring/net.c     |  1 +
 io_uring/rw.c      |  2 ++
 io_uring/timeout.c | 45 +++++++++++++++++++++++++++++++--------------
 4 files changed, 37 insertions(+), 15 deletions(-)

-- 
Jens Axboe


