Return-Path: <io-uring+bounces-3776-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DFBBD9A21B3
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 14:00:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9AA052893AB
	for <lists+io-uring@lfdr.de>; Thu, 17 Oct 2024 12:00:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CCC621DC07D;
	Thu, 17 Oct 2024 12:00:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="l8t6+ZN2"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87B101D5178;
	Thu, 17 Oct 2024 12:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729166443; cv=none; b=CaZxgr56Yb9ZgNkF0XKOFVs3CgzaRw2nFO0qQ8xewNvpOeo9JzbQ2qRFbV5K+Lbu/E2VNwGvK/cQHIV8H6UB079r6bLp7eaWN152rFoQ+h0pFBrUbl+ffuPc5ljdF16tG/pTQo2BN9sfS4eOaxhtj0QFw57sf2ZN/I3yUG3OpvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729166443; c=relaxed/simple;
	bh=vIaTO+t4gtILq00gPQynGtNdYTSLedibd+rmjdUA8yI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=kvzJnOXKdhGqBv0fx/spcXQGXgt+a7p5SPYhNE5GOsoRnmXV1pBNJ0Cl5oswcGSIQaNaIP2QHdWhI34OilyhmhGAyrCGu1szM6kzXFk71zKUknQ//xM4zGW9u2/YCQXiA8qDWXUdqrH+UmPDQwumM6tODiJMXBsoAD6YWJhzvBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=l8t6+ZN2; arc=none smtp.client-ip=209.85.167.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-539fb49c64aso1214596e87.0;
        Thu, 17 Oct 2024 05:00:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1729166439; x=1729771239; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YajK/IkYGa6WwS99D9AWd7oTDV/cV6q2Ud8zvCfNZYY=;
        b=l8t6+ZN2iTwgC7cDJ7a2uMULW2aPehLYjWrCXhabuZ3Pbap9lR+13TMzWkK3BWRwS8
         SeERCKYXhwMa9F26/I90cd5uOjD8g/CnwY2qAHPKqbAtKuioFE+Rgnb2E4tBoPKxXJHq
         82UWutU2nSCy+AuFLc4wcTuk85/vkmHzPPEUIumPrjBC+y2Z+a7StGfxR895iUvjCnaN
         54xSnhi9Ye8T/c3njSCjQ+2tVLcDcfoCorQdpCyrTwrHRry6rmWjbLmqj4i6AO37omrl
         8FMMGUYu7vDMR+70AvaQLP/Fn6LkUV9rJn4e1k29Pac3x1Z0mtH0JB+Vm60HrhXPXk6M
         4zbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729166439; x=1729771239;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YajK/IkYGa6WwS99D9AWd7oTDV/cV6q2Ud8zvCfNZYY=;
        b=cr0+yQjuMj3ZfqQ9hej35IGBsRrNuZHmHLPwav0h7IvhxjHl0tYIGaDx1othOSLCFE
         EGgtrTkQz0wApyXZ76ZR6X4Z/LVlyhAqFpRHAhm3DAHRj6RmUm9lZsdV+gIVxFF+M3GG
         3pMeiC78KM91pq9QqMxjeCkWldHpTvJH/xm8b0RKvLse9d/xnqmpgCTIPXASYUnDFmfN
         slZhtuGyBg7bwaUJKutYiiZyHiQ7DumVo3G2x7YQ93y+9DKbEoa19Wl+RL1CDARe8T4p
         6vZiMh8uf4tEeoiKx4OEyVqJqI2rmloI/x0xyERY/h6XDtUvVp0WEYwkrLPyfkvuL91g
         9Bdg==
X-Forwarded-Encrypted: i=1; AJvYcCVhSKWoTDNU8MS0thiZIAchrfw/RVV5Ud91G33pLSoiYGX2rjrykwkzgYYySza0+hp7Ja4NafRDeg==@vger.kernel.org, AJvYcCWCEjn31iGRfsiugF62zec2cw/YZJ3kMfZbnL8Qc9AXaO/DtdR/95JFLY9gmquJE0AqNUFQfUaAcGYZ4dZh@vger.kernel.org
X-Gm-Message-State: AOJu0Yzzbyuj0+jnlhjQIx5u04hXga0cPMLu8/Ed2MS30cxNpA9L/7FU
	x34iHou5Wp0NeS4D0pr4eDa4GN5fIo5c2LpsScFrd/zX4vl1ztdI
