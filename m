Return-Path: <io-uring+bounces-11762-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id A8FC6D38968
	for <lists+io-uring@lfdr.de>; Fri, 16 Jan 2026 23:44:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 05B6D3012EB6
	for <lists+io-uring@lfdr.de>; Fri, 16 Jan 2026 22:44:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0B75B30F924;
	Fri, 16 Jan 2026 22:44:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="JIWrvqu7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CF08270540
	for <io-uring@vger.kernel.org>; Fri, 16 Jan 2026 22:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768603442; cv=none; b=a97TykcYLFfwq8FYfbfZYYuskPOzDu1NhFQfTf1X+AGoveLGmWVoQ+/tCOatm2tesk4MpRw1459pJWwxfo2P0d22iQbhlJ7Z8NT0AUZwiPtRdlnMeui3yK3+W+CQGPxKyosdVYliCNZn/yshjfHJQ5KWF39gEjC7NhwpumxBRxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768603442; c=relaxed/simple;
	bh=Kzc93j7H6fLsuz9OsrUYyQ5IeZpDipafgMtqAmn6AMk=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=p5bg2IrxMe2uINadAb0qK7KnIUAFiVil+YN8nwK6S3W8LZgkkGOrhSYCEAzNysiYDY9K+ivBHtaF+xoIkUBdcE5Nzb/pIyCCkyKoXnIVcxpmE2tLj0zt0Ew8K0GD+hdJemBx6nVN6KuqtkHvwUo2TX4SOogsrdY9hrlp8j9PViE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=JIWrvqu7; arc=none smtp.client-ip=209.85.167.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-45c92df37fdso929279b6e.3
        for <io-uring@vger.kernel.org>; Fri, 16 Jan 2026 14:43:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768603438; x=1769208238; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=IFRIp0gYST6o7iLl/Jp0JdYZOlZJJ/yZJR/WMEGZh1Q=;
        b=JIWrvqu7a3qmmF/j6H92qEAKnGfdNuXiir5wITQ7x4FfMImCXPkVS5NcC7717nN8qk
         hhSaPDiNBytWQfcmTshhMdqIO2mKEqf6H5Avqxr/ITg19KTl1y+kSXpGJOviOJvktP/7
         HvRjUyKblFIpaJ3fgKUivNF2A+XSWkFFhH/jp7U+1dxcEwhEQvBllwS2b+JFi7gijIfX
         rA5pmefxr1LjhBLXy4vmmHwGYHh8JW08fpzSqGe8oh6z8c1jNmwOH8fUy7Hw1bBG/g/a
         D3AY5tug0+VTkY3dhJ+8tQQAjBtjGiejSyTrAdM91k7451QZ/UVspFeQJZs85ql9CyYf
         mbSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768603438; x=1769208238;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IFRIp0gYST6o7iLl/Jp0JdYZOlZJJ/yZJR/WMEGZh1Q=;
        b=PjSzq8XPZJHnTsrn62TlMb/KoVEnczgQB2d7KkPQDWyHA1SdXjv9m0Cr+YVQ5/FI1f
         bZqcRZNEbwXguFhR8IMf3319mFA2J2dXKQwYN4b+hvRqWP2AvISrct9F5LDQknapqX8a
         IRuVThT5AkQtADgvBEu6NgrjXS10iFL+iQk2Z0Pru3+bwYUe9fzcE0nDaW9Jvm7Kl06W
         c3NtH1nzl7mH5FIU5A3M8x4xQvaXTe7eow5Fv9MPTvIhBCmTh3sYPWCWmXR47XE48yPE
         aHlN+uCjYdpwvkeSGRI1Or/ERxQVQ8qVTajET0lXKDaXjzo0w9+cOpsE+Q8rixIOGzbM
         BbHA==
X-Gm-Message-State: AOJu0YwfWiOtGt20RwoSN2twUHU2PeBPdjCL1PBCRioxpOGTX/vmArXl
	rdqzgRkl1rtfKJgFgeGVg4mry581fVYq97XgtkuCV8pqcShNaOhedRJo2/kZ3nes01CeQpmb+7r
	ZTG00
