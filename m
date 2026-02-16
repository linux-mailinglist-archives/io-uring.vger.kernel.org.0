Return-Path: <io-uring+bounces-12260-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UN/0HFdLk2mi3AEAu9opvQ
	(envelope-from <io-uring+bounces-12260-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 17:52:39 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DD8EE1466F1
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 17:52:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 0BCEA3029A7F
	for <lists+io-uring@lfdr.de>; Mon, 16 Feb 2026 16:51:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 498BB2C11DB;
	Mon, 16 Feb 2026 16:51:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CbDr5IBl"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D90951465B4
	for <io-uring@vger.kernel.org>; Mon, 16 Feb 2026 16:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771260710; cv=none; b=IANqRGowdkKBoLGGxWlCkyh/EMHjFYeZljK9WcaAXWK8gEu+vDDjPH0FPtNz/kMc4iAp9ZxU8bf3pbJyJMUqQs8jlAfhEya5p+QA/NF2f0gSlKs2oUj5il/MvBHRL+pGc2wSwhPXW6YRZaCaThqfnMcdLvlzL93BePW9zFju5f0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771260710; c=relaxed/simple;
	bh=j9KUWJcfESA1mWLvPmWh6+nd7/OXBlZmzlO5YjHL3Ng=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=b78X21DQsy2lry5WGqQ/nkb+E/xFoonf744G9kspViQQAGAoX2adN5Rb0D1p6Wouaxfh/IPOBYir6GJdkxuafuLCy1HDVXooweC6N25X0Y6d5CPmR+HGr22knsu1/us006kDpzqcAAtuSGb1OFiAxju659QVjj5ptYTdy0wY7GA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CbDr5IBl; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-4359249bbacso3642897f8f.0
        for <io-uring@vger.kernel.org>; Mon, 16 Feb 2026 08:51:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771260707; x=1771865507; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=NDCriHrzn/JYKG01GPjMsow2FFrJxeUjg2GZhuyFBCw=;
        b=CbDr5IBlgpa7qJEBDHoevFpIGWLQkp5j4dTcGtSy1SxrW1n/5bFJGwS9KWlBWG5+og
         47pqc3wYlwDL2cjXL15SBFsSL8zxtXp26dqeZdBMfLx1wxaGLWF9+RHJONDPQoz96V3p
         us8xbLBosoYHR1yCV3iSyNgLMqwXLF/lHHXzsnb7hOvQdiaGkJEA1weokyLxA6/rY0WQ
         kNVCfEFQL78LpD3brrUyIferLkYWq28zskiNK0/NjBjE6sYvvS4oNh97oTvuZCLq8N88
         R9YRejlVSirHPC9/mfRsn8ra0cizlY/76uMeGuh1SAfgu9FpxFX9M4y6I4D6V2L9+R7F
         PaaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771260707; x=1771865507;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NDCriHrzn/JYKG01GPjMsow2FFrJxeUjg2GZhuyFBCw=;
        b=BA3QgESNIj6pviJj0y/HWMwwfJ351vk7IgAreLxs26bEHmJ30hZwMMv5Blyg4sN0hV
         lh99Tnfl4nv70TUi22K8xkzyDCPVCWPA7GSbeHt8FVwxUDT1j9CBfQ6i4aSGgKJ+DQ4u
         uQxlyr2chIWmI5TMdmtSY12c+7JNlSm2PRhQ425q6JVxcVbiPrh6Vu8ipDLQNrdu+1xy
         syuks266hpS1oUtOMsSc+q5SVWJ8UHqSyW4Ek22uIdVVexBTG6gbLfilQpZVApNhZj6i
         DHuMWYm757RMW3gM7StEtVNuMCATGGSQGa2n3b4KWvmqtPmKezXXJ7efvoyaKZEiUggY
         06QA==
X-Gm-Message-State: AOJu0YzuXgpFdwEypBrsUjdgtYSoiMcjuIHM04wPlrsMbU5PdP5h1bFo
	coBz6gV3xu10ZRMxRZ5wF8Txv79sIFEMXCteGuHXolOr+NgrqOWiPoxh3TBPisY5
X-Gm-Gg: AZuq6aIqpAyHYtor/DGfJt0dd5nkJkWa9+rTld0x5klDTNbRdE/kWclRHVYNE4z+Qjx
	1IjeDwZvf3VJ/vDGMKRr18VA64qf7Rs3uoWuITeQKsUv+JuXhOzkqk+dZKPgk6lnZ8yTVC9vx+S
	u4D+H0HOCu5/XJP+wADWHvZwkanrLKy4FWv197E/wa3TK45BXAVa9G25JYhxNoMyl1mmnRVm8I2
	jtIi+9nEudByMGRPHHv3uqdgFRKoI5/LbBdlLV1Km0BjuIzjV2HatANXychUeFGN6EgrWhz5zCa
	bDfX/g4uuT3sfXb3YpeB9cxTO9kWqm1/C9beuf6LX3lwGt3nkll/sRtVbefd3ePxexdUIhCVGp3
	+wrNKzwMJ3gIYhpJfdPCPY2M6EgIZQz7Fk0kLXFFas+5KJ9Cd1woEPfWz3nLXb6JsL91mQ/MoRF
	h08SgXh83cRdpIA4u5NNWPZQCRI2ApOyB5xWmusWiGgrHU5j4+lqC5y7UmjcqBONADKosbin/g6
	4ZXaCNU
X-Received: by 2002:a05:600c:40c4:b0:47d:403a:277 with SMTP id 5b1f17b1804b1-48378f062b0mr112443335e9.4.1771260706643;
        Mon, 16 Feb 2026 08:51:46 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:c3fa])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4837b64b08bsm76454255e9.6.2026.02.16.08.51.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Feb 2026 08:51:46 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	bpf@vger.kernel.org,
	axboe@kernel.dk,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: [PATCH v7 0/5] BPF controlled io_uring
