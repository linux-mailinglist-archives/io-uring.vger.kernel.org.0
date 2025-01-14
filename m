Return-Path: <io-uring+bounces-5856-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id A29E8A10D8D
	for <lists+io-uring@lfdr.de>; Tue, 14 Jan 2025 18:23:20 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A85B41883BA6
	for <lists+io-uring@lfdr.de>; Tue, 14 Jan 2025 17:23:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B20FE1CF2B7;
	Tue, 14 Jan 2025 17:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="2XzVlyOH"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18F5A42A83
	for <io-uring@vger.kernel.org>; Tue, 14 Jan 2025 17:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736875396; cv=none; b=cfiZ+19twhH0xJvwEe+6kwTq9/FBmoSascXoRWpNFR38521bef01EFZkrMaXRlW7zMjFRkSncwrDXmYE6lkwnkn7f9WeDqB+PjsCHn5R3IrOJfCpnqaR2504EeOX1f0PoxwiKg//I1ICpc6kwdHmzh6zRAn8wfylE2rwGF+oRrE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736875396; c=relaxed/simple;
	bh=lZR3dB3IWXeOkvBR7etA+pjpBUbJxETyLr4HwF3kqsM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=uQqQ7ONYURzzkCTK+AXKB1maC68KAeZ6k9CP1C3RMN6qFLmpgiRuPxZwcUKU4Pf+UaiULwEaX9dq6PmAVkAtU3eeExLFaO4/r9ayYlNoK2ffvdLJAlRi1gMfX54SqRmiStBjsFOJSkN0qXAqUtnCOivrMg68/ui7rnGUjTWTf5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=2XzVlyOH; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-844df397754so185754039f.2
        for <io-uring@vger.kernel.org>; Tue, 14 Jan 2025 09:23:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1736875394; x=1737480194; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=O9OjVNvWROO6S0zBxQKzJzbjRqiGI+v9Onowdkg4wHw=;
        b=2XzVlyOHGLgvfbYyuHFs3L8tKZf8Ruj0HzTRd62Y0cRJrv3S5sSVwihNU877pAkrld
         otULCyLwFogRvv8oR7uOWEsBCXn1QputMVh8P7tqK06rXpaN+GNnxgrCwQdMHU+g44MH
         x7lWN4BCje0OCxRXjTpqlo8KVuzQw0Ce7IDaZ+iyzkmvqHWk3W1xwU506Wz7w4Mh7Ass
         bbU13YdkvbyDDSLSRTJ60FCalGXJd68kJlwj02oBAo5mq//noCM4MPEZ/JRyzrpMuGmz
         IRFNNAwqce7afE9N/hk2gTODixa+eLyehwfbE8UKjGDhi3IzmuyEk+CZ5pRc0yIIrWpx
         zzVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736875394; x=1737480194;
        h=content-transfer-encoding:in-reply-to:content-language:from
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O9OjVNvWROO6S0zBxQKzJzbjRqiGI+v9Onowdkg4wHw=;
        b=KJFxmGK3ys3UuzhptrUqy7OjYfyX7KNE1eCsYP5+t9vVYtk4qg2V+ccfwhTkNx5JKI
         Q9gKdgnES3nQ5PAYAuihOSqVOK0zOMt4yOis7kJeN5re9PR46FdSx3nnmzlv8EPJ0Zcm
         i2pq4QaRetZPOkoQa2qqu99tfJD+OWc0ITcyt/iosRM7FssHvhtZ+WBLm2I01UVPlitV
         4Qk1N5CH6jr6Y+OaEPetpFDwq6FNfxcp+6hYpqURSx6EUnyUspekcm9lMpvp77r3BGim
         vOa/vZnXpv5YdIwyRtfC8SVAHOzj9ookP0WpuBgtFWJSt5zTCcRxckyruoBLPVdgXBSN
         5k7g==
X-Forwarded-Encrypted: i=1; AJvYcCUbc9m6q3SHhy2E1Q7EmfVIoB8NgvHrvgYAjDnNE5cLu14H/cLbl/NouGDxj+mDMbEUkohKkZQTIg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy0TXNoIDVU8YrMM0r4cIMRL6zcrMl8rJ+EGWHVkPhMSgP/MkqP
	DZAxJYeBx3e0amsh/5P1E0aPYAWJNo+SqA6ZNJgbsnjBr9nxLCCg+0gpn1xqjek=
