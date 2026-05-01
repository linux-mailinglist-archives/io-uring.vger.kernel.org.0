Return-Path: <io-uring+bounces-13193-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id yZzxDLkG9Gmr9wEAu9opvQ
	(envelope-from <io-uring+bounces-13193-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 01 May 2026 03:49:45 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 705BA4A9B25
	for <lists+io-uring@lfdr.de>; Fri, 01 May 2026 03:49:44 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0A85C3011F06
	for <lists+io-uring@lfdr.de>; Fri,  1 May 2026 01:49:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E56D52248A0;
	Fri,  1 May 2026 01:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="iEk/KK7g"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5735740DFC5
	for <io-uring@vger.kernel.org>; Fri,  1 May 2026 01:49:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777600181; cv=none; b=E61huRQ7d2JUXI2GyB6JsT0w39ZX8GdqCYMYMlLlVQwJnb7NSTmxnY71gYkjd5SjExKKv0Htl/7gjUoDkazbu8i0uzcNHbhENgip04ZGlwjxfCIVQI9Yl9/iS+FhtSBWFCX95Y0vvc+CWXMkF5vbLfMxAow7UEACbhSSxmTN5e0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777600181; c=relaxed/simple;
	bh=IQt5lleTUlwvroO9La3/8yEAEzk74ZoQQUKcZKDzx/U=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:Content-Type; b=fwypeEiBKT6Z3LD7hmuTU9jkYYtybQvOiYqwdDACek02PxL6aS98E0lOTaO/t2+bVM9pT1aJGqF616dbw5UQvxjHlVIIYcEo/etgBj1+zZM3I8xjo2II/DeV9RZDJPh32UZXgGudH5CkcVl4f10IfBgWiGbUZ8o7iU3q6zVG6wQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=iEk/KK7g; arc=none smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7dd73b7c757so802208a34.0
        for <io-uring@vger.kernel.org>; Thu, 30 Apr 2026 18:49:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1777600178; x=1778204978; darn=vger.kernel.org;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J+BbghG3Czft79x+9kbRnZ08K62lMKtzjM1hOl999Us=;
        b=iEk/KK7gQJ8jLAcBDxHVoSu5u7u3f3vVs6gEZWF2cHnTlYHbEFRhjPUDmRtnVxRPT+
         MOll/DztjojRVTXE23WZi3WuB2d7xSljCd92KQXKYblM/2jEFU2OpSkqyPBrYgYgEH6/
         jEd3lFzIvqBXXYoFpJ6uy3uGm03uV05B4CO34Tis0grgJMeKvk6o8XNlc3AXv5IdYx4C
         EZoNtX8L9JaRVO/gQ0R9he1ybT9s2HmxKfBi4dCDTVpGRUPBxEkrAftoTuCEe1apGVWg
         /0D99hgRadSBhYBGLea6D8edjWGsG0NdbKuYUDzdY/DpKnJc7uBo8Mv1sgpeZr6NeZ/L
         7UAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777600178; x=1778204978;
        h=content-transfer-encoding:content-language:cc:to:subject:from
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=J+BbghG3Czft79x+9kbRnZ08K62lMKtzjM1hOl999Us=;
        b=L8KyUdtr+Spp6GPmqFRebM5t4tFNEUFan7Omrfa+S1vnWc4TalpUsJ8MYlu1V4m0jk
         /CtbMgiNRLouawFdojYtcWKn+5LHvTp690pIu9T2CXK845GY2EOR1nG6KCao9jaU54jm
         Zo+lYvXdC6nZLKPfJ/9bvWNsNbRDMYceI+yXySenLIJBBZaoxcC8aOKdfGDVB0zpSHnL
         /Ioo7PkPnaeY54r6G3SdzL7SrQu8kVxxdZd1Yuti+GOqqj46k1ZOfc54LElx5fvmntZ7
         qMRBnHGkFX1Uw60650BdoWCSihwLsBiRTEikkZXm9IpbFGwhwAjFIXuCMiyhwML60RVr
         Krrg==
X-Gm-Message-State: AOJu0YwMcG7zqL1KKhoc0FDhNjxMx2p3bTb/NkVbSfmnH2Sy3xjg4yDn
	v4D5NDOZBbn+4lEP60sL4MvuW1etT98R5u3qeZOLBVzMyWwRecW3L5RFwRxiUT2k4o2axoyJCHP
	ZPKlb
X-Gm-Gg: AeBDieuixm06vo5dfYCLF0MyB09I8LX+uw5R4NHR9SggCODiCbNvjl4ic/yZSba2UAK
	LqW020rC1nQC7GObO0u07gYcVRM7rSV/adwZCGvvniJJgYswYRVfRKkvZb6XbdyC4+n9Tzd+dhM
	DyIRuCkgcgEj6XYL3c7/NyLehHxuQQgAUy6Ir/6QtrmlVXVdusru8OpK3zc/xx4RWFFaI50w6/o
	AI7Vqs+AIMpON1HAJfbFW71JqA9Cy9loX2GInKKbL/MsuLfF+x0+K9YyjdgMZR3w+lPNKBY2N4i
	L+C/ulgzn0rs6NFkP+B3EnTs/uiL5wAoFmxJhLtaJKDomF8DOA3fBXPDucgtzlOcnzcmN7HBeH/
	YWGEROa2SLH6SgyVNmInhoZx7jlmaxp23bCmnF70TAlfe8gGdtMQdRy5J1WRh1eaCYxKK8LwhW8
	ctihGTFBFDVqoa0Xh6h88J9kpNwjjmRp9A4Gcg7N/OYE5bX3+X7JOIaLFy0awg0TKG/5RgWe3d1
	pUoffLUiWv51vY6PNSp
X-Received: by 2002:a05:6830:3881:b0:7d9:f50f:9693 with SMTP id 46e09a7af769-7ded0b55abbmr603537a34.23.1777600177956;
        Thu, 30 Apr 2026 18:49:37 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7deca7a9149sm1120036a34.1.2026.04.30.18.49.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Apr 2026 18:49:36 -0700 (PDT)
Message-ID: <8f3dd419-e06b-4b83-aaa4-7f7bafc098b4@kernel.dk>
Date: Thu, 30 Apr 2026 19:49:35 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Jens Axboe <axboe@kernel.dk>
Subject: [GIT PULL] io_uring fixes for 7.1-rc2
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: io-uring <io-uring@vger.kernel.org>
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 705BA4A9B25
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13193-lists,io-uring=lfdr.de];
	TO_DN_ALL(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,kernel-dk.20251104.gappssmtp.com:dkim]

