Return-Path: <io-uring+bounces-1576-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF4ED8A6CBD
	for <lists+io-uring@lfdr.de>; Tue, 16 Apr 2024 15:45:39 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 65A3928711D
	for <lists+io-uring@lfdr.de>; Tue, 16 Apr 2024 13:45:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A943212C49A;
	Tue, 16 Apr 2024 13:45:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fQbQt36A"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBA6F12882C;
	Tue, 16 Apr 2024 13:45:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713275126; cv=none; b=uoRRl+dM45HKgPWY92rzCFHXNEX9KpJlM/haltKq0s78iy8/iHDnJxOFE1aRTxALJ4k8pN3K9Qk0TzIUNnmwjaSdLtS1obIByfYW63ZorTdRjTMPp9xnPP8ecHgVLtd1XAPEfOo53lpu/o/pNtRJHDxlBpoRCocIhgv9y99ootI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713275126; c=relaxed/simple;
	bh=kYocEGywmtTwPJf+Qkz381RMvPhf2erxHI7aJqKhN5M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gpbHtvGKtxKTMuLxdBX/XqsXmQkENnUgBOyy/xDVmDsRxXuthbi8wB57Wp/hRSVo83h+kKfF8INWrc2w6fVka5h9sL/E/oZuYHaaNI6TLsqJSCh610E9fNIqZMTA/juG3bBTWAEVp8fWqugFubT0Ni/gzDVWFJ49vpz/YfHpLAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fQbQt36A; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-56e48d0a632so6945831a12.2;
        Tue, 16 Apr 2024 06:45:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1713275123; x=1713879923; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UCjAE4+yeEU8FFvGHGn8JZpMlzpCUOole8marB16qj0=;
        b=fQbQt36AwmJZNAMI+yn9nzQFK0AI91HlZTamiM9vyx77kKGh/1InFxjeNbyINFG5dk
         Aw158cA8P+0BGYJvMtea79QzT2+JVZIrgbGgOLsBZOHt488+Drt+c0zp6OwoMhTDKYoU
         PWc2LqHA+vijZadvG1gH1vN6f+ogd/JHr3aLbE7Sbdtzp1iR9BXFdyAMP5phiBSfx1Uy
         9TcH6QiVXGjcQisOQ54L+D8gZviyS5aPlCsWJcbJVKDqP1wVlUu0IxOhG9fuLu7g46+I
         /RDEtq9kdURE6uTGgiAteiC3PucYtPEz99blEOa6oDvTNC5HIl7SWrmGIMMi9z5LDgoj
         +WAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713275123; x=1713879923;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UCjAE4+yeEU8FFvGHGn8JZpMlzpCUOole8marB16qj0=;
        b=EkC8E09DX3viYczNrQ/9ZA2+LqHdE6Tpl5QiOrx/POXw+RdHdK1GezDmxz91JgMCZg
         se/rXaaryw2mSvlQl/I23iW+9TJh1xkkM837CMF0AtragAUkrOQQMlRkJmCG+Rpwx1Vk
         uk01y+9nJafe8ZRa9NLSEDsLQcn68H7Squ/+M4Nj5+Y54cAZ4RY717oWjrbfCqd9oVkL
         J0HECzfJGGzgfWHKMquy1NzhfcBpOrkH9KN/ra3hlWXyrtNM/cmf4csWv7Neqdx6T5yC
         RZ/JeN8ppFxAh/U41k8RvY9ihT04jFf9nQvbgXWf6Goyjr9HYt97pYHnPWuq85yeHFtx
         OLFQ==
X-Forwarded-Encrypted: i=1; AJvYcCURkSu/EOH8yz/xSWaT46DGRTS+VZdBu7Y86khVfrmWZ5XOBmz/n1TilYbvqFlDFyGjNbdm5yYr3G62WGtAq+cN9GnROJ0=
X-Gm-Message-State: AOJu0Yz8toqbzPh54H/yyQTgRzzNWxu8JLx2WpHhB8rIOhriH6bySGLt
	6doEU2E4kxti0Kpg5XUG8ToYCNZLtgD5TJrmWTk6S5qyh6yK/qC25whJ1A==