X-Gm-Gg: ASbGncvwUiIP6YBJZl62mooC9cb3gvba0B7D43kAlgERDo5lIg544BxYgrvXDFi4BH2
	8D9/A2e+S+xYCbuV6G+hgqF0Oleq3AzkYfSd7+RnHNqT/2MHledOlZfedLpp9Ss/fvFF0w5Y+ja
	IqHUJtLDli+nZNLshUml5hjuFQgA/vcm7wzaPlJI4+4NeDf9N8vekOYDD/qyirHSY+I4OCsa4ur
	YjgJNStBZEBlIfxZGFu2e8B94/IL0/lWleyHIaes1ES23JTp8zH
X-Google-Smtp-Source: AGHT+IFeyhub1OXeK6Xu3+UbvZJvy982orDi1g8MpEWQd0FZ6VaNDLOJ5s40YP8yGo2cxCdkut1+Ww==
X-Received: by 2002:a05:6602:3e94:b0:83a:9820:f26b with SMTP id ca18e2360f4ac-84ce0037915mr2257000339f.2.1736875394097;
        Tue, 14 Jan 2025 09:23:14 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4ea1b5fa2bbsm3566265173.27.2025.01.14.09.23.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Jan 2025 09:23:13 -0800 (PST)
Message-ID: <380bf126-dd6a-45c8-8e3d-6f41b687df2e@kernel.dk>
Date: Tue, 14 Jan 2025 10:23:12 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: io_uring: memory accounting quirk with
 IORING_REGISTER_CLONE_BUFFERS
To: Jann Horn <jannh@google.com>, Pavel Begunkov <asml.silence@gmail.com>,
 io-uring <io-uring@vger.kernel.org>,
 kernel list <linux-kernel@vger.kernel.org>
