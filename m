Return-Path: <io-uring+bounces-13837-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id e0SgDikbPWpqxAgAu9opvQ
	(envelope-from <io-uring+bounces-13837-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 25 Jun 2026 14:12:25 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 994016C5710
	for <lists+io-uring@lfdr.de>; Thu, 25 Jun 2026 14:12:24 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel-dk.20251104.gappssmtp.com header.s=20251104 header.b=fX91Erqs;
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13837-lists+io-uring=lfdr.de@vger.kernel.org" designates 172.105.105.114 as permitted sender) smtp.mailfrom="io-uring+bounces-13837-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=none;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 4299630CE8F7
	for <lists+io-uring@lfdr.de>; Thu, 25 Jun 2026 12:09:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBC843E16A4;
	Thu, 25 Jun 2026 12:08:51 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D85CB3E169F
	for <io-uring@vger.kernel.org>; Thu, 25 Jun 2026 12:08:49 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782389331; cv=none; b=GPd/c1NpJ3ltY/c+bnbU1KOA1AhmjhKLxJE41wPE1BfxbE8uHQLeeg03rRbLd5nekjzewl1hE6TTt4nbfvYI8SSmfFpaEf/Fj2THf0ukkL56tLu4yKgGO480ZIZeaGxOR6VUhKJibHeb1pFCJS7J5b8KeDvaxxQ92VjgLcpLyaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782389331; c=relaxed/simple;
	bh=3gCmykHVM3TefHavGG9CBMLi0OnqnBUZlwJFj2JMqio=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=fMgcKMBIQv9Rt/AWTwptSp/vngkDIWoN+yE9emhwTUWrMJRNZZmU4Bzi8CFPDKuISRcVGGHr/sxQX8QZoPvPN/ZP4REtMVrtPTuUAKUO9rXuzVwxxunATkPc45aOwtijcub+seodTsUBaB19l+yJy8wJGWLzz5ZUh/XM/QiYxw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=fX91Erqs; arc=none smtp.client-ip=209.85.210.42
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7e6b554044fso1750211a34.0
        for <io-uring@vger.kernel.org>; Thu, 25 Jun 2026 05:08:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1782389329; x=1782994129; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Nk/20+wQTxalvgrt4mju+CbGhxlrziaJ2F0hT5rKkoo=;
        b=fX91ErqssAmo+L1vkEhBtl2qzoLqGQ+JvTBin51O7XMhSpHcjX/4324QFma7LReLF8
         LZvIk1P6Rp0MR+efY3/edUBBVN/xH0aPJbGRu6eLFLF3EUiaY9ID2AfBfpjOOiCd9jF3
         /FRXHi4jXS0QkKffkZN0BtZ/n03Cckbcu5pwlOPsUwZUlt72pONWyjQgAxHtCVK47CwL
         TSQKiGOqIRo4/wceGAmDbkf5JXMJBFdLEk+7Nk//1TjEQPRxRjlLH3o7BOp/+Mt/7Wm2
         pkwOtYmPjod3CjPbFi05kv4/yl/bYN4GwuCLfuJoMQUhCx832a0Qv6843y6JXCfTPtqI
         mxoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782389329; x=1782994129;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Nk/20+wQTxalvgrt4mju+CbGhxlrziaJ2F0hT5rKkoo=;
        b=PbTYy2smXasUjpaRfPyzR2tcbpw/s/udaTkO6mBUNThai4YcgF7gD6Bac7O9tnQ3H4
         82fqsFkKVFLnM9WG3STiU8d8MYa6o4V5/1Ue/k36S9iSRitnFNa0uVsneH/ZmfZw9YQo
         c06HIzosbU9HjDQCAi4wDu3Je7kvrgbfM7cJ6RXnI7FRiyF0a5ajV4rlmQZd7UmzunwM
         EGW04n7KuQ/0uBB8D3Uo8LLP7xupEt1JQUHUI8kZss3KK2CPMwU2enVjzob3bS1pf0QF
         alg/5wzS4xH+7JU9VRSIuG6WNSIq3YeDO2RJ7pomLqRXkdowkmHAsF3Nz2wpTBMc18kr
         jeVQ==
X-Gm-Message-State: AOJu0YynV1ljta5hJyVhcu2SUUfXYLjvETDWtI5O0tsZ+qQ+B47mjDQx
	/B0TV22FWFe0cbG+7QGy0lenIQ9HPBpD/ir3Pqk3l14o5Hqy3k26hrNHGmOnH9+CHaiJ8CZfDDo
	gs8KResI=
X-Gm-Gg: AfdE7ckhneRltMiNnwZV2tX0slKY1dRDzqc8IFrteC5kWy+uwyhpdE4gdeH/GUUl+cy
	9WvYtzfBpBIdhGDUERmjWkD+waCHS4ACf4Ff0pclRPW8coQBaTR5vya+u1y7AhWNGLR8uYTRpWm
	1z00nOMjOGN3TnPfeiFVaOdincFwfL2Kmx+s9oGVsl5pxUmnmYEDiFg5ufM9qrctTaBqBqEVIw4
	vQ/G7nXGefjxcuoerPH4Bsvk1HxfQbYtPd2XQgEVBsXNRogO48mHYv/LseJWQ84/DTp+eByP0QN
	IgIF5BGfJavaa6kFgSOCrR9vLZC12wpiK9sLwxi6PzxCHizDwHpa6D3S9dDPtTV6ckwng0x4Vde
	jrsAZAAc75UK57BUjf6dKuRtERk9Z/Q+2ZTZfkOeNrCvyO7hXMRvD017Xff55ekvcJdkwjWtdY6
	lvGaw92AwJMY1faCZNtpfl255XdtSpoFylz88AK981iK2Oz233XtPxoKhBVn5N4HxGrKd88v85C
	bK4h5SrvQ==
X-Received: by 2002:a05:6830:621a:b0:7e6:f7fb:9678 with SMTP id 46e09a7af769-7e99bff26e6mr2147740a34.1.1782389328898;
        Thu, 25 Jun 2026 05:08:48 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e9440661acsm15031098a34.7.2026.06.25.05.08.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 25 Jun 2026 05:08:47 -0700 (PDT)
Message-ID: <8762b3ca-0f33-4aa1-9d81-76dcbd222676@kernel.dk>
Date: Thu, 25 Jun 2026 06:08:47 -0600
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
Subject: [GIT PULL] io_uring fixes for 7.2-rc1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCPT_COUNT_TWO(0.00)[2];
	TO_DN_ALL(0.00)[];
	TAGGED_FROM(0.00)[bounces-13837-lists,io-uring=lfdr.de];
	FORWARDED(0.00)[lists@lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DMARC_NA(0.00)[kernel.dk];
	FORGED_SENDER(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS(0.00)[m:torvalds@linux-foundation.org,m:io-uring@vger.kernel.org,s:lists@lfdr.de];
	DKIM_TRACE(0.00)[kernel-dk.20251104.gappssmtp.com:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,vger.kernel.org:from_smtp,kernel.dk:mid,kernel.dk:from_mime,kernel-dk.20251104.gappssmtp.com:dkim]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 994016C5710

Hi Linus,

A few io_uring fixes that came in during the merge window. This contains:

- Fix a file reference leak in the nop opcode when used with
  IOSQE_FIXED_FILE.

- Preserve the SQ array entries when resizing the ring via the register
  path.

- Preserve the partial result for an iopoll request rather than
  overwriting it.

- Don't audit log IORING_OP_RECV_ZC.

- Bound io_pin_pages() by the page array byte size in the memmap path.

- Follow-up cleanup to the task_work mpscq conversion, getting rid of
  the now-unnecessary tw_pending tracking for the !DEFER_TASKRUN path.

- Switch a system_unbound_wq user over to system_dfl_wq

Please pull!


The following changes since commit 8b308f96484e37d92d2fc6b72b091f60496c000e:

  Merge tag 'linux_kselftest-next-7.2-rc1' of git://git.kernel.org/pub/scm/linux/kernel/git/shuah/linux-kselftest (2026-06-16 16:49:07 +0530)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-7.2-20260625

for you to fetch changes up to 3996771b8f759729cba0a28007438c085f814d61:

  io_uring/memmap: bound io_pin_pages() by page array byte size (2026-06-22 15:12:54 -0600)

----------------------------------------------------------------
io_uring-7.2-20260625

----------------------------------------------------------------
Deepanshu Kartikey (1):
      io_uring/memmap: bound io_pin_pages() by page array byte size

Jens Axboe (1):
      io_uring: get rid of tw_pending for !DEFER task work

Michael Wigham (1):
      io_uring/rw: preserve partial result for iopoll

Nathan Chancellor (1):
      io_uring: Use system_dfl_wq instead of system_unbound_wq

Ricardo Robaina (1):
      io_uring, audit: don't log IORING_OP_RECV_ZC

Vasileios Almpanis (1):
      io_uring/nop: fix file reference leak with IOSQE_FIXED_FILE

guzebing (1):
      io_uring/register: preserve SQ array entries on resize

 include/linux/io_uring_types.h |  2 --
 io_uring/memmap.c              |  2 +-
 io_uring/mpscq.h               |  9 +++++++++
 io_uring/nop.c                 |  8 ++++----
 io_uring/opdef.c               |  1 +
 io_uring/register.c            | 31 +++++++++++++++++++++----------
 io_uring/rw.c                  | 12 ++++++------
 io_uring/tw.c                  | 21 +++++++++------------
 8 files changed, 51 insertions(+), 35 deletions(-)

-- 
Jens Axboe


