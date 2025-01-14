Return-Path: <io-uring+bounces-5855-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A5C5A10D57
	for <lists+io-uring@lfdr.de>; Tue, 14 Jan 2025 18:17:27 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DE8653AAE7D
	for <lists+io-uring@lfdr.de>; Tue, 14 Jan 2025 17:17:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3D2381D5142;
	Tue, 14 Jan 2025 17:17:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Trx6RE+H"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A5141B5EB5
	for <io-uring@vger.kernel.org>; Tue, 14 Jan 2025 17:17:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736875040; cv=none; b=dxWxXGsHBD2VfVeTI1YUfDdEwvc3gW7ClDuaY2Dd8FCej0EorAJc9L8SnVjXTMA+PV46cifafQ1KguHTSOjs/J21ZIclF8gvhO2tqwt39JvZRGG/jAe2QSEVFo2PSyagmNV7OREmj2hdJMs/UsJYyFGVJFyA9m201EuOgnZVLss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736875040; c=relaxed/simple;
	bh=aNJqPtlLW25cESuDCRtRoeINyKmEEHkIA1c3j6KhevA=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=YBbE/UpFO76IURnmnLwxmUyTPDtdVBz0e28clfOBjY4h6RyOaC4X5LjwXCvLXK6aMnZaoLF91GOMsqxjtWbLho6IQiLnuVnck80BUTiLE6/qgGZ8fQx9HdAg5IUfrdNcjIXGUfMxIbu4jCwr+JKjTozVNszk0+lVltKD7FP+1Zc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Trx6RE+H; arc=none smtp.client-ip=209.85.208.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-5d3e638e1b4so7820a12.1
        for <io-uring@vger.kernel.org>; Tue, 14 Jan 2025 09:17:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1736875036; x=1737479836; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=WFTy4UQ0IggElZFtcV+jhPAVZCtqB1grwLbbV5mf3yI=;
        b=Trx6RE+Hfc9pkUaN0GIG6AMj4Zq1+hPP3m67brcgbOc8QG/wlSNZAqQ7lII16fbWlT
         hciKe3oBGqJTzbrFClln86ekCiFj6cQCrPaxjW4oSCbVNTaWCZBicIJKfRSvMZe1jHX+
         hixbLhW2AZbIci/+N1f6s5S/i1ntkuwC7pPmLUzZxxKXE+1cq/H1Z2JpHqIQJvJCzMjf
         EQqNCTQAEmdf69jQ0zh+qi6zZNMG9rciUm30B1o4oZcWFct/G1ttxtieMEPDYSXrhhKE
         +NMXS3+m/AEAyX38qu7u1iggAko3mORy7nEXDdEtaAFtZORk1MlDRyCLRKY9hfPDiLjI
         KuRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736875036; x=1737479836;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WFTy4UQ0IggElZFtcV+jhPAVZCtqB1grwLbbV5mf3yI=;
        b=O+dEEQLdjCKf96/bbsrASvWoh7H/82QcE1OoJupOwRlwek/EZ6E1C/DXlWW3Ps9pxC
         L3C4ZA/z7C8PF5+RRo/GbQYluEsSONO+LMQicfxttLiSvG5UCTF2pLgcaGjHeRNaHgyb
         UccwqW/t0yGnTEpOCLcIvlYtbzbtZbO1XnU0XhJKKPdEnBxjN2uaIE0XtgRPyuCDxPRn
         RWIsbAb9JUJSeodlpTsYvJI4u9AmHTPjEUPjlEtLD22TDWLO2+hFBFX2AMpRvsJXElUb
         zQ6LFIMv5iYTrq9kgW3Cxv4ErOQZo+rR0Ez8QsGgGpyCO2cZXQ+Xmw3pwSSA8QI8UTBc
         eHfQ==
X-Forwarded-Encrypted: i=1; AJvYcCUsCdYWGPULsabGtPPIbckApQEdqi7GYhWK8PKMhWz2nZIi2IeM5kJftV+4iVOLF/s6KJFAqXlBFQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YxP+8/MbaF1lJzYL6D5tK9rfAf7uIgE4EXRiYHc2X41JlPkDoFG
	0xswfMNlUsQu+sA7fSn4lp9Dp5sIT8KIiqNdPCn6x7p7uzhyPNhUccNPCH1dWslR5mMlE/LUMBU
	aicE3vHOb5mWEZbAVoVZnLwcirzv+AmOf9mEo
X-Gm-Gg: ASbGnctEJSrtyQovV84Vu7gQfqTaEImS5qfK3ntYWHdZHThk7MInr4cmhvKnPakmXB/
	Ew7TEGxhZETNqb1Vuje3TtdSPVVhGRiGeaihlZgJgTnbuxiCcjCoBxydTGgV2W51RkA==
X-Google-Smtp-Source: AGHT+IEQE6Xmk+2zxwHiqbmDH6sru4faX46wOdYNmnepu2gdFCEhUwXpVAoVzJH284qMB4bzfY2HxWWhHnt3frt2wmo=
X-Received: by 2002:aa7:cb45:0:b0:5d1:10a4:de9 with SMTP id
 4fb4d7f45d1cf-5d9f8aa6be3mr95175a12.7.1736875035147; Tue, 14 Jan 2025
 09:17:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Jann Horn <jannh@google.com>
Date: Tue, 14 Jan 2025 18:16:39 +0100
X-Gm-Features: AbW1kvbWc5cskMosACAqXVHYpOQzaVd3XxZpulCgFHayNbE3eC8jwhBOulTXDsw
Message-ID: <CAG48ez1zez4bdhmeGLEFxtbFADY4Czn3CV0u9d_TMcbvRA01bg@mail.gmail.com>
Subject: io_uring: memory accounting quirk with IORING_REGISTER_CLONE_BUFFERS
To: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
	io-uring <io-uring@vger.kernel.org>, kernel list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi,

