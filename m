Return-Path: <io-uring+bounces-8216-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 56AAAACDFF8
	for <lists+io-uring@lfdr.de>; Wed,  4 Jun 2025 16:12:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 21138175BB0
	for <lists+io-uring@lfdr.de>; Wed,  4 Jun 2025 14:12:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7D5A8290BAB;
	Wed,  4 Jun 2025 14:12:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="vmAv6v8W"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15F201E52D
	for <io-uring@vger.kernel.org>; Wed,  4 Jun 2025 14:12:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749046333; cv=none; b=rbYkPbgEHFipoPegXa8qOCjLXD2qhcP1xVv2QmMCG0O4dhUx7ichEGvdaw1c9P42M7tGjYA34sz5jyTEGUEZqcYcdzaWykRQzpg+FySCk032vftsMSPaLhdB6A7W1qnAwRgQ+Z2JjYQbVngGqtoXcCiIjXpc+J9jniqqBhye1OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749046333; c=relaxed/simple;
	bh=MeaKBopI+Brip5/1VOPOQh5RAUCMe3VOwqq7bAn+6fg=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=nHrwoW/q6uEsnxBjUMVVLqE7LHJ3/ivGJgVSXoHEaVvPSiAk1UBHC6+T1OxI71dxqfPIpDE2PhZF+MgmvYeHPhWrHJNN2qc1xkUzROxbLqTrtCAm8TdFIaKkw1nPZUj3YqPWdCpyTKc0469sLBTuB2WCYys1Fkv5nJWpdqvYdKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=vmAv6v8W; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-3dc7830a386so21955565ab.1
        for <io-uring@vger.kernel.org>; Wed, 04 Jun 2025 07:12:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1749046329; x=1749651129; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tfqyN5kFgj481DgFWJSrp9HdUmcxzSWFl+rkbPcvUPo=;
        b=vmAv6v8WG8W6DlKex9S5oqasyNvP3feRZk2cib4CznLbZFKYb23opOnEY0bCJpuJnL
         brUBC5FX35w3pR5znPrmR0J07G3fy9UY8xTK7pTqcElmXpeIxVQojCQLrKyrc6Gg5ykc
         E9pbIQt+1VMzONrjxG3U8H7S4r9sqym+adh+SODIjWoXwEHLgEQVqz4rWxKIYafkGPKl
         VyC2u8rakTDagQl9jxCib+0+HNXiU8UuzSVNnt+jhlH7dWGNHcVB9RDeH+QIX6BfyfJ4
         boDCKJyM3ZiXMQq6ZUhHzi4F6Y0Zh+5MhgOMUapP+28aBBGqtVOslvjpDHjqui1K7gyK
         G+0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749046329; x=1749651129;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tfqyN5kFgj481DgFWJSrp9HdUmcxzSWFl+rkbPcvUPo=;
        b=qAsdbFHNLve6O+ZPWpoQOu/ALenh7dBAW1/8BKDXMdF5sgh3kiTUxx6RuRVdBfIJIp
         Pp7VkSAEeQSB+W3CWNHtrDRYdkGWw0qWf2df67rxqI2Kp/M9f/oJIgoHGkDk2YAbqoxJ
         IOlc5rN+UaGvtVT/HD9S6jgn7YQavyZwL2CCJ7ZTwZqg1bjmlGi3NSxW5CRerIwU3+u5
         lhA4PVPmYMKomzUFMFph41Rq6JvGewTYJK0qCh+t3iGbeHKzxz+svJW5mMXCAF6tVlus
         52euYlTZLjpPLpcmRc6iadx1jZ85I4JtGc+yThIsdClr5rkDj2mdwtxEmTrQHTXjQZLQ
         Lw2w==
X-Forwarded-Encrypted: i=1; AJvYcCVf3COtIeA++6TP5hy0n6GHjBvS9vzaqDyEe9ULWxdCMG4qyvnFCvFiG0p7N69qhlm20grTnyGnqw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwLA88+vsWUiu9fFiKAdFuTIUoH4w/wepqgLnruq4FvNkRqUUoU
	lB4pcs2GVCg70DLQgkjszHmWY+s/frOUmUr2W6uqvUr4U54WzJhuTQOUj5yjiqcQ3kb55Sf6ynU
	qaRs7
