Return-Path: <io-uring+bounces-12150-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oF0OOiyTjGlQrAAAu9opvQ
	(envelope-from <io-uring+bounces-12150-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 11 Feb 2026 15:33:16 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 802B512543D
	for <lists+io-uring@lfdr.de>; Wed, 11 Feb 2026 15:33:16 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id D5EC2300A8EF
	for <lists+io-uring@lfdr.de>; Wed, 11 Feb 2026 14:33:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F28F827F19F;
	Wed, 11 Feb 2026 14:33:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MfJ1Z+lF"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7940F279329
	for <io-uring@vger.kernel.org>; Wed, 11 Feb 2026 14:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770820382; cv=none; b=fuW7CFfI38nK7HIT6P/I5ebLyB1fkM28DXJ7z9c/YbHipCQnx8O/jJWY4sAfR3pV8jaUfA0/IQrC30UvSxoFAa1f+7wzl7XpnTVYyKTV8YrnlwYqTRTqCXPlc7opwnzCNa4gy9GtnfMFNb7rZAwQQsi8WDFL3xLi36EX12id8zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770820382; c=relaxed/simple;
	bh=C/vFe3kP3KooC/TmOFBj2WXiog79aHaJOYYv/rT9B/s=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=sRBRYsKZs9JUlR/FJzLcmQ3HIg2fCgCnDpIVBML+y+VoUiipFAlDxzhOsZiNpJ26+lIiXmdEM9uFEuaXigq3v5bm1IC/NVX0fEY8T2K+cNw6R8oW7BFCSBuzvV/iG1hK/TnC4MnPBIDXxg59d/32Csk/n5ZKy1eKFDoXtPUiZ3U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MfJ1Z+lF; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-47ff94b46afso9676515e9.1
        for <io-uring@vger.kernel.org>; Wed, 11 Feb 2026 06:33:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770820379; x=1771425179; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=a+ACQbMRmW1Q78x2xp/swFKuW80lioyh00YybAUgjDI=;
        b=MfJ1Z+lFxNU7FjGJ29H3zzZLFWu536Rfo+AfqA6HKT8Ni6D6EdREMLSJCkmi2GJ6wG
         I8b9H6Rq56te982z3aElNG65tA5gNaNc1u0PYU0i6p1heMmNRoCwPi64vWAuu+04Kshb
         GgP1huFHTJABmSAal2GcrJiXKJfUijCXfKGOueXYq1T7PuU3XM9fHjiSu/rqVESVVwgj
         WpQkBx/V4jo8z4evA/yzNC7raXd7V0HAqeRMcD/6bIXuLXqGssGQaP56ZzwDWZ74whNL
         OQrvNZ6Uia8+uyw872VdlEjZAGTq7vpEH/GoBD19NrH9l97wnVHgnT7iV1vyME1yKcK9
         YBlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770820379; x=1771425179;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a+ACQbMRmW1Q78x2xp/swFKuW80lioyh00YybAUgjDI=;
        b=vdHcu8ktP+mJlLruT8tAOsUCsfMXErUMq7l/U8o6M4n1uiBoq1Y80Y+W1oS3V/993+
         f6t1ByBu0l5+3VOOjHXof+bEnP8GVKEOvmevFXCowcNtoWjo44c7yYI9ytNrer9D/hY2
         fxEhZ9sOgU7wMXJ6bOsNQgS0SK1bN65W9i+PL+tZko/D5PvED/EWxCZtxkBO+uGkdIge
         IEhJwQXac/F5Cp/dqHennB0FSp8ffB2AZDEAmO6OEowRzX8p/7nJ12OmMxrrJHY8fLOA
         SQPO9+3stagFBJa8a3VREr7b+IBhPoX5AjEorE+sEfqUjPkoUpM7khIuJWkY0wkViGtE
         MgyQ==
X-Gm-Message-State: AOJu0YwyL+gNexnKHXDhXLNGQ+McnyI1KQU23ejSpuc5zDey/azUklhA
	ugzO0GQE3NZeoRn4GoihqVBybuqD4q3YPFWx3JpTih8fj+trtYd55aRTL6rhT8bE
X-Gm-Gg: AZuq6aK1ZUa7V11krExiMVnWpSZuz6zalvZ8Z+qdGMbxWtFuxsSt0tY3o408A0TpfqV
	5RbfeJJjrT/jTM92cNNXXxtAwk3wd0zOmY0ac6AFMMydVwCqvmcprPu08OonHZr7/HakZH6rbDH
	dYdisqwDdEzJm2jbc//0tyUjcvKNjXZNEYXzNHB9UyItK1bkvRSrhYQeH7Vr8/lym0AoZHXeRek
	bgW0LC1clwn0XTPqeUeeXASyd22S8qc/rJGESJRFyfgxd78L2O1YmPSfwjDBEPw5+ApdeErm7yD
	n2aL5HdGuyTtzxm19BlI7/wo3o8SXHsr/KTbE4FsWt8UfXwPe5uDNlmCQI99zfldBg3ktP7omPr
	lV5LiiQ3ZV32Jjn+rHEuDtFtiSST3K1mc6YLGsLn4zfPMLNk33CPD8tvudYTAAuVfAgZci2/9uo
	IoZUWn8DwlfDMzuqpeq20bPVsFUDXEnrPLtn0olUwmYNpdgV3S7abmBREgrWR4dG4FFISxRG+AT
	0v6KLHGeg==
X-Received: by 2002:a05:600c:1548:b0:479:1348:c63e with SMTP id 5b1f17b1804b1-4835052d123mr80635675e9.9.1770820379204;
        Wed, 11 Feb 2026 06:32:59 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:b997])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43783e39c75sm4973747f8f.29.2026.02.11.06.32.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Feb 2026 06:32:58 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	bpf@vger.kernel.org,
	axboe@kernel.dk,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: [PATCH io_uring-7.1 v5 0/5] BPF controlled io_uring
Date: Wed, 11 Feb 2026 14:32:39 +0000
Message-ID: <cover.1770818588.git.asml.silence@gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12150-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org,kernel.dk];
	FREEMAIL_FROM(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 802B512543D
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

 include/linux/io_uring_types.h               |  10 +
 io_uring/Kconfig                             |   5 +
 io_uring/Makefile                            |   3 +-
 io_uring/bpf-ops.c                           | 271 +++++++++++++++++++
 io_uring/bpf-ops.h                           |  28 ++
 io_uring/io_uring.c                          |   8 +
 io_uring/loop.c                              |  96 +++++++
 io_uring/loop.h                              |  27 ++
 tools/testing/selftests/Makefile             |   3 +-
 tools/testing/selftests/io_uring/Makefile    | 162 +++++++++++
 tools/testing/selftests/io_uring/basic.bpf.c | 131 +++++++++
 tools/testing/selftests/io_uring/common.h    |   6 +
 tools/testing/selftests/io_uring/runner.c    | 107 ++++++++
 13 files changed, 855 insertions(+), 2 deletions(-)
 create mode 100644 io_uring/bpf-ops.c
 create mode 100644 io_uring/bpf-ops.h
 create mode 100644 io_uring/loop.c
 create mode 100644 io_uring/loop.h
 create mode 100644 tools/testing/selftests/io_uring/Makefile
 create mode 100644 tools/testing/selftests/io_uring/basic.bpf.c
 create mode 100644 tools/testing/selftests/io_uring/common.h
 create mode 100644 tools/testing/selftests/io_uring/runner.c

-- 
2.52.0