References: <CAG48ez1zez4bdhmeGLEFxtbFADY4Czn3CV0u9d_TMcbvRA01bg@mail.gmail.com>
From: Jens Axboe <axboe@kernel.dk>
Content-Language: en-US
In-Reply-To: <CAG48ez1zez4bdhmeGLEFxtbFADY4Czn3CV0u9d_TMcbvRA01bg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/14/25 10:16 AM, Jann Horn wrote:
> Hi,
> 
> I noticed that io_uring's memory accounting behaves weirdly when
> IORING_REGISTER_CLONE_BUFFERS is used to clone buffers from uring
> instance A to uring instance B, where A and B use different MMs for
> accounting. If I first close uring instance A and then uring instance
> B, the pinned memory counters for uring instance B will be subtracted,
> even though the pinned memory was originally accounted through uring
> instance A; so the MM of uring instance B can end up with negative
> locked memory.
> 
> Here is a testcase:
> ```
> #define _GNU_SOURCE
> #include <err.h>
> #include <unistd.h>
> #include <stdio.h>
> #include <stdlib.h>
> #include <fcntl.h>
> #include <sys/syscall.h>
> #include <sys/mman.h>
> #include <sys/uio.h>
> #include <linux/io_uring.h>
> 
> /* for building with outdated kernel headers */
> #if 1
> enum {
>         IORING_REGISTER_SRC_REGISTERED  = (1U << 0),
>         IORING_REGISTER_DST_REPLACE     = (1U << 1),
> };
> struct io_uring_clone_buffers {
>         __u32   src_fd;
>         __u32   flags;
>         __u32   src_off;
>         __u32   dst_off;
>         __u32   nr;
>         __u32   pad[3];
> };
> #define IORING_REGISTER_CLONE_BUFFERS 30
> #endif
> 
> #define SYSCHK(x) ({          \
>   typeof(x) __res = (x);      \
>   if (__res == (typeof(x))-1) \
>     err(1, "SYSCHK(" #x ")"); \
>   __res;                      \
> })
> 
> #define NUM_SQ_PAGES 4
> static int uring_init(struct io_uring_sqe **sqesp, void **cqesp) {
>   struct io_uring_sqe *sqes = SYSCHK(mmap(NULL, NUM_SQ_PAGES*0x1000,
> PROT_READ|PROT_WRITE, MAP_SHARED|MAP_ANONYMOUS, -1, 0));
>   void *cqes = SYSCHK(mmap(NULL, NUM_SQ_PAGES*0x1000,
> PROT_READ|PROT_WRITE, MAP_SHARED|MAP_ANONYMOUS, -1, 0));
>   *(volatile unsigned int *)(cqes+4) = 64 * NUM_SQ_PAGES;
>   struct io_uring_params params = {
>     .flags = IORING_SETUP_NO_MMAP|IORING_SETUP_NO_SQARRAY,
>     .sq_off = { .user_addr = (unsigned long)sqes },
>     .cq_off = { .user_addr = (unsigned long)cqes }
>   };
>   int uring_fd = SYSCHK(syscall(__NR_io_uring_setup, /*entries=*/10, &params));
>   if (sqesp)
>     *sqesp = sqes;
>   if (cqesp)
>     *cqesp = cqes;
>   return uring_fd;
> }
> 
> int main(int argc, char **argv) {
>   if (argc == 1) {
>     int ring1 = uring_init(NULL, NULL);
>     SYSCHK(fcntl(ring1, F_SETFD, 0)); /* clear O_CLOEXEC */
>     char *bufmem = SYSCHK(mmap(NULL, 0x1000, PROT_READ|PROT_WRITE,
> MAP_PRIVATE|MAP_ANONYMOUS, -1, 0));
>     struct iovec reg_iov = { .iov_base = bufmem, .iov_len = 0x1000 };
>     SYSCHK(syscall(__NR_io_uring_register, ring1,
> IORING_REGISTER_BUFFERS, &reg_iov, 1));
>     char fd_str[100];
>     sprintf(fd_str, "%d", ring1);
>     execlp(argv[0], argv[0], fd_str, NULL);
>     err(1, "reexec");
>   } else if (argc == 2) {
>     int ring1 = atoi(argv[1]);
>     int ring2 = uring_init(NULL, NULL);
>     struct io_uring_clone_buffers arg = {
>       .src_fd = ring1,
>       .flags = 0,
>       .src_off = 0,
>       .dst_off = 0,
>       .nr = 1
>     };
>     SYSCHK(syscall(__NR_io_uring_register, ring2,
> IORING_REGISTER_CLONE_BUFFERS, &arg, 1));
>     close(ring1);
>     close(ring2);
>     system("cat /proc/$PPID/status");
>     return 0;
>   } else {
>     errx(1, "please run without any arguments");
>   }
> }
> ```
> 
> Result:
> ```
> $ gcc -o uring-buf-deaccount uring-buf-deaccount.c
> $ ./uring-buf-deaccount
> Name:   uring-buf-deacc
> Umask:  0002
> State:  S (sleeping)
> Tgid:   1162
> Ngid:   0
> Pid:    1162
> PPid:   968
> TracerPid:      0
> Uid:    1000    1000    1000    1000
> Gid:    1000    1000    1000    1000
> FDSize: 256
> Groups: 1000
> NStgid: 1162
> NSpid:  1162
> NSpgid: 1162
> NSsid:  968
> Kthread:        0
> VmPeak:     2540 kB
> VmSize:     2456 kB
> VmLck:         0 kB
> VmPin:  18446744073709551612 kB
> VmHWM:      1264 kB
> VmRSS:      1264 kB
> RssAnon:               0 kB
> RssFile:            1264 kB
> RssShmem:              0 kB
> [...]
> ```
> 
> Note the "VmPin:  18446744073709551612 kB", that's 0xfffffffffffffffc or -4.
> 
> This doesn't lead to anything particularly bad; it just means the
> memory usage accounting is off.
> 
> Commit 7cc2a6eadcd7 ("io_uring: add IORING_REGISTER_COPY_BUFFERS
> method") says that the intended usecase for
> IORING_REGISTER_CLONE_BUFFERS are thread pools; maybe a reasonable fix
> would be to just refuse IORING_REGISTER_CLONE_BUFFERS between rings
> with different accounting contexts (meaning different ->user or
> ->mm_account)? If that restriction seems acceptable, I'd write a patch
> for that.

I think adding that restriction would be fine. The intended use case is
sharing buffers anyway, which means they would need to be in the same
address space to begin with.

-- 
Jens Axboe

