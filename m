Return-Path: <io-uring+bounces-13138-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id wKDOAvqK62lBNwAAu9opvQ
	(envelope-from <io-uring+bounces-13138-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 24 Apr 2026 17:23:38 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F448460BDA
	for <lists+io-uring@lfdr.de>; Fri, 24 Apr 2026 17:23:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4EB6D302E3E6
	for <lists+io-uring@lfdr.de>; Fri, 24 Apr 2026 15:19:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08B9B2EDD62;
	Fri, 24 Apr 2026 15:19:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="J9q8++AD"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f176.google.com (mail-oi1-f176.google.com [209.85.167.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E55842E0412
	for <io-uring@vger.kernel.org>; Fri, 24 Apr 2026 15:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777043959; cv=none; b=PC/xsp/qzXI+GiIgpnDugJtvpBi9mIFykw+JEjASvd/Pd4uhCpkYPCSCt+WAiYzoIRHEjxnXDwV8x3uX4I7utzU9RwWDJt/62k+WciahWSaXiYih5Oyh36/vAm0/ZwMbfFZ56u28jzCdYconvQQfY2KZoAq6ZbXQhVEj5tn+YX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777043959; c=relaxed/simple;
	bh=k/3Hvd3kP6M0Y9RJTulLzIyOoWrK4QLAgv/paa0Ggdk=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=Yw+WpbsRgNdq0yild8cMuoLpnYrSG38lOP8dQgsXaX1IUjB4iJ9hrlRCXThVeXmeSgLiVF5ynR/pV8F6x1nL2x0F+HEQn4fJvpKUgRensEuWQf4pPDf4L1ewCL161VDD34MjWo8lyLWLTNyVx5aQHhLY+R306UStjcA3yWdRO1E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=J9q8++AD; arc=none smtp.client-ip=209.85.167.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f176.google.com with SMTP id 5614622812f47-479fc1fc048so2523986b6e.1
        for <io-uring@vger.kernel.org>; Fri, 24 Apr 2026 08:19:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1777043956; x=1777648756; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lOgv/EGH8zBUeO0wf7e0ZUZVIdFoVwN6TiEtEnrFZNs=;
        b=J9q8++ADOTxU5n6aSE1dp5peVsaCY6V4NinhYH8OkFaFY42/6Vc5ccVSDEOfyupPv3
         5KUdrd1hjP0bZ9ryDG4zmd+rQPz3H1FcMdL51VvykRkHKFm/T87g5aVRhcJBkozYnY84
         sWI68VPu6K/c9mW4bi4cadRzXo6cIwqlnN/cKLCwm2lYvWpiL9qgukWhCAL+v15squt7
         kQvxpujJ5tMtM7SHL6d7dmKVL36Iqw5wplRO0U/LPsMUkcHqx1L6AM30ZLXImSJUrAYN
         yMFbm4eI3k7ge2n5wSKK4eOw2/DOIJEXhjc54e26lD8iekC8nNHZtjDM2nQQk0qGhtmX
         vdug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777043956; x=1777648756;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lOgv/EGH8zBUeO0wf7e0ZUZVIdFoVwN6TiEtEnrFZNs=;
        b=WP5P25iMhBwr4mSm/tkexRceBTmne07J7+lO6vdXme3/MG4gCG3loVu0vY+u6newtI
         QxeAPHBsBmpljc+HiZ31sQF9b47Bz6Et/ExkS8d6QSrDuhDnIEQSUnQFETnRf7gPStdX
         15hM9OkSY0TbKmXEPOxTvMEDu3MQCEUPx3ySldL4Oor6+8GCyA/nQ24VyWxXGGNHxjLJ
         /tHx4gzUvxJ2IaIbMg74eBYPuXgG5wrgkxtsWKap7hp/Fje3ahcD8deaIasFpbHKFyAC
         qZT8f2n/oGZAk4hIlVwvS0H4YEdxoP2yAunaVknovZ8wu5JUUIe23IJzb8RRqrOyHcIk
         kQMw==
X-Gm-Message-State: AOJu0YzbRMnMR2dcNWUp82vnOgUDA2WR70tma8xhXU2NxWeKiu4d3fhJ
	TbLk3sxbycaY0X2zVZxwhNKu64TbfFCL/3mtRT9ll1KwMuHtekaDRqmrJb3LWgYZ8KPsDwSsqC4
	jYTtcPqo=
X-Gm-Gg: AeBDiesqpZc2rVmvHHB7Mw/DfxdAuCClGDR5i0jqBCR1P3Jp0MWMaEMHpeQ+q8c4TJJ
	O6N94fWqprSykyVPlYWHtziyydVJgcrDdQKtbXKZFqqCvUYOCZKBIgdeEJMrmp5QwEdTLg7BwbX
	mK4mJ3+lJrMNdbLN2+i5i3DMlx1D8iot2WtwQ6KPI2AzuVR3jdsCHmZ0HnDQcbRPUHPqnz7OeCi
	ROsLvZxQLnHNiZ1aqtKD2FU8S1Gl3WI7wdUqlXehEXRypIFRGBzxuphN3IXvIlzO+LMC4wRn71P
	GOmeXbIQfktHmOG5Djx0PRcMlIloguERnw8K+RwiNzVlGau1/htvA/gc3nrxG0JJbWbCDTH7gJg
	ZOyz7KiM4rBWkhTbw+FLil/vM2SvTQsmdJ3ROHVkjFeWF9cBTnY9JtWUiUKlx9sXrmti4V6bqnO
	SDqJg2lqfg6gnCLT+TbdP7qGee9tPk1f+zddIMNOWBrzxK30DHuT8lM1FTnMWLTYfywr2l5r+nL
	6es+Q/1Ip6AVW3wpgs=
X-Received: by 2002:a05:6808:4fec:b0:467:112e:4590 with SMTP id 5614622812f47-4799cb31b57mr17927929b6e.46.1777043956244;
        Fri, 24 Apr 2026 08:19:16 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4799ff07f5dsm15213772b6e.6.2026.04.24.08.19.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Apr 2026 08:19:15 -0700 (PDT)
Message-ID: <9897da58-1661-4bd8-80d3-0e6708b8c0d7@kernel.dk>
Date: Fri, 24 Apr 2026 09:19:14 -0600
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
Subject: [GIT PULL] io_uring fixes for 7.1-rc1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6F448460BDA
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13138-lists,io-uring=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,kernel.dk:mid]

Hi Linus,

Set of fixes and cleanups for io_uring queued up for the 7.1 kernel
release. This pull request contains:

- Fix for a NOMMU bug with io_uring, where NOMMU doesn't grab page refs
  at mmap time. NOMMU also has entirely broken FOLL_PIN support, yet
  here we are.

- A few fixes covering minor issues introduced in this merge window.

- data race annotation to shut up KCSAN for when io-wq limits are
  applied.

- A nospec addition for direct descriptor file updating. Rest of the
  direct descriptor path already had this, but for some reason the
  update did not. Now they are all the same.

- Various minor defensive changes that claude identified and suggested
  terrible fixes for, turned into actually useful cleanups.
	- Use kvfree() for the imu cache. These can come from kmalloc or
	  vmalloc depending on size, but the in-cache ones are capped
	  where it's always kmalloc based. Change to kvfree() in the
	  cleanup path, making future changes unlikely to mess that up.
	- Negative kbuf consumption lengths. Can't happen right now, but
	  cqe->res is used directly, which if other codes changes could
	  then be an error value.

- Fix for an issue with the futex code, where partial wakes on a
  vectored fuxes would potentially wake the same futex twice, rather
  than move on to the next one. This could confuse an application as it
  would've expected the next futex to have been woken.

- Fix for a bug with ring resizing, where SQEs or CQEs might not have
  been copied correctly if large SQEs or CQEs are used in the ring.
  Application side issue, where SQEs or CQEs might have been lost during
  resize.

- Fix for a bug where EPOLL_URING_WAKE might have been lost, causing a
  multishot poll to not be terminated when it's nested, like it should
  have been.

- Fix for an issue with signed comparison of poll references for the
  slow path.

- Fix for a user struct UAF in the zcrx code.

- Two minor zcrx cleanups.

Please pull!


The following changes since commit 5bdb4078e1efba9650c03753616866192d680718:

  Merge tag 'sched_ext-for-7.1' of git://git.kernel.org/pub/scm/linux/kernel/git/tj/sched_ext (2026-04-15 10:54:24 -0700)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-7.1-20260424

for you to fetch changes up to d0be8884f56b0b800cd8966e37ce23417cd5044e:

  io_uring: take page references for NOMMU pbuf_ring mmaps (2026-04-21 20:14:39 -0600)

----------------------------------------------------------------
io_uring-7.1-20260424

----------------------------------------------------------------
Greg Kroah-Hartman (1):
      io_uring: take page references for NOMMU pbuf_ring mmaps

Jens Axboe (10):
      io_uring/tctx: check for setup tctx->io_wq before teardown
      io_uring/tctx: mark io_wq as exiting before error path teardown
      io_uring: fix iowq_limits data race in tctx node addition
      io_uring: fix spurious fput in registered ring path
      io_uring/rsrc: unify nospec indexing for direct descriptors
      io_uring/rsrc: use kvfree() for the imu cache
      io_uring/rw: add defensive hardening for negative kbuf lengths
      io_uring/futex: ensure partial wakes are appropriately dequeued
      io_uring/register: fix ring resizing with mixed/large SQEs/CQEs
      io_uring/poll: ensure EPOLL_ONESHOT is propagated for EPOLL_URING_WAKE

Longxuan Yu (1):
      io_uring/poll: fix signed comparison in io_poll_get_ownership()

Pavel Begunkov (3):
      io_uring/zcrx: fix user_struct uaf
      io_uring/zcrx: clear RQ headers on init
      io_uring/zcrx: warn on freelist violations

 io_uring/alloc_cache.h |  2 +-
 io_uring/futex.c       |  4 +++-
 io_uring/io_uring.c    |  3 ++-
 io_uring/memmap.c      | 46 +++++++++++++++++++++++++++++++++++++++++++++-
 io_uring/poll.c        |  6 ++++--
 io_uring/register.c    | 36 ++++++++++++++++++++++++++++--------
 io_uring/rsrc.c        |  5 ++++-
 io_uring/rsrc.h        |  9 +++++++--
 io_uring/rw.c          |  4 ++--
 io_uring/tctx.c        | 15 +++++++++++----
 io_uring/zcrx.c        |  5 ++++-
 11 files changed, 111 insertions(+), 24 deletions(-)

-- 
Jens Axboe


