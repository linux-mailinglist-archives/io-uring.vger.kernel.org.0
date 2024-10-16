Return-Path: <io-uring+bounces-3718-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 634FD99FED0
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 04:27:53 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E5129B21096
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 02:27:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 83BB815ADA6;
	Wed, 16 Oct 2024 02:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="taHkQQGh"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4752A1859
	for <io-uring@vger.kernel.org>; Wed, 16 Oct 2024 02:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729045666; cv=none; b=n0NsSC7Eog/axwcZwZGS5JoGm5i9WTYGK4goMQYFbkKjTdiNjdbPXOoAYodfDDEyxU+5bGWf71blzZUpJmXvT9Thpc3ZciorOvrAlXNKuF+CxvmtMcPmgLxtlU5Z3p23BUXSPcIDb8FV0K0651f2KIpG7qbA1syRyd8KVTJSdQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729045666; c=relaxed/simple;
	bh=jn4rrfFoiemoLyzFbZJaRx7CQYqoa4JLPlo1UC9nw6I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=URnTdsfgt9zNk/427AojpAK+/9Sg8u0e5Mq9I4dGF2psHgvzP7T0QReeOgR5FlJ3ffC5yxKRclzHZeA2fu95HV3KyssHeNTawUpTzi74rpxTQiqZFcnjE3R5HTVK949GqigHctqxfCQMgmOOPyyRQ+iCnozVOuMy0Rqp2xuup9Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=taHkQQGh; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-7c3e1081804so3512226a12.3
        for <io-uring@vger.kernel.org>; Tue, 15 Oct 2024 19:27:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1729045662; x=1729650462; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IBxNDED3O6Wqb9h2N+Jpu2nGg0QFlqGjfDNamxHzm0w=;
        b=taHkQQGhHlpYk3JTuVV2SZuSZBJklNGF73/evL7JJOitZLvJoa+KF3hvtnQSuX6HuF
         OvfsvfSz8+0rPvup0kuKLJtS4d+HPreNoQLQMokRpuJ9G/y/4APXdRsjGHQTsFuluouq
         w5JcA8/wLHowfbmSSH5XrJ8PFq2uz7fyCxYV4tZgJUgwecEMTzZX4wwiCULoVs3+lisv
         RrLCYUEGN8JgIgkIDgtC5bUk/pvXvcVU3rZt5pkMvHsuF5inKJP/GxLRiepP0PKV8z9h
         MRw6Q/DeGOJ9aMEtAmRdohsW9Zw0MqjPMrTUtJWUqG1e+7OCouLzO8ud7er1+X+tlN8L
         ahPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729045662; x=1729650462;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IBxNDED3O6Wqb9h2N+Jpu2nGg0QFlqGjfDNamxHzm0w=;
        b=uaFcbOcOjrZvFEnhmnMkd1O7ZdbYY7MTNjSPRjCMFqKAvpWMc4RrqesY/XNlStzJdA
         1f5/cgRfcY5Hh7o7Ic56q0yvdKtqgETTgbp9u8mHscJWrYzU42yr52bSKREZuGry2+RO
         Nt8AzjCPZeCJNL/ctxUEEmmhByB7ku7pAibGPiqFLo6TygfPxgTUv0l7cCpWUPH/z49Y
         4jU35Y1q1/rxmVQz+lHDbS7rIO606Mg1ou4xLX4LZoRRyBfv9Hdn/kSAqtVKZPM20Icw
         3X5OeX6jQk3E+Wu/XfP9ijZ7NoOviKmx2ggO92IdpLcW+nWIalhlSACIiZ0nsYACgXlC
         r5/g==
X-Gm-Message-State: AOJu0YwmVkJT3r2Wq77IyGL2/bpFwfNkjl7A30xZ4QMjE/Vi4UdSYn25
	ijZvjnBDZ4QMXmQEztGqO2gspfq4sLPxCMF2gE3LSDeat7jB8yJ1hCdl7z6BMTDgAsdoPAw+xj/
	N
