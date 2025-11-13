Return-Path: <io-uring+bounces-10590-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 99CC0C574D7
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 13:00:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 218364E4B9A
	for <lists+io-uring@lfdr.de>; Thu, 13 Nov 2025 12:00:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24ACA34DB68;
	Thu, 13 Nov 2025 12:00:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VpikwPG2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BAE233892C
	for <io-uring@vger.kernel.org>; Thu, 13 Nov 2025 12:00:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763035204; cv=none; b=GGnGQ4AN/ulx3pbXDkjjyI1ExvWR97gAfhmT6RmKyWZX4W3tNQfXmVN/vF/4uBfhlW3/j1Ny/zhNCpIM3CdOG5k4/5vVOmYH0Jd5MBYfSO0q2pKDveLdYqCJJ1uUQ9vGmxzvBnI3t0XjrhDFg9AOr/QJSJn5uCDg15QBrdPrOwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763035204; c=relaxed/simple;
	bh=wcKTYXi29mV+1guw8YDUU6A+NRswQPhohuo+sYDrdok=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=RwH/H5e2EMBgt6U1DFb7cLrSlxKiZDuUY/LRM7tc/yYCptSMb4pAbUc4IEBiWy4kFATz0jmG6rJ6xZOdVXE8i6wJFt+foKHtcDYqOXOqUE/GKX+9rZAELDe6DqMMCwxIvTBqiwcqdH8QPpyokozHzXIgAD6ysCYs46XnkS4vrTE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VpikwPG2; arc=none smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-42b3c5defb2so478788f8f.2
        for <io-uring@vger.kernel.org>; Thu, 13 Nov 2025 04:00:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763035200; x=1763640000; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=C7VGo/dqF/EVEUttF4Aca30ks+x8ZXpPyJklr1zfWJM=;
        b=VpikwPG2V77pw+3jYvKRnQbm7AlIt7suTsyEwI0xKJdcFek+1nAUusoyrxqAEvG4kh
         MgyLbKHQuT342WBM+dfF9mC/KXejkLIxtBTssoEe9m3qYEdWz0SdTo2rQbGc7RaqC1b2
         LIL2nam5XtRUcGzV5vk32Ft8PfQVaR+urS5fSgxzCWMIPci/SGHbpJQ/f5Pf8Hvyao68
         +yyvf3vgA+oOyVnKfz7ovMD7qdIdRJ+HY/3zn8+7wkkJOUA/nOwV0D/vOIHMevARcjm4
         4elmIqJqa78OwId9aWHsrPpAwLjf8Vrz4b765U8yAzl8AuKC1C9OXDIjObrxj6fDdj+t
         xpZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763035200; x=1763640000;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=C7VGo/dqF/EVEUttF4Aca30ks+x8ZXpPyJklr1zfWJM=;
        b=pD0Gdqp9xHRDV52J+icoFaaAOrBcbyGAOLA0TWSA0GmgH1REQqhP5tidWvQMKmRvBK
         Y47kYaJCC4/bBTGaU8lhoRYtafW4jZ4nDL9cWSUmepqrUnMJAtVdMQYc2E5BiYtQLFM/
         cPvrQSxbhfew6WHqRLlFcW3DrWrDDtMEao4dCOMjUf45T204nGzwBBTROOpjJ3cvQOf4
         4PXoAVqFLN6dguUk1WE9ijCnZFv2BacJBtc5s66u0kYauW2cUOjojiKv4QYVg30jW4gj
         S14ERH6MYfpMfNpWiLgBCugqYzIeNCn8ZnksZDKc++qjV8M8L506YOpQgpVpKtPPFo1p
         0ixw==
X-Gm-Message-State: AOJu0Yy1FS1lmmtwFJHnAmTulOtIHFplIv9z+BeEtZ6l5Pt5aPrB6jxb
	+ODXXDc0ELOb2iiELaSf/tSk8Dw2tL/E+cMtfKah6GgcTPxCREWPOKuj4uva4A==
X-Gm-Gg: ASbGncumZLntxZIQjG0NuakdsB8U0n+bRCesMXZi0eP3aBsHYGOiig2sDIBgfvP0BwW
	dqcKv0Krf5rWjVT7LbiMW++DDDcSSreoyUN7zVgzQum2Ctw1w5aOBGmmplpR0QtPVQbGN8dwLop
	86al9QD5cWuQdg5x/lSSiDYuQDB/XdpIFsVf4ONxN6QTMs8v5tIY1aj/fB3jWxqdg5/zekvaL3h
	1SoQWUbe9pWc46UxlnS4Eys9a8Hb/AfwaSHugZvfYMMGs6IIfgLwhlS1pj2mPiZk49tnJIkLjxJ
	7HQxB5FRC/ufZXQv3o9ycpwXPWj4XJgkeT554lS9L1jnC59LmJSu1+PskPoUhUd6pbSF9SjyFyR
	fb8B//+xnJnWzI/k4yTZuan7T113XQNxyE2LLm+BeQIEKmsBhp9Oogqx7a5g=