Date: Mon, 16 Feb 2026 16:51:21 +0000
Message-ID: <cover.1771260487.git.asml.silence@gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12260-lists,io-uring=lfdr.de];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org,kernel.dk];
	FREEMAIL_FROM(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[gmail.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: DD8EE1466F1
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

v7: - Fix CQ overflow flushing deadlock and add a selftest

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
 io_uring/io_uring.c                           |  13 +
 io_uring/loop.c                               |  97 +++++++
 io_uring/loop.h                               |  27 ++
 io_uring/wait.h                               |   1 +
 tools/testing/selftests/Makefile              |   3 +-
 tools/testing/selftests/io_uring/Makefile     | 162 +++++++++++
 tools/testing/selftests/io_uring/common.h     |   7 +
 .../selftests/io_uring/nops_loop.bpf.c        | 131 +++++++++
 tools/testing/selftests/io_uring/nops_loop.c  | 110 +++++++
 .../testing/selftests/io_uring/overflow.bpf.c |  52 ++++
 tools/testing/selftests/io_uring/overflow.c   |  82 ++++++
 tools/testing/selftests/io_uring/unreg.bpf.c  |  27 ++
 tools/testing/selftests/io_uring/unreg.c      | 113 ++++++++
 18 files changed, 1141 insertions(+), 2 deletions(-)
 create mode 100644 io_uring/bpf-ops.c
 create mode 100644 io_uring/bpf-ops.h
 create mode 100644 io_uring/loop.c
 create mode 100644 io_uring/loop.h
 create mode 100644 tools/testing/selftests/io_uring/Makefile
 create mode 100644 tools/testing/selftests/io_uring/common.h
 create mode 100644 tools/testing/selftests/io_uring/nops_loop.bpf.c
 create mode 100644 tools/testing/selftests/io_uring/nops_loop.c
 create mode 100644 tools/testing/selftests/io_uring/overflow.bpf.c
 create mode 100644 tools/testing/selftests/io_uring/overflow.c
 create mode 100644 tools/testing/selftests/io_uring/unreg.bpf.c
 create mode 100644 tools/testing/selftests/io_uring/unreg.c

-- 
2.52.0


