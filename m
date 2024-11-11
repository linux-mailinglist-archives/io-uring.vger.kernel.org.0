Return-Path: <io-uring+bounces-4586-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id DBFBB9C363F
	for <lists+io-uring@lfdr.de>; Mon, 11 Nov 2024 02:50:10 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 92D101F2107A
	for <lists+io-uring@lfdr.de>; Mon, 11 Nov 2024 01:50:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D10C2C125;
	Mon, 11 Nov 2024 01:50:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Tkf+AunN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FBA7191
	for <io-uring@vger.kernel.org>; Mon, 11 Nov 2024 01:50:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731289806; cv=none; b=FWBzkGPs6tWEUhFetT6mFqaULlKU57V1Pj1eNuyGbrFSKUx5cjAoxIBEG6EfROOB7lkEDo4SAp2UHBdx9GqxS0ELcfnjckxUFW/FGKa4NpXyzXDVuHdfM4vG61Du/REPT9HgcyBRYOG8k8DbMyyUnS3Fee7EebrOKwCnUIHxfXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731289806; c=relaxed/simple;
	bh=sAbPBX6B4Zr8i43mpk2NKMJTxpyZrBVqjGZF+4CxNTA=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=kJESaj3d372MEcRUUXhzRqfWUpQk3uqQF035Y+MUiFHpgkxq5R9BJDxXlKDliLfh85PjeBIQVF6hFwegqAZhzP3puNQtHQozHcwo5XbFHALlJ9bsEh2Yxeddlm3NG7KneqcSURGVFb2UgglDr7LEf0hlmQUlGLJvQgS78cXd2rM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Tkf+AunN; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-43161e7bb25so31855115e9.2
        for <io-uring@vger.kernel.org>; Sun, 10 Nov 2024 17:50:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731289803; x=1731894603; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=xP2cYe2NkDCWGiW/TphdL/sbfheVZKs3h02mA+7NbUg=;
        b=Tkf+AunNzqwl/CM7r9wCUYS5o13ddplIv+seUUfHV00IkI5LXUJi9YiDeS/SMYX0Lx
         M+ZTzVCIFYxi7jwoqSZpUcGn2+gtec53s84YHhOldN6rd3ewq8OtU0pKic5BBdYyk5ms
         TZhFHKbPJK71e+KbiaJ+Jm9O1ZhK4tHoYhxm24D8pnQ6d06C+i1mXY11V1icp8MFpCYZ
         1tGeAksF5nWR6IT8q163xFU8s1OOLd6lS5wDLL9MsHgFdMhxPuSl8jfVc8Upblimwv/h
         Y1J266Kch6pgzNuKYA2dWa25Epwhw4tRBcWW2pKd/EtmxMhftXyjWAwwP7sUHW0HHgrc
         7ZIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731289803; x=1731894603;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xP2cYe2NkDCWGiW/TphdL/sbfheVZKs3h02mA+7NbUg=;
        b=LDqssKYClReoc/iMsqv86ZA8jE4i7Ml9PLe+llSgzjDCj1E8lMdWJxpn7XCu/l7ndk
         Ruo9cQM9wNfD6R+uJSeELhfvLSqddDqP1x3LDW9+55Fnza2Dwj+wT7XFm/bbF0xFsUcZ
         vlVO2RVOMA77/k1qvqe5GUz62NiRqIikqB69oH/1jdsXsontxQduNpXE9njx486SbdQd
         TDXYLv6eXIm5zO/8LgqxYaohSLP12ZYSZan5gDZr5pDiZD0/v5/i/e/0H0O6pFCIgyIL
         48T3xbytgdb7PJMYmcRDyGVbdcrf2F1G2ORBo1fFgRwwaF4R08HZ9FY2nh+FjTCEx+W1
         mWWQ==
X-Gm-Message-State: AOJu0YxGcMc5qH3S7TRgMbwx5LmiLrSkokL9fCfSGDACThyOdzx9wg/w
	NSn1qP38Nf2RgSyo//q1faKF75BWtyN2NOrMmRARli/uWhf/bocflK0WKg==
