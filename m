Return-Path: <io-uring+bounces-13479-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kPCpG297EGrdXwYAu9opvQ
	(envelope-from <io-uring+bounces-13479-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 22 May 2026 17:51:11 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B8A465B7280
	for <lists+io-uring@lfdr.de>; Fri, 22 May 2026 17:51:10 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 0350E300363F
	for <lists+io-uring@lfdr.de>; Fri, 22 May 2026 15:51:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 51EDC3126D6;
	Fri, 22 May 2026 15:51:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="sc4C03g4"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF0E62FDC27
	for <io-uring@vger.kernel.org>; Fri, 22 May 2026 15:51:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779465063; cv=none; b=sXdnTZgNj3a/yijcqUlp5ybyUH5Np9OrtPRuQ3wqmsEQx1TZ2maAfJ4xVn3g6eRJtuTy0ydm//5gRNdZYCZwToiHWSX7yVwuiLbw0GKHJR7vFA0ymxtHOA7tfDe9iRdXTckPyUZh6mR4JhWe0Ob9UxdGUGjNoF6+eea1bkRZXFI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779465063; c=relaxed/simple;
	bh=LiyHAI1j5cTad6bj8ZKKwmr2GhG5SZkYdsoWtqx7f/8=;
	h=Message-ID:Date:MIME-Version:To:Cc:From:Subject:Content-Type; b=SkUHuC5+X+nMNpj0I/QXVCGaWis5Qh9KS5cRp9lg6KC/NM85k3Z88u9Cc3pCrQbE0vBTqU7ZNNO4HQMT30eAZLRsL61+xeQ0TD4ReT5kfm7F/za+RSWmXjmu8DG8YSmUWLy8yeQMAJnJxutr2VvRG5x3c3n/fWEIfz+hDrycKRA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=sc4C03g4; arc=none smtp.client-ip=209.85.160.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-439acb393f7so8156270fac.1
        for <io-uring@vger.kernel.org>; Fri, 22 May 2026 08:51:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1779465060; x=1780069860; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fvsxMlMi/wX5zCqUSyUTgkzkggjq5oBi0ZVEx3QNic8=;
        b=sc4C03g46a/CGoXV7/x54i51oiUjmo21o3wGEmUmOm5v7TSO2Y8nTU4U4jbENj9AyN
         uokpO7tSmwtWG3NurhuLZ+UbiqXZ56U8BPeL9UuwmhdlM6nKmu521YVJ3CtyxIv1LeS8
         Xu6rTE37hUsrrqti0GgdY3DJfyGr4xdA1Y8jAUqbI4TOtmUF2gEG1D0y6XfEgkNmiOYP
         0rDRkeYZf/6jEl0IJn51ji+7lBs27xTF0WwhFf0yGLD8RzbmINZ6Rlf2UWZ3Qnm8q9m3
         ofYqRzpTleW5WGFlYN+GT8KqDsriOAP14XTkiYMzmgLR8eMduZYSJ113CFdjHbpSztFl
         Pv6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779465060; x=1780069860;
        h=content-transfer-encoding:subject:from:cc:to:content-language
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fvsxMlMi/wX5zCqUSyUTgkzkggjq5oBi0ZVEx3QNic8=;
        b=cNmADHgdPOr7nOJrYCQV2RPsR1Q6klZKTb5sGMLGQ5eSzZyrTL+uYSjAU8YZMckJFh
         sm7ky1nSu0WbiUjm9w1Js/C6XFKRQzbzar1RMRQqmSqPReITIxgym7ubEaZsr+r7L/eh
         CgzWN0CFEVOtWHtUSLQ4A8h8hdywwcmda1sb+d6TwiDu7eW2MeTgP0n/HG5ZgZaKFdGc
         f1NISMSMLNyqVkswvrKIEb4lSxaFl6B3/A9cijtDWxGs9cmJfctnlXZWX7Kt4uyj0Ljn
         f+dUyx0JCTBwnf6VS3mLP5zlh43ArRLOtmp+3evq/lrzdwwR+WC8HtmWJ+zZ7z1YYD1O
         bAMw==
X-Gm-Message-State: AOJu0Yz30F8s67HwsWhI22kpXt3YoAf1ySe5pj6J/VNqh2Ui4933NTko
	Xv4JYtPEWiAkIlLnzqv/ioYfPLxHLfIaN+xL7QD9NsJigz3RanK2ROXD0aoiFouwVaTyJkD+uh1
	DVb/5
X-Gm-Gg: Acq92OEsLPRQD80XDvXj0GIw3JaDdrx4G7knRYqMUARqJrKvaVLwMdx/pxpn5cfyh44
	amhwDZCQt1SBAP6CHYa1DVJjJFc0umTU3bL9R4lC9YL1r0kHBr4S8Klvc0eRLbRxEMb/WcN1CW0
	+QYTl/m+dBPz8+qPf7tPuHQ5AutPVeYT2l9XUDURUB25Tgjkjf3bh8+Va8N4QzxfKRAAtEbq/53
	XqpSnz8mU5odY6eE2oz6O3d1X95I3iPlsFeqTjvU8KsNOztGaPnwwf7Q0zcjoX3ZuXtumlTOt+Y
	NumY/FK83wZvhfU3wbkVrZNJ65BbSeQwzAERvxh/aidpB5C8c0TGnkkRt9P44C2dig5ZrwC2cCl
	EFvrwC0io/kAPs8oS7ksjZ+OA7otdYvTvH55Rqd7gWJNFuztLYp3AWzegeoBbWfl4WDOSG24DBT
	Ja2qOEaeHzUMamCDC5ePDBLjk01cbAEeRzo7XOAH9fdvoJjdYcZewe05ekXgyi9YCKsgYnzt9H6
	2cX7ZJNH0GBU/K2SEM=
X-Received: by 2002:a05:6870:6b91:b0:42f:af81:2765 with SMTP id 586e51a60fabf-43b5ab20aaemr2505850fac.16.1779465059683;
        Fri, 22 May 2026 08:50:59 -0700 (PDT)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-43b639fd705sm2195165fac.15.2026.05.22.08.50.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 May 2026 08:50:58 -0700 (PDT)
Message-ID: <a2fc1873-e68c-45ad-a8db-c70eb2c9c5a8@kernel.dk>
Date: Fri, 22 May 2026 09:50:57 -0600
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
Subject: [GIT PULL] io_uring fixes for 7.1-rc5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20251104.gappssmtp.com:s=20251104];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13479-lists,io-uring=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,kernel.dk:mid]
X-Rspamd-Queue-Id: B8A465B7280
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Hi Linus,