X-Google-Smtp-Source: AGHT+IFyLEdiNrHMdJDbYTrSq9KNet+uR1QczyeQlVOP7Oj8VVE0HtFyU6yjFTH1x7kaaIfUM9dlEA==
X-Received: by 2002:a05:6000:651:b0:400:7e60:7ee0 with SMTP id ffacd0b85a97d-42b4baecb4dmr5341056f8f.0.1763035199583;
        Thu, 13 Nov 2025 03:59:59 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:6794])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b53e85e6fsm3686816f8f.18.2025.11.13.03.59.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 13 Nov 2025 03:59:59 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	axboe@kernel.dk,
	Martin KaFai Lau <martin.lau@linux.dev>,
	bpf@vger.kernel.org,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	ming.lei@redhat.com
Subject: [PATCH v3 00/10] BPF controlled io_uring
Date: Thu, 13 Nov 2025 11:59:37 +0000
Message-ID: <cover.1763031077.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.49.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This patch set adds a hook into the io_uring waiting loop and
allows to attach a BPF program to it, which is implemented as
io_uring specific struct_ops. It allows event processing and
request submission as well as waiting tuning.

There is a bunch of cases collected over time it's designed to cover:

- Syscall avoidance. Instead of returning to the userspace for
  CQE processing, a part of the logic can be moved into BPF to
  avoid excessive number of syscalls.

- Smarter request ordering and linking. Request links are pretty
  limited and inflexible as they can't pass information from one
  request to another. With BPF we can peek at CQEs and memory and
  compile a subsequent request.

- Eventual deprecation of links. Linked request kernel logic is
  a large liability. It introduces a lot of complexity to core
  io_uring, and also leaking into other areas, e.g. affecting
  decisions on what and when is initialised. It'll be a big win
  if it can be moved into the new hook as a kernel function or
  even better BPF.

- Access to in-kernel io_uring resources. For example, there are
  registered buffers that can't be directly accessed by the userspace,
  however we can give BPF the ability to peek at them. It can be used
  to take a look at in-buffer app level headers to decide what to do
  with data next and issuing IO using it.

- Finer control over waiting algorithms. io_uring has min-wait support,
  however it's still limited by uapi, and elaborate parametrisation
  for more complex algorithms won't be feasible.

- Optimised waiting. On the same note, mixing requests of different
  types and combining submissions with waiting into a single syscall
  proved to be troublesome because of different ways requests are
  executed. BPF and CQE parsing will help with that.

- Smarter polling. Napi polling is performed only once per syscall
  and then it switches to waiting. We can do smarter and intermix
  polling with waiting using the hook.

It might need more specialised kfuncs in the future, but the core
functionality is implemented with just two simple functions. One
returns region memory, which gives BPF access to CQ/SQ/etc. And
the second is for submitting requests. It's also given a structure
as an argument, which is used to pass waiting information.

Previously, a test sequentially executing N nop request in BPF
showed a 50% performance edge over 2-nop links, and 80% with no
linking at all on a mitigated kernel.

since v2: https://lore.kernel.org/io-uring/cover.1749214572.git.asml.silence@gmail.com/
  - Removed most of utility kfuncs and replaced it with a single
    helper returning the ring memory.
  - Added KF_TRUSTED_ARGS to kfuncs
  - Fix ifdef guarding
  - Added a selftest
  - Adjusted the waiting loop
  - Reused the bpf lock section for task_work execution

Pavel Begunkov (10):
  io_uring: rename the wait queue entry field
  io_uring: simplify io_cqring_wait_schedule results
  io_uring: export __io_run_local_work
  io_uring: extract waiting parameters into a struct
  io_uring/bpf: add stubs for bpf struct_ops
  io_uring/bpf: add handle events callback
  io_uring/bpf: implement struct_ops registration
  io_uring/bpf: add basic kfunc helpers
  selftests/io_uring: update mini liburing
  selftests/io_uring: add bpf io_uring selftests

 include/linux/io_uring_types.h               |   6 +
 io_uring/Kconfig                             |   5 +
 io_uring/Makefile                            |   1 +
 io_uring/bpf.c                               | 277 +++++++++++++++++++
 io_uring/bpf.h                               |  47 ++++
 io_uring/io_uring.c                          |  63 +++--
 io_uring/io_uring.h                          |  18 +-
 io_uring/napi.c                              |   4 +-
 tools/include/io_uring/mini_liburing.h       |  57 +++-
 tools/testing/selftests/Makefile             |   3 +-
 tools/testing/selftests/io_uring/Makefile    | 164 +++++++++++
 tools/testing/selftests/io_uring/basic.bpf.c |  81 ++++++
 tools/testing/selftests/io_uring/common.h    |   2 +
 tools/testing/selftests/io_uring/runner.c    |  80 ++++++
 tools/testing/selftests/io_uring/types.bpf.h | 136 +++++++++
 15 files changed, 900 insertions(+), 44 deletions(-)
 create mode 100644 io_uring/bpf.c
 create mode 100644 io_uring/bpf.h
 create mode 100644 tools/testing/selftests/io_uring/Makefile
 create mode 100644 tools/testing/selftests/io_uring/basic.bpf.c
 create mode 100644 tools/testing/selftests/io_uring/common.h
 create mode 100644 tools/testing/selftests/io_uring/runner.c
 create mode 100644 tools/testing/selftests/io_uring/types.bpf.h

-- 
2.49.0