Hi Linus,

Small batch of fixes for io_uring for the 7.1-rc2 kernel release. This
pull request contains:

- Remove dead struct io_buffer_list member.

- Fix for incrementally consumed buffers with recvmsg multishot, which
  requires a minimum value left in a buffer for any receive for the
  headers. If there's still a bit of buffer left but it's smaller than
  that value, then userspace will see a spurious -EFAULT returned in the
  CQE.

- Locking fix for the DEFER_TASKRUN retry list, which otherwise could
  race with fallback cancelations. If the task is exiting with task_work
  left in both the normal and retry list AND the exit cleanup races with
  the task running task work, then entries could either be doubly
  completed or lost.

- Cap NAPI busy poll timeout to something sane, to avoid syzbot running
  into excessive polling and triggering warnings around that.

Please pull!


The following changes since commit 254f49634ee16a731174d2ae34bc50bd5f45e731:

  Linux 7.1-rc1 (2026-04-26 14:19:00 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-7.1-20260430

for you to fetch changes up to 17666e2d7592c3e85260cafd3950121524acc2c5:

  io_uring/tw: serialize ctx->retry_llist with ->uring_lock (2026-04-30 06:57:20 -0600)

----------------------------------------------------------------
io_uring-7.1-20260430

----------------------------------------------------------------
Jens Axboe (3):
      io_uring/kbuf: kill dead struct io_buffer_list 'nr_entries' member
      io_uring/napi: cap busy_poll_to 10 msec
      io_uring/tw: serialize ctx->retry_llist with ->uring_lock

Martin Michaelis (1):
      io_uring/kbuf: support min length left for incremental buffers

 include/uapi/linux/io_uring.h |  3 ++-
 io_uring/kbuf.c               |  9 +++++++--
 io_uring/kbuf.h               |  8 +++++++-
 io_uring/napi.c               |  2 ++
 io_uring/tw.c                 | 12 +++++++++++-
 5 files changed, 29 insertions(+), 5 deletions(-)

-- 
Jens Axboe