X-Gm-Gg: ASbGncuXVOmmoFkB/EgmhLow1ZgTC2wDdU7R/e9wIe1sZkdAQmzmv9fwzRdJRCKiiX2
	RZqwTsDTYMHGWhgeg5M8/isg1xDXV/21t6ns7Bnukjhd5geJKecp9yTEgbzNSm3Sh+mrt1PGLxB
	24aHAlgAaMb/WJV1nJuvXF429ToL7qTaOYI7r8Y9olAol81LbgbDqYwCAwcXRgFkbDGBwjBJdDK
	moFDxRtNUAls3jYaVim+JDCTx/hhBu55vK8ofYyGoumo5GdsH2Y//lLydPE0JcNyirm4kJ1I2zj
	SDtaAscnZGXymvfriUXn3PwFxibxLzmX1bLW8uh3Nhuze9M=
X-Google-Smtp-Source: AGHT+IHakU+MvaZLjM0oWZvuKSiOO+wVPu208/vai2VS1FXQ2BWkXVA30BcJk1ue3RhRMvnZP9FF6w==
X-Received: by 2002:a05:6e02:12cc:b0:3dd:8663:d19e with SMTP id e9e14a558f8ab-3ddbee3d578mr28796975ab.10.1749046329103;
        Wed, 04 Jun 2025 07:12:09 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3ddc4a0251esm385385ab.68.2025.06.04.07.12.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Jun 2025 07:12:07 -0700 (PDT)
Message-ID: <83793604-3f0e-4496-a7c2-75f318219bee@kernel.dk>
Date: Wed, 4 Jun 2025 08:12:06 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: use-after-free if killed while in IORING_OP_FUTEX_WAIT
To: rtm@csail.mit.edu, Pavel Begunkov <asml.silence@gmail.com>,
 io-uring@vger.kernel.org
References: <38053.1749045482@localhost>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <38053.1749045482@localhost>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/4/25 7:58 AM, rtm@csail.mit.edu wrote:
> If a process is killed while in IORING_OP_FUTEX_WAIT, do_exit()'s call
> to exit_mm() causes the futex_private_hash to be freed, along with its
> buckets' locks, while the iouring request still exists. When (a little
> later in do_exit()) the iouring fd is fput(), the resulting
> futex_unqueue() tries to use the freed memory that
> req->async_data->lock_ptr points to.
> 
> I've attached a demo:
> 
> # cc uring46b.c
> # ./a.out
> killing child
> BUG: spinlock bad magic on CPU#0, kworker/u4:1/26
> Unable to handle kernel paging request at virtual address 6b6b6b6b6b6b711b
> Current kworker/u4:1 pgtable: 4K pagesize, 39-bit VAs, pgdp=0x000000008202a000
> [6b6b6b6b6b6b711b] pgd=0000000000000000, p4d=0000000000000000, pud=0000000000000000
> Oops [#1]
> Modules linked in:
> CPU: 0 UID: 0 PID: 26 Comm: kworker/u4:1 Not tainted 6.15.0-11192-ga82d78bc13a8 #553 NONE 
> Hardware name: riscv-virtio,qemu (DT)
> Workqueue: iou_exit io_ring_exit_work
> epc : spin_dump+0x38/0x6e
>  ra : spin_dump+0x30/0x6e
> epc : ffffffff80003354 ra : ffffffff8000334c sp : ffffffc600113b60
> ...
> status: 0000000200000120 badaddr: 6b6b6b6b6b6b711b cause: 000000000000000d
> [<ffffffff80003354>] spin_dump+0x38/0x6e
> [<ffffffff8009b78a>] do_raw_spin_lock+0x10a/0x126
> [<ffffffff811e6552>] _raw_spin_lock+0x1a/0x22
> [<ffffffff800eb80c>] futex_unqueue+0x2a/0x76
> [<ffffffff8069e366>] __io_futex_cancel+0x72/0x88
> [<ffffffff806982fe>] io_cancel_remove_all+0x50/0x74
> [<ffffffff8069e4ac>] io_futex_remove_all+0x1a/0x22
> [<ffffffff80010a7e>] io_uring_try_cancel_requests+0x2e2/0x36e
> [<ffffffff80010bf6>] io_ring_exit_work+0xec/0x3f0
> [<ffffffff80057f0a>] process_one_work+0x132/0x2fe
> [<ffffffff8005888c>] worker_thread+0x21e/0x2fe
> [<ffffffff80060428>] kthread+0xe8/0x1ba
> [<ffffffff80022fb0>] ret_from_fork_kernel+0xe/0x5e
> [<ffffffff811e8566>] ret_from_fork_kernel_asm+0x16/0x18
> Code: 4517 018b 0513 ca05 00ef 3b60 2603 0049 2601 c491 (a703) 5b04 
> ---[ end trace 0000000000000000 ]---
> Kernel panic - not syncing: Fatal exception
> ---[ end Kernel panic - not syncing: Fatal exception ]---

Thanks, I'll take a look!

-- 
Jens Axboe


