Return-Path: <io-uring+bounces-13928-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id 3RbMCOfGUWrFIgMAu9opvQ
	(envelope-from <io-uring+bounces-13928-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 06:30:31 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 151D17404EE
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 06:30:30 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=W2WcagQ3;
	dmarc=none;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13928-lists+io-uring=lfdr.de@vger.kernel.org" designates 104.64.211.4 as permitted sender) smtp.mailfrom="io-uring+bounces-13928-lists+io-uring=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 30F7C3006905
	for <lists+io-uring@lfdr.de>; Sat, 11 Jul 2026 04:30:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D80812AD35;
	Sat, 11 Jul 2026 04:30:24 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B31621F63D9
	for <io-uring@vger.kernel.org>; Sat, 11 Jul 2026 04:30:21 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783744224; cv=none; b=lpIfZj/RS7myXeBPmcXaO+80ThWvIWp4ONll9S8yKFlS3Xkf6VdjVF03WkrNNT01lpMZKh+IX0ubU1VZVV9mf52A1fFgJMgr/X5lG3bKH2e6AKetJLh5WMVWZggOqssjvzQ0/sQbdhABIhnVTjsgqImqvB6jdsaRnctbvFUDItw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783744224; c=relaxed/simple;
	bh=x2MxhJAYeqACIBZOUB9VKaDCTa0j00RodqQczoULHk0=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=Y3slI7fH3UvB2e/kdC3keIu2lID2029npeXKa86Cz1kRvTGDXZcF5/FHKcyP6cFaudFfcuBEEJsRRgg825Ep5dleLnUEc7qu/1zv4Aagw9uoQX1Hs509vCvhjS8a6HDA862JqjR+ANOu7jobWp81vrIpBqeRJvT8Ylo7kFyiyQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=W2WcagQ3; arc=none smtp.client-ip=209.85.167.171
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-4877a7b451dso918455b6e.0
        for <io-uring@vger.kernel.org>; Fri, 10 Jul 2026 21:30:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1783744220; x=1784349020; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:subject:from:cc:to
         :content-language:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=jMUFIDW6wUgaXgTSImjpJWfat5OKRo3RBCqmlAElAbM=;
        b=W2WcagQ3oULTcS/AoC6Zmfq0ox3sfZCOEAVIoKRGxXHSqYGQdtUoD3pJvZ3V3g9giN
         1N7eR9xJMAQAdhqoyAzOAw7+ti83ZaCMNx7FsSQBaFKUdExxlAAkghDKXZ33BLV4AfGT
         Y3YItbtsxi+Egfwe06DPmAa5nLccYT4MHNTY86EfW8VVMuz9Eemz+jsYi/xLgbvB0tCg
         VUqeOP18pMHN9hPhNEucwhLbuziNm/AvkeVgUFZEhW15b0LnXN72Tlfv2HBbACzqG7iT
         VsvwzKu3GPF1y7gwtEGq4XPuDLiiDebEMJKFv1ic2yW8FYtOkrFbhGwGYY+7+cjAKYC4
         4SPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783744220; x=1784349020;
        h=content-transfer-encoding:content-type:subject:from:cc:to
         :content-language:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=jMUFIDW6wUgaXgTSImjpJWfat5OKRo3RBCqmlAElAbM=;
        b=hFOy0xrG0A8CRsiXJSfKK4CrX85w0aWWcoX9tTAWROSTEeqDMriF+PXtCu9eTlGQN3
         N/PkLd5LSinD945qb/K03epnYBVg8js0OGFeDhDO44nsPYdbIhNtDDPeWOb6n9yVNQ2G
         McF7mD0YQq7ituYncjTB/KzX90a1sDSWlmbXou3lCMKCXdjEISt4Lo4B57OtP9s2/+to
         8r6tZs+3zpX3VOXDpwbXqPDJn1ce/glvYlIRkuyl8kN9iXWO1EzRY0azeqmxExAauzFz
         Dcblh3un7J7RXh70X81psUQZxtxJTmUIhA8LhPHg3N5Ax/fn7CJ6y1HodXL+PdDHHNkp
         rUNg==
X-Gm-Message-State: AOJu0YyNnWtI1yG2GOcKCMGL729rF2NESZvdEiAxW7Aw+HYo/TZBY2Fa
	LGwFeDkebtXi9uRqVolpPMK5YzszqiwktiXDK56WfMSZWESw85ep4oxfou3rWX8/o2zLl3duLV3
	exof0RGU=
X-Gm-Gg: AfdE7cnfLArilP6LcLlHoGuQRuQk/bfEwrtdrhfRflZDvDqNCFT03Ttgjf1T0RCtf9o
	k4oYbPN3vrSMKdQytDvgPbJp28Y/jtDox0Gw0/fdFnulaGMh1nn/rc9/2JN+Md2CDaWS89/E5jT
	haJk0R3oL8qLey64mn4J+WSBtD/O8ZW4NtclohP0RUX3WhtTnXb7URizNkr0qw3XVMCr7k40UVo
	CxkZVZtU0d1LcqF5sDZE7l1o8BBY1fd5UKximYCEi74aupiXaCM5FyRw+byN7+9NVW/esiM1Jqt
	4RtJOzu58KkXBNaHDcHZzWuRL+LXDikE1pcLE/8NC+7uiYcx9Udjy3sTl/eEv46gaAG22SJdhIC
	km2/B9pU40Kt3pY9FpKeK4PVriG6V0tJhuEihqKyQ8prgacxc834/A7X7lox7UWwvOUW7bJNool
	Lq2cAml7DlPsLHOi3SFdldth/XzNEEKdhzTOMJQ+AblPpPzqYYHBlBWbkR/13XoBTz0OI0h+Q=
X-Received: by 2002:a05:6808:2507:b0:4a4:d2b:8e7a with SMTP id 5614622812f47-4a42af3bfbcmr1225563b6e.35.1783744220285;
        Fri, 10 Jul 2026 21:30:20 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4a41f5b69bfsm2093140b6e.17.2026.07.10.21.30.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Jul 2026 21:30:19 -0700 (PDT)
Message-ID: <ebf34c44-2a7b-4656-a9ff-528660a070c5@kernel.dk>
Date: Fri, 10 Jul 2026 22:30:17 -0600
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
Subject: [GIT PULL] io_uring fixes for 7.2-rc3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	DMARC_NA(0.00)[kernel.dk];
	TO_DN_ALL(0.00)[];
	TAGGED_FROM(0.00)[bounces-13928-lists,io-uring=lfdr.de];
	FORWARDED(0.00)[lists@lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:torvalds@linux-foundation.org,m:io-uring@vger.kernel.org,s:lists@lfdr.de];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	RCPT_COUNT_TWO(0.00)[2];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,vger.kernel.org:from_smtp,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 151D17404EE

Hi Linus,

A set of io_uring fixes for 7.2-rc3. This contains:

- Restore full RCU read section in io_req_local_work_add(), which was
  mistakenly dropped with the DEFER_TASKRUN rework in this merge window.
  Revert the commit that grabbed the RCU read lock in
  io_ctx_mark_taskrun(), as that's no longer required with the previous
  fix.

- Fix a dangling iovec after a provided-buffer bundle grow failure, also
  an issue introduced in this merge window.

- Reject IORING_CQE_F_32 flag pass-through in MSG_RING to rings that
  weren't setup with CQE32 or CQE_MIXED.

- Return -EINVAL rather than -ENOMEM from get_unmapped_area() when mmap
  validation fails, matching io_uring_mmap().

Please pull!


The following changes since commit 3996771b8f759729cba0a28007438c085f814d61:

  io_uring/memmap: bound io_pin_pages() by page array byte size (2026-06-22 15:12:54 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-7.2-20260710

for you to fetch changes up to f3176c8ac4217c88fe1147ab084c47092921ffc4:

  Revert "io_uring: grab RCU read lock marking task run" (2026-07-09 11:43:07 -0600)

----------------------------------------------------------------
io_uring-7.2-20260710

----------------------------------------------------------------
Hao-Yu Yang (1):
      io_uring: fix dangling iovec after provided-buffer bundle grow failure

Jens Axboe (1):
      Revert "io_uring: grab RCU read lock marking task run"

Melbin K Mathew (1):
      io_uring/msg_ring: reject CQE32 flag pass-through to normal rings

Woraphat Khiaodaeng (1):
      io_uring: restore RCU read section in io_req_local_work_add()

Yang Xiuwei (1):
      io_uring/uring_cmd: fix uring_cmd.c comments

Yi Xie (1):
      io_uring/memmap: return -EINVAL from get_unmapped_area() on bad mmap

 io_uring/kbuf.c      |  5 +++--
 io_uring/memmap.c    |  2 +-
 io_uring/msg_ring.c  | 34 +++++++++++++++++++++++++++-------
 io_uring/tw.c        |  9 ++++++---
 io_uring/uring_cmd.c |  4 ++--
 5 files changed, 39 insertions(+), 15 deletions(-)

-- 
Jens Axboe