I noticed that io_uring's memory accounting behaves weirdly when
IORING_REGISTER_CLONE_BUFFERS is used to clone buffers from uring
instance A to uring instance B, where A and B use different MMs for
accounting. If I first close uring instance A and then uring instance
B, the pinned memory counters for uring instance B will be subtracted,
even though the pinned memory was originally accounted through uring
instance A; so the MM of uring instance B can end up with negative
locked memory.

Here is a testcase:
```
#define _GNU_SOURCE
#include <err.h>
#include <unistd.h>
#include <stdio.h>
#include <stdlib.h>
#include <fcntl.h>
#include <sys/syscall.h>
#include <sys/mman.h>
#include <sys/uio.h>
#include <linux/io_uring.h>

/* for building with outdated kernel headers */
#if 1
enum {
        IORING_REGISTER_SRC_REGISTERED  = (1U << 0),
        IORING_REGISTER_DST_REPLACE     = (1U << 1),
};
struct io_uring_clone_buffers {
        __u32   src_fd;
        __u32   flags;
        __u32   src_off;
        __u32   dst_off;
        __u32   nr;
        __u32   pad[3];
};
#define IORING_REGISTER_CLONE_BUFFERS 30
#endif

#define SYSCHK(x) ({          \
  typeof(x) __res = (x);      \
  if (__res == (typeof(x))-1) \
    err(1, "SYSCHK(" #x ")"); \
  __res;                      \
})

#define NUM_SQ_PAGES 4
static int uring_init(struct io_uring_sqe **sqesp, void **cqesp) {
  struct io_uring_sqe *sqes = SYSCHK(mmap(NULL, NUM_SQ_PAGES*0x1000,
PROT_READ|PROT_WRITE, MAP_SHARED|MAP_ANONYMOUS, -1, 0));
  void *cqes = SYSCHK(mmap(NULL, NUM_SQ_PAGES*0x1000,
PROT_READ|PROT_WRITE, MAP_SHARED|MAP_ANONYMOUS, -1, 0));
  *(volatile unsigned int *)(cqes+4) = 64 * NUM_SQ_PAGES;
  struct io_uring_params params = {
    .flags = IORING_SETUP_NO_MMAP|IORING_SETUP_NO_SQARRAY,
    .sq_off = { .user_addr = (unsigned long)sqes },
    .cq_off = { .user_addr = (unsigned long)cqes }
  };
  int uring_fd = SYSCHK(syscall(__NR_io_uring_setup, /*entries=*/10, &params));
  if (sqesp)
    *sqesp = sqes;
  if (cqesp)
    *cqesp = cqes;
  return uring_fd;
}

int main(int argc, char **argv) {
  if (argc == 1) {
    int ring1 = uring_init(NULL, NULL);
    SYSCHK(fcntl(ring1, F_SETFD, 0)); /* clear O_CLOEXEC */
    char *bufmem = SYSCHK(mmap(NULL, 0x1000, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_ANONYMOUS, -1, 0));
    struct iovec reg_iov = { .iov_base = bufmem, .iov_len = 0x1000 };
    SYSCHK(syscall(__NR_io_uring_register, ring1,
IORING_REGISTER_BUFFERS, &reg_iov, 1));
    char fd_str[100];
    sprintf(fd_str, "%d", ring1);
    execlp(argv[0], argv[0], fd_str, NULL);
    err(1, "reexec");
  } else if (argc == 2) {
    int ring1 = atoi(argv[1]);
    int ring2 = uring_init(NULL, NULL);
    struct io_uring_clone_buffers arg = {
      .src_fd = ring1,
      .flags = 0,
      .src_off = 0,
      .dst_off = 0,
      .nr = 1
    };
    SYSCHK(syscall(__NR_io_uring_register, ring2,
IORING_REGISTER_CLONE_BUFFERS, &arg, 1));
    close(ring1);
    close(ring2);
    system("cat /proc/$PPID/status");
    return 0;
  } else {
    errx(1, "please run without any arguments");
  }
}
```

Result:
```
$ gcc -o uring-buf-deaccount uring-buf-deaccount.c
$ ./uring-buf-deaccount
Name:   uring-buf-deacc
Umask:  0002
State:  S (sleeping)
Tgid:   1162
Ngid:   0
Pid:    1162
PPid:   968
TracerPid:      0
Uid:    1000    1000    1000    1000
Gid:    1000    1000    1000    1000
FDSize: 256
Groups: 1000
NStgid: 1162
NSpid:  1162
NSpgid: 1162
NSsid:  968
Kthread:        0
VmPeak:     2540 kB
VmSize:     2456 kB
VmLck:         0 kB
VmPin:  18446744073709551612 kB
VmHWM:      1264 kB
VmRSS:      1264 kB
RssAnon:               0 kB
RssFile:            1264 kB
RssShmem:              0 kB
[...]
```

Note the "VmPin:  18446744073709551612 kB", that's 0xfffffffffffffffc or -4.

This doesn't lead to anything particularly bad; it just means the
memory usage accounting is off.

Commit 7cc2a6eadcd7 ("io_uring: add IORING_REGISTER_COPY_BUFFERS
method") says that the intended usecase for
IORING_REGISTER_CLONE_BUFFERS are thread pools; maybe a reasonable fix
would be to just refuse IORING_REGISTER_CLONE_BUFFERS between rings
with different accounting contexts (meaning different ->user or
->mm_account)? If that restriction seems acceptable, I'd write a patch
for that.

