Return-Path: <io-uring+bounces-5480-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 045489F0EEE
	for <lists+io-uring@lfdr.de>; Fri, 13 Dec 2024 15:17:49 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C178E286FC8
	for <lists+io-uring@lfdr.de>; Fri, 13 Dec 2024 14:17:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4A4381E0DBD;
	Fri, 13 Dec 2024 14:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="c6XRb29w"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 916E81DF75E;
	Fri, 13 Dec 2024 14:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734099465; cv=none; b=FiGtHcrEASN1tNLXrSs2U30OvbYOtccpXdOemYqUlIDc3uBwUFx+E88UdAJbickL7h6XNfVlbYDaNGqfADJPVkxtE7ymvN2lVbJ17hOFE/njmb1Zpa7XFvPZdyvCpiY5fBCtT3gnKMCh1XV4D16UEZoxNe/OQAh11jgip/AXO+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734099465; c=relaxed/simple;
	bh=hgPLAbGHVm6x/VeDTgWewIf9tSqgpmV3lQ2Xew+DZtI=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=dTOUR5zDW09JuMxcyJ9+9MW9JtreCjmc1S/NLBcoj0N63EkUJu+GzM0u5oyqS3skqVgE/uyZsRPvEyw+dBogXbubSzgIa0beWcRZfb+TZaz0Q++k4OSry/t0+1R1V4czGS7BDofjpUrQYnd9W1jAyCbUJmafkqKWVby0frgEGds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=c6XRb29w; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5d122cf8dd1so3100052a12.2;
        Fri, 13 Dec 2024 06:17:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734099462; x=1734704262; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3MBZvoC1WPWLD0xbA3S46c06LLh2E8l3Vj77spglHL8=;
        b=c6XRb29wc6qEVq3jKfSPfPxXBFYv6XlJUr8wY74M6BQSZ0tDnwYMvEUhmR8whaigLC
         Vz5yXnSsWt/GryEpzxqv7QFA5/vdjGMTO8cF5tNhfA82fmD64NtLE0ELGxj7No6vBFD7
         rvUfzhFoq34l+1k+fFYaou/XwmLZRNYS85aA/NSIwEnJO2q0SR3itWh2xdniU4bFsTB6
         9vG17huMdci9HqqdZhtx0ljEx8+V8MOWrd4hYt45xPXhmy4QUkZkJ2c6N+cchUYQwrQa
         IgXdqQuvER8C/v6k3hFNJulM0kgd0dzh1g/NZK8z09D8dMY3Da26LqMtRyEynfx95cQi
         Heeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734099462; x=1734704262;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3MBZvoC1WPWLD0xbA3S46c06LLh2E8l3Vj77spglHL8=;
        b=IOmdNOUg8OU+5o16/ctKRRbqD1DUVOLoECBrsx7Mq6hz8jPMBjiEoU5i39Jkst2oLg
         OkGJRqL/P7GsPwbAU6W6NM4s0gl/D1slLyYGbol4SSAW3aMQXbePtH/qlbFKI9uegGmK
         X6PpDRtJTsYFyEylSCw/stf2ke+jzeonSEPwgacnnMUFkG1xIUdgzjzqki8VJG29RfDe
         cVM5Bt6LnC5KFc8/oFRBYmd51/AQMxJNkXi1rfjKfreFYspSf0aUkMpDK0xWWtcb7Ir+
         xatAFHbY3A16imzHxkImASuJi66OBGgO5RUOFelJqthU5D9JxSWjrmV3+UCsA05Mb2Fl
         Y40A==
X-Forwarded-Encrypted: i=1; AJvYcCV9p2o5Rg7cx5H/yUjAyunS/MJLFxeXOnRQMC4VXhGY8hS9RJGx8p4uwkMI2Hx1pjv/sC8Wx+WN7kFnjgo3@vger.kernel.org, AJvYcCVG1qrpc4gJ0+ioDWhzY3AvKnwSJUIVXK3fzFHXa/rditA4HC+0YRc5+EQJSeTnuePSziBEweqPlg==@vger.kernel.org
X-Gm-Message-State: AOJu0YzQMbQYU0qN5NCT1faMJgKbyrM6+teW3a4MH+QCz22PbwBcgIm4
	/dvbcolXIMW4bZA7vOuKkZAScQYnzI/bb0lkqrbKiTfQb88awc7ZHpHLgQ==
