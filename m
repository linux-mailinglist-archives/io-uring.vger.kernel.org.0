Return-Path: <io-uring+bounces-12430-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QHVDKmtBoGmrhAQAu9opvQ
	(envelope-from <io-uring+bounces-12430-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 26 Feb 2026 13:49:47 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 4941A1A5E3D
	for <lists+io-uring@lfdr.de>; Thu, 26 Feb 2026 13:49:47 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 08E0B30CA548
	for <lists+io-uring@lfdr.de>; Thu, 26 Feb 2026 12:48:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 464372D838C;
	Thu, 26 Feb 2026 12:48:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZiqqvAQp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE37D288C81
	for <io-uring@vger.kernel.org>; Thu, 26 Feb 2026 12:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772110130; cv=none; b=nM6UBCCUXdxLhVZqdXY1vBBdLM3AvQeClsE5r5SNA8My97RJuGNejL17zLRUEQOQzeMOdZcnXBBqNieGmL1WBLWtad0VD+gn0O5EBP+gcCdwO24WZxawnjDOKuwFLXgY3jqcfYBJmd0DPdGVALkkaQVTZs0FlYcZ2yh28D8hkZU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772110130; c=relaxed/simple;
	bh=bioIdntw+EbiCH62mI8wKIHqsyEz1Z+mpV8qZpW6E7k=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YzlZHpMBm8j/omMr3sACtVUmBhSIHs8yfNYDFT9kAX7va+sDPdl4UHn/sP1AKMqs7/M6/pNTWcMkXn7t5jxSbK2q6flFuupL72Q8HSo+6N6jwr4UJJ7wYHEKDlLoSjN8iVs0l073sv95sE7iUEUrxuJMD3OVPN/vjsv9M0zDPyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZiqqvAQp; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-48329eb96a7so5879025e9.3
        for <io-uring@vger.kernel.org>; Thu, 26 Feb 2026 04:48:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772110127; x=1772714927; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Zb02RlG515wD0Bxc0e7IkiTY4DFrs2fLfp44nwOveIE=;
        b=ZiqqvAQp/7a55IdN3FMXmgFdehWLdjKxM7ZOMzRrQKFDKAAVXRaQkE6DtRFdMC1nNq
         sEFMeHU0ej4l1bO9/gjcqW8c3kMbOWX43fNdbnY7xgvD9B5/W9hThvzKOuN8WSJJTqxV
         KDqXhGia9Ywy7FiRnLJ66KBBdpQH8CoPF18CxnaGxvwf5Kto9LlVHWTJ35f0KBzy1Daa
         EuCK6O4XBN3pnMPw/g5qWWnH7XJyMF6eXF3X72qGMJiRIqbwCi6oHMj9pYqrwXiITsaD
         nKI5GJURzz06Rq8PdDzyaNr/gmp0+tTpv6+4/nsdSQm4QwsfvuC6XF/gnXtBetyo80WS
         darw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772110127; x=1772714927;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zb02RlG515wD0Bxc0e7IkiTY4DFrs2fLfp44nwOveIE=;
        b=Lx+5QlINtVqQPgxwXlAXedwxvRDUfArfEie8+Hs44s/XaeQYXK+falwJ6G6JYn1Ts/
         y6zc/PFi67P4PpX7x1OrvsjVijTsOFQAwyIy2I7S+S/SxJhCZBaCKMb1UtlfUEzrGW3+
         2G7Taor57GqA8V+4h6gzU2PEmwERm1ID+WEuBWzHG++MmqiyfyJSHnOHuGAYIKTJSg2c
         pMzpgHTy3FJzN4uM/2U232l/9CmGjRTTAToL9wC7+tuqthlBrztE3q1oPFdXbHNiJF7P
         b4w1nk4TxPixEDCdB+sBhONFj2lKltrRxxeY4O4RAyPlBfIjAEHM1PJDLJIhEJeLePoU
         aAPw==
X-Gm-Message-State: AOJu0YyN4nUoFX+bPBIBiC8LXquhmACww6DSewiIINgUp7KTm2Ndc0oV
	jGImq7Vk4U+ZxNDqItJT55sjkHfADMw47XJbderPbYvikmu385OxWj3tI6VyIQ==
X-Gm-Gg: ATEYQzyT6CqM99wKbVSCt/BK1APxY8fH/Fqt6a0tNGAjLS4n6q5fPJw1enrCCfktcOc
	9z88qlRVKD6fKyNNN06xVRGT8NonYUki4nlyWyYFksILGLdpxyFsURhQYjBSN2/pn+rtliCkZ0S
	W9psuK7z+XnIFxENGevzM9jkXS7xxlGFb70ovwhCanLo0q4NFh+pk3K+gkaEkeLJ2SWZOa1hMRG
	4ejmRouTfgHYUlCs9ltGQwJCCUdbFrT6x3iNIc9LLGz7r3El7RaBEm2NgC/1d9rVXFo98Zl/kwD
	hs3IzJBFdocHbL6+wpdD+Lavg+4LjuJdU/eQ8f1pc5hxszxChiSRA4bHpmL0VxGObh5vjuAbf7C
	heHMlZ9YSNs5PmFO1g6C/LPF6LzD66fb0BhW0OvWUQo3SVixOI0ps0+JudxI2FkWN3SKUazYxbV
	eulLWleMXc+j51W8ZFtLz8iqAf0mYPSa54DF8lvAgYGpLZG0iK1YNZ7MNP856G/N/1Bmcgf/GaK
	pp4EssNpo2b33OKZk+b
X-Received: by 2002:a05:600c:1d15:b0:47e:e8c2:905f with SMTP id 5b1f17b1804b1-483a95bc0cbmr294148585e9.8.1772110126619;
        Thu, 26 Feb 2026 04:48:46 -0800 (PST)
Received: from 127.com ([2620:10d:c092:600::1:2ab0])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43970d4c977sm43734576f8f.32.2026.02.26.04.48.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 04:48:46 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	bpf@vger.kernel.org,
	axboe@kernel.dk,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>
Subject: [PATCH v10 0/4] BPF controlled io_uring
Date: Thu, 26 Feb 2026 12:48:37 +0000
Message-ID: <cover.1772109579.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.53.0
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
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12430-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org,kernel.dk];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	TO_DN_SOME(0.00)[];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	MID_RHS_MATCH_FROM(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[5];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_FIVE(0.00)[5];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 4941A1A5E3D
X-Rspamd-Action: no action

Introduces a way to override the standard io_uring_enter syscall
execution with an extendible event loop, which can be controlled
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

v10:
    - Remove internal wrapper struct around loop params for now
    - Improve nr_wait checks
    - Kill selftests

v9: - Update mini_liburing
    - Clean up the nop test, bound the CQ processing by a separate
      constant and not CQ_ENTRIES.
    - Add helpers for sharing code b/w examples
    - Enable IORING_SETUP_SQ_REWIND
    - Use io_uring regions for parameter passing.

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

Pavel Begunkov (4):
  io_uring: introduce callback driven main loop
  io_uring/bpf-ops: implement loop_step with BPF struct_ops
  io_uring/bpf-ops: add kfunc helpers
  io_uring/bpf-ops: implement bpf ops registration

 include/linux/io_uring_types.h |  10 ++
 io_uring/Kconfig               |   5 +
 io_uring/Makefile              |   3 +-
 io_uring/bpf-ops.c             | 270 +++++++++++++++++++++++++++++++++
 io_uring/bpf-ops.h             |  28 ++++
 io_uring/io_uring.c            |  13 ++
 io_uring/loop.c                |  91 +++++++++++
 io_uring/loop.h                |  27 ++++
 io_uring/wait.h                |   1 +
 9 files changed, 447 insertions(+), 1 deletion(-)
 create mode 100644 io_uring/bpf-ops.c
 create mode 100644 io_uring/bpf-ops.h
 create mode 100644 io_uring/loop.c
 create mode 100644 io_uring/loop.h

-- 
2.53.0


