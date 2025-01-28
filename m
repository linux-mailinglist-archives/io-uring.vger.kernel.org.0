Return-Path: <io-uring+bounces-6151-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id F1854A20B61
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2025 14:39:51 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 21CBB1883E9D
	for <lists+io-uring@lfdr.de>; Tue, 28 Jan 2025 13:39:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 903DC1A9B34;
	Tue, 28 Jan 2025 13:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="Q+JIiPXn"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA8A61A725A
	for <io-uring@vger.kernel.org>; Tue, 28 Jan 2025 13:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738071581; cv=none; b=aKtJO/f8MJufbXHBvc7irWMe1OZywPvTj69kvNxJcxMSUsjuDXfrhnF7Mg76a1fK9UL0d14b2J1tTzgzAyyYJz/dbO3FrqLOtLjHUCmVN9heUBAqrY3cSbocun8w4dNIBKoENz3ZSzkMFyH1oDTLNfJUJxMPMTNAeGbnrbrrgOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738071581; c=relaxed/simple;
	bh=K0chwOk8j+gfblQqMSn8zaQQwXrnqJlL2AW5smVHg8Q=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=mSv+85e8dYx1e4KtZbfKX+fWPU8AxK0V7x/NK9l7QdTI7q34+dpEi8wjevANCnbi5/J15P9sQsxTiq6ttNouEENfK5absIGB/Op1vvCw9+WrCsZjXo+PEvXRt65+KWpMKCRCYHRxxk5WBzH+jlu3m0BIRdFXYrOKNgIihFiwR30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=Q+JIiPXn; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-385d7f19f20so2888707f8f.1
        for <io-uring@vger.kernel.org>; Tue, 28 Jan 2025 05:39:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1738071576; x=1738676376; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=hK6gm4w3aip1p6X/TmteESgDCFv0ITdAvMjv3TFp//Y=;
        b=Q+JIiPXnE8L7CrxQrda/qLx8Kh57ysVoRMzz12yQfNw5Dk0gIIwodbAFoxtZh3TQab
         hl9L0lZkj7e0N8+RN+zo7U1b/dCmh6hY08HjPMoa5/oEX6ZE5Y3QiGuT34ywfVdvidMC
         G7bTuBY5D4vOOP6v8MibWARv9yU81I//Nj1r+eZIWfUFHpgHheKVflXkvoixbfs3zz85
         vNFI2LAf5Z1jdJMxBXXWMjkyUVVHWmbgY1z5JbfQvCOLTA2bjiiCh68xAEWBlau5kZKR
         oZaERXVOWINVKYa6H/alMV15ekvre5JPRt21e43q8xa+aNgYZd1340cctFKgOpXmAHYK
         WdyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738071576; x=1738676376;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=hK6gm4w3aip1p6X/TmteESgDCFv0ITdAvMjv3TFp//Y=;
        b=VM8ko3OSWV192CXlDpVLCgxnTflWL8XJYDIZcGTVU+XH9xf1qLXYipvxMdlU5Rv80W
         6nItRM3nkH+p/gJNOLDCD3mlIoGt4yI4y4tfacudQ6Uag5V6Jjuoewy8Y1Sbv/Ig2pu/
         OyaHehIV+tl+Dwq7/15Iaqzk35atq0nXqX8Uqe0Dm8771amS6pMT2vUfNuNP44gHr7xR
         YK6n/eCSKN/GA7t0255qTwjlk/f6mdfQbkIdw+Tjusvp48VtsWb7JBaewpcDNBLc6mfQ
         g9NDjreS5wAxo5SLT3a2kN+n1wVJLngSy0oLfyjL1jE3qDFwUXYaHRDuyoRKx5ags0L/
         u6Aw==
X-Forwarded-Encrypted: i=1; AJvYcCVho4+Cvz3kegJmMejSHpxARuuP4CJS5lAVNhhdQh89Fjuy1nQ8uK4fyE5OFnOvDaX1UtIAS6oM8g==@vger.kernel.org
X-Gm-Message-State: AOJu0YwHWUMowY1EnUDYVtqAdfbIxj56MKVi/EzERSeH5vMstpyKLWu+
	suS+n/5q12cz2OQxWVboNxuaTmLlem4uRtiF614JSSGfNhw4vuv6mchCzCqGjxvXEksnnzo591c
	Zjd8=
X-Gm-Gg: ASbGncuv28mc30mIJAwrf1BxmORv29h9zz7XVZ8eYxYKhfWlxJ2sEN/iqhkkfn7qGly
	no5mY4y81FWvhRsrR3uHD3M1ghYtfVZ+xsssbUdg7nLJ/PWEImehaYbKmxk4KQdiBxLp9uuhpo2
	NemISWr5POkJlqGy3TjG5uNXg0jEZgP3mEIivZ7Lnc6UbfrUR/vVzUSVTuEqg9NgVSkOX/j7OP6
	W+EBCfv+dMXDLqeJdsQ1B3D0XvXSgWe/DbZFk7N7Y/sY0qrDcVDgOH1QMSQJOGGZYaKzxexpX/i
	0G4Ml0zQj16JfnuVLj3xcOjwk0jH6HLiB4fl60giWn6CydS2GQSORRP8sglcGALSiwbRtfM/0U+
	J+r0g4uAoZAlE68Q=