X-Google-Smtp-Source: AGHT+IHrOvvDZoOCsjOFu4kDF/H17lcRWDqvFXpa8ftGWAH8G6+LcnjQ1oXIcI493rrIDGfysFvNSg==
X-Received: by 2002:a17:907:3e10:b0:a47:4bd6:9857 with SMTP id hp16-20020a1709073e1000b00a474bd69857mr12809370ejc.64.1713275123130;
        Tue, 16 Apr 2024 06:45:23 -0700 (PDT)
Received: from [192.168.42.125] ([163.114.131.193])
        by smtp.gmail.com with ESMTPSA id jw10-20020a170906e94a00b00a523be5897bsm5480304ejb.103.2024.04.16.06.45.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 16 Apr 2024 06:45:22 -0700 (PDT)
Message-ID: <15cf9f3c-efd7-40ce-8613-a113439c6fb6@gmail.com>
Date: Tue, 16 Apr 2024 14:45:29 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: io_uring: worker thread NULL dereference during openat op
To: Paul Moore <paul@paul-moore.com>, Dan Clash <daclash@linux.microsoft.com>
Cc: io-uring@vger.kernel.org, audit@vger.kernel.org,
 Jens Axboe <axboe@kernel.dk>
References: <0cea7b29-5c31-409a-a8d3-de53c7ce40eb@linux.microsoft.com>
 <CAHC9VhTWbFu8vbapWG5ndt=r-y5SkSSe=AA3YEufreYtjPMrUw@mail.gmail.com>
Content-Language: en-US
From: Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <CAHC9VhTWbFu8vbapWG5ndt=r-y5SkSSe=AA3YEufreYtjPMrUw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit



On 4/16/24 04:29, Paul Moore wrote:
> On Mon, Apr 15, 2024 at 7:26 PM Dan Clash <daclash@linux.microsoft.com> wrote:
>>
>> Below is a test program that causes multiple io_uring worker threads to
>> hit a NULL dereference while executing openat ops.
>>
>> The test program hangs forever in a D state.  The test program can be
>> run again after the NULL dereferences.  However, there are long delays
>> at reboot time because the io_uring_cancel() during do_exit() attempts
>> to wake the worker threads.
>>
>> The test program is single threaded but it queues multiple openat and
>> close ops with IOSQE_ASYNC set before waiting for completions.
>>
>> I collected trace with /sys/kernel/tracing/events/io_uring/enable
>> enabled if that is helpful.
>>
>> The test program reproduces similar problems in the following releases.
>>
>> mainline v6.9-rc3
>> stable 6.8.5
>> Ubuntu 6.5.0-1018-azure
>>
>> The test program does not reproduce the problem in Ubuntu
>> 5.15.0-1052-azure, which does not have the io_uring audit changes.
>>
>> The following is the first io_uring worker thread backtrace in the repro
>> against v6.9-rc3.
>>
>> BUG: kernel NULL pointer dereference, address: 0000000000000000
>> #PF: supervisor read access in kernel mode
>> #PF: error_code(0x0000) - not-present page
>> PGD 0 P4D 0
>> Oops: 0000 [#1] SMP PTI
>> CPU: 0 PID: 4628 Comm: iou-wrk-4605 Not tainted 6.9.0-rc3 #2
>> Hardware name: Microsoft Corporation Virtual Machine/Virtual Machine,
>> BIOS Hyper-V UEFI Release v4.1 11/28/2023
>> RIP: 0010:strlen (lib/string.c:402)
>> Call Trace:
>>    <TASK>
>> ? show_regs (arch/x86/kernel/dumpstack.c:479)
>> ? __die (arch/x86/kernel/dumpstack.c:421 arch/x86/kernel/dumpstack.c:434)
>> ? page_fault_oops (arch/x86/mm/fault.c:713)
>> ? do_user_addr_fault (arch/x86/mm/fault.c:1261)
>> ? exc_page_fault (./arch/x86/include/asm/irqflags.h:37
>> ./arch/x86/include/asm/irqflags.h:72 arch/x86/mm/fault.c:1513
>> arch/x86/mm/fault.c:1563)
>> ? asm_exc_page_fault (./arch/x86/include/asm/idtentry.h:623)
>> ? __pfx_strlen (lib/string.c:402)
>> ? parent_len (kernel/auditfilter.c:1284).
>> __audit_inode (kernel/auditsc.c:2381 (discriminator 4))
> 
> Thanks for the well documented bug report!
> 
> That's interesting, it looks like audit_inode() is potentially being
> passed a filename struct with a NULL name field (filename::name ==
> NULL).  Given the IOSQE_ASYNC and what looks like io_uring calling
> getname() from within the __io_openat_prep() function, I suspect the
> issue is that we aren't associating the filename information we
> collect in getname() with the proper audit_context().  In other words,
> we do the getname() in one context, and then the actual open operation
> in another, and the audit filename info is lost in the switch.
> 
> I think this is related to another issue that Jens and I have been
> discussing relating to connect() and sockaddrs.  We had been hoping
> that the issue we were seeing with sockaddrs was just a special case
> with connect, but it doesn't look like that is the case.
> 
> I'm going to be a bit busy this week with conferences, but given the
> previous discussions with Jens as well as this new issue, I suspect
> that we are going to need to do some work to support creation of a
> thin, or lazily setup, audit_context that we can initialize in the
> io_uring prep routines for use by getname(), move_addr_to_kernel(),
> etc., store in the io_kiocb struct, and then fully setup in
> audit_uring_entry().

I'd prefer not to leak that much into the io_uring's hot path. I
don't understand specifics of the problem, but let me throw
some ideas:

1) Each io_uring request has a reference to the task it was
submitted from, i.e. req->task, can you use the context from
the submitter task? E.g.

