Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6609E374C1A
	for <lists+io-uring@lfdr.de>; Thu,  6 May 2021 01:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229599AbhEEXuD (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 5 May 2021 19:50:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229779AbhEEXuC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 5 May 2021 19:50:02 -0400
Received: from mail-pf1-x42d.google.com (mail-pf1-x42d.google.com [IPv6:2607:f8b0:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BD3BC061574
        for <io-uring@vger.kernel.org>; Wed,  5 May 2021 16:49:04 -0700 (PDT)
Received: by mail-pf1-x42d.google.com with SMTP id m11so3502382pfc.11
        for <io-uring@vger.kernel.org>; Wed, 05 May 2021 16:49:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Dlk0fYmdsA4sVPnIEMF0cY2k6ue6IGJM2lhPnSbJsv4=;
        b=TcawMCA+UZ4oNQP/voq1p4cIv3ZgEB1iKQt8HZdRPAjtIlpBftiLFe/vr8deNpT3Qo
         ZLFETzAnjg+zND0/fWjQr/eqjQCwR6JXhv0Q7UbZ1Z7NM6kXDuTgh0JrRsa78aZDVhnt
         NbH2ODOCseSe+8jhYA65nugS+8Pdqe9lVEkwl6jAE7A3fr61jpdEYbMfB0aXlOjup2La
         oal5O/X20CpjXJk7t+UWsXbhNp8ZZi+eJHWJqCWORMtqY83KTjaZrCjkhYPJnZ+SwKMW
         O32Mc1c7UfZbt2tmnQd8dK0CNujMONnRZUrTMpPPjEVrQ2uNWObC9BNKt4WCQIW+bWvO
         C2Aw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Dlk0fYmdsA4sVPnIEMF0cY2k6ue6IGJM2lhPnSbJsv4=;
        b=DzZxkkzM4T8CL556zMBJvJ7locGmM56/+5jV9iQ/2gw+i0tSZUdqMoJDMihMNIouHv
         QNVYMCOvsLo9H0Cyo7DT2Uf8kFEeQuZLQozrvE3BJl6zX+pFuZAlA3LBluvCGdcNiOY7
         xnOPU0N7XUtu8Fliy8eDADDW2h/pNRm861eaCw1ZVb2rwyivj7+cZ7xEJAFddYEYQ5qw
         +T2W+MIdwHCfN0eajhzuwFKH5JSWmmFN3sfpaJcv7Oi07giWU+1vySs/pDrrgNCaCI9j
         jZ7jX9yiBaqVt08yy8/Fg85+Ju5Mw5ID25jMjxD4t8qWgMOczZ7hX4AUX097Xl8CHNgY
         T7bA==
X-Gm-Message-State: AOAM532beqCOCxKuxXPzCSDYcNIYLSjq4AZ2KToAAXKbNwbnsDPxYO9s
        ISih5peifc+rVPJh8/wUVHvYvg==
X-Google-Smtp-Source: ABdhPJzGglzznc3lT7uFV37R1RIE5nGXBKUWPyJlvMjLb5mKeraO5yO14etz4szPLLF6Vx/U8bYj4Q==
X-Received: by 2002:a62:3344:0:b029:24c:735c:4546 with SMTP id z65-20020a6233440000b029024c735c4546mr1404124pfz.1.1620258543399;
        Wed, 05 May 2021 16:49:03 -0700 (PDT)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id 79sm277813pfz.202.2021.05.05.16.49.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 May 2021 16:49:02 -0700 (PDT)
Subject: Re: [PATCH v2] io_thread/x86: setup io_threads more like normal user
 space threads
To:     Thomas Gleixner <tglx@linutronix.de>,
        Stefan Metzmacher <metze@samba.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Andy Lutomirski <luto@kernel.org>, linux-kernel@vger.kernel.org,
        io-uring@vger.kernel.org, x86@kernel.org
References: <20210411152705.2448053-1-metze@samba.org>
 <20210505110310.237537-1-metze@samba.org>
 <df4b116a-3324-87b7-ff40-67d134b4e55c@kernel.dk>
 <878s4soncx.ffs@nanos.tec.linutronix.de>
 <875yzwomvk.ffs@nanos.tec.linutronix.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <ff1f6a6c-9a11-acda-13cc-e67440a85d87@kernel.dk>
Date:   Wed, 5 May 2021 17:49:02 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <875yzwomvk.ffs@nanos.tec.linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/5/21 4:07 PM, Thomas Gleixner wrote:
> On Wed, May 05 2021 at 23:57, Thomas Gleixner wrote:
>> On Wed, May 05 2021 at 15:24, Jens Axboe wrote:
>>> On 5/5/21 5:03 AM, Stefan Metzmacher wrote:
>>>> As io_threads are fully set up USER threads it's clearer to
>>>> separate the code path from the KTHREAD logic.
>>>>
>>>> The only remaining difference to user space threads is that
>>>> io_threads never return to user space again.
>>>> Instead they loop within the given worker function.
>>>>
>>>> The fact that they never return to user space means they
>>>> don't have an user space thread stack. In order to
>>>> indicate that to tools like gdb we reset the stack and instruction
>>>> pointers to 0.
>>>>
>>>> This allows gdb attach to user space processes using io-uring,
>>>> which like means that they have io_threads, without printing worrying
>>>> message like this:
>>>>
>>>>   warning: Selected architecture i386:x86-64 is not compatible with reported target architecture i386
>>>>
>>>>   warning: Architecture rejected target-supplied description
>>>>
>>>> The output will be something like this:
>>>>
>>>>   (gdb) info threads
>>>>     Id   Target Id                  Frame
>>>>   * 1    LWP 4863 "io_uring-cp-for" syscall () at ../sysdeps/unix/sysv/linux/x86_64/syscall.S:38
>>>>     2    LWP 4864 "iou-mgr-4863"    0x0000000000000000 in ?? ()
>>>>     3    LWP 4865 "iou-wrk-4863"    0x0000000000000000 in ?? ()
>>>>   (gdb) thread 3
>>>>   [Switching to thread 3 (LWP 4865)]
>>>>   #0  0x0000000000000000 in ?? ()
>>>>   (gdb) bt
>>>>   #0  0x0000000000000000 in ?? ()
>>>>   Backtrace stopped: Cannot access memory at address 0x0
>>>
>>> I have queued this one up in the io_uring branch, also happy to drop it if
>>> the x86 folks want to take it instead. Let me know!
>>
>> I have no objections, but heck what's the rush here?
>>
>> Waiting a day for the x86 people to respond it not too much asked for
>> right?
> 
> That said, the proper subject line would be:
> 
>   x86/process: Setup io_threads ....
> 
> Aside of that:
> 
>       Reviewed-by: Thomas Gleixner <tglx@linutronix.de>

Thanks, I've added that and modified the subject line to adhere to that
style.

Again, I'm fine with this going through the tip tree, just wanted to
make sure it wasn't lost. So do just let me know, it's head-of-branch
here and easy to chop if need be.

-- 
Jens Axboe

