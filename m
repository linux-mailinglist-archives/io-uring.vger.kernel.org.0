Return-Path: <io-uring+bounces-11935-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id aP0SHk6ReGmirAEAu9opvQ
	(envelope-from <io-uring+bounces-11935-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 11:19:58 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EEFA92A6A
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 11:19:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 3EAAF3056334
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 10:15:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2962533BBB4;
	Tue, 27 Jan 2026 10:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fpcI1XBN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57FD23382EF
	for <io-uring@vger.kernel.org>; Tue, 27 Jan 2026 10:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769508877; cv=none; b=fyavLupb3TAd6I+7ISDcpFqAzGRzIDbTTx1mQN2PtzVlO7d5zFI94ykBfDsdEgs+HZ9BwTB11TcGqtoj1idOD0OXEGpwBwQfc6xrO2Q/bvulPhzY8EMo4XbeLox9J/ycc4Fkpyw3p9RR90Ztfh3g0+hctAvuZ2XIU3FNkxgSRZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769508877; c=relaxed/simple;
	bh=XWK1oThC0G1bvogR6IPv7QqDq36y7THv6q7Ut2sS4Ag=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=B6F2I0JaEmkrc45zDVJD/Gi8Y084lHZFpjkO/sjBM9P6mGy3jjPOqwTVzQItdQVgcR8gkq4Sy9fJh4jASSprmywpX81wey5unLcdX4QphRgTEF9PyqBi3nC9mp3Qi886owMaMDdMEOfcc4yt4W209gcMpNSXxqAcGQQA0X1GBTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fpcI1XBN; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-47fedb7c68dso55370985e9.2
        for <io-uring@vger.kernel.org>; Tue, 27 Jan 2026 02:14:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769508873; x=1770113673; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/4FvQHRBiEhUoBzRtCERgLc1sLFVyEqoxyKjPKRtz5A=;
        b=fpcI1XBNemcUWQuhNS0nozTC5nkFU41tKcu63cnLofjHQEYQPpvVXDGEi/EwUM5r+0
         OBVw5w4dmX8uXj4kYruaNcLqhe2mBRBjUsikixNKJXHpp88x4c+d3iHqHPe53win2z4Z
         iw0RrqDC/Lj+fCquFNyrH4/uiq3cPxJKqzry6HLbO7xKHVLYH+VXWvsRsPkOkL+JzkOs
         Bv5NBeyJoft49NM20GstmaShEahpuxryBMJECslA/RqdGLOQRXuxA7YZOrl/pTM+KCvD
         2bb40CAqNPDzb8wQ21g0r5xvpTIjb/fgL2z9pToB0wKFmcxGDH6r4g63XfJ4reD8hoNg
         aLZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769508873; x=1770113673;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/4FvQHRBiEhUoBzRtCERgLc1sLFVyEqoxyKjPKRtz5A=;
        b=kHZLE99BsRyYqdPIMldwsqlDYCGQ0ExgyKQaOiN7rG0Lu20r8V6i0pEkNTbs3WB0m1
         XfyOnpjXN7OQjIcfziubmXefKDbrvSZtLQ43NK0cJls4tNDQsbvP81SXIKWM/rhivfYN
         +yPbNQX+Eteq0sXyiZjB1jbpowOlx1Dn8st3mi7Pl6GZJnTio+RZ+Ou59Xcs56jgQq4s
         Zwt+/AOJz5hLxMncQMUPRUF77EYOuNv+vPQ/wWF+lIHystXkxPVcOe2kKv+JNZBkPqpN
         UaLDCl6b8vPmXPCVB4FefoNhpBZgptgXTIWNqROdIYzuoFd+qLNPkJb1DklTaWPTvw1+
         2/XQ==
X-Gm-Message-State: AOJu0YwPBEmSt+bY/1IAH84PHc8ztSY2zFLC9KTUod8gI39npPNYky9A
	AGZaJl2v4QZf+8jp/F3MkzutCKjz2A20MsOrT7njYXkKl1ieYQbao49G/iGCZy4W
X-Gm-Gg: AZuq6aLWrxCtCJNQMoN52uPNozgvW1PjhaAh4oP1bZlunejKwja/OEFzmD+Gt0yq4t7
	Z7veovueOqcZnxaiibXNN0Y+DFKiTCBgkn3LWILxCjJlI99f84uXE0l+j8h3EaW1WfhZPWFfZFQ
	RkRzEcfFJsYi3PC6GYTX29YQ5AqZ7kAI1zEjG5iw7eB4D+Xav8ADqie4LX/DgmEh0GiI0WOJ7Ft
	LSqvnkB1XsctMnamW73qzQgWsBRtXl0ENCD9krgQkBH5TGP2kwRVFBuuavanUHte1zlP2vO/MHH
	mPfyxP8UpOz8O0WIcstvw1tFlHqvtdnM+cFHxKjfxW9Hh4guXkAsqmFdxBcMkxp5m3cghjq7rED
	LhZfIBmw8onmFa7S3oU33RBU4jtzvDlZXi/yivvgXfKzic/FkaJbfcvEMsCKjLLF+ygKgr1XovL
	GOZYcWaTijEKXzav7bwfIkQf4i4hB9YM8KT6ryLDK1lllOqYyi9Twjd5EEmj2xf385XeJ1ORy+Y
	YLPTNRm6jao4Y52xw==
X-Received: by 2002:a05:600c:3113:b0:480:1c75:407c with SMTP id 5b1f17b1804b1-48069bfaaf6mr15553245e9.2.1769508872871;
        Tue, 27 Jan 2026 02:14:32 -0800 (PST)
Received: from 127.mynet ([2a01:4b00:bd21:4f00:7cc6:d3ca:494:116c])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-435b1c24acdsm38190407f8f.13.2026.01.27.02.14.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Jan 2026 02:14:32 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com,
	bpf@vger.kernel.org
Subject: [PATCH v4 0/6] BPF controlled io_uring
Date: Tue, 27 Jan 2026 10:14:04 +0000
Message-ID: <cover.1769470552.git.asml.silence@gmail.com>
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
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[gmail.com:+];
	TAGGED_FROM(0.00)[bounces-11935-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,vger.kernel.org];
	RCVD_TLS_LAST(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[asmlsilence@gmail.com,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_COUNT_FIVE(0.00)[5];
	NEURAL_HAM(-0.00)[-1.000];
	TO_DN_NONE(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	MID_RHS_MATCH_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 2EEFA92A6A
X-Rspamd-Action: no action

Note: I'll be targeting 7.1 as it's rc7 and it can use some
time to settle down.

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

Pavel Begunkov (6):
  io_uring: introduce callback driven main loop
  io_uring/bpf-ops: add basic bpf struct_ops boilerplate
  io_uring/bpf-ops: add loop_step struct_ops callback
  io_uring/bpf-ops: add kfunc helpers
  io_uring/bpf-ops: add bpf struct ops registration
  selftests/io_uring: add a bpf io_uring selftest

 include/linux/io_uring_types.h               |  10 +
 io_uring/Kconfig                             |   5 +
 io_uring/Makefile                            |   3 +-
 io_uring/bpf-ops.c                           | 265 +++++++++++++++++++
 io_uring/bpf-ops.h                           |  28 ++
 io_uring/io_uring.c                          |   8 +
 io_uring/loop.c                              |  88 ++++++
 io_uring/loop.h                              |  27 ++
 tools/testing/selftests/Makefile             |   3 +-
 tools/testing/selftests/io_uring/Makefile    | 143 ++++++++++
 tools/testing/selftests/io_uring/basic.bpf.c | 116 ++++++++
 tools/testing/selftests/io_uring/common.h    |   6 +
 tools/testing/selftests/io_uring/runner.c    | 107 ++++++++
 tools/testing/selftests/io_uring/types.bpf.h | 131 +++++++++
 14 files changed, 938 insertions(+), 2 deletions(-)
 create mode 100644 io_uring/bpf-ops.c
 create mode 100644 io_uring/bpf-ops.h
 create mode 100644 io_uring/loop.c
 create mode 100644 io_uring/loop.h
 create mode 100644 tools/testing/selftests/io_uring/Makefile
 create mode 100644 tools/testing/selftests/io_uring/basic.bpf.c
 create mode 100644 tools/testing/selftests/io_uring/common.h
 create mode 100644 tools/testing/selftests/io_uring/runner.c
 create mode 100644 tools/testing/selftests/io_uring/types.bpf.h

-- 
2.52.0