X-Gm-Gg: AY/fxX5xlV4jvZU6jvRVaVxz3ES/tffJ3MzayFPN3Okk+kAku/r72tj9MLE/zSIKCXV
	JmAdaK8YbF1aIcqyEaEsBzpA3IvLWr+Tfb2FOKFcIXQ1HYJcNrMxRUlR0V3SBPWoSH8gxZIhpHj
	Zzz4t4Un4B/OoOQelUA2uQI2mf6OV9EOInJRIMZLWIPC5btWE3Dv426MB/iuT7SOgI95f2oMPfR
	mALSpq7Rz+QoUNtrT4MA9FN0Dpv/YtQ0Nug4wFp0bKZe6OgcFst8CQIMs5a0dP85rNfBCwLbaw5
	NZLVQtMOMaKRiKCZqPqql+vGrHgCgWrVyu/R596P/e8q2ZxxF+3rf17wfl0e8wM4hErnX7eHyZz
	jtOnEDhZZRg+kOj+i9sQpeplN+mVj44M86ldrpw+3sIyJFGI4SnpHpzekhqHrJ3zoTg1PtAev8Z
	WTE7Tl0MndtYRsUJsEtwWhqXqKSDwAWLkWymcWIBiP7wxUmX9ynD+VlBs8d+OpA9T735E=
X-Received: by 2002:a05:6808:344c:b0:450:d09a:8cc4 with SMTP id 5614622812f47-45c9c091406mr2018789b6e.38.1768603438589;
        Fri, 16 Jan 2026 14:43:58 -0800 (PST)
Received: from m2max ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-45c9dec9ebcsm1945098b6e.2.2026.01.16.14.43.57
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Jan 2026 14:43:58 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: io-uring@vger.kernel.org
Subject: [PATCHSET RFC v4] Inherited restrictions and BPF filtering
Date: Fri, 16 Jan 2026 15:38:37 -0700
Message-ID: <20260116224356.399361-1-axboe@kernel.dk>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi,

Followup to v3 here:

https://lore.kernel.org/io-uring/20260115165244.1037465-1-axboe@kernel.dk/

which has all the gory details. The main new thing in v4 is proper
support for stacking of BPF filters, when a task goes through fork.
These are referenced, and COW'ed if new filters are attempted installed
in the referenced filter.

Performance and functionality is otherwise the same. See the changelog
for more details.

Comments welcome! Kernel branch can be found here:

https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux.git/log/?h=io_uring-bpf-restrictions

and sits on top of for-7.0/io_uring.

Changes since v3:
- Move fork.c logic to an io_uring helper, io_uring_fork(), rather than
  open code it.
- Sort out the filter and filter table references, and drop the patch
  that made io_restriction dynamically allocated.
- Drop IORING_REGISTER_RESTRICTIONS_TASK, IORING_REGISTER_RESTRICTIONS
  can just get reused with fd == -1 like other "blind" reg opcodes.
- Split IORING_OP_SOCKET filter support patch out as a separate patch
- Fix a few style issues
- Do proper cloning of registered BPF filters, if a task is forked.
  These are done COW style, where initially a new task will just
  inherit the existing filter with a reference to it. If new filters
  are added in the new task, then the existing table is COW'ed.
- Drop ctx->bpf_restricted, just check for the presence of the filter.
- Drop various alloc helpers, not needed with other cleanups.
- Add and improve a bunch of comments.

 include/linux/bpf.h            |   1 +
 include/linux/bpf_types.h      |   4 +
 include/linux/io_uring.h       |  14 +-
 include/linux/io_uring_types.h |  16 ++
 include/linux/sched.h          |   1 +
 include/uapi/linux/bpf.h       |   1 +
 include/uapi/linux/io_uring.h  |  52 +++++
 io_uring/Makefile              |   1 +
 io_uring/bpf_filter.c          | 372 +++++++++++++++++++++++++++++++++
 io_uring/bpf_filter.h          |  46 ++++
 io_uring/io_uring.c            |  27 +++
 io_uring/io_uring.h            |   1 +
 io_uring/net.c                 |   9 +
 io_uring/net.h                 |   5 +
 io_uring/register.c            |  73 +++++++
 io_uring/tctx.c                |  40 +++-
 kernel/bpf/syscall.c           |   9 +
 kernel/fork.c                  |   5 +
 18 files changed, 667 insertions(+), 10 deletions(-)

-- 
Jens Axboe


