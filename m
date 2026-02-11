Return-Path: <io-uring+bounces-12165-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UN24LeLSjGm+tgAAu9opvQ
	(envelope-from <io-uring+bounces-12165-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 11 Feb 2026 20:05:06 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CC0CB126FDF
	for <lists+io-uring@lfdr.de>; Wed, 11 Feb 2026 20:05:05 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 7CC133004624
	for <lists+io-uring@lfdr.de>; Wed, 11 Feb 2026 19:05:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C1CC3191CF;
	Wed, 11 Feb 2026 19:05:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="e9IXtwW9"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6C59295D90
	for <io-uring@vger.kernel.org>; Wed, 11 Feb 2026 19:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770836700; cv=none; b=Hwx/rgyZaLv3dBDRJibdYpqdhrAwOzxZXiQtLLtx784pmSq/YAg5mFDKsi5rrOrxMx3SvhJL1dWpKVkw9JcFiscj9I1xrqSCjayID/akNLx/73xKAwYrkVUvY3e8gC2P3FSmW1NoMxjJWoEToOXyeuT0c05lmSPMcpeYIzOKHJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770836700; c=relaxed/simple;
	bh=SU+ZkV7tEKyOIWdqLooOmnyTOabBy1/MLq3hqu/wI1E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=g2ctJ6h5/uY42QX3Muv7+wDkwkTTLC24WEZ3O+eElH9fSTmnC0AnZRlRs8TkscfCqNk1cJWXMgGjWLPlLlhPpeTYXV2lOKFHHfjCIzNgkof1c7U9A1p+nxomCpjTxwp/BHQno6Fz/yeCYyceNJ8Bs8IAmIr3LWa8YyioQJH5wZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=e9IXtwW9; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-47ff94b46afso12528865e9.1
        for <io-uring@vger.kernel.org>; Wed, 11 Feb 2026 11:04:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770836696; x=1771441496; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=d59SANFE3hpm6oFn6wRf+OdKFNjjGShou9odejSdtso=;
        b=e9IXtwW9da7C/KjDtUQ5o0q7IskvgCkHNO8oM8umqL+dKrgZdclQ6QscHR3JXACLf+
         vgruSyjWHD8DGClw28HjmhOLil93YkilCDvpRXDQ/ZSMVJyxinYawSIiLZyzY/4hP5q2
         ymrhuEHX3YZwhJThJO1Y1TQlQIOy0/vwqmatuUjeR/Tft2RuLh7kHk/KzcqEgCMO9Sbn
         xPx6wojAFcN6ZfSwtGfECVpB7LI25ZzQhpQ8TGCtUnnwcD5WcOIzQcfgB00UFthUlgLU
         kbxAEMf6hfTDqIwcYXLVRSwUSOe20HmV9O/HAkse8tOrzhLSO/v8mUVp7bRCVtAW6Vao
         7Xlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770836696; x=1771441496;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d59SANFE3hpm6oFn6wRf+OdKFNjjGShou9odejSdtso=;
        b=Ms8YyPrQl2xSvJRVQM3CwDJ7bho99zewQycQ1pmRMIRDU0bKVUKdiVqL+VHp5dgRe9
         3SyFRZ2qf9j1Aod9oAv+BSIDNaTX97xB+nmVoMYya+A4erTkdC6R5cDD17UJK+VqGAb8
         Z83/tKM0/kfsBQaxkCL8NOJVF2ysrtNMBhv+Dqk3ntrYJHHc1X4RCHUOzqugW15uwCA3
         LSMrGu8wm9mV2ZzVxDL6+ctxFDt+OTZyQOIvMJLj1fA4Y2aImi0IfVUs1s+HnCGRxS8N
         r+/1s7tiAr3aR0E9gvvJCwtO3I/YknyZ7RIXsEZjWmbTiknEuif2DmWCsJ470vljBATb
         I2qQ==
X-Gm-Message-State: AOJu0Yw1JnkILJWDnw6vXycyoVcspGLKnWOHhnmbN20NDHiU0mkPUV3i
	8lXtFepNof/bEKa1iK5Lnrikxs9A4RqeH1uP88EbU1aHsFyfkWIkdDgIejKTXDEq
X-Gm-Gg: AZuq6aLQcWNRnOTV53a0F6xmtxhjbL88AasqN/VxfS3Qb6127ogZLtWOUKs7Q0NJCuU
	h5i5OgYgkuaIErYeuC0CK0TIoLpAHeC39xWxI5id/FjfvygwFQr5hG6hVWSF3FPrORKEz2Nb5vD
	IpxDm+aqtY3An0e6/XeaKIJIiNp/LgwMMFHl9efSEHOHWl5z0rAInTnIA0uiBsryNsLkE+GA8lH
	6VQ9l6vkM/am7Vvri7NlwVfNexSAqUjANV/kzhRA1NcXGPKya2cqoZssauGowi1efX4/V/O7EZJ
	IUMG6/ikpdPmZj5BYtrIsoeat0TRCoPPhrled9/furPHJyyy9WUGPgFEEelFsJmooM3QZJGfPi1
	beX57+0bermEVJ9kzFbViiNqkxQrRtym2pVlIUQ0dIltTSeHrJJdVfNBFzRRkrtZqQpxWgmi12Z
	ynqJiXiYUw+oJpXa43fFmiMU7lHM/lTLIVkx4MuGRBy9LPCM5mMNTiJZLA8DP9fjMQ1D5YC8Q5J
	PXPlaompOeRj1rp0wgXtczGZNhsgA==
X-Received: by 2002:a05:600c:c176:b0:481:a662:b3f3 with SMTP id 5b1f17b1804b1-48364fe0814mr6901115e9.7.1770836696485;
        Wed, 11 Feb 2026 11:04:56 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43783dfc8b9sm6174169f8f.24.2026.02.11.11.04.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 11:04:55 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	bpf@vger.kernel.org,
	axboe@kernel.dk,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: [PATCH io_uring-7.1 v6 0/5] BPF controlled io_uring
Date: Wed, 11 Feb 2026 19:04:51 +0000
Message-ID: <cover.1770836401.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.52.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12165-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org,kernel.dk];
	FREEMAIL_FROM(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: CC0CB126FDF
X-Rspamd-Action: no action

This series introduces a way to override the standard io_uring_enter
syscall execution with an extendible event loop, which can be controlled
by BPF via new io_uring struct_ops or from within the kernel.

There are multiple use cases I want to cover with this:

- Syscall avoidance. Instead of returning to the userspace for
  CQE processing, a part of the logic can be moved into BPF to
  avoid excessive number of syscalls.

- Access to in-kernel io_uring resources. For example, there are
  registered buffers that can't be directly accessed by the userspace,
  however we can give BPF the ability to peek at them. It can be used
  to take a look at in-buffer app level headers to decide what to do
  with data next and issuing IO using it.

- Smarter request ordering and linking. Request links are pretty
  limited and inflexible as they can't pass information from one
  request to another. With BPF we can peek at CQEs and memory and
  compile a subsequent request.

- Feature semi-deprecation. It can be used to simplify handling
  of deprecated features by moving it into the callback out core
  io_uring. For example, it should be trivial to simulate
  IOSQE_IO_DRAIN. Another target could be request linking logic.

- It can serve as a base for custom algorithms and fine tuning.
  Often, it'd be impractical to introduce a generic feature because
  it's either niche or requires a lot of configuration. For example,
  there is support min-wait, however BPF can help to further fine tune
  it by doing it in multiple steps with different number of CQEs /
  timeouts. Another feature people were asking about is allowing
  to over queue SQEs but make the kernel to maintain a given QD.

- Smarter polling. Napi polling is performed only once per syscall
  and then it switches to waiting. We can do smarter and intermix
  polling with waiting using the hook.

It might need more specialised kfuncs in the future, but the core
functionality is implemented with just two simple functions. One
returns region memory, which gives BPF access to CQ/SQ/etc. And
the second is for submitting requests. It's also given a structure
as an argument, which is used to pass waiting parameters.

It showed good numbers in a test that sequentially executes N nop
requests, where BPF was more than twice as fast than a 2-nop
request link implementation.

I've got ideas on how the user space part while writing toy programs,
mostly about simplifying life to BPF writers, but I want to turn it
into something more cohesive before posting.

v6: - Fix inversed check on ejection leaving function pointer and
      add a selftest checking that.
    - Add spdx headers
    - Remove sqe reassignment in selftests

v5: - Selftests are now using vmlinux.h
    - Checking for unexpected loop return codes
    - Remove KF_TRUSTED_ARGS (default)
    - Squashed one of the patches, it's more sensible this way

v4: - Separated the event loop from the normal waiting path.
    - Improved the selftest.

v3: - Removed most of utility kfuncs and replaced it with a single
      helper returning the ring memory.
    - Added KF_TRUSTED_ARGS to kfuncs
    - Fix ifdef guarding
    - Added a selftest
    - Adjusted the waiting loop
    - Reused the bpf lock section for task_work execution

Pavel Begunkov (5):
  io_uring: introduce callback driven main loop
  io_uring/bpf-ops: implement loop_step with BPF struct_ops
  io_uring/bpf-ops: add kfunc helpers
  io_uring/bpf-ops: implement bpf ops registration
  selftests/io_uring: add a bpf io_uring selftest

 include/linux/io_uring_types.h                |  10 +
 io_uring/Kconfig                              |   5 +
 io_uring/Makefile                             |   3 +-
 io_uring/bpf-ops.c                            | 272 ++++++++++++++++++
 io_uring/bpf-ops.h                            |  28 ++
 io_uring/io_uring.c                           |   8 +
 io_uring/loop.c                               |  97 +++++++
 io_uring/loop.h                               |  27 ++
 tools/testing/selftests/Makefile              |   3 +-
 tools/testing/selftests/io_uring/Makefile     | 162 +++++++++++
 tools/testing/selftests/io_uring/common.h     |   7 +
 .../selftests/io_uring/nops_loop.bpf.c        | 131 +++++++++
 tools/testing/selftests/io_uring/nops_loop.c  | 110 +++++++
 tools/testing/selftests/io_uring/unreg.bpf.c  |  26 ++
 tools/testing/selftests/io_uring/unreg.c      | 113 ++++++++
 15 files changed, 1000 insertions(+), 2 deletions(-)
 create mode 100644 io_uring/bpf-ops.c
 create mode 100644 io_uring/bpf-ops.h
 create mode 100644 io_uring/loop.c
 create mode 100644 io_uring/loop.h
 create mode 100644 tools/testing/selftests/io_uring/Makefile
 create mode 100644 tools/testing/selftests/io_uring/common.h
 create mode 100644 tools/testing/selftests/io_uring/nops_loop.bpf.c
 create mode 100644 tools/testing/selftests/io_uring/nops_loop.c
 create mode 100644 tools/testing/selftests/io_uring/unreg.bpf.c
 create mode 100644 tools/testing/selftests/io_uring/unreg.c

-- 
2.52.0