audit_ctx = req->task->audit_context

io_uring explicitly lists all tasks using it, and you can easily
hook in there and initialise audit so that req->ctx->audit_context
is always set.

2) Can we initialise audit for each io-wq task when we create
them? We can also try to share audit ctx b/w iowq tasks and
the task they were created for.

  
>> ? link_path_walk.part.0.constprop.0 (fs/namei.c:2324)
>> path_openat (fs/namei.c:3550 fs/namei.c:3796)
>> do_filp_open (fs/namei.c:3826)
>> ? alloc_fd (./arch/x86/include/asm/paravirt.h:589 (discriminator 10)
>> ./arch/x86/include/asm/qspinlock.h:57 (discriminator 10)
>> ./include/linux/spinlock.h:204 (discriminator 10)
>> ./include/linux/spinlock_api_smp.h:142 (discriminator 10)
>> ./include/linux/spinlock.h:391 (discriminator 10) fs/file.c:553
>> (discriminator 10))
>> io_openat2 (io_uring/openclose.c:140)
>> io_openat (io_uring/openclose.c:178)
>> io_issue_sqe (io_uring/io_uring.c:1897)
>> io_wq_submit_work (io_uring/io_uring.c:2006)
>> io_worker_handle_work (io_uring/io-wq.c:540 io_uring/io-wq.c:597)
>> io_wq_worker (io_uring/io-wq.c:258 io_uring/io-wq.c:648)
>> ? __pfx_io_wq_worker (io_uring/io-wq.c:627)
>> ? raw_spin_rq_unlock (./arch/x86/include/asm/paravirt.h:589
>> ./arch/x86/include/asm/qspinlock.h:57 ./include/linux/spinlock.h:204
>> ./include/linux/spinlock_api_smp.h:142 kernel/sched/core.c:603)
>> ? finish_task_switch.isra.0 (./arch/x86/include/asm/irqflags.h:42
>> ./arch/x86/include/asm/irqflags.h:77 kernel/sched/sched.h:1397
>> kernel/sched/core.c:5163 kernel/sched/core.c:5281)
>> ? __pfx_io_wq_worker (io_uring/io-wq.c:627)
>> ret_from_fork (arch/x86/kernel/process.c:156)
>> ? __pfx_io_wq_worker (io_uring/io-wq.c:627)
>> ret_from_fork_asm (arch/x86/entry/entry_64.S:256)
> 

-- 
Pavel Begunkov

