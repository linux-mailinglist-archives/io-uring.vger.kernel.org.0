Return-Path: <io-uring+bounces-13256-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2LtwNzs3/mkroAAAu9opvQ
	(envelope-from <io-uring+bounces-13256-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 08 May 2026 21:19:23 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4F3F14FB083
	for <lists+io-uring@lfdr.de>; Fri, 08 May 2026 21:19:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id B373C3023D8E
	for <lists+io-uring@lfdr.de>; Fri,  8 May 2026 19:19:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F853376BD5;
	Fri,  8 May 2026 19:19:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="yPu5CdwU"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E9513321DC
	for <io-uring@vger.kernel.org>; Fri,  8 May 2026 19:19:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778267959; cv=none; b=pJgmm5FnrDqPTGYmpTBlX7fI25yCyE8NoE0lezoNjYMrUtSOCE5tBxs97LSDJ8VM5pGgNmmxNzwRIHSrHXFZpWBWA3KL3EclF+igQ3uT1r6HlCpj5aBQ3CGFY4TPTvTvQ7flaWzL7Vujq2GuYDpLUpOulu5m2cg59tU6XwKiEns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778267959; c=relaxed/simple;
	bh=24DFyDdTicQmBLTZ8+LRbY+KiUmR3EO7mV9uGd+Km6Q=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=iV4A61YOzgDKXL9YCZwc0rguktlTcPwM/0FD23JeX2qkdIApIBHpCIqy7UH1pRcqL6i9WGpOh3svlvtJi5W2pLZC40Yc1UQbJytveOof7GEpj5tpRyG/BE57XOtHaFENwz9CZf6qSwb+i3xLPfL6yjrYRrPIozGuAu6+RFI/Oh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=yPu5CdwU; arc=none smtp.client-ip=209.85.160.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-4042905015cso1818923fac.0
        for <io-uring@vger.kernel.org>; Fri, 08 May 2026 12:19:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1778267956; x=1778872756; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UImDyYCb6DVDK7Q3Nz3Zu113gv2Y6T+8KdZt1KRqTW8=;
        b=yPu5CdwUWRTBMTxxosLO9wsKgtMLSagVGrrYa+BxlRv0Eli1XjLquEZa6qC7in7Sti
         Ph69k37BAudbZXaVDTwzD6vOnU0P9ciFmN8KmLZXk3YbXD2LoYpz7j6BTWKnKJKKeIkt
         322wNsz0NZIosr92xyUnjhNTUNYVVfe0zeF2e1FIzFdY9Eew9eJJc+J6ZeZFOvpl+qjK
         c1XMIa40qtOS4jfV9DDUrSs2Xt+3GtzfFd0JuKZoFpVW1YH5lMP4LqaDr8PdXiUKyuJj
         73ethOUMzOWBIKt16Fp3kCcxNXP6D3QkWyCBnE73YxxVz/gIZeOE/gRq38ohrqWqGYa3
         el9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778267956; x=1778872756;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UImDyYCb6DVDK7Q3Nz3Zu113gv2Y6T+8KdZt1KRqTW8=;
        b=aJ3c+iBaH4PDWjgPNh9+VE53T/76W/Vyr11t+ugcksYc58T8ox+4+7BTUrOptrbher
         EyqGSDGtY2FsLUxhogf1Y7E5m4PUhhDjnZtPDCsVnap6AbF8x1k0yY8ROQFO6sRFiz1X
         GWt/L7iXPcdx1OZtNDG2c9DoBr0sIPNiYDzpNQX6+eYaA/ro2Oq9+h4wRQfB0PKIB0uC
         Dl2z9AmS3ePHK0eoVzWq+dv4X4ddcxpqQVH0NcIv8YPgJAkhfbJJVD866VO5POBXiDIF
         m5PaT6mvouLPBw+/034/OCf0dty0X+fMvVk0T1kDkhDfRGW8GspBllWu8KU/AcToptev
         d+Kw==
X-Gm-Message-State: AOJu0YxBQzicCDMvJwSiKBThPi6/4tM4Vl06mr8KgyfTwfjuM+1SyLBS
	Nh2ooJias8+yRpuBTAIDPIz8JVeDPJOsaTjma63YUHjfwaeO+rfYST/TlI/SalM6naNrftBAxfx
	2A95e
X-Gm-Gg: Acq92OFh7yujDX18y3WvGta7e25M6upZAVC/is5o9lEAv4zeiR46pNvJvMXS6GPGpuW
	ax7JF0KipWufOvA2u0gkMvrCp96RZW0/V/5mEAPYLA/HmNCEcQ6aI6N/16WQ9kLh5e1SxVkiRen
	zEN5SBsGcSmR1xpH0+aoV5nvS691Yv06N6qwv4Ur89C+S8E8W1iveoexZRiy5YGg9u/YIi+xIcl
	fWgmVGvu5Op0fzKtBTyPshym1DVXGZ1SmSZsVSXxd8FDWnqkFixpqJWRp28gRrcSid4NXPKzdGs
	4h5aOKUrycDka01N5gmLWktrHaoGu/MLbEHMsHRM4Z1FbumBgTMfXsvmOptJlAUMPJvhyJJwAW1
	e626vVxbllL6k5kOzWoMkQUGSq1SQRsQ0eAjXyv9xN9AJONe2hItjCqlxwFAza79bTKP2CnhsEn
	+eVOUD+dKMQuqUJOBPZITEU3nPbquGT60fXLpR28XUIUpHp4aq4Y2Bp0JLK4yMvbp3cizDanQnM
	ehbm8bc
X-Received: by 2002:a05:6871:c785:20b0:435:4b9b:828f with SMTP id 586e51a60fabf-4354b9b838emr2184077fac.2.1778267955770;
        Fri, 08 May 2026 12:19:15 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-435570ac625sm2541463fac.1.2026.05.08.12.19.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 May 2026 12:19:15 -0700 (PDT)
Message-ID: <db32ecb0-b37c-43b2-a8ab-cba6713b3e67@kernel.dk>
Date: Fri, 8 May 2026 13:19:14 -0600
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
Subject: [GIT PULL] io_uring fixes for 6.1-rc3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 4F3F14FB083
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	TAGGED_FROM(0.00)[bounces-13256-lists,io-uring=lfdr.de];
	TO_DN_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWO(0.00)[2];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MIME_TRACE(0.00)[0:+]
X-Rspamd-Action: no action

Hi Linus,

A few fixes for io_uring that should go into the current kernel release,
and will be heading to stable as well. This pull request contains:

- Ensure that the absolute timeouts for both the command side and the
  waiting side honor the callers time namespace.

- Ensure tracked NAPI entries are cleared at unregistration time, as
  the NAPI polling loop checks the list state rather than the general
  NAPI state. This can lead to NAPI polling even after unregistration
  has been done. If unregistered, all NAPI polling should be disabled.

- Fix for eventfd recursive invocation handling.

Please pull!


The following changes since commit 17666e2d7592c3e85260cafd3950121524acc2c5:

  io_uring/tw: serialize ctx->retry_llist with ->uring_lock (2026-04-30 06:57:20 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-7.1-20260508

for you to fetch changes up to 45d2b37a37ab98484693533496395c610a2cab96:

  io_uring/wait: honour caller's time namespace for IORING_ENTER_ABS_TIMER (2026-05-06 04:58:56 -0600)

----------------------------------------------------------------
io_uring-7.1-20260508

----------------------------------------------------------------
Maoyi Xie (2):
      io_uring/timeout: honour caller's time namespace for IORING_TIMEOUT_ABS
      io_uring/wait: honour caller's time namespace for IORING_ENTER_ABS_TIMER

Yufan Chen (2):
      io_uring/napi: clear tracked NAPI entries on unregister
      io_uring/eventfd: reset deferred signal state

 io_uring/eventfd.c |  1 +
 io_uring/napi.c    | 27 ++++++++++++++++++++-------
 io_uring/napi.h    |  8 +++++---
 io_uring/timeout.c | 35 ++++++++++++++++++++++-------------
 io_uring/wait.c    |  6 +++++-
 5 files changed, 53 insertions(+), 24 deletions(-)

-- 
Jens Axboe


