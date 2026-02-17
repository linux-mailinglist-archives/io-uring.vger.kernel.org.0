Return-Path: <io-uring+bounces-12285-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mGoxNXNSlGlFCgIAu9opvQ
	(envelope-from <io-uring+bounces-12285-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 17 Feb 2026 12:35:15 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3785314B6EA
	for <lists+io-uring@lfdr.de>; Tue, 17 Feb 2026 12:35:15 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 5728C30495CD
	for <lists+io-uring@lfdr.de>; Tue, 17 Feb 2026 11:33:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D12D53328E2;
	Tue, 17 Feb 2026 11:33:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Z1c34s+D"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E82733032F
	for <io-uring@vger.kernel.org>; Tue, 17 Feb 2026 11:33:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771328035; cv=none; b=szOm2vdaOwapInHBDqPJJx59OzmNif16gIMBI96zxOyA5eoM7NqhrbrowZ15Fr+MiRTAR8iJcVVvWLBd752zgWj6L1XHyQNXd96CdELntmvsvW/LfXSbzH1qMcdQfnIhx9APZxaWMQ8+oteRWPeuO6oYE7ch5Xtalh2Vr1iOxjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771328035; c=relaxed/simple;
	bh=wiqdQ0ogaikcpeYwtbNhgAlqC/mCmQjgsPHBNeJSXJM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ZT8Hpj52xpQD1PefWitxfrniaTtwVcl6pzHU3+STgTFq/M+3WRhzM28NmB3octCxbnaOc9InCz8rerxezce+AEX53TBm5yhWEVMryubvNo2mpfxbaSlEcFW4tUAibeZY/FUKJfdSCTly0usFMvmh9aK10GEJGpCdtR9WJXDxoh4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Z1c34s+D; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-436e87589e8so5024511f8f.3
        for <io-uring@vger.kernel.org>; Tue, 17 Feb 2026 03:33:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771328032; x=1771932832; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=R8Mjb2R5Fd9ejWzlBsoinpx5pR33b5ClXjbaNGQz1SI=;
        b=Z1c34s+DEzYqfz+wig5mUUysrxxkeh8mqRbmcprMS51+8ku94GIqrCrponvDSscvYZ
         67SUYGxUdz0QJkOmi7KDI2U5ZbqdUpd6o+HUdRmeSFu2HbApyXprb4fc6OSF3ThcTNux
         eW0lmNYd7ck/4glNuL4ORPkLRNmQxwPPVMkUVkZKkS2+SMQ32Ni52nsi8zhYJVHv86x1
         HQY5TvYiwiizEIIcSV5NHlnpnczoj2FJ1f+NGIvto4gAtp/qOYpNbZhP/AuCzdoELxnA
         dT1huUY6tYg6uyB5XviQDDpuaBPyVOh/7UOvHk+yqcDE2gqlE31u7evxYfElKL5wcebk
         M+3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771328032; x=1771932832;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R8Mjb2R5Fd9ejWzlBsoinpx5pR33b5ClXjbaNGQz1SI=;
        b=QYglGQg2jGj8+7QiWgap9Gq927iol2NE8avt5KFE1+f2e0V6NLTpvH8v8q0VHkQyPL
         Zc6YwV7EKrcsMeo32RhvcE6i0kjblLc/uvN7VlcVWQ61jPSYPwX+9eHyC4DzdKhNZVn4
         g5qLo2PEyDP+WpxzWLgBSoif3P7kep1rbU8zaWyldHw/Ws0cDLtsZmPSQHQzs7Jl/LZq
         zRJzB73WNI+bBDeBGoUV5qqkkjwlb8dCGEtHAFpimCa69EnPBou6DdLNOVJq8dfp41Mr
         YrD9igcQgQc3EaCWMRB5p8cvO0EKAcX1SpENpsPUkZtRmdLnbN0E9dTjIwCktw4V6bfu
         +jfA==
X-Gm-Message-State: AOJu0YyXdApy0t+j94MChUxZLyHZfyMDnSgDp5MtEMtguXeurbzcWy2N
	C2/FXJCQcWZWmyUKDUiipcozmaM2XaOHwnOxNt/wwWs7ERIulKQ3ZDp3/OiSqA==
X-Gm-Gg: AZuq6aKnUhSDh8vg9q9tCeu+VZLyHO7re2gSLDl96IOBBaSe5c/Nh6tKNihFviOuCbW
	e/2bRHIiFpiF0zW1i4EWEAu4tsSbZwytEsATRNLz1Vy2tRIdqNTgytiyxgqEVsjen9JVwtqGo6K
	tBFRxs4yNR3jQx86Ehi+OQpQXD1Rlcg9VYHE2JGIKZi9mi5UJWgVYAmdYwbpmoAPf0Hyretn1g9
	ajZoh3fsDWe85j90fdlHbTgoPx09fKyCOfklBCkwS9T0SpuH5QYGov07pDFudjbtt5R1R3wJc+Y
	oyRB0/Al0t+ckhMVWtSIWOmq2nW4gyTzwMzc3gkluUEdCiSfwdD40yaLKLPsHv6D0DLHzj02l3l
	ZhnaEhwN0Ynyz9wB03R1xUZmWQj0oyM0fjEQt3awBWU3NF0rLA3T/bacaJxOfgXTf3uG5/tfHVw
	Haqx/BbjD25UwlhjsNZZKsT3v4gNXFmR1KBiV4w8Z/M9bS/izukvWHjuW3vIYR0vMDLPlEJnKWX
	px+NEQO7J4nb5Zpub9EpEPQKvaB5g==
X-Received: by 2002:a05:6000:2881:b0:435:8aa0:a30c with SMTP id ffacd0b85a97d-4379791bbaemr26608747f8f.48.1771328031988;
        Tue, 17 Feb 2026 03:33:51 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43796ac800esm36258343f8f.27.2026.02.17.03.33.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Feb 2026 03:33:51 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	bpf@vger.kernel.org,
	axboe@kernel.dk,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: [PATCH v8 0/5] BPF controlled io_uring
Date: Tue, 17 Feb 2026 11:33:42 +0000
Message-ID: <cover.1771327059.git.asml.silence@gmail.com>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	TAGGED_FROM(0.00)[bounces-12285-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org,kernel.dk];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_FIVE(0.00)[5];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: 3785314B6EA
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

v8: - Remove an check that is "always true" to silence smatch
    - Kill unused variables from selftests

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
 io_uring/bpf-ops.c                            | 271 ++++++++++++++++++
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
 .../testing/selftests/io_uring/overflow.bpf.c |  51 ++++
 tools/testing/selftests/io_uring/overflow.c   |  82 ++++++
 tools/testing/selftests/io_uring/unreg.bpf.c  |  27 ++
 tools/testing/selftests/io_uring/unreg.c      | 113 ++++++++
 18 files changed, 1139 insertions(+), 2 deletions(-)
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