X-Gm-Gg: ASbGncvnQszXIq+E/JZ0o5l5mRGH2aJLenXhLXZz2LUzmsesRSvzQys2ugrt00pIffH
	7GwY87BnBIdYBi+A+CzsTXF/GSGM846FF5VxJP2nNVX2iVTVsIxypPr+t8YWWyQUQUP93DGeO/m
	QWQiZ5lL7ac8py4SCWoDUAWa8TRaeiP9OkpDtsuj17RPR4gP8dnEPbx1yVaoApA4CqNrlhhjgWj
	MyO3KWc2OZybLWmJ+4ToKQO9PM/YCyIRbSADDYD/nu+HJYD40TNX3FShuBwcnj2rc4=
X-Google-Smtp-Source: AGHT+IE0SZrmqXTd9+QeU17zhdj8dc8FYzSyUK1EMMBJyEUKFTDCIoXFZwv0X8j213p34U6+RJuvUg==
X-Received: by 2002:a05:6402:518a:b0:5d4:1ac2:271b with SMTP id 4fb4d7f45d1cf-5d63c3074e8mr2420180a12.11.1734099461532;
        Fri, 13 Dec 2024 06:17:41 -0800 (PST)
Received: from [192.168.42.94] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d14b608c8dsm11517294a12.48.2024.12.13.06.17.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Dec 2024 06:17:41 -0800 (PST)
Message-ID: <aa741d8a-ffab-4e4b-94bb-00c4188d888e@gmail.com>
Date: Fri, 13 Dec 2024 14:18:28 +0000
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [io-uring?] KCSAN: data-race in io_recv /
 io_wq_free_work
To: syzbot <syzbot+a697a4754324488bacd7@syzkaller.appspotmail.com>,
 axboe@kernel.dk, io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <675c165b.050a0220.17d782.000a.GAE@google.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <675c165b.050a0220.17d782.000a.GAE@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/13/24 11:11, syzbot wrote:
> ==================================================================
> BUG: KCSAN: data-race in io_recv / io_wq_free_work
> 
> write to 0xffff88814248b848 of 8 bytes by task 22395 on cpu 1:
>   io_recv+0x661/0xa70
>   io_issue_sqe+0x150/0xc10 io_uring/io_uring.c:1736
>   io_poll_issue+0x1a/0x20 io_uring/io_uring.c:1767
>   io_poll_check_events io_uring/poll.c:289 [inline]
>   io_poll_task_func+0x205/0x7c0 io_uring/poll.c:316
>   io_handle_tw_list+0xe3/0x200 io_uring/io_uring.c:1053
>   tctx_task_work_run+0x6e/0x1c0 io_uring/io_uring.c:1117
>   tctx_task_work+0x40/0x80 io_uring/io_uring.c:1135
>   task_work_run+0x13a/0x1a0 kernel/task_work.c:239
>   io_run_task_work+0x1b1/0x200 io_uring/io_uring.h:343
>   io_cqring_wait io_uring/io_uring.c:2594 [inline]
>   __do_sys_io_uring_enter io_uring/io_uring.c:3434 [inline]
>   __se_sys_io_uring_enter+0x14f5/0x1ba0 io_uring/io_uring.c:3325
>   __x64_sys_io_uring_enter+0x78/0x90 io_uring/io_uring.c:3325
>   x64_sys_call+0xb5e/0x2dc0 arch/x86/include/generated/asm/syscalls_64.h:427
>   do_syscall_x64 arch/x86/entry/common.c:52 [inline]
>   do_syscall_64+0xc9/0x1c0 arch/x86/entry/common.c:83
>   entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> read to 0xffff88814248b848 of 8 bytes by task 22396 on cpu 0:
>   req_ref_put_and_test io_uring/refs.h:22 [inline]
>   io_wq_free_work+0x24/0x1b0 io_uring/io_uring.c:1776
>   io_worker_handle_work+0x4cb/0x9d0 io_uring/io-wq.c:604
>   io_wq_worker+0x286/0x820 io_uring/io-wq.c:655
>   ret_from_fork+0x4b/0x60 arch/x86/kernel/process.c:147
>   ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:244
> 
> value changed: 0x0000000085584038 -> 0x0000000085184

IIUC what that it, it's known and mild. Writes to flags are
synchronised, for concurrent reads we make sure the interesting
bits are set in advance. i.e. only a problem if compiler decides
to mask a bit while modifying an unrelated bit or so. We probably
need WRITE_ONCE or splitting flags into two sets.

-- 
Pavel Begunkov