X-Google-Smtp-Source: AGHT+IEaY/yYHXOeIM3YGlkRKDIS/7+U38TyaOSyaqYQbAtNE62rta9K6zPfb0MkjTB9J5hsay2E3A==
X-Received: by 2002:a05:6a20:d045:b0:1cf:6953:2889 with SMTP id adf61e73a8af0-1d8bcf0fe6emr24836465637.16.1729045662613;
        Tue, 15 Oct 2024 19:27:42 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71e77371186sm2043187b3a.35.2024.10.15.19.27.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Oct 2024 19:27:42 -0700 (PDT)
Message-ID: <b197e714-d117-491e-83e8-a6849e027e8b@kernel.dk>
Date: Tue, 15 Oct 2024 20:27:40 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring: rename "copy buffers" to "clone buffers"
To: "Lai, Yi" <yi1.lai@linux.intel.com>
Cc: io-uring <io-uring@vger.kernel.org>, yi1.lai@intel.com
References: <27e7258c-b6d0-439c-854f-e6441a82148b@kernel.dk>
 <Zw8dkUzsxQ5LgAJL@ly-workstation>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <Zw8dkUzsxQ5LgAJL@ly-workstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/15/24 7:57 PM, Lai, Yi wrote:
> Hi Jens Axboe,
> 
> Greetings!
> 
> I used Syzkaller and found that there is BUG: unable to handle kernel paging request in io_register_clone_buffers in v6.12-rc2
> 
> After bisection and the first bad commit is:
> "
> 636119af94f2 io_uring: rename "copy buffers" to "clone buffers"
> "

It must be the parent that introduced it, not just the rename. So bisect
perhaps a bit suspect, but it's dying in that code so surely where it
is.