X-Google-Smtp-Source: AGHT+IF/FEhjBTSe4TzK9L2YFP4mgs4QChsRpCyJi2G6YgxrzXaV5zMf51EWzoBB2fkxdFF7Yooj4A==
X-Received: by 2002:a05:600c:3c97:b0:431:5632:4497 with SMTP id 5b1f17b1804b1-432b75167camr99406415e9.26.1731289802809;
        Sun, 10 Nov 2024 17:50:02 -0800 (PST)
Received: from 127.0.0.1localhost ([85.255.234.98])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-432b05c18e0sm161494685e9.28.2024.11.10.17.50.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 10 Nov 2024 17:50:02 -0800 (PST)
From: Pavel Begunkov <asml.silence@gmail.com>
To: io-uring@vger.kernel.org
Cc: asml.silence@gmail.com
Subject: [RFC 0/3] Add BPF for io_uring
Date: Mon, 11 Nov 2024 01:50:43 +0000
Message-ID: <cover.1731285516.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

WARNING: it's an early prototype and could likely be broken and unsafe
to run. Also, most probably it doesn't do the right thing from the
modern BPF perspective, but that's fine as I want to get some numbers
first and only then consult with BPF folks and brush it up.

A comeback of the io_uring BPF proposal put on top new infrastructure.
Instead executing BPF as a new request type, it's now run in the io_uring
waiting loop. The program is called to react every time we get a new
event like a queued task_work or an interrupt. Patch 3 adds some helpers
the BPF program can use to interact with io_uring like submitting new
requests and looking at CQEs. It also controls when to return control
back to user space by returning one of IOU_BPF_RET_{OK,STOP}, and sets
the task_work batching size, i.e. how many CQEs to wait for it be run
again, via a kfunc helper. We need to be able to sleep to submit
requests, hence only sleepable BPF is allowed. 

BPF can help to create arbitrary relations between requests from
within the kernel and later help with tuning the wait loop batching.
E.g. with minor extensions we can implement batch wait timeouts.
We can also use it to let the user to safely access internal resources
and maybe even do a more elaborate request setup than SQE allows it.

The benchmark is primitive, the non-BPF baseline issues a 2 nop request
link at a time and waits for them to complete. The BPF version runs
them (2 * N requests) one by one. Numbers with mitigations on:

# nice -n -20 taskset -c 0 ./minimal 0 50000000
type 2-LINK, requests to run 50000000
sec 10, total (ms) 10314
# nice -n -20 taskset -c 0 ./minimal 1 50000000
type BPF, requests to run 50000000
sec 6, total (ms) 6808

It needs to be better tested, especially with asynchronous requests
like reads and other hardware. It can also be further optimised. E.g.
we can avoid extra locking by taking it once for BPF/task_work_run.

The test (see examples-bpf/minimal[.bpf].c)
https://github.com/isilence/liburing.git io_uring-bpf
https://github.com/isilence/liburing/tree/io_uring-bpf

Pavel Begunkov (3):
  bpf/io_uring: add io_uring program type
  io_uring/bpf: allow to register and run BPF programs
  io_uring/bpf: add kfuncs for BPF programs

 include/linux/bpf.h               |   1 +
 include/linux/bpf_types.h         |   4 +
 include/linux/io_uring/bpf.h      |  10 ++
 include/linux/io_uring_types.h    |   4 +
 include/uapi/linux/bpf.h          |   1 +
 include/uapi/linux/io_uring.h     |   9 ++
 include/uapi/linux/io_uring/bpf.h |  22 ++++
 io_uring/Makefile                 |   1 +
 io_uring/bpf.c                    | 205 ++++++++++++++++++++++++++++++
 io_uring/bpf.h                    |  43 +++++++
 io_uring/io_uring.c               |  16 +++
 io_uring/register.c               |   7 +
 kernel/bpf/btf.c                  |   3 +
 kernel/bpf/syscall.c              |   1 +
 kernel/bpf/verifier.c             |  10 +-
 15 files changed, 336 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/io_uring/bpf.h
 create mode 100644 include/uapi/linux/io_uring/bpf.h
 create mode 100644 io_uring/bpf.c
 create mode 100644 io_uring/bpf.h

-- 
2.46.0