X-Google-Smtp-Source: AGHT+IEukFtG3CsS2S9GITpOM20ego4bSmu33bPRWGPmxddFLHHibVFmlSbgluSW/fPqqN9z/2UhNw==
X-Received: by 2002:a05:6512:6d0:b0:539:8f68:e036 with SMTP id 2adb3069b0e04-539e552184bmr11885399e87.34.1729166438018;
        Thu, 17 Oct 2024 05:00:38 -0700 (PDT)
Received: from [192.168.42.33] ([85.255.234.159])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-a9a2973faffsm288256366b.48.2024.10.17.05.00.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Oct 2024 05:00:37 -0700 (PDT)
Message-ID: <e40179ae-5b1a-446e-a982-607321b21d57@gmail.com>
Date: Thu, 17 Oct 2024 13:00:57 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] KCSAN: data-race in io_req_defer_failed /
 io_wq_free_work (3)
To: syzbot <syzbot+2b8e48083b04a2e58fab@syzkaller.appspotmail.com>,
 axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <6710c8ce.050a0220.d5849.0026.GAE@google.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <6710c8ce.050a0220.d5849.0026.GAE@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/17/24 09:20, syzbot wrote:
> Hello,
> 
> syzbot found the following issue on:
> 
> HEAD commit:    c964ced77262 Merge tag 'for-linus' of git://git.kernel.org..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=14d3cf27980000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=fd83253b74c9c570
> dashboard link: https://syzkaller.appspot.com/bug?extid=2b8e48083b04a2e58fab
> compiler:       Debian clang version 15.0.6, GNU ld (GNU Binutils for Debian) 2.40
> 
> Unfortunately, I don't have any reproducer for this issue yet.
> 
> Downloadable assets:
> disk image: https://storage.googleapis.com/syzbot-assets/dc3d0edf69f7/disk-c964ced7.raw.xz
> vmlinux: https://storage.googleapis.com/syzbot-assets/bb0052a85cf6/vmlinux-c964ced7.xz
> kernel image: https://storage.googleapis.com/syzbot-assets/ec8def944d77/bzImage-c964ced7.xz
> 
> IMPORTANT: if you fix the issue, please add the following tag to the commit:
> Reported-by: syzbot+2b8e48083b04a2e58fab@syzkaller.appspotmail.com

I'd assume io_req_defer_failed sets F_FAIL flag, req_ref_put_and_test()
reads F_REFCOUNT, which never changes at this point, and there are
dozens other such modifications.

The race is mild, it shouldn't be a problem unless the compiler
misbehaves,  but may make sense to add WRITE_ONCE for every
modification.


> ==================================================================
> BUG: KCSAN: data-race in io_req_defer_failed / io_wq_free_work
> 
> write to 0xffff888117079648 of 8 bytes by task 3752 on cpu 1:
>   io_req_defer_failed+0x73/0x440 io_uring/io_uring.c:935
>   io_req_task_cancel+0x21/0x30 io_uring/io_uring.c:1361
>   io_handle_tw_list+0x1b9/0x200 io_uring/io_uring.c:1063
>   tctx_task_work_run+0x6c/0x1b0 io_uring/io_uring.c:1135
>   tctx_task_work+0x40/0x80 io_uring/io_uring.c:1153
>   task_work_run+0x13a/0x1a0 kernel/task_work.c:228
>   get_signal+0xee9/0x1070 kernel/signal.c:2690
>   arch_do_signal_or_restart+0x95/0x4b0 arch/x86/kernel/signal.c:337
>   exit_to_user_mode_loop kernel/entry/common.c:111 [inline]
>   exit_to_user_mode_prepare include/linux/entry-common.h:328 [inline]
>   __syscall_exit_to_user_mode_work kernel/entry/common.c:207 [inline]
>   syscall_exit_to_user_mode+0x59/0x130 kernel/entry/common.c:218
>   do_syscall_64+0xd6/0x1c0 arch/x86/entry/common.c:89
>   entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> read to 0xffff888117079648 of 8 bytes by task 3753 on cpu 0:
>   req_ref_put_and_test io_uring/refs.h:22 [inline]
>   io_wq_free_work+0x21/0x160 io_uring/io_uring.c:1779
>   io_worker_handle_work+0x4cb/0x9d0 io_uring/io-wq.c:604
>   io_wq_worker+0x286/0x820 io_uring/io-wq.c:655
>   ret_from_fork+0x4b/0x60 arch/x86/kernel/process.c:147
>   ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
> 
> value changed: 0x00000000802c2058 -> 0x00000000806c2118

-- 
Pavel Begunkov