> All detailed into can be found at:
> https://github.com/laifryiee/syzkaller_logs/tree/main/241015_200715_io_register_clone_buffers
> Syzkaller repro code:
> https://github.com/laifryiee/syzkaller_logs/tree/main/241015_200715_io_register_clone_buffers/repro.c
> Syzkaller repro syscall steps:
> https://github.com/laifryiee/syzkaller_logs/tree/main/241015_200715_io_register_clone_buffers/repro.prog
> Syzkaller report:
> https://github.com/laifryiee/syzkaller_logs/tree/main/241015_200715_io_register_clone_buffers/repro.report
> Kconfig(make olddefconfig):
> https://github.com/laifryiee/syzkaller_logs/tree/main/241015_200715_io_register_clone_buffers/kconfig_origin
> Bisect info:
> https://github.com/laifryiee/syzkaller_logs/tree/main/241015_200715_io_register_clone_buffers/bisect_info.log
> bzImage:
> https://github.com/laifryiee/syzkaller_logs/raw/refs/heads/main/241015_200715_io_register_clone_buffers/bzImage_8cf0b93919e13d1e8d4466eb4080a4c4d9d66d7b
> Issue dmesg:
> https://github.com/laifryiee/syzkaller_logs/blob/main/241015_200715_io_register_clone_buffers/8cf0b93919e13d1e8d4466eb4080a4c4d9d66d7b_dmesg.log
> 
> "
> [   29.812887] Oops: Oops: 0003 [#1] PREEMPT SMP KASAN NOPTI
> [   29.813730] CPU: 1 UID: 0 PID: 731 Comm: repro Not tainted 6.12.0-rc2-8cf0b93919e1 #1
> [   29.814907] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
> [   29.816616] RIP: 0010:io_register_clone_buffers+0x45e/0x810
> [   29.817524] Code: 3c 08 00 0f 85 3c 03 00 00 48 8b 1b be 04 00 00 00 41 bf 01 00 00 00 48 8d 43 14 48 89 c7 48 89 85 08 ff ff ff e8 82 de f0 fe <f0> 44 0f c1 7b 14 31 ff 44 89 fe e8 e2 02 89 fe 45 85 ff 0f 84 b1
> [   29.820286] RSP: 0018:ffff88801469fc50 EFLAGS: 00010246
> [   29.821100] RAX: 0000000000000001 RBX: ffffffff85f7ca20 RCX: ffffffff82de91ae
> [   29.822165] RDX: fffffbfff0bef947 RSI: 0000000000000004 RDI: ffffffff85f7ca34
> [   29.823328] RBP: ffff88801469fd98 R08: 0000000000000001 R09: fffffbfff0bef946
> [   29.823868] R10: ffffffff85f7ca37 R11: 0000000000000001 R12: ffff88800ef21560
> [   29.824407] R13: 0000000000000000 R14: ffff88801469fd70 R15: 0000000000000001
> [   29.824924] FS:  00007feaa461a600(0000) GS:ffff88806c500000(0000) knlGS:0000000000000000
> [   29.825512] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   29.825934] CR2: ffffffff85f7ca34 CR3: 00000000143a4000 CR4: 0000000000750ef0
> [   29.826473] PKRU: 55555554
> [   29.826683] Call Trace:
> [   29.826874]  <TASK>
> [   29.827047]  ? show_regs+0x6d/0x80
> [   29.827333]  ? __die+0x29/0x70
> [   29.827584]  ? page_fault_oops+0x391/0xc50
> [   29.827897]  ? __pfx_page_fault_oops+0x10/0x10
> [   29.828258]  ? __pfx_is_prefetch.constprop.0+0x10/0x10
> [   29.828650]  ? search_module_extables+0x3f/0x110
> [   29.829010]  ? io_register_clone_buffers+0x45e/0x810
> [   29.829404]  ? search_exception_tables+0x65/0x70
> [   29.829756]  ? fixup_exception+0x114/0xb10
> [   29.830082]  ? kernelmode_fixup_or_oops.constprop.0+0xcc/0x100
> [   29.830543]  ? __bad_area_nosemaphore+0x3b2/0x650
> [   29.830911]  ? __sanitizer_cov_trace_const_cmp8+0x1c/0x30
> [   29.831327]  ? spurious_kernel_fault_check+0xbf/0x1c0
> [   29.831724]  ? bad_area_nosemaphore+0x33/0x40
> [   29.832100]  ? do_kern_addr_fault+0x14e/0x180
> [   29.832441]  ? exc_page_fault+0x1b0/0x1d0
> [   29.832767]  ? asm_exc_page_fault+0x2b/0x30
> [   29.833101]  ? io_register_clone_buffers+0x45e/0x810
> [   29.833485]  ? io_register_clone_buffers+0x45e/0x810
> [   29.833892]  ? __pfx_io_register_clone_buffers+0x10/0x10
> [   29.834345]  ? rcu_is_watching+0x19/0xc0
> [   29.834663]  ? trace_contention_end+0xe1/0x120
> [   29.835018]  ? __mutex_lock+0x258/0x1490
> [   29.835340]  ? lock_release+0x441/0x870
> [   29.835650]  __io_uring_register+0x61d/0x20f0
> [   29.836002]  ? __pfx___io_uring_register+0x10/0x10
> [   29.836398]  ? __fget_files+0x23c/0x4b0
> [   29.836715]  ? trace_irq_enable+0x111/0x120
> [   29.837056]  __x64_sys_io_uring_register+0x172/0x2a0
> [   29.837445]  x64_sys_call+0x14bd/0x20d0
> [   29.837758]  do_syscall_64+0x6d/0x140
> [   29.838050]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> [   29.838457] RIP: 0033:0x7feaa443ee5d
> [   29.838743] Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 93 af 1b 00 f7 d8 64 89 01 48

Thanks, I'll take a look! A vmlinux would be handy to have, in terms of
looking up where it's fauling without spending too much time on it. But
if you don't have it, no worries, I'll give this a spin tomorrow.

-- 
Jens Axboe