A few fixes for io_uring that should go into the 7.1 kernel release.
This pull request contains:

- Fix for an issue with IORING_OP_NOP and using injection results

- Fix for an issue in IORING_OP_WAITID, where the info state was assumed
  cleared by the lower level syscall handler, but for some cases it is
  not. Just clear the data upfront, so that non-initialized data isn't
  copied back to userspace.

- Fix for a lockdep reported issue, where IORING_OP_BIND enters file
  create and hence hits mnt_want_write(), which creates a 3 part lockdep
  cycle between the super lock, io_uring's uring_lock, and the cred
  mutex.

- Fix a regression introduced in this cycle with how linked timeouts are
  deleted.

- Ensure that the ->opcode nospec indexing on the opcode issue side
  covers all the cases.

Please pull!


The following changes since commit f44d38a31f1802b7222adaea9ee69f9d280f698a:

  io_uring: validate user-controlled cq.head in io_cqe_cache_refill() (2026-05-13 21:44:57 -0600)

are available in the Git repository at:

  https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git tags/io_uring-7.1-20260522

for you to fetch changes up to e97ff8b62d4690c69297f0f6de874f0564cc01a4:

  io_uring/nop: pass all errors to userspace (2026-05-21 11:10:56 -0600)

----------------------------------------------------------------
io_uring-7.1-20260522

----------------------------------------------------------------
Alexander A. Klimov (1):
      io_uring/nop: pass all errors to userspace

Heechan Kang (1):
      io_uring/waitid: clear waitid info before copying it to userspace

Jens Axboe (2):
      io_uring/net: punt IORING_OP_BIND async if it needs file create
      io_uring/timeout: splice timed out link in timeout handler

Michael Bommarito (1):
      io_uring: propagate array_index_nospec opcode into req->opcode

 io_uring/io_uring.c |  9 ++++-----
 io_uring/net.c      | 26 +++++++++++++++++++++++++-
 io_uring/nop.c      |  4 ++--
 io_uring/timeout.c  |  4 +++-
 io_uring/waitid.c   |  1 +
 5 files changed, 35 insertions(+), 9 deletions(-)

-- 
Jens Axboe