X-Google-Smtp-Source: AGHT+IEa5+xB0pJnhusdcQsnmAOsVGLJFO6EMVx0QymFEmPYEr1LFSe9P9cZFAeEoCBOIOfrrx0nvQ==
X-Received: by 2002:adf:a1cc:0:b0:38a:a074:9f3c with SMTP id ffacd0b85a97d-38bf5663dbcmr35768742f8f.16.1738071576010;
        Tue, 28 Jan 2025 05:39:36 -0800 (PST)
Received: from raven.intern.cm-ag (p200300dc6f2b6900023064fffe740809.dip0.t-ipconnect.de. [2003:dc:6f2b:6900:230:64ff:fe74:809])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38c2a1bb02dsm14160780f8f.70.2025.01.28.05.39.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jan 2025 05:39:35 -0800 (PST)
From: Max Kellermann <max.kellermann@ionos.com>
To: axboe@kernel.dk,
	asml.silence@gmail.com,
	io-uring@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Max Kellermann <max.kellermann@ionos.com>
Subject: [PATCH 0/8] Various io_uring micro-optimizations (reducing lock contention)
Date: Tue, 28 Jan 2025 14:39:19 +0100
Message-ID: <20250128133927.3989681-1-max.kellermann@ionos.com>
X-Mailer: git-send-email 2.45.2
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

While optimizing my io_uring-based web server, I found that the kernel
spends 35% of the CPU time waiting for `io_wq_acct.lock`.  This patch
set reduces contention of this lock, though I believe much more should
be done in order to allow more worker concurrency.

I measured these patches with my HTTP server (serving static files and
running a tiny PHP script) and with a micro-benchmark that submits
millions of `IORING_OP_NOP` entries (with `IOSQE_ASYNC` to force
offloading the operation to a worker, so this offload overhead can be
measured).

Some of the optimizations eliminate memory accesses, e.g. by passing
values that are already known to (inlined) functions and by caching
values in local variables.  These are useful optimizations, but they
are too small to measure them in a benchmark (too much noise).

Some of the patches have a measurable effect and they contain
benchmark numbers that I could reproduce in repeated runs, despite the
noise.

I'm not confident about the correctness of the last patch ("io_uring:
skip redundant poll wakeups").  This seemed like low-hanging fruit, so
low that it seemed suspicious to me.  If this is a useful
optimization, the idea could probably be ported to other wait_queue
users, or even into the wait_queue library.  What I'm not confident
about is whether the optimization is valid or whether it may miss
wakeups, leading to stalls.  Please advise!

Total "perf diff" for `IORING_OP_NOP`:

    42.25%     -9.24%  [kernel.kallsyms]     [k] queued_spin_lock_slowpath
     4.79%     +2.83%  [kernel.kallsyms]     [k] io_worker_handle_work
     7.23%     -1.41%  [kernel.kallsyms]     [k] io_wq_submit_work
     6.80%     +1.23%  [kernel.kallsyms]     [k] io_wq_free_work
     3.19%     +1.10%  [kernel.kallsyms]     [k] io_req_task_complete
     2.45%     +0.94%  [kernel.kallsyms]     [k] try_to_wake_up
               +0.81%  [kernel.kallsyms]     [k] io_acct_activate_free_worker
     0.79%     +0.64%  [kernel.kallsyms]     [k] __schedule

Serving static files with HTTP (send+receive on local+TCP,splice
file->pipe->TCP):

    42.92%     -7.84%  [kernel.kallsyms]     [k] queued_spin_lock_slowpath
     1.53%     -1.51%  [kernel.kallsyms]     [k] ep_poll_callback
     1.18%     +1.49%  [kernel.kallsyms]     [k] io_wq_free_work
     0.61%     +0.60%  [kernel.kallsyms]     [k] try_to_wake_up
     0.76%     -0.43%  [kernel.kallsyms]     [k] _raw_spin_lock_irqsave
     2.22%     -0.33%  [kernel.kallsyms]     [k] io_wq_submit_work

Running PHP script (send+receive on local+TCP, splice pipe->TCP):

    33.01%     -4.13%  [kernel.kallsyms]     [k] queued_spin_lock_slowpath
     1.57%     -1.56%  [kernel.kallsyms]     [k] ep_poll_callback
     1.36%     +1.19%  [kernel.kallsyms]     [k] io_wq_free_work
     0.94%     -0.61%  [kernel.kallsyms]     [k] _raw_spin_lock_irqsave
     2.56%     -0.36%  [kernel.kallsyms]     [k] io_wq_submit_work
     2.06%     +0.36%  [kernel.kallsyms]     [k] io_worker_handle_work
     1.00%     +0.35%  [kernel.kallsyms]     [k] try_to_wake_up

(The `IORING_OP_NOP` benchmark finishes after a hardcoded number of
operations; the two HTTP benchmarks finish after a certain wallclock
duration, and therefore more HTTP requests were handled.)

Max Kellermann (8):
  io_uring/io-wq: eliminate redundant io_work_get_acct() calls
  io_uring/io-wq: add io_worker.acct pointer
  io_uring/io-wq: move worker lists to struct io_wq_acct
  io_uring/io-wq: cache work->flags in variable
  io_uring/io-wq: do not use bogus hash value
  io_uring/io-wq: pass io_wq to io_get_next_work()
  io_uring: cache io_kiocb->flags in variable
  io_uring: skip redundant poll wakeups

 include/linux/io_uring_types.h |  10 ++
 io_uring/io-wq.c               | 230 +++++++++++++++++++--------------
 io_uring/io-wq.h               |   7 +-
 io_uring/io_uring.c            |  63 +++++----
 io_uring/io_uring.h            |   2 +-
 5 files changed, 187 insertions(+), 125 deletions(-)

-- 
2.45.2


